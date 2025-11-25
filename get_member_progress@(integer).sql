create function get_member_progress(_gym_id integer, _member_id integer)
    returns TABLE(log_date date, weight_kg numeric, body_fat_percent numeric)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
    SELECT
        pl.log_date,
        pl.weight_kg,
        pl.body_fat_percent
    FROM progress_logs pl
    JOIN members m ON pl.member_id = m.member_id
    WHERE pl.member_id = _member_id
      AND m.gym_id = _gym_id
    ORDER BY pl.log_date ASC;
END;
$$;

alter function get_member_progress(integer, integer) owner to root;

