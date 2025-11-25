create function login_gym_owner(_email character varying, _password_hash character varying)
    returns TABLE(r_owner_id integer, r_full_name character varying, r_email character varying)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
    SELECT
        owner_id,
        full_name,
        email
    FROM gym_owners
    WHERE email = _email
      AND password_hash = _password_hash;
END;
$$;

alter function login_gym_owner(varchar, varchar) owner to root;

