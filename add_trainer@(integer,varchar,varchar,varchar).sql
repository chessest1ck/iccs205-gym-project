create function add_trainer(_gym_id integer, _full_name character varying, _email character varying, _password_hash character varying, _specialization character varying, _phone character varying) returns text
    language plpgsql
as
$$
DECLARE
    _new_id INTEGER;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM gyms WHERE gym_id = _gym_id) THEN
        RETURN 'Error: Gym ID ' || _gym_id || ' not found.';
    END IF;

    IF EXISTS (SELECT 1 FROM trainers WHERE gym_id = _gym_id AND email = _email) THEN
        RETURN 'Error: Trainer email ' || _email || ' already exists in this gym.';
    END IF;

    INSERT INTO trainers (gym_id, full_name, email, password_hash, specialization, phone, status)
    VALUES (_gym_id, _full_name, _email, _password_hash, _specialization, _phone, 'Active')
    RETURNING trainer_id INTO _new_id;

    RETURN 'Success: Trainer "' || _full_name || '" added (ID: ' || _new_id || ')';
END;
$$;

alter function add_trainer(integer, varchar, varchar, varchar, varchar, varchar) owner to root;

