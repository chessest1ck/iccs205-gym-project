create function register_member(_name character varying, _email character varying, _phone character varying, _type_id integer) returns text
    language plpgsql
as
$$
DECLARE
    _duration INT;
    _end_date DATE;
BEGIN
    SELECT duration_days INTO _duration FROM membership_types WHERE type_id = _type_id;
    _end_date := CURRENT_DATE + _duration;

    INSERT INTO members (full_name, email, phone, type_id, membership_end_date)
    VALUES (_name, _email, _phone, _type_id, _end_date);
    RETURN 'Member registered successfully. Expires on: ' || _end_date;
END;
$$;

alter function register_member(varchar, varchar, varchar, integer) owner to root;

