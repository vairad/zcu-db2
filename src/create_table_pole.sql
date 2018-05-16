-- =======================================
-- Elementární část zaminované oblasti definovaná svými souřadnicemi,
-- která může nést minu nebo informaci, s kolika zaminovanými 
-- poli sousedí.
--
-- @author Radek Vais
-- @version 23.3.2018
-- =======================================

--DROP TABLE sem_pole;

CREATE TABLE sem_pole(
    id NUMBER (10) PRIMARY KEY,
    x NUMBER (4) NOT NULL,           -- xová souřadnice pole v oblasti
    y NUMBER (4) NOT NULL,           -- ynová souřadnice pole v oblasi
    oblast NUMBER(10) NOT NULL,      -- odkaz na oblast
    info_mina NUMBER(1) NULL,        -- počet sousedních min hodnota 9 znamená 
    zobrazeno NUMBER(1) DEFAULT 0,   -- vlajka, zda pole je již zobrazeno
    CONSTRAINT fk_pole_oblast
        FOREIGN KEY (oblast)
        REFERENCES sem_oblast (id)       
)
;

--DROP SEQUENCE seq_sem_pole_id;

CREATE SEQUENCE seq_sem_pole_id
    INCREMENT BY 1
    MAXVALUE 9999999999
    NOCYCLE 
;  

--DROP TRIGGER trigger_bi_sem_pole_id;

CREATE OR REPLACE TRIGGER t_bi_sem_pole_id
BEFORE INSERT 
ON sem_pole
FOR EACH ROW
BEGIN
   :new.id := seq_sem_pole_id.nextval;
END
;

COMMENT ON TABLE sem_pole IS 'Elementární část zaminované oblasti definovaná svými souřadnicemi, která může nést minu nebo informaci, s kolika zaminovanými poli sousedí.';

COMMENT ON COLUMN sem_pole.id IS 'Automaticky určované ID pole sekvencí a triggerem.';

COMMENT ON COLUMN sem_pole.x IS 'Vodorovná pozice pole v oblasti.';

COMMENT ON COLUMN sem_pole.y IS 'Svislá pozice pole v oblasti.';

COMMENT ON COLUMN sem_pole.oblast IS 'Odkaz na oblast, které je pole součástí';

COMMENT ON COLUMN sem_pole.info_mina IS 'Počet min sousedících min ... 9 = pole je minou';

COMMENT ON COLUMN sem_pole.zobrazeno IS 'Vlajka, zda pole je již zobrazeno (hodnoty 0/1)';