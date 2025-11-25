create function check_overdue_subscriptions()
    returns TABLE(gym_name character varying, expired_on date)
    language plpgsql
as
$$
BEGIN
    UPDATE gyms
    SET subscription_status = 'Suspended'
    WHERE subscription_end_date < CURRENT_DATE
      AND subscription_status = 'Active';

    RETURN QUERY
    SELECT name, subscription_end_date
    FROM gyms
    WHERE subscription_status = 'Suspended';
END;
$$;

alter function check_overdue_subscriptions() owner to root;

