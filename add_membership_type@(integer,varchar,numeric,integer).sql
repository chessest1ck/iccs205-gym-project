create function add_membership_type(_gym_id integer, _name character varying, _price numeric, _duration_days integer) returns text
    language plpgsql
as
$$
DECLARE
    _new_id INTEGER;
BEGIN
    IF _price < 0 THEN
        RETURN 'Error: Price cannot be negative.';
    END IF;

    IF _duration_days <= 0 THEN
        RETURN 'Error: Duration must be at least 1 day.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM gyms WHERE gym_id = _gym_id) THEN
        RETURN 'Error: Gym ID ' || _gym_id || ' not found.';
    END IF;

    INSERT INTO membership_types (gym_id, name, price, duration_days)
    VALUES (_gym_id, _name, _price, _duration_days)
    RETURNING type_id INTO _new_id;

    RETURN 'Success: "' || _name || '" created (ID: ' || _new_id || ')';
END;
$$;

alter function add_membership_type(integer, varchar, numeric, integer) owner to root;

