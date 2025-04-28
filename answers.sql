-- Question 1 Achieving 1NF (First Normal Form) 🛠️
-- The given ProductDetail table violates 1NF because the Products column contains multiple values. 
-- We will transform the table into 1NF by ensuring each row represents a single product for an order.

-- Step 1: Create a new table to hold the normalized order details with one product per order
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100)
);

-- Step 2: Insert each product as a separate row into the new table
-- We will split the Products column into individual products and insert them.
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT OrderID, CustomerName, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n.n), ',', -1)) AS Product
FROM ProductDetail
JOIN (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) n
WHERE n.n <= (LENGTH(Products) - LENGTH(REPLACE(Products, ',', '')) + 1);

-- Question 2 Achieving 2NF (Second Normal Form) 🧩
-- The OrderDetails table is in 1NF but contains partial dependencies, as CustomerName depends on OrderID.
-- We will transform the table into 2NF by creating separate tables to remove partial dependencies.

-- Step 1: Create a new table for Orders to hold the OrderID and CustomerName (removing the partial dependency on CustomerName)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Step 2: Insert the distinct order details into the Orders table
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Step 3: Create a new table for OrderProducts to hold OrderID, Product, and Quantity (removing dependency on CustomerName)
CREATE TABLE OrderProducts (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Step 4: Insert the product details into the OrderProducts table
INSERT INTO OrderProducts (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;