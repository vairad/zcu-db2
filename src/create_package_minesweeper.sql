/*<TOAD_FILE_CHUNK>*/
-- =======================================
--
--
-- @author Radek Vais
-- @version 23.3.2018
-- =======================================

CREATE OR REPLACE PACKAGE VAISR.MINESWEEPER
AS
    PROCEDURE VYTVOR_HRU(an_id_obtiznost INTEGER);
    FUNCTION RADEK_OBLASTI (an_id_oblast IN INTEGER
                            , an_radek IN INTEGER)
        RETURN VARCHAR2;
    PROCEDURE OBLAST_TISK (an_id_oblast IN INTEGER);
END;
/

/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE BODY VAISR.MINESWEEPER
AS

    PROCEDURE VYTVOR_HRU(an_id_obtiznost INTEGER)
    IS
        vn_id_oblast INTEGER;
    BEGIN
       vn_id_oblast := MINESWEEPER_AUTOMATION.VYTVOR_OBLAST(an_id_obtiznost);
       MINESWEEPER_AUTOMATION.ZAMINUJ_OBLAST(vn_id_oblast);
       MINESWEEPER_AUTOMATION.SPOCITEJ_OBLAST(vn_id_oblast);
       COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK;
    END;
    
    FUNCTION RADEK_OBLASTI (an_id_oblast IN INTEGER
                            , an_radek IN INTEGER)
    RETURN VARCHAR2
    IS
     vc_radek VARCHAR2(1024);
    BEGIN
        vc_radek := '';
        FOR pole IN (SELECT info_mina FROM sem_pole WHERE oblast = an_id_oblast AND y = an_radek)
        LOOP
            vc_radek := vc_radek || ' ' || pole.info_mina;
        END LOOP;
        RETURN vc_radek;
    END;
    
    PROCEDURE OBLAST_TISK (an_id_oblast IN INTEGER)
    IS
        an_x_count NUMBER;
    BEGIN
        SELECT sirka INTO an_x_count FROM sem_oblast WHERE id = an_id_oblast;
    
        FOR vn_index IN 1..an_x_count
        LOOP
            dbms_output.put_line(MINESWEEPER.RADEK_OBLASTI(an_id_oblast, vn_index));
        END LOOP;
    END;
END;
/

