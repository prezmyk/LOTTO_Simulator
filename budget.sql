CREATE TABLE budget (
budget_id NUMBER,
budget_amount NUMBER(8,2) NOT NULL, 
CONSTRAINT BUDGET_AMOUNT_CK CHECK (budget_amount > 0 ),
CONSTRAINT BUDGET_PK PRIMARY KEY (budget_id),
CONSTRAINT BUDGET_PK_CK CHECK (budget_id = 1 )
);

CREATE OR REPLACE TRIGGER budget_tr
BEFORE INSERT ON coupons
FOR EACH ROW 
WHEN (
USER <> 'LOTTO' )
DECLARE
   v_price NUMBER;
BEGIN   
    SELECT coupon_price INTO v_price FROM games WHERE game_id = :NEW.game_id;
    UPDATE budget SET budget_amount = budget_amount - v_price;    
END;
/

INSERT INTO budget VALUES (1,50);

COMMIT;


