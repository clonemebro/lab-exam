# Library Management (Advanced)

DBMS/SQL program demonstrating advanced library management operations using analytical queries, aggregate functions, and ranking techniques.

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
3. Display the top 3 most issued books.
4. Display how many books each member has issued over time.
5. Display the most recent book issued per member.
6. Find members with frequent borrowing activity.
7. Rank members by number of books issued.
8. Display the first issue of each book.
9. Detect books frequently issued within the same month.
10. Display the contribution of each book in total issues.
11. Find overdue books ranking.

## Topics Covered

- DDL Commands
- DML Commands
- SELECT Queries
- Aggregate Functions
- Group By
- Subqueries
- Joins
- Window Functions
- Ranking Functions