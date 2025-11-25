create function get_gym_trainers(_gym_id integer)
    returns TABLE(r_trainer_id integer, r_full_name character varying, r_specialization character varying, r_phone character varying, r_status character varying)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
    SELECT
        trainer_id,
        full_name,
        specialization,
        phone,
        status
    FROM trainers
    WHERE gym_id = _gym_id
    ORDER BY full_name ASC;
END;
$$;

alter function get_gym_trainers(integer) owner to root;

