CREATE INDEX passenger_ticket_1 ON Passenger([Last name]) 
CREATE INDEX passenger_ticket_2 ON Tickets(ID_Passenger, [End date],ID_Line)
CREATE INDEX service_parts_1 ON [Service part](Name, ID_Type)
CREATE INDEX service_parts_2 ON Vehicle([Vin Number])
CREATE INDEX sheudle_1 ON Employee([Last Name], ID_License)
CREATE INDEX sheudle_2 ON [Vehicle type](Capacity)
CREATE INDEX tender_1 ON Tender([Tender name], ID_tender)
CREATE INDEX tender_2 ON [Tender participants] (ID_tender, ID_Customer)
CREATE INDEX tender_3 ON Company(ID_Customer, [Company name])

Select [Last name],ID_ticket,[End date], ID_Line
from Passenger p join Tickets t
on p.ID_Passenger=t.ID_Passenger
where [Last name]='Niski'

Select Name, [Vin Number]
from [Service part] s join Vehicle v
on s.ID_Type=v.ID_Type
where [Vin Number]=811966977

Select [Last Name], Capacity
from Employee e join [Vehicle type] vt
on e.ID_License=vt.ID_Licece
where ID_Licece='TRM0000001'

Select [Tender name], [Company name]
from Tender t join [Tender participants] p
on t.ID_Tender=p.ID_Tender join Company c
on  p.ID_Customer=c.ID_Customer
where t.ID_Tender=2