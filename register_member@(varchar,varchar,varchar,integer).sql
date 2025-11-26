create function register_member(_gym_id integer, _name character varying, _email character varying, _password_hash character varying, _phone character varying, _type_id integer) returns text
    language plpgsql
as
$$
BEGIN
    INSERT INTO members (gym_id, full_name, email, password_hash, phone, type_id, membership_end_date)
    VALUES (_gym_id, _name, _email, _password_hash, _phone, _type_id, NULL);

    RETURN 'Success: Account created for ' || _name || '. Please make a payment to activate membership.';
END;
$$;

alter function register_member(integer, varchar, varchar, varchar, varchar, integer) owner to root;

