-- Create tables
-- Customer (CustomerID, Name, Email, Phone)
-- Product (ProductID, ProductName, Price, Stock)
-- Orders (OrderID, CustomerID, OrderDate)
-- OrderDetails (OrderID, ProductID, Quantity)
-- Payment (PaymentID, OrderID, Amount, Status)

create table customer(
    customerId varchar(10) primary key, 
    name varchar(20) not null,
    email varchar(30) unique, 
    phone varchar(20)
);

create table product(
    productId varchar(10),
    productName varchar(20),
    price decimal(10, 2),
    stock int
);

create table orders(
    orderId varchar(10),
    customerId varchar(10),
    OrderDate date
);

create table orderDetails(
    orderId varchar(10),
    productId varchar(10),
    quantity int
);

create table payment(
    paymentId varchar(10),
    orderId varchar(10),
    amount decimal(10, 2),
    status varchar(20)
);

-- Insert data

insert into customer values
    ('c01', 'customer1', 'customer1@gmail.com', '0123456789'),
    ('c02', 'customer2', 'customer2@gmail.com', '1234567890'),
    ('c03', 'customer3', 'customer3@gmail.com', '2345678901'),
    ('c04', 'customer4', 'customer4@gmail.com', '3456789012'),
    ('c05', 'customer5', 'customer5@gmail.com', '4567890123');

insert into product values
    ('p01', 'product1', 399, 700),
    ('p02', 'product2', 499, 600),
    ('p03', 'product3', 599, 500),
    ('p04', 'product4', 699, 400),
    ('p05', 'product5', 799, 300);

insert into orders values
    ('o01', 'c01', '2001-01-01'),
    ('o02', 'c02', '2001-02-01'),
    ('o03', 'c03', '2001-03-01'),
    ('o04', 'c04', '2001-04-01'),
    ('o05', 'c05', '2001-05-01');

insert into orderDetails values
    ('o01', 'p01', 30),
    ('o02', 'p01', 40),
    ('o03', 'p02', 50),
    ('o04', 'p02', 60),
    ('o05', 'p03', 70);

insert into payment values
    ('py01', 'o01', 11970, 'paid'),
    ('py02', 'o02', 15960, 'paid'),
    ('py03', 'o03', 24950, 'pending'),
    ('py04', 'o04', 29940, 'pending'),
    ('py05', 'o05', 41930, 'paid');

-- View all products

select * from product;

-- List Customer Orders with Product Details

select 
    customer.name, 
    orders.orderId,
    product.productName,
    orderDetails.quantity

    from customer
        join orders
        on customer.customerId = orders.customerId
        join orderDetails
        on orders.orderId = orderDetails.orderId
        join product
        on product.productId = orderDetails.productId;

-- Display Total Order Amount per Customer

select customer.name, sum(orderDetails.quantity * product.price) as amount
    from customer
    join orders
    on customer.customerId = orders.customerId
    join orderDetails
    on orders.orderId = orderDetails.orderId
    join product
    on product.productId = orderDetails.productId
    group by customer.name;

-- Display Products with Low Stock

select productName, stock from product
    where stock < 500;

-- Display Paid Orders

select * from payment
    where status = 'paid';

-- Create a view that gives a combined summary of customers, their orders, and products

create view customerOrderSummary as
    select 
        customer.name,
        orders.orderId, 
        product.productName, 
        orderDetails.quantity,
        payment.amount,
        payment.status

    from customer

    join orders
    on customer.customerId = orders.customerId

    join orderDetails
    on orderDetails.orderId = orders.orderId

    join product
    on product.productId = orderDetails.productId

    join payment
    on payment.orderId = orderDetails.orderId;

select * from customerOrderSummary;

-- Create a trigger that automatically updates (reduces) product stock when an order is placed

delimiter //

create trigger updateStock
after insert on orderDetails
for each row

begin 
   
    update product
    set stock = stock - new.quantity
    where productId = new.productId;

end //

delimiter ;

insert into orders values('o06', 'c01', '2001-06-01');
insert into orderDetails values('o06', 'p01', 30);
insert into payment values('py06', 'o06', 11970, 'pending');

select * from product;

-- Create index on ProductName column

create index idx_ProductName
    on product(productName);

show index from product;