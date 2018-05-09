CREATE OR REPLACE TRIGGER trigger_ai_sem_oblast
AFTER INSERT
ON sem_oblast
FOR EACH ROW
DECLARE
    vn_result NUMBER;
BEGIN
    vn_result := minesweeper_automation.VYTVOR_POLE(:new.id, :new.sirka, :new.vyska);
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