# Customer Order Management

DBMS/SQL program demonstrating customer order and product management using tables, queries, views, triggers, and indexes.

## Tables Used

### Customer
- CustomerID
- Name
- Email
- Phone

### Product
- ProductID
- ProductName
- Price
- Stock

### Orders
- OrderID
- CustomerID
- OrderDate

### OrderDetails
- OrderID
- ProductID
- Quantity

### Payment
- PaymentID
- OrderID
- Amount
- Status

## Operations Performed

1. Create Customer, Product, Orders, OrderDetails, and Payment tables.
2. Insert records into all tables.
3. View all products.
4. List customer orders with product details.
5. Display total order amount per customer.
6. Display products with low stock.
7. Display paid orders.
8. Create a view showing customers, their orders, and products.
9. Create a trigger to automatically reduce product stock when an order is placed.
10. Create an index on the ProductName column.

## Topics Covered

- DDL Commands
- DML Commands
- SELECT Queries
- Aggregate Functions
- Joins
- Views
- Triggers
- Indexes