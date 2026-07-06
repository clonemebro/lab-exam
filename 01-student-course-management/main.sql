-- Create Student and Course tables
create table student(
    id int primary key,
    name varchar(50),
    age int,
    department varchar(50),
    marks float
);

create table course(
    courseId int primary key,
    courseName varchar(50),
    studentId int
);

-- Insert at least 5 records into the table

insert into student values
    (001, 'name1', 20, 'mca', 95),
    (002, 'name2', 21, 'mca', 90),
    (003, 'name3', 22, 'msc cs', 85),
    (004, 'name4', 23, 'msc cs', 97), 
    (005, 'name5', 24, 'mba', 72),
    (006, 'name6', 25, 'mba', 92),
    (007, 'name7', 26, 'msc physics', 75);

insert into course values
    (01, 'course1', 001),
    (02, 'course2', 003),
    (03, 'course3', 005),
    (04, 'course4', 007),
    (05, 'course5', 004);

-- Find students with marks greater than 80

select name from student
    where marks > 80;

-- Find students belonging to 'mca' department.

select name from student
    where department = 'mca';

-- Find students whose name starts with 'A'

insert into student values
    (008, 'aName', 27, 'msc physics', 92);

select name from student
    where name like 'a%';

-- Find departments with average marks > 75

select department, avg(marks) from student
    group by department
    having avg(marks) > 75;

-- Find students who are not enrolled in any course

select name from student
    left join course
    on student.id = course.studentId
    where course.studentId is null;

-- Create a view for students with marks > 75

create view highMarks as
    select * from student
    where marks > 75;

select * from highMarks;

-- Write a function to calculate grade

delimiter //

create function getGrade(mark int)

    returns varchar(2)
    deterministic

    begin 

    declare grade varchar(2);

    if mark > 90 then 
        set grade = 'A';
    elseif mark > 75 then 
        set grade = 'B';
    elseif mark > 60 then 
        set grade = 'C';
    else 
        set grade = 'F';

    end if;

    return grade;

end //

delimiter ;

select getGrade(94);

-- Write a trigger for automatic update on insert

delimiter //

create trigger before_insert_students
    
    before insert on student
    for each row
    begin
        set new.marks = ifnull(new.marks, 0);
    end
    //

delimiter ;

insert into student(id, name, age, department) values(010, 'name10', 29, 'msc cs');

-- Create an index on student name

create index idx_name
    on student(name);

-- Count students in each department having more than 2 students

select department, count(*) from student
    group by department
    having count(*) > 2;