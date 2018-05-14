DECLARE
BEGIN
  --21 speciální obtížnost
  --41 jedna mina
   MINESWEEPER.VYTVOR_HRU(1);
  --  MINESWEEPER.TAH(46, 2, 4 );
--    MINESWEEPER.MINA(46, 2, 4 );
 -- MINESWEEPER.OBLAST_TISK(46);
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

DECLARE
BEGIN
  MINESWEEPER.TAH(51, 1, 4 );
  MINESWEEPER.OBLAST_TISK(51);
END;

DECLARE
BEGIN
  MINESWEEPER.MINA(51, 9, 9 );
  MINESWEEPER.OBLAST_TISK(51);
END;

DECLARE
BEGIN
  MINESWEEPER.MINA(51, 8, 9 );
  MINESWEEPER.MINA(51, 7, 9 );
  MINESWEEPER.MINA(51, 6, 9 );
  MINESWEEPER.MINA(51, 5, 9 );
  MINESWEEPER.MINA(51, 4, 9 );
  MINESWEEPER.MINA(51, 3, 9 );
  MINESWEEPER.MINA(51, 2, 9 );
  MINESWEEPER.MINA(51, 1, 9 );
  MINESWEEPER.OBLAST_TISK(51);
END;

DECLARE
BEGIN
  MINESWEEPER.OBLAST_TISK(51);
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


INSERT INTO sem_mina (pole) VALUES(2394);

SELECT COUNT(m.pole)
        FROM sem_mina m
        LEFT JOIN sem_pole p ON m.pole = p.id
        WHERE p.oblast = 51; 

SELECT o.MINY
        FROM sem_oblast o
        INNER JOIN sem_pole p ON o.id = p.oblast
        INNER JOIN sem_mina m ON m.pole = p.id
        WHERE p.oblast = 51; 


        SELECT o.miny
        FROM sem_oblast o
        WHERE o.id = 51;    

SELECT znak_pole(info_mina, zobrazeno, COUNT(m.pole)) AS field 
  FROM sem_pole p, sem_mina m 
  LEFT JOIN sem_mina ON m.pole = p.id 
  WHERE oblast = 8 AND y = 3)
  ;
  
  SELECT COUNT(m.pole)
        INTO vn_vlajky
        FROM sem_mina m
        LEFT JOIN sem_pole p ON m.pole = p.id
        WHERE p.oblast = an_id_oblast; 
  
  SELECT COUNT(id) FROM sem_pole 
  INNER JOIN sem_mina ON sem_mina.pole = sem_pole.id
  WHERE oblast = 46
  ;
  



SELECT sem_pole.id, sem_pole.info_mina, sem_pole.zobrazeno, sem_mina.pole AS field 
  FROM sem_pole 
  LEFT JOIN sem_mina ON sem_pole.id = sem_mina.pole
  WHERE sem_pole.oblast = 8 
--  GROUP BY sem_pole.id
;

