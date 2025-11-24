create function get_equipment_status()
    returns TABLE(equipment_id integer, name text, last_maintenance_date date, status text)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
    SELECT
        e.equipment_id,
        e.name::TEXT,
        e.last_maintenance_date,
        e.status::TEXT
    FROM equipment AS e
    ORDER BY e.equipment_id;
END;
$$;

alter function get_equipment_status() owner to root;

