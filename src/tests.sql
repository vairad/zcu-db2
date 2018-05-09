DECLARE
BEGIN
  MINESWEEPER.VYTVOR_HRU(21);
  MINESWEEPER.OBLAST_TISK(14);
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