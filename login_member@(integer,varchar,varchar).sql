create function login_member(_gym_id integer, _email character varying, _password_hash character varying)
    returns TABLE(r_member_id integer, r_full_name character varying, r_status character varying)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
    SELECT
        member_id,
        full_name,
        CASE
            WHEN membership_end_date < CURRENT_DATE THEN 'Expired'
            ELSE 'Active'
        END::VARCHAR
    FROM members
    WHERE gym_id = _gym_id
      AND email = _email
      AND password_hash = _password_hash;
END;
$$;

alter function login_member(integer, varchar, varchar) owner to root;

