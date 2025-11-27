create function get_daily_attendance_log(_gym_id integer, _date date DEFAULT CURRENT_DATE)
    returns TABLE(r_member_name character varying, r_check_in_time timestamp without time zone, r_status character varying)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
    SELECT
        m.full_name,
        al.check_in_time,
        CASE
            WHEN m.membership_end_date < CURRENT_DATE THEN 'Expired'
            ELSE 'Active'
        END::VARCHAR
    FROM attendance_logs al
    JOIN members m ON al.member_id = m.member_id
    WHERE al.gym_id = _gym_id
      AND al.check_in_time::DATE = _date
    ORDER BY al.check_in_time DESC;
END;
$$;

alter function get_daily_attendance_log(integer, date) owner to root;

