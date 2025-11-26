create function get_gym_membership_types(_gym_id integer)
    returns TABLE(r_type_id integer, r_name character varying, r_price numeric, r_duration_days integer)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
    SELECT
        type_id,
        name,
        price,
        duration_days
    FROM membership_types
    WHERE gym_id = _gym_id
    ORDER BY price ASC;
END;
$$;

alter function get_gym_membership_types(integer) owner to root;

