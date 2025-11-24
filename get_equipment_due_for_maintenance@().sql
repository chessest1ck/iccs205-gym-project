create function get_equipment_due_for_maintenance()
    returns TABLE(equipment_id integer, name character varying, last_maintenance date)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
    SELECT
        e.equipment_id,
        e.name,
        e.last_maintenance_date
    FROM equipment AS e
    WHERE e.last_maintenance_date < (CURRENT_DATE - INTERVAL '30 days')
       OR e.last_maintenance_date IS NULL
    ORDER BY e.last_maintenance_date ASC;
END;
$$;

alter function get_equipment_due_for_maintenance() owner to root;

