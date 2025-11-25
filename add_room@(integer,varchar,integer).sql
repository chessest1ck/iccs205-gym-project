create function add_room(_gym_id integer, _name character varying, _capacity integer) returns text
    language plpgsql
as
$$
DECLARE
    _new_id INTEGER;
BEGIN
    IF _capacity <= 0 THEN
        RETURN 'Error: Capacity must be greater than 0.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM gyms WHERE gym_id = _gym_id) THEN
        RETURN 'Error: Gym ID ' || _gym_id || ' not found.';
    END IF;

    INSERT INTO rooms (gym_id, name, capacity, status)
    VALUES (_gym_id, _name, _capacity, 'Available')
    RETURNING room_id INTO _new_id;

    RETURN 'Success: Room "' || _name || '" added (ID: ' || _new_id || ') with capacity ' || _capacity;
END;
$$;

alter function add_room(integer, varchar, integer) owner to root;

