USE MPK
SET DATEFORMAT ymd;

-------------------------------------------------------



-- Trigger 1 - Sprawdzenie, czy wstawiany kierowca ma poprawny numer licencji
CREATE TRIGGER EmployeeInsteadOfUpdate
ON Employee
INSTEAD OF INSERT, UPDATE
AS
BEGIN
	DECLARE @faulty_records TABLE(
	ID_Employee INT PRIMARY KEY,
	[First Name] NVARCHAR(256) NOT NULL,
	[Last Name] NVARCHAR(256) NOT NULL,
	Address NVARCHAR(256) NULL,
	ID_Position CHAR(3) NOT NULL,
	ID_Depot INT NULL,
	ID_License NVARCHAR(10) NULL
	)
	INSERT INTO @faulty_records
	SELECT * FROM INSERTED
	WHERE LEFT(ID_License, 3) NOT IN (SELECT DISTINCT [ID_License] FROM [Vehicle type])
	IF EXISTS (SELECT * FROM @faulty_records)
	BEGIN
		DECLARE @ERROR_ID INT = (SELECT TOP 1 ID_Employee FROM @faulty_records)
		DECLARE @ERROR_License VARCHAR(50) = (SELECT TOP 1 ID_License FROM @faulty_records)
		PRINT 'Error while inserting employee:' + CAST(@ERROR_ID AS VARCHAR(50)) +
			'. ID_License must start with a three letter code specified in [Vehicle type] table (was '
			+ @ERROR_License + ').'
		ROLLBACK
	END
	ELSE
		INSERT INTO Employee SELECT 
			[First Name],
			[Last Name],
			Address,
			ID_Position,
			ID_Depot,
			ID_License
		FROM INSERTED
END
GO


-- Trigger 2 - Zachowuje spójność danych przy ręcznym wstawianiu przystanków
CREATE TRIGGER RouteInsteadOfInsert
ON Route
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @CNT INT= (SELECT COUNT(*) FROM inserted )
	PRINT 'INSERTED '+CAST(@CNT AS VARCHAR(30))+' POSITIONS'
	DECLARE InsertedStops CURSOR
	FOR SELECT ID_Line, ID_Stop, ID_Next, Direction FROM INSERTED
	FOR READ ONLY

	DECLARE @Line INT
	DECLARE @Stop INT
	DECLARE @Next INT
	DECLARE @Prev INT
	DECLARE @Dir CHAR

	OPEN InsertedStops

	FETCH InsertedStops INTO @Line, @Stop, @Next, @Dir
	PRINT CAST(@Line AS NVARCHAR(50))+ CAST(@Dir AS NVARCHAR(50))+ CAST(@Stop AS NVARCHAR(50))+ CAST(@Next AS NVARCHAR(50))+CAST(@PREV AS NVARCHAR(50))
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF(@Next IS NULL)
			IF(@Dir='A')
			BEGIN
				SET @Prev = (SELECT ID_Loop2 FROM Line WHERE ID_Line = @Line)
				UPDATE Line
				SET ID_Loop2 = @Stop
				WHERE ID_Line = @Line
			END
			ELSE
			BEGIN
				SET @Prev = (SELECT ID_Loop2 FROM Line WHERE ID_Line = @Line)
				UPDATE Line
				SET ID_Loop1 = @Stop
				WHERE ID_Line = @Line
			END
		ELSE
			SET @Prev = (SELECT ID_Stop FROM Route WHERE ID_Next = @Next
			AND ID_Line = @Line AND Direction = @Dir)
		
		IF(@Prev IS NULL)
			IF(@Dir='A')
				UPDATE Line
				SET ID_Loop1 = @Stop
				WHERE ID_Line = @Line
			ELSE
				UPDATE Line
				SET ID_Loop2 = @Stop
				WHERE ID_Line = @Line
		
		UPDATE Route
		SET ID_Next = @Stop
		WHERE ID_Stop = @Prev
		AND ID_Line = @Line AND Direction = @Dir

		INSERT INTO Route (ID_Line, Direction, ID_Stop, ID_Next) VALUES
		(@Line, @Dir, @Stop, @Next)
		
	
		FETCH InsertedStops INTO @Line, @Stop, @Next, @Dir
		PRINT CAST(@Line AS NVARCHAR(50))+ CAST(@Dir AS NVARCHAR(50))+ CAST(@Stop AS NVARCHAR(50))+ CAST(@Next AS NVARCHAR(50))+CAST(@PREV AS NVARCHAR(50))
	END
	
	CLOSE InsertedStops
	DEALLOCATE InsertedStops
END
GO

-- Trigger 3 - Aktualizacja danych dot. lini, po dodaniu/usunięciu obsługujących ją pojazdów
CREATE TRIGGER ServingAfterInsertUpdate
ON Serving
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @insertedStats TABLE (ID_Line INT, Capacity INT, Count INT)
	DECLARE @deletedStats TABLE (ID_Line INT, Capacity INT, Count INT)
	
	INSERT INTO @insertedStats
	SELECT INSERTED.ID_Line AS ID_Line, MIN([Vehicle type].Capacity) AS Capacity, COUNT(INSERTED.ID_Vehicle) AS Count
	FROM INSERTED
	JOIN Vehicle ON INSERTED.ID_Vehicle = Vehicle.ID_Vehicle
	LEFT JOIN [Vehicle type] ON Vehicle.ID_Type = [Vehicle type].ID_type
	GROUP BY INSERTED.ID_Line


	INSERT INTO @deletedStats
	SELECT DELETED.ID_Line AS ID_Line, MAX([Vehicle type].Capacity) AS Capacity, COUNT(DELETED.ID_Vehicle) AS Count
	FROM DELETED
	JOIN Vehicle ON DELETED.ID_Vehicle = Vehicle.ID_Vehicle
	LEFT JOIN [Vehicle type] ON Vehicle.ID_Type = [Vehicle type].ID_type
	GROUP BY DELETED.ID_Line
	
	UPDATE Line
	SET [Vehicle capacity] =
		(SELECT MIN([Vehicle type].Capacity) AS Capacity FROM Serving
		JOIN Vehicle ON Serving.ID_Vehicle = Vehicle.ID_Vehicle
		LEFT JOIN [Vehicle type] ON [Vehicle type].ID_type = Vehicle.ID_Type
		GROUP BY Serving.ID_Line
		HAVING Serving.ID_Line = Line.ID_Line)

	UPDATE Line
	SET [Vehicle cardinality] = [Vehicle cardinality]
	+	CASE WHEN (SELECT Count FROM @insertedStats	AS sub WHERE Line.ID_Line=sub.ID_Line) IS NULL 
			THEN 0 
			ELSE (SELECT Count FROM @insertedStats	AS sub WHERE Line.ID_Line=sub.ID_Line)
		END
	-	CASE WHEN (SELECT Count FROM  @deletedStats	AS sub WHERE Line.ID_Line=sub.ID_Line) IS NULL 
			THEN 0 
			ELSE (SELECT Count FROM  @deletedStats	AS sub WHERE Line.ID_Line=sub.ID_Line)
		END
	WHERE Line.ID_Line IN (SELECT ID_Line FROM @insertedStats
		UNION SELECT ID_Line FROM @deletedStats)
END

-- Trigger 4 - Poprawia datę biletu tak, aby spełniała ona założenie bazy
GO
CREATE TRIGGER TicketDateGuard
ON Tickets
INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO Tickets
	SELECT (CASE WHEN [Start date] > [End date] THEN [End date] ELSE [Start date] END) AS [Start date], [End date], ID_Line, ID_Passenger
	FROM INSERTED
END
GO




-- Trigger 5 - Zamów nowe części, jeśli stare się skończą

GO
CREATE TRIGGER ServicePartRestock
ON [Service part]
AFTER UPDATE
AS
IF UPDATE (Quantity)
	BEGIN
		UPDATE [Service Part]
		SET Quantity = CASE WHEN (SELECT [Min quantity]+[Restock quantity] FROM INSERTED WHERE INSERTED.ID_Part = [Service Part].ID_Part) IS NOT NULL
			AND (Quantity < (SELECT [Min quantity] FROM INSERTED WHERE INSERTED.ID_Part = [Service Part].ID_Part))
			THEN (SELECT [Restock quantity] FROM INSERTED WHERE INSERTED.ID_Part = [Service Part].ID_Part) ELSE Quantity END
		WHERE [Service part].ID_Part IN (SELECT ID_Part FROM INSERTED)
	END