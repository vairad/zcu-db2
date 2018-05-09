CREATE OR REPLACE TRIGGER trigger_ai_sem_mina
AFTER INSERT 
ON sem_mina
FOR EACH ROW
BEGIN
   UPDATE Person SET Count=Count+1, Phone='123' WHERE name=`csr` and Phone <> '123'; 
   :new.id := seq_sem_oblast_id.nextval;
END
;

CREATE OR REPLACE TRIGGER trigger_ad_sem_mina
AFTER DELETE
ON sem_mina
FOR EACH ROW
BEGIN
   :new.id := seq_sem_oblast_id.nextval;
END
;