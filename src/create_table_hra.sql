-- =======================================
-- Průběžně aktualizované informace o probíhající hře. Obsahuje časové  
-- značky prvního a naposledy provedeného tahu, počet označených min a 
-- stav hry.
--
-- @author Radek Vais
-- @version 23.3.2018
-- =======================================

DROP TABLE sem_hra;

CREATE TABLE sem_hra
(
    id_hra NUMBER(10),
    oblast NUMBER(10),     -- příslušná oblast hry
    zacatek DATE,          -- čas prvního tahu
    konec DATE,            -- triggerem upravovaný čas posledního tahu
    pocet_tahu NUMBER(4),  -- triggerem upravovaný počet tahů hry
    pocet_vlajek NUMBER(4), -- triggerem upravovaná počet vlajek uživatele  
    stav NUMBER(10)         -- ciselniková hodnota stavu hry
);
