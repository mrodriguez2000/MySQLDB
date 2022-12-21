Use registros;
-- Procedimiento que actualiza el saldo de los usuarios
DELIMITER $$
	CREATE PROCEDURE ActualizaSaldo(SaldoIngresado INT, Identificacion INT)
		BEGIN
			UPDATE usuarios SET Saldo = SaldoIngresado WHERE IdUsuario = Identificacion;
        END; $$
DELIMITER ;

-- Procedimiento que se encarga de calcular el tiempo en años que lleva un usuario
DELIMITER $$
CREATE PROCEDURE ConsultaTiempo()
	BEGIN
		DECLARE FechaActual DATETIME DEFAULT NOW();
        SELECT Nombre, Saldo, FechaVinculacion, TIMESTAMPDIFF(YEAR, FechaVinculacion, FechaActual)
        AS TiempoTotal FROM usuarios;
    END; $$
DELIMITER ;

-- Se crea una nueva tabla que registra nuevos usuarios. Posteriormente se va a hacer un trigger que va a insertar datos en la nueva tabla
CREATE TABLE UsuariosRegistrados(
	IdUsuario INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(30) NOT NULL,
    Saldo DOUBLE,
    Insertado DATETIME
);

-- Trigger que inserta nuevos usuarios en la tabla UsuariosRegistrados, después de agregar nuevos usuarios en la tabla de usuarios
CREATE TRIGGER Usuarios_AI AFTER INSERT ON usuarios FOR EACH ROW
INSERT INTO usuariosregistrados
VALUES
(NEW.IdUsuario, NEW.Nombre, NEW.Saldo, NOW());

SELECT *FROM usuariosregistrados;

-- Procedimiento que se encarga de realizar operación de ingresar o retirar saldo, ingresando algunos parametros
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

SELECT *FROM usuarios;

SELECT AVG(Saldo) FROM usuarios;
-- Subconsulta que retorna algunos datos de los usuarios, cuyo saldo sea mayor al saldo promedio
SELECT Nombre, Telefono, Saldo FROM usuarios WHERE Saldo > (SELECT AVG(Saldo) AS Promedio FROM usuarios);

-- El siguiente trigger va a realizar la siguiente instrucción antes de actualizar el saldo de un usuario:
-- 1. Si un usuario desea retirar, sin embargo, la cantidad ingresada es mayor que el saldo del usuario. Si se cumple esa condición, el saldo no va a ser actualizado
-- 2. Si la primera condición no es verdadera, se actualizará el valor del saldo

DELIMITER $$
CREATE TRIGGER Actualiza_BU BEFORE UPDATE ON usuarios FOR EACH ROW
IF NEW.Saldo < 0 THEN SET NEW.Saldo = OLD.Saldo;
END IF;
$$