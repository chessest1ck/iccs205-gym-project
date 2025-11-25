create function make_system_payment(_gym_id integer, _plan_type_id integer) returns text
    language plpgsql
as
$$
DECLARE
    _payment_id INTEGER;
    _owner_id INTEGER;
    _amount DECIMAL(10, 2);
    _months INT;
    _start_date DATE := CURRENT_DATE;
    _end_date DATE;
    _plan_name VARCHAR;
BEGIN
    SELECT owner_id INTO _owner_id FROM gyms WHERE gym_id = _gym_id;

    IF _owner_id IS NULL THEN
        RETURN 'Error: Gym ID ' || _gym_id || ' not found.';
    END IF;

    SELECT price, duration_months, name
    INTO _amount, _months, _plan_name
    FROM system_subscription_types
    WHERE type_id = _plan_type_id;

    IF _amount IS NULL THEN
        RETURN 'Error: Subscription Plan ID ' || _plan_type_id || ' not found.';
    END IF;

    SELECT COALESCE(subscription_end_date, CURRENT_DATE)
    INTO _start_date
    FROM gyms
    WHERE gym_id = _gym_id;

    IF _start_date < CURRENT_DATE THEN
        _start_date := CURRENT_DATE;
    END IF;

    _end_date := _start_date + (_months || ' month')::INTERVAL;

    INSERT INTO system_payments (owner_id, gym_id, type_id, amount, status, period_start, period_end)
    VALUES (_owner_id, _gym_id, _plan_type_id, _amount, 'Paid', _start_date, _end_date)
    RETURNING system_payment_id INTO _payment_id;

    UPDATE gyms
    SET subscription_status = 'Active',
        subscription_end_date = _end_date
    WHERE gym_id = _gym_id;

    RETURN 'Success: "' || _plan_name || '" purchased for Gym ID ' || _gym_id || '. Valid until ' || _end_date;
END;
$$;

alter function make_system_payment(integer, integer) owner to root;

