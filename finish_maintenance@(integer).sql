create function finish_maintenance(_equipment_id integer) returns text
    language plpgsql
as
$$
DECLARE
    _equip_name VARCHAR;
BEGIN
    SELECT name INTO _equip_name FROM equipment WHERE equipment_id = _equipment_id;

    IF _equip_name IS NULL THEN
        RETURN 'Error: Equipment ID ' || _equipment_id || ' not found.';
    END IF;

    UPDATE equipment
    SET status = 'Active'
    WHERE equipment_id = _equipment_id;

    RETURN 'Success: ' || _equip_name || ' is now ACTIVE and ready for use.';
END;
$$;

alter function finish_maintenance(integer) owner to root;

