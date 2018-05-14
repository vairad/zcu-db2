-- Trigger vytvo�� pole pro pr�v� vytvo�enou oblast.
--
-- @author Radek Vais
CREATE OR REPLACE TRIGGER trigger_ai_sem_oblast
AFTER INSERT
ON sem_oblast
FOR EACH ROW
DECLARE
    vn_result NUMBER;
BEGIN
    dbms_output.put_line('Vytv���m pole pro oblast: '|| :new.id);
    vn_result := minesweeper_automation.VYTVOR_POLE(:new.id, :new.sirka, :new.vyska);
    IF vn_result = -1 THEN
        dbms_output.put_line('Nepoda�ilo se vytvo�it pole');
        DELETE FROM sem_oblast WHERE id = :new.id;
    END IF;
END
;

-- Trigger po vlo�en� tahu do tabulky sem_tah odkryje v�echna mo�n� pole pomoc�
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
   
   -- ur�i id oblasti do kter� byl zahr�n tah
   SELECT o.id INTO vn_oblast_id FROM sem_pole p, sem_oblast o
   WHERE o.id = p.oblast
   AND p.id = :new.pole;
   
   -- prvn� tah aktualizuje zacatek hry
   UPDATE sem_hra set zacatek = :new.cas, stav = 2 WHERE oblast = vn_oblast_id AND zacatek IS NULL;
   
   -- dal�� tahy zvy�uj� po��tadlo hry
   UPDATE sem_hra set pocet_tahu = (COALESCE(pocet_tahu, 0) + 1 ) WHERE oblast = vn_oblast_id;
   
   MINESWEEPER_AUTOMATION.PROHRA(vn_oblast_id);
   MINESWEEPER_AUTOMATION.VYHRA(vn_oblast_id);
END
;


-- Trigger p�ed vlo�en�m z�znamu do tabulky tah nastav� aktu�ln� �as tahu.
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


-- Trigger kontroluje omezen� na odkryt� pole.
-- pole je ji� odkryt�/zahran�
-- pole m� vlajku miny
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
        raise_application_error (-20002, 'Odkr�v�te ji� zahran� pole.');
   END IF;

   SELECT zobrazeno INTO vn_zobrazeno FROM sem_pole WHERE id = :new.pole;
   IF vn_zobrazeno = 1 THEN
        raise_application_error (-20001, 'Odkr�v�te ji� odkryt� pole.');
   END IF;
   
   SELECT COUNT(pole) INTO vn_zobrazeno FROM sem_mina WHERE pole = :new.pole;
   IF vn_zobrazeno > 0 THEN
        raise_application_error (-20003, 'Odkr�v�te minou ozna�en� pole.');
   END IF;
   
END
;

-- Trigger p�epo��t� p�id� vlaku do po�tu v oblasti
--
-- @author Radek Vais
CREATE OR REPLACE TRIGGER trigger_ai_sem_mina_placed
AFTER INSERT
ON sem_mina
FOR EACH ROW
DECLARE 
    vn_oblast_id NUMBER;
BEGIN
  
  -- ur�i id oblasti do kter� byl zahr�n tah
   SELECT o.id INTO vn_oblast_id FROM sem_pole p, sem_oblast o
   WHERE o.id = p.oblast
   AND p.id = :new.pole;
   
   -- prvn� tah aktualizuje zacatek hry
   UPDATE sem_hra set zacatek = sysdate, stav = 2 WHERE oblast = vn_oblast_id AND zacatek IS NULL;
   
   -- dal�� tahy zvy�uj� po��tadlo hry
   UPDATE sem_hra set pocet_vlajek = (COALESCE(pocet_vlajek, 0) + 1 )
        WHERE oblast = vn_oblast_id;
END
;

-- Trigger p�epo��t� aktu�ln� po�et vlajek v oblasti
--
-- @author Radek Vais
CREATE OR REPLACE TRIGGER trigger_ad_sem_mina_removed
AFTER DELETE
ON sem_mina
FOR EACH ROW
DECLARE 
    vn_oblast_id NUMBER;
BEGIN
  
  -- ur�i id oblasti do kter� byl zahr�n tah
   SELECT o.id INTO vn_oblast_id FROM sem_pole p, sem_oblast o
   WHERE o.id = p.oblast
   AND p.id = :old.pole;
   
   -- mazan� min sni�uje po�et vlajek ve h�e
   UPDATE sem_hra set pocet_vlajek = (pocet_vlajek -1  )
        WHERE oblast = vn_oblast_id;
END
;


-- Trigger kontroluje po�et vlajek na poli
--
-- @author Radek Vais
CREATE OR REPLACE TRIGGER trigger_bi_sem_mina_placed
BEFORE INSERT
ON sem_mina
FOR EACH ROW
DECLARE
BEGIN
        IF(MINESWEEPER_AUTOMATION.MNOHO_MIN(:new.pole) = 0) THEN
            raise_application_error (-20005, 'Nelze ozna�it v�ce pol� ne� min.');
        END IF;
 END;
 
 CREATE OR REPLACE TRIGGER trigger_bi_sem_oblast_param
 BEFORE INSERT
 ON sem_oblast
 FOR EACH ROW
 BEGIN
    MINESWEEPER_AUTOMATION.SPATNY_PARAMETR(:new.sirka, :new.vyska, :new.miny);
END;
