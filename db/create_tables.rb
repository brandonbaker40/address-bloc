require 'sqlite3'
require 'pg'

#db = SQLite3::Database.new "db/address_bloc.sqlite"
db = Postgres::Database.new "db/address_bloc.db"


####### SQLite3 ########

db.execute("DROP TABLE IF EXISTS address_book;");
db.execute("DROP TABLE IF EXISTS entry;");

db.execute <<-SQL
    CREATE TABLE address_book (
      id INTEGER PRIMARY KEY,
      name VARCHAR(30),
    );
  SQL

db.execute <<-SQL
    CREATE TABLE entry (
      id INTEGER PRIMARY KEY,
      address_book_id INTEGER,
      name VARCHAR(30),
      phone_number VARCHAR(30),
      email VARCHAR(30),
      FOREIGN KEY (address_book_id) REFERENCES address_book(id)
    );
  SQL

  ######## Postgres #########

  db.exec("DROP TABLE IF EXISTS address_book;");
  db.exec("DROP TABLE IF EXISTS entry;");

  db.exec <<-SQL
    CREATE TABLE address_book (
      id INT PRIMARY KEY NOT NULL,
      name TEXT NOT NULL
    );
  SQL

  db.exec <<-SQL
    CREATE TABLE entry (
      id INT PRIMARY KEY NOT NULL,
      address_book_id INT NOT NULL,
      name CHAR(30),
      phone_number CHAR(30),
      email CHAR(30),
      FOREIGN KEY (address_book_id) REFERENCES address_book(id)
    );
  SQL
