create function check_overdue_subscriptions()
    returns TABLE(owner_name character varying, gyms_suspended integer)
    language plpgsql
as
$$
DECLARE
    _owner RECORD;
BEGIN
    FOR _owner IN
        SELECT DISTINCT owner_id
        FROM system_payments
        GROUP BY owner_id
        HAVING MAX(period_end) < CURRENT_DATE
    LOOP
        UPDATE gyms
        SET subscription_status = 'Suspended'
        WHERE owner_id = _owner.owner_id
          AND subscription_status = 'Active';
    END LOOP;

    RETURN QUERY
    SELECT go.full_name, COUNT(g.gym_id)::INT
    FROM gym_owners go
    JOIN gyms g ON go.owner_id = g.owner_id
    WHERE g.subscription_status = 'Suspended'
    GROUP BY go.full_name;
END;
$$;

alter function check_overdue_subscriptions() owner to root;

