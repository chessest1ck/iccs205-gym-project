create function submit_payment_proof(_gym_id integer, _plan_type_id integer, _amount numeric, _proof_ref character varying) returns text
    language plpgsql
as
$$
DECLARE
    _gym_name VARCHAR;
BEGIN
    SELECT name INTO _gym_name FROM gyms WHERE gym_id = _gym_id;

    IF _gym_name IS NULL THEN
        RETURN 'Error: Gym ID not found.';
    END IF;

    INSERT INTO system_payment_requests (gym_id, type_id, transfer_amount, proof_reference)
    VALUES (_gym_id, _plan_type_id, _amount, _proof_ref);

    RETURN 'Success: Payment proof submitted for ' || _gym_name || '. Please wait for Admin approval.';
END;
$$;

alter function submit_payment_proof(integer, integer, numeric, varchar) owner to root;

