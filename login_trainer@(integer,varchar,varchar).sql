create function login_trainer(_gym_id integer, _email character varying, _password_hash character varying)
    returns TABLE(r_trainer_id integer, r_full_name character varying, r_status character varying, r_message text)
    language plpgsql
as
$$
DECLARE
    _status VARCHAR;
    _id INT;
    _name VARCHAR;
BEGIN
    SELECT trainer_id, full_name, status
    INTO _id, _name, _status
    FROM trainers
    WHERE gym_id = _gym_id
      AND email = _email
      AND password_hash = _password_hash;

    IF _id IS NULL THEN
        RETURN QUERY SELECT NULL::INT, NULL::VARCHAR, NULL::VARCHAR, 'Login Failed: Invalid credentials'::TEXT;

    ELSIF _status = 'Pending' THEN
        RETURN QUERY SELECT _id, _name, _status, 'Login Failed: Account is pending approval'::TEXT;

    ELSIF _status = 'Terminated' THEN
        RETURN QUERY SELECT _id, _name, _status, 'Login Failed: Access revoked'::TEXT;

    ELSE
        RETURN QUERY SELECT _id, _name, _status, 'Success'::TEXT;
    END IF;
END;
$$;

alter function login_trainer(integer, varchar, varchar) owner to root;

