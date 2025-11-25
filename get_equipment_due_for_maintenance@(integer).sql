create function get_equipment_due_for_maintenance(_gym_id integer)
    returns TABLE(r_equipment_id integer, r_name character varying, r_last_maintenance date)
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
    WHERE e.gym_id = _gym_id
      AND (
          e.last_maintenance_date < (CURRENT_DATE - INTERVAL '30 days')
          OR
          e.last_maintenance_date IS NULL
      )
    ORDER BY e.last_maintenance_date ASC NULLS FIRST;
END;
$$;

alter function get_equipment_due_for_maintenance(integer) owner to root;

