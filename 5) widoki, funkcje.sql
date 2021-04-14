USE MPK
GO
-- 1. Kierowcy:
CREATE VIEW Drivers
AS
	SELECT * FROM Employee
	WHERE ID_License IS NOT NULL
GO
-- 2. Zasięg, do którego może dotrzeć dany klient, z użyciem aktualnie posiadanych biletów:
GO
CREATE FUNCTION Range(@passenger INT)
RETURNS @out TABLE (
	ID_Stop INT,
	Name NVARCHAR(256) NOT NULL,
	Type CHAR(32) NOT NULL,
	[X coordinates] FLOAT,
	[Y coordinates] FLOAT,
	ID_District CHAR(3) NOT NULL)
AS BEGIN
	IF EXISTS (SELECT ID_Ticket FROM Tickets
			WHERE ID_Line IS NULL
			AND GETDATE() BETWEEN [Start date] AND [End date]) -- Pasażer posiada biletu całomiejski
		INSERT INTO @out
		SELECT DISTINCT Stop.* FROM Stop
		JOIN Route ON Stop.ID_Stop = Route.ID_Stop
	ELSE -- Pasażer nie posiada biletu całomiejskiego
		INSERT INTO @out
		SELECT DISTINCT Stop.* FROM Stop
		JOIN Route ON Stop.ID_Stop = Route.ID_Stop
		JOIN Line ON Route.ID_Line = Line.ID_Line
		JOIN Tickets ON Tickets.ID_Line = Line.ID_Line
		JOIN Passenger ON Passenger.ID_Passenger = Tickets.ID_Passenger
		WHERE Passenger.ID_Passenger = @passenger AND GETDATE() BETWEEN [Start date] AND [End date]
	RETURN
END
GO

-- 3. All vehicles:
GO
CREATE VIEW [All vehicles]
AS
	SELECT * FROM Vehicle UNION SELECT * FROM [Historic vehicle]
GO
-- 4. Dla zadanego menadżera wypisz wszystkich jego podwładnych

CREATE FUNCTION Subordinate(@ID_man INT)
RETURNS @out TABLE(
	ID_Employee INT,
	[First Name] NVARCHAR(256) NOT NULL,
	[Last Name] NVARCHAR(256) NOT NULL,
	Address NVARCHAR(256) NULL,
	ID_Position CHAR(3) NOT NULL,
	ID_Depot INT NOT NULL,
	ID_License NVARCHAR(10) NULL)
AS BEGIN
	DECLARE @depot INT = (SELECT ID_Depot FROM Employee WHERE ID_Employee = @ID_Man)
	INSERT INTO @out 
	SELECT * FROM Employee WHERE ID_Depot = @depot
	RETURN
END

-- 5. Najruchliwsze przystanki
--	Statystyka na podstawie biletów posiadanych przez pasażerów.

GO
CREATE FUNCTION [Popular stops] ()
RETURNS @histogram TABLE
	(
		ID_Stop INT,
		Name NVARCHAR(256) NOT NULL,
		Type CHAR(32) NOT NULL,
		[X coordinates] FLOAT,
		[Y coordinates] FLOAT,
		ID_District CHAR(3) NOT NULL,
		[Potential passengers] INT
	)
AS
BEGIN
	DECLARE @set TABLE(
		ID_Stop INT,
		Name NVARCHAR(256) NOT NULL,
		Type CHAR(32) NOT NULL,
		[X coordinates] FLOAT,
		[Y coordinates] FLOAT,
		ID_District CHAR(3) NOT NULL
	)

	DECLARE @passr INT
	DECLARE Cursor_passengers CURSOR
		FOR SELECT ID_Passenger FROM Passenger
		FOR READ ONLY
	OPEN Cursor_passengers
	WHILE @@FETCH_STATUS = 0
	BEGIN
		FETCH Cursor_passengers INTO @passr
		INSERT INTO @set SELECT * FROM Range(@passr)
	END
	CLOSE Cursor_passengers
	DEALLOCATE Cursor_passengers
	INSERT INTO @histogram 
	SELECT Stop.*, Grp.[Potential passengers] FROM
		(SELECT ID_Stop, COUNT(DISTINCT ID_Stop) AS [Potential passengers] FROM @set GROUP BY ID_Stop) AS Grp
		JOIN Stop ON Grp.ID_Stop = Stop.ID_Stop
	RETURN
END
GO

-- 6. Wyświetl stan kadry, czy wymagane będzie zatrudnienie nowych pracowników (zwolnienie starych)

CREATE VIEW [Staff summary]
AS
	SELECT
		ID_Depot AS ID_Depot,
		Employee.ID_Position AS ID_Position,
		Count(*) AS Count,
		(CASE WHEN Employee.ID_Position='cle' THEN Count(ID_Employee) - 3 
			WHEN Employee.ID_Position='man' THEN Count(ID_Employee) - 2
			WHEN Employee.ID_Position='dri' THEN Count(ID_Employee) - (2+2*(SELECT COUNT(DISTINCT ID_Vehicle) FROM Serving JOIN Line ON Serving.ID_Line=Line.ID_Line WHERE Line.ID_Depot=Employee.ID_Depot))
			WHEN Employee.ID_Position='meh' THEN Count(ID_Employee) - 3
			ELSE NULL END
		) AS Delta,
		SUM(Salary) AS Salaries,
		SUM(Bonus) AS Bonuses,
		SUM(Salary+CASE WHEN Bonus IS NULL THEN 0 ELSE Bonus END) AS Costs
	FROM Employee
	JOIN Position ON Employee.ID_Position = Position.ID_Position
	GROUP BY ID_Depot, Employee.ID_Position
GO

-- 7. Wypisz wszystkie aktualnie prowadzone przetargi

CREATE VIEW [Current Tender]
AS
	SELECT * FROM Tender WHERE
	GETDATE() BETWEEN Tender.[Date begin] AND Tender.[Date result]
GO

-- 8. Wypisz stan linii, razem z obciążeniem oraz odpowiedzią na to obciążenie (czy jest wystarczająco miejsc w pojazdach)

GO
CREATE VIEW [Line load status]
AS
SELECT
	Vehicles.ID_Line,
	(CASE WHEN [Expected load] IS NULL THEN 0 ELSE [Expected load] END) AS [Expected load],
	(CASE WHEN [Total capacity] IS NULL THEN 0 ELSE [Total capacity] END) AS [Total capacity],
	((CASE WHEN [Expected load] IS NULL THEN 0 ELSE [Expected load] END)
	-(CASE WHEN [Total capacity] IS NULL THEN 0 ELSE [Total capacity] END)) AS Delta
FROM
	(SELECT
		Line.ID_Line,
		COUNT(DISTINCT Passenger.ID_Passenger) AS [Expected load]
	FROM Line
	LEFT JOIN Tickets ON Tickets.ID_Line = Line.ID_Line
	LEFT JOIN Passenger ON Passenger.ID_Passenger = Tickets.ID_Passenger
	WHERE GETDATE() BETWEEN Tickets.[Start date] AND Tickets.[End date]
	GROUP BY Line.ID_Line) AS People
	RIGHT JOIN
	(SELECT
		Line.ID_Line,
		SUM([Vehicle type].Capacity) AS [Total capacity]
	FROM Line
	LEFT JOIN Serving ON Line.ID_Line = Serving.ID_Line
	LEFT JOIN Vehicle ON Serving.ID_Vehicle = Vehicle.ID_Vehicle
	LEFT JOIN [Vehicle type] ON Vehicle.ID_Type = [Vehicle type].ID_type
	GROUP BY Line.ID_Line) AS Vehicles
	ON People.ID_Line = Vehicles.ID_Line
GO

-- 9. Wypisz wszystkie przetargi w których bierze (brała) udział dana firma

GO
CREATE FUNCTION [Company tenders](@company NVARCHAR(256))
	RETURNS @OUT TABLE 
	(
		[Company name] NVARCHAR(256),
		Status VARCHAR(50),
		[Tender name] NVARCHAR(256),
		[Date begin] DATETIME,
		[Date result] DATETIME,
		[Tender short name] NVARCHAR(256),
		Description NVARCHAR(MAX)
	)
AS
BEGIN
	INSERT INTO @OUT
	SELECT 
		Company.[Company name],
		(CASE WHEN (GETDATE() BETWEEN Tender.[Date begin] AND Tender.[Date result]) THEN 'Pending' ELSE 'Dated' END) AS Status,
		Tender.[Tender name],
		Tender.[Date begin],
		Tender.[Date result],
		[Tender description].[Tender name] as [Tender short name],
		[Tender description].Description
	FROM Company
	JOIN [Tender participants] ON Company.ID_Customer = [Tender participants].ID_Customer
	JOIN Tender ON [Tender participants].ID_Tender = Tender.ID_Tender
	JOIN [Tender description] ON Tender.[Tender type] = [Tender description].ID_Tender_type
	WHERE Company.[Company name] LIKE @company
	ORDER BY Status DESC, [Date result] ASC
	RETURN
END
GO

-- 10. Wypisz kolejne przystanki dla podanej linii

GO
CREATE FUNCTION GetRoute(@Line INT, @Dir CHAR)
RETURNS @OUT TABLE(
		Ordinal INT,
		[Stop name] NVARCHAR(256),
		[Stop type] CHAR(32),
		[X coordinate] FLOAT,
		[Y coorditane] FLOAT,
		[District Name] NVARCHAR(256)
	)
AS
BEGIN
	;WITH NumberedStops (Ordinal, ID_Stop)
	AS
	(
	 SELECT 1 AS Ordinal, CASE WHEN @Dir = 'A' THEN ID_loop1 WHEN @Dir = 'B' THEN ID_loop2 ELSE NULL END AS ID_Stop
	 FROM Line
	 WHERE ID_Line = @Line
	 UNION ALL
	 SELECT Ordinal + 1 AS Ordinal, Route.ID_Next AS ID_Stop
	 FROM NumberedStops
	 JOIN Route ON NumberedStops.ID_Stop = Route.ID_Stop
	 WHERE ID_Line = @Line AND Direction = @Dir
	)
	INSERT INTO @OUT
	SELECT Ordinal,
		Stop.Name,
		Stop.Type,
		Stop.[X coordinates],
		Stop.[Y coordinates],
		[City district].Name AS [District Name]
	FROM NumberedStops
	JOIN Stop ON NumberedStops.ID_Stop = Stop.ID_Stop
	JOIN [City district] ON Stop.ID_District = [City district].ID_District
	ORDER BY Ordinal ASC;
	RETURN
END
GO