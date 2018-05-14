-- =======================================
-- Každá hra musí mít definovanou obtížnost. Buď bude vybrána 
-- předdefinovaná, nebo si hráč definuje obtížnost vlastní. Hodnoty 
-- parametrů vlastní obtížnosti se ukládají do tabulky OBLAST. Podle 
-- originální hry jsou předdefinované obtížnosti nastaveny takto:
--    Začátečník: 9 řádků x 9 sloupců, 10 min
--    Pokročilý: 16 řádků x 16 sloupců, 40 min
--    Expert: 16 řádků x 30 sloupců, 99 min
--
-- @author Radek Vais
-- @version 23.3.2018
-- =======================================

--DROP TABLE sem_obtiznost;

CREATE TABLE sem_obtiznost
(
    id    NUMBER(10) PRIMARY KEY,
    nazev VARCHAR2(50) NOT NULL,
    sirka NUMBER(4) NOT NULL,
    vyska NUMBER(4) NOT NULL,
    pocet_min NUMBER(4) NOT NULL
)
;

COMMENT ON TABLE sem_obtiznost IS 'Číselník pojmenovaných obtížností hry';

COMMENT ON COLUMN sem_obtiznost.id IS 'Manálně určované ID stavu hry.';

COMMENT ON COLUMN sem_obtiznost.nazev IS 'Uživatelský název obtížnosti';

COMMENT ON COLUMN sem_obtiznost.sirka IS 'Šířka hracího pole';

COMMENT ON COLUMN sem_obtiznost.vyska IS 'Výška hracího pole';

COMMENT ON COLUMN sem_obtiznost.pocet_min IS 'Počet hledaných min';

-- =============================================================================
-- Výchozí data číselníku
--

INSERT INTO sem_obtiznost(id, nazev, sirka, vyska, pocet_min)
    VALUES(1, 'Začátečník', 9, 9, 10)
;

INSERT INTO sem_obtiznost(id, nazev, sirka, vyska, pocet_min)
    VALUES(2, 'Pokročilý', 16, 16, 40)
;

INSERT INTO sem_obtiznost(id, nazev, sirka, vyska, pocet_min)
    VALUES(3, 'Expert', 16, 30, 99)
;