create function log_progress(_member_id integer, _weight numeric, _body_fat numeric) returns text
    language plpgsql
as
$$
DECLARE
    _member_name VARCHAR;
BEGIN
    SELECT full_name INTO _member_name FROM members WHERE member_id = _member_id;

    IF _member_name IS NULL THEN
        RETURN 'Error: Member ID ' || _member_id || ' does not exist.';
    END IF;

    INSERT INTO progress_logs (member_id, log_date, weight_kg, body_fat_percent)
    VALUES (_member_id, CURRENT_DATE, _weight, _body_fat)
    ON CONFLICT (member_id, log_date)
    DO UPDATE SET
        weight_kg = EXCLUDED.weight_kg,
        body_fat_percent = EXCLUDED.body_fat_percent;

    RETURN 'Success: Progress for ' || _member_name || ' updated for today.';
END;
$$;

alter function log_progress(integer, numeric, numeric) owner to root;

