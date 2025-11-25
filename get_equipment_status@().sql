create function get_equipment_status(_gym_id integer)
    returns TABLE(r_equipment_id integer, r_name text, r_last_maintenance date, r_status text)
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
    WHERE e.gym_id = _gym_id
    ORDER BY e.equipment_id;
END;
$$;

alter function get_equipment_status(integer) owner to root;

