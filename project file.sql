------------------------------DATABASE----------------------------------

USE project;

--------------------------MAIN--TABLE-----------------------------------

SELECT * FROM Employee_Productivity;

------------------------DEPARTMENT--TABLE-------------------------------

CREATE TABLE Department_Table(
    Employee_ID INT PRIMARY KEY,
    Department VARCHAR(50),
	constraint Department_Key foreign key(Employee_ID) 
	references Employee_Productivity(Employee_ID)
);

SELECT * FROM Department_Table;

INSERT INTO Department_Table (Employee_ID, Department)
SELECT  Employee_ID, Department
FROM Employee_Productivity;

-----------------------EMPLOYEE--TABLE----------------------------------

CREATE TABLE Employees(
	Employee_ID INT PRIMARY KEY,
	Employee_Name varchar(50),
	Manager_ID INT,
	constraint Employees_Key foreign key(Employee_ID) 
	references Employee_Productivity(Employee_ID)
);

SELECT*FROM Employees;

INSERT INTO Employees(Employee_ID,Employee_Name,Manager_ID)
SELECT Employee_ID,Employee_Name,Manager_ID 
FROM Employee_Productivity;

EXEC sp_rename Employees, Employees_Table;

SELECT*FROM Employees_Table;

------------------------COUNTRY--TABLE-----------------------------------

CREATE TABLE Country(
	Employee_ID INT PRIMARY KEY,
	Country VARCHAR(50),
	CONSTRAINT Country_Key FOREIGN KEY(Employee_ID) REFERENCES Employee_Productivity(Employee_ID)
);

SELECT * FROM Country;

INSERT INTO Country(Employee_ID,Country)
SELECT Employee_ID,Country 
FROM Employee_Productivity;

EXEC sp_rename Country, Country_Table;

SELECT * FROM Country_Table;

--------------------------SALARY--TABLE---------------------------------

CREATE TABLE Salary_Table(
	Employee_ID INT PRIMARY KEY,
	Salary INT,
	CONSTRAINT Salary_Key FOREIGN KEY(Employee_ID) REFERENCES Employee_Productivity(Employee_ID)
);

SELECT * FROM Salary_Table;

INSERT INTO Salary_Table(Employee_ID,Salary)
SELECT Employee_ID,Salary_USD 
FROM Employee_Productivity;

-----------------------EXPERIENCE--TABLE-----------------------------

CREATE TABLE Experience_Table(
	Employee_ID INT PRIMARY KEY,
	Experience INT
	CONSTRAINT Experience_Key FOREIGN KEY(Employee_ID) REFERENCES Employee_Productivity(Employee_ID)
);

SELECT * FROM Experience_Table;

INSERT INTO Experience_Table(Employee_ID,Experience)
SELECT Employee_ID,Experience_Years 
FROM Employee_Productivity;

--------------------------------------------------------------------------------------
-------------List-All-Departments-and-The-Total-Number-Of-Employees-In-Each-----------
--------------------------------------------------------------------------------------

---METHOD-1---
SELECT Department, COUNT(Employee_Name) AS Employees
FROM Employee_Productivity
GROUP BY Department;

---METHOD-2---
SELECT DISTINCT D.Department, E.Employee FROM
Department_Table AS D
JOIN(
	SELECT Department, count(Employee_Name) AS Employee
	FROM Employee_Productivity
	GROUP BY Department) AS E
ON D.Department = E.Department;

---METHOD-3---
WITH Dept_Count AS (
    SELECT Department, COUNT(Employee_Name) AS Employees
    FROM Employee_Productivity
    GROUP BY Department
)
SELECT DISTINCT D.Department, DC.Employees
FROM Department_Table D
JOIN Dept_Count DC
    ON D.Department = DC.Department;

---------------------------------------------------------------------------------------
------------------Top-5-Employees-Highest-Productivity-Score---------------------------
---------------------------------------------------------------------------------------

WITH EMP AS(
	SELECT Employee_Name, MAX(Productivity_Score) AS Max_Scores
	FROM Employee_Productivity
	GROUP BY Employee_Name
)
SELECT  E.Employee_Name, P.Max_Scores FROM 
(SELECT DISTINCT Employee_Name FROM Employees_Table) AS E
JOIN 
EMP AS P
ON E.Employee_Name = P.Employee_Name
ORDER BY Max_Scores DESC
;

----------------------------------------------------------------------------------
-------------Retrieve-List-Of-Unique-Countries-Count-Of-Employees-----------------
----------------------------------------------------------------------------------

SELECT C.Country AS Countries, COUNT(E.Employee_Name) AS Total_Employees FROM
Employees_Table E
INNER JOIN
Country_Table C
ON C.Employee_ID = E.Employee_ID
GROUP BY C.Country;

-------------------------------------------------------------------------------------
----Employees with more than 10 years of experience and Technical_Skill above 90-----
-------------------------------------------------------------------------------------

SELECT Employee_Name, Experience_Years, Technical_Skill_Score
FROM Employee_Productivity
WHERE Experience_Years > 10 AND Technical_Skill_Score > 90
ORDER BY Technical_Skill_Score DESC;

--------------------------------------------------------------------------------------
------------------------Average-Metrics-By-Department---------------------------------
--------------------------------------------------------------------------------------

SELECT D.Department, AVG(E.Productivity_Score) Average_Productivity_Score, AVG(S.Salary) Average_Salary , AVG(E.Technical_Skill_Score) Average_Technical_Skill_Score
FROM Employee_Productivity E
JOIN
Department_Table D
	ON E.Employee_ID = D.Employee_ID
JOIN
Salary_Table S
	ON D.Employee_ID = S.Employee_ID
GROUP BY D.Department
;

--------------------------------------------------------------------------------------------
---------------------------SELF-JOIN-Employee--and--Manager---------------------------------
--------------------------------------------------------------------------------------------

SELECT OLD.Employee_Name, NEW.Employee_Name
FROM Employees_Table OLD
LEFT JOIN
Employees_Table NEW
ON OLD.Manager_ID = NEW.Employee_ID;

---------------------------------------------------------------------------------------------
-------------------------Underpaid-High-Performers-------------------------------------------
---------------------------------------------------------------------------------------------

SELECT Employee_Name, Productivity_Score, Salary_USD
FROM Employee_Productivity
WHERE Productivity_Score > (
				SELECT AVG(Productivity_Score) Average_Score 
				FROM Employee_Productivity
			)
AND Salary_USD > (
				SELECT AVG(Salary_USD) Average_Salary 
				FROM Employee_Productivity
			);

--------------------------------------------------------------------------------
----------------------Second-Highest-Salary-------------------------------------
--------------------------------------------------------------------------------

CREATE VIEW Second_Highest AS
SELECT Employee_Name, Department, Experience_Years FROM (
	SELECT *,
	ROW_NUMBER() OVER(PARTITION BY Department ORDER BY Salary_USD DESC) Sh
	FROM Employee_Productivity
	) as s
	where sh = 2;

SELECT * FROM Second_Highest;
