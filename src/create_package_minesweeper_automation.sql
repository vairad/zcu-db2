/*<TOAD_FILE_CHUNK>*/
-- =======================================
--  Package, která obstarává 
--
-- @author Radek Vais
-- @version 23.3.2018
-- =======================================

CREATE OR REPLACE PACKAGE VAISR.MINESWEEPER_AUTOMATION
AS

    PROCEDURE ZAMINUJ_OBLAST( an_id_oblast IN NUMBER);
    
    PROCEDURE SPOCITEJ_OBLAST( an_id_oblast IN NUMBER);
    
    FUNCTION SPOCITEJ_POLE(  an_id_oblast IN NUMBER
                                ,an_x       IN NUMBER
                                ,an_y     IN NUMBER)
        RETURN NUMBER;
    
    FUNCTION VYTVOR_OBLAST(an_id_obtiznost IN NUMBER) 
        RETURN NUMBER;
    
    FUNCTION VYTVOR_POLE(an_id_oblast IN NUMBER
                    , an_sirka IN NUMBER
                    , an_vyska IN NUMBER
                    )
    RETURN NUMBER;
    
END MINESWEEPER_AUTOMATION;
/

/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE BODY VAISR.MINESWEEPER_AUTOMATION
AS     
        
    PROCEDURE ZAMINUJ_OBLAST(an_id_oblast NUMBER)
    IS
        vn_miny NUMBER;
        vn_x NUMBER;
        vn_y NUMBER;
        vn_placed NUMBER;
        vn_sirka NUMBER;
        vn_vyska NUMBER;
    BEGIN        
        vn_placed := 0;
        
        SELECT miny, sirka, vyska
          INTO vn_miny, vn_sirka, vn_vyska
        FROM sem_oblast
          WHERE id = an_id_oblast
        ;
        
        dbms_output.put_line('Pokládám ' || vn_miny || ' min do oblasti: ' || an_id_oblast);
        
        WHILE vn_miny > vn_placed
        LOOP
            vn_x := ROUND(DBMS_RANDOM.VALUE( 1 , vn_sirka));
            vn_y := ROUND(DBMS_RANDOM.VALUE( 1 , vn_vyska));
            --dbms_output.put_line('Pokládám minu na: ' || vn_x || ',' || vn_y);
            UPDATE sem_pole 
                SET info_mina = 9 
                WHERE x = vn_x AND y = vn_y AND oblast = an_id_oblast AND info_mina IS NULL;
            vn_placed := vn_placed + sql%rowcount;
        END LOOP;

    END ZAMINUJ_OBLAST;
    
    PROCEDURE SPOCITEJ_OBLAST( an_id_oblast IN NUMBER)
    IS
        vn_pocet_min NUMBER;
    BEGIN
        FOR pole IN (SELECT x, y FROM sem_pole WHERE oblast = an_id_oblast)
        LOOP
           --  dbms_output.put_line('Poèítám pole: ' || pole.x || ',' || pole.y);
           vn_pocet_min := MINESWEEPER_AUTOMATION.SPOCITEJ_POLE(an_id_oblast, pole.x, pole.y);
           
           IF vn_pocet_min <> 9 THEN
           
                UPDATE sem_pole 
                SET info_mina = vn_pocet_min 
                WHERE x = pole.x AND y = pole.y AND oblast = an_id_oblast;
                
                --dbms_output.put_line('Sousedím s: ' || vn_pocet_min || 'pole:'|| pole.x || ',' || pole.y);
           END IF;
        END LOOP;
    
    END SPOCITEJ_OBLAST;
    
    
    FUNCTION SPOCITEJ_POLE(  an_id_oblast IN NUMBER
                                ,an_x       IN NUMBER
                                ,an_y     IN NUMBER)
    RETURN NUMBER
    IS
        vn_miny_info NUMBER;
    BEGIN
        SELECT info_mina INTO vn_miny_info
           FROM sem_pole WHERE x = an_x AND y = an_y AND oblast = an_id_oblast;
        IF vn_miny_info = 9 THEN
            NULL;
            -- do nothing only jump to end of if
        ELSE
            vn_miny_info := 0;
            FOR sousedi IN ( SELECT info_mina 
                                FROM sem_pole 
                                WHERE x IN (an_x - 1, an_x , an_x + 1) and y IN (an_y - 1, an_y , an_y + 1) 
                                and oblast = an_id_oblast)
            LOOP
                IF(sousedi.info_mina = 9) THEN
                    vn_miny_info := vn_miny_info + 1;
                END IF;
            END LOOP;
        END IF;
        RETURN vn_miny_info;
    END SPOCITEJ_POLE;
    
    
    FUNCTION VYTVOR_OBLAST(an_id_obtiznost IN NUMBER)
    RETURN NUMBER
    IS
      vn_id_oblast NUMBER;
      vn_sirka     NUMBER;
      vn_vyska     NUMBER;
      vn_miny      NUMBER;
      vc_nazev_obtiznost VARCHAR2(50);
    BEGIN
        SELECT nazev
            , sirka
            , vyska
            , pocet_min
         INTO vc_nazev_obtiznost
            , vn_sirka
            , vn_vyska
            , vn_miny
            FROM sem_obtiznost
          WHERE id = an_id_obtiznost;
          
        dbms_output.put_line('Vytváøím novou oblast dle obtížnosti: ' || vc_nazev_obtiznost);
        
        vn_id_oblast := seq_sem_oblast_id.nextval();
        
        INSERT INTO sem_oblast (id, sirka, vyska, miny)
        VALUES(vn_id_oblast, vn_sirka, vn_vyska, vn_miny);
        
        return vn_id_oblast;
    EXCEPTION  
        WHEN OTHERS THEN
            return -1;

    END VYTVOR_OBLAST;
    
    
    FUNCTION VYTVOR_POLE(an_id_oblast IN NUMBER
                    , an_sirka IN NUMBER
                    , an_vyska IN NUMBER
                    )
    RETURN NUMBER
    IS
    BEGIN
        FOR i_sirka IN 1 .. an_sirka
        LOOP
            FOR i_vyska IN 1 .. an_vyska
            LOOP
                INSERT INTO sem_pole(x, y, oblast)
                VALUES (i_sirka, i_vyska, an_id_oblast);
            END LOOP;
        END LOOP;
        RETURN 1;
    EXCEPTION
        WHEN OTHERS THEN
        RETURN -1;
    END;
    
END MINESWEEPER_AUTOMATION;
/

