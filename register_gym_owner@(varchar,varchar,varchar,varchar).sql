create function register_gym_owner(_full_name character varying, _email character varying, _password_hash character varying, _phone character varying) returns text
    language plpgsql
as
$$
DECLARE
    _new_id INTEGER;
BEGIN
    IF EXISTS (SELECT 1 FROM gym_owners WHERE email = _email) THEN
        RETURN 'Error: Email ' || _email || ' is already registered.';
    END IF;

    INSERT INTO gym_owners (full_name, email, password_hash, phone)
    VALUES (_full_name, _email, _password_hash, _phone)
    RETURNING owner_id INTO _new_id;

    RETURN 'Success: Owner registered with ID: ' || _new_id;
END;
$$;

alter function register_gym_owner(varchar, varchar, varchar, varchar) owner to root;

