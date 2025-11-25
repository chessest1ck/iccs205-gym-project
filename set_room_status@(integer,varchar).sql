create function set_room_status(_room_id integer, _new_status character varying) returns text
    language plpgsql
as
$$
DECLARE
    _room_name VARCHAR;
BEGIN
    SELECT name INTO _room_name FROM rooms WHERE room_id = _room_id;

    IF _room_name IS NULL THEN
        RETURN 'Error: Room ID ' || _room_id || ' not found.';
    END IF;

    UPDATE rooms
    SET status = _new_status
    WHERE room_id = _room_id;

    RETURN 'Success: Room "' || _room_name || '" is now set to ' || _new_status;
END;
$$;

alter function set_room_status(integer, varchar) owner to root;

