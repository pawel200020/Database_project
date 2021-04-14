USE MPK SET DATEFORMAT ymd; 
SELECT * FROM Route
JOIN STOP SC ON Route.ID_Stop=SC.ID_Stop
LEFT JOIN STOP SN ON Route.ID_Next=SN.ID_Stop
WHERE ID_Line=1 AND Direction = 'A'

SELECT * FROM Line
JOIN Stop S1 ON Line.ID_loop1 = S1.ID_Stop
JOIN Stop S2 ON Line.ID_loop2 = S2.ID_Stop
WHERE ID_Line = 1

INSERT INTO Depot VALUES 
(N'P�asz�w', N'Biskupi�ska 2', NULL, 'BUS'),
(N'Wola_Duchacka', N'S�awka 10', NULL, 'BUS'),
(N'Bie�czyce', N'Kornela Makuszy�skiego 34', NULL, 'BUS'),
(N'Podg�rze', N'Jana Bro�ka 3', NULL, 'TRAM'),
(N'Nowa_Huta', N'Ujastek 12', NULL, 'TRAM')

INSERT INTO Position VALUES 
('man', 6000, NULL),
('mda', 2900, NULL),
('dri', 3500, 200),
('cle', 2000, 150)


INSERT INTO Employee VALUES 
(N'Miko�aj', N'Chmielewski', N'Maczka Stanis�awa 73A, Krak�w', 'man', 1, NULL),
(N'Anastazy', N'Kucharski', N'Odrodzenia 31A/04, Krak�w', 'man', 2, NULL),
(N'Remigiusz', N'Brzezi�ski', N'Wrzosowa 61A, Krak�w', 'man', 3, NULL),
(N'Artur', N'Zawadzki', N'Czere�niowa 57/06, Krak�w', 'man', 4, NULL),
(N'Olaf', N'Wi�niewski', N'Fabryczna 82A/22, Krak�w', 'man', 5, NULL),
(N'Franciszek', N'Makowski', N'Kaliska 61/53, Krak�w', 'mda', 1, NULL),
(N'Grzegorz', N'Soko�owski', N'Sucha 08A, Krak�w', 'mda', 2, NULL),
(N'Ludwik', N'Makowski', N'�niwna 90A, Krak�w', 'mda', 3, NULL),
(N'Rados�aw', N'G�recki', N'Puszkina Aleksandra 58, Krak�w', 'mda', 2, NULL),
(N'Borys', N'Kami�ski', N'Botaniczna 48A/19, Krak�w', 'cle', 1, NULL),
(N'Kordian', N'Szewczyk', N'Jaracza Stefana 95A, Krak�w', 'cle', 2, NULL),
(N'Kajetan', N'Sobczak', N'Lawendowa 53A/04, Krak�w', 'cle', 3, NULL),
(N'Dobromi�', N'Lewandowski', N'Grodzka 94A, Krak�w', 'cle', 4, NULL),
(N'Rafa�', N'Ka�mierczak', N'Jasna 52A, Krak�w', 'cle', 5, NULL),
(N'Dobromi�', N'Jakubowski', N'Dworska 63A, Krak�w', 'dri', 1, 'BUS0000001'),
(N'Andrzej', N'Adamska', N'Kr�lewska 24, Krak�w', 'dri', 2, 'BUS0000001'),
(N'B�a�ej', N'Pietrzak', N'Podmiejska 68A, Krak�w', 'dri', 3, 'BUS0000002'),
(N'Kewin', N'Nowak', N'Lompy J�zefa 90A, Krak�w', 'dri', 1, 'BUS0000003'),
(N'Maciej', N'Kowalczyk', N'11 Listopada 46, Krak�w', 'dri', 2, 'BUS0000001'),
(N'Fabian', N'Kubiak', N'Wieniawskiego Henryka 22/73, Krak�w', 'dri', 3,'BUS0000002'),
(N'Martin', N'Kalinowski', N'Botaniczna 43A/52, Krak�w', 'dri', 2, 'BUS0000003'),
(N'Jan', N'G�recki', N'Orzechowa 76, Krak�w', 'dri', 3, 'BUS0000001'),
(N'Kajetan', N'Zi�kowska', N'Hetma�ska 30A/98, Krak�w', 'dri', 1, 'TRM0000003'),
(N'Ludwik', N'W�jcik', N'Gr�jecka 23, Krak�w', 'dri', 1, 'TRM0000002'),
(N'Eugeniusz', N'Brzezi�ski', N'Kr�tka 93A/04, Krak�w', 'dri', 4, 'TRM0000001'),
(N'Ksawery', N'Kubiak', N'��czna 43A/63, Krak�w', 'dri', 4, 'TRM0000004'),
(N'Bruno', N'Jaworski', N'Wierzbowa 55, Krak�w', 'dri', 4, 'TRM0000003'),
(N'Krzysztof', N'Kowalczyk', N'Pawia 16A/50, Krak�w', 'dri', 5, 'TRM0000002'),
(N'Eustachy', N'Piotrowski', N'Zwyci�stwa 61A, Krak�w', 'dri', 5, 'TRM0000001'),
(N'Bronis�aw', N'Andrzejewski', N'Okopowa 93A, 70-479 Krak�w', 'dri', 5, 'TRM0000004')

INSERT INTO [Vehicle type] VALUES 
(N'BUS18M', 174, 'BUS0000001'),
(N'BUS12M', 90, 'BUS0000002'),
(N'BUS9M', 30, 'BUS0000003'),
(N'TRAM43M', 360, 'TRM0000001'),
(N'TRAM33M', 300, 'TRM0000002'),
(N'TRAM26M', 150, 'TRM0000003'),
(N'TRAM15M', 90, 'TRM0000004')

INSERT INTO Vehicle VALUES 
(N'278517065', N'Solaris', N'2010/06/26', 1, 1, 1),
(N'906181190', N'Solaris', N'2010/06/26', 1, 1, 1),
(N'931356235', N'Solaris', N'2010/06/26', 1, 1, 1),
(N'517215005', N'Solaris', N'2010/06/26', 1, 1, 1),
(N'396119769', N'Solaris', N'2010/06/26', 1, 2, 1),
(N'543405310', N'Solaris', N'2010/06/26', 1, 2, 2),
(N'856368554', N'Solaris', N'2010/06/26', 1, 2, 2),
(N'517687118', N'Solaris', N'2010/06/26', 1, 2, 2),
(N'370504471', N'Solaris', N'2010/06/26', 1, 2, 2),
(N'632683055', N'Solaris', N'2010/06/26', 1, 2, 2),
(N'668476239', N'Solaris', N'2010/06/26', 1, 2, 2),
(N'811966977', N'Autosan', N'2010/10/15', 1, 2, 3),
(N'276965369', N'Autosan', N'2010/10/15', 1, 2, 3),
(N'928332109', N'Autosan', N'2010/10/15', 1, 3, 3),
(N'320095015', N'Autosan', N'2010/10/15', 1, 3, 3),
(N'919526400', N'Autosan', N'2010/10/15', 1, 3, 3),
(N'822579444', N'Autosan', N'2010/10/15', 1, 3, 3),

(N'411028079', N'Pesa', N'2015/11/12', 1, 4, 4),
(N'469730101', N'Pesa', N'2015/11/12', 1, 4, 4),
(N'613281138', N'Pesa', N'2015/11/12', 1, 4, 4),
(N'802364405', N'Pesa', N'2015/11/12', 1, 4, 4),
(N'120982936', N'Bombardier', N'2010/11/12', 1, 4, 5),
(N'613869862', N'Bombardier', N'2010/11/12', 1, 4, 5),
(N'193532059', N'Bombardier', N'2001/11/12', 1, 4, 6),
(N'329761420', N'Bombardier', N'2001/11/12', 1, 4, 6),
(N'320095015', N'Bombardier', N'2010/11/05', 1, 4, 5),
(N'919529400', N'Bombardier', N'2011/11/15', 1, 5, 6),
(N'469204713', N'Bombardier', N'2014/11/23', 1, 5, 5),
(N'168243537', N'Konstal105N', N'1990/11/12', 0, 5, 7),
(N'320095015', N'Konstal105N', N'1990/11/12', 0, 5, 7),
(N'919526600', N'Konstal105N', N'1990/11/12', 0, 5, 7),
(N'255546039', N'Konstal105N', N'1990/11/12', 0, 5, 7),
(N'434198437', N'MAN_N8S', N'1974/08/12', 0, 5, 6),
(N'919526400', N'MAN_N8S', N'1974/04/12', 0, 5, 6)

INSERT INTO [Historic Vehicle] VALUES
(N'438332109', N'KonstalN', N'1950/11/04', 'Krak�w', 4, 6),
(N'354395015', N'KonstalN', N'1950/10/10', 'Wroc�aw', 4, 6),
(N'919324350', N'Ikarus280', N'1984/10/10', 'Krak�w', 1, 2),
(N'219526400', N'Jelcz 121MB', N'1984/12/10', 'Warszawa', 2, 2)
--select * from [MPK].[dbo].[Route]
INSERT INTO [Service part] VALUES 
(N'Spare Wheel', 12,3,2, N'20" for autosan', 1, 3),
(N'Gearbox', 4,5,6, N'Gearbox for urbino 12', 2, 3),
(N'Pantograph', 1,2,2, N'Pantograph for Bombardier tram', 5, 6)

INSERT INTO [City district] VALUES 
('OLT', N'Old Town'),
('GRZ', N'Grzeg�rzki'),
('BRO', N'Bronowice'),
('PDG', N'Podg�rze'),
('RUC', N'Ruczaj'),
('NHU', N'Nowa Huta'),
('KRO', N'Krowodrza')
INSERT INTO Stop VALUES

/*1*/(N'Mistrzejowice', 'SINGLE', 12.23, 56.46, 'NHU'),
/*2*/(N'Mi�nie�ska', 'SINGLE', 12.24, 56.35, 'NHU'),
/*3*/(N'Os. Z�otego Wieku', 'SINGLE', 12.25, 56.12, 'NHU'),
/*4*/(N'Rondo Piastowskie', 'SINGLE', 12.29, 56.36, 'NHU'),
/*5*/(N'Rondo Hipokratesa', 'SINGLE', 12.30, 56.98, 'NHU'),
/*6*/(N'Rondo Kocmyrzowskie im. Ks. Gorzelanego', 'SINGLE', 12.22, 56.33, 'NHU'),
/*7*/(N'Os. Zgody', 'SINGLE', 12.46, 56.22, 'NHU'),
/*8*/(N'Plac Centralny im. R.Reagana', 'SINGLE', 13.22, 56.47, 'NHU'),
/*9*/(N'Os. Na Skarpie', 'SINGLE', 11.22, 56.78, 'NHU'),
/*10*/(N'Klasztorna', 'SINGLE', 18.22, 56.65, 'NHU'),
/*11*/(N'Suche Stawy', 'SINGLE', 14.22, 56.96, 'NHU'),
/*12*/(N'Bardosa', 'SINGLE', 15.22, 56.78, 'NHU'),
/*13*/(N'Kopiec Wandy', 'SINGLE', 19.22, 56.87, 'NHU'),

/*14*/(N'Korona', 'DOUBLE', 12.47, 56.99, 'PDG'),
/*15*/(N'Kurdwan�w P+R','SINGLE', 12.74, 56.74, 'PDG'),
/*16*/(N'Prokocim','SINGLE', 14.74, 58.74, 'PDG'),
/*17*/(N'Dworcowa','SINGLE', 12.74, 56.45, 'PDG'),

/*18*/(N'Kujawy','SINGLE', 28.74, 55.74, 'NHU'),
/*19*/(N'Plesz�w','SINGLE', 25.79, 61.73, 'NHU'),
/*20*/(N'Kombinat','SINGLE', 27.79, 63.74, 'NHU'),
/*21*/(N'Os Piast�w','SINGLE', 23.29, 63.73, 'NHU'),
/*22*/(N'Centralna','Double', 29.09, 60.44, 'NHU'),

/*23*/(N'Bronowice SKA', 'DOUBLE', 12.22, 56.99, 'BRO'),
/*24*/(N'Brzoskiwnia Kamyk','SINGLE', 21.79, 84.74, 'BRO'),
/*25*/(N'Bronowice Ma�e', 'SINGLE', 12.65, 60.99, 'BRO'),
/*26*/(N'Bronowice', 'SINGLE', 14.79, 55.99, 'BRO'),

/*27*/(N'�w. Kr�lowej Jadwigi', 'DOUBLE', 12.34, 56.78, 'OLT'),
/*28*/(N'Stradom','SINGLE', 12.79, 59.74, 'OLT'),
/*29*/(N'Dworzec G��wny','DOUBLE', 12.46, 56.74, 'OLT'),
/*30*/(N'Teatr Bagatela','DOUBLE', 12.46, 56.74, 'OLT'),
/*31*/(N'Plac Inwalid�w','DOUBLE', 12.46, 56.74, 'OLT'),
/*32*/(N'Filharmonia','DOUBLE', 12.67, 59.74, 'OLT'),
/*33*/(N'Starowi�lna','DOUBLE', 12.46, 56.74, 'OLT'),

/*34*/(N'Krowodrza G�rka','SINGLE', 16.46, 52.74, 'KRO'),
/*35*/(N'Bratys�awska','SINGLE', 16.46, 51.74, 'KRO'),
/*36*/(N'Dworzec Towarowy','SINGLE', 16.46, 52.74, 'KRO'),
/*37*/(N'Szpital Narutowicza','SINGLE', 11.46, 59.74, 'KRO'),

/*38*/(N'Rondo Grzeg�rzeckie','DOUBLE', 12.74, 55.45, 'GRZ'),
/*39*/(N'Rondo Mogilskie','DOUBLE', 16.44, 57.45, 'GRZ'),
/*40*/(N'Hala Targowa','SINGLE', 15.23, 53.45, 'GRZ'),
/*41*/(N'Teatr Variete','DOUBLE', 19.41, 54.45, 'GRZ'),
/*42*/(N'Cysters�w','DOUBLE', 20.31, 57.45, 'GRZ'),
/*43*/(N'Dworzec G��wny Tunel','DOUBLE', 19.31, 57.45, 'GRZ'),

/*44*/(N'Czerwone Maki P+R','DOUBLE', 12.74, 56.45, 'RUC'),
/*45*/(N'Ruczaj','SINGLE', 15.74, 61.74, 'RUC'),
/*46*/(N'Norymberska','SINGLE', 19.79, 65.74, 'RUC')

select * from line
delete from line where ID_Line=3
INSERT INTO Line VALUES 
(16,1,13,90,4,5),
(1,38,43,300,3,5),
(2,27,33,360,4,4),
(3,14,44,150,7,5),
(101,23,26,30,2,3),
(194,44,46,174,4,2),
(234, 1,44, 90, 3, 1)

--linia 1A--
SET XACT_ABORT ON
BEGIN TRAN
DECLARE @Route1a StopTableTypeIdentity
INSERT INTO @Route1a VALUES
(N'Rondo Grzeg�rzeckie'),
(N'Rondo Mogilskie'),
(N'Hala Targowa'),
(N'Teatr Variete'),
(N'Cysters�w'),
(N'Dworzec G��wny Tunel')
DELETE FROM Route WHERE ID_Line = 1 AND Direction = 'A'
EXECUTE INSERT_ROUTE @line=1, @Stops=@Route1a
COMMIT
--linia 1B--
SET XACT_ABORT ON
BEGIN TRAN
DECLARE @Route1b StopTableTypeIdentity
INSERT INTO @Route1b VALUES
(N'Dworzec G��wny Tunel'),
(N'Cysters�w'),
(N'Teatr Variete'),
(N'Hala Targowa'),
(N'Rondo Mogilskie'),
(N'Rondo Grzeg�rzeckie')
DELETE FROM Route WHERE ID_Line = 1 AND Direction = 'B'
EXECUTE INSERT_ROUTE @line=1, @Stops=@Route1b
COMMIT


select * from Route
order by Direction asc

--linia 2A--
BEGIN TRAN
DECLARE @Route2a StopTableTypeIdentity
INSERT INTO @Route2a VALUES
(N'�w. Kr�lowej Jadwigi'),
(N'Stradom'),
(N'Dworzec G��wny'),
(N'Teatr Bagatela'),
(N'Plac Inwalid�w'),
(N'Filharmonia'),
(N'Bratys�awska'),
(N'Dworzec Towarowy'),
(N'Szpital Narutowicza'),
(N'Cysters�w'),
(N'Starowi�lna')
DELETE FROM Route WHERE ID_Line = 2 AND Direction = 'A'
EXECUTE INSERT_ROUTE @line=2, @Stops=@Route2a
COMMIT


--linia 2B--
BEGIN TRAN
DECLARE @Route2b StopTableTypeIdentity
INSERT INTO @Route2b VALUES
(N'Starowi�lna'),
(N'Cysters�w'),
(N'Szpital Narutowicza'),
(N'Dworzec Towarowy'),
(N'Bratys�awska'),
(N'Filharmonia'),
(N'Plac Inwalid�w'),
(N'Teatr Bagatela'),
(N'Dworzec G��wny'),
(N'Stradom'),
(N'�w. Kr�lowej Jadwigi')
DELETE FROM Route WHERE ID_Line = 2 AND Direction = 'B'
EXECUTE INSERT_ROUTE @line=2, @Stops=@Route2b
COMMIT

--linia 3A--
BEGIN TRAN
DECLARE @Route3a StopTableTypeIdentity
INSERT INTO @Route3a VALUES
(N'Korona'),
(N'Kurdwan�w P+R'),
(N'Prokocim'),
(N'Dworcowa'),
(N'Teatr Bagatela'),
(N'Plac Inwalid�w'),
(N'Filharmonia'),
(N'Starowi�lna'),
(N'Bratys�awska'),
(N'Krowodrza G�rka'),
(N'Czerwone Maki P+R')
DELETE FROM Route WHERE ID_Line = 3 AND Direction = 'A'
EXECUTE INSERT_ROUTE @line=3, @Stops=@Route3a
COMMIT
--linia 3B--
BEGIN TRAN
DECLARE @Route3b StopTableTypeIdentity
INSERT INTO @Route3b VALUES
(N'Czerwone Maki P+R'),
(N'Krowodrza G�rka'),
(N'Bratys�awska'),
(N'Starowi�lna'),
(N'Plac Inwalid�w'),
(N'Teatr Bagatela'),
(N'Dworcowa'),
(N'Prokocim'),
(N'Kurdwan�w P+R'),
(N'Korona')
DELETE FROM Route WHERE ID_Line = 3 AND Direction = 'B'
EXECUTE INSERT_ROUTE @line=3, @Stops=@Route3b
COMMIT

--linia 16A--
BEGIN TRAN
DECLARE @Route16a StopTableTypeIdentity
INSERT INTO @Route16a VALUES
(N'Mistrzejowice'),
(N'Mi�nie�ska'),
(N'Os. Z�otego Wieku'),
(N'Rondo Piastowskie'),
(N'Rondo Hipokratesa'),
(N'Rondo Kocmyrzowskie im. Ks. Gorzelanego'),
(N'Plac Centralny im. R.Reagana'),
(N'Os. Na Skarpie'),
(N'Klasztorna'),
(N'Suche Stawy'),
(N'Bardosa'),
(N'Kopiec Wandy')
DELETE FROM Route WHERE ID_Line = 16 AND Direction = 'A'
EXECUTE INSERT_ROUTE @line=16, @Stops=@Route16a
COMMIT
--linia 16B--
BEGIN TRAN
DECLARE @Route16b StopTableTypeIdentity
INSERT INTO @Route16b VALUES
(N'Kopiec Wandy'),
(N'Bardosa'),
(N'Suche Stawy'),
(N'Klasztorna'),
(N'Os. Na Skarpie'),
(N'Plac Centralny im. R.Reagana'),
(N'Rondo Kocmyrzowskie im. Ks. Gorzelanego'),
(N'Rondo Hipokratesa'),
(N'Rondo Piastowskie'),
(N'Os. Z�otego Wieku'),
(N'Mi�nie�ska'),
(N'Mistrzejowice')
DELETE FROM Route WHERE ID_Line = 16 AND Direction = 'B'
EXECUTE INSERT_ROUTE @line=16, @Stops=@Route16b
COMMIT

--linia 101A--
BEGIN TRAN
DECLARE @Route101a StopTableTypeIdentity
INSERT INTO @Route101a VALUES
(N'Bronowice SKA'),
(N'Brzoskiwnia Kamyk'),
(N'Bronowice Ma�e'),
(N'Bronowice')
DELETE FROM Route WHERE ID_Line = 101 AND Direction = 'A'
EXECUTE INSERT_ROUTE @line=101, @Stops=@Route101a
COMMIT

--linia 101B--
BEGIN TRAN
DECLARE @Route101b StopTableTypeIdentity
INSERT INTO @Route101b VALUES
(N'Bronowice'),
(N'Bronowice Ma�e'),
(N'Brzoskiwnia Kamyk'),
(N'Bronowice SKA')
DELETE FROM Route WHERE ID_Line = 101 AND Direction = 'B'
EXECUTE INSERT_ROUTE @line=101, @Stops=@Route101b
COMMIT

--linia 194A--
BEGIN TRAN
DECLARE @Route194a StopTableTypeIdentity
INSERT INTO @Route194a VALUES
(N'Czerwone Maki P+R'),
(N'Ruczaj'),
(N'Hala Targowa'),
(N'Dworzec Towarowy'),
(N'Norymberska')
DELETE FROM Route WHERE ID_Line = 194 AND Direction = 'A'
EXECUTE INSERT_ROUTE @line=194, @Stops=@Route194a
COMMIT

--linia 194B--
BEGIN TRAN
DECLARE @Route194b StopTableTypeIdentity
INSERT INTO @Route194b VALUES
(N'Norymberska'),
(N'Dworzec Towarowy'),
(N'Hala Targowa'),
(N'Czerwone Maki P+R')
DELETE FROM Route WHERE ID_Line = 194 AND Direction = 'B'
EXECUTE INSERT_ROUTE @line=194, @Stops=@Route194b
COMMIT

--linia 234A--
BEGIN TRAN
DECLARE @Route234a StopTableTypeIdentity
INSERT INTO @Route234a VALUES
(N'Mistrzejowice'),
(N'Mi�nie�ska'),
(N'Plesz�w'),
(N'Kombinat'),
(N'Bronowice Ma�e'),
(N'�w. Kr�lowej Jadwigi'),
(N'Dworzec G��wny'),
(N'Krowodrza G�rka'),
(N'Norymberska')
DELETE FROM Route WHERE ID_Line = 234 AND Direction = 'A'
EXECUTE INSERT_ROUTE @line=234, @Stops=@Route234a
COMMIT

--linia 234B--
BEGIN TRAN
DECLARE @Route234b StopTableTypeIdentity
INSERT INTO @Route234b VALUES
(N'Norymberska'),
(N'Krowodrza G�rka'),
(N'Dworzec G��wny'),
(N'�w. Kr�lowej Jadwigi'),
(N'Bronowice Ma�e'),
(N'Kombinat'),
(N'Plesz�w'),
(N'Mi�nie�ska'),
(N'Mistrzejowice')
DELETE FROM Route WHERE ID_Line = 234 AND Direction = 'B'
EXECUTE INSERT_ROUTE @line=234, @Stops=@Route234b
COMMIT

INSERT INTO Passenger VALUES 
(N'Jaros�aw', N'Niski', NULL,0),
(N'Aneta', N'Zimna', NULL,0),
(N'Piotr', N'Duda', NULL,100),
(N'Micha�', N'Swojski', 'Norymberska 21a',200),
(N'Anna', N'Ciep�a', 'Kolorwa 22',0),
(N'Katarzyna', N'Polowska', 'Bardosa 14',0)
SELECT GETDATE()

INSERT INTO Tickets VALUES 
(GETDATE(), N'2022-02-21 23:07:01.480', 234, 1),
(GETDATE(), N'2023-02-21 23:07:01.480', 1, 2),
(GETDATE(), N'2022-05-21 23:07:01.480', 2, 3),
(GETDATE(), N'2024-02-21 23:07:01.480', 16, 4)

INSERT INTO [Tender description] VALUES
('Expansion of the tram network','Tenders which choose the best company for railway expansion'),
('New Tram','Tenders which choose the best company for new trams'),
('New Bus','Tenders which choose the best company for new bus'),
('Tram Part','Tenders which choose the best company for new parts for trams'),
('Bus Part','Tenders which choose the best company for new parts for buses'),
('NG Tram','Tenders which choose the best company for general repair after 10 years of exploatation one type of a tram')
select * from Tender
INSERT INTO [Tender] VALUES
('New track to Mistrzejowice','2021/02/2 10:34:09' ,'2021/05/11 10:10:09' ,1),
('New 43m length tram',N'2021/02/22 11:44:59',N'2021/03/31 13:00:00',2),
('New  18m Electric Bus',N'2021/02/15 13:44:22',N'2021/03/11 12:00:00',3),
('New pantograph for Pesa 2014N',N'2021/02/18 11:56:33',N'2021/04/01 19:00:00',4),
('New gearbox for Urbino 12 III',N'2021/01/18 17:33:44',N'2021/02/01 22:00:09',5),
('NG for NGT6 1st type',N'2020/02/18 14:33:22',N'2021/04/01 07:00:00',6)
INSERT INTO [Company Owner] VALUES
(1,'Jan','Pozna�ski','505222456','modertrans@modertrans.poznan.pl'),
(2,'Andrzej','Kolorys','662545321','protram@onet.pl'),
(3,'Janusz','Ziemianin','884669357','twojaczesc@serwis.waw.pl'),
(4,'Maciej','Rafiolin','667657524','solaris@solarisinfo.pl'),
(5,'Mateusz','Zimny','667888524','bomardierinfo@deuchtrans.de'),
(6,'Antoni','Pomara�cza','874888524','mpklodzremonty@mpk.lodz.pl')
INSERT INTO [Company] VALUES
(1,'ModerTrans Pozna�','Forteczna 2, Pozna�','618775417','modertrans@modertrans.poznan.pl',1),
(2,'Protram Wroc�aw','Legicka 4, Wroc�aw','662545321','protramservice@wroclawia.pl',2),
(3,'Zak�ad remont�w Pojazd�w Wroc�aw','O�bi�ska 42, Wroc�aw','888425987','mpkwroc@wroc.pl',2),
(4,'Cz�ci Autobusowe KrakBus','Kawiory 45, Krak�w','565874123','janusz.serwis@gmail.com',3),
(5,'Solaris sp. z.o.o','ul. Obornicka 46 Bolechowo-Osiedle','48616672333','office@solarisbus.com',4),
(6,'Bombardier Transportation','Kinderplatz 45','985687245','officede@bombardier.de',5),
(7,'MPK ��d�','ul. Telefoniczna 446 ��d�','548741987','officelodz@mpk.lodz.pl',6),
(8,'MPK Gda�sk','ul. Morska 446 Gda�sk','547896321','gdampk@mpk.gdansk.pl',6)
select * from [Tender participants]
INSERT INTO [Tender participants] VALUES
(1,1),
(2,1),
(2,2),
(2,6),
(3,5),
(3,7),
(4,1),
(4,3),
(5,4),
(6,1),
(6,2)
