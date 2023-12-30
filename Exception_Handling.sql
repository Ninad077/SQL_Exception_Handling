-- Exception handling
-- Exception are abnormalities or unwanted events. 
-- They can be handled by declaring a handler and displaying an error or Warning message.


-- Exception Handling by Exit Handler
-- Exit handler will exit the store procedure if the select statement is invalid
Delimiter //
create procedure test()
	begin
		Declare exit handler for 1146
        select 'table does not exist!' message;
        select * from students;
        select * from customers;
    end //
Delimiter ;

call test();


-- Exception Handling by Continue Handler
-- Continue handler will continue the store procedure and check for the next select statement if the previous select statement is invalid
Delimiter //
create procedure test1()
	begin
		Declare continue handler for 1146
        select 'table does not exist!' message;
        select * from students;
        select * from customers;
    end //
Delimiter ;

call test1();


-- SQLEXCEPTION
-- SQLEXCEPTION is a keyword if the exception type is SQLNOTFOUND, SQLSTATE and SQLWARNING
-- In the following query Emp_id from customer is Primary key
-- and Emp_id=4 alread exists so since we used continue handler it will execute the next query
DELIMITER //
CREATE procedure test2()
BEGIN
	DECLARE CONTINUE handler for sqlexception
    select 'CHECK ERROR!' message;

	insert into employee(Emp_id,Emp_Name,Address,Age) values
    (4,"SHYAM","WEST",27);
    select * from customers;

END//
DELIMITER ;

call test2();


-- IS ERROR
-- IS ERROR will not display any error in event of an exception.
-- However it will set the flag @IsError=1
DELIMITER //
CREATE PROCEDURE InsertEmployeeDetails
(
	InputEmpID INTEGER,
    InputEmpName VARCHAR(50),
    InputEmailAddress VARCHAR(50),
    OUT IsError INT
)
BEGIN 
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET IsError=1;
	INSERT INTO Employee(EmpID, EmpName, EmailAddress)
	VALUES
	(InputEmpID, InputEmpName, InputEmailAddress);    

END // DELIMITER ;

select * from employee; 
CALL InsertEmployeeDetails (1,'Anvesh','anvesh@gmail.com',@IsError);
SELECT @IsError;


-- Handle an exception for null values using an error message and exit handler 
drop table Emp_EH;
create table Emp_EH(
Emp_id int primary key auto_increment,
Name varchar(40) not null
);
drop procedure Emp_procedure;
Delimiter //
create procedure Emp_procedure( IN Emp_Name varchar(40))
	begin
		Declare exit handler for 1048
        select 'Dont insert null values in Employee Name!' message;
		insert into Emp_EH(Name) values(Emp_Name);
    end //
Delimiter ;

call Emp_procedure("Ninad");

