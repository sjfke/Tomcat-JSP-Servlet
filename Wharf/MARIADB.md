# Creating MariaDB Database

## Create the ``docker volume``

```powershell
PS C:\Users\sjfke> docker volume ls                                                      # jsp_bookstoredata volume exists
PS C:\Users\sjfke> docker volume create jsp-bookstore-data                               # create jsp-bookstore-data volume if DOES NOT exist
```

## Start the ``dbs`` and ``adminer`` containers

```powershell
# Use either, but not both
PS C:\Users\sjfke> docker compose --env-file env/mariadb -f .\compose-mariadb.yaml up -d # adminer, mariadb using jsp-net
PS C:\Users\sjfke> docker compose -f .\compose-mariadb-simple.yaml up -d                 # adminer, mariadb using jsp-net
```

> ### Notice 
> * `compose-mariadb-simple.yaml` hard-codes the DB root password
>
> * `compose-mariadb.yaml` avoids hard-coding the DB root password by using environment variables
>   * `--env-file env\mariadb` provides MariaDB root password
>
>   * `--env-file env\adminer` overrides Adminer defaults

## Create the `Bookstore.book` table using an SQL script

```powershell
# Copy the file to the container
PS C:\Users\sjfke> docker cp .\Wharf\bookstore.sql tomcat-jsp-servlet-dbs-1:/tmp/

# Open an interactive shell
PS C:\Users\sjfke> docker exec -it tomcat-jsp-servlet-dbs-1 bash  # container interactive shell (alt. sh)
```

From the interactive shell on ``tomcat-jsp-servlet-dbs-1``

```bash
# mariadb -u root -p
Enter password:

MariaDB [(none)]> source /tmp/bookstore.sql
MariaDB [(none)]> use Bookstore
MariaDB [Bookstore]> select * from book;
+---------+------------------+-------------+-------+
| book_id | title            | author      | price |
+---------+------------------+-------------+-------+
|      11 | Thinking in Java | Bruce Eckel | 25.69 |
+---------+------------------+-------------+-------+
1 row in set (0.001 sec)

MariaDB [Bookstore]> show grants for 'bsapp'@'%';
+------------------------------------------------------------------------------------------------------+
| Grants for bsapp@%                                                                                   |
+------------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `bsapp`@`%` IDENTIFIED BY PASSWORD '*8232A1298A49F710DBEE0B330C42EEC825D4190A' |
| GRANT ALL PRIVILEGES ON `Bookstore`.* TO `bsapp`@`%`                                                 |
+------------------------------------------------------------------------------------------------------+
2 rows in set (0.000 sec)

exit;
```

## Manually create the `Bookstore.book` table

```powershell
# Open an interactive shell
PS C:\Users\sjfke> docker exec -it tomcat-jsp-servlet-dbs-1 bash  # container interactive shell (alt. sh)
```
Execute the following commands

```sql
# mariadb -u root -p
Enter password:

MariaDB [(none)]> create database Bookstore;
MariaDB [(none)]> use Bookstore

MariaDB [Bookstore]> drop table if exists book;
MariaDB [Bookstore]> create table book(
  `book_id` int(11) auto_increment primary key not null,
  `title` varchar(128) unique key not null,
  `author` varchar(45) not null,
  `price` float not null
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

MariaDB [Bookstore]> insert into book (title, author, price) values ('Thinking in Java', 'Bruce Eckel', '25.69');
MariaDB [Bookstore]> select * from book;
MariaDB [Bookstore]> exit;
```

## Create an application account and grant access

Execute the following commands

```sql
# mariadb -u root -p
Enter password:
MariaDB [(none)]> use Bookstore;
MariaDB [Bookstore]> create user 'bsapp'@'%' identified by 'P@ssw0rd';
MariaDB [Bookstore]> grant all privileges on Bookstore.* to 'bsapp'@'%';
MariaDB [Bookstore]> flush privileges;
MariaDB [Bookstore]> show grants for 'bsapp'@'%';
MariaDB [Bookstore]> exit;
```

> ### Notice
>
> * The *bsapp* account is not IP access restricted, i.e. not 'bsapp'@'localhost'.
> * *Docker* will allocate a random RFC-1918 IP to the database when it is deployed.

## Verify application account access

```sql
# mariadb -u bsapp -p Bookstore
Enter password:
MariaDB [Bookstore]> select * from book;
MariaDB [Bookstore]> exit;
```

## Using *Adminer* Web Interface

All of the above steps can be done and checked using through ``adminer`` container.

```yaml
System: MariaDB
Server: dbs
Username: root
Password: r00tpa55
Database: <blank>
```

## Stop the ``dbs`` and ``adminer`` containers

```powershell
PS C:\Users\sjfke> docker compose down
```