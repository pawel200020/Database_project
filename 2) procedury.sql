-- Procedura 1 - Wstawianie trasy dla lini w postaci human-readable
USE MPK
CREATE TYPE StopTableTypeIdentity AS TABLE
(
    Ord INT PRIMARY KEY IDENTITY(1,1),
    [Stop name] NVARCHAR(256)
)
GO
CREATE TYPE StopTableType AS TABLE
(
    Ord INT PRIMARY KEY,
    [Stop name] NVARCHAR(256)
)
--DROP PROCEDURE INSERT_ROUTE
GO
CREATE PROCEDURE INSERT_ROUTE (@line INT, @Stops StopTableTypeIdentity READONLY)
AS
BEGIN
	DECLARE @StopsSorted StopTableType
	INSERT INTO @StopsSorted
	SELECT * FROM @Stops ORDER BY Ord ASC

	SELECT * FROM @StopsSorted

	DECLARE @dir CHAR

	IF((SELECT [Stop name] FROM @StopsSorted WHERE Ord = 1) = (SELECT Stop.Name FROM Line JOIN Stop ON Line.ID_loop1 = Stop.ID_Stop WHERE ID_Line = @line))
		SET @dir = 'A'
	ELSE
		SET @dir = 'B'

	DECLARE RouteNode CURSOR
	FOR SELECT [Stop name] FROM @StopsSorted
	FOR READ ONLY

	DECLARE @CurrentStop INT = NULL
	DECLARE @NextStop INT = NULL
	DECLARE @NextName NVARCHAR(256)
	DECLARE @CurrentName NVARCHAR(256)

	
	OPEN RouteNode
	
	FETCH RouteNode INTO @NextName
	SET @NextStop = (SELECT TOP 1 ID_Stop FROM Stop WHERE Name = @NextName ORDER BY ID_Stop ASC)
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @CurrentStop = @NextStop
		FETCH RouteNode INTO @NextName
		IF @@FETCH_STATUS <> 0
			SET @NextStop = NULL
		ELSE
			SET @NextStop = (SELECT TOP 1 ID_Stop FROM Stop WHERE Name = @NextName ORDER BY ID_Stop ASC)
		IF (@CurrentStop IS NOT NULL)
		BEGIN
			INSERT INTO Route (ID_Line, ID_Stop, ID_Next, Direction) VALUES 
			(@line, @CurrentStop, @NextStop, @dir)
		END --IF
	END

	CLOSE RouteNode
	DEALLOCATE RouteNode
END
GO

-- Procedura 2 - Wstawianie nowego przystanku na trasie po podanym
CREATE PROCEDURE InsertStopAfter @Line INT, @Direction CHAR, @Inserted INT, @Previous INT
AS
BEGIN
	DECLARE @Next INT = (SELECT ID_Next FROM Route
					WHERE ID_Stop = @Previous
					AND ID_Line = @Line AND Direction = @Direction)

	INSERT INTO Route (ID_Line, Direction, ID_Stop, ID_Next) VALUES
	(@Line, @Direction, @Inserted, @Next)

END
GO
-- Procedura 3 - Wstawianie nowego przystanku na trasie przed podanym
CREATE PROCEDURE InsertStopBefore @Line INT, @Direction CHAR, @Inserted INT, @Next INT
AS
BEGIN
	DECLARE @Previous INT = (SELECT ID_Stop FROM Route
					WHERE ID_Next = @Next
					AND ID_Line = @Line AND Direction = @Direction)

	INSERT INTO Route (ID_Line, Direction, ID_Stop, ID_Next) VALUES
	(@Line, @Direction, @Inserted, @Next)
	
END
GO

-- Procedura 4 - Kanar

GO
CREATE PROCEDURE VerifyPassenger @Pass INT, @Line INT
AS
BEGIN
	IF NOT EXISTS
	(SELECT * FROM Passenger
	JOIN Tickets ON Tickets.ID_Passenger = Passenger.ID_Passenger
	WHERE Tickets.ID_Passenger = @Pass AND
		(ID_Line IS NULL OR ID_Line = @Line)
		AND GETDATE() BETWEEN [Start date] AND [End date])
	BEGIN
		UPDATE Passenger
		SET Penalty = Penalty + 100
		WHERE ID_Passenger = @Pass
	END
END
GO

-- Procedura 5 - Pojazd siê postarza³ i teraz jest ju¿ pojazdem historycznym
GO
CREATE PROCEDURE Degrade @Veh INT
AS
BEGIN
	BEGIN TRAN
		INSERT INTO [Historic Vehicle]
		SELECT [Vin number], Brand, [Production date], N'Kraków', ID_Depot, ID_Type
		FROM Vehicle
		WHERE ID_Vehicle = @Veh

		DELETE FROM Vehicle
		WHERE ID_Vehicle = @Veh
	COMMIT
END
GO