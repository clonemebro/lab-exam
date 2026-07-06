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

-- View all books

select * from book;

-- Display Issued Books with Member Details

select
    book.title,
    member.name

from issues

join book
on book.bookId = issues.bookId

join member
on member.memberId = issues.memberId;

-- Display Late Returns

select 
    issues.memberId,
    issues.bookId,
    issues.returnDate,
    fine.amount

from issues

join fine
on issues.issueId = fine.issueId;

/* another way to do is

select * from issues
where datediff(returnDate, issueDate) > 7;

*/

-- Display Total Fine Collected

select sum(amount) as totalFine
from fine;

-- List Available Books

-- insert a new value to check
-- whether it is actually working

insert into book values
    ('b06', 'title6', 'author6', 'publisher6', 0);

select * from book
where availableCopies > 0;

-- Create a view that displays issued books with member names

create view issuedBookSummary as
    
select 
    book.title,
    member.name,
    issues.issueDate,
    issues.returnDate

from issues

join book
on issues.bookId = book.bookId

join member
on issues.memberId = member.memberId;

select * from issuedBookSummary;

-- Create a trigger for issuing the book

-- When a book is issued, available copies should decrease automatically

delimiter //

create trigger updateAvailableCopies
after insert on issues
for each row

begin
         
    update book
    set availableCopies = availableCopies - 1
    where bookId = new.bookId;

end //

delimiter ;

insert into issues values
    ('i06', 'b01', 'm05', '2001-03-01', '2001-04-01');

select * from book;

-- Create an index for book title

create index idx_bookTitle
on book(title);

show index from book;

-- Rank Books by Number of Times Issued

select 
    book.bookId,
    book.title,
    count(issues.bookId) as totalIssued,

    rank() over(
        order by count(issues.bookId) desc
    ) as rankNumber

from book

join issues
on book.bookId = issues.bookId

group by book.bookId, book.title;