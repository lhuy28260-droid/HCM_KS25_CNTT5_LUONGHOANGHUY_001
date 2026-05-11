DROP DATABASE IF EXISTS BookManagement;
CREATE DATABASE BookManagement;
USE BookManagement;

CREATE TABLE Users(
	user_id VARCHAR(5) PRIMARY KEY NOT NULL,
    full_name VARCHAR(100)  NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL UNIQUE
);

CREATE TABLE Categories(
	category_id VARCHAR(5) PRIMARY KEY  NOT NULL,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Book(
	book_id VARCHAR(5) PRIMARY KEY NOT NULL ,
    title  VARCHAR(100) NOT NULL UNIQUE,
    category_id VARCHAR(5) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK( price > 0 ),
    stock INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE CASCADE
);

CREATE TABLE Borrows(
	borrow_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    user_id VARCHAR(5) NOT NULL ,
    book_id VARCHAR(5) NOT NULL,
	status VARCHAR(20) NOT NULL,
    borrow_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE ,
	FOREIGN KEY (book_id) REFERENCES Book(book_id) ON DELETE CASCADE
);

INSERT INTO Users(user_id, full_name ,email , phone)
VALUES ('U01' , 'Nguyễn Văn An' , 'a@m.com' , '0912345678'),
		('U02','Trần Thị Bích','b@m.com','0923456789'),
        ('U03','Lê Hoàng Minh','mi@m.com','0934567890'),
        ('U04','Phạm Thu Hà','h@m.com','0945678901'),
        ('U05','Võ Quốc Huy','hu@gmail.com','0956789012');

INSERT INTO Categories(category_id,category_name)
VALUES ('C01', 'IT') ,
		('C02', 'Literature'),
        ('C03', 'Science'),
        ('C04', 'History');
        
INSERT INTO Book(book_id,title,category_id,price,stock)
VALUES ('B01','Clean Code', 'C01',250000.00,10),
		('B02', 'Design Pattern' , 'C01',300000.00,5),
        ('B03','Tat Den','C02', 50000.00 , 20),
        ('B04','Universe','C03',150000.00,8),
        ('B05','Sapiens','C04',200000.00,15);
        
INSERT INTO Borrows(borrow_id , user_id , book_id , borrow_date , status)
VALUES (1 , 'U01' , 'B01' , '2025-10-01' , 'Borrowing'),
		(2 , 'U02' , 'B03' , '2025-10-02','Returned'),
        (3,'U03', 'B02' , '2025-10-03' , 'Returned'),
        (4,'U04','B05','2025-10-04','Lost'),
        (5,'U05','B01','2025-10-05','Borrowing');
        

UPDATE Book SET stock = stock + 10,
				price = price * ( price + 0.05 )
WHERE book_id = 'B05';

UPDATE Users SET phone = '0999999999' WHERE user_id = 'U03';

-- borrows có 1 user - N phiếu 
-- 1 book_id - N phiếu 

Delete b FROM Borrows b
INNER JOIN Users u ON b.user_id = u.user_id
INNER JOIN Book bo ON b.book_id = bo.book_id
WHERE status = 'Returned' AND borrow_date < '2025-10-03';

-- PHẦN 2 CÂU 6
SELECT book_id , title , price FROM Book 
WHERE  price = 100.000 between  250.000 AND (stock >0);

-- PHẦN 2 CÂU 7 
SELECT full_name , email FROM Users
WHERE full_name LIKE '%Nguyen%';
-- Phần 2 câu 8
SELECT borrow_id , user_id , borrow_date FROM Borrows
ORDER BY borrow_date DESC;

-- Phan 2 câu 9
SELECT book_id , title , price FROM Book 
GROUP BY book_id , title
HAving MAX(price) 
ORDER BY price DESC LIMIT 3;

-- PHan 2 câu 10
SELECT title , stock FROM Book 
Group BY title , stock
limit 2 offset 2;

-- Phan 3 câu 1
SELECT b.borrow_id , u.full_name , bo.title , b.borrow_date ,b.status
FROM Borrows b 
INNER JOIN Users u ON b.user_id = u.user_id
INNER JOIN Book bo ON b.book_id = bo.book_id
WHERE b.status = 'Borrowing';
 -- Phan 3 câu 2
SELECT ca.category_id , ca.category_name , bo.title 
FROM Categories ca 
LEFT JOIN Book bo ON ca.category_id = bo.category_id;


-- PHẦN 3 CÂU 13
SELECT b.status , 
		SUM(borrow_id) AS Total_Borrows FROM Borrows b 
GROUP BY b.status;
-- phẦN 3 CÂU 14
SELECT full_name ,
		COUNT(user_id) AS User_count
FROM Users u
GROUP BY user_id
HAVING COUNT(user_id) >= 2;

-- phan 3 câu 15
SELECT book_id , title , price FROM Book 
group by book_id , title
HAVING price < (SELECT AVG(price) FROM Book);

-- Phan 3 cau 16
SELECT u.full_name , u.phone 
FROM Borrows b
INNER JOIN Users u ON  b.user_id  = u.user_id
INNER JOIN Book bo ON  b.book_id = bo.book_id
WHERE title = 'Clean Code'
group by u.full_name , u.phone;
