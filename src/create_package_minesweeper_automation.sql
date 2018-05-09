-- =======================================
--  Package, která obstarává 
--
-- @author Radek Vais
-- @version 23.3.2018
-- =======================================

CREATE OR REPLACE PACKAGE VAISR.MINESWEEPER_AUTOMATION
AS
    PROCEDURE ZAMINUJ_OBLAST( an_id_oblast  NUMBER);
    
    FUNCTION VYTVOR_OBLAST(an_id_obtiznost IN NUMBER) 
    RETURN NUMBER;
    
    FUNCTION VYTVOR_POLE(an_id_oblast IN NUMBER
                    , an_sirka IN NUMBER
                    , an_vyska IN NUMBER
                    )
    RETURN NUMBER;
    
END MINESWEEPER_AUTOMATION;
/

CREATE OR REPLACE PACKAGE BODY VAISR.MINESWEEPER_AUTOMATION
AS
    PROCEDURE ZAMINUJ_OBLAST(an_id_oblast NUMBER)
    IS
        vn_miny NUMBER;
    BEGIN
        SELECT miny 
          INTO vn_miny
        FROM sem_oblast
          WHERE id = an_id_oblast
        ;
        dbms_output.put_line(vn_miny);
    END ZAMINUJ_OBLAST;
    
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
        
        COMMIT;
        
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
                INSERT INTO sem_pole(x, y, id)
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
