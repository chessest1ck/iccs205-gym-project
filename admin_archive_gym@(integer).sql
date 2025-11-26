create function admin_archive_gym(_gym_id integer) returns text
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

    UPDATE gyms
    SET subscription_status = 'Archived',
        subscription_end_date = CURRENT_DATE - 1
    WHERE gym_id = _gym_id;

    RETURN 'Success: "' || _gym_name || '" has been archived by System Admin.';
END;
$$;

alter function admin_archive_gym(integer) owner to root;

