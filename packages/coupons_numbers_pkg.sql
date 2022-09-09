create or replace PACKAGE coupons_numbers_pkg IS    
   TYPE numbers_array IS TABLE OF NUMBER;

   PROCEDURE coupon_numbers (p_number numbers_array,  p_game_id NUMBER );  

/*
-- Example PL/SQL BLOCK
SET SERVEROUTPUT ON
DECLARE
t_number coupons_numbers_pkg.numbers_array;
BEGIN
t_number := coupons_numbers_pkg.numbers_array(1,2,3,4,5,6); -- Numbers for coupon
coupons_numbers_pkg.coupon_numbers (t_number, p_game_id => 10);
END;
/
*/ 
   

END coupons_numbers_pkg;
/

create or replace PACKAGE BODY coupons_numbers_pkg IS  

PROCEDURE coupon_numbers (p_number numbers_array,   p_game_id NUMBER )   IS
    v_coupon_id 	NUMBER;
    v_count_id 		NUMBER;
    v_big_id		NUMBER;
	v_express_id	NUMBER;
    BEGIN
		SELECT game_id INTO v_big_id FROM games WHERE
		TRIM(UPPER(game_name)) = 'BIG LOTTO';
		SELECT game_id INTO v_express_id FROM games WHERE
		TRIM(UPPER(game_name)) = 'EXPRESS LOTTO';
        v_coupon_id := CONCAT(TO_NUMBER(TO_CHAR(sysdate, 'YYMMDD')),coupons_id_seq.nextval);
        INSERT INTO coupons (coupon_id, coupon_date,game_id) 
        VALUES (  v_coupon_id, sysdate, p_game_id);                  

   IF p_game_id = v_big_id THEN
        FOR i IN p_number.first .. p_number.last
        LOOP   
            IF p_number(i) BETWEEN 1 AND 49 THEN
                INSERT INTO coupons_numbers (coupon_id, coupon_no)
                VALUES (v_coupon_id, p_number(i));             
            ELSE
                ROLLBACK;
                DBMS_OUTPUT.PUT_LINE('Wrong numbers');
                RETURN;
            END IF;
        END LOOP;
    ELSIF p_game_id = v_express_id THEN
        FOR i IN p_number.first .. p_number.last
        LOOP   
            IF p_number(i) BETWEEN 1 AND 42 THEN
                INSERT INTO coupons_numbers (coupon_id, coupon_no)
                VALUES (v_coupon_id, p_number(i)); 
            ELSE
                ROLLBACK;
                DBMS_OUTPUT.PUT_LINE('Wrong numbers');
                RETURN;
            END IF;
        END LOOP;
    ELSE    
        DBMS_OUTPUT.PUT_LINE('Wrong numbers');
        ROLLBACK;
        RETURN;
    END IF;

        SELECT COUNT(coupon_no) INTO v_count_id FROM coupons_numbers
        WHERE coupon_id = v_coupon_id GROUP BY coupon_id;

        IF p_game_id = v_big_id AND v_count_id = 6 THEN
            COMMIT;
        ELSIF p_game_id = v_express_id AND v_count_id = 5 THEN
            COMMIT;
        ELSE
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Wrong numbers');
            RETURN;
        END IF;       
    END;

END coupons_numbers_pkg;