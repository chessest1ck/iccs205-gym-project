create function get_gym_schedule(_gym_id integer, _start_date timestamp without time zone, _end_date timestamp without time zone)
    returns TABLE(r_class_id integer, r_title character varying, r_start_time timestamp without time zone, r_end_time timestamp without time zone, r_trainer_name character varying, r_room_name character varying, r_max_capacity integer)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
    SELECT
        c.class_id,
        c.title,
        c.start_time,
        c.end_time,
        t.full_name AS trainer_name,
        r.name AS room_name,
        c.max_capacity
    FROM classes c
    JOIN trainers t ON c.trainer_id = t.trainer_id
    JOIN rooms r ON c.room_id = r.room_id
    WHERE c.gym_id = _gym_id
      AND c.start_time >= _start_date
      AND c.start_time <= _end_date
    ORDER BY c.start_time ASC;
END;
$$;

alter function get_gym_schedule(integer, timestamp, timestamp) owner to root;

