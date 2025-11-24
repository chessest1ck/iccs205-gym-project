create function perform_maintenance(_equipment_id integer, _notes text, _cost numeric) returns void
    language plpgsql
as
$$
BEGIN
    INSERT INTO maintenance_logs (equipment_id, description, cost)
    VALUES (_equipment_id, _notes, _cost);
    UPDATE equipment
    SET last_maintenance_date = CURRENT_DATE,
        status = 'Active'
    WHERE equipment_id = _equipment_id;
END;
$$;

alter function perform_maintenance(integer, text, numeric) owner to root;

