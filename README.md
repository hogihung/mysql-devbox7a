# README

Need to do a proper README but for now, need to jot this down:


Before running 'vagrant up' be sure to review/complete the following:

1.  Vagrantfile, adjust memory settings if needed (see mem variable or use Environment Setting [provide example])  export VAGRANT_MEMORY=xxxxx

2.  Edit the provisioning/set_mysql_root_pw.sh file and adjust NEW_PASS if you do not want to use the provided password.



```
# NOTE:  I noticed an issue when provisioning once where the mysql pw script didn't work properly.
#        It looked like maybe there were some special characters in the generated password.
#        Keep an eye out for this!
```


# Post Vagrant Up

After you have executed 'vagrant up' we want to log in and verify our tools have
been installed:

```
➜  devbox7-a vagrant ssh
----------------------------------------------------------------
  CentOS Linux 7.2 - API DEV BOX              built 2017-07-14
----------------------------------------------------------------
[vagrant@devbox7-a ~]$ 

[vagrant@devbox7-a ~]$ rvm -v
rvm 1.29.2 (latest) by Michal Papis, Piotr Kuczynski, Wayne E. Seguin [https://rvm.io/]
[vagrant@devbox7-a ~]$

[vagrant@devbox7-b ~]$ ruby -v
ruby 2.4.0p0 (2016-12-24 revision 57164) [x86_64-linux]
[vagrant@devbox7-b ~]$

[vagrant@devbox7-a ~]$ node -v
v7.10.1
[vagrant@devbox7-a ~]$

[vagrant@devbox7-a ~]$ mysql --version
mysql  Ver 14.14 Distrib 5.7.18, for Linux (x86_64) using  EditLine wrapper
[vagrant@devbox7-a ~]$

[vagrant@devbox7-a ~]$ sudo systemctl status mysqld
● mysqld.service - MySQL Server
   Loaded: loaded (/usr/lib/systemd/system/mysqld.service; enabled; vendor preset: disabled)
   Active: active (running) since Mon 2017-07-17 15:58:19 UTC; 2min 3s ago
     Docs: man:mysqld(8)
           http://dev.mysql.com/doc/refman/en/using-systemd.html
  Process: 908 ExecStart=/usr/sbin/mysqld --daemonize --pid-file=/var/run/mysqld/mysqld.pid $MYSQLD_OPTS (code=exited, status=0/SUCCESS)
  Process: 872 ExecStartPre=/usr/bin/mysqld_pre_systemd (code=exited, status=0/SUCCESS)
 Main PID: 921 (mysqld)
   CGroup: /system.slice/mysqld.service
           └─921 /usr/sbin/mysqld --daemonize --pid-file=/var/run/mysqld/mysqld.pid

Jul 17 15:58:18 devbox7-a systemd[1]: Starting MySQL Server...
Jul 17 15:58:19 devbox7-a systemd[1]: Started MySQL Server.
[vagrant@devbox7-a ~]$

[vagrant@devbox7-a ~]$ elixir -v
Erlang/OTP 20 [erts-9.0] [source] [64-bit] [smp:1:1] [ds:1:1:10] [async-threads:10] [hipe] [kernel-poll:false]

Elixir 1.4.5
[vagrant@devbox7-a ~]$ 

[vagrant@devbox7-a ~]$ erl -v
Erlang/OTP 20 [erts-9.0] [source] [64-bit] [smp:1:1] [ds:1:1:10] [async-threads:10] [hipe] [kernel-poll:false]

Eshell V9.0  (abort with ^G)
1>
BREAK: (a)bort (c)ontinue (p)roc info (i)nfo (l)oaded
       (v)ersion (k)ill (D)b-tables (d)istribution
^C[vagrant@devbox7-a ~]$ 

[vagrant@devbox7-a ~]$ mix -h
mix                   # Runs the default task (current: "mix run")
mix app.start         # Starts all registered apps

{--snip--}

# We will focus on confirming the next two are present for Phoenix
mix phoenix.new       # Creates a new Phoenix v1.2.4 application
mix phx.new           # Creates a new Phoenix v1.3.0-rc.2 application using the experimental generators

{--snip--}

mix test              # Runs a project's tests
mix xref              # Performs cross reference checks
iex -S mix            # Starts IEx and runs the default task
[vagrant@devbox7-a ~]$ 


[vagrant@devbox7-a ~]$ mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 6
Server version: 5.7.18 MySQL Community Server (GPL)

Copyright (c) 2000, 2017, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

Now that we have confirmed that our basic setup is up and running successfully,
the next step is to enable replication between the master (devbox7-a) and the
slave (devbox7-b).


## Setting Up MySQL Replication (Master)

Master (devbox7-a): 192.168.70.10
Slave  (devbox7-b): 192.168.70.11

Replication User:   replicant 
Replication Pass:   b0rgs#Human$
Replication Host:   devbox7-b.localdomain 


Now we need to create the replication user as defined above:

```
# Anyway to automate this?  Would need to use expect.
mysql -u root -p -e "CREATE USER 'replicant'@'192.168.70.11' IDENTIFIED BY 'b0rgs#Human$';"
mysql -u root -p -e "GRANT REPLICATION SLAVE ON *.* TO 'replicant'@'192.168.70.11';"

# Example:
[vagrant@devbox7-a ~]$ mysql -u root -p -e "CREATE USER 'replicant'@'192.168.70.11' IDENTIFIED BY 'b0rgs#Human$';"
Enter password:
[vagrant@devbox7-a ~]$ mysql -u root -p -e "GRANT REPLICATION SLAVE ON *.* TO 'replicant'@'192.168.70.11';"
Enter password:
[vagrant@devbox7-a ~]$

```


Next we need to log in to mysql as root and perform execute a few commands:


```
mysql -u root -p

# Lock the master
FLUSH TABLES WITH READ LOCK;

# Record master replication log position
SHOW MASTER STATUS;   # Note the File and Position values

# Example:
mysql> FLUSH TABLES WITH READ LOCK;
Query OK, 0 rows affected (0.00 sec)

mysql> SHOW MASTER STATUS;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000001 |     1185 |              |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)

mysql>
```


Exit out of mysql.  Next we will dump the database using the mysqldump command


```
mysqldump -u root -p --all-databases --master-data > dbdump.sql

# Example:
[vagrant@devbox7-a ~]$ mysqldump -u root -p --all-databases --master-data > dbdump.sql
Enter password:
[vagrant@devbox7-a ~]$

[vagrant@devbox7-a ~]$ ls -la dbdump.sql
-rw-rw-r--. 1 vagrant vagrant 776846 Jul 18 02:53 dbdump.sql
[vagrant@devbox7-a ~]$
```


Log back in as root and unlock the tables


```
mysql -u root -p
UNLOCK TABLES;

# Example:
mysql> UNLOCK TABLES;
Query OK, 0 rows affected (0.00 sec)

mysql>
```


Now we need to copy that dump file over to our slave


```
scp dbdump.sql 192.168.70.11:/tmp

# Example:
[vagrant@devbox7-a ~]$ scp dbdump.sql 192.168.70.11:/tmp
The authenticity of host '192.168.70.11 (192.168.70.11)' can't be established.
ECDSA key fingerprint is 3a:88:05:f6:ba:6c:77:0f:cb:0a:d7:47:b5:e5:ad:d5.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.70.11' (ECDSA) to the list of known hosts.
vagrant@192.168.70.11's password:
dbdump.sql                                                                                                                                         100%  759KB 758.6KB/s   00:00
[vagrant@devbox7-a ~]$
```


We are now done with setting up the master.  Please review the README.md file for
the slave computer, devbox7-b.  You should be able to jump down to the section
titled:  "Setting Up MySQL Replication (Slave).


