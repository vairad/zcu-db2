-- =======================================
-- Výsledková tabulka her, které byly neúspìšnì dokonèené. Mìla by navíc
-- (oproti pohledu VITEZOVE) ukazovat, kolik min bylo správnì odhaleno.
--
-- @author Radek Vais
-- @version 23.3.2018
-- =======================================


CREATE OR REPLACE VIEW sem_porazeni 
AS
    SELECT o.sirka AS sirka, o.vyska AS vyska, o.miny AS miny
        , h.pocet_tahu AS pocet_tahu
        , (h.konec - h.zacatek)*(24)  AS doba_hry_hodiny
        ,(h.konec - h.zacatek)*(24 * 60) AS doba_hry_minuty
        ,(h.konec - h.zacatek)*(24 * 60 * 60) AS doba_hry_sekundy
    FROM sem_hra h
    LEFT JOIN sem_oblast o ON h.oblast = o.id
    WHERE h.stav = 4
;
    
--SELECT * FROM sem_porazeni;