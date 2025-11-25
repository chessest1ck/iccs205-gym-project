create function register_member(_gym_id integer, _name character varying, _email character varying, _password_hash character varying, _phone character varying, _type_id integer) returns text
    language plpgsql
as
$$
DECLARE
    _duration INT;
    _end_date DATE;
BEGIN
    SELECT duration_days INTO _duration
    FROM membership_types
    WHERE type_id = _type_id AND gym_id = _gym_id;

    IF _duration IS NULL THEN
        RAISE EXCEPTION 'Invalid Membership Type ID % for Gym ID %', _type_id, _gym_id;
    END IF;

    _end_date := CURRENT_DATE + _duration;

    INSERT INTO members (gym_id, full_name, email, password_hash, phone, type_id, membership_end_date)
    VALUES (_gym_id, _name, _email, _password_hash, _phone, _type_id, _end_date);

    RETURN 'Member registered successfully. Expires on: ' || _end_date;
END;
$$;

alter function register_member(integer, varchar, varchar, varchar, varchar, integer) owner to root;

