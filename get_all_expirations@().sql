create function get_all_expirations(_gym_id integer)
    returns TABLE(r_member_id integer, r_name character varying, r_expires date, r_status text)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
    SELECT
        m.member_id,
        m.full_name,
        m.membership_end_date,
        CASE
            WHEN m.membership_end_date < CURRENT_DATE THEN 'EXPIRED'
            ELSE 'ACTIVE'
        END::TEXT
    FROM members m
    WHERE m.gym_id = _gym_id
      AND m.membership_end_date IS NOT NULL
    ORDER BY m.membership_end_date ASC;
END;
$$;

alter function get_all_expirations(integer) owner to root;

