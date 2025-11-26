create function approve_trainer(_owner_id integer, _trainer_id integer) returns text
    language plpgsql
as
$$
DECLARE
    _trainer_name VARCHAR;
    _gym_owner_id INTEGER;
BEGIN
    SELECT t.full_name, g.owner_id 
    INTO _trainer_name, _gym_owner_id
    FROM trainers t
    JOIN gyms g ON t.gym_id = g.gym_id
    WHERE t.trainer_id = _trainer_id;

    IF _trainer_name IS NULL THEN
        RETURN 'Error: Trainer ID not found.';
    END IF;

    IF _gym_owner_id != _owner_id THEN
        RETURN 'Error: You do not have permission to approve staff for this gym.';
    END IF;

    UPDATE trainers
    SET status = 'Active'
    WHERE trainer_id = _trainer_id;

    RETURN 'Success: Trainer ' || _trainer_name || ' is now ACTIVE and can log in.';
END;
$$;

alter function approve_trainer(integer, integer) owner to root;

