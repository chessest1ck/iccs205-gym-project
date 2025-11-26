create function get_pending_payment_requests()
    returns TABLE(r_request_id integer, r_gym_name character varying, r_owner_name character varying, r_plan_name character varying, r_amount numeric, r_proof_ref character varying, r_date timestamp without time zone)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
    SELECT
        spr.request_id,
        g.name,
        go.full_name,
        sst.name,
        spr.transfer_amount,
        spr.proof_reference,
        spr.transfer_date
    FROM system_payment_requests spr
    JOIN gyms g ON spr.gym_id = g.gym_id
    JOIN gym_owners go ON g.owner_id = go.owner_id
    JOIN system_subscription_types sst ON spr.type_id = sst.type_id
    WHERE spr.status = 'Pending'
    ORDER BY spr.transfer_date ASC;
END;
$$;

alter function get_pending_payment_requests() owner to root;

