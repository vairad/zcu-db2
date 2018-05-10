-- =======================================
-- Hráčem odkrývaná pole v zaminované oblasti. Ke každému tahu se bude
-- automaticky ukládat časová značka, kdy byl tah vykonán.
--
-- @author Radek Vais
-- @version 23.3.2018
-- =======================================

--DROP TABLE sem_tah;

CREATE TABLE sem_tah
(
    pole NUMBER(10) PRIMARY KEY,        -- příslušná zahrané pole
    cas DATE,                           -- triggerem upravovaný čas tahu
    CONSTRAINT fk_tah_pole
        FOREIGN KEY (pole)
        REFERENCES sem_pole (id)
);

COMMENT ON TABLE sem_tah IS 'Hráčem odkrývaná pole v zaminované oblasti. Ke každému tahu se bude automaticky ukládat časová značka, kdy byl tah vykonán.';

COMMENT ON COLUMN sem_tah.pole IS 'Odkaz na konkrétní hráčem odkryté.';

COMMENT ON COLUMN sem_tah.cas IS 'Čas vykonání tahu, hodnota automaticky uložená triggerem.';
