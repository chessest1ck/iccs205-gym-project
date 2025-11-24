create function renew_membership(_member_id integer) returns text
    language plpgsql
as
$$
DECLARE
    _type_id INT;
    _duration INT;
    _current_end DATE;
    _new_end DATE;
BEGIN
    SELECT type_id, membership_end_date
    INTO _type_id, _current_end
    FROM members
    WHERE member_id = _member_id;

    IF _type_id IS NULL THEN
        RETURN 'Error: Member ID ' || _member_id || ' not found.';
    END IF;

    SELECT duration_days INTO _duration
    FROM membership_types
    WHERE type_id = _type_id;

    IF _duration IS NULL THEN
        RETURN 'Error: Membership Type not configured properly.';
    END IF;

    IF _current_end IS NULL OR _current_end < CURRENT_DATE THEN
        _new_end := CURRENT_DATE + _duration;
    ELSE
        _new_end := _current_end + _duration;
    END IF;

    UPDATE members
    SET membership_end_date = _new_end
    WHERE member_id = _member_id;

    RETURN 'Success: Membership renewed. New Expiry: ' || _new_end;
END;
$$;

alter function renew_membership(integer) owner to root;

