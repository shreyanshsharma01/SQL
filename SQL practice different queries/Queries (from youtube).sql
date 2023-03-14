CREATE DATABASE practicequeries;
USE practicequeries;

CREATE TABLE Department (
  dept_id INT NOT NULL PRIMARY KEY,
  dept_name VARCHAR(50) NOT NULL
);

CREATE TABLE Manager (
  manager_id INT NOT NULL PRIMARY KEY,
  manager_name VARCHAR(50) NOT NULL,
  city VARCHAR(50) NOT NULL
);

CREATE TABLE Employee (
  emp_id INT NOT NULL PRIMARY KEY,
  emp_name VARCHAR(50) NOT NULL,
  salary DECIMAL(10, 2) NOT NULL,
  city VARCHAR(50) NOT NULL,
  dept_id INT NOT NULL,
  manager_id INT NOT NULL,
  FOREIGN KEY (dept_id) REFERENCES Department(dept_id),
  FOREIGN KEY (manager_id) REFERENCES Manager(manager_id)
);

--#1 Find the name of the department where more than two employees are working
	SELECT d.dept_name
    FROM Department d LEFT JOIN Employee e
    ON d.dept_id = e.dept_id
    GROUP BY e.dept_id
    HAVING COUNT(e.dept_id)>2;

--#2 Calculate average salary of each dept which is higher than 75000,find dept_name in desc order
	SELECT d.dept_name,AVG(e.salary)
    FROM employee e LEFT JOIN department d 
    ON e.dept_id = d.dept_id
    GROUP BY e.dept_id
    HAVING AVG(e.salary) > 75000
    ORDER BY d.dept_name DESC;

--#3 Find manager & employee who belongs to same city
	SELECT e.emp_name,m.manager_name,e.city
    FROM Employee e LEFT JOIN Manager m 
    ON e.manager_id = m.manager_id
    WHERE e.city = m.city; 

--#4 Find those employee whose salary exists bw 35000 & 90000 with manager_name & dept_name
	SELECT 
    e.emp_name, e.salary, d.dept_name, m.manager_name
FROM
    Employee e
        INNER JOIN
    Department d ON e.dept_id = d.dept_id
        INNER JOIN
    Manager m ON m.manager_id = e.manager_id
WHERE
    e.salary BETWEEN 35000 AND 90000
    
--#5 Select the total salary paid by each department 
	select d.dept_name,sum(e.salary) as Total_salary
    from department d inner join employee e 
    on d.dept_id = e.dept_id
    group by d.dept_name
    
--#6 Select the employee names and their manager name for all employees who work in a department with "HR" in the department name
	select e.emp_name,m.manager_name,d.dept_name
    from employee e inner join manager m
    on e.manager_id = m.manager_id INNER JOIN department d 
    on e.dept_id = d.dept_id
    where d.dept_name like '%HR%'

--#7 Select the employee names and their salary who earn more than the average salary of their department:
	select emp_name,salary
    from employee 
    where salary > all (
		  select avg(salary)
          from employee 
          group by dept_id
	);
    select emp_name,salary
    from employee 
    where salary > (
		  select avg(salary)
          from dept_id = employee.dept_id
	);
    select e.emp_name,e.salary
    from employee e inner join (
		select dept_id,avg(salary) as avg_salary
        from employee 
        group by dept_id )
        as dept_avg 
        on e.dept_id = dept_avg.dept_id
        AND e.salary > dept_avg.avg_salary 
        where e.salary < (select avg(salary) from employee);

--#8 Select the employee names and their salary who earn more than the average salary of their department & less than the overall average.
	select emp_name,salary
    from employee 
    where salary > ALl(
		  select avg(salary)
          group by dept_id
	) AND salary < (select avg(salary) from employee );

--#9 Select the department names and the total number of employees whose manager is based in "Banglore"
	select d.dept_name,count(e.emp_name) as Total_emps,m.city
    from department d inner join employee e
    on d.dept_id = e.dept_id inner join manager m 
    on e.manager_id = m.manager_id 
    where m.city = 'Banglore'
    group by d.dept_name;
    # using subqueries 
    select d.dept_name,count(e.emp_name) as Total_emps
    from employee e join department d 
    on e.dept_id = d.dept_id
    where e.manager_id IN (select manager_id from manager
						  where city = 'Banglore')
	group by d.dept_name;
    
--#10 Select the manager names and their average employee salary for managers who have at least two employees reporting to them.
	select m.manager_name,avg(e.salary) as AVG_Emp_sal
    from manager m LEFT JOIN employee e 
    on m.manager_id = e.manager_id
    group by m.manager_name
    having count(e.emp_id)>=2;
    
    SELECT m.manager_name, AVG(e.salary) as avg_salary
    FROM Employee e
    JOIN Manager m ON e.manager_id = m.manager_id
    WHERE m.manager_id IN (
      SELECT manager_id
      FROM Employee
      GROUP BY manager_id
    )
    GROUP BY m.manager_name;
    