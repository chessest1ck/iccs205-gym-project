create function revoke_membership(_gym_id integer, _member_id integer, _reason text) returns text
    language plpgsql
as
$$
DECLARE
    _name VARCHAR;
BEGIN
    SELECT full_name INTO _name
    FROM members
    WHERE member_id = _member_id AND gym_id = _gym_id;

    IF _name IS NULL THEN
        RETURN 'Error: Member not found.';
    END IF;

    UPDATE members
    SET membership_end_date = CURRENT_DATE - 1
    WHERE member_id = _member_id;

    RETURN 'Success: Membership for ' || _name || ' revoked. Reason: ' || _reason;
END;
$$;

alter function revoke_membership(integer, integer, text) owner to root;

