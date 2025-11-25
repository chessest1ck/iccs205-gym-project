create function terminate_trainer(_gym_id integer, _trainer_id integer) returns text
    language plpgsql
as
$$
DECLARE
    _name VARCHAR;
BEGIN
    SELECT full_name INTO _name
    FROM trainers
    WHERE trainer_id = _trainer_id AND gym_id = _gym_id;

    IF _name IS NULL THEN
        RETURN 'Error: Trainer not found.';
    END IF;

    UPDATE trainers
    SET status = 'Terminated'
    WHERE trainer_id = _trainer_id;

    RETURN 'Success: Trainer ' || _name || ' is now removed.';
END;
$$;

alter function terminate_trainer(integer, integer) owner to root;

