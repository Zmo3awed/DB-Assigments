--Question 29 - Create an AFTER INSERT Trigger
--Create an AFTER INSERT trigger that records every newly inserted patient in PatientAudit.

CREATE TABLE PatientAudit02 
(
ID INT IDENTITY PRIMARY KEY ,
PID INT ,
ACTION VARCHAR(10),
TIME DATETIME
)
GO
CREATE OR ALTER TRIGGER INSERT_PATIENT
ON PATIENTS
AFTER INSERT
AS
BEGIN 

INSERT INTO PatientAudit02
SELECT ID ,'INSERTION',GETDATE()
FROM inserted

END;

INSERT INTO Patients
VALUES
    (401, 'Ali',  '20000101', 1),
    (402, 'Omar', '20010101', 1),
    (403, 'Ziad', '20020101', 1);
SELECT *
FROM PatientAudit02

--Question 30 - Audit Consultant Salary Changes
--Create an audit table and an AFTER UPDATE trigger that stores the old and new consultant salary.
CREATE TABLE ConsultantSalaryAudit02
(
ID INT IDENTITY PRIMARY KEY ,
CID INT ,
OLD INT,
NEW INT,
ACTION VARCHAR(10),
TIME DATETIME
)
GO
CREATE OR ALTER TRIGGER UPDATE_CSALARY
ON ConsultantS
AFTER UPDATE
AS 
BEGIN
IF NOT UPDATE(SALARY)
   RETURN;
INSERT INTO ConsultantSalaryAudit02
SELECT I.Id ,D.Salary ,I.Salary ,'UPDATED',GETDATE()
FROM inserted I INNER JOIN deleted D
ON I.Id = d.ID
END;

--Question 31 - Audit Patient Ward Changes
--Create a trigger that records the old and new ward whenever a patient's ward changes.
GO
CREATE OR ALTER TRIGGER UPDATE_PWARDID
ON PATIENTS
AFTER UPDATE
AS 
BEGIN
IF NOT UPDATE(WARDID)
   RETURN;
INSERT INTO -- ASSUM TABLE TO INSERT IT
SELECT I.ID ,D.WardId ,I.WardId ,'UPDATED',GETDATE()
FROM inserted I INNER JOIN deleted D
ON I.Id = d.ID
END;

--Question 32 - Archive Deleted Patients
--Create a table for deleted patients and an AFTER DELETE trigger that stores deleted patient information.

GO
CREATE OR ALTER TRIGGER DELETE_PATIENT
ON PATIENTS
AFTER DELETE
AS
BEGIN 

INSERT INTO --ASSUM THERE IS A DELETED TABLE
SELECT ID ,'DELETE',GETDATE()
FROM deleted
END;

--Question 33 - Audit Deleted Consultants
--Create an AFTER DELETE trigger that stores deleted consultant information.
GO
CREATE OR ALTER TRIGGER DELETE_CONSULTANT
ON PATIENTS
AFTER DELETE
AS
BEGIN 

INSERT INTO --ASSUM THERE IS A DELETED TABLE
SELECT ID ,NAME,SALARY,'DELETE',GETDATE()
FROM deleted
END;



--Question 34 - Compare Old and New Consultant Salary
--Create an AFTER UPDATE trigger that displays the old and new salary of the consultant.
-- REBEATED 
--Question 35 - Compare Old and New Patient Ward
--Create an AFTER UPDATE trigger that displays the patient's old ward and new ward.

--DID BEFORE

--Question 36 - Handle Multiple Inserted Rows
--Create an AFTER INSERT trigger that records every patient inserted by a single statement. Then insert three patients in one statement.

-- SAME SINGLE INSERT TRIGGER

--Question 37 - Prevent Patients Without a Ward
--Create an INSTEAD OF INSERT trigger that prevents inserting a patient when Wardld is NULL.

GO
CREATE OR ALTER TRIGGER PREVENT_NULL
ON PATIENTS
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE WardId IS NULL
    )
    BEGIN
        THROW 50001, 'WardId cannot be NULL', 1;
    END;

    INSERT INTO Patients
    SELECT *
    FROM inserted;
END;
GO

--Question 38 - Validate Patient Date of Birth
--Create an INSTEAD OF INSERT trigger that prevents patients whose date of birth is in the future.

CREATE OR ALTER TRIGGER PREVINT_FUTER_DATE
ON PATIENTS
INSTEAD OF INSERT 
AS
BEGIN 
IF EXISTS (SELECT 1 FROM inserted WHERE DOB> GETDATE())
   BEGIN
   THROW 50002 ,'CAN NOT BE I THE FUTURE',1
   END
INSERT INTO Patients 
SELECT *
FROM inserted



END;

--Question 39 - Prevent Consultant Salary Reduction
--Create an INSTEAD OF UPDATE trigger that prevents reducing a consultant's salary.


GO
CREATE OR ALTER TRIGGER PREVINT_REDUCE_SALARY
ON CONSULTANTS
INSTEAD OF UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted I
        JOIN deleted D ON I.Id = D.Id
        WHERE I.Salary < D.Salary
    )
    BEGIN
        THROW 50003, 'SALARY CANNOT BE REDUCED', 1;
    END;

    UPDATE C
    SET C.Name = I.Name,
        C.Salary = I.Salary
    FROM Consultants C
    JOIN inserted I ON C.Id = I.Id;
END;
GO


--Question 40 - Control Patient Updates
--Create an INSTEAD OF UPDATE trigger that allows patient information to be updated without changing the patient ID.

GO
CREATE OR ALTER TRIGGER PREVINT_EDIT_ID
ON PATIENTS
INSTEAD OF UPDATE
AS
BEGIN


    UPDATE P
    SET P.Name = I.Name,
        P.DOB = I.DOB,
        P.WardId = I.WardId
    FROM Patients P
    JOIN inserted I ON P.Id = I.Id;
END;


UPDATE PATIENTS
SET NAME ='MOHAMED'
WHERE  ID =1

--Question 41 - Prevent Patient Deletion
--Create an INSTEAD OF DELETE trigger that prevents patients from being deleted directly.
GO

CREATE OR ALTER TRIGGER PREVENT_DELETE
ON Patients
INSTEAD OF DELETE
AS
BEGIN
    THROW 50005, 'DELETE IS NOT ALLOWED', 1;
END;
GO

--Question 42 — Archive Before Delete
--Create an INSTEAD OF DELETE trigger that first stores the deleted patient in DeletedPatients, then deletes the patient from Patients.

CREATE OR ALTER TRIGGER PREVENT_DELETE
ON Patients
INSTEAD OF DELETE
AS
BEGIN
INSERT INTO -- ASSUM TABLE CREATED
SELECT *
FROM deleted

    DELETE P
    FROM Patients P
    INNER JOIN deleted D
        ON P.ID = D.ID;
END;
GO

--Question 43 — Add Patient with Audit Trigger
--Create a stored procedure that adds a patient and an AFTER INSERT trigger that records the new patient in PatientAudit. Then execute the procedure.
CREATE OR ALTER PROC Add_Patient
@ID INT ,
@NAME VARCHAR(50),
@DOB DATE ,
@WARDID INT
AS
BEGIN
INSERT INTO Patients
VALUES (@ID,@NAME,@DOB,@WARDID)
END;

EXEC Add_Patient 409 ,'ADEL' ,'2000-10-05',2
--Question 44 — Update Consultant with Salary Audit
--Create a stored procedure to update a consultant salary and an AFTER UPDATE trigger to record the old and new salary. 
GO
CREATE OR ALTER PROC UPDATE_SALARY
@ID INT ,
@NEW INT
AS
BEGIN
UPDATE Consultants
SET SALARY = @NEW
WHERE ID = @ID 
END;

--Question 45 — Delete Patient and Archive the Record 
--Create a stored procedure that deletes a patient and a trigger that automatically archives the deleted patient.
GO
CREATE OR ALTER PROC DELETE_Patient
@ID INT 
AS
BEGIN
DELETE Patients
WHERE ID=@ID
END; 
EXEC DELETE_Patient 1

------------------------------- INDEX ------------------------------------------

--Question 1 — Create a Clustered Index
--Create PatientIndexDemo with PatientId, PatientName, DOB, and WardId. Copy data from Patients, then create a clustered index on PatientId.

SELECT *
INTO PatientIndexDemo
FROM PATIENTS
GO
CREATE CLUSTERED INDEX IX_ID
ON PatientIndexDemo(ID)

--Question 2 — Create Another Clustered Index
--Create ConsultantIndexDemo containing ConsultantId, ConsultantName, and Salary. Copy data from Consultants, then create a clustered index on ConsultantId.
SELECT *
INTO ConsultantIndexDemo
FROM CONSULTANTS
GO
CREATE CLUSTERED INDEX IX_CONSULTANT_ID
ON ConsultantIndexDemo(ID)

--Question 3 — Index Patients by Ward
--Create a nonclustered index on Patients.WardId to improve searches that retrieve patients based on their ward.
GO
CREATE NONCLUSTERED INDEX IX_PATIENT_WARDID
ON PatientIndexDemo(WARDID)


--Question 4 — Index Consultants by Salary
--Create a nonclustered index on Consultants.Salary.
CREATE NONCLUSTERED INDEX IX_CONSULTANT_SALARY
ON ConsultantIndexDemo(SALARY)


--Question 5 — Create a Composite Nonclustered Index
--Create a nonclustered index on DrugAdministrations using PatientId and DrugCode.
GO 
CREATE NONCLUSTERED INDEX IX_ID_DRUGCODE
ON DrugAdministrations(PatientId ,DRUGCODE)
--Question 6 — Create a Nonclustered Index with Included Columns
--Create a nonclustered index on Patients.WardId and include Name and DOB.
GO
CREATE NONCLUSTERED INDEX IX_PATIENT_WARDID_INCLUDED
ON PatientIndexDemo (WARDID)
INCLUDE (NAME, DOB);
--Question 7 — Unique Consultant Names
--Create a unique index on Consultants.Name to prevent duplicate consultant names.
GO
CREATE UNIQUE NONCLUSTERED INDEX IX_Consultants_Name
ON ConsultantIndexDemo(NAME)

--Question 8 — Composite Unique Index
--Create PatientDrugAssignmentDemo with PatientId, DrugCode, and StartDate. Create a unique composite index on PatientId and DrugCode.
SELECT *
INTO PatientDrugAssignmentDemo
FROM DrugAdministrations

CREATE UNIQUE NONCLUSTERED INDEX IX_DRUG
ON PatientDrugAssignmentDemo(PATIENTID,DRUGCODE)

--Question 9 — Test the Unique Index
--Insert one valid row into PatientDrugAssignmentDemo, then attempt to insert the same PatientId and DrugCode again with a different date.

-- THERE IS AN DUBLICATION ALEEDY , SO WE CAN NOT APPLY UNIQE INDEX

--Question 10 — Display Indexes
--Display the indexes defined on the Patients table.
EXEC sp_helpindex 'Patients';



--Question 11 — Find Indexes from System Catalogs
--Display table name, index name, and index type for all indexes in the Hospital database.

SELECT I.object_id,OBJECT_NAME(I.object_id) , I.name  
FROM sys.indexes AS I

--Question 12 — Drop a Nonclustered Index
--Remove the index created in Question 4.
DROP INDEX IX_CONSULTANT_SALARY
ON ConsultantIndexDemo
--Question 13 — Create an Index for Patient Searches
--Create a nonclustered index that can help queries searching patients by WardId and DOB.
GO
CREATE  NONCLUSTERED INDEX IX_WARD_DOB
ON PatientIndexDemo(WARDID,DOB)

--Question 14 — Create a Reporting Index
--Create a nonclustered index on DrugAdministrations using PatientId and DATE, including DrugCode, Dosage, and Quantity.
CREATE NONCLUSTERED INDEX Reporting_Index
ON DrugAdministrations(PatientId,DATE)
INCLUDE (DRUGCODE,DOSAGE)
