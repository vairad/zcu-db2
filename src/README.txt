-- Vhodné poøadí spuštìní souborù pro deployment databázové logiky
--
-- @autor Radek Vais

-- create data entities

create_table_obtiznost.sql
create_table_omezeni.sql
create_table_stav.sql
create_table_oblast.sql
create_table_pole.sql
create_table_mina.sql
create_table_tah.sql
create_table_hra.sql

--create views

create_view_chybne_miny.sql
create_view_vitezove.sql
create_view_porazeni.sql


-- create package for automatic events

create_package_minesweeper_automation.sql


--create special triggers

create_creation_triggers.sql

create_view_chybne_miny.sql


-- create gaming package

create_package_minesweeper.sql
