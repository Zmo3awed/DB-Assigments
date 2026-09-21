-- ● Insert a Guest (FullName, Nationality, PassportNumber, DateOfBirth) 
INSERT INTO Guests
    (FullName, Nationality, PassportNum, DateOfBirth)
VALUES
    ('Ahmed Ali', 'Egyptian', 'A12345678', '2000-05-15')
-- ● Insert multiple Guests in one statement
INSERT INTO Guests
    (FullName, Nationality, PassportNum, DateOfBirth)
VALUES
    ('Ahmed Ali', 'Egyptian', 'A12345678', '2000-05-15'),
    ('Omar Hassan', 'Egyptian', 'B98765432', '1999-08-20'),
    ('John Smith', 'American', 'C12345678', '2001-03-10')

-- ● Increase DailyRate by 15% for all suites 

UPDATE rooms 
SET DailyRate+=(DailyRate*0.15)

-- ● Update ReservationStatus: If CheckoutDate < GETDATE() → 'Completed' 
--   If CheckinDate > GETDATE() → 'Upcoming' Else → 'Active'
Update Reservation
SET statues = CASE
WHEN Checkout < GETDATE() THEN 'Completed' 
WHEN Checkout > GETDATE() THEN 'Upcoming'
ELSE 'Active'
END

-- ● Delete Reservation_Guest for a reservation

DELETE FROM reservation_Guests

-- ● Create table #StaffUpdates (StaffId, FullName, Position, Salary) 
CREATE TABLE StaffUpdates
(
StaffId INT PRIMARY KEY,
FullName VARCHAR(10),
Position VARCHAR(20),
Salary DECIMAL(6,3)

)

MERGE INTO STAFF AS S
USING StaffUpdates AS U
ON S.id = U.STAFFID

WHEN MATCHED THEN
    UPDATE SET
        S.Position = U.Position,
        S.Salary = U.Salary

WHEN NOT MATCHED BY TARGET THEN
    INSERT (Id, Name, Position, Salary)
    VALUES (U.StaffId, U.FullName, U.Position, U.Salary)

WHEN NOT MATCHED BY SOURCE THEN
    DELETE;