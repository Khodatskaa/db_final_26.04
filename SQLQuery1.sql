CREATE DATABASE [db_final_26.04]  -- Coffee shop
GO
USE [db_final_26.04];
GO

-- Create Countries table
CREATE TABLE Countries (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50) NOT NULL UNIQUE
);
GO

-- Create Coffee table
CREATE TABLE Coffee (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Type NVARCHAR(100),
    QuantitySold INT,
    Price MONEY NOT NULL CHECK (Price >= 0)
);
GO

-- Create Shops table
CREATE TABLE Shops (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(MAX) NOT NULL,
    CountryId INT NOT NULL,
    FOREIGN KEY (CountryId) REFERENCES Countries(Id)
);
GO

-- Create Sales table
CREATE TABLE Sales (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Price MONEY NOT NULL CHECK (Price >= 0),
    Quantity INT NOT NULL CHECK (Quantity > 0),
    SaleDate DATE NOT NULL DEFAULT GETDATE() CHECK (SaleDate <= CAST(GETDATE() AS DATE)),
    CoffeeId INT NOT NULL,
    ShopId INT NOT NULL,
    FOREIGN KEY (CoffeeId) REFERENCES Coffee(Id),
    FOREIGN KEY (ShopId) REFERENCES Shops(Id)
);
GO

-- Create Employees table
CREATE TABLE Employees (
    EmployeeId INT PRIMARY KEY IDENTITY(1,1),
    Position NVARCHAR(50),
    EmploymentDate DATE,
    Gender NVARCHAR(10),
    Salary DECIMAL(10, 2),
    CONSTRAINT CHK_Salary CHECK (Salary >= 0),
    CONSTRAINT CHK_Gender CHECK (Gender IN ('Male', 'Female'))
);
GO

-- Create Customers table
CREATE TABLE Customers (
    CustomerId INT PRIMARY KEY IDENTITY(1,1),
    Email NVARCHAR(255),
    Phone NVARCHAR(20),
    PurchaseHistory TEXT,
    DiscountPercentage DECIMAL(5, 2),
    SignedForMailing BIT,
    CONSTRAINT CHK_PhoneLength CHECK (LEN(Phone) >= 7)
);
GO

-- Create Orders table
CREATE TABLE Orders (
    Id INT PRIMARY KEY IDENTITY(1,1),
    CustomerId INT,
    OrderDate DATE,
    TotalPrice DECIMAL(10, 2),
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId)
);
GO

-- Create Suppliers table
CREATE TABLE Suppliers (
    SupplierId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    ContactName NVARCHAR(100),
    ContactNumber NVARCHAR(20)
);
GO

-- Create Inventory table
CREATE TABLE Inventory (
    Id INT PRIMARY KEY IDENTITY(1,1),
    CoffeeId INT,
    SupplierId INT,
    Quantity INT NOT NULL CHECK (Quantity >= 0),
    PurchaseDate DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (CoffeeId) REFERENCES Coffee(Id),
    FOREIGN KEY (SupplierId) REFERENCES Suppliers(SupplierId)
);
GO

-- Create Ingredients table
CREATE TABLE Ingredients (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    QuantityInStock INT NOT NULL CHECK (QuantityInStock >= 0)
);
GO

-- Create Recipes table
CREATE TABLE Recipes (
    RecipeId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    Description NVARCHAR(MAX)
);
GO

-- Create RecipeIngredients table
CREATE TABLE RecipeIngredients (
    RecipeId INT,
    IngredientId INT,
    Quantity DECIMAL(10, 2),
    FOREIGN KEY (RecipeId) REFERENCES Recipes(RecipeId),
    FOREIGN KEY (IngredientId) REFERENCES Ingredients(Id)
);
GO

-- Create MenuItems table
CREATE TABLE MenuItems (
    ItemId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    Price MONEY NOT NULL CHECK (Price >= 0)
);
GO

-- Triggers

-- Trigger for Shops Table
CREATE TRIGGER check_shop_country
ON Shops
INSTEAD OF INSERT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM inserted i JOIN Countries c ON i.CountryId = c.Id)
    BEGIN
        RAISERROR ('Country does not exist', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
GO

-- Trigger for Sales Table
CREATE TRIGGER update_quantity_sold
ON Sales
AFTER INSERT
AS
BEGIN
    UPDATE c
    SET QuantitySold = c.QuantitySold + i.Quantity
    FROM Coffee c
    INNER JOIN inserted i ON c.Id = i.CoffeeId;
END;
GO

-- Trigger for Orders Table
CREATE TRIGGER update_total_price
ON Orders
AFTER INSERT
AS
BEGIN
    UPDATE o
    SET TotalPrice = (SELECT SUM(s.Price * s.Quantity) FROM Sales s WHERE s.ShopId = o.ShopId)
    FROM Orders o
    INNER JOIN inserted i ON o.Id = i.Id;
END;
GO

-- Trigger for Inventory Table
CREATE TRIGGER check_inventory_quantity
ON Inventory
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Quantity < 0)
    BEGIN
        RAISERROR ('Quantity cannot be negative', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
GO

-- Trigger for Coffee Table
CREATE TRIGGER check_price_constraint
ON Coffee
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Price < 0)
    BEGIN
        RAISERROR ('Price cannot be negative', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
GO

-- Trigger for Customers Table
CREATE TRIGGER check_customer_email_format
ON Customers
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Email NOT LIKE '%@%')
    BEGIN
        RAISERROR ('Invalid email format', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
GO

-- Trigger for Customers Table
CREATE TRIGGER check_customer_phone_length
ON Customers
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE LEN(Phone) < 7)
    BEGIN
        RAISERROR ('Phone number must have at least 7 digits', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
GO

-- Trigger for Employees Table
CREATE TRIGGER check_employee_salary
ON Employees
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Salary < 0)
    BEGIN
        RAISERROR ('Salary cannot be negative', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
GO

-- Trigger for Employees Table
CREATE TRIGGER check_employee_gender
ON Employees
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Gender NOT IN ('Male', 'Female'))
    BEGIN
        RAISERROR ('Invalid gender', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
GO