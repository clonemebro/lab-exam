# Bank Management (Basic)

DBMS/SQL program demonstrating banking operations using tables, queries, views, triggers, and indexes.

## Tables Used

### Customer
- CustomerID
- Name
- Address
- Phone

### Account
- AccountID
- CustomerID
- Balance
- AccountType

### Transaction
- TransactionID
- AccountID
- Amount
- Type
- Date

### Branch
- BranchID
- BranchName
- Location

## Operations Performed

1. Create Customer, Account, Transaction, and Branch tables.
2. Insert records into all tables.
3. View all accounts.
4. Display customer account details.
5. Display transaction details.
6. Display total balance per branch.
7. Display high value transactions.
8. Create a view displaying customer name, account, and balance.
9. Create an index on AccountID.
10. Create a trigger to automatically update account balance for deposits and withdrawals.
11. Find the top 3 customers by total balance.

## Topics Covered

- DDL Commands
- DML Commands
- SELECT Queries
- Aggregate Functions
- Joins
- Views
- Triggers
- Indexes