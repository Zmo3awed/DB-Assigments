--ASP.Net Course 
--Question 1 — Display All Patients
--Create a stored procedure that returns all patients.

CREATE OR ALTER PROC GETALLPATIENTS
AS
BEGIN

SELECT *
FROM Patients
END;
GO


EXEC GETALLPATIENTS 


--Question 2 — Display All Consultants
--Create a stored procedure that returns all consultants with their salaries.

--Create a stored procedure that returns all patients.
GO
CREATE OR ALTER PROC GETALLConsultants
AS
BEGIN

SELECT NAME , SALARY
FROM Consultants
END;

EXEC GETALLConsultants

--Question 3 — Display Patients with Their Wards
--Create a stored procedure that displays every patient together with the ward they belong to.

GO
CREATE OR ALTER PROC GETALLPATIENTSWITHWARDID
AS
BEGIN

SELECT P.Name , W.Name 'WARD NAME'
FROM Patients P INNER JOIN WARDS W
ON P.WardId = W.ID
END;

--Question 4 — Get Patient by ID
--Create a stored procedure that receives a patient ID and returns that patient.

GO
CREATE OR ALTER PROC GETPATIENTBYID
@ID INT
AS
BEGIN

SELECT NAME 
FROM Patients 
WHERE ID = @ID
END;

EXEC GETPATIENTBYID 299

--Question 5 — Get Consultants by Minimum Salary
--Create a stored procedure that receives a minimum salary and returns consultants whose salary is greater than or equal to it.

GO
CREATE OR ALTER PROC GETHIGHSALARYCON
@MINSALARY DECIMAL (18,2)
AS
BEGIN

SELECT NAME , SALARY
FROM Consultants
WHERE Salary>= @MINSALARY
END;
--Question 6 — Get Patients by Ward
--Create a stored procedure that receives a ward ID and returns all patients assigned to that ward.

GO
CREATE OR ALTER PROC GETPATIENTSBYWARDID
@WARDID INT 
AS
BEGIN

SELECT * 
FROM Patients
WHERE WardId = @WARDID
END;

EXEC GETPATIENTSBYWARDID 3
--Question 7 — Return Patient Count
--Create a stored procedure that returns the total number of patients through an OUTPUT parameter.


GO
CREATE OR ALTER PROC GETNUMOFPATIENTS
@RESULT INT OUT
AS
BEGIN

SELECT @RESULT = COUNT(*) 
FROM Patients
END;

DECLARE @COUNTER INT
EXEC GETNUMOFPATIENTS @COUNTER OUT 
SELECT @COUNTER
--Question 8 — Return Average Consultant Salary
--Create a stored procedure that returns the average consultant salary through an OUTPUT parameter.


GO
CREATE OR ALTER PROC GETAVGSALARY
@AVERG DECIMAL(10,2) OUT
AS
BEGIN

SELECT @AVERG = AVG(SALARY) 
FROM Consultants
END;

DECLARE @AVG DECIMAL(10,2)
EXEC GETAVGSALARY @AVG OUT 

SELECT @AVG

--Question 9 — Return Patient Medication Quantity
--Create a stored procedure that receives a patient ID and returns the total medication quantity through an OUTPUT parameter.



--Question 10 — Increase a Salary
--Create a stored procedure that receives a salary as an input-output parameter and increases it by a supplied percentage.


GO
CREATE OR ALTER PROC INCREES_SALARY
@SALARY DECIMAL(10,2) OUT,
@PERSENTEG DECIMAL(10,2)
AS
BEGIN

SET @SALARY = @SALARY + @SALARY *(@PERSENTEG/100)
END;

DECLARE @SA DECIMAL(10,2) = 10000
EXEC INCREES_SALARY @SA OUT ,50

SELECT @SA

--Question 11 — Increase Medication Quantity
--Create a stored procedure that receives a quantity as input-output and adds an additional quantity to it.
GO
CREATE OR ALTER PROC IncreaseMedicationQuantity 
@quantity DECIMAL(10,2) OUT,
@additional DECIMAL(10,2)
AS 
BEGIN
SET @quantity += @additional
END;

--Question 12 — Convert Monthly Salary to Annual Salary
--Create a stored procedure that receives a monthly salary as input-output and replaces it with the annual salary.


GO
CREATE OR ALTER PROC ConvertMonthlySalarytoAnnualSalary 
@SALARY DECIMAL(10,2) OUT
AS 
BEGIN
SET @SALARY = @SALARY *12
END;
DECLARE @MONTHLY DECIMAL(10,2) = 15000
EXEC ConvertMonthlySalarytoAnnualSalary @MONTHLY OUT
SELECT @MONTHLY 'ANUAAL SALARY'
--Question 13 — Insert Patient with Error Handling
--Create a stored procedure that inserts a patient and handles errors using TRY-CATCH.
GO
CREATE OR ALTER PROC InsertPatient
@NAME VARCHAR(30),
@DOB DATE,
@WARDID INT,
@NEWID INT OUT
AS
BEGIN
BEGIN TRY
IF @DOB > GETDATE()
    THROW 50001,'CAN NOT HAS DATE IN THE FUTCHER', 1;
IF NOT EXISTS (SELECT 1 FROM Wards WHERE ID= @WARDID)
    THROW 50002,'WARD ID NOT EXIST',1;

SELECT @NEWID = ISNULL(MAX(ID),0) +1
FROM PATIENTS

INSERT INTO Patients 
VALUES(@NEWID,@NAME,@DOB,@WARDID)
PRINT 'Patient ADDED SUCESSFULY'
END TRY 

BEGIN CATCH
SET @NEWID =NULL;
SELECT ERROR_NUMBER() ,
       ERROR_MESSAGE(),
       ERROR_LINE()
END CATCH

END;

DECLARE @NEW INT;
EXEC InsertPatient
    @NAME = 'ZYAD',
   @DOB = '2027-05-10',
    @WARDID = 3,
    @NEWID = @NEW OUTPUT;

SELECT @NEW AS NewID;



--Question 14 — Update Consultant with Error Handling
--Create a stored procedure that updates a consultant's salary and handles errors.
GO
CREATE OR ALTER PROC UpdateConsultant
@ID INT ,
@NAME VARCHAR(30) =NULL,
@SALARY DECIMAL(10,2) =NULL
AS 
BEGIN
UPDATE Consultants
SET Name = ISNULL(@NAME,NAME),
    Salary = ISNULL(@SALARY,SALARY)
WHERE ID =@ID 

IF @@ROWCOUNT >0
   PRINT 'UBDATED SUCCESSFLY'
ELSE 
   PRINT 'UBDATE FAILED'
END;

EXEC UpdateConsultant 315 , 'DR.Zyad Mohamed'
--Question 15 — Delete Patient with Error Handling
--Create a stored procedure that deletes a patient and handles errors using TRY-CATCH.
GO
create or alter proc DeletePatient
@ID INT 
AS 
BEGIN
BEGIN TRY
IF NOT EXISTS (SELECT 1 FROM Patients WHERE ID =@ID)
   THROW 50004 , 'THIS ID NOT EXIST',1

DELETE FROM Patients 
WHERE ID =@ID

END TRY 
BEGIN CATCH
PRINT 'DELETE FAILED'
SELECT ERROR_NUMBER(),ERROR_MESSAGE(),
       ERROR_SEVERITY()

END CATCH

END;

EXEC DeletePatient 301

--Question 16 — Add a New Patient
--Create a stored procedure that inserts a new patient.
 -- DID IT BEFOR 

--Question 17 — Add a New Consultant
--Create a stored procedure that inserts a new consultant.

GO
CREATE OR ALTER PROC InsertConsultant
@NAME VARCHAR(30),
@SALARY DECIMAL(10,2),
@NEWID INT OUT
AS
BEGIN
BEGIN TRY



SELECT @NEWID = ISNULL(MAX(ID),0) +1
FROM Consultants

INSERT INTO Consultants 
VALUES(@NEWID,@NAME,@SALARY)
PRINT 'Consultant ADDED SUCESSFULY'
END TRY 

BEGIN CATCH
SET @NEWID =NULL;
SELECT ERROR_NUMBER() ,
       ERROR_MESSAGE(),
       ERROR_LINE()
END CATCH

END;


--Question 18 — Record a Medication Administration
--Create a stored procedure that inserts a new medication administration.

GO
CREATE OR ALTER PROC InsertConsultant
@NURSEID INT,
@DRUGCODE INT,
@PATIENTID INT ,
@DOSAGE VARCHAR(50)
AS
BEGIN
BEGIN TRY

IF NOT EXISTS (SELECT 1 FROM Nurses WHERE @NURSEID = Number)
       THROW 50005, 'THIS NURSE NOT EXIST',1

IF NOT EXISTS (SELECT 1 FROM Patients WHERE @PATIENTID = ID)
       THROW 50005, 'THIS PATIENT NOT EXIST',1

INSERT INTO DrugAdministrations 
VALUES(@NURSEID,@DRUGCODE,@PATIENTID ,@DOSAGE,CAST(GETDATE() AS DATE), CAST(GETDATE() AS TIME))
PRINT 'DrugAdministration ADDED SUCESSFULY'
END TRY 

BEGIN CATCH
SELECT ERROR_NUMBER() ,
       ERROR_MESSAGE(),
       ERROR_LINE()
END CATCH

END;

--Question 19 — Update Patient Information
--Create a stored procedure that updates a patient's name, date of birth, and ward.

GO
CREATE OR ALTER PROC UpdatePatient
@ID INT,
@DOB DATE = NULL ,
@NAME VARCHAR(30) =NULL,
@WARDID DECIMAL(10,2) =NULL
AS 
BEGIN
BEGIN TRY 
IF NOT EXISTS (SELECT 1 FROM Wards WHERE ID= @WARDID)
    THROW 50002,'WARD ID NOT EXIST',1;
UPDATE Patients
SET Name = ISNULL(@NAME,NAME),
    WARDID = ISNULL(@WARDID,WardId),
    DOB = ISNULL(@DOB, DOB)
WHERE ID =@ID 

IF @@ROWCOUNT >0
   PRINT 'UBDATED SUCCESSFLY'
ELSE 
   PRINT 'UBDATE FAILED'
END TRY
BEGIN CATCH
SELECT ERROR_NUMBER() ,
       ERROR_MESSAGE(),
       ERROR_LINE()

END CATCH 
END;

--Question 20 — Update Consultant Salary
--Create a stored procedure that changes a consultant's salary.

GO
CREATE OR ALTER PROC UpdateConsultantSalary
@ID INT ,
@SALARY DECIMAL(10,2) =NULL
AS 
BEGIN
UPDATE Consultants
SET 
    Salary = ISNULL(@SALARY,SALARY)
WHERE ID =@ID 

IF @@ROWCOUNT >0
   PRINT 'UBDATED SUCCESSFLY'
ELSE 
   PRINT 'UBDATE FAILED'
END;

--Question 21 — Increase Nurse Salary
--Create a stored procedure that increases a nurse's salary by a percentage.


GO
CREATE OR ALTER PROC UpdateNurseSalary
@ID INT ,
@SALARY DECIMAL(10,2) =NULL
AS 
BEGIN
UPDATE Nurses
SET 
    Salary = ISNULL(@SALARY,SALARY)
WHERE Number =@ID 

IF @@ROWCOUNT >0
   PRINT 'UBDATED SUCCESSFLY'
ELSE 
   PRINT 'UBDATE FAILED'
END;

--Question 22 — Delete a Patient
--Create a stored procedure that deletes a patient by ID.
  -- DID IT BEFOR

--Question 23 — Delete a Consultant
--Create a stored procedure that deletes a consultant by ID.

GO
create or alter proc DeleteConsultant
@ID INT 
AS 
BEGIN
BEGIN TRY
IF NOT EXISTS (SELECT 1 FROM Consultants WHERE ID =@ID)
   THROW 50004 , 'THIS ID NOT EXIST',1

DELETE FROM Consultants 
WHERE ID =@ID

END TRY 
BEGIN CATCH
PRINT 'DELETE FAILED'
SELECT ERROR_NUMBER(),ERROR_MESSAGE(),
       ERROR_SEVERITY()

END CATCH

END;


--Question 24 — Delete a Medication Administration
--Create a stored procedure that deletes a medication administration using its identifying columns.

GO
create or alter proc MedicationAdministration
@PATIENTID INT ,
@DRUGCODE INT,
@NURSEID INT,
@DATE DATE,
@TIME TIME(7)
AS 
BEGIN
BEGIN TRY
IF NOT EXISTS (SELECT 1 FROM DrugAdministrations 
WHERE PatientId =@PATIENTID 
AND
@DRUGCODE =DrugCode 
AND
@DATE =DATE 
AND 
@TIME = TIME
AND 
@NURSEID =NurseId
)
   THROW 50004 , 'THIS ID NOT EXIST',1

DELETE FROM DrugAdministrations 
WHERE PatientId =@PATIENTID 
AND
@DRUGCODE =DrugCode 
AND
@DATE =DATE 
AND 
@TIME = TIME
AND 
@NURSEID =NurseId

END TRY 
BEGIN CATCH
PRINT 'DELETE FAILED'
SELECT ERROR_NUMBER(),ERROR_MESSAGE(),
       ERROR_SEVERITY()

END CATCH

END;

--Question 48 — Stored Procedure Returning Multiple Statistics
--Create a stored procedure that returns total patients, total consultants, average consultant salary, and total medication quantity.
GO
CREATE OR ALTER PROC MultipleStatistics

AS 
BEGIN

SELECT COUNT(*) 'TOTAL CONSULTATNS '
, AVG(Salary) 'AVERGE CONSLTANT SALARY '
FROM Consultants

SELECT COUNT(*) 'TOTAL PATIENTS'
FROM Patients 

SELECT COUNT(*)
FROM DrugAdministrations AS TOTALADMENSTRATION
END;

EXEC MultipleStatistics
GO
--Question 49 — Stored Procedure with OUTPUT and TRY-CATCH
--Create a stored procedure that receives a patient ID and returns total medication quantity through an OUTPUT parameter. Handle errors using TRY-CATCH.

-- I CAN NOT CALC TOTAL BECAUSE DOSAGE IS STRING NOT INT 

--Question 50 — Final Hospital Patient Summary
--Create a stored procedure that receives a patient ID and returns patient information, ward name, number of medication administrations, and total medication quantity. Use TRY-CATCH.
CREATE OR ALTER PROC PatientSummary
    @ID INT
AS
BEGIN
    BEGIN TRY

        IF NOT EXISTS
        (
            SELECT 1
            FROM Patients
            WHERE ID = @ID
        )
            THROW 50006, 'THIS ID NOT EXIST', 1;

        SELECT
            P.Id,
            P.Name,
            P.DOB,
            W.Name AS [WARD NAME],
            COUNT(DA.DrugCode) AS [Number Of Medication Administrations]
        FROM Patients P
        JOIN Wards W
            ON P.WardId = W.Id

        LEFT JOIN DrugAdministrations DA
            ON P.Id = DA.PatientId

        WHERE P.Id = @ID

        GROUP BY
            P.Id,
            P.Name,
            P.DOB,
            W.Name;

    END TRY

    BEGIN CATCH

        SELECT
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage,
            ERROR_SEVERITY() AS ErrorSeverity;

    END CATCH
END;
