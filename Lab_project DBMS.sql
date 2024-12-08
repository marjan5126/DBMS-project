CREATE DATABASE Flood_affected_area;
USE Flood_affected_area;

-- 1. Area Table

CREATE TABLE Area (
    AreaID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(255) NOT NULL,
    Population INT NOT NULL,
    FloodRiskLevel ENUM('Low', 'Medium', 'High') NOT NULL DEFAULT 'Low',
    AffectedPopulationCount INT 
);

-- 2. Household Table
CREATE TABLE Household (
    HouseholdID INT PRIMARY KEY,
    Address VARCHAR(255) NOT NULL,
    AreaID INT NOT NULL,
    TotalMembers INT NOT NULL,
    IncomeLevel ENUM('Low', 'Medium', 'High') NOT NULL,  
    FOREIGN KEY (AreaID) REFERENCES Area(AreaID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 3. Resident Table
CREATE TABLE Resident (
    ResidentID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Age INT,
    Gender VARCHAR(10),
    HouseholdID INT NOT NULL,
    DisabilityStatus BOOLEAN,
    EmploymentStatus ENUM('Employed', 'Unemployed', 'Student', 'Retired', 'Other') NOT NULL,  
    FOREIGN KEY (HouseholdID) REFERENCES Household(HouseholdID) ON DELETE CASCADE ON UPDATE CASCADE
);


-- 4. Relief Center Table
CREATE TABLE ReliefCenter (
    CenterID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    AreaID INT NOT NULL,
    Capacity INT,
    IsActive BOOLEAN, 
    FOREIGN KEY (AreaID) REFERENCES Area(AreaID) ON DELETE CASCADE ON UPDATE CASCADE
);


-- 5. Medical Center Table
CREATE TABLE MedicalCenter (
    MedicalCenterID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(255),
    AreaID INT NOT NULL,
    Capacity INT,
    FOREIGN KEY (AreaID) REFERENCES Area(AreaID) ON DELETE CASCADE ON UPDATE CASCADE
);


-- 6. Organization Table
CREATE TABLE Organization (
    OrganizationID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Type VARCHAR(50),
    ContactInfo VARCHAR(255),
    TotalReliefFunds DECIMAL(15, 2),
    AreaID INT NOT NULL,
    FOREIGN KEY (AreaID) REFERENCES Area(AreaID) ON DELETE CASCADE ON UPDATE CASCADE
);


-- 7. Donation Table
CREATE TABLE Donation (
    DonationID INT PRIMARY KEY,
    Amount DECIMAL(15, 2) NOT NULL,
    Date DATE NOT NULL,
    DonationType VARCHAR(50),
    OrganizationID INT,
    ReliefCenterID INT,
    FOREIGN KEY (OrganizationID) REFERENCES Organization(OrganizationID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ReliefCenterID) REFERENCES ReliefCenter(CenterID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 8. Volunteer Table
CREATE TABLE Volunteer (
    VolunteerID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    ContactInfo VARCHAR(255),
    OrganizationID INT,
    Skillset VARCHAR(255),
    Availability BOOLEAN,
    FOREIGN KEY (OrganizationID) REFERENCES Organization(OrganizationID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 9. Infrastructure Damage Table
CREATE TABLE InfrastructureDamage (
    DamageID INT PRIMARY KEY,
    Type ENUM('Structural', 'Electrical', 'Plumbing', 'Water', 'Road', 'Other') NOT NULL,
    Severity VARCHAR(50),
    AreaID INT NOT NULL,
    RepairStatus VARCHAR(50),
    FOREIGN KEY (AreaID) REFERENCES Area(AreaID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 10. Inventory Supplier Table

DROP table InventorySupplier;
CREATE TABLE InventorySupplier (
    SupplierID INT PRIMARY KEY,            
    Name VARCHAR(100) NOT NULL,            
    ContactInfo VARCHAR(255),              
    SupplyType VARCHAR(50),                
    ReliabilityRating DECIMAL(3, 1),       
    ReliefCenterID INT, 
    FOREIGN KEY (ReliefCenterID) REFERENCES ReliefCenter(CenterID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 11 aviable ki resource ahce tai

CREATE TABLE ResourceInventory (
    ResourceID INT PRIMARY KEY,           
    Type VARCHAR(50),                     
    Quantity INT,                          
    ReliefCenterID INT,                   
    SupplierID INT,                        
    FOREIGN KEY (ReliefCenterID) REFERENCES ReliefCenter(CenterID) ON DELETE CASCADE ON UPDATE CASCADE,  
    FOREIGN KEY (SupplierID) REFERENCES InventorySupplier(SupplierID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 12. Relief Distribution Table
CREATE TABLE ReliefDistribution (
    DistributionID INT PRIMARY KEY,
    Date DATE NOT NULL,
    ReliefCenterID INT,
    HouseholdID INT,
    ItemsDistributed VARCHAR(255),
    FOREIGN KEY (ReliefCenterID) REFERENCES ReliefCenter(CenterID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (HouseholdID) REFERENCES Household(HouseholdID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 13. Health Report Table
CREATE TABLE HealthReport (
    ReportID INT PRIMARY KEY,
    Date DATE NOT NULL,
    MedicalCenterID INT,
    ResidentID INT,
    Diagnosis VARCHAR(255),
    Treatment VARCHAR(255),
    FOREIGN KEY (MedicalCenterID) REFERENCES MedicalCenter(MedicalCenterID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ResidentID) REFERENCES Resident(ResidentID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 14. Volunteer Assignment Table
CREATE TABLE VolunteerAssignment (
    AssignmentID INT PRIMARY KEY,
    VolunteerID INT,
    ReliefCenterID INT,
    Rolee_of_Volunteer VARCHAR(100),
    StartDate DATE NOT NULL,
    EndDate DATE,
    FOREIGN KEY (VolunteerID) REFERENCES Volunteer(VolunteerID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ReliefCenterID) REFERENCES ReliefCenter(CenterID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 15. Damage Report Table
CREATE TABLE DamageReport (
    ReportID INT PRIMARY KEY,
    DamageID INT,
    ReporterID INT,
    ReportDate DATE NOT NULL,
    DamageLocation VARCHAR(255),
    DamageDetails VARCHAR(255),
    FOREIGN KEY (DamageID) REFERENCES InfrastructureDamage(DamageID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 16. Shelter Site Table
CREATE TABLE ShelterSite (
    SiteID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(255),
    Capacity INT,
    CurrentOccupancy INT,
    AreaID INT NOT NULL,
    FOREIGN KEY (AreaID) REFERENCES Area(AreaID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 17. Transport Logistics Table
CREATE TABLE TransportLogistics (
    TransportID INT PRIMARY KEY,
    Route VARCHAR(255),
    VehicleType VARCHAR(50),
    DriverID INT,
    Capacity INT,
    ReliefCenterID INT,
    FOREIGN KEY (ReliefCenterID) REFERENCES ReliefCenter(CenterID) ON DELETE CASCADE ON UPDATE CASCADE
);


-- 18. Health Survey Table
CREATE TABLE HealthSurvey (
    SurveyID INT PRIMARY KEY AUTO_INCREMENT,
    ResidentID INT,
    SurveyDate DATE,
    HealthStatus VARCHAR(255),
    Symptoms VARCHAR(255),
    TreatmentReceived Boolean,
    SurveyorName VARCHAR(100),
    SurveyType VARCHAR(50),
    MentalHealthStatus VARCHAR(255),
    NextFollowUpDate DATE,
    FOREIGN KEY (ResidentID) REFERENCES Resident(ResidentID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 19. Emergency Contact Table
CREATE TABLE EmergencyContact (
    ContactID INT PRIMARY KEY AUTO_INCREMENT,
    ResidentID INT,
    Name VARCHAR(100),
    Relationship VARCHAR(50),
    PhoneNumber VARCHAR(20),
    Email VARCHAR(100),
    FOREIGN KEY (ResidentID) REFERENCES Resident(ResidentID) ON DELETE CASCADE ON UPDATE CASCADE
);


-- 20. Feedback Table
CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY AUTO_INCREMENT,
    GivenBy VARCHAR(100), 
    FeedbackDate DATE,
    Comments TEXT,
    Rating INT, 
    RelatedEventID INT, 
    FOREIGN KEY (RelatedEventID) REFERENCES Resident(ResidentID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 1
INSERT INTO Area (AreaID, Name, Location, Population, FloodRiskLevel, AffectedPopulationCount)
VALUES
(1, 'Fulgazi', 'Feni', 30000, 'High', 25000),
(2, 'Parshuram', 'Feni', 20000, 'High', 18000),
(3, 'Chagalnaiya', 'Feni', 25000, 'Medium', 15000),
(4, 'Daganbhuiyan', 'Feni', 27000, 'Medium', 20000),
(5, 'Feni Sadar', 'Feni', 40000, 'High', 35000),
(6, 'Rajapur', 'Feni', 15000, 'Low', 5000),
(7, 'Sonagazi', 'Feni', 20000, 'Medium', 12000),
(8, 'Chhagalnaiya', 'Feni', 22000, 'High', 20000),
(9, 'Munshirhat', 'Feni', 18000, 'Medium', 14000),
(10, 'Lalpur', 'Feni', 12000, 'Low', 3000),
(11, 'Bardal', 'Feni', 10000, 'Low', 2000),
(12, 'Pathan Nagar', 'Feni', 11000, 'Medium', 6000),
(13, 'Dharmapur', 'Feni', 14000, 'Medium', 8000),
(14, 'Motiganj', 'Feni', 18000, 'High', 16000),
(15, 'Ekdilpur', 'Feni', 13000, 'Low', 5000),
(16, 'Purba Maijdi', 'Feni', 9000, 'Low', 2000),
(17, 'Paschim Maijdi', 'Feni', 9500, 'Medium', 4000),
(18, 'Matiranga', 'Feni', 11500, 'Medium', 7000),
(19, 'Char Ilisha', 'Feni', 8700, 'High', 8000),
(20, 'Hossainpur', 'Feni', 10500, 'Medium', 5500);

-- 2
INSERT INTO Household (HouseholdID, Address, AreaID, TotalMembers, IncomeLevel)
VALUES
(1, 'Fulgazi Block A', 1, 5, 'Low'),
(2, 'Parshuram Center', 2, 4, 'Medium'),
(3, 'Chagalnaiya South', 3, 6, 'Low'),
(4, 'Daganbhuiyan East', 4, 7, 'Medium'),
(5, 'Feni Sadar West', 5, 8, 'High'),
(6, 'Rajapur Village 1', 6, 4, 'Low'),
(7, 'Sonagazi Upazila', 7, 5, 'Medium'),
(8, 'Chhagalnaiya Ward 2', 8, 6, 'Medium'),
(9, 'Munshirhat Road', 9, 3, 'Low'),
(10, 'Lalpur Colony', 10, 7, 'Low'),
(11, 'Bardal Lane 3', 11, 4, 'Low'),
(12, 'Pathan Nagar Block C', 12, 5, 'Medium'),
(13, 'Dharmapur South', 13, 3, 'Medium'),
(14, 'Motiganj South', 14, 6, 'High'),
(15, 'Ekdilpur Junction', 15, 4, 'Medium'),
(16, 'Purba Maijdi North', 16, 5, 'Low'),
(17, 'Paschim Maijdi Block D', 17, 7, 'Medium'),
(18, 'Matiranga Center', 18, 6, 'Medium'),
(19, 'Char Ilisha West', 19, 8, 'High'),
(20, 'Hossainpur South', 20, 4, 'Medium');


-- 3
INSERT INTO Resident (ResidentID, Name, Age, Gender, HouseholdID, DisabilityStatus, EmploymentStatus)
VALUES
(1, 'Md. Rafiq', 40, 'Male', 1, FALSE, 'Employed'),
(2, 'Amina Khatun', 35, 'Female', 1, FALSE, 'Unemployed'),
(3, 'Rahim Uddin', 70, 'Male', 2, TRUE, 'Retired'),
(4, 'Shirin Akter', 25, 'Female', 3, FALSE, 'Student'),
(5, 'Nazmul Islam', 50, 'Male', 4, FALSE, 'Employed'),
(6, 'Kamal Hossain', 45, 'Male', 5, TRUE, 'Unemployed'),
(7, 'Fatema Begum', 30, 'Female', 6, FALSE, 'Student'),
(8, 'Jannatul Ferdous', 20, 'Female', 7, FALSE, 'Student'),
(9, 'Abul Kalam', 55, 'Male', 8, TRUE, 'Retired'),
(10, 'Shamima Akter', 38, 'Female', 9, FALSE, 'Unemployed'),
(11, 'Tariqul Islam', 32, 'Male', 10, FALSE, 'Employed'),
(12, 'Nasima Sultana', 28, 'Female', 11, FALSE, 'Other'),
(13, 'Rokeya Sultana', 65, 'Female', 12, TRUE, 'Retired'),
(14, 'Mahmudul Hasan', 50, 'Male', 13, FALSE, 'Employed'),
(15, 'Sadia Afrin', 22, 'Female', 14, FALSE, 'Student'),
(16, 'Hasan Ahmed', 18, 'Male', 15, FALSE, 'Student'),
(17, 'Rubina Akter', 45, 'Female', 16, FALSE, 'Other'),
(18, 'Shafiqur Rahman', 42, 'Male', 17, TRUE, 'Unemployed'),
(19, 'Sultana Akhter', 29, 'Female', 18, FALSE, 'Other'),
(20, 'Nurul Amin', 60, 'Male', 19, TRUE, 'Retired');

-- 4
INSERT INTO ReliefCenter (CenterID, Name, AreaID, Capacity, IsActive)
VALUES
(1, 'Fulgazi Relief Point', 1, 500, TRUE),
(2, 'Parshuram Help Hub', 2, 300, TRUE),
(3, 'Chagalnaiya Assistance Center', 3, 400, TRUE),
(4, 'Daganbhuiyan Relief Station', 4, 600, FALSE),
(5, 'Feni Sadar Distribution Hub', 5, 700, TRUE),
(6, 'Rajapur Support Center', 6, 450, TRUE),
(7, 'Sonagazi Emergency Shelter', 7, 550, FALSE),
(8, 'Chhagalnaiya Aid Base', 8, 500, TRUE),
(9, 'Munshirhat Relief Post', 9, 300, TRUE),
(10, 'Lalpur Help Center', 10, 400, FALSE),
(11, 'Bardal Community Relief', 11, 350, TRUE),
(12, 'Pathan Nagar Aid Station', 12, 600, TRUE),
(13, 'Dharmapur Medical Relief', 13, 500, FALSE),
(14, 'Motiganj Aid Point', 14, 700, TRUE),
(15, 'Ekdilpur Disaster Center', 15, 650, FALSE),
(16, 'Purba Maijdi Help Center', 16, 550, TRUE),
(17, 'Paschim Maijdi Relief Hub', 17, 450, TRUE),
(18, 'Matiranga Assistance Post', 18, 600, FALSE),
(19, 'Char Ilisha Support Base', 19, 800, TRUE),
(20, 'Hossainpur Aid Station', 20, 400, TRUE);


-- 5
INSERT INTO MedicalCenter (MedicalCenterID, Name, Location, AreaID, Capacity)
VALUES
(1, 'Fulgazi Medical Hub', 'Fulgazi Town', 1, 200),
(2, 'Parshuram Health Center', 'Parshuram Upazila', 2, 150),
(3, 'Chagalnaiya Clinic', 'Chagalnaiya Bazar', 3, 250),
(4, 'Daganbhuiyan Hospital', 'Daganbhuiyan East', 4, 300),
(5, 'Feni Sadar Medical Center', 'Feni Sadar Block', 5, 400),
(6, 'Rajapur Rural Clinic', 'Rajapur Village', 6, 180),
(7, 'Sonagazi Aid Hospital', 'Sonagazi Junction', 7, 220),
(8, 'Chhagalnaiya Emergency Center', 'Chhagalnaiya Town', 8, 250),
(9, 'Munshirhat Health Hub', 'Munshirhat Road', 9, 200),
(10, 'Lalpur Health Center', 'Lalpur Colony', 10, 300),
(11, 'Bardal Community Clinic', 'Bardal Lane', 11, 250),
(12, 'Pathan Nagar Medical Center', 'Pathan Nagar Block C', 12, 400),
(13, 'Dharmapur Rural Clinic', 'Dharmapur Village', 13, 180),
(14, 'Motiganj Emergency Hub', 'Motiganj Block', 14, 300),
(15, 'Ekdilpur Disaster Clinic', 'Ekdilpur Road', 15, 350),
(16, 'Purba Maijdi Aid Center', 'Purba Maijdi', 16, 200),
(17, 'Paschim Maijdi Rural Hospital', 'Paschim Maijdi', 17, 300),
(18, 'Matiranga Health Hub', 'Matiranga Center', 18, 400),
(19, 'Char Ilisha Rural Aid', 'Char Ilisha South', 19, 500),
(20, 'Hossainpur Medical Aid', 'Hossainpur Village', 20, 220);


-- 6
INSERT INTO Organization (OrganizationID, Name, Type, ContactInfo, TotalReliefFunds, AreaID)
VALUES
(1, 'Sunah Relief Society', 'NGO', 'sunah.relief@gmail.com', 50000.00, 1),
(2, 'Red Crescent Society', 'NGO', 'info@redcrescent.org', 100000.00, 2),
(3, 'Feni Aid Organization', 'NGO', 'feni.aid@gmail.com', 75000.00, 3),
(4, 'Parshuram Relief Group', 'NGO', 'parshuram.relief@gmail.com', 40000.00, 4),
(5, 'Chagalnaiya Relief Team', 'NGO', 'chagalnaiya.aid@mail.com', 30000.00, 5),
(6, 'Motiganj Aid Center', 'NGO', 'motiganj.help@gmail.com', 60000.00, 6),
(7, 'Rajapur Emergency Society', 'NGO', 'rajapur.emergency@gmail.com', 55000.00, 7),
(8, 'Bardal Support Organization', 'NGO', 'bardal.support@gmail.com', 45000.00, 8),
(9, 'Purba Maijdi Aid Group', 'NGO', 'purba.aid@gmail.com', 70000.00, 9),
(10, 'Sonagazi Emergency Relief', 'NGO', 'sonagazi.relay@mail.com', 50000.00, 10),
(11, 'Dharmapur Aid Council', 'NGO', 'dharmapur.aid@gmail.com', 30000.00, 11),
(12, 'Fulgazi Support Organization', 'NGO', 'fulgazi.support@gmail.com', 80000.00, 12),
(13, 'Matiranga Assistance Group', 'NGO', 'matiranga.aid@gmail.com', 55000.00, 13),
(14, 'Hossainpur Emergency Team', 'NGO', 'hossainpur.team@gmail.com', 45000.00, 14),
(15, 'Red Shield Aid Society', 'NGO', 'redshield.aid@gmail.com', 65000.00, 15),
(16, 'Ekdilpur Support Society', 'NGO', 'ekdilpur.support@gmail.com', 30000.00, 16),
(17, 'Pathan Nagar Relief Organization', 'NGO', 'pathan.nagar.relief@gmail.com', 70000.00, 17),
(18, 'Sonagazi Welfare Council', 'NGO', 'sonagazi.welfare@gmail.com', 55000.00, 18),
(19, 'Char Aid Assistance Group', 'NGO', 'char.aid.group@gmail.com', 50000.00, 19),
(20, 'Chhagalnaiya Emergency Relief', 'NGO', 'chhagalnaiya.relief@gmail.com', 45000.00, 20);

-- 7
INSERT INTO Donation (DonationID, Amount, Date, DonationType, OrganizationID, ReliefCenterID)
VALUES
(1, 50000.00, '2024-11-01', 'Financial Aid', 1, 1),
(2, 15000.00, '2024-11-02', 'Medical Supplies', 2, 2),
(3, 20000.00, '2024-11-03', 'Clothing', 3, 3),
(4, 30000.00, '2024-11-04', 'Food Packages', 4, 4),
(5, 25000.00, '2024-11-05', 'Sanitation Kits', 5, 5),
(6, 18000.00, '2024-11-06', 'Tools & Equipment', 6, 6),
(7, 10000.00, '2024-11-07', 'Water Supply Kits', 7, 7),
(8, 12000.00, '2024-11-08', 'Electrical Materials', 8, 8),
(9, 15000.00, '2024-11-09', 'Emergency Blankets', 9, 9),
(10, 5000.00, '2024-11-10', 'Miscellaneous Aid', 10, 10),
(11, 40000.00, '2024-11-11', 'Medical Equipment', 11, 11),
(12, 17000.00, '2024-11-12', 'First Aid Kits', 12, 12),
(13, 14000.00, '2024-11-13', 'Clothing', 13, 13),
(14, 23000.00, '2024-11-14', 'Food Packages', 14, 14),
(15, 27000.00, '2024-11-15', 'Sanitation Kits', 15, 15),
(16, 19000.00, '2024-11-16', 'Financial Aid', 16, 16),
(17, 21000.00, '2024-11-17', 'Medical Supplies', 17, 17),
(18, 16000.00, '2024-11-18', 'Blankets', 18, 18),
(19, 24000.00, '2024-11-19', 'Water Supply Kits', 19, 19),
(20, 22000.00, '2024-11-20', 'Food Packages', 20, 20);



 -- 8
INSERT INTO Volunteer (VolunteerID, Name, ContactInfo, OrganizationID, Skillset, Availability)
VALUES
(1, 'Aminul Islam', 'aminul@gmail.com', 1, 'Medical Aid, First Aid', TRUE),
(2, 'Sofia Karim', 'sofia.karim@gmail.com', 2, 'Clothing Distribution', TRUE),
(3, 'Rafi Ahmed', 'rafi.ahmed@gmail.com', 3, 'Food Supply Management', TRUE),
(4, 'Hasina Chowdhury', 'hasina.c@gmail.com', 4, 'Sanitation Assistance', TRUE),
(5, 'Shahriar Alam', 'shahriar.alam@gmail.com', 5, 'Logistics Management', TRUE),
(6, 'Rina Sultana', 'rina.sultana@gmail.com', 6, 'Blanket Distribution', TRUE),
(7, 'Imran Kabir', 'imran.kabir@gmail.com', 7, 'Electrical Repairs', TRUE),
(8, 'Farzana Haque', 'farzana.haque@gmail.com', 8, 'Medical Supplies Handling', TRUE),
(9, 'Mujib Hasan', 'mujib.hasan@gmail.com', 9, 'Clothing Management', TRUE),
(10, 'Ayesha Akter', 'ayesha.akter@gmail.com', 10, 'Water Supply Logistics', TRUE),
(11, 'Sajib Roy', 'sajib.roy@gmail.com', 11, 'Distribution Coordination', TRUE),
(12, 'Jannat Begum', 'jannat.begum@gmail.com', 12, 'Hygiene Kit Preparation', TRUE),
(13, 'Rakib Mahmud', 'rakib.mahmud@gmail.com', 13, 'Tool Distribution', TRUE),
(14, 'Sara Alam', 'sara.alam@gmail.com', 14, 'Relief Logistics', TRUE),
(15, 'Nashit Chowdhury', 'nashit@gmail.com', 15, 'Food Inventory', TRUE),
(16, 'Tanjim Alam', 'tanjim.alam@gmail.com', 16, 'Water Distribution', TRUE),
(17, 'Mokbul Hossain', 'mokbul.hossain@gmail.com', 17, 'Emergency Support', TRUE),
(18, 'Shimi Karim', 'shimi.karim@gmail.com', 18, 'Medical Assistance', TRUE),
(19, 'Noman Ahmed', 'noman.ahmed@gmail.com', 19, 'Relief Transportation', TRUE),
(20, 'Safiul Islam', 'safiul.islam@gmail.com', 20, 'Volunteer Coordination', TRUE);
-- 9
INSERT INTO InfrastructureDamage (DamageID, Type, Severity, AreaID, RepairStatus)
VALUES
(1, 'Road', 'Severe', 1, 'Pending'),
(2, 'Structural', 'Critical', 2, 'Under Repair'),
(3, 'Electrical', 'Moderate', 3, 'In Progress'),
(4, 'Plumbing', 'Severe', 4, 'Pending'),
(5, 'Water', 'Critical', 5, 'Under Repair'),
(6, 'Road', 'Moderate', 6, 'Completed'),
(7, 'Structural', 'Critical', 7, 'Pending'),
(8, 'Electrical', 'Severe', 8, 'In Progress'),
(9, 'Plumbing', 'Moderate', 9, 'Pending'),
(10, 'Water', 'Severe', 10, 'Under Repair'),
(11, 'Road', 'Critical', 11, 'Pending'),
(12, 'Structural', 'Moderate', 12, 'Completed'),
(13, 'Electrical', 'Critical', 13, 'Pending'),
(14, 'Plumbing', 'Severe', 14, 'In Progress'),
(15, 'Water', 'Critical', 15, 'Under Repair'),
(16, 'Road', 'Moderate', 16, 'Completed'),
(17, 'Structural', 'Severe', 17, 'Pending'),
(18, 'Electrical', 'Moderate', 18, 'In Progress'),
(19, 'Plumbing', 'Critical', 19, 'Pending'),
(20, 'Water', 'Severe', 20, 'Under Repair');


-- 10 
INSERT INTO InventorySupplier (SupplierID, Name, ContactInfo, SupplyType, ReliabilityRating, ReliefCenterID)
VALUES
(1, 'Sunah Supplies', 'sunah.supplies@gmail.com', 'Clothing', 4.5, 1),
(2, 'Red Crescent Logistics', 'info@redcrescentlog.com', 'Medical Supplies', 4.8, 2),
(3, 'Feni Aid Suppliers', 'feni.aid@gmail.com', 'Food Supplies', 4.2, 3),
(4, 'Parshuram Relief Co.', 'parshuram.relief@gmail.com', 'Sanitation Kits', 4.3, 4),
(5, 'Chagalnaiya Distributors', 'chagalnaiya.dist@gmail.com', 'Blankets', 4.6, 5),
(6, 'Motiganj Supply Center', 'motiganj.supply@gmail.com', 'Tools', 4.4, 6),
(7, 'Rajapur Suppliers', 'rajapur.supplier@gmail.com', 'Electrical Materials', 4.7, 7),
(8, 'Bardal Relief Suppliers', 'bardal.relief@gmail.com', 'Water Supply Kits', 4.3, 8),
(9, 'Purba Aid Logistics', 'purba.aid@gmail.com', 'Medical Equipment', 4.5, 9),
(10, 'Sonagazi Goods Distribution', 'sonagazi.goods@gmail.com', 'Food Inventory', 4.2, 10),
(11, 'Dharmapur Aid Co.', 'dharmapur.aid@gmail.com', 'Clothing', 4.3, 11),
(12, 'Fulgazi Relief Suppliers', 'fulgazi.relief@gmail.com', 'Blankets', 4.6, 12),
(13, 'Matiranga Distributors', 'matiranga.dist@gmail.com', 'Sanitation Kits', 4.4, 13),
(14, 'Hossainpur Aid Group', 'hossainpur.aid@gmail.com', 'Medical Supplies', 4.5, 14),
(15, 'Red Shield Logistics', 'redshield.log@gmail.com', 'Food Supply', 4.7, 15),
(16, 'Ekdilpur Aid Center', 'ekdilpur.aid@gmail.com', 'Tools', 4.3, 16),
(17, 'Pathan Nagar Supplies', 'pathan.supply@gmail.com', 'Electrical Kits', 4.5, 17),
(18, 'Sonagazi Distribution', 'sonagazi.distribution@gmail.com', 'Water Supply Kits', 4.6, 18),
(19, 'Char Relief Suppliers', 'char.relief@gmail.com', 'Clothing', 4.4, 19),
(20, 'Chhagalnaiya Relief Logistics', 'chhagalnaiya.log@gmail.com', 'Blankets', 4.5, 20);

-- 11
INSERT INTO ResourceInventory (ResourceID, Type, Quantity, ReliefCenterID, SupplierID)
VALUES
(1, 'Clothing', 500, 1, 1),
(2, 'Medical Supplies', 300, 2, 2),
(3, 'Food Supplies', 1000, 3, 3),
(4, 'Sanitation Kits', 400, 4, 4),
(5, 'Blankets', 800, 5, 5),
(6, 'Tools', 250, 6, 6),
(7, 'Electrical Materials', 300, 7, 7),
(8, 'Water Supply Kits', 600, 8, 8),
(9, 'Medical Equipment', 500, 9, 9),
(10, 'Food Inventory', 1200, 10, 10),
(11, 'Clothing', 450, 11, 11),
(12, 'Blankets', 700, 12, 12),
(13, 'Sanitation Kits', 300, 13, 13),
(14, 'Medical Supplies', 400, 14, 14),
(15, 'Food Supply', 1000, 15, 15),
(16, 'Tools', 500, 16, 16),
(17, 'Electrical Kits', 300, 17, 17),
(18, 'Water Supply Kits', 700, 18, 18),
(19, 'Clothing', 400, 19, 19),
(20, 'Blankets', 900, 20, 20);

-- 12
INSERT INTO ReliefDistribution (DistributionID, Date, ReliefCenterID, HouseholdID, ItemsDistributed)
VALUES
(1, '2024-11-01', 1, 1, 'Clothing, Food Supplies'),
(2, '2024-11-02', 2, 2, 'Medical Supplies, Blankets'),
(3, '2024-11-03', 3, 3, 'Sanitation Kits, Tools'),
(4, '2024-11-04', 4, 4, 'Water Supply Kits, Food Supplies'),
(5, '2024-11-05', 5, 5, 'Clothing, Sanitation Kits'),
(6, '2024-11-06', 6, 6, 'Electrical Materials, Tools'),
(7, '2024-11-07', 7, 7, 'Medical Supplies, Blankets'),
(8, '2024-11-08', 8, 8, 'Food Supplies, Water Kits'),
(9, '2024-11-09', 9, 9, 'Clothing, Sanitation Kits'),
(10, '2024-11-10', 10, 10, 'Food Inventory, Tools'),
(11, '2024-11-11', 11, 11, 'Medical Supplies, Blankets'),
(12, '2024-11-12', 12, 12, 'Sanitation Kits, Electrical Materials'),
(13, '2024-11-13', 13, 13, 'Food Supplies, Tools'),
(14, '2024-11-14', 14, 14, 'Clothing, Water Supply Kits'),
(15, '2024-11-15', 15, 15, 'Medical Supplies, Sanitation Kits'),
(16, '2024-11-16', 16, 16, 'Tools, Food Supplies'),
(17, '2024-11-17', 17, 17, 'Electrical Kits, Blankets'),
(18, '2024-11-18', 18, 18, 'Water Supply Kits, Tools'),
(19, '2024-11-19', 19, 19, 'Clothing, Food Supplies'),
(20, '2024-11-20', 20, 20, 'Blankets, Sanitation Kits');

-- 13
INSERT INTO HealthReport (ReportID, Date, MedicalCenterID, ResidentID, Diagnosis, Treatment)
VALUES
(1, '2024-11-01', 1, 1, 'Flu', 'Antiviral medication'),
(2, '2024-11-02', 2, 2, 'Malnutrition', 'Nutritional supplements'),
(3, '2024-11-03', 3, 3, 'Headache', 'Pain relief medication'),
(4, '2024-11-04', 4, 4, 'Waterborne illness', 'Hydration and antibiotics'),
(5, '2024-11-05', 5, 5, 'Cold', 'Rest and warm clothing'),
(6, '2024-11-06', 6, 6, 'Skin Rashes', 'Topical ointments'),
(7, '2024-11-07', 7, 7, 'Typhoid', 'Antibiotic treatment'),
(8, '2024-11-08', 8, 8, 'Diarrhea', 'Oral rehydration solution'),
(9, '2024-11-09', 9, 9, 'Stomach Ache', 'Digestive medicines'),
(10, '2024-11-10', 10, 10, 'High Fever', 'Paracetamol'),
(11, '2024-11-11', 11, 11, 'Ear Infection', 'Antibiotic ear drops'),
(12, '2024-11-12', 12, 12, 'Dehydration', 'IV fluids and hydration'),
(13, '2024-11-13', 13, 13, 'Cough', 'Cough syrup'),
(14, '2024-11-14', 14, 14, 'Back Pain', 'Physiotherapy and exercises'),
(15, '2024-11-15', 15, 15, 'Fatigue', 'Balanced diet and rest'),
(16, '2024-11-16', 16, 16, 'Malaria', 'Antimalarial treatment'),
(17, '2024-11-17', 17, 17, 'Anemia', 'Iron supplements'),
(18, '2024-11-18', 18, 18, 'Wound Infection', 'Antiseptic application'),
(19, '2024-11-19', 19, 19, 'Allergy', 'Antihistamines'),
(20, '2024-11-20', 20, 20, 'Vision Problems', 'Eye check-up and glasses');


-- 14
INSERT INTO VolunteerAssignment (AssignmentID, VolunteerID, ReliefCenterID, Rolee_of_Volunteer, StartDate, EndDate)
VALUES
(1, 1, 1, 'Food Distribution', '2024-11-01', '2024-11-10'),
(2, 2, 2, 'Medical Assistance', '2024-11-02', '2024-11-12'),
(3, 3, 3, 'Sanitation Support', '2024-11-03', '2024-11-14'),
(4, 4, 4, 'Water Supply Distribution', '2024-11-04', '2024-11-15'),
(5, 5, 5, 'Blanket Distribution', '2024-11-05', '2024-11-16'),
(6, 6, 6, 'Clothing Distribution', '2024-11-06', '2024-11-17'),
(7, 7, 7, 'Medical Checkups', '2024-11-07', '2024-11-18'),
(8, 8, 8, 'Tool Distribution', '2024-11-08', '2024-11-19'),
(9, 9, 9, 'Relief Center Maintenance', '2024-11-09', '2024-11-20'),
(10, 10, 10, 'Transport Logistics Support', '2024-11-10', '2024-11-21'),
(11, 11, 11, 'Food Supply Coordination', '2024-11-11', '2024-11-22'),
(12, 12, 12, 'Sanitation Kit Distribution', '2024-11-12', '2024-11-23'),
(13, 13, 13, 'Medical Supplies Handling', '2024-11-13', '2024-11-24'),
(14, 14, 14, 'Clothing Sorting', '2024-11-14', '2024-11-25'),
(15, 15, 15, 'Volunteer Training', '2024-11-15', '2024-11-26'),
(16, 16, 16, 'Support Team Coordination', '2024-11-16', '2024-11-27'),
(17, 17, 17, 'Water Distribution Logistics', '2024-11-17', '2024-11-28'),
(18, 18, 18, 'Road Repair Support', '2024-11-18', '2024-11-29'),
(19, 19, 19, 'Shelter Setup Assistance', '2024-11-19', '2024-11-30'),
(20, 20, 20, 'Volunteer Communication Management', '2024-11-20', '2024-12-01');

-- 15
INSERT INTO DamageReport (ReportID, DamageID, ReporterID, ReportDate, DamageLocation, DamageDetails)
VALUES
(1, 1, 1, '2024-11-01', 'Village Area 5', 'Severe road collapse due to flooding'),
(2, 2, 2, '2024-11-02', 'Near Relief Center 2', 'Water supply system failure'),
(3, 3, 3, '2024-11-03', 'Shelter Site 10', 'Structural damage in shelter walls'),
(4, 4, 4, '2024-11-04', 'Area 8 main road', 'Road completely washed away'),
(5, 5, 5, '2024-11-05', 'Household 15', 'Furniture damage from water flooding'),
(6, 6, 6, '2024-11-06', 'Medical Center Location', 'Electrical systems malfunction'),
(7, 7, 7, '2024-11-07', 'Relief Center 7', 'Plumbing system failure'),
(8, 8, 8, '2024-11-08', 'Household 9', 'Walls cracked due to soil erosion'),
(9, 9, 9, '2024-11-09', 'Area 3', 'Collapsed electricity poles'),
(10, 10, 10, '2024-11-10', 'Road connecting villages', 'Road surface damage'),
(11, 11, 11, '2024-11-11', 'Shelter Area 4', 'Damaged tents and water infiltration'),
(12, 12, 12, '2024-11-12', 'Near Local Clinic', 'Supply storage roof torn'),
(13, 13, 13, '2024-11-13', 'Village Area 2', 'Widespread electrical outages'),
(14, 14, 14, '2024-11-14', 'Community Hall', 'Roof collapsed during heavy rain'),
(15, 15, 15, '2024-11-15', 'Relief Distribution Site', 'Tools and infrastructure lost'),
(16, 16, 16, '2024-11-16', 'Main Village Road', 'Severe water erosion damage'),
(17, 17, 17, '2024-11-17', 'Area 12', 'Cracked streets due to soil displacement'),
(18, 18, 18, '2024-11-18', 'Near Transportation Hub', 'Transportation vehicles submerged'),
(19, 19, 19, '2024-11-19', 'Local Market Area', 'Market goods lost due to flooding'),
(20, 20, 20, '2024-11-20', 'Residential Area', 'Collapsed walls and floors');

-- 16
INSERT INTO ShelterSite (SiteID, Name, Location, Capacity, CurrentOccupancy, AreaID)
VALUES
(1, 'Sunah Shelter', 'Village Area 5', 100, 90, 1),
(2, 'Red Crescent Shelter', 'Near Relief Center 2', 150, 140, 2),
(3, 'Central Community Hall', 'Area 3 main road', 120, 110, 3),
(4, 'Local Emergency Hub', 'Near Hospital Area', 80, 70, 4),
(5, 'Temporary Relief Site', 'East Side of Village Area 2', 50, 45, 5),
(6, 'Mud Shelter Site', 'Near Local Clinic', 75, 65, 6),
(7, 'West Village Shelter', 'Area 7 Main Street', 60, 55, 7),
(8, 'Shelter Hub 12', 'Near Market Area', 100, 95, 8),
(9, 'Residential Emergency Shelter', 'Local Residential Block', 150, 130, 9),
(10, 'Community Relief Hub', 'Central Market Area', 80, 75, 10),
(11, 'Village Roadside Shelter', 'Near Main Road', 50, 40, 11),
(12, 'Temporary Relief Tent', 'Near Transportation Hub', 70, 60, 12),
(13, 'Evacuation Center', 'Main Village Square', 120, 110, 13),
(14, 'School Shelter Site', 'Area School Grounds', 100, 85, 14),
(15, 'Temporary Shelter 3', 'Back Streets Area 6', 60, 55, 15),
(16, 'Relief Distribution Site', 'Near Transport Logistics', 80, 70, 16),
(17, 'Area Hospital Support Shelter', 'Hospital Grounds', 90, 80, 17),
(18, 'Central Temporary Shelter', 'Near Village Area 4', 120, 110, 18),
(19, 'Southern Emergency Hub', 'South Village Area', 150, 140, 19),
(20, 'Community Emergency Hall', 'Main Square Area', 100, 90, 20);

-- 17

INSERT INTO TransportLogistics (TransportID, Route, VehicleType, DriverID, Capacity, ReliefCenterID)
VALUES
(1, 'Village 5 to Central Hub', 'Truck', 1, 10, 1),
(2, 'Area 3 to Relief Center', 'Bus', 2, 40, 2),
(3, 'Shelter Site 10 to Medical Center', 'Ambulance', 3, 5, 3),
(4, 'Market Distribution Hub', 'Van', 4, 15, 4),
(5, 'Central Emergency Hub Route', 'Pickup Truck', 5, 8, 5),
(6, 'Main Road to Village Areas', 'Delivery Truck', 6, 12, 6),
(7, 'East Village to Hospital Support', 'Van', 7, 15, 7),
(8, 'Relief Center to Temporary Shelter', 'Truck', 8, 10, 8),
(9, 'South Village Roads', 'Minibus', 9, 20, 9),
(10, 'Transporting Goods from Suppliers', 'Van', 10, 15, 10),
(11, 'Village Distribution Road', '3-Wheeler', 11, 5, 11),
(12, 'Area 12 to Emergency Hub', 'Bus', 12, 20, 12),
(13, 'Transport from Market to Relief Center', 'Truck', 13, 25, 13),
(14, 'Shelter Area Logistics', 'Pickup Truck', 14, 10, 14),
(15, 'School Road Emergency Transport', 'Van', 15, 15, 15),
(16, 'Temporary Shelter 3 Logistics', '3-Wheeler', 16, 5, 16),
(17, 'Central Support Hub Logistics', 'Bus', 17, 20, 17),
(18, 'Village Main Road Transport', 'Delivery Truck', 18, 12, 18),
(19, 'Relief Distribution to Roadside Centers', 'Pickup Truck', 19, 10, 19),
(20, 'Warehouse Supply to Central Relief Hub', 'Truck', 20, 25, 20);

-- 18
INSERT INTO HealthSurvey (SurveyID, ResidentID, SurveyDate, HealthStatus, Symptoms, TreatmentReceived, SurveyorName, SurveyType, MentalHealthStatus, NextFollowUpDate)
VALUES
(1, 1, '2024-11-01', 'Critical', 'Fever, cough', TRUE, 'Dr. Ayesha', 'Emergency', 'High Stress', '2024-11-10'),
(2, 2, '2024-11-02', 'Stable', 'Headache, fatigue', TRUE, 'Dr. Karim', 'Routine', 'Moderate Stress', '2024-11-12'),
(3, 3, '2024-11-03', 'Critical', 'Shortness of breath', TRUE, 'Dr. Samina', 'Emergency', 'Severe Anxiety', '2024-11-11'),
(4, 4, '2024-11-04', 'Stable', 'Back pain, weakness', TRUE, 'Dr. Hasan', 'Routine', 'Low Stress', '2024-11-15'),
(5, 5, '2024-11-05', 'Critical', 'Chills, dehydration', TRUE, 'Dr. Monir', 'Emergency', 'High Anxiety', '2024-11-09'),
(6, 6, '2024-11-06', 'Stable', 'Cough, cold', TRUE, 'Dr. Rafi', 'Routine', 'Moderate Stress', '2024-11-14'),
(7, 7, '2024-11-07', 'Critical', 'Dizziness, headache', TRUE, 'Dr. Fatima', 'Emergency', 'High Stress', '2024-11-10'),
(8, 8, '2024-11-08', 'Stable', 'Joint pain, fatigue', TRUE, 'Dr. Alam', 'Routine', 'Low Anxiety', '2024-11-12'),
(9, 9, '2024-11-09', 'Critical', 'High fever, dehydration', TRUE, 'Dr. Amina', 'Emergency', 'Severe Anxiety', '2024-11-11'),
(10, 10, '2024-11-10', 'Stable', 'Cough, sore throat', TRUE, 'Dr. Tariq', 'Routine', 'Moderate Stress', '2024-11-14'),
(11, 11, '2024-11-11', 'Critical', 'Severe abdominal pain', TRUE, 'Dr. Zahid', 'Emergency', 'High Stress', '2024-11-10'),
(12, 12, '2024-11-12', 'Stable', 'Fatigue, headache', TRUE, 'Dr. Salma', 'Routine', 'Moderate Stress', '2024-11-13'),
(13, 13, '2024-11-13', 'Critical', 'Shortness of breath', TRUE, 'Dr. Khan', 'Emergency', 'Severe Anxiety', '2024-11-11'),
(14, 14, '2024-11-14', 'Stable', 'Cold symptoms', TRUE, 'Dr. Arif', 'Routine', 'Low Anxiety', '2024-11-15'),
(15, 15, '2024-11-15', 'Critical', 'High fever, chills', TRUE, 'Dr. Rehana', 'Emergency', 'High Stress', '2024-11-10'),
(16, 16, '2024-11-16', 'Stable', 'Muscle pain, fatigue', TRUE, 'Dr. Farhan', 'Routine', 'Moderate Stress', '2024-11-12'),
(17, 17, '2024-11-17', 'Critical', 'Severe headache, dehydration', TRUE, 'Dr. Sultana', 'Emergency', 'Severe Anxiety', '2024-11-11'),
(18, 18, '2024-11-18', 'Stable', 'Mild cough, fatigue', TRUE, 'Dr. Karim', 'Routine', 'Low Stress', '2024-11-14'),
(19, 19, '2024-11-19', 'Critical', 'Severe vomiting, dizziness', TRUE, 'Dr. Hina', 'Emergency', 'High Anxiety', '2024-11-09'),
(20, 20, '2024-11-20', 'Stable', 'Cold symptoms, back pain', TRUE, 'Dr. Rafi', 'Routine', 'Moderate Stress', '2024-11-15');

-- 19
INSERT INTO EmergencyContact (ContactID, ResidentID, Name, Relationship, PhoneNumber, Email)
VALUES
(1, 1, 'Aminul Islam', 'Father', '01712345678', 'aminul@example.com'),
(2, 2, 'Seroja Begum', 'Mother', '01723456789', 'seroja@example.com'),
(3, 3, 'Rahima Khatun', 'Sister', '01734567890', 'rahima@example.com'),
(4, 4, 'Salim Khan', 'Brother', '01745678901', 'salim@example.com'),
(5, 5, 'Farzana Karim', 'Wife', '01756789012', 'farzana@example.com'),
(6, 6, 'Rafi Uddin', 'Husband', '01767890123', 'rafi@example.com'),
(7, 7, 'Shila Sultana', 'Mother', '01778901234', 'shila@example.com'),
(8, 8, 'Jahangir Alam', 'Father', '01789012345', 'jahangir@example.com'),
(9, 9, 'Safiul Haque', 'Brother', '01790123456', 'safiul@example.com'),
(10, 10, 'Anika Jahan', 'Sister', '01801234567', 'anika@example.com'),
(11, 11, 'Mohammed Alam', 'Father', '01812345678', 'mohammed@example.com'),
(12, 12, 'Nilufa Yasmin', 'Wife', '01823456789', 'nilufa@example.com'),
(13, 13, 'Akram Hossain', 'Brother', '01834567890', 'akram@example.com'),
(14, 14, 'Ayesha Akter', 'Sister', '01845678901', 'ayesha@example.com'),
(15, 15, 'Imran Chowdhury', 'Husband', '01856789012', 'imran@example.com'),
(16, 16, 'Soma Akter', 'Sister', '01867890123', 'soma@example.com'),
(17, 17, 'Rafiul Karim', 'Father', '01878901234', 'rafiul@example.com'),
(18, 18, 'Tanjima Khan', 'Mother', '01889012345', 'tanjima@example.com'),
(19, 19, 'Amin Hossain', 'Brother', '01890123456', 'amin@example.com'),
(20, 20, 'Sultana Begum', 'Wife', '01901234567', 'sultana@example.com');

-- 20

INSERT INTO Feedback (FeedbackID, GivenBy, FeedbackDate, Comments, Rating, RelatedEventID) VALUES
(1, 'Resident', '2024-11-01', 'The relief distribution was very prompt and well-organized.', 5, 1),
(2, 'Resident', '2024-11-02', 'Shelter facilities need more cleaning and maintenance.', 3, 2),
(3, 'Volunteer', '2024-11-01', 'The transportation logistics were well-planned but had some delays.', 4, 3),
(4, 'Organization', '2024-11-01', 'We need more financial support to continue relief operations.', 4, 4),
(5, 'Resident', '2024-11-02', 'Medical services were insufficient in the shelter area.', 2, 5),
(6, 'Resident', '2024-11-03', 'Food distribution was sufficient and reached households on time.', 5, 6),
(7, 'Volunteer', '2024-11-01', 'More coordination is needed among volunteers for better efficiency.', 4, 7),
(8, 'Organization', '2024-11-03', 'Relief supplies were distributed adequately, but transportation was a concern.', 4, 8),
(9, 'Resident', '2024-11-04', 'Communication from relief teams was very helpful and informative.', 5, 9),
(10, 'Volunteer', '2024-11-02', 'The availability of resources and supplies was commendable.', 4, 10),
(11, 'Resident', '2024-11-03', 'Flood victims need better long-term support and rehabilitation.', 3, 11),
(12, 'Organization', '2024-11-04', 'We need more skilled volunteers for logistical support.', 4, 12),
(13, 'Resident', '2024-11-05', 'Shelter sites were overcrowded and lacked privacy.', 2, 13),
(14, 'Volunteer', '2024-11-04', 'Support from transportation logistics could be improved.', 3, 14),
(15, 'Organization', '2024-11-06', 'We require more funding to sustain ongoing relief efforts.', 5, 15),
(16, 'Resident', '2024-11-04', 'Healthcare facilities were overwhelmed during the flood peak.', 2, 16),
(17, 'Volunteer', '2024-11-05', 'The coordination among relief centers was commendable.', 4, 17),
(18, 'Organization', '2024-11-02', 'We need better communication channels to distribute supplies faster.', 4, 18),
(19, 'Resident', '2024-11-05', 'Feedback sessions for residents help in identifying real needs.', 5, 19),
(20, 'Volunteer', '2024-11-06', 'Logistical planning for transportation routes should be more efficient.', 4, 20);

 -- 1
SELECT * FROM Area;
-- 2
SELECT * FROM Household;
-- 3

SELECT * FROM Resident;
-- 4
SELECT * FROM ReliefCenter;
-- 5
SELECT * FROM MedicalCenter;
-- 6
SELECT * FROM Organization;
-- 7
SELECT * FROM Donation;
-- 8
SELECT * FROM Volunteer;
-- 9

SELECT * FROM InfrastructureDamage;
-- 10
SELECT * FROM InventorySupplier;
-- 11
SELECT * FROM ResourceInventory;
-- 12
SELECT * FROM ReliefDistribution;
-- 13
SELECT * FROM HealthReport;
-- 14
SELECT * FROM VolunteerAssignment  ;
-- 15
SELECT * FROM DamageReport;
-- 16
SELECT * FROM ShelterSite;
-- 17
SELECT * FROM TransportLogistics;
-- 18
SELECT * FROM HealthSurvey;
-- 19
SELECT * FROM EmergencyContact;
-- 20
SELECT * FROM Feedback ;




