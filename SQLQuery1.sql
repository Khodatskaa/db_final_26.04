CREATE DATABASE [db_final_26.04]  -- Coffee shop
GO
USE [db_final_26.04]
GO

CREATE TABLE Countries(
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Shops(
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(MAX) NOT NULL,
    CountryId INT NOT NULL,
    FOREIGN KEY (CountryId) REFERENCES Countries(Id)
);

CREATE TABLE Sales(
    Id INT PRIMARY KEY IDENTITY(1,1),
    Price MONEY NOT NULL CHECK (Price >= 0),
    Quantity INT NOT NULL CHECK (Quantity > 0),
    SaleDate DATE NOT NULL DEFAULT GETDATE() CHECK (SaleDate <= CAST(GETDATE() AS DATE)),
    CoffeeId INT NOT NULL,
    ShopId INT NOT NULL,
    FOREIGN KEY (CoffeeId) REFERENCES Coffee(Id),
    FOREIGN KEY (ShopId) REFERENCES Shops(Id)
);

CREATE TABLE Employees (
    EmployeeId INT PRIMARY KEY IDENTITY(1,1),
    Position NVARCHAR(50),
    EmploymentDate DATE,
    Gender NVARCHAR(10),
    Salary DECIMAL(10, 2),
    CONSTRAINT CHK_Salary CHECK (Salary >= 0),
    CONSTRAINT CHK_Gender CHECK (Gender IN ('Male', 'Female'))
);

CREATE TABLE Customers (
    CustomerId INT PRIMARY KEY IDENTITY(1,1),
    Email NVARCHAR(255),
    Phone NVARCHAR(20),
    PurchaseHistory TEXT,
    DiscountPercentage DECIMAL(5, 2),
    SignedForMailing BIT,
    CONSTRAINT CHK_PhoneLength CHECK (LEN(Phone) >= 7)
);

CREATE TABLE Orders (
    Id INT PRIMARY KEY IDENTITY(1,1),
    CustomerId INT,
    OrderDate DATE,
    TotalPrice DECIMAL(10, 2),
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId)
);

CREATE TABLE Coffee (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Type NVARCHAR(100),
    QuantitySold INT,
    Price MONEY NOT NULL CHECK (Price >= 0),
    CONSTRAINT CHK_Price CHECK (Price >= 0)
);

CREATE TABLE Suppliers (
    SupplierId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    ContactName NVARCHAR(100),
    ContactNumber NVARCHAR(20)
);

CREATE TABLE Inventory (
    Id INT PRIMARY KEY IDENTITY(1,1),
    CoffeeId INT,
    SupplierId INT,
    Quantity INT NOT NULL CHECK (Quantity >= 0),
    PurchaseDate DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (CoffeeId) REFERENCES Coffee(Id),
    FOREIGN KEY (SupplierId) REFERENCES Suppliers(SupplierId),
    CONSTRAINT CHK_Quantity CHECK (Quantity >= 0)
);

CREATE TABLE Ingredients (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    QuantityInStock INT NOT NULL CHECK (QuantityInStock >= 0)
);

CREATE TABLE Recipes (
    RecipeId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    Description NVARCHAR(MAX)
);

CREATE TABLE RecipeIngredients (
    RecipeId INT,
    IngredientId INT,
    Quantity DECIMAL(10, 2),
    FOREIGN KEY (RecipeId) REFERENCES Recipes(RecipeId),
    FOREIGN KEY (IngredientId) REFERENCES Ingredients(Id)
);

CREATE TABLE MenuItems (
    ItemId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    Price MONEY NOT NULL CHECK (Price >= 0)
);

GO

--1. Trigger for Shops Table
CREATE TRIGGER check_shop_country
ON Shops
AFTER INSERT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Countries WHERE Id IN (SELECT CountryId FROM inserted)) 
    BEGIN
        RAISERROR ('Country does not exist', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

--2. Trigger for Sales Table
CREATE TRIGGER update_quantity_sold
ON Sales
AFTER INSERT
AS
BEGIN
    UPDATE Coffee
    SET QuantitySold = QuantitySold + (SELECT Quantity FROM inserted WHERE CoffeeId = Coffee.Id)
    WHERE Coffee.Id IN (SELECT CoffeeId FROM inserted);
END;
GO

--3. Trigger for Orders Table
CREATE TRIGGER update_total_price
ON Orders
AFTER INSERT
AS
BEGIN
    UPDATE Orders
    SET TotalPrice = (SELECT SUM(Price * Quantity) FROM Sales WHERE Sales.ShopId = Orders.ShopId)
    FROM Orders
    INNER JOIN inserted ON Orders.Id = inserted.Id;
END;
GO

--4. Trigger for Inventory Table
CREATE TRIGGER check_inventory_quantity
ON Inventory
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Quantity < 0) 
    BEGIN
        RAISERROR ('Quantity cannot be negative', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

--5. Trigger for Coffee Table
CREATE TRIGGER check_price_constraint
ON Coffee
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Price < 0) 
    BEGIN
        RAISERROR ('Price cannot be negative', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

--6. Trigger for Customers Table
CREATE TRIGGER check_customer_email_format
ON Customers
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Email NOT LIKE '%@%') 
    BEGIN
        RAISERROR ('Invalid email format', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

--7. Trigger for Customers Table
CREATE TRIGGER check_customer_phone_length
ON Customers
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE LEN(Phone) < 7) 
    BEGIN
        RAISERROR ('Phone number must have at least 7 digits', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

--8. Trigger for Employees Table
CREATE TRIGGER check_employee_salary
ON Employees
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Salary < 0) 
    BEGIN
        RAISERROR ('Salary cannot be negative', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

--9. Trigger for Employees Table
CREATE TRIGGER check_employee_gender
ON Employees
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Gender NOT IN ('Male', 'Female')) 
    BEGIN
        RAISERROR ('Invalid gender', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
