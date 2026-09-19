CREATE DATABASE OnlineRetailStore;
GO

USE OnlineRetailStore;
GO

-- 1. Customers
CREATE TABLE Customers
(
    CustomerId INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(20),
    Email VARCHAR(100),
    ShippingAddress VARCHAR(255),
    RegistrationDate DATETIME
)
GO

-- 2. Categories
CREATE TABLE Categories
(
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Description VARCHAR(255),
    MainCategory INT  FOREIGN KEY 
        REFERENCES Categories(CategoryId)

       
)

-- 3. Suppliers
CREATE TABLE Suppliers
(
    SupplierId INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Country VARCHAR(100),
    Email VARCHAR(100),
    Address VARCHAR(255),
    ContactNumber VARCHAR(20)
)


-- 4. Payments
CREATE TABLE Payments
(
    PaymentId INT PRIMARY KEY,
    PaymentDate DATETIME,
    Amount DECIMAL(10,2),
    Status VARCHAR(50),
    Method VARCHAR(50)
)


-- 5. Products
CREATE TABLE Products
(
    ProductId INT IDENTITY(1,1) PRIMARY KEY,
    StockQuantity INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    AddedDate DATETIME,
    Description VARCHAR(255),
    UnitPrice DECIMAL(10,2) NOT NULL,
    CategoryId INT NOT NULL FOREIGN KEY 
        REFERENCES Categories(CategoryId), 
)


-- 6. Products_Suppliers
CREATE TABLE Products_Suppliers
(
    SupplierId INT NOT NULL 
    FOREIGN KEY 
     REFERENCES Suppliers(SupplierId),
    ProductId INT NOT NULL
    FOREIGN KEY 
    REFERENCES Products(ProductId),

    PRIMARY KEY (SupplierId, ProductId),

)


-- 7. Orders
CREATE TABLE Orders
(
    OrderId INT  PRIMARY KEY,
    Status VARCHAR(50),
    TotalAmount DECIMAL(6,2),
    OrderDate DATETIME,
    CustomerId INT NOT NULL,

    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerId)
        REFERENCES Customers(CustomerId)
)

-- 8. OrderItems
CREATE TABLE OrderItems
(
    OrderItemId INT PRIMARY KEY,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    ProductId INT NOT NULL,
    OrderId INT NOT NULL,

    CONSTRAINT FK_OrderItems_Products
        FOREIGN KEY (ProductId)
        REFERENCES Products(ProductId),

    CONSTRAINT FK_OrderItems_Orders
        FOREIGN KEY (OrderId)
        REFERENCES Orders(OrderId)
)


-- 9. Reviews
CREATE TABLE Reviews
(
    ReviewId INT IDENTITY(1,1) PRIMARY KEY,
    Rating INT,
    Date DATETIME,
    Comment VARCHAR(500),
    ProductId INT NOT NULL,
    CustomerId INT NOT NULL,

    CONSTRAINT FK_Reviews_Products
        FOREIGN KEY (ProductId)
        REFERENCES Products(ProductId),

    CONSTRAINT FK_Reviews_Customers
        FOREIGN KEY (CustomerId)
        REFERENCES Customers(CustomerId)
)


-- 10. StockTransactions
CREATE TABLE StockTransactions
(
    TranId INT IDENTITY(1,1) PRIMARY KEY,
    TranDate DATETIME,
    QuantityChange INT,
    Type VARCHAR(50),
    Reference VARCHAR(100),
    ProductId INT NOT NULL,

    CONSTRAINT FK_StockTransactions_Products
        FOREIGN KEY (ProductId)
        REFERENCES Products(ProductId)
)


-- 11. Orders_Payments
CREATE TABLE Orders_Payments
(
    OrderId INT NOT NULL,
    PaymentId INT NOT NULL,

    CONSTRAINT PK_Orders_Payments
        PRIMARY KEY (OrderId, PaymentId),

    CONSTRAINT FK_Orders_Payments_Orders
        FOREIGN KEY (OrderId)
        REFERENCES Orders(OrderId),

    CONSTRAINT FK_Orders_Payments_Payments
        FOREIGN KEY (PaymentId)
        REFERENCES Payments(PaymentId)
)


-- 12. Shipments
CREATE TABLE Shipments
(
    ShipmentId INT IDENTITY(1,1) PRIMARY KEY,
    ShipmentDate DATETIME,
    Status VARCHAR(50),
    DeliveryDate DATETIME,
    CarrierName VARCHAR(100),
    TrackingNumber VARCHAR(100),
    OrderId INT NOT NULL,

    CONSTRAINT FK_Shipments_Orders
        FOREIGN KEY (OrderId)
        REFERENCES Orders(OrderId)
)
