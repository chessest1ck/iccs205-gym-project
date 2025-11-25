create function retire_equipment(_gym_id integer, _equipment_id integer) returns text
    language plpgsql
as
$$
DECLARE
    _name VARCHAR;
BEGIN
    SELECT name INTO _name
    FROM equipment
    WHERE equipment_id = _equipment_id AND gym_id = _gym_id;

    IF _name IS NULL THEN
        RETURN 'Error: Equipment not found.';
    END IF;

    UPDATE equipment
    SET status = 'Retired'
    WHERE equipment_id = _equipment_id;

    RETURN 'Success: ' || _name || ' is now marked as Retired.';
END;
$$;

alter function retire_equipment(integer, integer) owner to root;

