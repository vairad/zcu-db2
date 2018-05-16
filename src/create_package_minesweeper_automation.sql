/*<TOAD_FILE_CHUNK>*/
-- =======================================
--  Package, která obstarává automatické události vyvolané triggery nebo uživatelem.
--
-- @author Radek Vais
-- @version 23.3.2018
-- =======================================

CREATE OR REPLACE PACKAGE VAISR.MINESWEEPER_AUTOMATION
AS

    PROCEDURE ZAMINUJ_OBLAST( an_id_oblast IN NUMBER
                            , an_sirka NUMBER
                            , an_vyska NUMBER
                            , an_miny NUMBER);
    
    PROCEDURE SPOCITEJ_OBLAST( an_id_oblast IN NUMBER);
    
    PROCEDURE VYTVOR_HRU( an_id_oblast IN NUMBER);
    
    FUNCTION SPOCITEJ_POLE(  an_id_oblast IN NUMBER
                                ,an_x       IN NUMBER
                                ,an_y     IN NUMBER)
        RETURN NUMBER;
    
    
    FUNCTION VYTVOR_POLE(an_id_oblast IN NUMBER
                    , an_sirka IN NUMBER
                    , an_vyska IN NUMBER
                    )
        RETURN NUMBER;
    
    PROCEDURE ODKRYJ_POLE(an_pole_id IN NUMBER);
    
    PROCEDURE VYHRA(an_oblast_id IN NUMBER);
    
    PROCEDURE PROHRA(an_oblast_id IN NUMBER);
    
    PROCEDURE ZOBRAZ_OBLAST(an_oblast_id IN NUMBER);
    
    PROCEDURE OZNAC_MINY(an_oblast_id IN NUMBER);
    
    FUNCTION MNOHO_MIN(an_pole_id IN NUMBER)
        RETURN NUMBER;
    
    PROCEDURE UKONCENA_HRA(an_pole_id IN NUMBER);
    
    FUNCTION VYTVOR_VLASTNI_OBLAST(an_sirka IN NUMBER
                                    ,an_vyska IN NUMBER
                                    ,an_miny IN NUMBER)
        RETURN NUMBER;  
    
    PROCEDURE SPATNY_PARAMETR(an_sirka IN NUMBER
                                ,an_vyska IN NUMBER
                                ,an_miny IN NUMBER); 
        
    
END MINESWEEPER_AUTOMATION;
/

/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PACKAGE BODY VAISR.MINESWEEPER_AUTOMATION
AS     
        
    PROCEDURE ZAMINUJ_OBLAST(an_id_oblast NUMBER, an_sirka NUMBER, an_vyska NUMBER, an_miny NUMBER)
    IS
        vn_x NUMBER;
        vn_y NUMBER;
        vn_placed NUMBER;
    BEGIN        
        vn_placed := 0;
        
        dbms_output.put_line('Pokládám ' || an_miny || ' min do oblasti: ' || an_id_oblast);
        
        WHILE an_miny > vn_placed
        LOOP
            vn_x := ROUND(DBMS_RANDOM.VALUE( 1 , an_sirka));
            vn_y := ROUND(DBMS_RANDOM.VALUE( 1 , an_vyska));
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
        dbms_output.put_line('Poèítám oblast: ' || an_id_oblast);
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
    END VYTVOR_POLE;
    
    PROCEDURE VYTVOR_HRU( an_id_oblast IN NUMBER)
    IS
    BEGIN
        dbms_output.put_line('Vytváøím záznam hry pro oblast: ' || an_id_oblast);
        INSERT INTO sem_hra (id, oblast, stav) VALUES (seq_sem_hra_id.nextval, an_id_oblast, 1);
    END VYTVOR_HRU;
    
    PROCEDURE ODKRYJ_POLE(an_pole_id IN NUMBER)
    IS
        vn_miny NUMBER;
        vn_oblast NUMBER;
        vn_x NUMBER;
        vn_y NUMBER;
    BEGIN
        UPDATE sem_pole SET zobrazeno = 1 WHERE id = an_pole_id;
        SELECT info_mina, oblast, x, y INTO vn_miny, vn_oblast, vn_x, vn_y FROM sem_pole WHERE id = an_pole_id;
        IF vn_miny = 0 THEN
            FOR pole IN ( SELECT info_mina, id 
                                FROM sem_pole 
                                WHERE x IN (vn_x - 1, vn_x , vn_x + 1) and y IN (vn_y - 1, vn_y , vn_y + 1) 
                                AND oblast = vn_oblast
                                AND zobrazeno = 0)
            LOOP
                ODKRYJ_POLE(pole.id);
            END LOOP;
        END IF;
    END ODKRYJ_POLE;
    
    
    PROCEDURE VYHRA(an_oblast_id IN NUMBER)
    IS
        an_miny NUMBER  ;
        an_pole NUMBER ;
        an_slapnute NUMBER;
    BEGIN
        --dbms_output.put_line('Kontroluji vítìzství.');
        SELECT COUNT(id) INTO an_slapnute FROM sem_pole 
            WHERE oblast = an_oblast_id AND info_mina <> 9
              AND zobrazeno = 1;
    
        SELECT (sirka * vyska), miny INTO an_pole, an_miny FROM sem_oblast
          WHERE id = an_oblast_id;
          
        IF (an_pole - an_slapnute) = an_miny THEN
            
            -- uprav záznam o høe pro danou oblast, pokud je nová nebo rozehraná.
            UPDATE sem_hra SET stav = 3, konec = sysdate WHERE oblast = an_oblast_id AND stav = 1 OR stav = 2;
            IF sql%rowcount > 0 THEN
                dbms_output.put_line('Vítìzství!');
            END IF;

            MINESWEEPER_AUTOMATION.ZOBRAZ_OBLAST(an_oblast_id);
            MINESWEEPER_AUTOMATION.OZNAC_MINY(an_oblast_id);
            
        END IF;
    END VYHRA;
    
    
    PROCEDURE PROHRA(an_oblast_id IN NUMBER)
    IS
        an_miny NUMBER  ;
        an_pole NUMBER ;
        an_slapnute NUMBER;
    BEGIN
        --dbms_output.put_line('Kontroluji prohru');
        SELECT COUNT(id) INTO an_slapnute FROM sem_pole 
            WHERE oblast = an_oblast_id AND info_mina = 9
              AND zobrazeno = 1;
                        
        IF (an_slapnute > 0) THEN
            -- uprav záznam o høe pro danou oblast, pokud je nová nebo rozehraná.
            UPDATE sem_hra SET stav = 4, konec = sysdate WHERE oblast = an_oblast_id AND stav = 1 OR stav = 2;
            IF sql%rowcount > 0 THEN
                dbms_output.put_line('Šlápl jsi na minu! Prohra.');
            END IF;
            
           -- MINESWEEPER_AUTOMATION.ZOBRAZ_OBLAST(an_oblast_id);
            
        END IF;
    END PROHRA;
    
    PROCEDURE ZOBRAZ_OBLAST(an_oblast_id IN NUMBER)
    IS
    BEGIN
        UPDATE sem_pole SET zobrazeno = 1 WHERE oblast = an_oblast_id;
    END ZOBRAZ_OBLAST;
    
    PROCEDURE OZNAC_MINY(an_oblast_id IN NUMBER)
    IS
    BEGIN
        FOR mina IN (SELECT id FROM sem_pole WHERE oblast = an_oblast_id AND info_mina = 9)
        LOOP
            BEGIN
                INSERT INTO sem_mina(pole) VALUES (mina.id);
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
                CONTINUE;
            END;
        END LOOP;
    END OZNAC_MINY;
    
    
    FUNCTION MNOHO_MIN(an_pole_id IN NUMBER)
    RETURN NUMBER
    IS
        vn_vlajky NUMBER;
        vn_miny NUMBER;
    BEGIN
        SELECT COALESCE(h.pocet_vlajek,0) , COALESCE(o.miny,0)
        INTO vn_vlajky, vn_miny
        FROM sem_hra h
        LEFT JOIN sem_oblast o ON h.oblast = o.id
        LEFT JOIN sem_pole p ON o.id = p.oblast
        WHERE p.id = an_pole_id; 
        
        RETURN vn_miny - vn_vlajky;
    END MNOHO_MIN;
    
    PROCEDURE UKONCENA_HRA(an_pole_id IN NUMBER)
    IS
        vn_stav NUMBER;
    BEGIN
        SELECT h.stav
        INTO vn_stav
        FROM sem_hra h
        LEFT JOIN sem_oblast o ON h.oblast = o.id
        LEFT JOIN sem_pole p ON o.id = p.oblast
        WHERE p.id = an_pole_id; 
        
        IF(vn_stav > 2) THEN
            raise_application_error (-20004, 'Hra byla již uzavøena.');
        END IF;
        
    END UKONCENA_HRA;
    
    FUNCTION VYTVOR_VLASTNI_OBLAST(an_sirka IN NUMBER
                                    ,an_vyska IN NUMBER
                                    ,an_miny IN NUMBER)
    RETURN NUMBER
    IS
        vn_id_oblast NUMBER;
    BEGIN
        vn_id_oblast := seq_sem_oblast_id.nextval();
        
        INSERT INTO sem_oblast (id, sirka, vyska, miny)
        VALUES(vn_id_oblast, an_sirka, an_vyska, an_miny);
        
        RETURN vn_id_oblast;
    END VYTVOR_VLASTNI_OBLAST;
     
    
    PROCEDURE SPATNY_PARAMETR(an_sirka IN NUMBER
                        ,an_vyska IN NUMBER
                        ,an_miny IN NUMBER)
    IS
        vn_value NUMBER;
    BEGIN
    
    --sirka max
       SELECT COALESCE(n_value, 100) INTO vn_value FROM sem_omezeni WHERE name = 'max_sirka' ;
            IF (an_sirka > vn_value) THEN
                raise_application_error (-20006, 'Obtížnost pøekrèuje maximální šíøku.'); 
            END IF;
    --sirka min
        SELECT COALESCE(n_value, 1) INTO vn_value FROM sem_omezeni WHERE name = 'min_sirka' ;
            IF (an_sirka < vn_value) THEN
                raise_application_error (-20007, 'Obtížnost pøekrèuje minimální šíøku.'); 
            END IF;
    --vyska
        SELECT COALESCE(n_value, 100) INTO vn_value FROM sem_omezeni WHERE name = 'max_vyska' ;
            IF (an_vyska > vn_value) THEN
                raise_application_error (-20008, 'Obtížnost pøekrèuje maximální výšku.'); 
            END IF;
       
        SELECT COALESCE(n_value, 1) INTO vn_value FROM sem_omezeni WHERE name = 'min_vyska' ;
            IF (an_vyska < vn_value) THEN
                raise_application_error (-20009, 'Obtížnost pøekrèuje minimální výšku.'); 
            END IF;
    --pocet min
        SELECT COALESCE(n_value, 1) INTO vn_value FROM sem_omezeni WHERE name = 'min_miny' ;
            IF (an_miny < vn_value) THEN
                raise_application_error (-20010, 'Obtížnost obsahuje málo min.'); 
            END IF;
            
        SELECT COALESCE(n_value, 10) INTO vn_value FROM sem_omezeni WHERE name = 'p_miny' ;
            IF (an_miny > (vn_value * an_sirka * an_vyska / 100 )) THEN
                raise_application_error (-20010, 'Obtížnost obsahuje mnoho min.'); 
            END IF;
    END;                            


END MINESWEEPER_AUTOMATION;
/

