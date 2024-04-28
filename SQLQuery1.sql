USE [db_final_26.04]
GO

-- Insert into Countries without specifying identity column
INSERT INTO Countries (Name) VALUES ('France'), ('Italy')
GO

-- Insert into Shops, referencing the correct CountryIds
INSERT INTO Shops (Name, CountryId) VALUES 
    ('Coffee House 1', 1), 
    ('Café Français', 2), 
    ('Italian Espresso Bar', 3);
GO

-- Insert into Coffee
INSERT INTO Coffee (Type, QuantitySold, Price) VALUES 
    ('Espresso', 20, 2.50), 
    ('V60', 32, 4.20),
    ('Cortado', 12, 3.30),
    ('Cold brew', 41, 3.90),
    ('Latte', 15, 3.50);
GO

-- Insert into Suppliers
INSERT INTO Suppliers (Name, ContactName, ContactNumber) VALUES 
    ('Coffee Supplier Co.', 'John Smith', '9876543210'), 
    ('Milk Supplier Inc.', 'Emily Johnson', '1234567890');
GO

-- Insert into Inventory
INSERT INTO Inventory (CoffeeId, SupplierId, Quantity, PurchaseDate) VALUES 
    (1, 1, 100, '2024-04-01'), 
    (2, 2, 50, '2024-04-10');
GO

-- Insert into Ingredients
INSERT INTO Ingredients (Name, QuantityInStock) VALUES 
    ('Milk', 500), 
    ('CoffeeBeans', 1500),
    ('Ice', 900),
    ('Sugar', 1000);
GO

-- Insert into Recipes
INSERT INTO Recipes (Name, Description) VALUES 
    ('Espresso', 'A shot of pure coffee'), 
    ('V60', 'Pour over type of brewing'),
    ('Cortado', 'Espresso with steamed milk 1:1'),
    ('Cold brew', 'Shots of espresso with ice'),
    ('Latte', 'Espresso with steamed milk');
GO

-- Insert into RecipeIngredients
INSERT INTO RecipeIngredients (RecipeId, IngredientId, Quantity) VALUES 
    (1, 1, 1), 
    (2, 1, 1), 
    (2, 2, 0.5);
GO

-- Insert into MenuItems
INSERT INTO MenuItems (Name, Price) VALUES 
    ('Espresso', 2.50), 
    ('V60', 4.20),
    ('Cortado', 3.30),
    ('Cold brew', 3.90);
GO

-- Insert into Sales
INSERT INTO Sales (Price, Quantity, SaleDate, CoffeeId, ShopId) VALUES 
    (3.50, 10, '2024-04-26', 1, 1), 
    (4.00, 8, '2024-04-26', 2, 1), 
    (2.00, 15, '2024-04-25', 1, 2);
GO

-- Insert into Orders
INSERT INTO Orders (CustomerId, OrderDate, TotalPrice) VALUES 
    (1, '2024-04-26', 35.00), 
    (2, '2024-04-25', 30.00);
GO
