create function get_gym_rooms(_gym_id integer)
    returns TABLE(r_room_id integer, r_name character varying, r_capacity integer, r_status character varying)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
    SELECT
        room_id,
        name,
        capacity,
        status
    FROM rooms
    WHERE gym_id = _gym_id
    ORDER BY room_id ASC;
END;
$$;

alter function get_gym_rooms(integer) owner to root;

