-- ============================================
-- HOSPITAL MANAGEMENT SYSTEM
-- ============================================

DROP TABLE IF EXISTS Treatment;
DROP TABLE IF EXISTS Appointment;
DROP TABLE IF EXISTS Doctor;
DROP TABLE IF EXISTS Patient;

-- ============================================
-- CREATE TABLES
-- ============================================

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
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID)
);

CREATE TABLE Treatment(
    TreatmentID INT PRIMARY KEY,
    AppID INT,
    Diagnosis VARCHAR(100),
    Cost DECIMAL(10,2),
    FOREIGN KEY (AppID) REFERENCES Appointment(AppID)
);

-- ============================================
-- INSERT DATA
-- ============================================

INSERT INTO Patient VALUES
(1,'Arun',25,'Male','9876543210'),
(2,'Meera',30,'Female','9876543211'),
(3,'Rahul',40,'Male','9876543212'),
(4,'Anjali',28,'Female','9876543213'),
(5,'John',35,'Male','9876543214');

INSERT INTO Doctor VALUES
(101,'Dr. Raj','Cardiology'),
(102,'Dr. Priya','Orthopedics'),
(103,'Dr. Joseph','Neurology'),
(104,'Dr. Anita','Dermatology');   -- No appointments

INSERT INTO Appointment VALUES
(201,1,101,'2025-01-10'),
(202,2,102,'2025-01-12'),
(203,3,101,'2025-01-15'),
(204,4,103,'2025-01-18'),
(205,5,102,'2025-01-20'),
(206,1,102,'2025-02-01'),
(207,2,101,'2025-02-10'),
(208,1,101,'2025-03-05');

INSERT INTO Treatment VALUES
(301,201,'Heart Checkup',3000),
(302,202,'Fracture',2500),
(303,203,'High BP',2000),
(304,204,'Migraine',4500),
(305,205,'Joint Pain',1800),
(306,206,'Back Pain',3200),
(307,207,'Cardiac Review',4000),
(308,208,'ECG',1500);

-- ============================================
-- i. View all the patients
-- ============================================

SELECT * FROM Patient;

-- ============================================
-- ii. Display the total cost accumulated per
--     patient over time (Running Total)
-- ============================================

SELECT
    P.PatientID,
    P.Name,
    A.Date,
    T.Cost,
    SUM(T.Cost) OVER(
        PARTITION BY P.PatientID
        ORDER BY A.Date
    ) AS Running_Total
FROM Patient P
JOIN Appointment A
ON P.PatientID = A.PatientID
JOIN Treatment T
ON A.AppID = T.AppID
ORDER BY P.PatientID,A.Date;

-- ============================================
-- iii. Most expensive treatment for each patient
-- ============================================

SELECT
    P.PatientID,
    P.Name,
    MAX(T.Cost) AS Highest_Treatment_Cost
FROM Patient P
JOIN Appointment A
ON P.PatientID=A.PatientID
JOIN Treatment T
ON A.AppID=T.AppID
GROUP BY P.PatientID,P.Name;

-- ============================================
-- iv. Display Patients with Above Average
--     Treatment Cost
-- ============================================

SELECT
    P.PatientID,
    P.Name,
    T.Diagnosis,
    T.Cost
FROM Patient P
JOIN Appointment A
ON P.PatientID=A.PatientID
JOIN Treatment T
ON A.AppID=T.AppID
WHERE T.Cost >
(
    SELECT AVG(Cost)
    FROM Treatment
);

-- ============================================
-- v. Display Doctor-wise Average Treatment Cost
-- ============================================

SELECT
    D.DoctorID,
    D.Name,
    AVG(T.Cost) AS Average_Treatment_Cost
FROM Doctor D
JOIN Appointment A
ON D.DoctorID=A.DoctorID
JOIN Treatment T
ON A.AppID=T.AppID
GROUP BY D.DoctorID,D.Name;

-- ============================================
-- vi. Compare Current vs Previous Treatment Cost
-- ============================================

SELECT
    TreatmentID,
    Diagnosis,
    Cost AS Current_Cost,
    LAG(Cost) OVER(ORDER BY TreatmentID) AS Previous_Cost,
    Cost - LAG(Cost) OVER(ORDER BY TreatmentID) AS Difference
FROM Treatment;

-- ============================================
-- vii. Display Daily Patient Count
-- ============================================

SELECT
    Date,
    COUNT(DISTINCT PatientID) AS Patient_Count
FROM Appointment
GROUP BY Date
ORDER BY Date;

-- ============================================
-- viii. Find Doctors with No Appointments
-- ============================================

SELECT
    D.DoctorID,
    D.Name
FROM Doctor D
LEFT JOIN Appointment A
ON D.DoctorID=A.DoctorID
WHERE A.AppID IS NULL;

-- ============================================
-- ix. Rank Patients by Total Spending
-- ============================================

SELECT
    PatientID,
    Name,
    Total_Spending,
    RANK() OVER(ORDER BY Total_Spending DESC) AS Spending_Rank
FROM
(
    SELECT
        P.PatientID,
        P.Name,
        SUM(T.Cost) AS Total_Spending
    FROM Patient P
    JOIN Appointment A
    ON P.PatientID=A.PatientID
    JOIN Treatment T
    ON A.AppID=T.AppID
    GROUP BY P.PatientID,P.Name
) AS Spending;

-- ============================================
-- x. Detect Frequent Patients
-- (Patients having 2 or more appointments)
-- ============================================

SELECT
    P.PatientID,
    P.Name,
    COUNT(A.AppID) AS Total_Appointments
FROM Patient P
JOIN Appointment A
ON P.PatientID=A.PatientID
GROUP BY P.PatientID,P.Name
HAVING COUNT(A.AppID) >= 2;
