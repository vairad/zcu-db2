/*<TOAD_FILE_CHUNK>*/
-- =======================================
--
--
-- @author Radek Vais
-- @version 23.3.2018
-- =======================================

CREATE OR REPLACE PACKAGE VAISR.MINESWEEPER
AS
    PROCEDURE VYTVOR_HRU(an_id_obtiznost NUMBER);
    
    FUNCTION ZNAK_POLE( an_info_mina IN NUMBER
                        , an_zobrazeno IN NUMBER)
        RETURN CHAR;
        
    FUNCTION RADEK_OBLASTI (an_id_oblast IN NUMBER
                            , an_radek IN NUMBER)
        RETURN VARCHAR2;
        
    PROCEDURE OBLAST_TISK (an_id_oblast IN NUMBER);
    
    PROCEDURE TAH(an_id_oblast IN NUMBER
                    ,an_x IN NUMBER
                    ,an_y IN NUMBER);
END;
/

/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE BODY VAISR.MINESWEEPER
AS

    PROCEDURE VYTVOR_HRU(an_id_obtiznost NUMBER)
    IS
        vn_id_oblast NUMBER;
    BEGIN
       vn_id_oblast := MINESWEEPER_AUTOMATION.VYTVOR_OBLAST(an_id_obtiznost);
       MINESWEEPER_AUTOMATION.ZAMINUJ_OBLAST(vn_id_oblast);
       MINESWEEPER_AUTOMATION.SPOCITEJ_OBLAST(vn_id_oblast);
       MINESWEEPER_AUTOMATION.VYTVOR_HRU(vn_id_oblast);
       COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('CHYBA ALOzeni:');
            dbms_output.put_line(SQLERRM);
        ROLLBACK;
    END;
    
    FUNCTION ZNAK_POLE( an_info_mina IN NUMBER
                        , an_zobrazeno IN NUMBER)
    RETURN CHAR
    IS
      vc_output CHAR;
    BEGIN
        IF an_zobrazeno = 0 THEN
            vc_output := 'o';
        ELSE
            CASE an_info_mina
                WHEN 9 THEN vc_output := 'x';
                WHEN 0 THEN vc_output := '-';
                ELSE vc_output := TO_CHAR(an_info_mina);
            END CASE;
        END IF;
        
        RETURN vc_output;
    END ZNAK_POLE;
    
    FUNCTION RADEK_OBLASTI (an_id_oblast IN NUMBER
                            , an_radek IN NUMBER)
    RETURN VARCHAR2
    IS
     vc_radek VARCHAR2(1024);
    BEGIN
        vc_radek := '';
        FOR pole IN (SELECT znak_pole(info_mina, zobrazeno) AS field FROM sem_pole WHERE oblast = an_id_oblast AND y = an_radek)
        LOOP
            vc_radek := vc_radek || ' ' || pole.field;
        END LOOP;
        RETURN vc_radek;
    END;
    
    PROCEDURE OBLAST_TISK (an_id_oblast IN NUMBER)
    IS
        an_x_count NUMBER;
    BEGIN
        dbms_output.put_line('Stav oblasti ' || an_id_oblast || ':');
        SELECT sirka INTO an_x_count FROM sem_oblast WHERE id = an_id_oblast;
    
        FOR vn_index IN 1..an_x_count
        LOOP
            dbms_output.put_line(MINESWEEPER.RADEK_OBLASTI(an_id_oblast, vn_index));
        END LOOP;
    END;
    
    PROCEDURE TAH(an_id_oblast IN NUMBER
                    ,an_x IN NUMBER
                    ,an_y IN NUMBER)
    IS
        vn_pole_id NUMBER;
    BEGIN
        SELECT id 
        INTO vn_pole_id 
        FROM sem_pole 
        WHERE oblast = an_id_oblast
            AND x = an_x
            AND y = an_y;
           
        INSERT INTO sem_tah (pole) VALUES (vn_pole_id);
        
    EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line(SQLERRM);
    END TAH;
END;
/

