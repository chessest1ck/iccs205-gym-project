create function check_membership_status(_member_id integer) returns text
    language plpgsql
as
$$
DECLARE
    _member_name VARCHAR;
    _end_date DATE;
    _status_msg VARCHAR;
BEGIN
    SELECT full_name, membership_end_date
    INTO _member_name, _end_date
    FROM members
    WHERE member_id = _member_id;

    IF _member_name IS NULL THEN
        RETURN 'Error: Member not found.';
    END IF;

    IF _end_date IS NULL THEN
        _status_msg := 'PENDING (Payment Required)';
    ELSIF _end_date < CURRENT_DATE THEN
        _status_msg := 'EXPIRED on ' || _end_date;
    ELSE
        _status_msg := 'ACTIVE until ' || _end_date;
    END IF;

    RETURN 'Member: ' || _member_name || ' | Status: ' || _status_msg;
END;
$$;

alter function check_membership_status(integer) owner to root;

