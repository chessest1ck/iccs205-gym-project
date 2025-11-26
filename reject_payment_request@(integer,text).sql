create function reject_payment_request(_request_id integer, _reason text) returns text
    language plpgsql
as
$$
DECLARE
    _gym_id INT;
    _status VARCHAR;
BEGIN
    SELECT gym_id, status
    INTO _gym_id, _status
    FROM system_payment_requests
    WHERE request_id = _request_id;

    IF _gym_id IS NULL THEN
        RETURN 'Error: Request ID not found.';
    END IF;

    IF _status != 'Pending' THEN
        RETURN 'Error: Cannot reject. Status is already ' || _status;
    END IF;

    UPDATE system_payment_requests
    SET status = 'Rejected',
        admin_note = _reason
    WHERE request_id = _request_id;

    RETURN 'Success: Request #' || _request_id || ' rejected. Reason: ' || _reason;
END;
$$;

alter function reject_payment_request(integer, text) owner to root;

