USE [db_final_26.04]
GO

-- Select all countries
SELECT * FROM Countries;

-- Select all shops with their respective countries
SELECT s.Name AS ShopName, c.Name AS CountryName
FROM Shops s
INNER JOIN Countries c ON s.CountryId = c.Id;

-- Select all sales with details of the coffee and shop
SELECT sa.Id AS SaleId, sa.Price, sa.Quantity, sa.SaleDate, c.Type AS CoffeeType, sh.Name AS ShopName
FROM Sales sa
INNER JOIN Coffee c ON sa.CoffeeId = c.Id
INNER JOIN Shops sh ON sa.ShopId = sh.Id;

-- Select all employees
SELECT * FROM Employees;

-- Select all customers
SELECT * FROM Customers;

-- Select all orders with details of the customer
SELECT o.Id AS OrderId, o.OrderDate, o.TotalPrice, c.Email AS CustomerEmail, c.Phone AS CustomerPhone
FROM Orders o
INNER JOIN Customers c ON o.CustomerId = c.CustomerId;

-- Select all coffees
SELECT * FROM Coffee;

-- Select all suppliers
SELECT * FROM Suppliers;

-- Select all inventory items with details of the coffee and supplier
SELECT i.Id AS InventoryId, c.Type AS CoffeeType, s.Name AS SupplierName, i.Quantity, i.PurchaseDate
FROM Inventory i
INNER JOIN Coffee c ON i.CoffeeId = c.Id
INNER JOIN Suppliers s ON i.SupplierId = s.SupplierId;

-- Select all ingredients
SELECT * FROM Ingredients;

-- Select all recipes
SELECT * FROM Recipes;

-- Select all recipe ingredients with details of the recipe and ingredient
SELECT ri.RecipeId, r.Name AS RecipeName, i.Name AS IngredientName, ri.Quantity
FROM RecipeIngredients ri
INNER JOIN Recipes r ON ri.RecipeId = r.RecipeId
INNER JOIN Ingredients i ON ri.IngredientId = i.Id;

-- Select all menu items
SELECT * FROM MenuItems;
GO

-- Add Customer Procedure
CREATE PROCEDURE AddCustomer
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

-- Update Customer Procedure
CREATE PROCEDURE UpdateCustomer
    @CustomerId INT,
    @Email NVARCHAR(255),
    @Phone NVARCHAR(20),
    @PurchaseHistory TEXT,
    @DiscountPercentage DECIMAL(5, 2),
    @SignedForMailing BIT
AS
BEGIN
    UPDATE Customers
    SET Email = @Email,
        Phone = @Phone,
        PurchaseHistory = @PurchaseHistory,
        DiscountPercentage = @DiscountPercentage,
        SignedForMailing = @SignedForMailing
    WHERE CustomerId = @CustomerId;
END;
GO

-- Delete Customer Procedure
CREATE PROCEDURE DeleteCustomer
    @CustomerId INT
AS
BEGIN
    DELETE FROM Customers WHERE CustomerId = @CustomerId;
END;
GO

-- Get Sales by Date Procedure
CREATE PROCEDURE GetSalesByDate
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT *
    FROM Sales
    WHERE SaleDate BETWEEN @StartDate AND @EndDate;
END;
GO

-- Get Employee by Position Procedure
CREATE PROCEDURE GetEmployeesByPosition
    @Position NVARCHAR(50)
AS
BEGIN
    SELECT *
    FROM Employees
    WHERE Position = @Position;
END;
GO

-- Get Coffee by Type Procedure
CREATE PROCEDURE GetCoffeeByType
    @Type NVARCHAR(100)
AS
BEGIN
    SELECT *
    FROM Coffee
    WHERE Type = @Type;
END;
GO

-- Get Orders by Customer Procedure
CREATE PROCEDURE GetOrdersByCustomer
    @CustomerId INT
AS
BEGIN
    SELECT *
    FROM Orders
    WHERE CustomerId = @CustomerId;
END;
GO
