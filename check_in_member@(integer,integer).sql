create function check_in_member(_member_id integer, _gym_id integer) returns text
    language plpgsql
as
$$
DECLARE
    _end_date DATE;
    _member_name VARCHAR;
BEGIN
    SELECT full_name, membership_end_date
    INTO _member_name, _end_date
    FROM members
    WHERE member_id = _member_id AND gym_id = _gym_id;

    IF _member_name IS NULL THEN
        RETURN 'Error: Member not found in this gym.';
    END IF;

    IF _end_date < CURRENT_DATE THEN
        RETURN 'ACCESS DENIED: Membership expired on ' || _end_date;
    END IF;

    INSERT INTO attendance_logs (member_id, gym_id, check_in_time)
    VALUES (_member_id, _gym_id, CURRENT_TIMESTAMP);

    UPDATE members
    SET last_attend_date = CURRENT_TIMESTAMP
    WHERE member_id = _member_id;

    RETURN 'Success: Welcome ' || _member_name || '! Check-in recorded.';
END;
$$;

alter function check_in_member(integer, integer) owner to root;

