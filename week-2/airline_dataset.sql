-- Airline Management System Dataset
-- This script creates the necessary tables and populates them with sample data.

-- Drop existing tables to start fresh
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS passengers;
DROP TABLE IF EXISTS airlines;
DROP TABLE IF EXISTS airports;

-- Create the tables
CREATE TABLE airlines (
    airline_id SERIAL PRIMARY KEY,
    airline_name VARCHAR(100) NOT NULL,
    headquarters VARCHAR(100)
);

CREATE TABLE airports (
    airport_code CHAR(3) PRIMARY KEY,
    airport_name VARCHAR(100),
    city VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE flights (
    flight_id SERIAL PRIMARY KEY,
    flight_number VARCHAR(10) NOT NULL,
    airline_id INT REFERENCES airlines(airline_id),
    origin_airport CHAR(3) REFERENCES airports(airport_code),
    destination_airport CHAR(3) REFERENCES airports(airport_code),
    departure_time TIMESTAMP,
    arrival_time TIMESTAMP,
    base_price NUMERIC(10, 2)
);

CREATE TABLE passengers (
    passenger_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    flight_id INT REFERENCES flights(flight_id),
    passenger_id INT REFERENCES passengers(passenger_id),
    booking_date DATE,
    seat_number VARCHAR(4),
    status VARCHAR(20) CHECK (status IN ('Confirmed', 'Cancelled', 'Waitlisted'))
);

-- Populate the tables with sample data
INSERT INTO airlines (airline_name, headquarters) VALUES
('Gemini Air', 'Mountain View'),
('Starlight Airways', 'London'),
('Quantum Lines', 'Seattle'),
('Celestial Charters', 'Singapore');

INSERT INTO airports (airport_code, airport_name, city, country) VALUES
('SFO', 'San Francisco International Airport', 'San Francisco', 'USA'),
('LAX', 'Los Angeles International Airport', 'Los Angeles', 'USA'),
('JFK', 'John F. Kennedy International Airport', 'New York', 'USA'),
('ORD', 'O''Hare International Airport', 'Chicago', 'USA'),
('LHR', 'Heathrow Airport', 'London', 'UK'),
('ATL', 'Hartsfield-Jackson Atlanta International Airport', 'Atlanta', 'USA'),
('DEN', 'Denver International Airport', 'Denver', 'USA'),
('CDG', 'Charles de Gaulle Airport', 'Paris', 'France'),
('HND', 'Haneda Airport', 'Tokyo', 'Japan');

INSERT INTO flights (flight_number, airline_id, origin_airport, destination_airport, departure_time, arrival_time, base_price) VALUES
-- Gemini Air
('GA101', 1, 'SFO', 'LAX', '2026-03-01 08:00:00', '2026-03-01 09:30:00', 250.00),
('GA102', 1, 'LAX', 'SFO', '2026-03-01 11:00:00', '2026-03-01 12:30:00', 250.00),
('GA202', 1, 'JFK', 'ORD', '2026-03-05 15:00:00', '2026-03-05 17:00:00', 450.00),
('GA300', 1, 'SFO', 'DEN', '2026-03-02 14:00:00', '2026-03-02 17:30:00', 320.00),
('GA301', 1, 'DEN', 'SFO', '2026-03-02 19:00:00', '2026-03-02 20:30:00', 310.00),
-- Starlight Airways
('SA201', 2, 'JFK', 'LHR', '2026-03-05 19:00:00', '2026-03-06 07:00:00', 800.00),
('SA301', 2, 'LHR', 'SFO', '2026-03-10 10:00:00', '2026-03-10 13:00:00', 1200.00),
('SA400', 2, 'LHR', 'CDG', '2026-03-03 09:00:00', '2026-03-03 10:15:00', 150.00),
('SA401', 2, 'CDG', 'LHR', '2026-03-03 12:00:00', '2026-03-03 13:15:00', 140.00),
-- Quantum Lines
('QL500', 3, 'LAX', 'JFK', '2026-03-04 07:00:00', '2026-03-04 15:30:00', 550.00),
('QL501', 3, 'JFK', 'LAX', '2026-03-04 17:00:00', '2026-03-05 01:30:00', 540.00),
('QL600', 3, 'ORD', 'ATL', '2026-03-06 10:00:00', '2026-03-06 12:00:00', 280.00),
('QL700', 3, 'SFO', 'HND', '2026-03-12 22:00:00', '2026-03-14 02:00:00', 1500.00),
-- Celestial Charters
('CC800', 4, 'HND', 'SFO', '2026-03-15 11:00:00', '2026-03-15 04:00:00', 1600.00),
('CC900', 4, 'CDG', 'JFK', '2026-03-07 11:00:00', '2026-03-07 13:30:00', 750.00),
('CC901', 4, 'JFK', 'CDG', '2026-03-07 18:00:00', '2026-03-08 07:30:00', 760.00);

INSERT INTO passengers (first_name, last_name, email) VALUES
('John', 'Doe', 'john.doe@example.com'),
('Jane', 'Smith', 'jane.smith@example.com'),
('Peter', 'Jones', 'peter.jones@example.com'),
('Emily', 'White', 'emily.white@example.com'),
('Michael', 'Green', 'michael.green@example.com'),
('Sarah', 'Black', 'sarah.black@example.com'),
('David', 'Hall', 'david.hall@example.com'),
('Laura', 'King', 'laura.king@example.com'),
('Robert', 'Hill', 'robert.hill@example.com'),
('Linda', 'Scott', 'linda.scott@example.com'),
('James', 'Adams', 'james.adams@example.com'),
('Patricia', 'Baker', 'patricia.baker@example.com'),
('Charles', 'Clark', 'charles.clark@example.com'),
('Jennifer', 'Davis', 'jennifer.davis@example.com'),
('William', 'Evans', 'william.evans@example.com'),
('Mary', 'Frank', 'mary.frank@example.com'),
('Richard', 'Ghosh', 'richard.ghosh@example.com'),
('Susan', 'Harris', 'susan.harris@example.com'),
('Joseph', 'Irwin', 'joseph.irwin@example.com'),
('Karen', 'Jackson', 'karen.jackson@example.com');

INSERT INTO bookings (flight_id, passenger_id, booking_date, seat_number, status) VALUES
(1, 1, '2026-02-15', '12A', 'Confirmed'),
(1, 2, '2026-02-16', '12B', 'Confirmed'),
(1, 3, '2026-02-17', '12C', 'Confirmed'),
(1, 4, '2026-02-18', '12D', 'Cancelled'),
(1, 5, '2026-02-19', '12E', 'Confirmed'),
(2, 6, '2026-02-20', '15A', 'Confirmed'),
(2, 7, '2026-02-21', '15B', 'Confirmed'),
(3, 8, '2026-02-22', '22F', 'Confirmed'),
(3, 9, '2026-02-23', '22G', 'Waitlisted'),
(3, 1, '2026-02-24', '22H', 'Confirmed'),
(4, 10, '2026-02-25', '8A', 'Confirmed'),
(4, 11, '2026-02-26', '8B', 'Confirmed'),
(5, 12, '2026-02-27', '9C', 'Confirmed'),
(6, 13, '2026-02-28', '30A', 'Confirmed'),
(6, 14, '2026-03-01', '30B', 'Cancelled'),
(6, 15, '2026-03-02', '30C', 'Confirmed'),
(7, 16, '2026-03-03', '7D', 'Confirmed'),
(8, 17, '2026-03-04', '4A', 'Confirmed'),
(8, 18, '2026-03-04', '4B', 'Confirmed'),
(9, 19, '2026-03-05', '5E', 'Confirmed'),
(9, 20, '2026-03-05', '5F', 'Waitlisted'),
(10, 1, '2026-03-06', '11A', 'Confirmed'),
(10, 2, '2026-03-06', '11B', 'Confirmed'),
(10, 3, '2026-03-06', '11C', 'Confirmed'),
(11, 4, '2026-03-07', '21A', 'Confirmed'),
(12, 5, '2026-03-08', '2A', 'Confirmed'),
(12, 6, '2026-03-08', '2B', 'Cancelled'),
(13, 7, '2026-03-09', '40G', 'Confirmed'),
(14, 8, '2026-03-10', '41H', 'Confirmed'),
(15, 9, '2026-03-11', '1A', 'Confirmed'),
(15, 10, '2026-03-11', '1B', 'Confirmed'),
(16, 11, '2026-03-12', '2A', 'Confirmed'),
(16, 12, '2026-03-12', '2B', 'Waitlisted'),
(16, 13, '2026-03-12', '2C', 'Waitlisted');

-- End of script