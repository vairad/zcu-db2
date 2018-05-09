-- =======================================
--
--
-- @author Radek Vais
-- @version 23.3.2018
-- =======================================

CREATE OR REPLACE PACKAGE VAISR.MINESWEEPER
AS
    PROCEDURE VYTVOR_HRU(an_id_obtiznost INTEGER);
END;
/

CREATE OR REPLACE PACKAGE BODY VAISR.MINESWEEPER
AS

    PROCEDURE VYTVOR_HRU(an_id_obtiznost INTEGER)
    IS
        vn_id_oblast INTEGER;
    BEGIN
       vn_id_oblast := MINESWEEPER_AUTOMATION.VYTVOR_OBLAST(an_id_obtiznost);
    END;
    
END;
/