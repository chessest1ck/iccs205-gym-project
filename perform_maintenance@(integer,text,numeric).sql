create function perform_maintenance(_equipment_id integer, _notes text, _cost numeric) returns text
    language plpgsql
as
$$
DECLARE
    _new_log_id INTEGER;
    _equip_name VARCHAR;
BEGIN
    SELECT name INTO _equip_name FROM equipment WHERE equipment_id = _equipment_id;

    IF _equip_name IS NULL THEN
        RETURN 'Error: Equipment ID ' || _equipment_id || ' not found.';
    END IF;

    INSERT INTO maintenance_logs (equipment_id, description, cost, log_date)
    VALUES (_equipment_id, _notes, _cost, CURRENT_DATE)
    RETURNING log_id INTO _new_log_id;

    UPDATE equipment
    SET last_maintenance_date = CURRENT_DATE,
        status = 'Inactive'
    WHERE equipment_id = _equipment_id;

    RETURN 'Maintenance recorded. ' || _equip_name || ' is now marked as INACTIVE.';
END;
$$;

alter function perform_maintenance(integer, text, numeric) owner to root;

