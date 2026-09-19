CREATE DATABASE Hotel


CREATE TABLE Guests
(
id int PRIMARY KEY,
fullName varChar(50),
nationality varchar(10),
passportNum varchar(20),
dateOfBirth date
)

CREATE TABLE Guest_Contact
(
id int FOREIGN KEY REFERENCES Guests(id),
detail varchar(20),
PRIMARY KEY(id,detail)
)

CREATE TABLE reservation
(
id INT PRIMARY KEY,
checkin DATE,
checkout DATE,
bookingDate DATE,
statues VARCHAR(10),
totalPrice INT,
numOfAdults INT,
numOfChilds INT,
)

CREATE TABLE reservation_Guests
(
G_id INT FOREIGN KEY REFERENCES Guests(id),
R_id INT FOREIGN KEY REFERENCES reservation(id)
PRIMARY KEY(G_id,R_id)
)

CREATE TABLE Payment
(
id INT PRIMARY KEY,
date DATE,
amount DECIMAL(6,2),
confNum VARCHAR(10),
method VARCHAR(10)

)


CREATE TABLE reservation_Payments
(
P_id INT FOREIGN KEY REFERENCES Payment(id),
R_id INT FOREIGN KEY REFERENCES reservation(id)
PRIMARY KEY(P_id,R_id)
)

CREATE TABLE hotels
(
name VARCHAR(10),
Aaddress varchar(30),
city varchar(10),
startingRating int,
countactNum varchar(15),

)
ALTER TABLE hotels 
ADD id int PRIMARY KEY

CREATE TABLE staff
(
id int PRIMARY KEY,
name varchar(10),
position varchar(10),
salary decimal(6,3),
hotel_id int FOREIGN KEY REFERENCES Hotels(id)
)

ALTER TABLE HOTELS
ADD Manage_id int FOREIGN KEY REFERENCES STAFF(id)

CREATE TABLE services
(
id int PRIMARY KEY,
Name varchar(10),
charge decimal,
requestDate date,
staffid int FOREIGN KEY REFERENCES staff(id)


CREATE TABLE reservation_Servecis
(
R_id INT FOREIGN KEY REFERENCES reservation(id),
s_id INT FOREIGN KEY REFERENCES services(id)
PRIMARY KEY(s_id,R_id)
)

CREATE TABLE rooms
(
id int PRIMARY KEY ,
type varchar(10),
capacity int ,
DailyRate int ,
Avilabilty binary,
Hotelid int FOREIGN KEY REFERENCES Hotels(id)
)

CREATE TABLE reservation_Rooms
(
R_id INT FOREIGN KEY REFERENCES reservation(id),
Ro_id INT FOREIGN KEY REFERENCES rooms(id)
PRIMARY KEY(Ro_id,R_id)
)