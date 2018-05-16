-- =======================================
-- Zadání:
-- Číselník obsahující, v jakých stavech se hra může vyskytovat. Stavy
-- mohou být:
--  rozehraná, úspěšně ukončená, neúspěšně ukončená.
--
-- @author Radek Vais
-- @version 24.3.2018
-- =======================================

--DROP TABLE sem_stav;

CREATE TABLE sem_stav
(
    id NUMBER(10) PRIMARY KEY NOT NULL,
    nazev VARCHAR2(50) NOT NULL
)
;

COMMENT ON TABLE sem_stav IS 'Číselník stavů hry';

COMMENT ON COLUMN sem_stav.id IS 'Manuálně určované ID';

COMMENT ON COLUMN sem_stav.nazev IS 'Uživatelsky přívětivý název stavu hry';

-- =============================================================================
-- Základní hodnoty číselníku
--

INSERT INTO sem_stav (id, nazev) 
VALUES (1, 'Nová')
;

INSERT INTO sem_stav(id, nazev) 
VALUES (2, 'Rozehraná')
;

INSERT INTO sem_stav(id, nazev) 
VALUES (3, 'Vyhraná')
;

INSERT INTO sem_stav(id, nazev) 
VALUES (4, 'Prohraná')
;
