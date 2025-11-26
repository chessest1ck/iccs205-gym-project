create function get_pending_trainers(_owner_id integer)
    returns TABLE(gym_name character varying, trainer_id integer, trainer_name character varying, specialization character varying, applied_date timestamp without time zone)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
    SELECT
        g.name,
        t.trainer_id,
        t.full_name,
        t.specialization,
        CURRENT_TIMESTAMP
    FROM trainers t
    JOIN gyms g ON t.gym_id = g.gym_id
    WHERE g.owner_id = _owner_id
      AND t.status = 'Pending';
END;
$$;

alter function get_pending_trainers(integer) owner to root;

