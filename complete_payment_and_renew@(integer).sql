create function complete_payment_and_renew(_payment_id integer) returns text
    language plpgsql
as
$$
DECLARE
    _member_id INT;
BEGIN
    SELECT member_id
    INTO _member_id
    FROM payments
    WHERE payment_id = _payment_id
      AND payment_status = 'success';

    IF _member_id IS NULL THEN
        RETURN 'Error: Payment not completed.';
    END IF;
    RETURN renew_membership(_member_id);
END;
$$;

alter function complete_payment_and_renew(integer) owner to root;

