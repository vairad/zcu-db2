-- =======================================
-- Průběžně aktualizované informace o probíhající hře. Obsahuje časové  
-- značky prvního a naposledy provedeného tahu, počet označených min a 
-- stav hry.
--
-- @author Radek Vais
-- @version 28.4.2018
-- =======================================

--DROP TABLE sem_hra;

CREATE TABLE sem_hra
(
    id NUMBER(10) PRIMARY KEY,
    oblast NUMBER(10),      -- příslušná oblast hry
    zacatek DATE,           -- triggerem upravovaný čas prvního tahu
    konec DATE,             -- triggerem upravovaný čas posledního tahu
    pocet_tahu NUMBER(4),   -- triggerem upravovaný počet tahů hry
    pocet_vlajek NUMBER(4), -- triggerem upravovaná počet vlajek uživatele  
    stav NUMBER(10),        -- ciselniková hodnota stavu hry
    CONSTRAINT fk_hra_oblast
        FOREIGN KEY (oblast)
        REFERENCES sem_oblast (id)
);

-- DROP SEQUENCE seq_sem_hra_id;

CREATE SEQUENCE seq_sem_hra_id
    INCREMENT BY 1
    MAXVALUE 9999999999
    NOCYCLE 
;  

COMMENT ON TABLE sem_hra IS 'Tabulka her. Průběžně aktualizované informace o probíhající hře. Obsahuje časové značky prvního a naposledy provedeného tahu, počet označených min a stav hry.';

COMMENT ON COLUMN sem_hra.id IS 'ID hry ze sekvence.';

COMMENT ON COLUMN sem_hra.oblast IS 'Odkaz na oblast hry.';

COMMENT ON COLUMN sem_hra.zacatek IS 'Triggerem upravovaný  čas začátku hry.';

COMMENT ON COLUMN sem_hra.konec IS 'Triggerem upravovaný čas konce hry.';

COMMENT ON COLUMN sem_hra.pocet_tahu IS 'Triggerem upravovaný počet zahraných tahů.';

COMMENT ON COLUMN sem_hra.stav IS 'Triggerem upravovaný číselníkový stav hry';
