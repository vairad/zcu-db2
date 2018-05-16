-- =======================================
-- Každá zaminovaná oblast je vytvořená podle vlastní obtížnosti a
-- obsahuje její hodnoty. Hráč má za úkol oblast od min vyčistit.
--
-- @author Radek Vais
-- @version 28.4.2018
-- =======================================

--DROP TABLE sem_oblast;

CREATE TABLE sem_oblast
(
    id NUMBER (10) PRIMARY KEY,
    sirka NUMBER (4) NOT NULL,       -- šířka pole
    vyska NUMBER (4) NOT NULL,       -- výška pole
    miny  NUMBER (4) NOT NULL,        -- počet min v oblasti
    obtiznost NUMBER (10) NULL,         -- pripadne id obtiznosti
    CONSTRAINT fk_oblast_obtiznost
      FOREIGN KEY (obtiznost)
      REFERENCES sem_obtiznost (id)
);

--DROP SEQUENCE seq_sem_oblast_id;

CREATE SEQUENCE seq_sem_oblast_id
    INCREMENT BY 1
    MAXVALUE 9999999999
    NOCYCLE 
;  

CREATE OR REPLACE TRIGGER t_bi_sem_oblast_id
BEFORE INSERT
ON sem_oblast
FOR EACH ROW
BEGIN
    :new.id := seq_sem_oblast_id.nextval;
END
;

COMMENT ON TABLE sem_oblast IS 'Každá zaminovaná oblast je vytvořená podle vlastní obtížnosti a obsahuje její hodnoty. Hráč má za úkol oblast od min vyčistit.';

COMMENT ON COLUMN sem_oblast.id IS 'Automaticky určované ID ze sekvence.';

COMMENT ON COLUMN sem_oblast.sirka IS 'Šířka této oblasti.';

COMMENT ON COLUMN sem_oblast.vyska IS 'Výška této oblasti.';

COMMENT ON COLUMN sem_oblast.miny IS 'Počet min v oblasti.';

COMMENT ON COLUMN sem_oblast.miny IS 'Odkaz na definici standardní obtížnosti.';

