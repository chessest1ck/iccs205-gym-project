create function get_owners_gyms(_owner_id integer)
    returns TABLE(r_gym_id integer, r_name character varying, r_location character varying, r_status character varying)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
    SELECT
        gym_id,
        name,
        location,
        subscription_status
    FROM gyms
    WHERE owner_id = _owner_id
    ORDER BY gym_id ASC;
END;
$$;

alter function get_owners_gyms(integer) owner to root;

