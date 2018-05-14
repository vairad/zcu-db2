-- =======================================
-- Výsledková tabulka her, které byly úspìšnì dokonèené. Mìla by ukazovat
-- parametry obtížnosti (rozmìry oblasti a poèet min) dané hry a také dobu
-- hraní hry (rozdíl èasových znaèek posledního a prvního tahu)
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