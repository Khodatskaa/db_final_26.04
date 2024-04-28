USE [db_final_26.04]
GO

INSERT INTO Countries (Name) VALUES ('France'), ('Italy');

INSERT INTO Shops (Name, CountryId) VALUES 
    ('Coffee House 1', 1), 
    ('Café Français', 1), 
    ('Italian Espresso Bar', 2);

INSERT INTO Coffee (Type, QuantitySold, Price) VALUES 
    ('Espresso', 20, 2.50), 
    ('V60', 32, 4.20),
    ('Cortado', 12, 3.30),
    ('Cold brew', 41, 3.90),
    ('Latte', 15, 3.50);

INSERT INTO Suppliers (Name, ContactName, ContactNumber) VALUES 
    ('Coffee Supplier Co.', 'John Smith', '9876543210'), 
    ('Milk Supplier Inc.', 'Emily Johnson', '1234567890');

INSERT INTO Inventory (CoffeeId, SupplierId, Quantity, PurchaseDate) VALUES 
    (1, 1, 100, '2024-04-01'), 
    (2, 1, 50, '2024-04-10');

INSERT INTO Ingredients (Name, QuantityInStock) VALUES 
    ('Milk', 500), 
    ('CoffeeBeans', 1500),
    ('Ice', 900),
    ('Sugar', 1000);

INSERT INTO Recipes (Name, Description) VALUES 
    ('Espresso', 'A shot of pure coffee'), 
    ('V60', 'Pour over type of brewing'),
    ('Cortado', 'Espresso with steamed milk 1:1'),
    ('Cold brew', 'Shots of espresso with ice'),
    ('Latte', 'Espresso with steamed milk');

INSERT INTO RecipeIngredients (RecipeId, IngredientId, Quantity) VALUES 
    (1, 2, 1),
    (2, 2, 1),
    (2, 1, 0.5);

INSERT INTO MenuItems (Name, Price) VALUES 
    ('Espresso', 2.50), 
    ('V60', 4.20),
    ('Cortado', 3.30),
    ('Cold brew', 3.90);

INSERT INTO Sales (Price, Quantity, SaleDate, CoffeeId, ShopId) VALUES 
    (3.50, 10, '2024-04-26', 1, 1), 
    (4.00, 8, '2024-04-26', 2, 1), 
    (2.00, 15, '2024-04-25', 1, 2); 

INSERT INTO Orders (CustomerId, OrderDate, TotalPrice) VALUES 
    (1, '2024-04-26', 35.00), 
    (2, '2024-04-25', 30.00);
