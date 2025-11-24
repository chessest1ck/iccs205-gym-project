create function check_membership_status(_member_id integer) returns text
    language plpgsql
as
$$
DECLARE
    _member_name VARCHAR;
    _gym_name VARCHAR;
    _plan_name VARCHAR;
    _end_date DATE;
    _status_msg VARCHAR;
BEGIN
    SELECT
        m.full_name,
        g.name,
        mt.name,
        m.membership_end_date
    INTO
        _member_name,
        _gym_name,
        _plan_name,
        _end_date
    FROM members m
    JOIN gyms g ON m.gym_id = g.gym_id
    JOIN membership_types mt ON m.type_id = mt.type_id
    WHERE m.member_id = _member_id;

    IF _member_name IS NULL THEN
        RETURN 'Error: Member ID ' || _member_id || ' not found.';
    END IF;

    IF _end_date < CURRENT_DATE THEN
        _status_msg := 'EXPIRED on ' || _end_date;
    ELSE
        _status_msg := 'ACTIVE until ' || _end_date;
    END IF;

    RETURN 'Name: ' || _member_name || ' | Gym: ' || _gym_name || ' | Plan: ' || _plan_name || ' | Status: ' || _status_msg;
END;
$$;

alter function check_membership_status(integer) owner to root;

