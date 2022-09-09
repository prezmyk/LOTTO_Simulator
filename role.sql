-- ROLE
CREATE ROLE GUEST_UESER; 
-- SESSION
GRANT CREATE SESSION TO GUEST_USER;
-- SELECT on tables
GRANT SELECT ON lotto.games 				TO GUEST_USER;
GRANT SELECT ON lotto.results 				TO GUEST_USER;
GRANT SELECT ON lotto.lucky_winners 		TO GUEST_USER;
GRANT SELECT ON lotto.coupons 				TO GUEST_USER;
GRANT SELECT ON lotto.coupons_numbers 		TO GUEST_USER;
GRANT SELECT ON lotto.rollovers 			TO GUEST_USER;
GRANT SELECT ON lotto.rollovers_archive 	TO GUEST_USER;
GRANT SELECT ON lotto.budget				TO GUEST_USER;
-- SELECT on Views
GRANT SELECT ON lotto.last_winners_sum 		TO GUEST_USER;
GRANT SELECT ON lotto.MATCHED_WINNERS 		TO GUEST_USER;
GRANT SELECT ON lotto.winners_with_amount 	TO GUEST_USER;
GRANT SELECT ON lotto.coupons_prices 		TO GUEST_USER;



-- Procedure
GRANT EXECUTE ON LOTTO.coupons_numbers_pkg 	TO GUEST_USER;

-- SYNONYM
GRANT GUEST_USER	TO LOTTO_USER;


-- SYNONYMS on tables
CREATE PUBLIC SYNONYM games 				FOR lotto.games;
CREATE PUBLIC SYNONYM results 				FOR lotto.results ;
CREATE PUBLIC SYNONYM lucky_winners 		FOR lotto.lucky_winners ;
CREATE PUBLIC SYNONYM coupons 				FOR lotto.coupons ;
CREATE PUBLIC SYNONYM coupons_numbers 		FOR lotto.coupons_numbers ;
CREATE PUBLIC SYNONYM rollovers 			FOR lotto.rollovers ;
CREATE PUBLIC SYNONYM rollovers_archive 	FOR lotto.rollovers_archive ;
CREATE PUBLIC SYNONYM budget			 	FOR lotto.budget;
-- SYNONYMS on Views
CREATE PUBLIC SYNONYM last_winners_sum 	FOR lotto.last_winners_sum ;
CREATE PUBLIC SYNONYM MATCHED_WINNERS 		FOR lotto.MATCHED_WINNERS ;
CREATE PUBLIC SYNONYM winners_with_amount 	FOR lotto.winners_with_amount ;
CREATE PUBLIC SYNONYM coupons_prices 		FOR lotto.coupons_prices  ;
-- PACKAGE
CREATE PUBLIC SYNONYM coupons_numbers_pkg 	FOR LOTTO.coupons_numbers_pkg ;


