-- =======================================
-- Každá vlastní obtížnost musí splňovat jistá omezení. Např. počet 
-- řádků či sloupců nesmí být menší než 9 a větší než 100. Také je
-- vhodné pohlídat, aby počet rozmístěných min v zaminované oblasti
-- nebyl příliš velký, např. nepřekročil 40 procent její velikosti.
--
-- @author Radek Vais
-- @version 23.3.2018
-- =======================================

--DROP TABLE sem_omezeni;

CREATE TABLE sem_omezeni(
    id NUMBER (10) PRIMARY KEY,
    name VARCHAR2(50) NOT NULL,
    n_value NUMBER(10),
    c_value VARCHAR2(50)
)
;

COMMENT ON TABLE sem_omezeni IS 'Každá vlastní obtížnost musí splňovat jistá omezení. Např. počet řádků či sloupců nesmí být menší než 9 a větší než 100. Také jevhodné pohlídat, aby počet rozmístěných min v zaminované oblastinebyl příliš velký, např. nepřekročil 40 procent její velikosti.';

COMMENT ON COLUMN sem_omezeni.id IS 'ID omezení.';

COMMENT ON COLUMN sem_omezeni.name IS 'Textový název omezení.';

COMMENT ON COLUMN sem_omezeni.n_value IS 'Numerická hodnota.';

COMMENT ON COLUMN sem_omezeni.c_value IS 'Textová hodnota.';


-- =============================================================================
-- Výchozí data číselníku
--

INSERT INTO sem_omezeni(id, name, n_value) VALUES (1, 'max_sirka', 100);

INSERT INTO sem_omezeni(id, name, n_value) VALUES (2, 'max_vyska', 100);

INSERT INTO sem_omezeni(id, name, n_value) VALUES (3, 'min_sirka', 9);

INSERT INTO sem_omezeni(id, name, n_value) VALUES (4, 'min_vyska', 9);

INSERT INTO sem_omezeni(id, name, n_value) VALUES (5, 'min_miny', 1);

INSERT INTO sem_omezeni(id, name, n_value) VALUES (6, 'p_miny', 40);
