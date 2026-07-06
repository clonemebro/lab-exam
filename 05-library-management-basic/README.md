# Library Management (Basic)

DBMS/SQL program demonstrating library management operations using tables, queries, views, triggers, and indexes.

## Tables Used

### Book
- BookID
- Title
- Author
- Publisher
- AvailableCopies

### Member
- MemberID
- Name
- Department
- Phone

### Issue
- IssueID
- BookID
- MemberID
- IssueDate
- ReturnDate

### Fine
- FineID
- IssueID
- Amount

## Operations Performed

1. Create Book, Member, Issue, and Fine tables.
2. Insert records into all tables.
3. View all books.
4. Display issued books with member details.
5. Display late returns.
6. Display total fine collected.
7. List available books.
8. Create a view displaying issued books with member names.
9. Create a trigger for issuing books.
10. Create an index on book title.
11. Rank books by number of times issued.

## Topics Covered

- DDL Commands
- DML Commands
- SELECT Queries
- Aggregate Functions
- Joins
- Views
- Triggers
- Indexes
- Ranking Functions