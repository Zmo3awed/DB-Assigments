--Question 1 — Count Patients per Ward
--Display the number of patients assigned to each ward.
SELECT WardId , COUNT(ID)
FROM Patients 
GROUP BY WardId

--Question 2 — Calculate the Average Consultant Salary
--Display the average salary of all consultants.
SELECT AVG(Salary)
FROM Consultants

--Question 3 — Display Salary Statistics for Consultants
--Display the minimum, maximum, average, and total consultant salaries.

SELECT AVG(Salary) ,MIN(SALARY), MAX(SALARY)
FROM Consultants


--Question 4 — Count Patients by Ward
--Display the ward ID and number of patients in each ward, sorted from highest to lowest.

SELECT WardId , COUNT(ID)
FROM Patients 
GROUP BY WardId
ORDER BY WardId DESC

--Question 5 — Medication Quantity per Patient
--Display the total medication quantity administered to each patient.

SELECT PatientId , SUM(DRUGCODE) 'Medication Quantity'
FROM DrugAdministrations 
GROUP BY PatientId

--Question 6 — Medication Administrations per Patient
--Display each patient ID together with the number of medication administrations they received.

SELECT PatientId , COUNT(DRUGCODE) 
FROM DrugAdministrations 
GROUP BY PatientId


--Question 7 — Patients per Ward with Ward Names
--Display every ward together with the number of patients assigned to it, including wards with no patients.

SELECT W.Name 'WARD NAME' , COUNT(P.Id) 'patients assigned to'
FROM Patients P RIGHT JOIN Wards W
ON P.WardId = W.Id
GROUP BY W.Name


--Question 8 — Average Nurse Salary per Ward
--Display each ward together with the average salary of nurses serving in that ward.
 
 SELECT ServesInWardId ,AVG(Salary)
 FROM Nurses 
 GROUP BY ServesInWardId

-- Question 9 — Wards with More Than 3 Patients
--Display wards that have more than 3 patients.

SELECT WardId , COUNT(ID)
FROM Patients 
GROUP BY WardId
HAVING COUNT(ID) > 3

--Question 10 — Patients with More Than 5 Medication Administrations
--Display patients who received medication more than 5 times.

SELECT PatientId , COUNT(DRUGCODE) 
FROM DrugAdministrations 
GROUP BY PatientId
HAVING COUNT(DRUGCODE) > 5

--Question 11 — Consultants Above Average Salary
--Display consultants whose salary is greater than the average consultant salary.

SELECT  NAME 
FROM Consultants
WHERE Salary > 
(
SELECT AVG(Salary)
FROM Consultants
)
--Question 12 — Nurses Above Average Salary
--Display nurses whose salary is greater than the average nurse salary.


SELECT  NAME 
FROM NURSES
WHERE Salary > 
(
SELECT AVG(Salary)
FROM NURSES
)
--Question 13 — Patients in the Largest Ward
--Display patients who belong to the ward containing the largest number of patients.

SELECT NAME 
FROM Patients 
WHERE WardId =
(
SELECT MAX(WardId)
FROM Patients
)

--Question 14 — Consultants with the Maximum Salary
--Display the consultant or consultants who have the highest salary.

SELECT NAME
FROM Consultants 
WHERE Salary =
(
SELECT MAX(Salary)
FROM Consultants
)

--Question 15 — Patients Who Received Medication
--Display patients who have at least one medication administration.

SELECT P.Id, P.Name
FROM Patients P
JOIN DrugAdministrations D
ON P.Id = D.PatientId;

--Question 16 — Patients Who Never Received Medication
--Display patients who have never received any medication.

SELECT P.Id, P.Name , D.*
FROM Patients P LEFT JOIN DrugAdministrations D
ON P.Id = D.PatientId
WHERE D.PatientId IS NULL

--Question 17 — Count Medication Administrations per Patient
--Display every patient together with the number of medication administrations they received.
--Question 18 — Total Medication Quantity per Patient
--Display every patient together with the total medication quantity administered to them.


--Question 19 — Derived Table for Consultant Salaries
--Create a derived table containing the average consultant salary, then display consultants whose salary is above that average.
--Question 20 — Patients with Above-Average Medication Quantity
--Display patients whose total medication quantity is greater than the average total medication quantity across patients who received medication.

--Question 20 — Patients with Above-Average Medication Quantity
--Display patients whose total medication quantity is greater than the average total medication quantity across patients who received medication.

SELECT P.Name, COUNT(*) AS TotalMedication
FROM Patients P
JOIN DrugAdministrations D
    ON P.Id = D.PatientId
GROUP BY P.Id, P.Name
HAVING COUNT(*) >
(
    SELECT AVG(TotalMedication * 1.0)
    FROM
    (
        SELECT PatientId, COUNT(*) AS TotalMedication
        FROM DrugAdministrations
        GROUP BY PatientId
    ) AS T
)


--Question 21 — Create a Patient Backup
--Create a new table containing all patients.


SELECT *
INTO PatientsBackup
FROM Patients

--Question 22 — Create a Basic Patient Information Table
--Create a new table containing only patient ID, name, and date of birth.

SELECT ID ,NAME,DOB
INTO PatientInformation 
FROM Patients 

--Question 23 — Create a Consultant Salary Report
--Create a new table containing consultant ID, name, and salary.

SELECT ID ,NAME ,Salary
INTO ConsultantSalaryReport
FROM Consultants 

--Question 24 — Create a Patient-Ward Report
--Create a new table containing each patient together with the ward they belong to.

SELECT ID ,Name ,WardId
INTO PatientWardReport
FROM Patients 

--Question 25 — Create a Patient-Consultant Report
--Create a new table containing patients and their assigned consultants.

SELECT  P.* ,C.Name 'CONSULTANT NAME'
INTO PatientConsultantReport
FROM Patients P, PatientExaminations PE , Consultants C
WHERE P.Id = PE.PatientId AND PE.ConsultantId = C.Id


--Question 26 — Create a High-Salary Consultant Table
--Create a new table containing consultants whose salary is greater than 50000.

SELECT *
INTO HighSalary 
FROM Consultants
WHERE Salary > 50000

--Question 27 — Create a Young Patients Table
--Create a new table containing patients born after January 1, 2000.

SELECT *
INTO YoungPatients 
FROM Patients
WHERE DOB > '1-1-2000'


--Question 28 — Create a High-Salary Nurse Report
--Create a new table containing nurses earning more than 30000 together with the ward they serve in.

SELECT NAME ,ServesInWardId
INTO HighSalaryNurse
FROM Nurses
WHERE Salary > 30000

--Question 29 — Create a Ward Patient Summary
--Create a new table containing each ward and its patient count.

SELECT WardId , COUNT(ID) 'NUM OF PATIONTS'
INTO WardPationtsSamary
FROM Patients 
GROUP BY WardId


--Question 30 — Create a Patient Medication Summary
--Create a new table containing each patient and their total medication quantity.

SELECT PatientId , SUM(DRUGCODE) 'Medication Quantity'
INTO PatientMedicationSummary
FROM DrugAdministrations 
GROUP BY PatientId


--Question 31 — Calculate Patient Age
--Create a scalar function that receives a date of birth and returns the patient's age.
GO
CREATE OR ALTER FUNCTION CalcAge (@DOB DATE)
RETURNS INT
AS
BEGIN
RETURN DATEDIFF(YEAR, @DOB, GETDATE())
END
GO
--Question 32 — Calculate Annual Salary
--Create a scalar function that receives a monthly salary and returns the annual salary.
CREATE OR ALTER FUNCTION CalcAnnualSalary (@monthly DECIMAL(10,2))
RETURNS DECIMAL (10,2)
AS
BEGIN
RETURN @monthly * 12
END
GO

--Question 33 — Calculate Medication Cost
--Create a scalar function that receives quantity and unit price and returns the total medication cost.

CREATE OR ALTER FUNCTION CalculateMedicationCost (@quantity INT ,@price DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
RETURN @quantity *@price
END
GO



--Question 34 — Get Patients by Ward
--Create an inline table-valued function that receives a ward ID and returns all patients in that ward.

CREATE OR ALTER FUNCTION GetPatientsbyWard(@WARDID INT)
RETURNS TABLE 
AS 
RETURN 
(
SELECT NAME  
FROM Patients
WHERE WardId = @WARDID
)
GO

SELECT *
FROM DBO.GetPatientsbyWard(1)
--Question 35 — Get Consultants by Minimum Salary
--Create an inline table-valued function that receives a minimum salary and returns consultants whose salary is greater than or equal to it.

GO
CREATE OR ALTER FUNCTION GetConsultantsbyMinimumSalary(@MINSALARY DECIMAL(10,2))
RETURNS TABLE 
AS 
RETURN 
(
SELECT NAME 
FROM Consultants
WHERE SALARY >= @MINSALARY
)

--Question 36 — Get Patients with Their Ward
--Create an inline table-valued function that receives a ward ID and returns patients together with their ward name.

GO
CREATE OR ALTER FUNCTION GetPatientsWithWard(@WARDID INT)
RETURNS TABLE 
AS 
RETURN 
(
SELECT p.Name , W.Name 'WARD NAME'
FROM Patients p INNER JOIN Wards w
ON P.WardId = W.ID
WHERE P.WardId = @WARDID
)
GO
SELECT *
FROM DBO.GetPatientsWithWard(1)
--Question 37 — Get Patients Above a Specific Age
--Create a multi-statement table-valued function that receives a minimum age and returns patients who are at least that age.
GO
CREATE OR ALTER FUNCTION GetPatientsAboveSpecificAge (@MinAge INT)
RETURNS @PatientsAbove TABLE
(
    ID INT PRIMARY KEY,
    Name VARCHAR(20),
    Age INT
)
AS
BEGIN

    INSERT INTO @PatientsAbove (ID, Name, Age)
    SELECT 
        ID,
        Name,
        DATEDIFF(YEAR, DOB, GETDATE())
    FROM Patients
    WHERE DATEDIFF(YEAR, DOB, GETDATE()) >= @MinAge;

    RETURN;
END
GO

--Question 38 — Get Patient Medication Summary
--Create a multi-statement table-valued function that receives a patient ID and returns the total medication quantity and number of medication administrations.
--Question 39 — Classify Consultant Salaries
--Create a multi-statement table-valued function that receives a minimum salary and returns consultants with a salary classification.
CREATE OR ALTER FUNCTION ClassifyConsultantSalaries(@MinSalary DECIMAL(10,2))
RETURNS @ClassifyConsultants TABLE
(
ID INT PRIMARY KEY, 
NAME VARCHAR(10),
SALARY DECIMAL(10,2)
)
AS 
BEGIN
INSERT INTO @ClassifyConsultants (ID ,NAME ,SALARY)
SELECT ID , NAME , Salary
FROM Consultants
WHERE Salary >@MINSALARY
RETURN;
END
GO

--Question 43 — Create a Consultant Salary Report Using a Scalar Function
--Create a new table containing each consultant's name, monthly salary, and annual salary.

SELECT NAME , SALARY , DBO.CalcAnnualSalary(SALARY) 'ANNUAL SALARY'
INTO ConsultantSalaryReport2
FROM Consultants

--Question 44 — Use an Inline TVF with a Filter
--Using GetConsultantsByMinimumSalary, display consultants whose salary is at least 50000 and whose name starts with A.
SELECT Name
FROM dbo.GetConsultantsByMinimumSalary(5000)
WHERE Name LIKE 'Dr. A%'

--Question 45 — Use a Multi-Statement TVF
--Using GetPatientsWithAge, display patients who are at least 30 years old and order them from oldest to youngest.
SELECT NAME ,AGE
FROM DBO.GetPatientsAboveSpecificAge(30)
ORDER BY AGE DESC

--Question 46 — Final Hospital Patient Summary
--Display patient ID, patient name, ward name, patient age, number of medication administrations, and total medication quantity. Use the existing tables and CalculatePatientAge.
GO
SELECT P.Id ,P.Name , W.Name 'WARD NAME' , DBO.CalcAge(P.DOB) AS 'PATIENT AGE'
,COUNT(DA.DrugCode) 'NUMBER OF MEDCATION ' 
FROM Patients P ,Wards W , DrugAdministrations DA
WHERE P.WardId = W.ID AND DA.PatientId = P.Id
GROUP BY P.Id ,P.Name , W.Name , DBO.CalcAge(P.DOB)

