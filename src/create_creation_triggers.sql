-- Trigger vytvoøí pole pro právì vytvoøenou oblast.
--
-- @author Radek Vais
CREATE OR REPLACE TRIGGER trigger_ai_sem_oblast
AFTER INSERT
ON sem_oblast
FOR EACH ROW
DECLARE
    vn_result NUMBER;
BEGIN
    dbms_output.put_line('Vytváøím pole pro oblast: '|| :new.id);
    vn_result := minesweeper_automation.VYTVOR_POLE(:new.id, :new.sirka, :new.vyska);
    IF vn_result = -1 THEN
        dbms_output.put_line('Nepodaøilo se vytvoøit pole');
        DELETE FROM sem_oblast WHERE id = :new.id;
    END IF;
END
;

-- Trigger po vložení tahu do tabulky sem_tah odkryje všechna možná pole pomocí
-- procedury ODKRYJ_POLE.
--
-- @author Radek Vais
CREATE OR REPLACE TRIGGER trigger_ai_sem_tah_played
AFTER INSERT 
ON sem_tah
FOR EACH ROW
DECLARE 
    vn_oblast_id NUMBER;
BEGIN
   MINESWEEPER_AUTOMATION.ODKRYJ_POLE(:new.pole);
   
   -- urèi id oblasti do které byl zahrán tah
   SELECT o.id INTO vn_oblast_id FROM sem_pole p, sem_oblast o
   WHERE o.id = p.oblast
   AND p.id = :new.pole;
   
   -- první tah aktualizuje zacatek hry
   UPDATE sem_hra set zacatek = :new.cas, stav = 2 WHERE oblast = vn_oblast_id AND zacatek IS NULL;
   
   -- další tahy zvyšují poèítadlo hry
   UPDATE sem_hra set pocet_tahu = (COALESCE(pocet_tahu, 0) + 1 ) WHERE oblast = vn_oblast_id;
   
   MINESWEEPER_AUTOMATION.PROHRA(vn_oblast_id);
   MINESWEEPER_AUTOMATION.VYHRA(vn_oblast_id);
END
;


-- Trigger pøed vložením záznamu do tabulky tah nastaví aktuální èas tahu.
--
-- @author Radek Vais
CREATE OR REPLACE TRIGGER trigger_bi_sem_tah
BEFORE INSERT 
ON sem_tah
FOR EACH ROW
DECLARE
    vn_stav NUMBER;
BEGIN
   :new.cas := sysdate;
   MINESWEEPER_AUTOMATION.UKONCENA_HRA(:new.pole);
END
;


-- Trigger kontroluje omezení na odkrytí pole.
-- pole je již odkryté/zahrané
-- pole má vlajku miny
--
-- @author Radek Vais
CREATE OR REPLACE TRIGGER trigger_bi_sem_tah_showed
BEFORE INSERT 
ON sem_tah
FOR EACH ROW
DECLARE
  vn_zobrazeno NUMBER;
BEGIN

   SELECT COUNT(pole) INTO vn_zobrazeno FROM sem_tah WHERE pole = :new.pole;
   IF vn_zobrazeno > 0 THEN
        raise_application_error (-20002, 'Odkrýváte již zahrané pole.');
   END IF;

   SELECT zobrazeno INTO vn_zobrazeno FROM sem_pole WHERE id = :new.pole;
   IF vn_zobrazeno = 1 THEN
        raise_application_error (-20001, 'Odkrýváte již odkryté pole.');
   END IF;
   
   SELECT COUNT(pole) INTO vn_zobrazeno FROM sem_mina WHERE pole = :new.pole;
   IF vn_zobrazeno > 0 THEN
        raise_application_error (-20003, 'Odkrýváte minou oznaèené pole.');
   END IF;
   
END
;

-- Trigger pøepoèítá pøidá vlaku do poètu v oblasti
--
-- @author Radek Vais
CREATE OR REPLACE TRIGGER trigger_ai_sem_mina_placed
AFTER INSERT
ON sem_mina
FOR EACH ROW
DECLARE 
    vn_oblast_id NUMBER;
BEGIN
  
  -- urèi id oblasti do které byl zahrán tah
   SELECT o.id INTO vn_oblast_id FROM sem_pole p, sem_oblast o
   WHERE o.id = p.oblast
   AND p.id = :new.pole;
   
   -- první tah aktualizuje zacatek hry
   UPDATE sem_hra set zacatek = sysdate, stav = 2 WHERE oblast = vn_oblast_id AND zacatek IS NULL;
   
   -- další tahy zvyšují poèítadlo hry
   UPDATE sem_hra set pocet_vlajek = (COALESCE(pocet_vlajek, 0) + 1 )
        WHERE oblast = vn_oblast_id;
END
;

-- Trigger pøepoèítá aktuální poèet vlajek v oblasti
--
-- @author Radek Vais
CREATE OR REPLACE TRIGGER trigger_ad_sem_mina_removed
AFTER DELETE
ON sem_mina
FOR EACH ROW
DECLARE 
    vn_oblast_id NUMBER;
BEGIN
  
  -- urèi id oblasti do které byl zahrán tah
   SELECT o.id INTO vn_oblast_id FROM sem_pole p, sem_oblast o
   WHERE o.id = p.oblast
   AND p.id = :old.pole;
   
   -- mazaní min snižuje poèet vlajek ve høe
   UPDATE sem_hra set pocet_vlajek = (pocet_vlajek -1  )
        WHERE oblast = vn_oblast_id;
END
;


-- Trigger kontroluje poèet vlajek na poli
--
-- @author Radek Vais
CREATE OR REPLACE TRIGGER trigger_bi_sem_mina_placed
BEFORE INSERT
ON sem_mina
FOR EACH ROW
DECLARE
BEGIN
        IF(MINESWEEPER_AUTOMATION.MNOHO_MIN(:new.pole) = 0) THEN
            raise_application_error (-20005, 'Nelze oznaèit více polí než min.');
        END IF;
 END;
 
 CREATE OR REPLACE TRIGGER trigger_bi_sem_oblast_param
 BEFORE INSERT
 ON sem_oblast
 FOR EACH ROW
 BEGIN
    MINESWEEPER_AUTOMATION.SPATNY_PARAMETR(:new.sirka, :new.vyska, :new.miny);
END;
