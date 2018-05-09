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



CREATE OR REPLACE TRIGGER trigger_bi_sem_pole_id
BEFORE INSERT 
ON sem_pole
FOR EACH ROW
BEGIN
   :new.id := seq_sem_pole_id.nextval;
END
;