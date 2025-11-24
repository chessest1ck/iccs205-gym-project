create function perform_maintenance(_equipment_id integer, _notes text, _cost numeric) returns void
    language plpgsql
as
$$
DECLARE
    rows_affected integer;
BEGIN
    INSERT INTO maintenance_logs (equipment_id, description, cost)
    VALUES (_equipment_id, _notes, _cost);

    UPDATE equipment
    SET last_maintenance_date = CURRENT_DATE,
        status = 'Inactive'
    WHERE equipment_id = _equipment_id;
    
    GET DIAGNOSTICS rows_affected = ROW_COUNT;
    
    IF rows_affected = 0 THEN
        RAISE EXCEPTION 'Equipment ID % not found. No status update occurred.', _equipment_id;
    ELSE
        RAISE NOTICE 'Success: Equipment % updated to Inactive.', _equipment_id;
    END IF;
END;
$$;

alter function perform_maintenance(integer, text, numeric) owner to root;

