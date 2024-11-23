DROP DATABASE `reservation_system`;
CREATE DATABASE IF NOT EXISTS `reservation_system`;
USE `reservation_system`;

CREATE TABLE IF NOT EXISTS Weekday(weekday varchar(9) primary key);
CREATE TABLE IF NOT EXISTS Ticket(num int primary key, fare float NOT NULL, booking_fee float NOT NULL);
CREATE TABLE IF NOT EXISTS Airline(id char(2) primary key);
CREATE TABLE IF NOT EXISTS Airport(id char(3) primary key);
CREATE TABLE IF NOT EXISTS Aircraft(registration varchar(6) primary key, seats int NOT NULL, airline_id char(2) NOT NULL, 
									foreign key (airline_id) references airline(id) ON UPDATE CASCADE ON DELETE CASCADE);
CREATE TABLE IF NOT EXISTS Users(id int primary key AUTO_INCREMENT, username varchar(20) UNIQUE NOT NULL, password varchar(20) NOT NULL, 
								 fname varchar(30) NOT NULL, lname varchar(30) NOT NULL, permission varchar(8) NOT NULL);
CREATE TABLE IF NOT EXISTS Cust_Ticket(ticket_num int, cust_id integer, class varchar(11) NOT NULL, 
									   time_purchased datetime NOT NULL, primary key(ticket_num, cust_id),
									   foreign key(ticket_num) references Ticket(num) ON UPDATE CASCADE ON DELETE CASCADE,
                                       foreign key(cust_id) references users(id) ON UPDATE CASCADE ON DELETE CASCADE);
CREATE TABLE IF NOT EXISTS Flight(num int, flight_type varchar(13) NOT NULL, registration varchar(6) NOT NULL, airline_id char(2), 
								  dep_airport_id char(3) NOT NULL, dep_date date NOT NULL, dep_time time, arr_airport_id char(3) NOT NULL, 
                                  arr_date date NOT NULL, arr_time time NOT NULL, price int NOT NULL, primary key(num, airline_id),
                                  foreign key(registration) references Aircraft(registration) ON UPDATE CASCADE ON DELETE CASCADE, 
                                  foreign key(airline_id) references Airline(id) ON UPDATE CASCADE ON DELETE CASCADE, 
                                  foreign key(dep_airport_id) references Airport(id) ON UPDATE CASCADE ON DELETE CASCADE,
                                  foreign key(arr_airport_id) references Airport(id) ON UPDATE CASCADE ON DELETE CASCADE);
CREATE TABLE IF NOT EXISTS Ticket_Flight(ticket_num int, flight_num int, airline_id char(2), 
										primary key(ticket_num, flight_num, airline_id),
										foreign key(ticket_num) references Ticket(num) ON UPDATE CASCADE ON DELETE CASCADE,
										foreign key(airline_id, flight_num) references Flight(airline_id, num) ON UPDATE CASCADE ON DELETE CASCADE);
CREATE TABLE IF NOT EXISTS Waiting_list(flight_num int, airline_id char(2), cust_id int, 
										primary key(flight_num, airline_id, cust_id), 
										foreign key(flight_num, airline_id) references Flight(num, airline_id) ON UPDATE CASCADE ON DELETE CASCADE, 
                                        foreign key(cust_id) references users(id) ON UPDATE CASCADE ON DELETE CASCADE);
CREATE TABLE IF NOT EXISTS Questions(id int primary key AUTO_INCREMENT, subject varchar(30) NOT NULL, field varchar(400) NOT NULL, userid int NOT NULL, 
									 foreign key(userid) references users(id) ON UPDATE CASCADE ON DELETE CASCADE);
CREATE TABLE IF NOT EXISTS Replies(id int primary key, field varchar(400) NOT NULL, csrepid int NOT NULL, 
								   foreign key(id) references Questions(id) ON UPDATE CASCADE ON DELETE CASCADE,
                                   foreign key(csrepid) references Users(id) ON UPDATE CASCADE ON DELETE CASCADE);
CREATE TABLE IF NOT EXISTS Associated_with(airline_id char(2), airport_id char(3), primary key(airline_id, airport_id),
										   foreign key(airline_id) references Airline(id) ON UPDATE CASCADE ON DELETE CASCADE,
                                           foreign key(airport_id) references Airport(id) ON UPDATE CASCADE ON DELETE CASCADE);
CREATE TABLE IF NOT EXISTS Operates_on(flight_num integer, weekday varchar(9), airline_id char(2), 
									   primary key(flight_num, airline_id, weekday),
									   foreign key(flight_num, airline_id) references Flight(num, airline_id) ON UPDATE CASCADE ON DELETE CASCADE,
                                       foreign key(weekday) references Weekday(weekday) ON UPDATE CASCADE ON DELETE CASCADE);

INSERT INTO Users VALUES(1, "csrep", "1234", "Jeeva", "Ramasamy", "cust_rep");
INSERT INTO Users VALUES(2, "Woogy99", "1234", "Woogy", "Sim", "customer");
INSERT INTO Users VALUES(3, "admin", "1234", "333", "1112", "admin");
INSERT INTO Users VALUES(4, "user", "password", "user", "user", "customer");
INSERT INTO Users VALUES(5, "user2", "password", "John", "Johnes", "customer");
INSERT INTO Users VALUES(6, "user3", "password", "James", "James", "customer");

INSERT INTO Airline VALUES ('DL');
INSERT INTO Airline VALUES ('LH');
INSERT INTO Airline VALUES ('B6');
INSERT INTO Airline VALUES ('EK');
INSERT INTO Airline VALUES ('AS');
INSERT INTO Airline VALUES ('SQ');
INSERT INTO Airline VALUES ('AA');
INSERT INTO Airline VALUES ('QF');
INSERT INTO Airline VALUES ('WN');
INSERT INTO Airline VALUES ('CX');

INSERT INTO Aircraft VALUES ('N4444', 160, 'DL');
INSERT INTO Aircraft VALUES ('N5555', 220, 'LH');
INSERT INTO Aircraft VALUES ('N6666', 130, 'B6');
INSERT INTO Aircraft VALUES ('N7777', 250, 'EK');
INSERT INTO Aircraft VALUES ('N8888', 170, 'AS');
INSERT INTO Aircraft VALUES ('N9999', 300, 'SQ');
INSERT INTO Aircraft VALUES ('N1010', 200, 'AA');
INSERT INTO Aircraft VALUES ('N1111', 120, 'QF');
INSERT INTO Aircraft VALUES ('N1212', 190, 'WN');
INSERT INTO Aircraft VALUES ('N1313', 240, 'CX');

INSERT INTO Airport VALUES ('ATL');
INSERT INTO Airport VALUES ('MIA');
INSERT INTO Airport VALUES ('FRA');
INSERT INTO Airport VALUES ('ORD');
INSERT INTO Airport VALUES ('BOS');
INSERT INTO Airport VALUES ('MCO');
INSERT INTO Airport VALUES ('DXB');
INSERT INTO Airport VALUES ('JFK');
INSERT INTO Airport VALUES ('SEA');
INSERT INTO Airport VALUES ('SFO');
INSERT INTO Airport VALUES ('SIN');
INSERT INTO Airport VALUES ('LAX');
INSERT INTO Airport VALUES ('DFW');
INSERT INTO Airport VALUES ('SYD');
INSERT INTO Airport VALUES ('PHX');
INSERT INTO Airport VALUES ('LAS');
INSERT INTO Airport VALUES ('HKG');

INSERT INTO Flight VALUES (207, 'Domestic', 'N4444', 'DL', 'ATL', '2023-12-12', '14:45:00', 'MIA', '2023-12-12', '17:30:00', 280.00);
INSERT INTO Flight VALUES (208, 'International', 'N5555', 'LH', 'FRA', '2023-12-15', '18:30:00', 'ORD', '2023-12-15', '22:15:00', 850.00);
INSERT INTO Flight VALUES (209, 'Domestic', 'N6666', 'B6', 'MIA', '2023-12-18', '08:15:00', 'MCO', '2023-12-18', '11:45:00', 220.00);
INSERT INTO Flight VALUES (210, 'International', 'N7777', 'EK', 'MCO', '2023-12-21', '23:00:00', 'JFK', '2023-12-22', '06:30:00', 1200.00);
INSERT INTO Flight VALUES (211, 'Domestic', 'N8888', 'AS', 'MCO', '2023-12-25', '12:30:00', 'SFO', '2023-12-25', '15:15:00', 320.00);
INSERT INTO Flight VALUES (212, 'International', 'N9999', 'SQ', 'SIN', '2023-12-28', '06:00:00', 'LAX', '2023-12-28', '14:45:00', 1100.00);
INSERT INTO Flight VALUES (213, 'Domestic', 'N1010', 'AA', 'LAX', '2024-01-02', '09:45:00', 'ORD', '2024-01-02', '12:30:00', 260.00);
INSERT INTO Flight VALUES (214, 'International', 'N1111', 'QF', 'ORD', '2024-01-05', '20:00:00', 'SYD', '2024-01-06', '04:30:00', 950.00);
INSERT INTO Flight VALUES (215, 'Domestic', 'N1212', 'WN', 'PHX', '2024-01-08', '07:30:00', 'LAS', '2024-01-08', '09:15:00', 180.00);
INSERT INTO Flight VALUES (216, 'International', 'N1313', 'CX', 'LAS', '2024-01-11', '16:15:00', 'HKG', '2024-01-12', '00:45:00', 1300.00);
INSERT INTO Flight VALUES (217, 'Domestic', 'N1111', 'QF', 'ORD', '2024-01-12', '12:52:00', 'LAS', '2024-01-12', '17:23:00', 420.00);
INSERT INTO Flight VALUES (218, 'International', 'N1111', 'QF', 'SFO', '2024-01-13', '12:52:00', 'HKG', '2024-01-14', '17:23:00', 1420.00);
INSERT INTO Flight VALUES (219, 'International', 'N1111', 'QF', 'LAX', '2024-01-15', '12:52:00', 'SYD', '2024-01-16', '17:23:00', 1020.00);
INSERT INTO Flight VALUES (220, 'Domestic', 'N1212', 'WN', 'LAS', '2024-01-15', '12:52:00', 'JFK', '2024-01-15', '20:23:00', 520.00);

INSERT INTO Ticket VALUES (1, 820.00, 10.00);
INSERT INTO Ticket VALUES (2, 850.00, 15.00); 
INSERT INTO Ticket VALUES (3, 1420.00, 12.00);
INSERT INTO Ticket VALUES (4, 2310.00, 10.00);
INSERT INTO Ticket VALUES (5, 1480.00, 20.00);
INSERT INTO Ticket VALUES (6, 280.00, 15.00);
INSERT INTO Ticket VALUES (7, 680.00, 15.00);
INSERT INTO Ticket VALUES (8, 1740.00, 15.00);
INSERT INTO Ticket VALUES (9, 2120.00, 15.00);
INSERT INTO Ticket VALUES (10, 700.00, 15.00);

INSERT INTO Ticket_Flight VALUES (1, 207, 'DL');
INSERT INTO Ticket_Flight VALUES (1, 209, 'B6');
INSERT INTO Ticket_Flight VALUES (1, 211, 'AS');
INSERT INTO Ticket_Flight VALUES (2, 208, 'LH');
INSERT INTO Ticket_Flight VALUES (3, 209, 'B6');
INSERT INTO Ticket_Flight VALUES (3, 210, 'EK');
INSERT INTO Ticket_Flight VALUES (4, 212, 'SQ');
INSERT INTO Ticket_Flight VALUES (4, 213, 'AA');
INSERT INTO Ticket_Flight VALUES (4, 214, 'QF');
INSERT INTO Ticket_Flight VALUES (5, 215, 'WN');
INSERT INTO Ticket_Flight VALUES (5, 216, 'CX');
INSERT INTO Ticket_Flight VALUES (6, 207, 'DL');
INSERT INTO Ticket_Flight VALUES (7, 213, 'AA');
INSERT INTO Ticket_Flight VALUES (7, 217, 'QF');
INSERT INTO Ticket_Flight VALUES (8, 211, 'AS');
INSERT INTO Ticket_Flight VALUES (8, 218, 'QF');
INSERT INTO Ticket_Flight VALUES (9, 212, 'SQ');
INSERT INTO Ticket_Flight VALUES (9, 219, 'QF');
INSERT INTO Ticket_Flight VALUES (10, 215, 'WN');
INSERT INTO Ticket_Flight VALUES (10, 220, 'WN');

INSERT INTO Cust_Ticket VALUES (1, 2, 'Economy', '2023-10-10 10:30:00');
INSERT INTO Cust_Ticket VALUES (7, 2, 'First Class', '2023-11-24 09:00:00');
INSERT INTO Cust_Ticket VALUES (10, 2, 'Business', '2023-12-01 15:45:00');
INSERT INTO Cust_Ticket VALUES (2, 4, 'Business', '2023-11-27 14:30:00');
INSERT INTO Cust_Ticket VALUES (8, 4, 'First Class', '2023-11-12 08:00:00');
INSERT INTO Cust_Ticket VALUES (3, 5, 'Economy', '2023-11-30 22:00:00');
INSERT INTO Cust_Ticket VALUES (9, 5, 'Economy', '2023-12-02 20:15:00');
INSERT INTO Cust_Ticket VALUES (4, 6, 'First Class', '2023-10-03 07:15:00');
INSERT INTO Cust_Ticket VALUES (5, 6, 'Business', '2023-11-17 12:30:00');
INSERT INTO Cust_Ticket VALUES (6, 6, 'Economy', '2023-11-20 18:45:00');