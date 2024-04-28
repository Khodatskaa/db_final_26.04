CREATE DATABASE [db_final_26.04]  -- Coffee shop
GO
USE [db_final_26.04]
GO

CREATE TABLE Countries(
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Shops (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(MAX) NOT NULL,
    CountryId INT NOT NULL,
    FOREIGN KEY (CountryId) REFERENCES Countries(Id)
);

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

CREATE TABLE Employees (
    EmployeeId INT PRIMARY KEY IDENTITY(1,1),
    Position NVARCHAR(50),
    EmploymentDate DATE,
    Gender NVARCHAR(10),
    Salary DECIMAL(10, 2),
	ADD CONSTRAINT CHK_Salary CHECK (Salary >= 0),
	ADD CONSTRAINT CHK_Gender CHECK (Gender IN ('Male', 'Female'));
);

CREATE TABLE Customers (
    CustomerId INT PRIMARY KEY IDENTITY(1,1),
    Email NVARCHAR(255),
    Phone NVARCHAR(20),
    PurchaseHistory TEXT,
    DiscountPercentage DECIMAL(5, 2),
    SignedForMailing BIT,
	ADD CONSTRAINT CHK_PhoneLength CHECK (LEN(Phone) >= 7);
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
	ADD CONSTRAINT CHK_Price CHECK (Price >= 0);
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
    FOREIGN KEY (SupplierId) REFERENCES Suppliers(SupplierId)
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

DELIMITER //    

--1. Trigger for Shops Table
CREATE TRIGGER check_shop_country
BEFORE INSERT ON Shops
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Countries WHERE Id = NEW.CountryId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Country does not exist';
    END IF;
END//

--2. Trigger for Sales Table
CREATE TRIGGER update_quantity_sold
AFTER INSERT ON Sales
FOR EACH ROW
BEGIN
    UPDATE Coffee
    SET QuantitySold = QuantitySold + NEW.Quantity
    WHERE Id = NEW.CoffeeId;
END//

--3. Trigger for Orders Table
CREATE TRIGGER update_total_price
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    DECLARE total_price DECIMAL(10, 2);
    SET total_price = (SELECT SUM(Price * Quantity) FROM Sales WHERE ShopId = NEW.ShopId);
    SET NEW.TotalPrice = total_price;
END//

--4. Trigger for Inventory Table
CREATE TRIGGER check_inventory_quantity
BEFORE INSERT ON Inventory
FOR EACH ROW
BEGIN
    IF NEW.Quantity < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantity cannot be negative';
    END IF;
END//

--5. Trigger for Coffee Table
CREATE TRIGGER check_price_constraint
BEFORE INSERT ON Coffee
FOR EACH ROW
BEGIN
    IF NEW.Price < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Price cannot be negative';
    END IF;
END//

--6.
CREATE TRIGGER check_quantity_sold_constraint
BEFORE INSERT ON Coffee
FOR EACH ROW
BEGIN
    IF NEW.QuantitySold < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantity sold cannot be negative';
    END IF;
END//

--7. Trigger for Customers Table
CREATE TRIGGER check_customer_email_format
BEFORE INSERT ON Customers
FOR EACH ROW
BEGIN
    IF NEW.Email NOT LIKE '%@%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid email format';
    END IF;
END//

--8.CREATE TRIGGER check_customer_phone_length
CREATE TRIGGER check_customer_phone_length
BEFORE INSERT ON Customers
FOR EACH ROW
BEGIN
    IF LENGTH(NEW.Phone) < 7 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Phone number must have at least 7 digits';
    END IF;
END;

--9. Trigger for Employees Table
CREATE TRIGGER check_employee_salary
BEFORE INSERT ON Employees
FOR EACH ROW
BEGIN
    IF NEW.Salary < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Salary cannot be negative';
    END IF;
END//

--10.CREATE TRIGGER check_employee_gender
BEFORE INSERT ON Employees
FOR EACH ROW
BEGIN
    IF NEW.Gender NOT IN ('Male', 'Female') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid gender';
    END IF;
END//

DELIMITER;

