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
GROUP_CONCAT (ID_TRANSACCION) AS FACTURAS,
SUM (TOTAL_PAGAR) AS TOTAL_ABONADO
FROM FACTURA
GROUP BY ID_USER;


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