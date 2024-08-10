USE AUTOBATTLER;

-- CREAREMOS DOS ROLES:
DROP ROLE IF EXISTS profesor , tutor;
CREATE ROLE profesor , tutor;

-- OTORGAREMOS LOS PERMISOS
GRANT ALL ON AUTOBATTLER.* TO profesor;
GRANT SELECT, INSERT, UPDATE, DELETE ON AUTOBATTLER.* TO tutor;


-- CREAREMOS USUARIOS
DROP  USER IF EXISTS 'p_anderson'@'%' , 't_ariel'@'%';

-- proferor
CREATE USER 'p_anderson'@'%' IDENTIFIED BY 'anderson123';

-- tutor
CREATE USER 't_ariel'@'%' IDENTIFIED BY 'annone123';


-- OTORGARLES ROLES
GRANT profesor TO 'p_anderson'@'%' ;
GRANT tutor TO 't_ariel'@'%';

SET DEFAULT ROLE profesor TO 'p_anderson'@'%';
SET DEFAULT ROLE tutor TO 't_ariel'@'%';
FLUSH PRIVILEGES;

-- VERIFICACION DE PERMISOS

SHOW GRANTS FOR 'p_anderson'@'%';
SHOW GRANTS FOR 't_ariel'@'%';