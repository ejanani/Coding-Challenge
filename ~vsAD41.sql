CREATE DATABASE CarRental

USE CarRental

--Creating VehicleTable

CREATE TABLE VEHICLE(
vehicleID INT PRIMARY KEY IDENTITY(1,1),
make VARCHAR(50),
model VARCHAR(50),
year int,
dailyrate DECIMAL(8,2),
status VARCHAR(50),
passengerCapacity int,
engineCapacity int
)

--Creating Customer Table

CREATE TABLE CUSTOMER(
customerID INT PRIMARY KEY,
firstName VARCHAR(50),
lastName VARCHAR(50),
email TEXT,
phoneNumber VARCHAR(15)
)


--Creating Lease Table

CREATE TABLE LEASE(
leaseID INT PRIMARY KEY,
vehicleID INT,
customerID INT,
startDate DATE,
endDate DATE,
type VARCHAR(50),
FOREIGN KEY (vehicleID) REFERENCES VEHICLE (vehicleID),
FOREIGN KEY (customerID) REFERENCES CUSTOMER (customerID)
)


--Creating Payment Table

CREATE TABLE PAYMENT(
paymentID INT PRIMARY KEY,
leaseID INT,
paymentDate DATE,
amount DECIMAL(8,2)
FOREIGN KEY (leaseID) REFERENCES lease (leaseID)
)

--Inserting Values into VehicleTable

INSERT INTO VEHICLE VALUES
('Toyota','Camry',2022,50.00,1,4,1450),
('Honda', 'Civic',2023,45.00,1,7,1500),
('Ford','Focus',2022,48.00,0,4,1400),
('Nissan','Altima',2023,52.00,1,7,1200),
('Chevrolet','Malibu',2022,47.00,1,4,1800),
('Hyndai','Sonata',2023,49.00,0,7,1400),
('BMW','3Series',2023,60.00,1,7,2499),
('Mercedes','C-Class',2022,58.00,1,8,2599),
('Audi', 'A4', 2022,55.00,0,4,2500),
('Lexus', 'ES', 2023,54.00,1,4,2500)

SELECT * FROM VEHICLE

--Inserting Values into CustomerTable

INSERT INTO CUSTOMER VALUES
(1,'John','Doe','johndoe@example.com',555-555-5555),
(2,'Jane','Smith','janesmith@example.com',555-123-4567),
(3,'Robert','Johnson','robert@example.com',555-789-1234),
(4, 'Sarah',' Brown',' sarah@example.com', 555-456-7890),(5, 'David',' Lee',' david@example.com', 555-987-6543),(6 ,'Laura',' Hall',' laura@example.com ',555-234-5678),(7,' Michael',' Davis',' michael@example.com', 555-876-543),(8,' Emma',' Wilson',' emma@example.com', 555-432-1098),(9, 'William',' Taylor',' william@example.com', 555-321-6547),(10, 'Olivia','Adams',' olivia@example.com', 555-765-4321)SELECT * FROM CUSTOMER

--Inserting Values into Lease Table

INSERT INTO lease VALUES
(1, 1, 1, '2023-01-01', '2023-01-05', 'Daily'),
(2, 2, 2, '2023-02-15', '2023-02-28', 'Monthly'),
(3, 3, 3, '2023-03-10', '2023-03-15', 'Daily'),
(4, 4, 4, '2023-04-20', '2023-04-30', 'Monthly'),
(5, 5, 5, '2023-05-05', '2023-05-10','Daily'),
(6, 4, 3, '2023-06-15', '2023-06-30', 'Monthly'),
(7, 7, 7, '2023-07-01', '2023-07-10', 'Daily'),
(8, 8, 8, '2023-08-12', '2023-08-15', 'Monthly'),
(9, 3, 3, '2023-09-07', '2023-09-10', 'Daily'),
(10, 10, 10, '2023-10-10', '2023-10-31', 'Monthly')

--Inserting Valuesinto Payment Table

INSERT INTO Payment VALUES
(1, 1, '2023-01-03', 200.00),
(2, 2, '2023-02-20', 1000.00),
(3, 3, '2023-03-12', 75.00),
(4, 4, '2023-04-25', 900.00),
(5, 5, '2023-05-07', 60.00),
(6, 6, '2023-06-18', 1200.00),
(7, 7, '2023-07-03', 40.00),
(8, 8, '2023-08-14', 1100.00),
(9, 9, '2023-09-03', 80.00),
(10, 10, '2023-10-03', 1500.00)

SELECT * FROM PAYMENT

--1. Update the daily rate for a Mercedes car to 68:

UPDATE Vehicle
SET dailyRate = 68.00
WHERE make = 'Mercedes'

--2. Delete a specific customer and all associated leases and payments:

DELETE FROM Payment
WHERE leaseID IN (
    SELECT l.leaseID
    FROM Lease l
    WHERE l.customerID = 10	
)
DELETE FROM Lease
WHERE customerID = 10;
DELETE FROM Customer
WHERE customerID =10;


--3. Rename the "paymentDate" column in the Payment table to "transactionDate":

EXEC sp_rename 'Payment.paymentDate', 'transactionDate', 'COLUMN'

--4. Find a specific customer by email:

SELECT * FROM Customer
WHERE CAST(email AS varchar(max)) = 'johndoe@example.com'

--5. Get active leases for a specific customer:

SELECT l.*
FROM Lease l
JOIN Customer c ON l.customerID = c.customerID
WHERE l.customerID = 1
AND l.endDate >= GETDATE()

--6. Find all payments made by a customer with a specific phone number:

SELECT p.*
FROM PAYMENT p
JOIN LEASE l ON p.leaseID = l.leaseID
JOIN CUSTOMER c ON l.customerID = c.customerID
WHERE c.phoneNumber = '555-123-4567'


--7. Calculate the average daily rate of all available cars:

SELECT AVG(dailyRate)
FROM Vehicle

--8. Find the car with the highest daily rate:

select * from Vehicle where dailyRate=(select Max(dailyRate) from Vehicle)

--9. Retrieve all cars leased by a specific customer:

select concat(make,model) AS Details from Vehicle
where vehicleId in (select vehicleID from Lease 
where customerID=3)

--10. Find the details of the most recent lease:

SELECT *
FROM Lease
WHERE endDate = (
    SELECT MAX(endDate)
    FROM Lease
)
--11. List all payments made in the year 2023:

SELECT *
FROM Payment
WHERE YEAR(transactionDate) = 2023

--12. Retrieve customers who have not made any payments:

SELECT c.*
FROM Customer c
LEFT JOIN Lease l ON c.customerID = l.customerID
WHERE l.customerID IS NULL

--13. Retrieve Car Details and Their Total Payments:

SELECT v.vehicleID,v.make,v.model,
SUM(p.amount) AS totalPayments
FROM Vehicle v
LEFT JOIN Lease l ON v.vehicleID = l.vehicleID
LEFT JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY v.vehicleID,v.make,v.model

--14. Calculate Total Payments for Each Customer:

SELECT c.customerID,c.firstName,c.lastName,
SUM(p.amount) AS totalPayments
FROM Customer c
LEFT JOIN Lease l ON c.customerID = l.customerID
LEFT JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY c.customerID,c.firstName,c.lastName

--15. List Car Details for Each Lease:

SELECT l.leaseID,v.vehicleID,v.make,v.model,v.year,v.dailyRate,v.status,v.passengerCapacity,v.engineCapacity
FROM Lease l
JOIN Vehicle v ON l.vehicleID = v.vehicleID

--16. Retrieve Details of Active Leases with Customer and Car Information:

DECLARE @today DATE = '2023-07-25'
SELECT l.*, c.firstName, c.lastName, v.make, v.model
FROM Lease l, Customer c, Vehicle v
WHERE l.customerID = c.customerID
AND l.vehicleID = v.vehicleID
AND l.endDate >= @today;


--17. Find the Customer Who Has Spent the Most on Leases:

SELECT TOP 1
c.customerID,c.firstName,c.lastName,
SUM(p.amount) AS totalSpentOnLeases
FROM Customer c
JOIN Lease l ON c.customerID = l.customerID
JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY c.customerID,c.firstName,c.lastName
ORDER BY totalSpentOnLeases DESC


--18. List All Cars with Their Current Lease Information:

SELECT V.*, L.* FROM Vehicle V
JOIN Lease L ON L.vehicleID = V.vehicleID