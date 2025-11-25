create function get_equipment_summary(_gym_id integer)
    returns TABLE(status_type text, count bigint)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
    SELECT
        e.status::TEXT,
        COUNT(*)
    FROM equipment e
    WHERE e.gym_id = _gym_id
    GROUP BY e.status;
END;
$$;

alter function get_equipment_summary(integer) owner to root;

