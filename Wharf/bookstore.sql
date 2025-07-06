CREATE DATABASE Bookstore;
USE Bookstore

DROP TABLE IF EXISTS book;
create table book(
  `book_id` int(11) auto_increment primary key not null,
  `title` varchar(128) unique key not null,
  `author` varchar(45) not null,
  `price` float not null
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

INSERT INTO book (title, author, price) values ('Thinking in Java', 'Bruce Eckel', '25.69');
CREATE USER 'bsapp'@'%' identified by 'P@ssw0rd';
GRANT ALL PRIVILEGES ON Bookstore.* to 'bsapp'@'%';
FLUSH PRIVILEGES;
