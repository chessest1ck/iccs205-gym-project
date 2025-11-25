create function add_equipment(_gym_id integer, _name character varying, _purchase_date date DEFAULT CURRENT_DATE) returns text
    language plpgsql
as
$$
DECLARE
    _new_id INTEGER;
    _date_to_use DATE;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM gyms WHERE gym_id = _gym_id) THEN
        RETURN 'Error: Gym ID ' || _gym_id || ' not found.';
    END IF;

    _date_to_use := COALESCE(_purchase_date, CURRENT_DATE);

    INSERT INTO equipment (gym_id, name, purchase_date, last_maintenance_date, status)
    VALUES (_gym_id, _name, _date_to_use, NULL, 'Active')
    RETURNING equipment_id INTO _new_id;

    RETURN 'Success: "' || _name || '" added to inventory (ID: ' || _new_id || ')';
END;
$$;

alter function add_equipment(integer, varchar, date) owner to root;

