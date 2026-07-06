-- ============================
-- Hospital Management DBMS Lab
-- ============================

DROP TABLE IF EXISTS Treatment;
DROP TABLE IF EXISTS Appointment;
DROP TABLE IF EXISTS Doctor;
DROP TABLE IF EXISTS Patient;

CREATE TABLE Patient(
    PatientID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT,
    Gender VARCHAR(10),
    Phone VARCHAR(15)
);

CREATE TABLE Doctor(
    DoctorID INT PRIMARY KEY,
    Name VARCHAR(50),
    Specialization VARCHAR(50)
);

CREATE TABLE Appointment(
    AppID INT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    Date DATE,
    FOREIGN KEY(PatientID) REFERENCES Patient(PatientID),
    FOREIGN KEY(DoctorID) REFERENCES Doctor(DoctorID)
);

CREATE TABLE Treatment(
    TreatmentID INT PRIMARY KEY,
    AppID INT,
    Diagnosis VARCHAR(100),
    Cost DECIMAL(10,2),
    FOREIGN KEY(AppID) REFERENCES Appointment(AppID)
);

INSERT INTO Patient VALUES
(1,'Arun',25,'Male','9876543210'),
(2,'Meera',30,'Female','9876543211'),
(3,'Rahul',40,'Male','9876543212'),
(4,'Anjali',28,'Female','9876543213'),
(5,'John',35,'Male','9876543214');

INSERT INTO Doctor VALUES
(101,'Dr. Raj','Cardiology'),
(102,'Dr. Priya','Orthopedics'),
(103,'Dr. Joseph','Neurology');

INSERT INTO Appointment VALUES
(201,1,101,'2025-01-10'),
(202,2,102,'2025-01-12'),
(203,3,101,'2025-01-15'),
(204,4,103,'2025-01-18'),
(205,5,102,'2025-01-20'),
(206,1,102,'2025-02-01');

INSERT INTO Treatment VALUES
(301,201,'Heart Checkup',3000),
(302,202,'Fracture',2500),
(303,203,'High BP',2000),
(304,204,'Migraine',4500),
(305,205,'Joint Pain',1800),
(306,206,'Back Pain',3200);

-- 1. View all patients
SELECT * FROM Patient;

-- 2. Complete treatment report
SELECT
P.PatientID,
P.Name AS Patient_Name,
D.Name AS Doctor_Name,
D.Specialization,
A.Date,
T.Diagnosis,
T.Cost
FROM Patient P
JOIN Appointment A ON P.PatientID=A.PatientID
JOIN Doctor D ON A.DoctorID=D.DoctorID
JOIN Treatment T ON A.AppID=T.AppID;

-- 3. Total revenue
SELECT SUM(Cost) AS Total_Revenue
FROM Treatment;

-- 4. Patients treated by Dr. Raj
SELECT DISTINCT
P.PatientID,
P.Name
FROM Patient P
JOIN Appointment A ON P.PatientID=A.PatientID
JOIN Doctor D ON A.DoctorID=D.DoctorID
WHERE D.Name='Dr. Raj';

-- 5. Highest treatment cost
SELECT MAX(Cost) AS Highest_Cost
FROM Treatment;

-- 6. High-cost treatments view
CREATE VIEW HighCostTreatments AS
SELECT *
FROM Treatment
WHERE Cost > 2500;

SELECT * FROM HighCostTreatments;

-- 7. Trigger to prevent negative treatment cost
DELIMITER //

CREATE TRIGGER PreventNegativeCost
BEFORE INSERT ON Treatment
FOR EACH ROW
BEGIN
    IF NEW.Cost < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Treatment cost cannot be negative';
    END IF;
END//

DELIMITER ;

-- 8. Index on patient name
CREATE INDEX idx_patient_name
ON Patient(Name);

-- 9. Top 3 doctors by number of patients
SELECT
D.DoctorID,
D.Name,
COUNT(A.PatientID) AS Total_Patients
FROM Doctor D
JOIN Appointment A ON D.DoctorID=A.DoctorID
GROUP BY D.DoctorID,D.Name
ORDER BY Total_Patients DESC
LIMIT 3;

-- 10. Total cost accumulated per patient
SELECT
P.PatientID,
P.Name,
SUM(T.Cost) AS Total_Cost
FROM Patient P
JOIN Appointment A ON P.PatientID=A.PatientID
JOIN Treatment T ON A.AppID=T.AppID
GROUP BY P.PatientID,P.Name;
