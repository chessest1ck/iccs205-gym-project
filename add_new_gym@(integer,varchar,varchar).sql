create function add_new_gym(_owner_id integer, _gym_name character varying, _location character varying) returns text
    language plpgsql
as
$$
DECLARE
    _new_id INTEGER;
    _owner_exists BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM gym_owners WHERE owner_id = _owner_id) INTO _owner_exists;

    IF NOT _owner_exists THEN
        RETURN 'Error: Owner ID ' || _owner_id || ' does not exist.';
    END IF;

    INSERT INTO gyms (owner_id, name, location, subscription_status)
    VALUES (_owner_id, _gym_name, _location, 'Active')
    RETURNING gym_id INTO _new_id;

    RETURN 'Success: "' || _gym_name || '" created with Gym ID: ' || _new_id;
END;
$$;

alter function add_new_gym(integer, varchar, varchar) owner to root;

