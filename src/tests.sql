DECLARE
BEGIN
  --21 speciální obtížnost
--  MINESWEEPER.VYTVOR_HRU(1);
  MINESWEEPER.TAH(38, 9, 9 );
  MINESWEEPER.OBLAST_TISK(38);
  ---MINESWEEPER_AUTOMATION.ZAMINUJ_OBLAST(7);
 -- MINESWEEPER_AUTOMATION.SPOCITEJ_OBLAST(9);
 -- dbms_output.put_line(MINESWEEPER.RADEK_OBLASTI(9, 1));
  --dbms_output.put_line(MINESWEEPER.RADEK_OBLASTI(9, 2));
 -- dbms_output.put_line(MINESWEEPER.RADEK_OBLASTI(9, 3));
 -- dbms_output.put_line(MINESWEEPER.RADEK_OBLASTI(9, 4));
 -- dbms_output.put_line(MINESWEEPER.RADEK_OBLASTI(9, 5));
 -- dbms_output.put_line(MINESWEEPER.RADEK_OBLASTI(9, 6));
 -- dbms_output.put_line(MINESWEEPER.RADEK_OBLASTI(9, 7));
 -- dbms_output.put_line(MINESWEEPER.RADEK_OBLASTI(9, 8));
 -- dbms_output.put_line(MINESWEEPER.RADEK_OBLASTI(9, 9));
--  dbms_output.put_line(MINESWEEPER_AUTOMATION.SPOCITEJ_POLE(8, 7, 9));
END;

INSERT INTO sem_pole(x, y, oblast)
                VALUES (1, 2, 1);
                
                
UPDATE sem_pole SET info_mina = 9 WHERE x =1 AND y=1 AND oblast = 7 AND info_mina IS NULL;

SELECT miny, sirka, vyska
        FROM sem_oblast
          WHERE id = 7
        ;
        
        
SELECT x, y, info_mina from sem_pole WHERE x IN (2, 3, 4) and y IN (4, 5,6) and oblast = 8;

SELECT info_mina , x, y, id
FROM sem_pole 
WHERE x IN (1 - 1, 1 , 1+ 1) and y IN (1 - 1, 1 , 1 + 1) 
AND oblast = 28
AND info_mina = 0;

UPDATE sem_hra set pocet_tahu = (COALESCE(pocet_tahu, 0) + 1 ) WHERE id = 1;