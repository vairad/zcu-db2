-- =======================================
-- Zobrazení celé zaminované oblasti vèetnì odkrytých polí a (hráèem)
-- oznaèených min. Každý øádek oblasti bude zobrazen voláním funkce
-- RADEK_OBLASTI
--
-- @author Radek Vais
-- @version 23.3.2018
-- =======================================

CREATE OR REPLACE VIEW OBLAST_TISK AS
SELECT DISTINCT(y), OBLAST, MINESWEEPER.RADEK_OBLASTI(oblast, y) AS RADEK
FROM sem_pole
ORDER BY y ASC
;

--SELECT radek FROM OBLAST_TISK WHERE oblast = 47;

