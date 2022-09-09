BEGIN
DBMS_SCHEDULER.create_job (
    job_name        => 'big_lotto_job',
    program_name    => 'big_lotto',
    schedule_name   => 'numbers_rolling',
    enabled         => TRUE,
    comments        => 'job for daily big lotto draw numbers at 7PM'
);

END;
/

BEGIN
DBMS_SCHEDULER.create_job (
    job_name        => 'express_lotto_job',
    program_name    => 'express_lotto',
    schedule_name   => 'numbers_rolling',
    enabled         => TRUE,
    comments        => 'job for daily express lotto draw numbers at 7PM'
);

END;
/

BEGIN
DBMS_SCHEDULER.create_job (
    job_name        => 'big_lotto_rollover_job',
    program_name    => 'big_lotto_rollover',
    schedule_name   => 'lotto_rollovers',
    enabled         => TRUE,
    comments        => 'job for daily big lotto matching winners'
);

END;
/

BEGIN
DBMS_SCHEDULER.create_job (
    job_name        => 'express_lotto_rollover_job',
    program_name    => 'express_lotto_rollover',
    schedule_name   => 'lotto_rollovers',
    enabled         => TRUE,
    comments        => 'job for daily express lotto matching winners'
);

END;
/

BEGIN
DBMS_SCHEDULER.create_job (
    job_name        => 'at_random_coupons_job',
    program_name    => 'AT_RANDOM_SCRIPT',
    schedule_name   => 'AT_RANDOM_COUPONS',
    enabled         => TRUE,
    comments        => 'job for draw example coupons every 8 hours'
);

END;
/

BEGIN
DBMS_SCHEDULER.create_job (
    job_name        => 'reset_budget_job',
    program_name    => 'reset_budget',
    schedule_name   => 'numbers_rolling',
    enabled         => TRUE,
    comments        => 'reset budget each day after drew numbers'
);
END;
/