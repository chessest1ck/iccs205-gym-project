create function login_gym_owner(_email character varying, _password_hash character varying)
    returns TABLE(r_owner_id integer, r_full_name character varying, r_email character varying, r_gym_count integer)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
    SELECT
        go.owner_id,
        go.full_name,
        go.email,
        (SELECT COUNT(*)::INT FROM gyms AS g WHERE g.owner_id = go.owner_id) AS gym_count
    FROM gym_owners AS go
    WHERE go.email = _email
      AND go.password_hash = _password_hash;
END;
$$;

alter function login_gym_owner(varchar, varchar) owner to root;

