create function schedule_class(_gym_id integer, _room_id integer, _trainer_id integer, _title character varying, _start_time timestamp without time zone, _duration_minutes integer) returns text
    language plpgsql
as
$$
DECLARE
    _end_time TIMESTAMP;
    _room_status VARCHAR;
BEGIN
    _end_time := _start_time + (_duration_minutes || ' minutes')::INTERVAL;

    SELECT status INTO _room_status FROM rooms WHERE room_id = _room_id;

    IF _room_status IS NULL THEN
        RETURN 'Error: Room ID ' || _room_id || ' not found.';
    END IF;

    IF _room_status != 'Available' THEN
        RETURN 'Error: Room is currently set to ' || _room_status || ' and cannot be booked.';
    END IF;

    IF EXISTS (
        SELECT 1 FROM classes
        WHERE room_id = _room_id
          AND (
                (start_time <= _start_time AND end_time > _start_time) OR
                (start_time < _end_time AND end_time >= _end_time) OR
                (start_time >= _start_time AND end_time <= _end_time)
          )
    ) THEN
        RETURN 'Error: This room is already booked during that time slot.';
    END IF;

    INSERT INTO classes (gym_id, room_id, trainer_id, title, start_time, end_time)
    VALUES (_gym_id, _room_id, _trainer_id, _title, _start_time, _end_time);

    RETURN 'Success: "' || _title || '" scheduled from ' || _start_time || ' to ' || _end_time;
END;
$$;

alter function schedule_class(integer, integer, integer, varchar, timestamp, integer) owner to root;

