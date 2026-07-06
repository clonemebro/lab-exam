# Bank Management (Advanced)

DBMS/SQL program demonstrating advanced banking operations using queries, aggregate functions, and ranking techniques.

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
3. Display balance after each transaction.
4. Find accounts with no transactions.
5. Detect high value transactions.
6. Display monthly transaction summary.
7. Find customers with multiple accounts.
8. Find the second highest balance account.
9. Rank accounts by balance.
10. Display branch-wise average balance.
11. Find customers with no withdrawals.

## Topics Covered

- DDL Commands
- DML Commands
- SELECT Queries
- Aggregate Functions
- Subqueries
- Group By
- Joins
- Window Functions
- Ranking Functions