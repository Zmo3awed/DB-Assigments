--Display every patient together with the name of the ward they belong to.
SELECT Patients.Name 'Pation Name' ,Wards.Name 'Ward Name'
FROM Patients , Wards
WHERE Patients.WardId = WARDS.Id

--Display every drug administration together with the patient's name and the administered drug code.

SELECT P.Name , DA.DrugCode
FROM DrugAdministrations DA, Patients P
WHERE  P.Id = DA.PatientId

--Display every patient together with the consultant who examined them.

SELECT P.Name 'NAME', C.Name 'consultant Name' 
FROM Patients P , Consultants C , PatientExaminations PE
WHERE P.Id = PE.PatientId AND PE.ConsultantId=C.Id


--Display every patient together with their ward, including patients who are not assigned to a ward.

SELECT P.Name AS 'Name', ISNULL(W.Name, 'NO WARD') AS 'Ward Name'
FROM Patients P LEFT JOIN Wards W
ON P.WardId = W.Id

--Display every ward together with its patients, including wards that currently have no patients.
SELECT W.Name 'Ward Name' , ISNULL (P.Name,'NO PATIENT') AS 'Name'
FROM Patients P RIGHT JOIN Wards W
ON P.WardId = W.Id


--Display every consultant together with the patients they examined, including consultants who have not examined any patient.

SELECT 
    C.Name AS 'CONSULTANT NAME',
    P.Name AS 'PATIENT NAME'
FROM Consultants C
LEFT JOIN PatientExaminations PE
    ON C.Id = PE.ConsultantId
LEFT JOIN Patients P
    ON PE.PatientId = P.Id


--Display every ward together with the patients assigned to it, including wards that have no patients.

SELECT W.Name 'WARD NAME' , P.Name 'PATIENT NAME'
FROM PATIENTS P RIGHT JOIN WARDS W
ON P.WardId = W.Id

--Display every consultant together with their patient assignments, including consultants who have no assignments.

SELECT 
    C.Name AS 'CONSULTANT NAME',
    P.Name AS 'PATIENT NAME'
FROM Consultants C
LEFT JOIN PatientConsultantAssignments PA
    ON C.Id = PA.ConsultantId
LEFT JOIN Patients P
    ON PA.PatientId = P.Id

--Display all patients and all wards, including patients without a ward and wards without patients.

SELECT P.Name 'PATIENT NAME' , W.NAME 'WARD NAME'
FROM Patients P FULL OUTER JOIN WARDS W
ON P.WardId = W.Id
--Display all consultants and their patient assignments, including consultants without assignments and assignments without consultants
SELECT 
    C.Name AS 'CONSULTANT NAME',
    P.Name AS 'PATIENT NAME'
FROM Consultants C
FULL OUTER JOIN PatientConsultantAssignments PA
    ON C.Id = PA.ConsultantId
FULL OUTER JOIN Patients P
    ON PA.PatientId = P.Id

--Display every nurse together with the name of their manager.

SELECT N.Name 'NURSE NAME', MA.Name 'MANAGER NAME'
FROM Nurses N JOIN Nurses MA
ON N.ManagerId=MA.Number

--Display only nurses who have a manager.

SELECT N.Name 'NURSE NAME'
FROM Nurses N JOIN Nurses MA
ON N.ManagerId=MA.Number

--Display every manager together with the nurses they manage.

SELECT  MA.Name 'MANAGER NAME', N.Name 'NURSE MANGED'
FROM Nurses N JOIN Nurses MA
ON N.ManagerId=MA.Number

--Generate every possible combination of patients and consultants.

SELECT Patients.Name 'PATIENT NAME' , Consultants.Name 'consultants NAME'
FROM Patients CROSS JOIN Consultants 

--Generate every possible combination of wards and consultants.
SELECT WARDS.Name 'PATIENT NAME' , Consultants.Name 'consultants NAME'
FROM WARDS CROSS JOIN Consultants 
--Display each patient's name, ward, and consultant who examined the patient.

SELECT P.Name 'PATIENT NAME' , W.Name 'WARD NAME' , C.Name 'CONSULTANT NAME'   
FROM Patients P, Wards W , Consultants C ,PatientExaminations PE
WHERE P.WardId = W.Id AND P.Id = PE.PatientId AND C.Id = PE.ConsultantId

--Display each patient's name, the nurse who administered the drug, and the drug code.

SELECT P.Name 'PATIENT NAME' ,N.Name 'NURSE NAME',D.DrugCode 'DRUG CODE'
FROM Patients P , Nurses N ,DrugAdministrations D
WHERE P.Id=D.PatientId AND D.NurseId = N.Number

--Display each patient, their ward, the nurse who administered the drug, and the drug dosage.

SELECT P.Name 'PATIENT NAME' ,W.Name 'WARD NAME',N.Name 'NURSE NAME',D.Dosage 
FROM Patients P , Nurses N ,DrugAdministrations D,Wards W
WHERE P.Id=D.PatientId AND D.NurseId = N.Number AND P.WardId=W.Id

--Display the patient name, consultant name, and ward name for every patient who has been examined by a consultant.

SELECT P.Name 'PATIENT NAME' ,C.Name 'CONSLTANT NAME',W.Name 'WARD NAME' 
FROM Patients P JOIN WARDS W
ON P.WardId = W.Id 
JOIN 
PatientExaminations PE 
ON P.Id = PE.PatientId
JOIN
Consultants C
ON C.Id =PE.ConsultantId

--Display the patient name, nurse name, drug code, dosage, administration date, and administration time.

SELECT P.Name 'PATIENT NAME' ,N.Name 'NURSE NAME',D.DrugCode,D.Dosage,D.DATE ,D.Time 
FROM PATIENTS P 
JOIN 
DrugAdministrations D 
ON P.Id = D.PatientId
JOIN 
NURSES N
ON D.NurseId = N.Number

--Assign a unique row number to every consultant based on salary, starting with the highest-paid consultant.

SELECT C.Name, C.Salary ,ROW_NUMBER()OVER(ORDER BY C.SALARY DESC) 
FROM Consultants C

--Assign a unique row number to every consultant based on salary, starting with the lowest-paid consultant.

SELECT C.Name, C.Salary ,ROW_NUMBER()OVER(ORDER BY C.SALARY ) 
FROM Consultants C

--Assign a unique row number to every consultant based on salary. If two consultants have the same salary, order them alphabetically by name.

SELECT C.Name, C.Salary ,ROW_NUMBER()OVER(ORDER BY C.SALARY ,NAME ) 
FROM Consultants C
--Rank all consultants based on salary, with the highest salary receiving rank 1.

SELECT SALARY , RANK()OVER (ORDER BY SALARY DESC) AS SALARYRANK
FROM Consultants

--Rank all consultants based on salary from lowest to highest.

SELECT SALARY , RANK()OVER (ORDER BY SALARY DESC) AS SALARYRANK
FROM Consultants

--Display each consultant's salary rank and sort the result from the highest salary to the lowest.
SELECT SALARY , RANK()OVER (ORDER BY SALARY ) AS SALARYRANK
FROM Consultants
ORDER BY SALARY DESC

--Assign a dense rank to every consultant based on salary, with the highest salary receiving rank 1.

SELECT SALARY , DENSE_RANK()OVER (ORDER BY SALARY DESC) AS SALARYRANK
FROM Consultants

--Display the salary and dense rank of every consultant, sorted by salary from highest to lowest.

SELECT SALARY , DENSE_RANK()OVER (ORDER BY SALARY ) AS SALARYRANK
FROM Consultants
ORDER BY SALARY DESC

--Display the consultant name, salary, RANK, and DENSE_RANK so you can compare how ties are handled.

SELECT NAME, SALARY ,RANK()OVER (ORDER BY SALARY ) AS SALARYRANK
, DENSE_RANK()OVER (ORDER BY SALARY ) AS SALARY_DENSE_RANK
FROM Consultants
--Divide all consultants into two salary groups, with the highest-paid consultants placed in the first group.

SELECT SALARY , NTILE(2)OVER (ORDER BY SALARY DESC) AS SALARYRANK
FROM Consultants

--Divide all consultants into three approximately equal salary groups.

SELECT SALARY , NTILE(3)OVER (ORDER BY SALARY ) AS SALARYRANK
FROM Consultants

--Divide all consultants into four salary groups and display the highest-paid group first.

SELECT SALARY , NTILE(4)OVER (ORDER BY SALARY DESC) AS SALARYRANK
FROM Consultants

--Rank nurses by salary within each ward. The ranking should start from 1 for every ward.
SELECT Salary ,ServesInWardId,RANK() OVER(PARTITION BY ServesInWardId ORDER BY SALARY)
FROM NURSES 
--Assign a unique row number to nurses based on salary within each ward.
SELECT Salary ,ServesInWardId,ROW_NUMBER() OVER(PARTITION BY ServesInWardId ORDER BY SALARY)
FROM NURSES 
--Assign a dense salary rank to nurses within each ward. Nurses with the same salary should have the same rank.
SELECT Salary ,ServesInWardId,DENSE_RANK() OVER(PARTITION BY ServesInWardId ORDER BY SALARY)
FROM NURSES 
--Divide the nurses in each ward into two salary groups.

SELECT Salary ,ServesInWardId,NTILE(2) OVER(PARTITION BY ServesInWardId ORDER BY SALARY)
FROM NURSES 

--Display every nurse together with their ward and salary rank within that ward.

SELECT Salary ,ServesInWardId,RANK() OVER(PARTITION BY ServesInWardId ORDER BY SALARY)
FROM NURSES 

--Display every patient, their ward, and the salary rank of the consultant who examined them among all consultants.
SELECT P.Name 'PATIENT NAME' ,P.WardId ,C.Salary,
RANK() OVER(ORDER BY C.SALARY) 'CONSULTANT NAME'
FROM Patients P JOIN PatientExaminations PE
ON P.Id = PE.PatientId 
JOIN Consultants C
ON C.ID = PE.ConsultantId
--Display every patient, the nurse who administered their medication, the drug dosage, and the nurse's salary rank within their ward.

SELECT P.Name 'PATIONT NAME',N.Name 'NURSE NAME' ,N.ServesInWardId, DA.Dosage ,
RANK() OVER(PARTITION BY N.ServesInWardId ORDER BY N.SALARY) 'NURSE SALARY RANK'
FROM Patients P JOIN DrugAdministrations DA 
ON P.Id = DA.PatientId 
JOIN 
Nurses N
ON N.Number = DA.NurseId
