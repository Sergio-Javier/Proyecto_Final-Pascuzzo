USE AUTOBATTLER;

-- Primer vista
-- crear una vista para ver los datos de los usuarios y sus tiempos de partida
-- y composiciones segun el registro de partidas
DROP VIEW IF EXISTS vw_date_reg;
CREATE VIEW vw_date_reg AS
SELECT
    r.ID_REG,
    u.NICK,
    p.TIEMPO_DE_PARTIDA,
    e.UNIDADES_COMPRADAS
FROM
    REGISTRO_DE_PARTIDA AS r
    JOIN USUARIO AS u ON r.ID_USER = u.ID_USER
    JOIN PARTIDA AS p ON r.ID_SALA = p.ID_SALA
    JOIN ESTADISTICAS AS e ON p.ID_ESTADISTICA = e.ID_ESTADISTICA;


-- Segunda vista:
-- contar cuantas patidas tiene cada usuario
DROP VIEW IF EXISTS vw_user_count_party;
CREATE VIEW vw_user_count_party AS
SELECT
    u.ID_USER,
    u.NICK,
    COUNT(r.ID_REG) AS total_partidas
FROM
    USUARIO AS u
    LEFT JOIN REGISTRO_DE_PARTIDA AS r ON u.ID_USER = r.ID_USER
GROUP BY
    u.ID_USER, u.NICK;

-- tercer vista:
-- ver que facturas tiene cada usuario y el monto total gastado.
DROP VIEW IF EXISTS vw_compras_de_user;
CREATE VIEW vw_compras_de_user AS
SELECT
    ID_USER,
    GROUP_CONCAT(ID_TRANSACCION) AS NRO_FACTURAS,
    SUM(TOTAL_PAGAR) AS TOTAL_ABONADO
FROM
    FACTURA
GROUP BY
    ID_USER;


-- cuarta vista:
-- ver los modos de juegos usados por los user, segun el registro de partida.
DROP VIEW IF EXISTS vw_modos_jugados;
CREATE VIEW vw_modos_jugados AS
SELECT
r.ID_REG,
r.FECHA_HORA,
r.ID_USER,
p.ID_SALA,
p.ID_MODO,
m.TIPO_MODO
FROM PARTIDA AS p 
	JOIN REGISTRO_DE_PARTIDA AS r 
		ON r.ID_REG = p.ID_SALA
	LEFT JOIN MODO_DE_JUEGO AS m 
		ON m.TIPO_MODO = p.ID_MODO;

-- Quinta vista.
-- Para esta viste se tuvo que crear una tabla, para poder contar la cantidad de id de las unidades que mas utilizan
--los jugadores. Emplee la ayuda de IA, pero se modifico para que funcionara de forma correcta.
-- Ademas, esta tabla con los numeros de los id, puede ser modificada con un triggers, cada vez que se
-- cree una unidad para el juego, el trigger haria un insert into en la tabla NUMBERS.
-- Solo se creo la tabla para facilitar el conteo de las unidades mas compradas,
-- almacenado en la tabla ESTADISTICAS.

DROP TABLE IF EXISTS NUMBERS;
CREATE TABLE NUMBERS (id_unid INT);
INSERT INTO NUMBERS (id_unid) VALUES
(1), (2), (3), (4), (5), (6), (7), (8), (9), (10),
(11), (12), (13), (14), (15), (16), (17), (18), (19), (20),
(21), (22), (23), (24);

DROP VIEW IF EXISTS vw_unidades_mas_usadas;
CREATE VIEW vw_unidades_mas_usadas AS
SELECT 
	id_unid, COUNT(*) AS CANT_DE_USOS
FROM 
	(SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(e.UNIDADES_COMPRADAS, ',', n.id_unid), ',', -1) AS id_unid
		FROM ESTADISTICAS AS e
			JOIN NUMBERS AS n ON FIND_IN_SET(n.id_unid, e.UNIDADES_COMPRADAS)
	) AS ext_nro
GROUP BY id_unid
ORDER BY CANT_DE_USOS DESC;