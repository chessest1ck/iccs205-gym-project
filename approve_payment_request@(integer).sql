create function approve_payment_request(_request_id integer) returns text
    language plpgsql
as
$$
DECLARE
    _gym_id INT;
    _type_id INT;
    _status VARCHAR;
    _result_msg TEXT;
BEGIN
    SELECT gym_id, type_id, status
    INTO _gym_id, _type_id, _status
    FROM system_payment_requests
    WHERE request_id = _request_id;

    IF _gym_id IS NULL THEN
        RETURN 'Error: Request ID not found.';
    END IF;

    IF _status = 'Approved' THEN
        RETURN 'Error: This request is already approved.';
    END IF;

    SELECT make_system_payment(_gym_id, _type_id) INTO _result_msg;

    UPDATE system_payment_requests
    SET status = 'Approved'
    WHERE request_id = _request_id;

    RETURN 'Approved: ' || _result_msg;
END;
$$;

alter function approve_payment_request(integer) owner to root;

