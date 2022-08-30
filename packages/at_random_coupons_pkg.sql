create or replace PACKAGE at_random_coupons_pkg IS   

TYPE rolled_no IS TABLE OF NUMBER INDEX BY PLS_INTEGER;

PROCEDURE big_lotto_at_random;

PROCEDURE express_lotto_at_random;

END at_random_coupons_pkg;
/

create or replace PACKAGE BODY at_random_coupons_pkg IS

TYPE rolled_no_table IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
PROCEDURE big_lotto_at_random IS
    -- array with unique values
    t_rolled_no rolled_no_table := rolled_no_table();
    v_loop_counter     NUMBER 		-- counter for a loop
    v_rolled_no        NUMBER 		-- random rolled number for coupons_numbers table
    v_flag             BOOLEAN;     -- flag for checking unique values in array
    v_coupon_id        NUMBER;      -- coupon_id for coupons table
    v_game_id          NUMBER;      -- game_id for coupons_table
BEGIN 
	v_loop_counter  := 1; -- counter for a loop
    v_rolled_no   	:= TRUNC(dbms_random.value(1,49));
-- get game_id
    SELECT game_id INTO v_game_id FROM games WHERE
    TRIM(UPPER(game_name)) = 'BIG LOTTO';
-- add first number
    t_rolled_no(1) := v_rolled_no;
    -- DBMS_OUTPUT.PUT_LINE(v_rolled_no ||' '|| v_loop_counter );  
    -- get coupon_id and add first record
    v_coupon_id  := CONCAT(TO_NUMBER(TO_CHAR(sysdate, 'YYMMDD')),coupons_id_seq.nextval);
    INSERT INTO COUPONS (COUPON_ID, COUPON_DATE, GAME_ID) VALUES (v_coupon_id,sysdate, v_game_id);  
    
    LOOP 
		-- loop to check if number was rolled
        FOR i IN  t_rolled_no.first..t_rolled_no.last
        LOOP  
            IF  v_rolled_no IN (t_rolled_no(i)) THEN            
                v_flag := TRUE; -- if is change flage to true
            END IF;
        END LOOP; 

        IF v_flag = FALSE THEN -- if not add number to array and increase loop_vounter value
            t_rolled_no(v_loop_counter) :=  v_rolled_no; 
            -- add next record if number is unique
            INSERT INTO COUPONS_numbers(COUPON_ID, COUPON_NO) VALUES (v_coupon_id , t_rolled_no(v_loop_counter) );
            -- increase loop counter
            v_loop_counter  := v_loop_counter   +1;
         --   DBMS_OUTPUT.PUT_LINE(v_rolled_no ||' '|| v_loop_counter );  
        ELSE  
            v_flag := FALSE; -- if is change flage to false and roll new number
            v_rolled_no  := TRUNC(dbms_random.value(1,49));      
        END IF;        
    EXIT WHEN v_loop_counter > 6;
    END LOOP; 

END big_lotto_at_random;

PROCEDURE express_lotto_at_random IS
        -- array with unique values
    t_rolled_no rolled_no_table := rolled_no_table();
    v_loop_counter     NUMBER := 1; -- counter for a loop
    v_rolled_no        NUMBER := TRUNC(dbms_random.value(1,42)); -- random rolled number for coupons_numbers table
    v_flag             BOOLEAN;     -- flag for checking unique values in array
    v_coupon_id        NUMBER;      -- coupon_id for coupons table
    v_game_id          NUMBER;      -- game_id for coupons_table
BEGIN
	v_loop_counter  := 1; -- counter for a loop
	v_rolled_no     := TRUNC(dbms_random.value(1,42));
	SELECT game_id INTO v_game_id FROM games WHERE
	TRIM(UPPER(game_name)) = 'EXPRESS LOTTO';
-- add first number
    t_rolled_no(1) := v_rolled_no;
    -- DBMS_OUTPUT.PUT_LINE(v_rolled_no ||' '|| v_loop_counter );  
    -- get coupon_id and add first record
    v_coupon_id  := CONCAT(TO_NUMBER(TO_CHAR(sysdate, 'YYMMDD')),coupons_id_seq.nextval);
    INSERT INTO COUPONS (COUPON_ID, COUPON_DATE, GAME_ID) VALUES (v_coupon_id,sysdate, v_game_id);    

    LOOP 
		-- loop to check if number was rolled
        FOR i IN  t_rolled_no.first..t_rolled_no.last
        LOOP  
            IF  v_rolled_no IN (t_rolled_no(i)) THEN            
                v_flag := TRUE; -- if is change flage to true
            END IF;
        END LOOP; 

        IF v_flag = FALSE THEN -- if not add number to array and increase loop_vounter value
            t_rolled_no(v_loop_counter) :=  v_rolled_no; 
            -- add next record if number is unique
            INSERT INTO COUPONS_numbers(COUPON_ID, COUPON_NO) VALUES (v_coupon_id , t_rolled_no(v_loop_counter) );
            -- increase loop counter
            v_loop_counter  := v_loop_counter   +1;

         --   DBMS_OUTPUT.PUT_LINE(v_rolled_no ||' '|| v_loop_counter );  
        ELSE  
            v_flag := FALSE; -- if is change flage to false and roll new number
            v_rolled_no  := TRUNC(dbms_random.value(1,42));      
        END IF;         

        EXIT WHEN v_loop_counter > 5;
    END LOOP;

END express_lotto_at_random;

END at_random_coupons_pkg;