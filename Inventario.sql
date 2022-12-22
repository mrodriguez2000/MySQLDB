USE Inventarios;
CREATE TABLE Productos(
	IdProducto VARCHAR(5) PRIMARY KEY,
    NombreProducto VARCHAR(100) NOT NULL,
    CategoriaProducto VARCHAR(30),
    PrecioUnitario DOUBLE,
    Unidades INT NOT NULL
);

CREATE TABLE EntradaProducto(
	IdEntrada INT AUTO_INCREMENT PRIMARY KEY,
    FechaEntrada DATE NOT NULL,
    IdProducto VARCHAR(30) NOT NULL,
    UnidadesEntrantes INT,
    CONSTRAINT Fk_Entrada FOREIGN KEY(IdProducto) REFERENCES Productos(IdProducto)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE SalidaProductos(
	IdSalida INT AUTO_INCREMENT PRIMARY KEY,
    FechaSalida DATE NOT NULL,
    IdProducto VARCHAR(30) NOT NULL,
    CantidadSalida INT NOT NULL,
    CONSTRAINT Fk_Salida FOREIGN KEY(IdProducto) REFERENCES Productos(IdProducto)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Procedimiento que inserta productos
DELIMITER $$
	CREATE PROCEDURE InsertaProducto(CodigoProducto VARCHAR(30), Nombre VARCHAR(100), Categoria VARCHAR(30),
    PrecioProducto DOUBLE, Unidades INT)
		BEGIN
			INSERT INTO productos
            (IdProducto, NombreProducto, CategoriaProducto, PrecioUnitario, UnidadesExistencias)
            VALUES
            (CodigoProducto, Nombre, Categoria, PrecioProducto, Unidades);
        END $$
DELIMITER ;

-- Procedimiento que elimina productos
DELIMITER $$
	CREATE PROCEDURE EliminaProducto(ID VARCHAR(30))
		BEGIN
			DELETE FROM Productos WHERE IdProducto = ID;
        END $$
DELIMITER ;

-- Procedimiento que inserta registros en la tabla de entrada de productos
DELIMITER $$
	CREATE PROCEDURE InsertaEntrada(IdEntrada INT, FechaEntrada Date, IdProducto VARCHAR(30), UnidadesEntrantes INT)
    BEGIN
		INSERT INTO entradaproducto
        VALUES
        (IdEntrada, FechaEntrada, IdProducto, UnidadesEntrantes);
    END $$
DELIMITER ;

-- Procedimiento que inserta registros en la tabla de salida de productos
DELIMITER $$
	CREATE PROCEDURE InsertaSalida(IdSalida INT, FechaSalida Date, IdProducto VARCHAR(30), CantidadSalida INT)
    BEGIN
		INSERT INTO salidaproductos
        VALUES
        (IdSalida, FechaSalida, IdProducto, CantidadSalida);
    END $$
DELIMITER ;

-- Procedimiento que actualiza productos
DELIMITER $$
	CREATE PROCEDURE Actualiza(Id VARCHAR(30), Nombre VARCHAR(30), Precio DOUBLE)
		BEGIN
			CASE
				WHEN Nombre != "" AND Precio IS NOT NULL THEN UPDATE productos SET NombreProducto = Nombre 
				, PrecioUnitario = Precio WHERE IdProducto = Id;
                
				WHEN Nombre != "" AND Precio IS NULL THEN UPDATE productos SET NombreProducto = Nombre 
				WHERE IdProducto = Id;
                
				WHEN Nombre = "" AND Precio IS NOT NULL THEN UPDATE productos SET PrecioUnitario = Precio 
				WHERE IdProducto = Id;
				
                ELSE SELECT *FROM productos;
			END CASE;
		END; $$
DELIMITER ;

SELECT salidaproductos.IdProducto, productos.NombreProducto FROM salidaproductos INNER JOIN productos 
ON salidaproductos.IdProducto = productos.IdProducto HAVING SUM(salidaproductos.CantidadSalida) > 10;

SELECT DISTINCT CategoriaProducto FROM Productos;