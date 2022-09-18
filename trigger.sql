CREATE OR REPLACE TRIGGER budget_tr
BEFORE INSERT ON coupons FOR EACH ROW 

DECLARE
   v_price NUMBER;

BEGIN   
    SELECT g.coupon_price INTO v_price FROM games g
    JOIN coupons c
    ON g.game_id = c.game_id
    WHERE c.coupon_id = :NEW.coupon_id;
    
   UPDATE budget SET coupon_quota = coupon_cuota - v_price;

END;
/