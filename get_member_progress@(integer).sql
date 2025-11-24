create function get_member_progress(_member_id integer)
    returns TABLE(r_weight numeric, r_body_fat numeric, r_log_date date)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
    SELECT
        p.weight_kg,
        p.body_fat_percent,
        p.log_date
    FROM progress_logs AS p
    WHERE p.member_id = _member_id
    ORDER BY p.log_date ASC;
END;
$$;

alter function get_member_progress(integer) owner to root;

