-- =======================================
-- Seznam pol� v zaminovan� oblasti, kter� byly chybn� ozna�en� jako
-- zaminovan�. Nab�z� data pro v�echny oblasti.

--
-- @author Radek Vais
-- @version 23.3.2018
-- =======================================


CREATE OR REPLACE VIEW sem_chybne_miny
AS
    SELECT p.oblast AS oblast, p.X AS X, p.y AS Y
    FROM sem_mina m
    LEFT JOIN sem_pole p ON m.pole = p.id
    WHERE p.info_mina <> 9
;
    
--SELECT * FROM sem_chybne_miny;
    