USE [db_final_26.04]
GO

-- Inserting data into Countries table
INSERT INTO Countries (Name)
VALUES ('United States'),
       ('United Kingdom'),
       ('Canada');

-- Inserting data into Shops table
INSERT INTO Shops (Name, CountryId)
VALUES ('Coffee House 1', 1),
       ('Coffee House 2', 1),
       ('Tea House 1', 2);

-- Inserting data into Employees table
INSERT INTO Employees (Position, EmploymentDate, Gender, Salary)
VALUES ('Manager', '2023-01-01', 'Male', 50000.00),
       ('Barista', '2023-02-15', 'Female', 30000.00),
       ('Barista', '2023-02-20', 'Male', 30000.00);

-- Inserting data into Customers table
INSERT INTO Customers (Email, Phone, PurchaseHistory, DiscountPercentage, SignedForMailing)
VALUES ('customer1@example.com', '123456789', NULL, 5.00, 1),
       ('customer2@example.com', '987654321', NULL, 0.00, 0);

-- Inserting data into Coffee table
INSERT INTO Coffee (Type, QuantitySold, Price)
VALUES ('Espresso', 100, 2.50),
       ('Latte', 150, 3.00),
       ('Cappuccino', 120, 3.25);

-- Inserting data into Suppliers table
INSERT INTO Suppliers (Name, ContactName, ContactNumber)
VALUES ('Coffee Supplier 1', 'John Smith', '123-456-7890'),
       ('Coffee Supplier 2', 'Jane Doe', '987-654-3210');

-- Inserting data into Ingredients table
INSERT INTO Ingredients (Name, QuantityInStock)
VALUES ('Milk', 500),
       ('Sugar', 1000),
       ('Vanilla Syrup', 200);

-- Inserting data into Recipes table
INSERT INTO Recipes (Name, Description)
VALUES ('Espresso', 'A concentrated coffee beverage brewed by forcing hot water under pressure through finely-ground coffee beans.');

-- Inserting data into MenuItems table
INSERT INTO MenuItems (Name, Price)
VALUES ('Espresso', 2.50),
       ('Latte', 3.50),
       ('Cappuccino', 3.75);
