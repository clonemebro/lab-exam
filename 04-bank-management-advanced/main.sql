-- Create the following tables
-- Customer (CustomerID, Name, Address, Phone)
-- Account (AccountID, CustomerID, Balance, AccountType)
-- Transactions (TransactionID, AccountID, Amount, Type, Date)
-- Branch (BranchID, BranchName, Location)

create table customer(
    customerId varchar(10) primary key,
    name varchar(30) not null,
    address varchar(50) not null, 
    phone varchar(20) not null
);

create table account(
    accountId varchar(20) primary key,
    customerId varchar(10) not null,
    balance double(10, 2) not null,
    accountType varchar(10) not null,

    foreign key(customerId)
    references customer(customerId)
);

create table transactions(
    transactionId varchar(20) primary key,
    accountId varchar(20) not null,
    amount double(10, 2) not null,
    type varchar(10) not null,
    date date not null,

    foreign key(accountId)
    references account(accountId)
);

create table branch(
    branchId varchar(20) primary key,
    branchName varchar(20) not null,
    Location varchar(50) not null
);

-- Insert data

insert into customer values
    ('c01', 'customer1', 'address1', '0123456789'),
    ('c02', 'customer2', 'address2', '1234567890'),
    ('c03', 'customer3', 'address3', '2345678901'),
    ('c04', 'customer4', 'address4', '3456789012'),
    ('c05', 'customer5', 'address5', '4567890123');

insert into account values
    ('a01', 'c01', 1000, 'savings'),
    ('a02', 'c02', 2000, 'savings'),
    ('a03', 'c03', 3000, 'savings'),
    ('a04', 'c04', 40000, 'current'),
    ('a05', 'c05', 50000, 'current');

insert into transactions values
    ('t01', 'a01', 500, 'debit', '2001-01-01'),
    ('t02', 'a02', 1000, 'credit', '2001-01-02'),
    ('t03', 'a03', 2000, 'debit', '2001-01-03'),
    ('t04', 'a04', 20000, 'debit', '2001-01-04');

insert into branch values
    ('b01', 'branch1', 'location1'),
    ('b02', 'branch2', 'location2'),
    ('b03', 'branch3', 'location3'),
    ('b04', 'branch4', 'location4'),
    ('b05', 'branch5', 'location5');

-- Display balance after each transaction

select 
    transactions.transactionId,
    transactions.accountId,
    transactions.type,
    transactions.amount,
    account.balance

    from transactions

    join account
    on transactions.accountId = account.accountId;

-- Find Accounts with No Transactions

select * from account
    where accountId not in(select accountId from transactions);

-- Detect High Value Transactions

select * from transactions
    where amount > 10000;

-- Display Monthly Transaction Summary

-- before writing sql query, let's add new values to the transaction table

insert into transactions values
    ('t05', 'a01', 1000, 'credit', '2001-02-01'),
    ('t06', 'a02', 5000, 'credit', '2001-02-02'),
    ('t07', 'a03', 500, 'debit', '2001-03-03'),
    ('t08', 'a04', 32000, 'credit', '2001-03-04');

select 
    month(date) as month,
    sum(amount) as totalTransaction

from transactions
group by month(date);

-- Find Customers with Multiple Accounts
-- before writing query, let's add a customer with multiple accounts

insert into customer values('c06', 'customer6', 'address6', '5678901234');

insert into account values
    ('a06', 'c06', 125000, 'current'),
    ('a07', 'c06', 32000, 'savings');

select 
    customer.name,
    count(accountId) as totalAccounts

from customer
join account
on customer.customerId = account.customerId

group by customer.customerId, customer.name
having count(accountId) > 1;

-- Second Highest Balance Account

select * from account
order by balance desc

limit 1 offset 1;

/* Below is another way to do it

select
    max(balance) as secondHighestBalance from account
    where balance < (select max(balance) from account);

*/

-- Rank Accounts by Balance

select 
    account.accountId,
    account.balance,

    rank() over(
        order by balance desc
    ) as rankNumber

from account;

-- Branch-wise Average Balance

-- Since Branch table is not connected to Account table in the given schema,
-- branch-wise balance cannot be calculated properly without a relationship.

-- Alternative total average balance:

select avg(balance) as averageBalance
from account;

-- Customers with No Withdrawals

select 
    distinct customer.name

from customer

join account
on customer.customerId = account.customerId

where account.accountId not in(

    select accountId
    from transactions
    where type = 'debit'

);