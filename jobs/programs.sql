-- ** BIG LOTTO ** --
BEGIN
DBMS_SCHEDULER.create_program (
    program_name   => 'big_lotto',
    program_type   => 'PLSQL_BLOCK',
    program_action  =>  
q'[
DECLARE
    v_count     NUMBER;
    v_l         NUMBER;
    v_no        NUMBER; 
    v_game_id   NUMBER;
BEGIN 
    v_count := 0;
    v_l     := 1;
    v_no    := TRUNC(dbms_random.value(1,49)); 
	
    SELECT game_id INTO v_game_id FROM games WHERE
    TRIM(UPPER(game_name)) = 'BIG LOTTO';
    LOOP
        BEGIN
            IF v_count = 0 THEN
            INSERT INTO results VALUES (v_game_id, sysdate, v_no ); 
            v_l := v_l +1;
            
            ELSIF v_count >= 1 THEN
                v_no  := TRUNC(dbms_random.value(1,49));        
            END IF;  
            
            SELECT COUNT(draw_no) INTO v_count FROM results 
            WHERE TO_CHAR(draw_date,'yymmdd')= TO_CHAR(sysdate,'yymmdd')
            AND draw_no = v_no;   

        EXCEPTION WHEN NO_DATA_FOUND THEN 
            v_count := 0;
        END;
  --  DBMS_OUTPUT.PUT_LINE(v_no);
        EXIT WHEN v_l > 6;
    END LOOP; 
END;
]',
    enabled => TRUE,
    comments => 'rolling numbers for big lotto'
);
END;
/

-- ** EXPRESS LOTTO ** --
BEGIN
DBMS_SCHEDULER.create_program (
    program_name   => 'express_lotto',
    program_type   => 'PLSQL_BLOCK',
    program_action  =>  
q'[
DECLARE
    v_count     NUMBER; -- value to checking number
    v_l         NUMBER;  -- rolling limit counter
    v_no        NUMBER; --random value with range
    v_game_id   NUMBER;
BEGIN
    v_count := 0; 
    v_l     := 1;  
    v_no    := TRUNC(dbms_random.value(1,42));
    SELECT game_id INTO v_game_id FROM games WHERE
    TRIM(UPPER(game_name)) = 'EXPRESS LOTTO';
    LOOP -- rolling loop
        BEGIN            
            IF v_count = 0 THEN -- if false then insert and l_v increment
            INSERT INTO results VALUES (v_game_id, sysdate, v_no ); 
            v_l := v_l +1;
            
            -- if true then roll again
            ELSIF v_count >= 1 THEN
                v_no  := TRUNC(dbms_random.value(1,42));        
            END IF;  
            
            -- Checking rolled number
            SELECT COUNT(draw_no) INTO v_count FROM results 
            WHERE TO_CHAR(draw_date,'yymmdd') = TO_CHAR(sysdate,'yymmdd')
            AND draw_no = v_no;   

        EXCEPTION WHEN NO_DATA_FOUND THEN -- when no found then false
            v_count := 0;
        END;
  --  DBMS_OUTPUT.PUT_LINE(v_no);
        EXIT WHEN v_l > 5; 
    END LOOP; 
END;
]',
    enabled => TRUE,
    comments => 'rolling numbers for express lotto'
);
END;
/

-- ** BIG LOTTO ROLLOVER ** --

BEGIN

DBMS_SCHEDULER.create_program (
    program_name   => 'big_lotto_rollover',
    program_type   => 'PLSQL_BLOCK',
    program_action  =>  
q'[
DECLARE
v_counter       NUMBER;
v_amount        NUMBER;
v_game_id       NUMBER;
BEGIN
    SELECT game_id INTO v_game_id FROM games WHERE
    TRIM(UPPER(game_name)) = 'BIG LOTTO';
    
	-- Create archive record of cumulation amount
    INSERT INTO rollovers_archive SELECT * FROM rollovers
    WHERE game_id = v_game_id;
	
    -- subtrack wining amount 3-5 correct numbers CUMULATIVE_AMOUNT
    SELECT cumulative_amount - nth_winners_sum(2,v_game_id) INTO v_amount 
    FROM rollovers 
    WHERE game_id = v_game_id;  
    -- Check is any or how many rolled 6 correct numbers
    SELECT COUNT(correct_no) INTO v_counter
    FROM matched_winners mw
    JOIN rollovers r
    ON r.game_id = mw.game_id
    AND TO_CHAR(r.rollover_day, 'YYMMDD') = TO_CHAR(mw.draw_date , 'YYMMDD')
    WHERE r.game_id = v_game_id AND mw.correct_no = 6; 
	
    -- MAXIMUM CUMULATION return when nobody rolled 6 correct numbers
    IF v_amount > 100000000 AND v_counter = 0 THEN
        UPDATE ROLLOVERS SET  rollover_day = sysdate
		, CUMULATIVE_AMOUNT = CUMULATIVE_AMOUNT - nth_winners_sum(2,v_game_id)
        WHERE game_id = v_game_id;	
        RETURN;
    END IF;      

    IF v_counter = 0 THEN 
         -- UPDATE rollovers when nobody rolled 6 correct numbers
        UPDATE ROLLOVERS SET  rollover_day = sysdate,
        CUMULATIVE_AMOUNT = CUMULATIVE_AMOUNT + v_amount
        WHERE game_id = v_game_id;

    -- Winners
    ELSIF v_counter > 0 THEN 
        -- Records to lucky_winners TABLE
        INSERT INTO lucky_winners (coupon_id, winned_amount)
        SELECT mw.coupon_id,  ROUND(v_amount/ v_counter, 2) FROM matched_winners mw
        JOIN rollovers r
        ON r.game_id = mw.game_id
        AND TO_CHAR(r.rollover_day, 'YYMMDD') = TO_CHAR(mw.draw_date , 'YYMMDD')
        WHERE mw.game_id = v_game_id AND mw.correct_no = 6; 

        -- Reset cumulative amount to default value
        UPDATE ROLLOVERS SET  rollover_day = sysdate,
        CUMULATIVE_AMOUNT = (SELECT AMOUNT_TO_WIN FROM games where game_id = v_game_id)
        where game_id = v_game_id;        
    END IF;
END;
]',
    enabled => TRUE,
    comments => 'Creating rollovers_acrhive record. Checking rolled numbers and update rollovers amount. 
    Reset cumulative amount to default value if is there any lucky winner.'
);
END;
/

-- ** EXPRESS LOTTO ROLLOVER ** --
BEGIN

DBMS_SCHEDULER.create_program (
    program_name   => 'express_lotto_rollover',
    program_type   => 'PLSQL_BLOCK',
    program_action  =>  
q'[
DECLARE
v_counter       NUMBER; -- value to get how many is max winners 
v_amount        NUMBER; -- value to get sum winners amount without jackpot
v_game_id 		NUMBER; 
BEGIN
	SELECT game_id INTO v_game_id FROM games WHERE
    TRIM(UPPER(game_name)) = 'EXPRESS LOTTO';

    -- subtrack wining amount 3-4 correct numbers CUMULATIVE_AMOUNT
    SELECT cumulative_amount - nth_winners_sum(2,v_game_id) INTO v_amount 
    FROM rollovers 
    WHERE game_id = v_game_id;  
    
    -- Check is any or how many rolled 5 correct numbers
    SELECT COUNT(correct_no) INTO v_counter
    FROM matched_winners mw
    JOIN rollovers r
    ON r.game_id = mw.game_id
    AND TO_CHAR(r.rollover_day, 'YYMMDD') = TO_CHAR(mw.draw_date , 'YYMMDD')
    WHERE r.game_id = v_game_id AND mw.correct_no = 5;   

    -- Winners
    IF v_counter > 0 THEN 
        -- Records to lucky_winners TABLE
        INSERT INTO lucky_winners (coupon_id, winned_amount)
        SELECT mw.coupon_id,  ROUND(v_amount/ v_counter, 2) FROM matched_winners mw
        JOIN rollovers r
        ON r.game_id = mw.game_id
        AND TO_CHAR(r.rollover_day, 'YYMMDD') = TO_CHAR(mw.draw_date , 'YYMMDD')
        WHERE mw.game_id = v_game_id AND mw.correct_no = 5; 

    END IF;
    -- Reset cumulative amount to default value
    UPDATE ROLLOVERS SET  rollover_day = sysdate,
    CUMULATIVE_AMOUNT = (SELECT AMOUNT_TO_WIN FROM games where game_id = v_game_id)
	WHERE game_id = v_game_id;

EXCEPTION WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Nobody has won');
UPDATE ROLLOVERS SET  rollover_day = sysdate,
CUMULATIVE_AMOUNT = (SELECT AMOUNT_TO_WIN FROM games where game_id = v_game_id)
WHERE game_id = v_game_id;

END;
]',
    enabled => TRUE,
    comments => 'Creating rollovers_acrhive record. Checking rolled numbers and update rollovers amount. 
    Reset cumulative amount to default value if is there any lucky winner.'
);
END;
/

-- ** RANDOM COUPONS SCRIPT ** --
BEGIN
DBMS_SCHEDULER.create_program (
    program_name        => 'at_random_script',
    program_type        => 'PLSQL_BLOCK',
    program_action      => q'[
BEGIN
    FOR i IN 1..5000
    LOOP
           at_random_coupons_pkg.big_lotto_at_random();
         at_random_coupons_pkg.express_lotto_at_random();
    END LOOP;
END;    
]',
    enabled => TRUE,  
	comments => 'script running at random procedures for rolling example coupons'

);
END;
/



