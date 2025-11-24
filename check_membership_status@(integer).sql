create function check_membership_status(_member_id integer) returns text
    language plpgsql
as
$$
DECLARE
    _end_date DATE;
BEGIN
    SELECT membership_end_date INTO _end_date FROM members WHERE member_id = _member_id;

    IF _end_date < CURRENT_DATE THEN
        RETURN 'Expired on ' || _end_date;
    ELSE
        RETURN 'Active until ' || _end_date;
    END IF;
END;
$$;

alter function check_membership_status(integer) owner to root;

