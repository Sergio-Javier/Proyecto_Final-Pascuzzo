USE AUTOBATTLER;

-- BORRAMOS SI EXISTE LOS PROCEDIMIENTOS
DROP PROCEDURE IF EXISTS sp_rango_user;
DROP PROCEDURE IF EXISTS delete_user;

DELIMITER //
-- CREAMOS NUESTRO PRIMER PROCEDIMIENTO
CREATE PROCEDURE sp_rango_user(IN p_id_user INT, OUT p_nick VARCHAR(100), OUT p_nombre_rango VARCHAR(50))
BEGIN
    DECLARE puntaje INT;
-- LLEVAMOS LOS DATOS A LAS VARIABLES
    SELECT u.NICK, u.PUNTOS_CLASIF INTO p_nick, puntaje
    FROM USUARIO AS u
    WHERE u.ID_USER = p_id_user;

-- Si el ID_USER no existe en la base de datos
    IF p_nick IS NULL THEN
        SET p_nombre_rango = 'USUARIO NO ENCONTRADO';
    ELSE
-- Determino los nombres de rangos segun los puntos a comparar en la variable puntaje
        IF puntaje BETWEEN 0 AND 9 THEN
            SET p_nombre_rango = 'BRONCE';
        ELSEIF puntaje BETWEEN 10 AND 29 THEN
            SET p_nombre_rango = 'PLATA';
        ELSEIF puntaje BETWEEN 30 AND 59 THEN
            SET p_nombre_rango = 'ORO';
        ELSEIF puntaje BETWEEN 60 AND 89 THEN
            SET p_nombre_rango = 'DIAMANTE';
        ELSEIF puntaje >= 90 THEN
            SET p_nombre_rango = 'PLATINO';
        END IF;
    END IF;

END //

DELIMITER ;


DELIMITER //

-- CREAMOS NUESTRO SEGUNDO PROCEDIMIENTO
CREATE PROCEDURE delete_user (IN d_id_user INT)
BEGIN

    -- DECLARAMOS LAS SIGUIENTES VARIABLES
    DECLARE existe_id INT;
    DECLARE level_id INT;
    DECLARE id VARCHAR(100);

    -- INICIAR TRANSACCION Y DESACTIVAR AUTOCOMMIT
    START TRANSACTION;

    -- CORROBORAMOS SI EL ID EXISTE CON LA VARIABLE existe_id
    SET existe_id = (SELECT count(ID_USER) FROM USUARIO WHERE ID_USER = d_id_user);

    -- SI EXISTE, BORRAR EL ID
    IF existe_id > 0 THEN
        
        -- OBTENEMOS EL NIVEL DEL USUARIO
        SET level_id = (SELECT nivel_user FROM USUARIO WHERE ID_USER = d_id_user);

        -- BORRAR EL USUARIO
        DELETE FROM USUARIO WHERE ID_USER = d_id_user;

        -- SI EL NIVEL DEL USUARIO ES MAYOR A 10, HACER ROLLBACK
        IF level_id > 10 THEN 
            ROLLBACK;
            SET id = 'Transaccion revertida: Nivel de usuario mayor a 10';
        ELSE
            COMMIT;
            SET id = CONCAT(d_id_user, ' - ID Borrado con Exito');
        END IF;

    ELSE
        -- SI NO SE ENCUENTRA EL USUARIO, ARROJAR MENSAJE DE ERROR
        SET id = 'Usuario no encontrado';
    END IF;

    -- MOSTRAR EL ESTADO DEL BORRADO
    SELECT id AS Estado_de_borrado;

END //

DELIMITER ;
