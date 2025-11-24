create function complete_payment_and_renew(_payment_id integer) returns text
    language plpgsql
as
$$
DECLARE
    _member_id INT;
    _amount DECIMAL(10,2);
    _current_status VARCHAR;
BEGIN
    SELECT member_id, amount, payment_status
    INTO _member_id, _amount, _current_status
    FROM payments
    WHERE payment_id = _payment_id;

    IF _member_id IS NULL THEN
        RETURN 'Error: Payment ID ' || _payment_id || ' not found.';
    END IF;

    IF _current_status = 'Paid' THEN
        RETURN 'Error: This payment has already been processed.';
    END IF;

    IF _current_status != 'Pending' THEN
        RETURN 'Error: Payment status is ' || _current_status || '. Cannot process.';
    END IF;

    UPDATE payments
    SET payment_status = 'Paid'
    WHERE payment_id = _payment_id;

    PERFORM renew_membership(_member_id);

    RETURN 'Success: Payment verified ($' || _amount || ') and membership extended.';
END;
$$;

alter function complete_payment_and_renew(integer) owner to root;

