-- =======================================
-- Script zaèistí databázové entity v DB
--
-- @author Radek Vais
-- @version 08.05.2018
-- =======================================


DROP TRIGGER trigger_bi_sem_hra_id;
DROP TRIGGER trigger_bi_sem_tah_time;
DROP TRIGGER trigger_bi_sem_pole_id;
DROP TRIGGER  trigger_bi_sem_oblast_id;
DROP TRIGGER  trigger_bi_sem_obtiznost_id;

DROP SEQUENCE seq_sem_obtiznost_id;
DROP SEQUENCE seq_sem_oblast_id;
DROP SEQUENCE seq_sem_pole_id;
DROP SEQUENCE seq_sem_hra_id;

DROP TABLE sem_hra;
DROP TABLE sem_tah;
DROP TABLE sem_mina;
DROP TABLE sem_pole;
DROP TABLE sem_oblast;
DROP TABLE sem_stav;
DROP TABLE sem_obtiznost;
DROP TABLE sem_omezeni;