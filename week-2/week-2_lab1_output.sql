
--Activity 1
CREATE OR REPLACE FUNCTION get_flight_duration(p_flight_id INT)
RETURNS INTERVAL AS $$
DECLARE
    v_duration INTERVAL;
BEGIN
    SELECT arrival_time - departure_time
    INTO v_duration
    FROM flights
    WHERE flight_id = p_flight_id;

    RETURN v_duration;
END;
$$ LANGUAGE plpgsql;

SELECT flight_number, get_flight_duration(flight_id) AS duration
FROM flights
WHERE flight_number = 'SA201';

--Activity 2
CREATE OR REPLACE FUNCTION get_price_category(p_flight_id INT)
RETURNS TEXT AS $$
DECLARE
    v_price NUMERIC;
BEGIN
    SELECT base_price
    INTO v_price
    FROM flights
    WHERE flight_id = p_flight_id;

    IF v_price < 300 THEN
        RETURN 'Budget';
    ELSIF v_price BETWEEN 300 AND 800 THEN
        RETURN 'Standard';
    ELSE
        RETURN 'Premium';
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT flight_number, base_price, get_price_category(flight_id) AS category
FROM flights;

--Activity 3
CREATE OR REPLACE PROCEDURE book_flight(
    p_passenger_id INT,
    p_flight_id INT,
    p_seat_number VARCHAR
)
AS $$
BEGIN
    INSERT INTO bookings (
        flight_id,
        passenger_id,
        booking_date,
        seat_number,
        status
    )
    VALUES (
        p_flight_id,
        p_passenger_id,
        CURRENT_DATE,
        p_seat_number,
        'Confirmed'
    );
END;
$$ LANGUAGE plpgsql;

SELECT COUNT(*) FROM bookings WHERE flight_id = 1;

CALL book_flight(3, 1, '14C');

SELECT COUNT(*) FROM bookings WHERE flight_id = 1;


--Activity 4
CREATE OR REPLACE PROCEDURE increase_prices_for_airline(
    p_airline_id INT,
    p_percentage_increase NUMERIC
)
AS $$
DECLARE
    flight_rec RECORD;
BEGIN
    FOR flight_rec IN
        SELECT flight_id, base_price
        FROM flights
        WHERE airline_id = p_airline_id
    LOOP
        UPDATE flights
        SET base_price = base_price + (base_price * p_percentage_increase / 100)
        WHERE flight_id = flight_rec.flight_id;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Check prices before
SELECT flight_number, base_price
FROM flights
WHERE airline_id = 1;

-- Increase prices by 10%
CALL increase_prices_for_airline(1, 10);

-- Check prices after
SELECT flight_number, base_price
FROM flights
WHERE airline_id = 1;
