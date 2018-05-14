-- =======================================
-- V�sledkov� tabulka her, kter� byly �sp�n� dokon�en�. M�la by ukazovat
-- parametry obt�nosti (rozm�ry oblasti a po�et min) dan� hry a tak� dobu
-- hran� hry (rozd�l �asov�ch zna�ek posledn�ho a prvn�ho tahu)
--
-- @author Radek Vais
-- @version 23.3.2018
-- =======================================

CREATE OR REPLACE VIEW sem_vitezove 
AS
    SELECT o.sirka AS sirka, o.vyska AS vyska, o.miny AS miny
        , h.pocet_tahu AS pocet_tahu
        , (h.konec - h.zacatek)*(24)  AS doba_hry_hodiny
        ,(h.konec - h.zacatek)*(24 * 60) AS doba_hry_minuty
        ,(h.konec - h.zacatek)*(24 * 60 * 60) AS doba_hry_sekundy
    FROM sem_hra h
    LEFT JOIN sem_oblast o ON h.oblast = o.id
    WHERE h.stav = 3
;
    
--SELECT * FROM sem_vitezove;