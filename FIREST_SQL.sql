-- ● Insert a new Customer (FullName, PhoneNumber, Email,
--ShippingAddress, RegistrationDate)
INSERT INTO Customers
VALUES('Zyad Mohamed','01114195719','zyad@gmail.com','31-tahergonem street',15-9-2026)

-- ● Insert 3 new Suppliers
INSERT INTO Suppliers
VALUES(1,'Ali','UK','ali@gmail.com','45-london','4501457515'),
(2,'Ahmed','Us','ahmed@gmail.com','78-newyourk','1452875'),
(3,'omar','Egypt','omar@gmail.com','45-dokki','0101419448')

-- ● Insert 2 Categories
INSERT INTO Categories (name)
VALUES('water')

INSERT INTO Categories
VALUES('Chepses','amazing snak',6)

-- ● Insert a Product but only (Name, UnitPrice)

INSERT INTO Products(name , UnitPrice,CategoryId,StockQuantity)
VALUES('COLA',10,6,200)


-- ● Create table ArchivedStock (TranId, ProductId, QuantityChange,
--   TranDate) Insert into ArchivedStock all StockTransactions before 2023

CREATE TABLE ArchivedStock
(
    TranId INT,
    ProductId INT,
    QuantityChange INT,
    TranDate DATE
)

INSERT INTO StockTransactions
VALUES(15-7-2023,15,'YYY','UUU',3)

    INSERT INTO ArchivedStock
    SELECT TranId,ProductId,QuantityChange,TranDate
    FROM StockTransactions
    
    SELECT *
    FROM ArchivedStock

-- ● Create #CustomerOrders with (OrderId, CustomerId, TotalAmount)
--   Insert customers who made orders above 5000.

CREATE TABLE COUSTOMERORDERS
(
Orderid INT ,
Customerid INT,
TotlAmount DECIMAL,
PRIMARY KEY(Orderid,Customerid)
)

INSERT INTO Orders
VALUES(1,'DDD',750,15-7-2025,1)

INSERT INTO COUSTOMERORDERS
SELECT OrderId, CustomerId,TotalAmount
FROM Orders
WHERE TotalAmount > 500

--● Create ##TopRatedProducts with (ProductId, Rating) Insert
--  products with rating ≥ 4.5
 
CREATE TABLE TOPRATEDPRODUCTS
(
Productid INT PRIMARY KEY,
Raring DECIMAL 
)

INSERT INTO TOPRATEDPRODUCTS
SELECT ProductId,Rating
FROM Products
WHERE Rating > 4.5

-- ●  Increase all UnitPrice by 10% for products under 100 EGP 
UPDATE PRODUCTS
SET UnitPrice += (UnitPrice*0.1)
WHERE UnitPrice<100

-- ●  Update Order Status: If TotalAmount > 5000 → “Premium” Else → “Standard” 

UPDATE Orders
SET Status = CASE 
WHEN TotalAmount > 5000 THEN 'Premium'
ELSE 'Standard'
END

-- ● Delete a Review by ReviewId 
DELETE FROM Reviews
WHERE ReviewId = 1

-- ● Delete all Orders with Status = “Cancelled 
DELETE FROM Orders
WHERE Status = 'Cancelled'

-- ● Delete OrderItems for a given OrderId 
DELETE FROM OrderItems
WHERE OrderId = 1

-- ● Create table #ProductsUpdate (ProductId, Name, UnitPrice, StockQuantity) 
CREATE TABLE PRODUCTSUPDATE
(
Productid INT PRIMARY KEY ,
Name VARCHAR(10) ,
UnitPcrice INT ,
StockQuantity INT
)

-- MERGE
MERGE INTO Products AS P
USING PRODUCTSUPDATE AS U
ON P.ProductId = U.ProductId

WHEN MATCHED THEN
    UPDATE SET
        P.UnitPrice = U.UnitPcrice,
        P.StockQuantity = U.StockQuantity

WHEN NOT MATCHED BY TARGET THEN
    INSERT ( Name, UnitPrice, StockQuantity)
    VALUES (U.Name, U.UnitPcrice, U.StockQuantity)

WHEN NOT MATCHED BY SOURCE THEN.
    DELETE;
