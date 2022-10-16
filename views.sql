CREATE OR REPLACE VIEW MATCHED_WINNERS AS
SELECT g.game_id, g.game_name, r.draw_date, c.coupon_date, c.coupon_id, COUNT(*) correct_no FROM results r
JOIN games g
ON r.game_id = g.game_id
JOIN coupons c
ON c.game_id = g.game_id
AND TO_CHAR(c.coupon_date,'YYMMDDHH24MISS') BETWEEN TO_CHAR(r.draw_date - (INTERVAL '1' DAY),'YYMMDDHH24MISS') 
AND TO_CHAR(r.draw_date ,'YYMMDDHH24MISS') 
JOIN coupons_numbers cn
ON c.coupon_id=cn.coupon_id
WHERE cn.coupon_no=r.draw_no
GROUP BY g.game_id, g.game_name, r.draw_date, c.coupon_id, c.coupon_date
HAVING COUNT(*) >= 3;


CREATE VIEW WINNERS_WITH_AMOUNT AS
SELECT mw.*,
    CASE 
        WHEN UPPER(mw.game_name) = 'BIG LOTTO' AND mw.correct_no = 3 THEN  20
        WHEN UPPER(mw.game_name) = 'BIG LOTTO' AND mw.correct_no = 4 THEN  500 
        WHEN UPPER(mw.game_name) = 'BIG LOTTO' AND mw.correct_no = 5 THEN  2000
        WHEN UPPER(mw.game_name) = 'BIG LOTTO' AND mw.correct_no = 6 THEN  NVL(lw.winned_amount,0)
        WHEN UPPER(mw.game_name) = 'EXPRESS LOTTO' AND mw.correct_no = 3 THEN  10
        WHEN UPPER(mw.game_name) = 'EXPRESS LOTTO' AND mw.correct_no = 4 THEN  1000
        WHEN UPPER(mw.game_name) = 'EXPRESS LOTTO' AND mw.correct_no = 5 THEN  NVL(lw.winned_amount,0)       
    END amount        
FROM MATCHED_WINNERS mw
LEFT JOIN lucky_winners lw
ON mw.coupon_id=lw.coupon_id
ORDER BY mw.draw_date DESC, mw.coupon_id ASC, mw.correct_no DESC;


CREATE OR REPLACE VIEW last_winners_sum  AS
SELECT game_id, draw_date, SUM(amount) amount_summary FROM  WINNERS_WITH_AMOUNT
WHERE ((UPPER(game_name) = 'BIG LOTTO' AND correct_no < 6)
OR (UPPER(game_name) = 'EXPRESS LOTTO' AND correct_no < 5))
AND draw_date = (SELECT MAX(draw_date) FROM results)
GROUP BY game_id, draw_date;


CREATE VIEW coupons_prices AS
SELECT 
    c.game_id, TO_CHAR(r.draw_date ,'YY-MM-DD HH24:MI') draw_date
    , COUNT(DISTINCT c.coupon_id) coupon_no 
    ,   CASE
            WHEN c.game_id = 10 THEN COUNT(DISTINCT c.coupon_id)  * 2
            WHEN c.game_id = 20 THEN COUNT(DISTINCT c.coupon_id)  * 1.5
        END coupon_price_sum
FROM  coupons c
LEFT OUTER JOIN results r
ON c.game_id = r.game_id
AND TO_CHAR(c.coupon_date,'YY-MM-DD HH24:MI') BETWEEN TO_CHAR(r.draw_date - (INTERVAL '1' DAY),'YY-MM-DD HH24:MI') 
AND TO_CHAR(r.draw_date ,'YY-MM-DD HH24:MI') 
GROUP BY TO_CHAR(r.draw_date ,'YY-MM-DD HH24:MI'), c.game_id
ORDER BY draw_date DESC, c.game_id;


CREATE OR REPLACE VIEW WINNING_NUMBERS AS 
SELECT
GAME_ID, DRAW_DATE, NO_1, NO_2, NO_3, NO_4, NO_5,  NO_6
FROM 
  (SELECT
  game_id,draw_no, to_char(draw_date, 'YYYY-MM-DD') draw_date,
  ROW_NUMBER()
  OVER(PARTITION BY to_char(draw_date, 'YYYY-MM-DD'), game_id
  ORDER BY draw_no ASC )  rn
  FROM results )
PIVOT (
  MAX ( draw_no )FOR rn IN ( 1 NO_1, 2 NO_2, 3 NO_3, 4 NO_4, 5 NO_5, 6 NO_6 )
  )
 ORDER BY draw_date, game_id;