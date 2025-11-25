create function login_trainer(_gym_id integer, _email character varying, _password_hash character varying)
    returns TABLE(r_trainer_id integer, r_full_name character varying, r_specialization character varying, r_status character varying)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
    SELECT
        trainer_id,
        full_name,
        specialization,
        status
    FROM trainers
    WHERE gym_id = _gym_id
      AND email = _email
      AND password_hash = _password_hash;
END;
$$;

alter function login_trainer(integer, varchar, varchar) owner to root;

