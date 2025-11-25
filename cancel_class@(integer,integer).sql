create function cancel_class(_gym_id integer, _class_id integer) returns text
    language plpgsql
as
$$
DECLARE
    _title VARCHAR;
    _start_time TIMESTAMP;
BEGIN
    SELECT title, start_time INTO _title, _start_time
    FROM classes
    WHERE class_id = _class_id AND gym_id = _gym_id;

    IF _title IS NULL THEN
        RETURN 'Error: Class not found.';
    END IF;

    IF _start_time < CURRENT_TIMESTAMP THEN
        RETURN 'Error: Cannot cancel a class that has already started/finished.';
    END IF;

    DELETE FROM classes WHERE class_id = _class_id;

    RETURN 'Success: Class "' || _title || '" has been cancelled.';
END;
$$;

alter function cancel_class(integer, integer) owner to root;

