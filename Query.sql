Use registros;
DELIMITER $$
	CREATE PROCEDURE ActualizaSaldo(SaldoIngresado INT, Identificacion INT)
		BEGIN
			UPDATE usuarios SET Saldo = SaldoIngresado WHERE IdUsuario = Identificacion;
        END; $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE ConsultaTiempo()
	BEGIN
		DECLARE FechaActual DATETIME DEFAULT NOW();
        SELECT Nombre, Saldo, FechaVinculacion, TIMESTAMPDIFF(YEAR, FechaVinculacion, FechaActual)
        AS TiempoTotal FROM usuarios;
    END; $$
DELIMITER ;
CREATE TABLE UsuariosRegistrados(
	IdUsuario INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(30) NOT NULL,
    Saldo DOUBLE,
    Insertado DATETIME
);

CREATE TRIGGER Usuarios_AI AFTER INSERT ON usuarios FOR EACH ROW
INSERT INTO usuariosregistrados
VALUES
(NEW.IdUsuario, NEW.Nombre, NEW.Saldo, NOW());

SELECT *FROM usuariosregistrados;

DELIMITER $$
	CREATE PROCEDURE RealizarOperacion(Operacion VARCHAR(20), ID INT, Aumento_Disminucion INT)
    BEGIN
		CASE
			WHEN Operacion = "Ingresar" THEN UPDATE usuarios 
            SET Saldo = Saldo + Aumento_Disminucion WHERE IdUsuario = ID;
            WHEN Operacion = "Retirar" THEN UPDATE usuarios 
            SET Saldo = Saldo - Aumento_Disminucion WHERE IdUsuario = ID;
        END CASE;
    END; $$
DELIMITER ;
DROP PROCEDURE RealizarOperacion;
SELECT *FROM usuarios;

SELECT AVG(Saldo) FROM usuarios;
SELECT Nombre, Telefono, Saldo FROM usuarios WHERE Saldo > (SELECT AVG(Saldo) AS Promedio FROM usuarios);

DELIMITER $$
CREATE TRIGGER Actualiza_BU BEFORE UPDATE ON usuarios FOR EACH ROW
IF NEW.Saldo < 0 THEN SET NEW.Saldo = OLD.Saldo;
END IF;
$$