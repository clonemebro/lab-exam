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
    ('t04', 'a04', 20000, 'debit', '2001-01-04'),
    ('t05', 'a05', 10000, 'credit', '2001-01-05');

insert into branch values
    ('b01', 'branch1', 'location1'),
    ('b02', 'branch2', 'location2'),
    ('b03', 'branch3', 'location3'),
    ('b04', 'branch4', 'location4'),
    ('b05', 'branch5', 'location5');

-- View all accounts

select * from account;

-- Display customer account details

select 
    customer.name,
    account.accountId,
    account.balance,
    account.accountType

    from customer

    join account
    on customer.customerId = account.customerId;

-- Display transaction details

select * from transactions;

-- Display Total Balance per Branch

-- Since Branch table is not connected with Account table in the question,
-- a direct branch-wise balance is not possible without relationship data.

select sum(balance) as totalBalance from account;

-- Display High Value Transactions

select * from transactions
    where amount > 10000;

-- Create a view that displays customer name, account, and balance

create view customerAccountSummary as
    select 
        customer.name,
        account.accountId,
        account.balance

    from customer

    join account
    on customer.customerId = account.customerId;

select * from customerAccountSummary;

-- Create an index on accound id

create index idx_accountId
    on account(accountId);

show index from account;

-- Create a trigger that automatically increases or decreases the account balance
-- based on deposit or withdrawal transactions

delimiter //

create trigger updateBalance
after insert on transactions
for each row

    begin

        if new.type = 'debit' then
            
            update account
            set balance = balance - new.amount
            where accountId = new.accountId;
        
        elseif new.type = 'credit' then

            update account
            set balance = balance + new.amount
            where accountId = new.accountId;

        end if;

    end //

delimiter ;

insert into transactions values('t06', 'a05', 5000, 'debit', '2001-01-06');

select * from account;

-- Find Top 3 Customers by Total Balance

select 
    customer.name,
    account.balance

from customer

join account
on customer.customerId = account.customerId

order by account.balance desc

limit 3;