BEGIN

DBMS_SCHEDULER.create_schedule (
    schedule_name   => 'numbers_rolling',
    start_date      => sysdate,
    repeat_interval => 'freq=daily; byhour=19; byminute=0; bysecond =0',
    end_date        => null,
    comments        => 'daily lotto numbers rolling'
);
END;
/

BEGIN

DBMS_SCHEDULER.create_schedule (
    schedule_name   => 'lotto_rollovers',
    start_date      => sysdate,
    repeat_interval => 'freq=daily; byhour=19; byminute=01; bysecond =0',
    end_date        => null,
    comments        => 'daily lotto rollovers'
);
END;
/

BEGIN
DBMS_SCHEDULER.CREATE_SCHEDULE (
    schedule_name  => 'at_random_coupons',
    repeat_interval  => 'freq=hourly; INTERVAL=4',     
    start_date => sysdate,
    comments => 'for random coupon rolling numbers script'
);
END;
/


