
CREATE DATABASe book;
CREATE TABLE Author (
Author_ID INT PRIMARY KEY ,
Author_Name VARCHAR(50),
Country VARCHAR(30)
);

CREATE TABLE Publisher(
Publisher_ID INT PRIMARY KEY, Publisher_Name VARCHAR(50));

CREATE TABLE Book(
Book_ID INT PRIMARY KEY, 
Title VARCHAR(50),
Author_ID INT, 
Publisher_ID INT,
Price DECIMAL(6,2),
FOREIGN KEY (Author_ID) REFERENCES Author(Author_ID),
FOREIGN KEY (Publisher_ID) REFERENCES Publisher(Publisher_ID)
);
Insert into Author VALUES (1, 'Chetan Bhagat', 'India '), (2,'I K Rowling', 'UK');
INSERT INTO Publisher VALUES
(101, 'Penguin'),
(102, 'Bloomsbury');
Insert into Book VALUES
(1001, 'Half Girlfriend', 1, 101, 350.00), (1002, 'Harry Potter', 2, 102, 500.00);
SELECT * FROM Author;
SELECT * FROM Publisher;SELECT * FROM Book;