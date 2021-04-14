DROP DATABASE MPK
CREATE DATABASE MPK
GO
USE MPK
CREATE TABLE Employee(
	ID_Employee INT PRIMARY KEY IDENTITY(1,1),
	[First Name] NVARCHAR(256) NOT NULL,
	[Last Name] NVARCHAR(256) NOT NULL,
	Address NVARCHAR(256) NULL,
	ID_Position CHAR(3) NOT NULL,
	ID_Depot INT NULL,
	ID_License NVARCHAR(10) NULL
)

CREATE TABLE Position(
	ID_Position CHAR(3) PRIMARY KEY,
	Salary MONEY NOT NULL,
	Bonus MONEY NULL
)

ALTER TABLE Employee
ADD CONSTRAINT [Held position]
FOREIGN KEY (ID_Position) REFERENCES Position(ID_Position)

CREATE TABLE Vehicle(
	ID_Vehicle INT PRIMARY KEY IDENTITY(100000,1), --100000 historic vehicles can exist
	[Vin Number] NVARCHAR(15) NOT NULL,
	[Brand] NVARCHAR(256) NOT NULL,
	[Production date] DATE,
	[Low floor] BIT NOT NULL,
	ID_Depot INT NOT NULL,
	ID_Type INT NOT NULL
)

CREATE TABLE [Historic Vehicle](
	ID_Vehicle INT PRIMARY KEY IDENTITY(1,1), CHECK(ID_Vehicle < 100000),
	[Vin Number] NVARCHAR(15) NOT NULL,
	[Brand] NVARCHAR(256) NOT NULL,
	[Production date] DATETIME,
	[Primary city] NVARCHAR(256),
	ID_Depot INT NOT NULL,
	ID_Type INT NOT NULL
)

CREATE TABLE [Vehicle type](
	ID_type INT PRIMARY KEY IDENTITY(1,1),
	Category NVARCHAR(256) NOT NULL,
	Capacity INT NOT NULL,
	ID_Licece NVARCHAR(10)
)

CREATE TABLE [Service part](
	ID_Part INT PRIMARY KEY IDENTITY(1,1),
	Name NVARCHAR(256),
	Quantity INT, CHECK(Quantity >= 0),
	[Min quantity] INT NULL DEFAULT NULL,
	[Restock quantity] INT NULL DEFAULT NULL,
	Description NVARCHAR(MAX),
	ID_Depot INT NOT NULL,
	ID_Type INT NOT NULL
)

CREATE TABLE Depot(
	ID_Depot INT PRIMARY KEY IDENTITY(1,1),
	Name NVARCHAR(256) NOT NULL,
	Address NVARCHAR(256) NOT NULL,
	ID_Manager INT NULL,
	[Depot type] CHAR(32) NOT NULL
)

ALTER TABLE Vehicle
ADD CONSTRAINT [Home depot]
FOREIGN KEY (ID_Depot) REFERENCES Depot(ID_Depot)

ALTER TABLE Vehicle
ADD CONSTRAINT [Vehicle type constraint]
FOREIGN KEY (ID_Type) REFERENCES [Vehicle type](ID_Type)

ALTER TABLE [Historic vehicle]
ADD CONSTRAINT [Home depot historic]
FOREIGN KEY (ID_Depot) REFERENCES Depot(ID_Depot)

ALTER TABLE [Historic vehicle]
ADD CONSTRAINT [Vehicle type constraint historic]
FOREIGN KEY (ID_Type) REFERENCES [Vehicle type](ID_Type)

ALTER TABLE [Service part]
ADD CONSTRAINT [Storing depot]
FOREIGN KEY (ID_Depot) REFERENCES Depot(ID_Depot)

ALTER TABLE [Service part]
ADD CONSTRAINT [Part of vehicle]
FOREIGN KEY (ID_Type) REFERENCES [Vehicle type](ID_Type)

ALTER TABLE Depot
ADD CONSTRAINT [Depot manager]
FOREIGN KEY (ID_Manager) REFERENCES Employee(ID_Employee)

CREATE TABLE Line(
	ID_Line INT PRIMARY KEY, CHECK(ID_Line BETWEEN 0 AND 999),
	ID_loop1 INT NOT NULL,
	ID_loop2 INT NOT NULL,
	[Vehicle capacity] INT,
	[Vehicle cardinality] INT,
	ID_Depot INT NOT NULL
)

CREATE TABLE Stop(
	ID_Stop INT PRIMARY KEY IDENTITY(1,1),
	Name NVARCHAR(256) NOT NULL UNIQUE,
	Type CHAR(32) NOT NULL,
	[X coordinates] FLOAT,
	[Y coordinates] FLOAT,
	ID_District CHAR(3) NOT NULL
)

CREATE TABLE Route(
	ID_Line INT NOT NULL,
	ID_Stop INT NOT NULL,
	ID_Next INT NULL,
	Direction CHAR, CHECK (Direction IN ('A', 'B')),
	PRIMARY KEY (ID_Line, ID_Stop, Direction)
)

CREATE TABLE [City district](
	ID_District CHAR(3) PRIMARY KEY,
	Name NVARCHAR(256) NOT NULL
)

CREATE TABLE [Serving](
	ID_Vehicle INT,
	ID_Line INT
	PRIMARY KEY (ID_Vehicle, ID_Line)
)

ALTER TABLE Stop
ADD CONSTRAINT [Base district]
FOREIGN KEY (ID_District) REFERENCES [City district](ID_District)

ALTER TABLE Route
ADD CONSTRAINT [Route Line]
FOREIGN KEY (ID_Line) REFERENCES Line(ID_Line)

ALTER TABLE Route
ADD CONSTRAINT [Route Stop]
FOREIGN KEY (ID_Stop) REFERENCES Stop(ID_Stop)

ALTER TABLE Route
ADD CONSTRAINT [Route Next]
FOREIGN KEY (ID_Next) REFERENCES Stop(ID_Stop)

ALTER TABLE	Line
ADD CONSTRAINT [Loop Stop 1]
FOREIGN KEY (ID_Loop1) REFERENCES Stop(ID_Stop)
ALTER TABLE Line
ADD CONSTRAINT [Loop Stop 2]
FOREIGN KEY (ID_Loop2) REFERENCES Stop(ID_Stop)
ALTER TABLE Line
ADD CONSTRAINT [Serving depot]
FOREIGN KEY (ID_Depot) REFERENCES Depot(ID_Depot)

ALTER TABLE Serving
ADD CONSTRAINT [Serving vehicle]
FOREIGN KEY (ID_Vehicle) REFERENCES Vehicle(ID_Vehicle)

ALTER TABLE Serving
ADD CONSTRAINT [Served line]
FOREIGN KEY (ID_Line) REFERENCES Line(ID_Line)

CREATE TABLE Tender(
	ID_Tender INT PRIMARY KEY IDENTITY(1,1),
	[Tender name] NVARCHAR(256) NOT NULL,
	[Date begin] DATETIME NOT NULL,
	[Date result] DATETIME NOT NULL,
	[Tender type] INT
)

CREATE TABLE [Tender description](
	ID_Tender_type INT PRIMARY KEY IDENTITY(1,1),
	[Tender name] NVARCHAR(256) NOT NULL,
	Description NVARCHAR(MAX)
)

CREATE TABLE Company(
	ID_Customer CHAR(6) PRIMARY KEY,
	[Company name] NVARCHAR(256),
	Address NVARCHAR(256),
	Phone VARCHAR(11),
	Email VARCHAR(256),
	ID_Owner INT
)

CREATE TABLE [Company Owner](
	ID_Owner INT PRIMARY KEY,
	[First name] NVARCHAR(256) NOT NULL,
	[Last name] NVARCHAR(256) NOT NULL,
	Phone VARCHAR(11),
	Email VARCHAR(256),
	CHECK (Phone IS NOT NULL OR Email IS NOT NULL)
)

CREATE TABLE [Tender participants](
	ID_Tender INT,
	ID_Customer CHAR(6),
	PRIMARY KEY (ID_Tender, ID_Customer)
)

ALTER TABLE Tender
ADD CONSTRAINT [Tender type]
FOREIGN KEY ([Tender type]) REFERENCES [Tender description](ID_Tender_type)

ALTER TABLE [Tender participants]
ADD CONSTRAINT [Tender constraint]
FOREIGN KEY(ID_Tender) REFERENCES Tender(ID_Tender)

ALTER TABLE [Tender participants]
ADD CONSTRAINT [Tender customer constraint]
FOREIGN KEY(ID_Customer) REFERENCES Company(ID_Customer)

ALTER TABLE Company
ADD CONSTRAINT Owner
FOREIGN KEY (ID_Owner) REFERENCES [Company owner](ID_Owner)

CREATE TABLE Passenger(
	ID_Passenger INT PRIMARY KEY IDENTITY(1,1),
	[First name] NVARCHAR(256) NOT NULL,
	[Last name] NVARCHAR(256) NOT NULL,
	Address NVARCHAR(256) NULL,
	Penalty MONEY DEFAULT 0
)

CREATE TABLE Tickets(
	ID_Ticket INT PRIMARY KEY IDENTITY(1,1),
	[Start date] DATE NOT NULL,
	[End date] DATE NOT NULL,
	CHECK ([Start date] <= [End date]),
	ID_Line INT NULL,
	ID_Passenger INT NOT NULL
)

ALTER TABLE Tickets
ADD CONSTRAINT [Ticket owner]
FOREIGN KEY (ID_Passenger) REFERENCES Passenger(ID_Passenger)

ALTER TABLE Tickets
ADD CONSTRAINT [Ticket range]
FOREIGN KEY (ID_Line) REFERENCES Line(ID_Line)