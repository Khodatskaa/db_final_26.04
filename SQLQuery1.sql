USE [db_final_26.04]
GO

-- Selecting all data from the Countries table
SELECT * FROM Countries;

-- Selecting all data from the Shops table
SELECT * FROM Shops;

-- Selecting data from the Employees table with specific conditions
SELECT * FROM Employees WHERE Position = 'Manager';

-- Selecting data from the Customers table with specific conditions
SELECT * FROM Customers WHERE DiscountPercentage > 0;

-- Selecting data from the Coffee table with specific conditions
SELECT * FROM Coffee WHERE QuantitySold > 100;

-- Selecting data from the Suppliers table
SELECT * FROM Suppliers;

-- Selecting data from the Ingredients table
SELECT * FROM Ingredients;

-- Selecting data from the Recipes table
SELECT * FROM Recipes;

-- Selecting data from the MenuItems table
SELECT * FROM MenuItems;
GO

-- Procedure to insert a new shop
CREATE PROCEDURE InsertShop
    @Name NVARCHAR(MAX),
    @CountryId INT
AS
BEGIN
    INSERT INTO Shops (Name, CountryId)
    VALUES (@Name, @CountryId);
END;
GO

-- Procedure to insert a new employee
CREATE PROCEDURE InsertEmployee
    @Position NVARCHAR(50),
    @EmploymentDate DATE,
    @Gender NVARCHAR(10),
    @Salary DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO Employees (Position, EmploymentDate, Gender, Salary)
    VALUES (@Position, @EmploymentDate, @Gender, @Salary);
END;
GO

-- Procedure to insert a new customer
CREATE PROCEDURE InsertCustomer
    @Email NVARCHAR(255),
    @Phone NVARCHAR(20),
    @PurchaseHistory TEXT,
    @DiscountPercentage DECIMAL(5, 2),
    @SignedForMailing BIT
AS
BEGIN
    INSERT INTO Customers (Email, Phone, PurchaseHistory, DiscountPercentage, SignedForMailing)
    VALUES (@Email, @Phone, @PurchaseHistory, @DiscountPercentage, @SignedForMailing);
END;
GO

-- Procedure to insert a new coffee
CREATE PROCEDURE InsertCoffee
    @Type NVARCHAR(100),
    @QuantitySold INT,
    @Price MONEY
AS
BEGIN
    INSERT INTO Coffee (Type, QuantitySold, Price)
    VALUES (@Type, @QuantitySold, @Price);
END;
GO

-- Procedure to insert a new supplier
CREATE PROCEDURE InsertSupplier
    @Name NVARCHAR(100),
    @ContactName NVARCHAR(100),
    @ContactNumber NVARCHAR(20)
AS
BEGIN
    INSERT INTO Suppliers (Name, ContactName, ContactNumber)
    VALUES (@Name, @ContactName, @ContactNumber);
END;
GO
