create function create_member_payment(_gym_id integer, _member_id integer, _payment_method character varying, _transaction_id character varying) returns text
    language plpgsql
as
$$
DECLARE
    _new_payment_id INTEGER;
    _member_gym_id INTEGER;
    _type_id INTEGER;
    _official_price DECIMAL(10, 2);
    _plan_name VARCHAR;
BEGIN
    SELECT gym_id, type_id
    INTO _member_gym_id, _type_id
    FROM members
    WHERE member_id = _member_id;

    IF _member_gym_id IS NULL THEN
        RETURN 'Error: Member ID ' || _member_id || ' not found.';
    END IF;

    IF _member_gym_id != _gym_id THEN
        RETURN 'Error: Member ' || _member_id || ' does not belong to Gym ' || _gym_id;
    END IF;

    IF _type_id IS NULL THEN
        RETURN 'Error: Member has no Membership Type assigned.';
    END IF;

    SELECT price, name
    INTO _official_price, _plan_name
    FROM membership_types
    WHERE type_id = _type_id;

    IF _official_price IS NULL THEN
        RETURN 'Error: Membership Type configuration missing.';
    END IF;

    INSERT INTO payments (
        member_id,
        amount,
        payment_method,
        gateway_transaction_id,
        payment_status,
        payment_date
    )
    VALUES (
        _member_id,
        _official_price,
        _payment_method,
        _transaction_id,
        'Pending',
        CURRENT_TIMESTAMP
    )
    RETURNING payment_id INTO _new_payment_id;

    RETURN 'Success: Payment #' || _new_payment_id || ' created for ' || _plan_name || ' ($' || _official_price || '). Status: Pending.';
END;
$$;

alter function create_member_payment(integer, integer, varchar, varchar) owner to root;

