create function register_trainer(_gym_id integer, _full_name character varying, _email character varying, _password_hash character varying, _specialization character varying, _phone character varying) returns text
    language plpgsql
as
$$
DECLARE
    _gym_name VARCHAR;
BEGIN
    SELECT name INTO _gym_name FROM gyms WHERE gym_id = _gym_id;

    IF _gym_name IS NULL THEN
        RETURN 'Error: Gym ID ' || _gym_id || ' not found.';
    END IF;

    IF EXISTS (SELECT 1 FROM trainers WHERE gym_id = _gym_id AND email = _email) THEN
        RETURN 'Error: Email already registered at this gym.';
    END IF;

    INSERT INTO trainers (gym_id, full_name, email, password_hash, specialization, phone, status)
    VALUES (_gym_id, _full_name, _email, _password_hash, _specialization, _phone, 'Pending'); -- <--- PENDING

    RETURN 'Success: Application sent to ' || _gym_name || '. Please wait for Owner approval.';
END;
$$;

alter function register_trainer(integer, varchar, varchar, varchar, varchar, varchar) owner to root;

