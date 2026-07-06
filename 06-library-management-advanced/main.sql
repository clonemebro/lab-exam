-- Create the following tables
-- Book (BookID, Title, Author, Publisher, AvailableCopies)
-- Member (MemberID, Name, Department, Phone)
-- Issue (IssueID, BookID, MemberID, IssueDate, ReturnDate)
-- Fine (FineID, IssueID, Amount)

create table book(
    bookId varchar(10) primary key,
    title varchar(20) not null,
    author varchar(20) not null,
    publisher varchar(20) not null,
    availableCopies int not null
);

create table member(
    memberId varchar(10) primary key,
    name varchar(30) not null,
    department varchar(20) not null,
    phone varchar(20) not null unique
);

create table issues(
    issueId varchar(10) primary key,
    bookId varchar(10) not null,
    memberId varchar(10) not null,
    issueDate date not null,
    returnDate date not null,

    foreign key(bookId)
    references book(bookId),

    foreign key(memberId)
    references member(memberId)
);

create table fine(
    fineId varchar(10) primary key,
    issueId varchar(10) not null,
    amount decimal(10, 2) not null,

    foreign key(issueId)
    references issues(issueId)
);

-- Insert data

insert into book values
    ('b01', 'title1', 'author1', 'publisher1', 1000),
    ('b02', 'title2', 'author2', 'publisher2', 2000),
    ('b03', 'title3', 'author3', 'publisher3', 3000),
    ('b04', 'title4', 'author4', 'publisher4', 4000),
    ('b05', 'title5', 'author5', 'publisher5', 5000);

insert into member values
    ('m01', 'name1', 'department1', '0123456789'),
    ('m02', 'name2', 'department2', '1234567890'),
    ('m03', 'name3', 'department3', '2345678901'),
    ('m04', 'name4', 'department4', '3456789012'),
    ('m05', 'name5', 'department5', '4567890123');

insert into issues values
    ('i01', 'b01', 'm01', '2001-01-01', '2001-02-01'),
    ('i02', 'b02', 'm02', '2001-01-01', '2001-02-01'),
    ('i03', 'b03', 'm03', '2001-02-01', '2001-03-01'),
    ('i04', 'b04', 'm04', '2001-02-01', '2001-03-01'),
    ('i05', 'b05', 'm05', '2001-03-01', '2001-04-01');

insert into fine values
    ('f01', 'i01', 100),
    ('f02', 'i02', 100),
    ('f03', 'i05', 300);

-- Display Top 3 Most Issued Books

-- let's insert some values to the issues table

insert into issues values
    ('i06', 'b01', 'm05', '2001-03-01', '2001-04-01'),
    ('i07', 'b01', 'm04', '2001-04-01', '2001-05-01'),
    ('i08', 'b02', 'm03', '2001-04-01', '2001-05-01');
    
select 
    book.title,
    count(issues.bookId) as totalIssued

from book

join issues
on book.bookId = issues.bookId

group by book.bookId

order by totalIssued desc

limit 3;

-- Display how many books a member has issued over time

select 
    member.name,
    count(issues.issueId) as totalBooksIssued

from member

join issues
on member.memberId = issues.memberId

group by member.memberId, member.name;

-- Display the most recent book per member

select 
    member.name,
    book.title,
    issues.issueDate

from issues

join member
on member.memberId = issues.memberId

join book
on book.bookId = issues.bookId

where (issues.memberId, issues.issueDate) in (
    
    select 
        memberId,
        max(issueDate)

    from issues

    group by memberId

);