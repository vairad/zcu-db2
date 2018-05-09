-- =======================================
-- Hráčem označovaná pole, o kterých si myslí, že jsou zaminovaná.
--
--
-- @author Radek Vais
-- @version 23.3.2018
-- =======================================

--DROP TABLE sem_mina;

CREATE TABLE sem_mina(
    pole NUMBER (10) PRIMARY KEY,
    CONSTRAINT fk_mina_pole
      FOREIGN KEY (pole)
      REFERENCES sem_pole (id)
)
;

COMMENT ON TABLE sem_mina IS 'Hráčem označovaná pole, o kterých si myslí, že jsou zaminovaná.';

COMMENT ON COLUMN sem_mina.pole IS 'Odkaz na konkrétní pole.';
