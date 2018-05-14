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


CREATE OR REPLACE TRIGGER trigger_bi_sem_tah_played
AFTER INSERT 
ON sem_tah
FOR EACH ROW
DECLARE 
    vn_hra_id NUMBER;
BEGIN
   MINESWEEPER_AUTOMATION.ODKRYJ_POLE(:new.pole);
   SELECT h.id INTO vn_hra_id FROM sem_hra h, sem_pole p, sem_oblast o
   WHERE h.oblast = o.id
   AND o.id = p.oblast
   AND p.id = :new.pole;
   
   UPDATE sem_hra set zacatek = :new.cas, stav = 2 WHERE id = vn_hra_id AND zacatek IS NULL;
   
   UPDATE sem_hra set pocet_tahu = (COALESCE(pocet_tahu, 0) + 1 ) WHERE id = vn_hra_id;
END
;

--DROP TRIGGER trigger_bi_sem_tah_time;

CREATE OR REPLACE TRIGGER trigger_bi_sem_tah_time
BEFORE INSERT 
ON sem_tah
FOR EACH ROW
BEGIN
   :new.cas := sysdate;

END
;

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

CREATE OR REPLACE TRIGGER trigger_au_sem_pole_id
AFTER UPDATE
ON sem_pole
FOR EACH ROW
DECLARE
    an_miny NUMBER  ;
    an_pole NUMBER ;
    an_slapnute NUMBER;
BEGIN
    SELECT COUNT(id) INTO an_slapnute FROM sem_pole 
      WHERE oblast = :new.oblast AND info_mina <> 9
        AND zobrazeno = 1;
    
    SELECT (sirka * vyska), miny INTO an_pole, an_miny FROM sem_oblast
      WHERE id = :new.oblast;
      
    IF (an_pole - an_slapnute) = an_miny THEN
        MINESWEEPER_AUTOMATION.VYHRA(:new.oblast);
    END IF;
END
;

CREATE OR REPLACE TRIGGER trigger_bi_sem_pole_id
BEFORE INSERT 
ON sem_pole
FOR EACH ROW
BEGIN
   :new.id := seq_sem_pole_id.nextval;
END
;