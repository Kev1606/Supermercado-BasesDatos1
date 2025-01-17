CREATE DATABASE IF NOT EXISTS SUPERMERCADO;
SET GLOBAL LOG_BIN_TRUST_FUNCTION_CREATORS = 1;
use supermercado;

CREATE TABLE `PAIS` (
  `Cod_Pais` INT NOT NULL UNIQUE,
  `Nombre_Pais` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`Cod_Pais`)
);

CREATE TABLE `PROVINCIA` (
  `Cod_Provincia` INT NOT NULL UNIQUE,
  `Nombre_Provincia` VARCHAR(40) NOT NULL,
  `Cod_Pais` INT NOT NULL,
  PRIMARY KEY (`Cod_Provincia`),
  FOREIGN KEY (`Cod_Pais`) REFERENCES `PAIS`(`Cod_Pais`)
);

CREATE TABLE `CIUDAD` (
  `Cod_Ciudad` INT NOT NULL UNIQUE,
  `Nombre_Ciudad` VARCHAR(40) NOT NULL,
  `Cod_Provincia` INT NOT NULL,
  PRIMARY KEY (`Cod_Ciudad`),
  FOREIGN KEY (`Cod_Provincia`) REFERENCES `PROVINCIA`(`Cod_Provincia`)
);

CREATE TABLE `SUCURSAL` (
  `Cod_Sucursal` INT NOT NULL UNIQUE,
  `Nombre_Sucursal` VARCHAR(40) NOT NULL,
  `Cod_Ciudad` INT NOT NULL,
  PRIMARY KEY (`Cod_Sucursal`),
  FOREIGN KEY (`Cod_Ciudad`) REFERENCES `CIUDAD`(`Cod_Ciudad`)
);

CREATE TABLE `SEXO` (
  `Cod_Sexo` INT NOT NULL UNIQUE,
  `Descrip_Sexo` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`Cod_Sexo`)
);

CREATE TABLE `PERSONA` (
  `Identificacion_Per` INT NOT NULL UNIQUE,
  `Nombre` VARCHAR(30) NOT NULL,
  `Apellidos` VARCHAR(30) NOT NULL,
  `Fecha_Nacimiento` DATE NOT NULL,
  `Direccion_Residencia` VARCHAR(20) NOT NULL,
  `Cod_Sexo` INT NOT NULL,
  `Cod_Ciudad` INT NOT NULL,
  FOREIGN KEY (`Cod_Sexo`) REFERENCES `SEXO`(`Cod_Sexo`),
  FOREIGN KEY (`Cod_Ciudad`) REFERENCES `CIUDAD`(`Cod_Ciudad`)
);

CREATE TABLE `PUESTO_LABORAL` (
  `Cod_Puesto_Laboral` INT NOT NULL UNIQUE,
  `Descrip_Pues_Lab` VARCHAR(30) NOT NULL,
  `Salario_Mensual` FLOAT  NOT NULL,
  PRIMARY KEY (`Cod_Puesto_Laboral`)
);

CREATE TABLE `EMPLEADO` (
  `Cod_Empleado` INT NOT NULL UNIQUE,
  `Fecha_Contratado` DATE NOT NULL,
  `Horas_Laborales` FLOAT NOT NULL,
  `Cod_Sucursal` INT NOT NULL,
  `Cod_Puesto_Laboral` INT NOT NULL,
  `Identificacion_Per` INT NOT NULL UNIQUE,
  PRIMARY KEY (`Cod_Empleado`),
  FOREIGN KEY (`Cod_Puesto_Laboral`) REFERENCES `PUESTO_LABORAL`(`Cod_Puesto_Laboral`),
  FOREIGN KEY (`Cod_Sucursal`) REFERENCES `SUCURSAL`(`Cod_Sucursal`)
);

CREATE TABLE `TIPO_USUARIO` (
  `Cod_Tipo_Usuario` INT NOT NULL UNIQUE,
  `Descrip_TipUsu` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`Cod_Tipo_Usuario`)
);

CREATE TABLE `USUARIO` (
  `Cod_Usuario` INT NOT NULL UNIQUE,
  `Nombre_Usuario` VARCHAR(20) NOT NULL,
  `Contraseña` VARCHAR(20) NOT NULL,
  `CorreoElec` VARCHAR(30) NOT NULL,
  `Cod_Tipo_Usuario` INT NOT NULL,
  `Identificacion_Per` INT NOT NULL UNIQUE,
  PRIMARY KEY (`Cod_Usuario`),
  FOREIGN KEY (`Cod_Tipo_Usuario`) REFERENCES `TIPO_USUARIO`(`Cod_Tipo_Usuario`)
);

CREATE TABLE `CLIENTE` (
  `Cod_Cliente` INT NOT NULL UNIQUE,
  `Cod_Usuario` INT NOT NULL UNIQUE,
  PRIMARY KEY (`Cod_Cliente`),
  FOREIGN KEY (`Cod_Usuario`) REFERENCES `USUARIO`(`Cod_Usuario`)
);

CREATE TABLE `PROVEEDOR` (
  `Cod_Proveedor` INT NOT NULL UNIQUE,
  `Nombre_Proveedor` VARCHAR(50) NOT NULL,
  `Porcentaje_Ganancia` FLOAT NOT NULL,
  `Cod_Ciudad` INT NOT NULL,
  PRIMARY KEY (`Cod_Proveedor`),
  FOREIGN KEY (`Cod_Ciudad`) REFERENCES `CIUDAD`(`Cod_Ciudad`)
);

CREATE TABLE `IMPUESTO` (
  `Cod_Impuesto` INT NOT NULL UNIQUE,
  `Porcentaje_Imp` FLOAT NOT NULL,
  `Descrip_Imp` VARCHAR(20) NOT NULL,
  KEY `ID` (`Cod_Impuesto`)
);

CREATE TABLE `TIPO_PRODUCTO` (
  `Cod_Tipo_Producto` INT NOT NULL UNIQUE,
  `Nombre_Tipo_Producto` VARCHAR(50) NOT NULL,
  `Descrip_Tipo_Producto` VARCHAR(30) NOT NULL,
  `Cod_Impuesto` INT NOT NULL,
  PRIMARY KEY (`Cod_Tipo_Producto`),
  FOREIGN KEY (`Cod_Impuesto`) REFERENCES `IMPUESTO`(`Cod_Impuesto`)
);

CREATE TABLE `PRODUCTO` (
  `Cod_Producto` INT NOT NULL UNIQUE,
  `Nombre_Producto` VARCHAR(50) NOT NULL,
  `Cod_Tipo_Producto` INT NOT NULL,
  `Cant_Minima` INT NOT NULL,
  `Cant_Maxima` INT NOT NULL,
  PRIMARY KEY (`Cod_Producto`),
  FOREIGN KEY (`Cod_Tipo_Producto`) REFERENCES `TIPO_PRODUCTO`(`Cod_Tipo_Producto`)
);

CREATE TABLE `TELEF_PERSO` (
  `Identificacion_Per` INT NOT NULL,
  `Num_Telef` VARCHAR(15)  NOT NULL,
  `Contador_Telef` INT AUTO_INCREMENT NOT NULL,
  PRIMARY KEY ( `Contador_Telef`),
  FOREIGN KEY (`Identificacion_Per`) REFERENCES `PERSONA`(`Identificacion_Per`)
);

CREATE TABLE `BODEGA_SUCURSAL_PRODUCTO` (
  `Cod_Bode_Sucu_Produ` INT NOT NULL AUTO_INCREMENT,
  `Cod_Producto` INT NOT NULL,
  `Cod_Sucursal` INT NOT NULL,
  `Precio_Compra` FLOAT NOT NULL,
  `Cod_Proveedor` INT NOT NULL,
  `Fecha_Compra` DATE NOT NULL,
  `Cantidad_Actual` INT NOT NULL,
  `Fecha_Produccion` DATE NOT NULL,
  `Fecha_Vencimiento` DATE NOT NULL,
  PRIMARY KEY (`Cod_Bode_Sucu_Produ`),
  FOREIGN KEY (`Cod_Producto`) REFERENCES `PRODUCTO`(`Cod_Producto`),
  FOREIGN KEY (`Cod_Sucursal`) REFERENCES `SUCURSAL`(`Cod_Sucursal`),
  FOREIGN KEY (`Cod_Proveedor`) REFERENCES `PROVEEDOR`(`Cod_Proveedor`)
);

CREATE TABLE `CRIPTOCARTERA` (
  `Cod_Cliente` INT NOT NULL,
  `Num_Cripto_Cartera` VARCHAR(25) NOT NULL,
  `Contador_CriptoCar` INT AUTO_INCREMENT NOT NULL,
  PRIMARY KEY (`Contador_CriptoCar`),
  FOREIGN KEY (`Cod_Cliente`) REFERENCES `CLIENTE`(`Cod_Cliente`)
);

CREATE TABLE `TARJETA_CREDITO` (
  `Cod_Cliente` INT NOT NULL,
  `Num_Tarjeta_Credito` VARCHAR(20) NOT NULL,
  `Contador_TarjCre` INT AUTO_INCREMENT NOT NULL,
  PRIMARY KEY (`Contador_TarjCre`),
  FOREIGN KEY (`Cod_Cliente`) REFERENCES `CLIENTE`(`Cod_Cliente`)
);

CREATE TABLE `CHEQUE` (
  `Cod_Cliente` INT NOT NULL,
  `Num_Cheque` VARCHAR(20) NOT NULL,
  `Contador_Cheque` INT AUTO_INCREMENT NOT NULL,
  PRIMARY KEY (`Contador_Cheque`),
  FOREIGN KEY (`Cod_Cliente`) REFERENCES `CLIENTE`(`Cod_Cliente`)
);

CREATE TABLE `BODEGA_PROVEEDOR_PRODUCTO` (
  `Cod_Bode_Provee_Produ` INT  NOT NULL AUTO_INCREMENT,
  `Cod_Proveedor` INT NOT NULL,
  `Cod_Producto` INT NOT NULL,
  `Precio_Venta` FLOAT NOT NULL,
  `Cantidad_En_Bodega` INT NOT NULL,
  `Fecha_Produccion` DATE NOT NULL,
  `Fecha_Vencimiento` DATE NOT NULL,
  PRIMARY KEY (`Cod_Bode_Provee_Produ`),
  FOREIGN KEY (`Cod_Proveedor`) REFERENCES `PROVEEDOR`(`Cod_Proveedor`),
  FOREIGN KEY (`Cod_Producto`) REFERENCES `PRODUCTO`(`Cod_Producto`)
);

CREATE TABLE `ESTADO_PEDIDO` (
  `ID_EstadoP` INT NOT NULL AUTO_INCREMENT,
  `Descripcion_EstadoP` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`ID_EstadoP`)
);

CREATE TABLE `PEDIDO` (
  `Num_Pedido` INT NOT NULL UNIQUE,
  `Fecha_Pedido` DATE NOT NULL,
  `Cod_Cliente` INT NOT NULL,
  `ID_EstadoP` INT NOT NULL,
  `Envio` BOOL NOT NULL,
  `Cod_Sucursal` INT NOT NULL,
  PRIMARY KEY (`Num_Pedido`),
  FOREIGN KEY (`Cod_Cliente`) REFERENCES `CLIENTE`(`Cod_Cliente`),
  FOREIGN KEY (`ID_EstadoP`) REFERENCES `ESTADO_PEDIDO`(`ID_EstadoP`),
  FOREIGN KEY (`Cod_Sucursal`) REFERENCES `SUCURSAL`(`Cod_Sucursal`)
);

CREATE TABLE `PEDIDO_PRODUCTO` (
  `Num_Pedido` INT NOT NULL,
  `Cod_Producto` INT NOT NULL,
  `Cantidad_Producto` INT NOT NULL,
  `Porcentaje_Desc`  FLOAT NOT NULL,
  `Motivo_Desc` VARCHAR(15),
  FOREIGN KEY (`Num_Pedido`) REFERENCES `PEDIDO`(`Num_Pedido`),
  FOREIGN KEY (`Cod_Producto`) REFERENCES `PRODUCTO`(`Cod_Producto`)
);

CREATE TABLE `FACTURA` (
  `Num_Factura` INT NOT NULL UNIQUE,
  `Fecha_Factura` DATE NOT NULL,
  `Cod_Cliente` INT NOT NULL,
  `Cod_Empleado` INT NOT NULL,
  `Metodo_Pago` VARCHAR(15) NOT NULL,
  `Num_Pedido` INT NOT NULL,
  PRIMARY KEY (`Num_Factura`),
  FOREIGN KEY (`Cod_Cliente`) REFERENCES `CLIENTE`(`Cod_Cliente`),
  FOREIGN KEY (`Cod_Empleado`) REFERENCES `EMPLEADO`(`Cod_Empleado`),
   FOREIGN KEY (`Num_Pedido`) REFERENCES `PEDIDO`(`Num_Pedido`)
);

CREATE TABLE `BONOS_EMPLEADO` (
  `Num_Bono` INT NOT NULL AUTO_INCREMENT,
  `Cod_Empleado` INT NOT NULL,
  `MontoBono` FLOAT NOT NULL,
  `Fecha_Bono` DATE NOT NULL,
  PRIMARY KEY (`Num_Bono`),
  FOREIGN KEY (`Cod_Empleado`) REFERENCES `EMPLEADO`(`Cod_Empleado`)
);

CREATE TABLE `PRODUCTO_EXPIRADO` (
	`Cod_Producto_Exp` INT NOT NULL AUTO_INCREMENT,
    `Cod_Producto` INT NOT NULL,
    `Cantidad_Productos` INT NOT NULL,
    `Cod_Bode_Sucu_Produ` INT NOT NULL,
    PRIMARY KEY (`Cod_Producto_Exp`),
    FOREIGN KEY (`Cod_Bode_Sucu_Produ`) REFERENCES `BODEGA_SUCURSAL_PRODUCTO`(`Cod_Bode_Sucu_Produ`)
);


/*----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------CRUDs----------------------------------------------------
-----------------------------------------------------------------------------------------------------------------*/

/*------------------------------------------------------------ PAIS ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_PAIS(pCodPais INT, pNombrePais VARCHAR(40), pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
	IF (pCodPais IS NOT NULL) THEN
    
		IF (pOperacion = 'CREATE') THEN
			IF ((SELECT COUNT(*) FROM PAIS WHERE Cod_Pais = pCodPais) = 0) THEN
				IF (pNombrePais != '' AND pNombrePais IS NOT NULL) THEN
					INSERT INTO PAIS(Cod_Pais,Nombre_Pais)
					VALUES(pCodPais,pNombrePais);
				ELSE
					SET msgError = 'El nombre del pais está vacío';
					SELECT msgError;
                END IF;
			ELSE
				SET msgError = 'El codigo de pais ya existe';
				SELECT msgError;
            END IF;
		END IF;

		IF (pOperacion = 'READ') THEN
			IF ((SELECT COUNT(*) FROM PAIS WHERE Cod_Pais = pCodPais) > 0) THEN
				SELECT Cod_Pais, Nombre_Pais
				FROM PAIS
				WHERE Cod_Pais = pCodPais;
			ELSE
				SET msgError = 'El pais no existe, no se puede realizar la busqueda';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'UPDATE')  THEN
			IF ((SELECT COUNT(*) FROM PAIS WHERE Cod_Pais = pCodPais) > 0) THEN
				UPDATE PAIS
				SET Nombre_Pais = IFNULL( pNombrePais, Nombre_Pais)
				WHERE Cod_Pais = pCodPais;
			ELSE
				SET msgError = 'El pais no existe, no se puede actualizar datos';
				SELECT msgError;
			END IF;
		END IF;
        
		IF (pOperacion = 'DELETE') THEN
			IF ((SELECT COUNT(*) FROM PAIS WHERE Cod_Pais = pCodPais) > 0) THEN
				IF ((SELECT COUNT(*) FROM PROVINCIA WHERE Cod_Pais = pCodPais) = 0) THEN
					DELETE FROM PAIS
					WHERE Cod_Pais = pCodPais;
				ELSE
					SET msgError = 'No se puede eliminar, pais asociado a provincias';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'No se puede eliminar, el pais no existe';
				SELECT msgError;
			END IF;
		END IF;
        
	ELSE
		SET msgError = 'El codigo de pais es vacío';
        SELECT msgError;
	END IF;
END;
//


/*------------------------------------------------------------ PROVINCIA ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_PROVINCIA(pCodProvincia INT, pNombreProvincia VARCHAR(40), pCodPais INT, pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
	IF (pCodProvincia IS NOT NULL) THEN
    
		IF (pOperacion = 'CREATE') THEN
			IF ((SELECT COUNT(*) FROM PROVINCIA WHERE Cod_Provincia = pCodProvincia) = 0) THEN
				IF (pNombreProvincia != ''AND pNombreProvincia IS NOT NULL) THEN
					IF ((SELECT COUNT(*) FROM PAIS WHERE Cod_Pais = pCodPais) > 0) THEN 
						INSERT INTO PROVINCIA(Cod_Provincia, Nombre_Provincia, Cod_Pais)
						VALUES(pCodProvincia, pNombreProvincia, pCodPais);
					ELSE
						SET msgError = 'El codigo de pais no existe';
						SELECT msgError;
                    END IF;
				ELSE
					SET msgError = 'El nombre de la provincia está vacía';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'El codigo de provincia ya existe';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'READ') THEN
			IF ((SELECT COUNT(*) FROM PROVINCIA WHERE Cod_Provincia = pCodProvincia) > 0) THEN
				SELECT Cod_Provincia, Nombre_Provincia, Cod_Pais
				FROM PROVINCIA
				WHERE Cod_Provincia = pCodProvincia;
			ELSE
				SET msgError = 'La provincia no existe, no se puede realizar la busqueda';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'UPDATE')  THEN
			IF ((SELECT COUNT(*) FROM PROVINCIA WHERE Cod_Provincia = pCodProvincia) > 0) THEN
				UPDATE PROVINCIA
				SET Nombre_Provincia = IFNULL( pNombreProvincia, Nombre_Provincia)
				WHERE Cod_Provincia = pCodProvincia;
			ELSE
				SET msgError = 'La provincia no existe, no se puede actualizar datos';
				SELECT msgError;
			END IF;
		END IF;
		
		IF (pOperacion = 'DELETE') THEN
			IF ((SELECT COUNT(*) FROM PROVINCIA WHERE Cod_Provincia = pCodProvincia) > 0) THEN
				IF ((SELECT COUNT(*) FROM CIUDAD WHERE Cod_Provincia = pCodProvincia) = 0) THEN
					DELETE FROM PROVINCIA
					WHERE Cod_Provincia = pCodProvincia;
				ELSE
					SET msgError = 'No se puede eliminar, provincia asociada a ciudad';
					SELECT msgError;
				END IF;
			ELSE
					SET msgError = 'No se puede eliminar, la provincia no existe';
					SELECT msgError;
			END IF;
		END IF;
        
	ELSE
		SET msgError = 'El codigo de provincia esta vacio';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ CIUDAD ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_CIUDAD(pCodCiudad INT, pNombreCiudad VARCHAR(40), pCodProvincia INT, pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
	IF (pCodCiudad IS NOT NULL) THEN
    
		IF (pOperacion = 'CREATE') THEN
			IF ((SELECT COUNT(*) FROM CIUDAD WHERE Cod_Ciudad = pCodCiudad) = 0) THEN
				IF (pNombreCiudad != '' AND pNombreCiudad IS NOT NULL) THEN
					IF ((SELECT COUNT(*) FROM PROVINCIA WHERE Cod_Provincia = pCodProvincia) > 0) THEN 
						INSERT INTO CIUDAD(Cod_Ciudad, Nombre_Ciudad, Cod_Provincia)
						VALUES(pCodCiudad, pNombreCiudad, pCodProvincia);
					ELSE
						SET msgError = 'El codigo de provincia no existe';
						SELECT msgError;
                    END IF;
				ELSE
					SET msgError = 'El nombre de la ciudad está vacía';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'El codigo de ciudad ya existe';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'READ') THEN
			IF ((SELECT COUNT(*) FROM CIUDAD WHERE Cod_Ciudad = pCodCiudad) > 0) THEN
				SELECT Cod_Ciudad, Nombre_Ciudad, Cod_Provincia
				FROM CIUDAD
				WHERE Cod_Ciudad = pCodCiudad;
			ELSE
				SET msgError = 'La ciudad no existe, no se puede realizar la busqueda';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'UPDATE')  THEN
			IF ((SELECT COUNT(*) FROM CIUDAD WHERE Cod_Ciudad = pCodCiudad) > 0) THEN
				UPDATE CIUDAD
				SET Nombre_Ciudad = IFNULL( pNombreCiudad, Nombre_Ciudad)
				WHERE Cod_Ciudad = pCodCiudad;
			ELSE
				SET msgError = 'La ciudad no existe, no se puede actualizar datos';
				SELECT msgError;
			END IF;
		END IF;
		
		IF (pOperacion = 'DELETE') THEN
			IF ((SELECT COUNT(*) FROM CIUDAD WHERE Cod_Ciudad = pCodCiudad) > 0) THEN
				IF ((SELECT COUNT(*) FROM SUCURSAL WHERE Cod_Ciudad = pCodCiudad) = 0) THEN
					IF ((SELECT COUNT(*) FROM PERSONA WHERE Cod_Ciudad = pCodCiudad) = 0) THEN
						IF ((SELECT COUNT(*) FROM PROVEEDOR WHERE Cod_Ciudad = pCodCiudad) = 0) THEN
							DELETE FROM CIUDAD
							WHERE Cod_Ciudad = pCodCiudad;
                        ELSE
							SET msgError = 'No se puede eliminar, ciudad asocidada a proveedor';
							SELECT msgError;
						END IF;
					ELSE
						SET msgError = 'No se puede eliminar, ciudad asociada a persona';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'No se puede eliminar, ciudad asociada a sucursal';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'No se puede eliminar, la ciudad no existe';
				SELECT msgError;
			END IF;
		END IF;
        
	ELSE
		SET msgError = 'El codigo de ciudad esta vacio';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ SUCURSAL ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_SUCURSAL(pCodSucursal INT, pNombreSucursal VARCHAR(40), pCodCiudad INT, pOperacion VARCHAR(10))
BEGIN
	DECLARE msgError VARCHAR(70) DEFAULT '';
	IF (pCodSucursal IS NOT NULL) THEN
    
		IF (pOperacion = 'CREATE') THEN
			IF ((SELECT COUNT(*) FROM SUCURSAL WHERE Cod_Sucursal = pCodSucursal) = 0) THEN
				IF (pNombreSucursal != '' AND pNombreSucursal IS NOT NULL) THEN
					IF ((SELECT COUNT(*) FROM CIUDAD WHERE Cod_Ciudad = pCodCiudad) > 0) THEN 
						INSERT INTO SUCURSAL(Cod_Sucursal, Nombre_Sucursal, Cod_Ciudad)
						VALUES(pCodSucursal, pNombreSucursal, pCodCiudad);
					ELSE
						SET msgError = 'El codigo de ciudad no existe';
						SELECT msgError;
                    END IF;
				ELSE
					SET msgError = 'El nombre de la sucursal está vacía';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'El codigo de sucursal ya existe';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'READ') THEN
			IF ((SELECT COUNT(*) FROM SUCURSAL WHERE Cod_Sucursal = pCodSucursal) > 0) THEN
				SELECT Cod_Sucursal, Nombre_Sucursal, Cod_Ciudad
				FROM SUCURSAL
				WHERE Cod_Sucursal = pCodSucursal;
			ELSE
				SET msgError = 'La sucursal no existe, no se puede realizar la busqueda';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'UPDATE')  THEN
			IF ((SELECT COUNT(*) FROM SUCURSAL WHERE Cod_Sucursal = pCodSucursal) > 0) THEN
				UPDATE SUCURSAL
				SET Nombre_Sucursal = IFNULL( pNombreSucursal, Nombre_Sucursal)
				WHERE Cod_Sucursal = pCodSucursal;
			ELSE
				SET msgError = 'La sucursal no existe, no se puede actualizar datos';
				SELECT msgError;
			END IF;
		END IF;
		
		IF (pOperacion = 'DELETE') THEN
			IF ((SELECT COUNT(*) FROM SUCURSAL WHERE Cod_Sucursal = pCodSucursal) > 0) THEN
				IF ((SELECT COUNT(*) FROM BODEGA_SUCURSAL_PRODUCTO WHERE Cod_Sucursal = pCodSucursal) = 0) THEN
					IF ((SELECT COUNT(*) FROM EMPLEADO WHERE Cod_Sucursal = pCodSucursal) = 0) THEN
						DELETE FROM SUCURSAL
						WHERE Cod_Sucursal = pCodSucursal;
					ELSE
						SET msgError = 'No se puede eliminar, sucursal asociada a empleado';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'No se puede eliminar, sucursal asociada a bodega_sucursal';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'No se puede eliminar, la sucursal no existe';
				SELECT msgError;
			END IF;
		END IF;
	
	ELSE
		SET msgError = 'El codigo de sucursal esta vacio';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ SEXO ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_SEXO(pCodSexo INT, pDescripSexo VARCHAR(15), pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
	IF (pCodSexo IS NOT NULL) THEN
    
		IF (pOperacion = 'CREATE') THEN
			IF ((SELECT COUNT(*) FROM SEXO WHERE Cod_Sexo = pCodSexo) = 0) THEN
				IF (pDescripSexo != '' AND pDescripSexo IS NOT NULL) THEN
					INSERT INTO SEXO(Cod_Sexo, Descrip_Sexo)
					VALUES(pCodSexo, pDescripSexo);
				ELSE
					SET msgError = 'La descripción del sexo está vacía';
					SELECT msgError;
                END IF;
			ELSE
				SET msgError = 'El codigo de sexo ya existe';
				SELECT msgError;
            END IF;
		END IF;

		IF (pOperacion = 'READ') THEN
			IF ((SELECT COUNT(*) FROM SEXO WHERE Cod_Sexo = pCodSexo) > 0) THEN
				SELECT Cod_Sexo, Descrip_Sexo
				FROM SEXO
				WHERE Cod_Sexo = pCodSexo;
			ELSE
				SET msgError = 'El codigo de sexo no existe, no se puede realizar la busqueda';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'UPDATE')  THEN
			IF ((SELECT COUNT(*) FROM SEXO WHERE Cod_Sexo = pCodSexo) > 0) THEN
				UPDATE SEXO
				SET Descrip_Sexo = IFNULL( pDescripSexo, Descrip_Sexo)
				WHERE Cod_Sexo = pCodSexo;
			ELSE
				SET msgError = 'El codigo de sexo no existe, no se puede actualizar datos';
				SELECT msgError;
			END IF;
		END IF;
        
		IF (pOperacion = 'DELETE') THEN
			IF ((SELECT COUNT(*) FROM SEXO WHERE Cod_Sexo = pCodSexo) > 0) THEN
				IF ((SELECT COUNT(*) FROM PERSONA WHERE Cod_Sexo = pCodSexo) = 0) THEN
					DELETE FROM SEXO
					WHERE Cod_Sexo = pCodSexo;
				ELSE
					SET msgError = 'No se puede eliminar, sexo asociado a persona';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'No se puede eliminar, el codigo de sexo no existe';
				SELECT msgError;
			END IF;
		END IF;
        
	ELSE
		SET msgError = 'El codigo de sexo es vacío';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ PERSONA ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_PERSONA(pIdentPers INT, pNombre VARCHAR(30), pApellidos VARCHAR(30), 
										pFechaNaci DATE, pDirecResi VARCHAR(20), pCodSexo INT, pCodCiudad INT, pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
	IF (pIdentPers IS NOT NULL) THEN
    
		IF (pOperacion = 'CREATE') THEN
			IF ((SELECT COUNT(*) FROM PERSONA WHERE Identificacion_Per = pIdentPers) = 0) THEN
				IF (pNombre != ''  AND pNombre IS NOT NULL) THEN
					IF (pApellidos != ''  AND pApellidos IS NOT NULL) THEN
						IF (pFechaNaci IS NOT NULL) THEN
							IF (pDirecResi != ''  AND pDirecResi IS NOT NULL) THEN
								IF ((SELECT COUNT(*) FROM SEXO WHERE Cod_Sexo = pCodSexo) > 0) THEN
									IF ((SELECT COUNT(*) FROM CIUDAD WHERE Cod_Ciudad = pCodCiudad) > 0) THEN
										INSERT INTO PERSONA(Identificacion_Per, Nombre, Apellidos, Fecha_Nacimiento, Direccion_Residencia, Cod_Sexo, Cod_Ciudad)
										VALUES(pIdentPers, pNombre, pApellidos, pFechaNaci, pDirecResi, pCodSexo, pCodCiudad);
									ELSE
										SET msgError = 'El codigo de ciudad no existe';
										SELECT msgError;
									END IF;
                                ELSE
									SET msgError = 'El codigo de sexo no existe';
									SELECT msgError;
								END IF;
							ELSE
								SET msgError = 'La direccion de residencia está vacía';
								SELECT msgError;
							END IF;
						ELSE
							SET msgError = 'La fecha de nacimiento está vacía';
							SELECT msgError;
						END IF;
					ELSE
						SET msgError = 'Los apellidos están vacíos';
						SELECT msgError;
                    END IF;
				ELSE
					SET msgError = 'El nombre está vacío';
					SELECT msgError;
                END IF;
			ELSE
				SET msgError = 'La identificacion personal ya existe';
				SELECT msgError;
            END IF;
		END IF;

		IF (pOperacion = 'READ') THEN
			IF ((SELECT COUNT(*) FROM PERSONA WHERE Identificacion_Per = pIdentPers) > 0) THEN
				SELECT Identificacion_Per, Nombre, Apellidos, Fecha_Nacimiento, Direccion_Residencia, Cod_Sexo, Cod_Ciudad
				FROM PERSONA
				WHERE Identificacion_Per = pIdentPers;
			ELSE
				SET msgError = 'La identificacion personal no existe, no se puede hacer la busqueda';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'UPDATE')  THEN
			IF ((SELECT COUNT(*) FROM PERSONA WHERE Identificacion_Per = pIdentPers) > 0) THEN
				IF ((SELECT COUNT(*) FROM SEXO WHERE Cod_Sexo = pCodSexo) > 0) THEN
					IF ((SELECT COUNT(*) FROM CIUDAD WHERE Cod_Ciudad = pCodCiudad) > 0) THEN
						UPDATE PERSONA
						SET Nombre=IFNULL(pNombre, Nombre), Apellidos=IFNULL(pApellidos, Apellidos),Direccion_Residencia=IFNULL(pDirecResi,Direccion_Residencia), Cod_Sexo=IFNULL(pCodSexo,Cod_Sexo), Cod_Ciudad=IFNULL(pCodCiudad,Cod_Ciudad)
						WHERE Identificacion_Per = pIdentPers;
					ELSE
						SET msgError = 'El codigo de ciudad no existe, no se puede actualizar';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'El codigo de sexo no existe, no se puede actualizar';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'La identificacion personal no existe, no se puede actualizar';
				SELECT msgError;
			END IF;
		END IF;
        
		IF (pOperacion = 'DELETE') THEN
			IF ((SELECT COUNT(*) FROM PERSONA WHERE Identificacion_Per = pIdentPers) > 0) THEN
				IF ((SELECT COUNT(*) FROM EMPLEADO WHERE Identificacion_Per = pIdentPers) = 0) THEN
					IF ((SELECT COUNT(*) FROM USUARIO WHERE Identificacion_Per = pIdentPers) = 0) THEN
						IF ((SELECT COUNT(*) FROM TELEF_PERSO WHERE Identificacion_Per = pIdentPers) = 0) THEN
							DELETE FROM PERSONA
							WHERE Identificacion_Per = pIdentPers;
						ELSE
							SET msgError = 'No se puede eliminar, persona asociada a telefono personal';
							SELECT msgError;
						END IF;
					ELSE
						SET msgError = 'No se puede eliminar, persona asociada a usuario';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'No se puede eliminar, persona asociada a empleado';
					SELECT msgError;
				END IF;
            ELSE
				SET msgError = 'No se puede eliminar, identificacion personal no existe';
				SELECT msgError;
			END IF;
		END IF;
	
	ELSE
		SET msgError = 'La identificacion personal está vacía';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ PUESTO_LABORAL ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_PULABORAL(pCodPuLaboral INT, pDescPuLaboral VARCHAR(30), pSalarioMe FLOAT,  pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
	IF (pCodPuLaboral IS NOT NULL) THEN
    
		IF (pOperacion = 'CREATE') THEN
			IF ((SELECT COUNT(*) FROM PUESTO_LABORAL WHERE Cod_Puesto_Laboral = pCodPuLaboral) = 0) THEN
				IF (pDescPuLaboral != '' AND pDescPuLaboral IS NOT NULL) THEN
					IF ((pSalarioMe IS NOT NULL) AND (pSalarioMe >= 0 )) THEN
						INSERT INTO PUESTO_LABORAL(Cod_Puesto_Laboral, Descrip_Pues_Lab, Salario_Mensual)
						VALUES(pCodPuLaboral, pDescPuLaboral, pSalarioMe);
					ELSE
						SET msgError = 'El salario ingresado no es válido';
						SELECT msgError;
                    END IF;
				ELSE
					SET msgError = 'La descripción del puesto laboral está vacía';
					SELECT msgError;
                END IF;
			ELSE
				SET msgError = 'El codigo de puesto laboral ya existe';
				SELECT msgError;
            END IF;
		END IF;

		IF (pOperacion = 'READ') THEN
			IF ((SELECT COUNT(*) FROM PUESTO_LABORAL WHERE Cod_Puesto_Laboral = pCodPuLaboral) > 0) THEN
				SELECT Cod_Puesto_Laboral, Descrip_Pues_Lab, Salario_Mensual
				FROM PUESTO_LABORAL
				WHERE Cod_Puesto_Laboral = pCodPuLaboral;
			ELSE
				SET msgError = 'Codigo de puesto laboral no existe, no se puede realizar la busqueda';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'UPDATE')  THEN
			IF ((SELECT COUNT(*) FROM PUESTO_LABORAL WHERE Cod_Puesto_Laboral = pCodPuLaboral) > 0) THEN
				IF ((pSalarioMe IS NOT NULL) AND (pSalarioMe >= 0 )) THEN
					UPDATE PUESTO_LABORAL
					SET Descrip_Pues_Lab = IFNULL( pDescPuLaboral, Descrip_Pues_Lab), Salario_Mensual = IFNULL( pSalarioMe, Salario_Mensual)
					WHERE Cod_Puesto_Laboral = pCodPuLaboral;
				ELSE
                SET msgError = 'El salario ingresado no es válido';
				SELECT msgError;
                END IF;
			ELSE
				SET msgError = 'El codigo de puesto laboral no existe, no se puede actualizar datos';
				SELECT msgError;
			END IF;
		END IF;
        
		IF (pOperacion = 'DELETE') THEN
			IF ((SELECT COUNT(*) FROM PUESTO_LABORAL WHERE Cod_Puesto_Laboral = pCodPuLaboral) > 0) THEN
				IF ((SELECT COUNT(*) FROM EMPLEADO WHERE Cod_Puesto_Laboral = pCodPuLaboral) = 0) THEN
					DELETE FROM PUESTO_LABORAL
					WHERE Cod_Puesto_Laboral = pCodPuLaboral;
				ELSE
					SET msgError = 'No se puede eliminar, puesto laboral asociado a empleado';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'No se puede eliminar, el codigo de puesto laboral no existe';
				SELECT msgError;
			END IF;
		END IF;
        
	ELSE
		SET msgError = 'El codigo de puesto laboral es vacío';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ EMPLEADO ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_EMPLEADO(pCodEmpleado INT, pFechaContr DATE, pHorasLab FLOAT, pCodSucursal INT, pCodPuLaboral INT, pIdentPers INT , pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
	IF (pCodEmpleado IS NOT NULL) THEN
    
		IF (pOperacion = 'CREATE') THEN
			IF ((SELECT COUNT(*) FROM EMPLEADO WHERE Cod_Empleado = pCodEmpleado) = 0) THEN
				IF (pFechaContr IS NOT NULL) THEN
					IF (pHorasLab IS NOT NULL AND pHorasLab>=0) THEN
						IF ((SELECT COUNT(*) FROM SUCURSAL WHERE Cod_Sucursal = pCodSucursal) > 0) THEN
							IF ((SELECT COUNT(*) FROM PUESTO_LABORAL WHERE Cod_Puesto_Laboral = pCodPuLaboral) > 0) THEN
								IF ((SELECT COUNT(*) FROM PERSONA WHERE Identificacion_Per = pIdentPers) > 0) THEN
									INSERT INTO EMPLEADO(Cod_Empleado, Fecha_Contratado, Horas_Laborales, Cod_Sucursal, Cod_Puesto_Laboral, Identificacion_Per)
									VALUES(pCodEmpleado,pFechaContr, pHorasLab, pCodSucursal, pCodPuLaboral, pIdentPers);
								ELSE
									SET msgError = 'La identificacion personal no existe';
									SELECT msgError;
								END IF;
							ELSE
								SET msgError = 'El codigo de puesto laboral no existe';
								SELECT msgError;
							END IF;
						ELSE
							SET msgError = 'El codigo de sucursal no existe';
							SELECT msgError;
						END IF;
					ELSE
						SET msgError = 'Las horas laborales ingresadas no son válidas';
						SELECT msgError;
                    END IF;
				ELSE
					SET msgError = 'La fecha de contratacion ingresada es vacía';
					SELECT msgError;
                END IF;
			ELSE
				SET msgError = 'El codigo de empleado ya existe';
				SELECT msgError;
            END IF;
		END IF;

		IF (pOperacion = 'READ') THEN
			IF ((SELECT COUNT(*) FROM EMPLEADO WHERE Cod_Empleado = pCodEmpleado) > 0) THEN
				SELECT Cod_Empleado, Fecha_Contratado, Horas_Laborales, Cod_Sucursal, Cod_Puesto_Laboral, Identificacion_Per
				FROM EMPLEADO
				WHERE Cod_Empleado = pCodEmpleado;
			ELSE
				SET msgError = 'El codigo de empleado no existe, no se puede hacer la busqueda';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'UPDATE')  THEN
			IF ((SELECT COUNT(*) FROM EMPLEADO WHERE Cod_Empleado = pCodEmpleado) > 0) THEN
				IF (pHorasLab IS NOT NULL AND pHorasLab>=0) THEN
					IF ((SELECT COUNT(*) FROM SUCURSAL WHERE Cod_Sucursal = pCodSucursal) > 0) THEN
						IF ((SELECT COUNT(*) FROM PUESTO_LABORAL WHERE Cod_Puesto_Laboral = pCodPuLaboral) > 0) THEN
							UPDATE EMPLEADO
							SET Horas_Laborales=IFNULL(pHorasLab, Horas_Laborales), Cod_Sucursal=IFNULL(pCodSucursal,Cod_Sucursal), Cod_Puesto_Laboral=IFNULL(pCodPuLaboral,Cod_Puesto_Laboral)
							WHERE Cod_Empleado = pCodEmpleado;
						ELSE
							SET msgError = 'El codigo de puesto laboral no existe, no se puede actualizar';
							SELECT msgError;
						END IF;
                    ELSE
						SET msgError = 'El codigo de sucursal no existe, no se puede actualizar';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'Las horas laborales ingresadas no son válidas, no se puede actualizar';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'El codigo de empleado no existe, no se puede actualizar';
				SELECT msgError;
			END IF;
		END IF;
        
		IF (pOperacion = 'DELETE') THEN
			IF ((SELECT COUNT(*) FROM EMPLEADO WHERE Cod_Empleado = pCodEmpleado) > 0) THEN
				IF ((SELECT COUNT(*) FROM FACTURA WHERE Cod_Empleado = pCodEmpleado) = 0) THEN
					IF ((SELECT COUNT(*) FROM BONOS_EMPLEADO WHERE Cod_Empleado = pCodEmpleado) = 0) THEN
						DELETE FROM EMPLEADO
						WHERE Cod_Empleado = pCodEmpleado;
					ELSE
						SET msgError = 'No se puede eliminar, empleado asociada a bono de empleado';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'No se puede eliminar, empleado asociada a factura';
					SELECT msgError;
				END IF;
            ELSE
				SET msgError = 'No se puede eliminar, codigo de empleado no existe';
				SELECT msgError;
			END IF;
		END IF;
	
	ELSE
		SET msgError = 'El codigo de empleado está vacío';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ TIPO_USUARIO ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_TIPUSUARIO(pCodTipUsu INT, pDescTipUsu VARCHAR(30), pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
	IF (pCodTipUsu IS NOT NULL) THEN
    
		IF (pOperacion = 'CREATE') THEN
			IF ((SELECT COUNT(*) FROM TIPO_USUARIO WHERE Cod_Tipo_Usuario = pCodTipUsu) = 0) THEN
				IF (pDescTipUsu != '' AND pDescTipUsu IS NOT NULL) THEN
					INSERT INTO TIPO_USUARIO(Cod_Tipo_Usuario, Descrip_TipUsu)
					VALUES(pCodTipUsu, pDescTipUsu);
				ELSE
					SET msgError = 'La descripción del tipo de usuario está vacía';
					SELECT msgError;
                END IF;
			ELSE
				SET msgError = 'El codigo de tipo de usuario ya existe';
				SELECT msgError;
            END IF;
		END IF;

		IF (pOperacion = 'READ') THEN
			IF ((SELECT COUNT(*) FROM TIPO_USUARIO WHERE Cod_Tipo_Usuario = pCodTipUsu) > 0) THEN
				SELECT Cod_Tipo_Usuario, Descrip_TipUsu
				FROM TIPO_USUARIO
				WHERE Cod_Tipo_Usuario = pCodTipUsu;
			ELSE
				SET msgError = 'El codigo de tipo usuario no existe, imposible realizar la busqueda';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'UPDATE')  THEN
			IF ((SELECT COUNT(*) FROM TIPO_USUARIO WHERE Cod_Tipo_Usuario = pCodTipUsu) > 0) THEN
				UPDATE TIPO_USUARIO
				SET Descrip_TipUsu = IFNULL( pDescTipUsu, Descrip_TipUsu)
				WHERE Cod_Tipo_Usuario = pCodTipUsu;
			ELSE
				SET msgError = 'El codigo de tipo usuario no existe, no se puede actualizar datos';
				SELECT msgError;
			END IF;
		END IF;
        
		IF (pOperacion = 'DELETE') THEN
			IF ((SELECT COUNT(*) FROM TIPO_USUARIO WHERE Cod_Tipo_Usuario = pCodTipUsu) > 0) THEN
				IF ((SELECT COUNT(*) FROM USUARIO WHERE Cod_Tipo_Usuario = pCodTipUsu) = 0) THEN
					DELETE FROM TIPO_USUARIO
					WHERE Cod_Tipo_Usuario = pCodTipUsu;
				ELSE
					SET msgError = 'No se puede eliminar, tipo de usuario asociado a usuario';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'No se puede eliminar, el codigo de tipo de usuario no existe';
				SELECT msgError;
			END IF;
		END IF;
        
	ELSE
		SET msgError = 'El codigo de tipo de usuario es vacío';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ USUARIO ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_USUARIO(pCodUsu INT,  pNombUsu VARCHAR(20), pContra VARCHAR(20), pCorreoE VARCHAR(30), pCodTipUsu INT, pIdentPers INT, pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
	IF (pCodUsu IS NOT NULL) THEN
    
		IF (pOperacion = 'CREATE') THEN
			IF ((SELECT COUNT(*) FROM USUARIO WHERE Cod_Usuario = pCodUsu) = 0) THEN
				IF (pNombUsu != ''  AND pNombUsu IS NOT NULL) THEN
					IF (pContra != ''  AND pContra IS NOT NULL) THEN
						IF (pCorreoE != ''  AND pCorreoE IS NOT NULL) THEN
								IF ((SELECT COUNT(*) FROM TIPO_USUARIO WHERE Cod_Tipo_Usuario = pCodTipUsu) > 0) THEN
									IF ((SELECT COUNT(*) FROM PERSONA WHERE Identificacion_Per = pIdentPers) > 0) THEN
										INSERT INTO USUARIO(Cod_Usuario, Nombre_Usuario, Contraseña, CorreoElec, Cod_Tipo_Usuario, Identificacion_Per)
										VALUES(pCodUsu, pNombUsu, pContra, pCorreoE, pCodTipUsu, pIdentPers);
									ELSE
										SET msgError = 'La identificacion personal no existe';
										SELECT msgError;
									END IF;
                                ELSE
									SET msgError = 'El codigo de tipo de usuario no existe';
									SELECT msgError;
								END IF;
						ELSE
							SET msgError = 'El correo electrónico está vacío';
							SELECT msgError;
						END IF;
					ELSE
						SET msgError = 'La contraseña está vacía';
						SELECT msgError;
                    END IF;
				ELSE
					SET msgError = 'El nombre está vacío';
					SELECT msgError;
                END IF;
			ELSE
				SET msgError = 'El nombre de usuario está vacío';
				SELECT msgError;
            END IF;
		END IF;

		IF (pOperacion = 'READ') THEN
			IF ((SELECT COUNT(*) FROM USUARIO WHERE Cod_Usuario = pCodUsu) > 0) THEN
				SELECT Cod_Usuario, Nombre_Usuario, Contraseña, CorreoElec, Cod_Tipo_Usuario, Identificacion_Per
				FROM USUARIO
				WHERE Cod_Usuario = pCodUsu;
			ELSE
				SET msgError = 'El codigo de usuario no existe, no se puede hacer la busqueda';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'UPDATE')  THEN
			IF ((SELECT COUNT(*) FROM USUARIO WHERE Cod_Usuario = pCodUsu) > 0) THEN
				IF ((SELECT COUNT(*) FROM TIPO_USUARIO WHERE Cod_Tipo_Usuario = pCodTipUsu) > 0) THEN
					IF ((SELECT COUNT(*) FROM PERSONA WHERE Identificacion_Per = pIdentPers) > 0) THEN
						UPDATE USUARIO
						SET Nombre=Nombre_Usuario=IFNULL(pNombUsu,Nombre_Usuario), Contraseña=IFNULL(pContra,Contraseña), Cod_Tipo_Usuario=IFNULL(pCodTipUsu,Cod_Tipo_Usuario), CorreoElec=IFNULL(pCorreoE,CorreoElec)
						WHERE Cod_Usuario = pCodUsu;
					ELSE
						SET msgError = 'La identificacion personal no existe, no se puede actualizar';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'El codigo de tipo de usuario no existe, no se puede actualizar';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'El codigo de usuario no existe, no se puede actualizar';
				SELECT msgError;
			END IF;
		END IF;
        
		IF (pOperacion = 'DELETE') THEN
			IF ((SELECT COUNT(*) FROM USUARIO WHERE Cod_Usuario = pCodUsu) > 0) THEN
				IF ((SELECT COUNT(*) FROM CLIENTE WHERE Cod_Usuario = pCodUsu) = 0) THEN
					DELETE FROM USUARIO
					WHERE Cod_Usuario = pCodUsu;
				ELSE
					SET msgError = 'No se puede eliminar, usuario asociada a cliente';
					SELECT msgError;
				END IF;
            ELSE
				SET msgError = 'No se puede eliminar, codigo de usuario no existe';
				SELECT msgError;
			END IF;
		END IF;
	
	ELSE
		SET msgError = 'El codigo de usuario está vacío';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ CLIENTE ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_CLIENTE(pCodCliente INT, pCodUsu INT, pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
	IF (pCodCliente IS NOT NULL) THEN
    
		IF (pOperacion = 'CREATE') THEN
			IF ((SELECT COUNT(*) FROM CLIENTE WHERE Cod_Cliente = pCodCliente) = 0) THEN
				IF ((SELECT COUNT(*) FROM USUARIO WHERE Cod_Usuario = pCodUsu) > 0) THEN
					INSERT INTO CLIENTE(Cod_Cliente, Cod_Usuario)
					VALUES(pCodCliente, pCodUsu);
				ELSE
					SET msgError = 'El codigo de usuario no existe';
					SELECT msgError;
                END IF;
			ELSE
				SET msgError = 'El codigo de cliente ya existe';
				SELECT msgError;
            END IF;
		END IF;

		IF (pOperacion = 'READ') THEN
			IF ((SELECT COUNT(*) FROM CLIENTE WHERE Cod_Cliente = pCodCliente) > 0) THEN
				SELECT Cod_Cliente, Cod_Usuario
				FROM CLIENTE
				WHERE Cod_Cliente = pCodCliente;
			ELSE
				SET msgError = 'El codigo de cliente, no se puede realizar la busqueda';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'UPDATE')  THEN
			SET msgError = 'No está permitido actualizar datos';
			SELECT msgError;
		END IF;
        
		IF (pOperacion = 'DELETE') THEN
			IF ((SELECT COUNT(*) FROM CLIENTE WHERE Cod_Cliente = pCodCliente) > 0) THEN
				IF ((SELECT COUNT(*) FROM CRIPTOCARTERA WHERE Cod_Cliente = pCodCliente) = 0) THEN
					IF ((SELECT COUNT(*) FROM TARJETA_CREDITO WHERE Cod_Cliente = pCodCliente) = 0) THEN
						IF ((SELECT COUNT(*) FROM CHEQUE WHERE Cod_Cliente = pCodCliente) = 0) THEN
							IF ((SELECT COUNT(*) FROM PEDIDO WHERE Cod_Cliente = pCodCliente) = 0) THEN
								IF ((SELECT COUNT(*) FROM FACTURA WHERE Cod_Cliente = pCodCliente) = 0) THEN
									DELETE FROM CLIENTE
									WHERE Cod_Cliente = pCodCliente;
                                ELSE
									SET msgError = 'No se puede eliminar, cliente asociado a factura';
									SELECT msgError;
								END IF;
							ELSE
								SET msgError = 'No se puede eliminar, cliente asociado a pedido';
								SELECT msgError;
							END IF;
                        ELSE
							SET msgError = 'No se puede eliminar, cliente asociado a cheque';
							SELECT msgError;
						END IF;
					ELSE
						SET msgError = 'No se puede eliminar, cliente asociado a tarjeta de credito';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'No se puede eliminar, cliente asociado a criptocartera';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'No se puede eliminar, el codigo de cliente no existe';
				SELECT msgError;
			END IF;
		END IF;
        
	ELSE
		SET msgError = 'Error: el codigo de cliente es vacío';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ PROVEEDOR ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_PROVEEDOR(pCodProveedor INT, pNomProvee VARCHAR(50), pPorcentGan FLOAT, pCodCiudad INT, pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
	IF (pCodProveedor IS NOT NULL) THEN
    
		IF (pOperacion = 'CREATE') THEN
			IF ((SELECT COUNT(*) FROM PROVEEDOR WHERE Cod_Proveedor = pCodProveedor) = 0) THEN
				IF (pNomProvee != '' AND pNomProvee IS NOT NULL) THEN
					IF (pPorcentGan IS NOT NULL AND pPorcentGan>=0) THEN
						IF ((SELECT COUNT(*) FROM CIUDAD WHERE Cod_Ciudad = pCodCiudad) > 0) THEN
							INSERT INTO PROVEEDOR(Cod_Proveedor, Nombre_Proveedor, Porcentaje_Ganancia, Cod_Ciudad)
							VALUES(pCodProveedor, pNomProvee, pPorcentGan, pCodCiudad);
						ELSE
							SET msgError = 'El codigo de ciudad no existe';
							SELECT msgError;
						END IF;
                    ELSE
						SET msgError = 'El porcentaje de ganancia ingresado no es válido';
						SELECT msgError;
					END IF;
                ELSE
					SET msgError = 'El nombre de proveedor ingresado no es válido';
					SELECT msgError;
                END IF;
			ELSE
				SET msgError = 'El codigo de proveedor ya existe';
				SELECT msgError;
            END IF;
		END IF;

		IF (pOperacion = 'READ') THEN
			IF ((SELECT COUNT(*) FROM PROVEEDOR WHERE Cod_Proveedor = pCodProveedor) > 0) THEN
				SELECT Cod_Proveedor, Nombre_Proveedor, Porcentaje_Ganancia, Cod_Ciudad
				FROM PROVEEDOR
				WHERE Cod_Proveedor = pCodProveedor;
			ELSE
				SET msgError = 'El codigo proveedor no existe, no se puede realizar la busqueda';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'UPDATE')  THEN
			IF ((SELECT COUNT(*) FROM PROVEEDOR WHERE Cod_Proveedor = pCodProveedor) > 0) THEN
				IF (pPorcentGan IS NOT NULL AND pPorcentGan>=0) THEN
					IF ((SELECT COUNT(*) FROM CIUDAD WHERE Cod_Ciudad = pCodCiudad) > 0) THEN
						UPDATE PROVEEDOR
						SET Nombre_Proveedor = IFNULL(pNomProvee,Nombre_Proveedor), Porcentaje_Ganancia = IFNULL(pPorcentGan,Porcentaje_Ganancia), Cod_Ciudad = IFNULL(pCodCiudad,Cod_Ciudad)
						WHERE Cod_Proveedor = pCodProveedor;
					ELSE
						SET msgError = 'El codigo de ciudad no existe, no se puede actualizar datos';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'El porcentaje de ganancia no es válido, no se puede actualizar datos';
					SELECT msgError;
				END IF;
            ELSE
				SET msgError = 'El codigo de proveedor no existe, no se puede actualizar datos';
				SELECT msgError;
			END IF;
		END IF;
        
		IF (pOperacion = 'DELETE') THEN
			IF ((SELECT COUNT(*) FROM PROVEEDOR WHERE Cod_Proveedor = pCodProveedor) > 0) THEN
				IF ((SELECT COUNT(*) FROM BODEGA_PROVEEDOR_PRODUCTO WHERE Cod_Proveedor = pCodProveedor) = 0) THEN
					IF ((SELECT COUNT(*) FROM BODEGA_SUCURSAL_PRODUCTO WHERE Cod_Proveedor = pCodProveedor) = 0) THEN
						DELETE FROM PROVEEDOR
						WHERE Cod_Proveedor = pCodProveedor;
                    ELSE
						SET msgError = 'No se puede eliminar, proveedor asociado a bodega de sucursal';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'No se puede eliminar, proveedor asociado a bodega de proveedor';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'No se puede eliminar, el codigo de proveedor no existe';
				SELECT msgError;
			END IF;
		END IF;
        
	ELSE
		SET msgError = 'El codigo de proveedor es vacío';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ IMPUESTO ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_IMPUESTO(pCodImpu INT, pPorcImpu FLOAT, pDescImpu VARCHAR(20),  pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
	IF (pCodImpu IS NOT NULL) THEN
    
		IF (pOperacion = 'CREATE') THEN
			IF ((SELECT COUNT(*) FROM IMPUESTO WHERE Cod_Impuesto = pCodImpu) = 0) THEN
				IF (pDescImpu != ''  AND pDescImpu IS NOT NULL) THEN
					IF ((pPorcImpu IS NOT NULL) AND (pPorcImpu >= 0 )) THEN
						INSERT INTO IMPUESTO(Cod_Impuesto, Porcentaje_Imp, Descrip_Imp)
						VALUES(pCodImpu, pPorcImpu, pDescImpu);
					ELSE
						SET msgError = 'El porcentaje del impuesto ingresado no es válido';
						SELECT msgError;
                    END IF;
				ELSE
					SET msgError = 'La descripción del impuesto está vacía';
					SELECT msgError;
                END IF;
			ELSE
				SET msgError = 'El codigo de impuesto ya existe';
				SELECT msgError;
            END IF;
		END IF;

		IF (pOperacion = 'READ') THEN
			IF ((SELECT COUNT(*) FROM IMPUESTO WHERE Cod_Impuesto = pCodImpu) > 0) THEN
				SELECT Cod_Impuesto, Porcentaje_Imp, Descrip_Imp
				FROM IMPUESTO
				WHERE Cod_Impuesto = pCodImpu;
			ELSE
				SET msgError = 'El impuesto no existe, no se puede realizar la busqueda';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'UPDATE')  THEN
			IF ((SELECT COUNT(*) FROM IMPUESTO WHERE Cod_Impuesto = pCodImpu) > 0) THEN
				IF ((pPorcImpu IS NOT NULL) AND (pPorcImpu >= 0 )) THEN
					UPDATE IMPUESTO
					SET Descrip_Imp = IFNULL( pDescImpu, Descrip_Imp), Porcentaje_Imp = IFNULL( pPorcImpu, Porcentaje_Imp)
					WHERE Cod_Impuesto = pCodImpu;
				ELSE
                SET msgError = 'El porcentaje del impuesto ingresado no es válido';
				SELECT msgError;
                END IF;
			ELSE
				SET msgError = 'El impuesto no existe, no se puede actualizar datos';
				SELECT msgError;
			END IF;
		END IF;
        
		IF (pOperacion = 'DELETE') THEN
			IF ((SELECT COUNT(*) FROM IMPUESTO WHERE Cod_Impuesto = pCodImpu) > 0) THEN
				IF ((SELECT COUNT(*) FROM TIPO_PRODUCTO WHERE Cod_Impuesto = pCodImpu) = 0) THEN
					DELETE FROM IMPUESTO
					WHERE Cod_Impuesto = pCodImpu;
				ELSE
					SET msgError = 'No se puede eliminar, impuesto asociado a tipo producto';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'No se puede eliminar, el impuesto no existe';
				SELECT msgError;
			END IF;
		END IF;
        
	ELSE
		SET msgError = 'El codigo de impuesto es vacío';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ TIPO_PRODUCTO ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_TIPPRODU(pCodTipProdu INT, pNomTipProdu VARCHAR(50), pDescrTipProdu VARCHAR(30),  pCodImpu INT, pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
	IF (pCodTipProdu IS NOT NULL) THEN
    
		IF (pOperacion = 'CREATE') THEN
			IF ((SELECT COUNT(*) FROM TIPO_PRODUCTO WHERE Cod_Tipo_Producto = pCodTipProdu) = 0) THEN
				IF (pNomTipProdu != ''  AND pNomTipProdu IS NOT NULL) THEN
					IF (pDescrTipProdu != ''  AND pDescrTipProdu IS NOT NULL) THEN
						IF ((SELECT COUNT(*) FROM IMPUESTO WHERE Cod_Impuesto = pCodImpu) > 0) THEN
							INSERT INTO TIPO_PRODUCTO(Cod_Tipo_Producto, Nombre_Tipo_Producto, Descrip_Tipo_Producto, Cod_Impuesto)
							VALUES(pCodTipProdu, pNomTipProdu, pDescrTipProdu, pCodImpu);
						ELSE
							SET msgError = 'El codigo de impuesto no existe';
							SELECT msgError;
						END IF;
					ELSE
						SET msgError = 'La descripción del tipo de producto está vacía';
						SELECT msgError;
                    END IF;
				ELSE
					SET msgError = 'El nombre del tipo de producto está vacío';
					SELECT msgError;
                END IF;
			ELSE
				SET msgError = 'El codigo de tipo de producto ya existe';
				SELECT msgError;
            END IF;
		END IF;

		IF (pOperacion = 'READ') THEN
			IF ((SELECT COUNT(*) FROM TIPO_PRODUCTO WHERE Cod_Tipo_Producto = pCodTipProdu) > 0) THEN
				SELECT Cod_Tipo_Producto, Nombre_Tipo_Producto, Descrip_Tipo_Producto, Cod_Impuesto
				FROM TIPO_PRODUCTO
				WHERE Cod_Tipo_Producto = pCodTipProdu;
			ELSE
				SET msgError = 'El codigo de tipo de producto no existe, no se puede hacer la busqueda';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'UPDATE')  THEN
			IF ((SELECT COUNT(*) FROM TIPO_PRODUCTO WHERE Cod_Tipo_Producto = pCodTipProdu) > 0) THEN
				IF ((SELECT COUNT(*) FROM IMPUESTO WHERE Cod_Tipo_Producto = pCodTipProdu) > 0) THEN
					UPDATE TIPO_PRODUCTO
					SET Nombre_Tipo_Producto=IFNULL(pNomTipProdu,Nombre_Tipo_Producto), Descrip_Tipo_Producto=IFNULL(pDescrTipProdu,Descrip_Tipo_Producto), Cod_Impuesto=IFNULL(pCodImpu,Cod_Impuesto)
					WHERE Cod_Tipo_Producto = pCodTipProdu;
				ELSE
					SET msgError = 'El codigo de impuesto no existe, no se puede actualizar';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'El codigo de tipo de producto, no se puede actualizar';
				SELECT msgError;
			END IF;
		END IF;
        
		IF (pOperacion = 'DELETE') THEN
			IF ((SELECT COUNT(*) FROM TIPO_PRODUCTO WHERE Cod_Tipo_Producto = pCodTipProdu) > 0) THEN
				IF ((SELECT COUNT(*) FROM PRODUCTO WHERE Cod_Impuesto = pCodImpu) = 0) THEN
					DELETE FROM TIPO_PRODUCTO
					WHERE Cod_Tipo_Producto = pCodTipProdu;
				ELSE
					SET msgError = 'No se puede eliminar, tipo producto asociado a producto';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'No se puede eliminar, el tipo de producto no existe';
				SELECT msgError;
			END IF;
		END IF;
        
	ELSE
		SET msgError = 'El tipo de producto es vacío';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ FACTURA ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_FACTURA(pNumFact INT, pFechaFact DATE, pCodCliente INT, pCodEmpleado INT, pMetodoPago VARCHAR(15), pNumPedido INT, pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
	IF (pNumFact IS NOT NULL) THEN
    
		IF (pOperacion = 'CREATE') THEN
			IF ((SELECT COUNT(*) FROM FACTURA WHERE Num_Factura = pNumFact) = 0) THEN
				IF (pFechaFact IS NOT NULL) THEN
					IF ((SELECT COUNT(*) FROM CLIENTE WHERE Cod_Cliente = pCodCliente) > 0) THEN
						IF ((SELECT COUNT(*) FROM EMPLEADO WHERE Cod_Empleado = pCodEmpleado) > 0) THEN
							IF (pMetodoPago != '' AND pMetodoPago IS NOT NULL) THEN
								IF ((SELECT COUNT(*) FROM PEDIDO WHERE Num_Pedido = pNumPedido) > 0) THEN
									INSERT INTO FACTURA(Num_Factura, Fecha_Factura, Cod_Cliente, Cod_Empleado, Metodo_Pago, Num_Pedido)
									VALUES(pNumFact, pFechaFact, pCodCliente, pCodEmpleado, pMetodoPago,pNumPedido);
								ELSE
									SET msgError = 'El numero de pedido no existe';
									SELECT msgError;
								END IF;
							ELSE
								SET msgError = 'El metodo de pago ingresado es inválido';
								SELECT msgError;
							END IF;
						ELSE
							SET msgError = 'El codigo de empleado no existe';
							SELECT msgError;
						END IF;
					ELSE
						SET msgError = 'El codigo de cliente no existe';
						SELECT msgError;
                    END IF;
				ELSE
					SET msgError = 'La fecha de la factura es inválida';
					SELECT msgError;
                END IF;
			ELSE
				SET msgError = 'El numero de factura ya existe';
				SELECT msgError;
            END IF;
		END IF;
	
		IF (pOperacion = 'READ') THEN
			IF ((SELECT COUNT(*) FROM FACTURA WHERE Num_Factura = pNumFact) > 0) THEN
				SELECT Num_Factura, Fecha_Factura, Cod_Cliente, Cod_Empleado, Metodo_Pago, Num_Pedido
				FROM FACTURA
				WHERE Num_Factura = pNumFact;
			ELSE
				SET msgError = 'El numero de factura no existe, no se puede hacer la busqueda';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'UPDATE')  THEN
			IF ((SELECT COUNT(*) FROM FACTURA WHERE Num_Factura = pNumFact) > 0) THEN
				IF (pMetodoPago IS NOT NULL) THEN
					UPDATE FACTURA
					SET Metodo_Pago = IFNULL(pMetodoPago,Metodo_Pago)
					WHERE Num_Factura = pNumFact;
				ELSE
					SET msgError = 'El metodo de pago es inválido, no se puede actualizar';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'El numero de factura no existe, no se puede actualizar';
				SELECT msgError;
			END IF;
		END IF;
        
		IF (pOperacion = 'DELETE') THEN
			IF ((SELECT COUNT(*) FROM FACTURA WHERE Num_Factura = pNumFact) > 0) THEN
				DELETE FROM FACTURA
				WHERE Num_Factura = pNumFact;
            ELSE
				SET msgError = 'No se puede eliminar, el numero de factura no existe';
				SELECT msgError;
			END IF;
		END IF;
        
	ELSE
		SET msgError = 'El numero de factura está vacío';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ PRODUCTO ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_PRODUCTO(pCodProdu INT,  pNombProdu VARCHAR(50), pCodTipProdu INT, pCantMin INT, pCantMax INT, pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
	IF (pCodProdu IS NOT NULL) THEN
    
		IF (pOperacion = 'CREATE') THEN
			IF ((SELECT COUNT(*) FROM PRODUCTO WHERE Cod_Producto = pCodProdu) = 0) THEN
				IF (pNombProdu != '' AND pNombProdu IS NOT NULL) THEN
					IF ((SELECT COUNT(*) FROM TIPO_PRODUCTO WHERE Cod_Tipo_Producto = pCodTipProdu) > 0) THEN
						IF (pCantMin IS NOT NULL AND pCantMin>=0) THEN
							IF (pCantMax IS NOT NULL AND pCantMax>pCantMin) THEN
								INSERT INTO PRODUCTO(Cod_Producto, Nombre_Producto, Cod_Tipo_Producto, Cant_Minima, Cant_Maxima)
								VALUES(pCodProdu, pNombProdu, pCodTipProdu, pCantMin, pCantMax);
							ELSE
								SET msgError = 'La cantidad maxima debe ser mayor a la minima';
								SELECT msgError;
							END IF;
						ELSE
							SET msgError = 'La cantidad minima debe ser >= a 0';
							SELECT msgError;
						END IF;
                    ELSE
						SET msgError = 'El codigo de tipo de producto no existe';
						SELECT msgError;
					END IF;
                ELSE
					SET msgError = 'El nombre de producto ingresado no es válido';
					SELECT msgError;
                END IF;
			ELSE
				SET msgError = 'El codigo de producto ya existe';
				SELECT msgError;
            END IF;
		END IF;

		IF (pOperacion = 'READ') THEN
			IF ((SELECT COUNT(*) FROM PRODUCTO WHERE Cod_Producto = pCodProdu) > 0) THEN
				SELECT Cod_Producto, Nombre_Producto, Cod_Tipo_Producto, Cant_Minima, Cant_Maxima
				FROM PRODUCTO
				WHERE Cod_Producto = pCodProdu;
			ELSE
				SET msgError = 'El codigo producto no existe, no se puede realizar la busqueda';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'UPDATE')  THEN
			IF ((SELECT COUNT(*) FROM PRODUCTO WHERE Cod_Producto = pCodProdu) > 0) THEN
					IF ((SELECT COUNT(*) FROM TIPO_PRODUCTO WHERE Cod_Tipo_Producto = pCodTipProdu) > 0) THEN
						IF (pCantMin IS NOT NULL AND pCantMin>=0) THEN
							IF (pCantMax IS NOT NULL AND pCantMax>pCantMin) THEN
								UPDATE PRODUCTO
								SET Nombre_Producto=IFNULL(pNombProdu,Nombre_Producto), Cod_Tipo_Producto=IFNULL(pCodTipProdu,Cod_Tipo_Producto), Cant_Minima=IFNULL(pCantMin,Cant_Minima), Cant_Maxima=IFNULL(pCantMax,Cant_Maxima)
								WHERE Cod_Producto = pCodProdu;
							ELSE
								SET msgError = 'La cantidad maxima es invalida, no se puede actualizar datos';
								SELECT msgError;
							END IF;
						ELSE
							SET msgError = 'La cantidad minima es invalida, no se puede actualizar datos';
							SELECT msgError;
						END IF;
				ELSE
					SET msgError = 'El codigo de tipo de producto no existe, no se puede actualizar datos';
					SELECT msgError;
				END IF;
            ELSE
				SET msgError = 'El codigo de producto no existe, no se puede actualizar datos';
				SELECT msgError;
			END IF;
		END IF;
        
		IF (pOperacion = 'DELETE') THEN
			IF ((SELECT COUNT(*) FROM PRODUCTO WHERE Cod_Producto = pCodProdu) > 0) THEN
				IF ((SELECT COUNT(*) FROM BODEGA_PROVEEDOR_PRODUCTO WHERE Cod_Producto = pCodProdu) = 0) THEN
					IF ((SELECT COUNT(*) FROM BODEGA_SUCURSAL_PRODUCTO WHERE Cod_Producto = pCodProdu) = 0) THEN
						IF ((SELECT COUNT(*) FROM PEDIDO_PRODUCTO WHERE Cod_Producto = pCodProdu) = 0) THEN
							DELETE FROM PRODUCTO
							WHERE Cod_Producto = pCodProdu;
						ELSE
							SET msgError = 'No se puede eliminar, proveedor asociado a pedido de producto';
							SELECT msgError;
						END IF;
                    ELSE
						SET msgError = 'No se puede eliminar, producto asociado a bodega de sucursal';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'No se puede eliminar, producto asociado a bodega de proveedor';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'No se puede eliminar, el codigo de producto no existe';
				SELECT msgError;
			END IF;
		END IF;
        
	ELSE
		SET msgError = 'El codigo de producto es vacío';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ TELEF_PERSO ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_TELEFPERSO(pIdentPers INT, pNumTel VARCHAR(15), pContTelef INT, pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
	IF (pIdentPers IS NOT NULL) THEN
		IF ((SELECT COUNT(*) FROM PERSONA WHERE Identificacion_Per = pIdentPers) > 0)THEN
			IF (pOperacion = 'CREATE') THEN
				IF (pNumTel != '' AND pNumTel IS NOT NULL) THEN
					INSERT INTO TELEF_PERSO(Identificacion_Per, Num_Telef)
					VALUES(pIdentPers, pNumTel);
				ELSE
					SET msgError = 'El numero de telefono está vacío';
					SELECT msgError;
				END IF;
			END IF;

			IF (pOperacion = 'READ') THEN
				IF ((SELECT COUNT(*) FROM TELEF_PERSO WHERE Identificacion_Per = pIdentPers) > 0) THEN
					SELECT Identificacion_Per, Num_Telef, Contador_Telef
					FROM TELEF_PERSO
					WHERE Identificacion_Per = pIdentPers;
				ELSE
					SET msgError = 'La persona no tiene numeros de telefono asociados';
					SELECT msgError;
				END IF;
			END IF;

			IF (pOperacion = 'UPDATE')  THEN
				IF ((SELECT COUNT(*) FROM TELEF_PERSO WHERE Identificacion_Per = pIdentPers) > 0) THEN
					IF ((SELECT COUNT(*) FROM TELEF_PERSO WHERE Contador_Telef = pContTelef) > 0) THEN
						UPDATE TELEF_PERSO
						SET Num_Telef = IFNULL(pNumTel, Num_Telef)
						WHERE Identificacion_Per = pIdentPers AND Contador_Telef = pContTelef;
					ELSE
						SET msgError = 'El ID del telefono no existe, imposible actualizar datos';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'La persona no tiene numeros de telefono asociados';
					SELECT msgError;
				END IF;
			END IF;
			
			IF (pOperacion = 'DELETE') THEN
				IF ((SELECT COUNT(*) FROM TELEF_PERSO WHERE Identificacion_Per = pIdentPers) > 0) THEN
					IF ((SELECT COUNT(*) FROM TELEF_PERSO WHERE Contador_Telef = pContTelef) = 0) THEN
						DELETE FROM TELEF_PERSO
						WHERE Identificacion_Per = pIdentPers AND Contador_Telef = pContTelef;
					ELSE
						SET msgError = 'No se puede eliminar, el ID del telefono no existe';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'La persona no tiene numeros de telefono asociados';
					SELECT msgError;
				END IF;
			END IF;
            
        ELSE
			SET msgError = 'El numero de identificacion no existe';
			SELECT msgError;
	END IF;
    
	ELSE
		SET msgError = 'El numero de cedula es vacío';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ BODEGA_SUCURSAL_PRODUCTO ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_BODESUCUPRODU(pCodBodega INT, pCodProdu INT, pCodSucursal INT, 
										pPrecioCompra FLOAT, pCodProveedor INT, pFechaCompra DATE, pCantActual INT, pFechaProducc DATE, pFechaVenci DATE, pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
    
	IF (pOperacion = 'CREATE') THEN
		IF ((SELECT COUNT(*) FROM SUCURSAL WHERE Cod_Sucursal = pCodSucursal) > 0) THEN
			IF ((SELECT COUNT(*) FROM PRODUCTO WHERE Cod_Producto = pCodProdu) > 0) THEN
				IF ((SELECT COUNT(*) FROM PROVEEDOR WHERE Cod_Proveedor = pCodProveedor) > 0) THEN
					IF (pPrecioCompra IS NOT NULL AND pPrecioCompra >= 0) THEN
						IF (pCantActual IS NOT NULL AND pCantActual >= 0) THEN
							IF (pFechaCompra IS NOT NULL) THEN
								IF (pFechaProducc IS NOT NULL) THEN
									IF (pFechaVenci IS NOT NULL) THEN
										INSERT INTO BODEGA_SUCURSAL_PRODUCTO(Cod_Producto, Cod_Sucursal, Precio_Compra, Cod_Proveedor, Fecha_Compra, Cantidad_Actual, Fecha_Produccion, Fecha_Vencimiento)
										VALUES(pCodProdu, pCodSucursal, pPrecioCompra, pCodProveedor, pFechaCompra, pCantActual, pFechaProducc, pFechaVenci);
									ELSE
										SET msgError = 'La fecha de vencimiento es inválida';
										SELECT msgError;
									END IF;
								ELSE
									SET msgError = 'La fecha de produccion es inválida';
									SELECT msgError;
								END IF;
							ELSE
								SET msgError = 'La fecha de compra es inválida';
								SELECT msgError;
							END IF;
						ELSE
							SET msgError = 'La cantidad comprada es inválida';
							SELECT msgError;
						END IF;
					ELSE
						SET msgError = 'El precio de la compra es inválido';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'El código de proveedor no existe';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'El código de producto no existe';
				SELECT msgError;
			END IF;
		ELSE
			SET msgError = 'El código de sucursal no existe';
			SELECT msgError;
		END IF;
	END IF;
    
	IF (pCodBodega IS NOT NULL) THEN
    
		IF (pOperacion = 'READ') THEN
			IF ((SELECT COUNT(*) FROM BODEGA_SUCURSAL_PRODUCTO WHERE Cod_Bode_Sucu_Produ = pCodBodega) > 0) THEN
				SELECT Cod_Bode_Sucu_Produ, Cod_Producto, Cod_Sucursal, Precio_Compra, Cod_Proveedor, Fecha_Compra, Cantidad_Actual, Fecha_Produccion, Fecha_Vencimiento
				FROM BODEGA_SUCURSAL_PRODUCTO
				WHERE Cod_Bode_Sucu_Produ = pCodBodega;
			ELSE
				SET msgError = 'El codigo de bodega de sucursal no existe,imposible hacer la busqueda';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'UPDATE') THEN
			IF ((SELECT COUNT(*) FROM BODEGA_SUCURSAL_PRODUCTO WHERE Cod_Bode_Sucu_Produ = pCodBodega) > 0) THEN
				IF (pPrecioCompra IS NOT NULL AND pPrecioCompra >= 0) THEN
					IF (pCantActual IS NOT NULL AND pCantActual >= 0) THEN
						UPDATE BODEGA_SUCURSAL_PRODUCTO
						SET Precio_Compra=IFNULL(pPrecioCompra,Precio_Compra),Fecha_Compra=IFNULL(pFechaCompra,Fecha_Compra), Cantidad_Actual=IFNULL(pCantActual,Cantidad_Actual), Fecha_Produccion=IFNULL(pFechaProducc,Fecha_Produccion), Fecha_Vencimiento=IFNULL(pFechaVenci,Fecha_Vencimiento)
						WHERE Cod_Bode_Sucu_Produ = pCodBodega;
					ELSE
						SET msgError = 'La cantidad  actual es inválida, no se puede actualizar';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'El precio de compra es inválido, no se puede actualizar';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'El código de bodega de sucursal no existe, no se puede actualizar';
				SELECT msgError;
			END IF;
		END IF;
        
		IF (pOperacion = 'DELETE') THEN
			IF ((SELECT COUNT(*) FROM BODEGA_SUCURSAL_PRODUCTO WHERE Cod_Bode_Sucu_Produ = pCodBodega) > 0) THEN
				IF ((SELECT COUNT(*) FROM PRODUCTO_EXPIRADO WHERE Cod_Bode_Sucu_Produ = pCodBodega) = 0) THEN
					IF ((SELECT COUNT(*) FROM PEDIDO WHERE Cod_Bode_Sucu_Produ = pCodBodega) = 0) THEN
						DELETE FROM BODEGA_SUCURSAL_PRODUCTO
						WHERE Cod_Bode_Sucu_Produ = pCodBodega;
					ELSE
						SET msgError = 'Imposible eliminar, código de bodega está asociado a pedido';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'Imposible eliminar, código de bodega está asociado a producto expirado';
					SELECT msgError;
				END IF;
            ELSE
				SET msgError = 'No se puede eliminar, el código de bodega de sucursal no existe';
				SELECT msgError;
			END IF;
		END IF;
	
    #el codigo de bodega no es solicitado al crear la bodega, así se evita el mensaje
	ELSEIF ((pCodBodega IS NOT NULL) AND (pOperacion!='CREATE')) THEN
		SET msgError = 'El código de bodega de sucursal está vacío';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ CRIPTOCARTERA ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_CRIPTOCARTERA(pCodCliente INT, pNumCriptoCart VARCHAR(25), pContCriptoC INT, pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
	IF (pCodCliente IS NOT NULL) THEN
		IF ((SELECT COUNT(*) FROM CLIENTE WHERE Cod_Cliente = pCodCliente) > 0)THEN
        
			IF (pOperacion = 'CREATE') THEN
				IF (pNumCriptoCart != '' AND pNumCriptoCart IS NOT NULL) THEN
					INSERT INTO CRIPTOCARTERA(Cod_Cliente, Num_Cripto_Cartera)
					VALUES(pCodCliente, pNumCriptoCart);
				ELSE
					SET msgError = 'El numero de cripto cartera está vacío';
					SELECT msgError;
				END IF;
			END IF;

			IF (pOperacion = 'READ') THEN
				IF ((SELECT COUNT(*) FROM CRIPTOCARTERA WHERE Cod_Cliente = pCodCliente) > 0) THEN
					SELECT Cod_Cliente, Num_Cripto_Cartera, Contador_CriptoCar
					FROM CRIPTOCARTERA
					WHERE Cod_Cliente = pCodCliente;
				ELSE
					SET msgError = 'El cliente no tiene cripto carteras asociadas';
					SELECT msgError;
				END IF;
			END IF;

			IF (pOperacion = 'UPDATE')  THEN
				IF ((SELECT COUNT(*) FROM CRIPTOCARTERA WHERE Cod_Cliente = pCodCliente) > 0) THEN
					IF ((SELECT COUNT(*) FROM CRIPTOCARTERA WHERE Contador_CriptoCar = pContCriptoC) > 0) THEN
						UPDATE CRIPTOCARTERA
						SET Num_Cripto_Cartera = IFNULL(pNumCriptoCart, Num_Cripto_Cartera)
						WHERE Cod_Cliente = pCodCliente AND Contador_CriptoCar = pContCriptoC;
					ELSE
						SET msgError = 'El ID de cripto cartera no existe, imposible actualizar datos';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'El cliente no tiene cripto carteras asociadas';
					SELECT msgError;
				END IF;
			END IF;
			
			IF (pOperacion = 'DELETE') THEN
				IF ((SELECT COUNT(*) FROM CRIPTOCARTERA WHERE Cod_Cliente = pCodCliente) > 0) THEN
					IF ((SELECT COUNT(*) FROM CRIPTOCARTERA WHERE Contador_CriptoCar = pContCriptoC) = 0) THEN
						DELETE FROM CRIPTOCARTERA
						WHERE Cod_Cliente = pCodCliente AND Contador_CriptoCar = pContCriptoC;
					ELSE
						SET msgError = 'El ID de cripto cartera no existe, no se puede eliminar';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'El cliente no tiene cripto carteras asociadas';
					SELECT msgError;
				END IF;
			END IF;
            
			ELSE
				SET msgError = 'El codigo de cliente no existe';
				SELECT msgError;
		END IF;
        
	ELSE
		SET msgError = 'El codigo de cliente es vacío';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ TARJETA_CREDITO ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_TARJECREDI(pCodCliente INT, pNumTarjeCredi VARCHAR(20), pContTarjeCre INT, pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
	IF (pCodCliente IS NOT NULL) THEN
		IF ((SELECT COUNT(*) FROM CLIENTE WHERE Cod_Cliente = pCodCliente) > 0)THEN
        
			IF (pOperacion = 'CREATE') THEN
				IF (pNumTarjeCredi != '' AND pNumTarjeCredi IS NOT NULL) THEN
					INSERT INTO TARJETA_CREDITO(Cod_Cliente, Num_Tarjeta_Credito)
					VALUES(pCodCliente, pNumTarjeCredi);
				ELSE
					SET msgError = 'El numero de tarjeta de credito está vacío';
					SELECT msgError;
				END IF;
			END IF;

			IF (pOperacion = 'READ') THEN
				IF ((SELECT COUNT(*) FROM TARJETA_CREDITO WHERE Cod_Cliente = pCodCliente) > 0) THEN
					SELECT Cod_Cliente, Num_Tarjeta_Credito, Contador_TarjCre
					FROM TARJETA_CREDITO
					WHERE Cod_Cliente = pCodCliente;
				ELSE
					SET msgError = 'El cliente no tiene cripto carteras asociadas';
					SELECT msgError;
				END IF;
			END IF;

			IF (pOperacion = 'UPDATE')  THEN
				IF ((SELECT COUNT(*) FROM TARJETA_CREDITO WHERE Cod_Cliente = pCodCliente) > 0) THEN
					IF ((SELECT COUNT(*) FROM TARJETA_CREDITO WHERE Contador_TarjCre = pContTarjeCre) > 0) THEN
						UPDATE TARJETA_CREDITO
						SET Num_Tarjeta_Credito = IFNULL(pNumTarjeCredi, Num_Tarjeta_Credito)
						WHERE Cod_Cliente = pCodCliente AND Contador_TarjCre = pContTarjeCre;
					ELSE
						SET msgError = 'El ID de tarjeta de credito no existe, imposible actualizar datos';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'El cliente no tiene tarjetas de credito asociadas';
					SELECT msgError;
				END IF;
			END IF;
			
			IF (pOperacion = 'DELETE') THEN
				IF ((SELECT COUNT(*) FROM TARJETA_CREDITO WHERE Cod_Cliente = pCodCliente) > 0) THEN
					IF ((SELECT COUNT(*) FROM TARJETA_CREDITO WHERE Contador_TarjCre = pContTarjeCre) > 0) THEN
						DELETE FROM TARJETA_CREDITO
						WHERE Cod_Cliente = pCodCliente AND Contador_TarjCre = pContTarjeCre;
					ELSE
						SET msgError = 'El ID de tarjeta de credito no existe, no se puede eliminar';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'El cliente no tiene tarjetas de credito asociadas';
					SELECT msgError;
				END IF;
			END IF;
            
			ELSE
				SET msgError = 'El codigo de cliente no existe';
				SELECT msgError;
		END IF;
        
	ELSE
		SET msgError = 'El codigo de cliente es vacío';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ CHEQUE ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_CHEQUE(pCodCliente INT, pNumCheque VARCHAR(20), pContCheque INT, pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
	IF (pCodCliente IS NOT NULL) THEN
		IF ((SELECT COUNT(*) FROM CLIENTE WHERE Cod_Cliente = pCodCliente) > 0)THEN
        
			IF (pOperacion = 'CREATE') THEN
				IF (pNumCheque != '' AND pNumCheque IS NOT NULL) THEN
					INSERT INTO CHEQUE(Cod_Cliente, Num_Cheque)
					VALUES(pCodCliente, pNumCheque);
				ELSE
					SET msgError = 'El numero de cheque está vacío';
					SELECT msgError;
				END IF;
			END IF;

			IF (pOperacion = 'READ') THEN
				IF ((SELECT COUNT(*) FROM CHEQUE WHERE Cod_Cliente = pCodCliente) > 0) THEN
					SELECT Cod_Cliente, Num_Cheque, Contador_Cheque
					FROM CHEQUE
					WHERE Cod_Cliente = pCodCliente;
				ELSE
					SET msgError = 'El cliente no tiene cheques asociados';
					SELECT msgError;
				END IF;
			END IF;

			IF (pOperacion = 'UPDATE')  THEN
				IF ((SELECT COUNT(*) FROM CHEQUE WHERE Cod_Cliente = pCodCliente) > 0) THEN
					IF ((SELECT COUNT(*) FROM CHEQUE WHERE Contador_Cheque = pContCheque) > 0) THEN
						UPDATE CHEQUE
						SET Num_Cheque = IFNULL(pNumCheque, Num_Cheque)
						WHERE Cod_Cliente = pCodCliente AND Contador_Cheque = pContCheque;
					ELSE
						SET msgError = 'El ID de cheque no existe, imposible actualizar datos';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'El cliente no tiene cheques asociados';
					SELECT msgError;
				END IF;
			END IF;
			
			IF (pOperacion = 'DELETE') THEN
				IF ((SELECT COUNT(*) FROM CHEQUE WHERE Cod_Cliente = pCodCliente) > 0) THEN
					IF ((SELECT COUNT(*) FROM CHEQUE WHERE Contador_Cheque = pContCheque) > 0) THEN
						DELETE FROM CHEQUE
						WHERE Cod_Cliente = pCodCliente AND Contador_Cheque = pContCheque;
					ELSE
						SET msgError = 'El ID de cheque no existe, no se puede eliminar';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'El cliente no tiene cheques asociados';
					SELECT msgError;
				END IF;
			END IF;
            
			ELSE
				SET msgError = 'El codigo de cliente no existe';
				SELECT msgError;
		END IF;
        
	ELSE
		SET msgError = 'El codigo de cliente es vacío';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ BODEGA_PROVEEDOR_PRODUCTO ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_BODEPROVEPRODU(pCodBodega INT, pCodProvee INT, pCodProdu INT, pPrecioVenta FLOAT, pCantBodega INT, 
															pFechaProducc DATE, pFechaVenci DATE, pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
    
	IF (pOperacion = 'CREATE') THEN
		IF ((SELECT COUNT(*) FROM PROVEEDOR WHERE Cod_Proveedor = pCodProvee) > 0) THEN
			IF ((SELECT COUNT(*) FROM PRODUCTO WHERE Cod_Producto = pCodProdu) > 0) THEN
				IF (pPrecioVenta IS NOT NULL AND pPrecioVenta >= 0) THEN
					IF (pCantBodega IS NOT NULL AND pCantBodega >= 0) THEN
						IF (pFechaProducc IS NOT NULL) THEN
							IF (pFechaVenci IS NOT NULL) THEN
								INSERT INTO BODEGA_PROVEEDOR_PRODUCTO(Cod_Proveedor, Cod_Producto, Precio_Venta, Cantidad_En_Bodega, Fecha_Produccion, Fecha_Vencimiento)
								VALUES(pCodProvee, pCodProdu, pPrecioVenta, pCantBodega, pFechaProducc, pFechaVenci);
							ELSE
								SET msgError = 'La fecha de vencimiento es inválida';
								SELECT msgError;
							END IF;
						ELSE
							SET msgError = 'La fecha de producción es inválida';
							SELECT msgError;
						END IF;
					ELSE
						SET msgError = 'La cantidad en bodega es inválida';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'El precio de venta es inválido';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'El código de producto no existe';
				SELECT msgError;
			END IF;
		ELSE
			SET msgError = 'El código de proveedor no existe';
			SELECT msgError;
		END IF;
	END IF;
    
	IF (pCodBodega IS NOT NULL) THEN
    
		IF (pOperacion = 'READ') THEN
			IF ((SELECT COUNT(*) FROM BODEGA_PROVEEDOR_PRODUCTO WHERE Cod_Bode_Provee_Produ = pCodBodega) > 0) THEN
				SELECT Cod_Bode_Provee_Produ, Cod_Proveedor, Cod_Producto, Precio_Venta, Cantidad_En_Bodega, Fecha_Produccion, Fecha_Vencimiento
				FROM BODEGA_PROVEEDOR_PRODUCTO
				WHERE Cod_Bode_Provee_Produ = pCodBodega;
			ELSE
				SET msgError = 'El codigo de bodega de proveedor no existe,imposible hacer la busqueda';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'UPDATE')  THEN
			IF ((SELECT COUNT(*) FROM BODEGA_PROVEEDOR_PRODUCTO WHERE Cod_Bode_Provee_Produ = pCodBodega) > 0) THEN
				IF (pPrecioVenta IS NOT NULL AND pPrecioVenta >= 0) THEN
					IF (pCantBodega IS NOT NULL AND pCantBodega >= 0) THEN
						UPDATE BODEGA_PROVEEDOR_PRODUCTO
						SET Precio_Venta=IFNULL(pPrecioVenta,Precio_Venta), Cantidad_En_Bodega=IFNULL(pCantBodega,Cantidad_En_Bodega), Fecha_Produccion=IFNULL(pFechaProducc,Fecha_Produccion), Fecha_Vencimiento=IFNULL(pFechaVenci,Fecha_Vencimiento)
						WHERE Cod_Bode_Provee_Produ = pCodBodega;
					ELSE
						SET msgError = 'La cantidad en bodega es inválida, no se puede actualizar';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'El precio de venta es inválido, no se puede actualizar';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'El código de bodega de proveedor no existe, no se puede actualizar';
				SELECT msgError;
			END IF;
		END IF;
        
		IF (pOperacion = 'DELETE') THEN
			IF ((SELECT COUNT(*) FROM BODEGA_PROVEEDOR_PRODUCTO WHERE Cod_Bode_Provee_Produ = pCodBodega) > 0) THEN
				DELETE FROM BODEGA_PROVEEDOR_PRODUCTO
				WHERE Cod_Bode_Provee_Produ = pCodBodega;
            ELSE
				SET msgError = 'No se puede eliminar, el código de bodega de proveedor no existe';
				SELECT msgError;
			END IF;
		END IF;
	
    #el codigo de bodega no es solicitado al crear la bodega, así se evita el mensaje
	ELSEIF ((pCodBodega IS NOT NULL) AND (pOperacion!='CREATE')) THEN
		SET msgError = 'El código de bodega de proveedor está vacío';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ BONOS_EMPLEADO ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_BONOSEMP(pNumBono INT,  pCodEmpleado INT, pMontoBono FLOAT, pFechaBono DATE, pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';

	IF (pOperacion = 'CREATE') THEN
		IF ((SELECT COUNT(*) FROM EMPLEADO WHERE Cod_Empleado = pCodEmpleado) > 0) THEN
			IF (pMontoBono IS NOT NULL AND pMontoBono>=0) THEN
				IF (pFechaBono IS NOT NULL) THEN
					INSERT INTO BONOS_EMPLEADO(Cod_Empleado, MontoBono, Fecha_Bono)
					VALUES(pCodEmpleado, pMontoBono, pFechaBono);
				ELSE
					SET msgError = 'La fecha ingresada no es valida';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'El monto de bono ingresado no es valido';
				SELECT msgError;
			END IF;
		ELSE
			SET msgError = 'El codigo de empleado no existe';
			SELECT msgError;
		END IF;
	END IF;

	IF (pCodEmpleado IS NOT NULL) THEN
		IF (pOperacion = 'READ') THEN
			IF ((SELECT COUNT(*) FROM BONOS_EMPLEADO WHERE Num_Bono = pNumBono) > 0) THEN
				SELECT Num_Bono, Cod_Empleado, MontoBono, Fecha_Bono
				FROM BONOS_EMPLEADO
				WHERE Num_Bono = pNumBono;
			ELSE
				SET msgError = 'El codigo bono no existe, no se puede realizar la busqueda';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'UPDATE')  THEN
			IF ((SELECT COUNT(*) FROM BONOS_EMPLEADO WHERE Num_Bono = pNumBono) > 0) THEN
				IF (pMontoBono IS NOT NULL AND pMontoBono>=0) THEN
					UPDATE BONOS_EMPLEADO
					SET MontoBono=IFNULL(pMontoBono,MontoBono), Fecha_Bono=IFNULL(pFechaBono,Fecha_Bono)
					WHERE Num_Bono = pNumBono;
				ELSE
					SET msgError = 'El monto de bono ingresado no es valido, no se puede actualizar datos';
					SELECT msgError;
				END IF;
            ELSE
				SET msgError = 'El codigo de bono no existe, no se puede actualizar datos';
				SELECT msgError;
			END IF;
		END IF;
        
		IF (pOperacion = 'DELETE') THEN
			IF ((SELECT COUNT(*) FROM BONOS_EMPLEADO WHERE Num_Bono = pNumBono) > 0) THEN
				DELETE FROM BONOS_EMPLEADO
				WHERE Num_Bono = pNumBono;
			ELSE
				SET msgError = 'No se puede eliminar, el codigo de bono no existe';
				SELECT msgError;
			END IF;
		END IF;
	
    #el codigo de bono no es solicitado al crear el bono, así se evita el mensaje
	ELSEIF ((pCodEmpleado IS NOT NULL) AND (pOperacion!='CREATE')) THEN
		SET msgError = 'El codigo de bono es vacío';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ ESTADO_PEDIDO ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_ESTADOP(pIDEstadoP INT,  pDescripEstP VARCHAR(15), pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
	IF (pIDEstadoP IS NOT NULL) THEN
    
		IF (pOperacion = 'CREATE') THEN
			IF ((SELECT COUNT(*) FROM ESTADO_PEDIDO WHERE ID_EstadoP = pIDEstadoP) = 0) THEN
				IF (pDescripEstP != '' AND pDescripEstP IS NOT NULL) THEN
					INSERT INTO ESTADO_PEDIDO(ID_EstadoP, Descripcion_EstadoP)
					VALUES(pIDEstadoP, pDescripEstP);
				ELSE
					SET msgError = 'La descripción del estado de pedido está vacía';
					SELECT msgError;
                END IF;
			ELSE
				SET msgError = 'El ID de estado de pedido ya existe';
				SELECT msgError;
            END IF;
		END IF;

		IF (pOperacion = 'READ') THEN
			IF ((SELECT COUNT(*) FROM ESTADO_PEDIDO WHERE ID_EstadoP = pIDEstadoP) > 0) THEN
				SELECT ID_EstadoP, Descripcion_EstadoP
				FROM ESTADO_PEDIDO
				WHERE ID_EstadoP = pIDEstadoP;
			ELSE
				SET msgError = 'El ID de estado de pedido no existe, no se puede realizar la busqueda';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'UPDATE')  THEN
			IF ((SELECT COUNT(*) FROM ESTADO_PEDIDO WHERE ID_EstadoP = pIDEstadoP) > 0) THEN
				UPDATE ESTADO_PEDIDO
				SET Descripcion_EstadoP = IFNULL(pDescripEstP, Descripcion_EstadoP)
				WHERE ID_EstadoP = pIDEstadoP;
			ELSE
				SET msgError = 'El ID de estado de pedido no existe, no se pudo actualizar los datos';
				SELECT msgError;
			END IF;
		END IF;
        
		IF (pOperacion = 'DELETE') THEN
			IF ((SELECT COUNT(*) FROM ESTADO_PEDIDO WHERE ID_EstadoP = pIDEstadoP) > 0) THEN
				IF ((SELECT COUNT(*) FROM PEDIDO WHERE ID_EstadoP = pIDEstadoP) = 0) THEN
					DELETE FROM ESTADO_PEDIDO
					WHERE ID_EstadoP = pIDEstadoP;
				ELSE
					SET msgError = 'No se puede eliminar, estado de pedido asociado a pedido';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'No se puede eliminar, el estado de pedido no existe';
				SELECT msgError;
			END IF;
		END IF;
	
	ELSE
		SET msgError = 'El ID de estado de pedido está vacío';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ PEDIDO ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_PEDIDO(pNumPedido INT, pFechaPedido DATE, pCodCliente INT, pIDEstadoP INT, pEnvio BOOL, pCodSucursal INT, pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
	IF (pNumPedido IS NOT NULL) THEN
        
		IF (pOperacion = 'CREATE') THEN
			IF ((SELECT COUNT(*) FROM PEDIDO WHERE Num_Pedido = pNumPedido) = 0) THEN
				IF (pFechaPedido IS NOT NULL) THEN
					IF ((SELECT COUNT(*) FROM CLIENTE WHERE Cod_Cliente = pCodCliente) > 0) THEN
						IF ((SELECT COUNT(*) FROM ESTADO_PEDIDO WHERE ID_EstadoP = pIDEstadoP) > 0) THEN
							IF (pEnvio IS NOT NULL) THEN
								IF ((SELECT COUNT(*) FROM SUCURSAL WHERE Cod_Sucursal = pCodSucursal) > 0) THEN
									INSERT INTO PEDIDO(Num_Pedido, Fecha_Pedido, Cod_Cliente, ID_EstadoP, Envio,Cod_Sucursal)
									VALUES(pNumPedido, pFechaPedido, pCodCliente, pIDEstadoP, pEnvio, pCodSucursal);
								ELSE
									SET msgError = 'El codigo del sucursal no existe';
									SELECT msgError;
								END IF;
                            ELSE
								SET msgError = 'El dato del envío es nulo';
								SELECT msgError;
							END IF;
						ELSE
							SET msgError = 'El codigo del estado del pedido no existe';
							SELECT msgError;
						END IF;
					ELSE
						SET msgError = 'El codigo de cliente no existe';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'La fecha de la factura es inválida';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'El numero de pedido ya existe';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'READ') THEN
			IF ((SELECT COUNT(*) FROM PEDIDO WHERE Num_Pedido = pNumPedido) > 0) THEN
				SELECT Num_Pedido, Fecha_Pedido, Cod_Cliente, ID_EstadoP, Envio, Cod_Bode_Sucu_Produ
				FROM PEDIDO
				WHERE Num_Pedido = pNumPedido;
			ELSE
				SET msgError = 'El numero de pedido no existe, no se puede realizar la busqueda';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'UPDATE')  THEN
			IF ((SELECT COUNT(*) FROM PEDIDO WHERE Num_Pedido = pNumPedido) > 0) THEN
				IF ((SELECT COUNT(*) FROM ESTADO_PEDIDO WHERE ID_EstadoP = pIDEstadoP) > 0) THEN
					UPDATE PEDIDO
					SET Envio = IFNULL(pEnvio,Envio), ID_EstadoP = IFNULL(pIDEstadoP,ID_EstadoP)
					WHERE Num_Pedido = pNumPedido;
				ELSE
					SET msgError = 'El codigo de estado de pedido no existe, no se puede actualizar datos';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'El numero de pedido no existe, no se puede actualizar datos';
				SELECT msgError;
			END IF;
		END IF;
		
		IF (pOperacion = 'DELETE') THEN
			IF ((SELECT COUNT(*) FROM PEDIDO WHERE Num_Pedido = pNumPedido) > 0) THEN
				IF ((SELECT COUNT(*) FROM PEDIDO_PRODUCTO WHERE Num_Pedido = pNumPedido) > 0) THEN
					IF ((SELECT COUNT(*) FROM FACTURA WHERE Num_Pedido = pNumPedido) > 0) THEN
							DELETE FROM PEDIDO
							WHERE Num_Pedido = pNumPedido;
					ELSE
						SET msgError = 'No se puede eliminar, el numero de pedido esta asociado a una factura';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'No se puede eliminar, el pedido esta asociado a una orden de productos';
					SELECT msgError;
				END IF;
			ELSE
				SET msgError = 'No se puede eliminar, el numero de pedido no existe';
				SELECT msgError;
			END IF;
		END IF;
            
	ELSE
		SET msgError = 'El numero de pedido es vacío';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ PEDIDO_PRODUCTO ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_PEDIDOxPRODU(pNumPedido INT, pCodProdu INT, pCantProdu INT, pPorcenDesc FLOAT, pMotivoDesc VARCHAR(15),  pOperacion VARCHAR(10))
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
DECLARE Cod_Bodega_Sucu_Producto INT;
DECLARE nuevo_Total INT;

	IF (pNumPedido IS NOT NULL) THEN
		IF (pCodProdu IS NOT NULL) THEN
        
			IF (pOperacion = 'CREATE') THEN
				IF ((SELECT COUNT(*) FROM PEDIDO WHERE Num_Pedido = pNumPedido) > 0) THEN
					IF ((SELECT COUNT(*) FROM PRODUCTO WHERE Cod_Producto = pCodProdu) > 0) THEN
						IF (pPorcenDesc IS NOT NULL AND pPorcenDesc>=0) THEN
							IF (pCantProdu IS NOT NULL AND pCantProdu>0) THEN
								SET Cod_Bodega_Sucu_Producto = (SELECT Cod_Sucursal FROM PEDIDO WHERE Num_Pedido = pNumPedido);
								IF (SELECT Cantidad_Actual FROM BODEGA_SUCURSAL_PRODUCTO WHERE BODEGA_SUCURSAL_PRODUCTO.Cod_Sucursal = Cod_Bodega_Sucu_Producto AND
										BODEGA_SUCURSAL_PRODUCTO.Cod_Producto = pCodProdu AND Cantidad_Actual >=pCantProdu) THEN
									INSERT INTO PEDIDO_PRODUCTO(Num_Pedido, Cod_Producto, Cantidad_Producto, Porcentaje_Desc, Motivo_Desc)
									VALUES(pNumPedido, pCodProdu, pCantProdu, pPorcenDesc, pMotivoDesc);
                                    SET nuevo_Total = (SELECT Cantidad_Actual FROM BODEGA_SUCURSAL_PRODUCTO WHERE BODEGA_SUCURSAL_PRODUCTO.Cod_Sucursal = Cod_Bodega_Sucu_Producto AND
										BODEGA_SUCURSAL_PRODUCTO.Cod_Producto = pCodProdu) - pCantProdu;
                                    CALL CRUD_BODESUCUPRODU ((SELECT COD_BODE_SUCU_PRODU FROM BODEGA_SUCURSAL_PRODUCTO WHERE pCodProdu = BODEGA_SUCURSAL_PRODUCTO.COD_PRODUCTO), 
															null, null, (SELECT PRECIO_COMPRA FROM BODEGA_SUCURSAL_PRODUCTO WHERE pCodProdu = BODEGA_SUCURSAL_PRODUCTO.COD_PRODUCTO), 
                                                            null, null, nuevo_Total, null, null, 'UPDATE');
								ELSE
									SET msgError = 'La sucursal tiene menos productos que los solicitados';
									SELECT msgError;
								END IF;
							ELSE
								SET msgError = 'La cantidad de productos es inválida';
								SELECT msgError;
							END IF;
						ELSE
							SET msgError = 'El porcentaje de descuento es inválido';
							SELECT msgError;
						END IF;
					ELSE
						SET msgError = 'El codigo de producto no existe';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'El numero de pedido no existe';
					SELECT msgError;
				END IF;
			END IF;

			IF (pOperacion = 'READ') THEN
				IF ((SELECT COUNT(*) FROM PEDIDO WHERE Num_Pedido = pNumPedido) > 0) THEN
					IF ((SELECT COUNT(*) FROM PRODUCTO WHERE Cod_Producto = pCodProdu) > 0) THEN
						SELECT Num_Pedido, Cod_Producto, Cantidad_Producto, Porcentaje_Desc, Motivo_Desc
						FROM PEDIDO_PRODUCTO
						WHERE Num_Pedido = pNumPedido AND Cod_Producto = pCodProdu;
					ELSE
						SET msgError = 'El codigo de producto no existe, no se puede realizar la busqueda';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'El numero de pedido no existe, no se puede realizar la busqueda';
					SELECT msgError;
				END IF;
			END IF;

			IF (pOperacion = 'UPDATE')  THEN
				IF ((SELECT COUNT(*) FROM PEDIDO WHERE Num_Pedido = pNumPedido) > 0) THEN
					IF ((SELECT COUNT(*) FROM PRODUCTO WHERE Cod_Producto = pCodProdu) > 0) THEN
							IF (pPorcenDesc IS NOT NULL AND pPorcenDesc>=0) THEN
								IF (pCantProdu IS NOT NULL AND pCantProdu>0) THEN
									SET Cod_Bodega_Sucu_Producto = (SELECT Cod_Sucursal FROM PEDIDO WHERE Num_Pedido = pNumPedido);
									IF (SELECT Cantidad_Actual FROM BODEGA_SUCURSAL_PRODUCTO WHERE BODEGA_SUCURSAL_PRODUCTO.Cod_Sucursal = Cod_Bodega_Sucu_Producto AND
											BODEGA_SUCURSAL_PRODUCTO.Cod_Producto = pCodProdu AND Cantidad_Actual >=pCantProdu) THEN
										UPDATE PEDIDO_PRODUCTO
										SET Cantidad_Producto = IFNULL(pCantProdu,Cantidad_Producto), Porcentaje_Desc=IFNULL(pPorcenDesc,Porcentaje_Desc), Motivo_Desc=IFNULL(pMotivoDesc,Motivo_Desc)
										WHERE Num_Pedido = pNumPedido AND Cod_Producto=pCodProdu;
                                        SET nuevo_Total = (SELECT Cantidad_Actual FROM BODEGA_SUCURSAL_PRODUCTO WHERE BODEGA_SUCURSAL_PRODUCTO.Cod_Sucursal = Cod_Bodega_Sucu_Producto AND
										BODEGA_SUCURSAL_PRODUCTO.Cod_Producto = pCodProdu) - pCantProdu;
										CALL CRUD_BODESUCUPRODU ((SELECT COD_BODE_SUCU_PRODU FROM BODEGA_SUCURSAL_PRODUCTO WHERE pCodProdu = BODEGA_SUCURSAL_PRODUCTO.COD_PRODUCTO), 
															null, null, (SELECT PRECIO_COMPRA FROM BODEGA_SUCURSAL_PRODUCTO WHERE pCodProdu = BODEGA_SUCURSAL_PRODUCTO.COD_PRODUCTO), 
                                                            null, null, nuevo_Total, null, null, 'UPDATE');
                                    ELSE
										SET msgError = 'La sucursal tiene menos productos que los solicitados';
										SELECT msgError;
									END IF;
								ELSE
									SET msgError = 'La cantidad de productos es inválida, no se puede actualizar datos';
									SELECT msgError;
								END IF;
							ELSE
								SET msgError = 'El porcentaje de descuento es inválido, no se puede actualizar datos';
								SELECT msgError;
							END IF;
					ELSE
						SET msgError = 'El codigo de producto no existe, no se puede actualizar datos';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'El numero de pedido no existe, no se puede actualizar datos';
					SELECT msgError;
				END IF;
			END IF;
			
			IF (pOperacion = 'DELETE') THEN
				IF ((SELECT COUNT(*) FROM PEDIDO WHERE Num_Pedido = pNumPedido) > 0) THEN
					IF ((SELECT COUNT(*) FROM PRODUCTO WHERE Cod_Producto = pCodProdu) > 0) THEN
							DELETE FROM PEDIDO_PRODUCTO
							WHERE Num_Pedido = pNumPedido AND Cod_Producto=pCodProdu;
					ELSE
						SET msgError = 'No se puede eliminar, el codigo de producto no existe';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'No se puede eliminar, el numero de pedido no existe';
					SELECT msgError;
				END IF;
			END IF;
            
        ELSE
			SET msgError = 'El codigo de producto es vacío';
			SELECT msgError;
		END IF;
	ELSE
		SET msgError = 'El numero de pedido es vacío';
        SELECT msgError;
	END IF;
END;
//

/*------------------------------------------------------------ PRODUCTO_EXPIRADO ------------------------------------------------------------*/
delimiter //
CREATE PROCEDURE CRUD_PRODUCTO_EXPIRADO(pCodProduExp INT, pCodProdu INT, pCantProExp INT, pBodeSucuProdu INT, pOperacion VARCHAR(10)) 
BEGIN
DECLARE msgError VARCHAR(70) DEFAULT '';
    
	IF (pOperacion = 'CREATE') THEN
		IF ((SELECT COUNT(*) FROM PRODUCTO WHERE Cod_Producto = pCodProdu) = 0) THEN
				IF ((SELECT COUNT(*) FROM BODEGA_SUCURSAL_PRODUCTO WHERE Cod_Bode_Sucu_Produ = pBodeSucuProdu) > 0) THEN
					IF (pCantProExp IS NOT NULL AND pCantProExp>=0) THEN
							INSERT INTO PRODUCTO_EXPIRADO (Cod_Producto, Cantidad_Productos, Cod_Bode_Sucu_Produ) 
							VALUES (pCodProdu, pCantProExp, pBodeSucuProdu);
					ELSE
						SET msgError = 'La cantidad de productos expirados no es válida';
						SELECT msgError;
					END IF;
				ELSE
					SET msgError = 'El código de bodega sucursal no existe';
					SELECT msgError;
				END IF;
		ELSE
			SET msgError = 'El código de producto no existe';
			SELECT msgError;
		END IF;
	END IF;
    
	IF (pCodProdu IS NOT NULL) THEN
    
		IF (pOperacion = 'READ') THEN
			IF ((SELECT COUNT(*) FROM PRODUCTO_EXPIRADO WHERE Cod_Producto_Exp = pCodProduExp) > 0) THEN
				SELECT Cod_Producto, Cantidad_Productos, Cod_Bode_Sucu_Produ
				FROM PRODUCTO_EXPIRADO
				WHERE Cod_Producto_Exp = pCodProduExp;
			ELSE
				SET msgError = 'El codigo producto expirado no existe, imposible realizar la busqueda';
				SELECT msgError;
			END IF;
		END IF;

		IF (pOperacion = 'UPDATE')  THEN
			IF ((SELECT COUNT(*) FROM PRODUCTO_EXPIRADO WHERE Cod_Producto_Exp = pCodProduExp) > 0) THEN
				IF (pCantProExp IS NOT NULL AND pCantProExp>=0) THEN
						UPDATE PRODUCTO_EXPIRADO
						SET Cantidad_Productos=IFNULL(pCantProExp,Cantidad_Productos)
						WHERE Cod_Producto_Exp = pCodProduExp;
					ELSE
						SET msgError = 'Cantidad de productos expirados es inválida,imposible actualizar datos';
						SELECT msgError;
					END IF;
            ELSE
				SET msgError = 'El codigo de producto expirado no existe, no se puede actualizar datos';
				SELECT msgError;
			END IF;
		END IF;
        
		IF (pOperacion = 'DELETE') THEN
			IF ((SELECT COUNT(*) FROM PRODUCTO_EXPIRADO WHERE Cod_Producto_Exp = pCodProduExp) > 0) THEN
				DELETE FROM PRODUCTO_EXPIRADO
				WHERE Cod_Producto_Exp = pCodProduExp;
			 ELSE
				SET msgError = 'El codigo de producto expirado no existe, no se puede eliminar datos';
				SELECT msgError;
			END IF;
		END IF;
        
    #el codigo de producto expirado no es solicitado al crear el registro, así se evita el mensaje
	ELSEIF ((pCodEmpleado IS NOT NULL) AND (pOperacion!='CREATE')) THEN
		SET msgError = 'El codigo de producto expirado es vacío';
        SELECT msgError;
	END IF;
END;
//

/*-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------PROCEDURES----------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------*/

DELIMITER //
/*------------------------------------------------------------ CANTIDAD DE TIEMPO QUE LLEVA TRABAJANDO UN EMPLEADO ------------------------------------------------------------*/
CREATE FUNCTION TIEMPO_LABORAL_EMPLEADO (pCodEmpleado INT) RETURNS INT
BEGIN
	DECLARE DIAS_LABORADOS INT;
    DECLARE Fecha_Actual DATE;
    SET Fecha_Actual = NOW();
    
    SELECT DATEDIFF(Fecha_Actual, EMPLEADO.Fecha_Contratado) AS 'TIEMPO LABORANDO'
	INTO DIAS_LABORADOS
    FROM EMPLEADO
    WHERE pCodEmpleado = EMPLEADO.Cod_Empleado;
    
    RETURN DIAS_LABORADOS;
END
//

DELIMITER //
/*------------------------------------------------------------ CANTIDAD DE FACTURAS QUE REALIZA UN EMPLEADO ------------------------------------------------------------*/
CREATE FUNCTION CANTIDAD_FACTURAS_EMPLEADO (pCodEmpleado INT) RETURNS INT
BEGIN
	DECLARE FACTURACIONES INT;
    SELECT COUNT(FACTURA.Num_Factura)
    INTO FACTURACIONES
	FROM FACTURA
	WHERE pCodEmpleado = FACTURA.Cod_Empleado;
    RETURN FACTURACIONES;
END
//

DELIMITER //
/*------------------------------------------------------------ CANTIDAD DE EMPLEADOS DE UNA SUCURSAL ------------------------------------------------------------*/
CREATE PROCEDURE EMPLEADOS_SUCURSAL (pCodSucursal INT)
BEGIN
	SELECT SUCURSAL.NOMBRE_SUCURSAL AS 'SUCURSAL', COUNT(EMPLEADO.Cod_Empleado) AS 'CANTIDAD DE EMPLEADOS'
	FROM EMPLEADO
	INNER JOIN SUCURSAL ON EMPLEADO.Cod_Sucursal = SUCURSAL.Cod_Sucursal	
	WHERE pCodSucursal = SUCURSAL.Cod_Sucursal;
END
//

DELIMITER //
/*------------------------------------------------------------ CANTIDAD DE PRODUCTOS EN UNA SUCURSAL ------------------------------------------------------------*/
CREATE PROCEDURE PRODUCTOS_SUCURSAL(pCodSucursal INT)
BEGIN
	SELECT 
		(SELECT NOMBRE_SUCURSAL FROM SUCURSAL WHERE pCodSucursal = SUCURSAL.COD_SUCURSAL) AS 'SUCURSAL', 
		SUM(BODEGA_SUCURSAL_PRODUCTO.Cantidad_Actual) AS 'CANTIDAD DE PRODUCTOS'
	FROM BODEGA_SUCURSAL_PRODUCTO
	WHERE pCodSucursal = BODEGA_SUCURSAL_PRODUCTO.Cod_Sucursal;
END
//

DELIMITER //
/*------------------------------------------------------------ CANTIDAD DE SUCURSALES EN UN PAIS ------------------------------------------------------------*/
CREATE PROCEDURE SUCURSALES_PAIS (pCodPais INT)
BEGIN
SELECT 
	(SELECT NOMBRE_PAIS FROM PAIS WHERE pCodPais = PAIS.Cod_Pais) AS 'PAIS', 
			COUNT(SUCURSAL.Cod_Sucursal) AS 'NUM_SUCURSALES'
	FROM SUCURSAL
	INNER JOIN CIUDAD ON SUCURSAL.Cod_Ciudad = CIUDAD.Cod_Ciudad
	INNER JOIN PROVINCIA ON CIUDAD.Cod_Provincia = PROVINCIA.Cod_Provincia
	INNER JOIN PAIS ON PROVINCIA.Cod_Pais = PAIS.Cod_Pais
	WHERE pCodPais = PAIS.Cod_Pais;
END
//

DELIMITER //
/*------------------------------------------------------------ DINERO GANADO POR HORA DE UN EMPLEADO ------------------------------------------------------------*/
CREATE PROCEDURE EMPLEADO_DINERO_HORA (pCodEmpleado INT)
BEGIN
	SELECT 
			(SELECT NOMBRE FROM PERSONA INNER JOIN EMPLEADO ON PERSONA.IDENTIFICACION_PER = EMPLEADO.IDENTIFICACION_PER WHERE pCodEmpleado = EMPLEADO.Cod_Empleado) AS 'NOMBRE', 
			PUESTO_LABORAL.Salario_Mensual/(EMPLEADO.Horas_Laborales*4) AS 'DINERO GANADO POR HORA' # horas_laborales son semanales *4 = mensuales
	FROM EMPLEADO
	INNER JOIN PUESTO_LABORAL 
	ON EMPLEADO.Cod_Puesto_Laboral = PUESTO_LABORAL.Cod_Puesto_Laboral
	WHERE pCodEmpleado = EMPLEADO.Cod_Empleado;
END
//

DELIMITER //
/*------------------------------------------------------------ CANTIDAD DE EMPLEADOS POR PUESTO ------------------------------------------------------------*/
CREATE PROCEDURE EMPLEADO_CATEGORIA (pCodPuestoLabo INT)
BEGIN
    SELECT
		PUESTO_LABORAL.Descrip_Pues_Lab AS 'PUESTO LABORAL',
		COUNT(EMPLEADO.Cod_Empleado) AS 'CANTIDAD DE EMPLEADOS'
	FROM EMPLEADO
    INNER JOIN PUESTO_LABORAL ON EMPLEADO.Cod_Puesto_Laboral = PUESTO_LABORAL.Cod_Puesto_Laboral
	WHERE pCodPuestoLabo = EMPLEADO.Cod_Puesto_Laboral;
END
//

DELIMITER //
/*------------------------------------------------------------ CANTIDAD DE VECES QUE UN CLIENTE HA COMPRADO ------------------------------------------------------------*/
CREATE PROCEDURE COMPRAS_CLIENTE (pCodCliente INT)
BEGIN
    SELECT
		COUNT(FACTURA.Num_Factura) AS 'CANTIDAD DE COMPRAS'
	FROM
		FACTURA
	WHERE
		pCodCliente = FACTURA.Cod_Cliente;
END;
//cliente

SET GLOBAL LOG_BIN_TRUST_FUNCTION_CREATORS = 1;

DELIMITER  //
/*--------------------------------------------------- CANTIDAD DE DIAS QUE HACEN FALTA PARA QUE CADUQUE UN PRODUCTO --------------------------------------------------*/
CREATE FUNCTION DIAS_CADUCIDAD_PRODUCTO (COD_PRODUCTO INT) RETURNS INT
BEGIN
	DECLARE CADUCIDAD_DIAS INT;
    DECLARE FECHA_ACTUAL DATE;
    SET FECHA_ACTUAL = NOW();
    
SELECT 
    DATEDIFF(BODEGA_PROVEEDOR_PRODUCTO.FECHA_VENCIMIENTO,
			FECHA_ACTUAL)
INTO CADUCIDAD_DIAS FROM
    BODEGA_PROVEEDOR_PRODUCTO
        INNER JOIN
    PRODUCTO ON BODEGA_PROVEEDOR_PRODUCTO.COD_PRODUCTO = PRODUCTO.COD_PRODUCTO
WHERE
    COD_PRODUCTO = PRODUCTO.COD_PRODUCTO;
    
    RETURN CADUCIDAD_DIAS;
END
//

DELIMITER //
/*--------------------------------------------------- ESPECIFICACION DE UN PRODUCTO --------------------------------------------------*/
CREATE PROCEDURE ESPECIFICACION_PRODUCTO (COD_PRODUCTO INT)
BEGIN
	SELECT 	PRODUCTO.NOMBRE_PRODUCTO AS 'NOMBRE',
			TIPO_PRODUCTO.NOMBRE_TIPO_PRODUCTO AS 'TIPO DE PRODUCTO',
            DIAS_CADUCIDAD_PRODUCTO (COD_PRODUCTO) AS 'DIAS PARA CADUCAR',
            TIPO_PRODUCTO.DESCRIP_TIPO_PRODUCTO AS 'DESCRIPCION'
	FROM
			PRODUCTO
	INNER JOIN
			TIPO_PRODUCTO
	ON
			PRODUCTO.COD_TIPO_PRODUCTO = TIPO_PRODUCTO.COD_TIPO_PRODUCTO
	WHERE
			COD_PRODUCTO = PRODUCTO.COD_PRODUCTO;
END
//

DELIMITER //
/*------------------------------------------------------------ DINERO FACTURADO EN UNA FECHA ------------------------------------------------------------*/
CREATE FUNCTION VENDIDO_FECHA (FECHA DATE, COD_SUCURSAL INT)
RETURNS FLOAT
BEGIN
	DECLARE DINERO_FACTURADO FLOAT;
    SET DINERO_FACTURADO = 0.0;
    
    SELECT 
    SUM(PEDIDO_PRODUCTO.CANTIDAD_PRODUCTO * BODEGA_SUCURSAL_PRODUCTO.PRECIO_COMPRA)
	INTO DINERO_FACTURADO
	FROM PEDIDO_PRODUCTO
	INNER JOIN
		PRODUCTO
	ON
		PEDIDO_PRODUCTO.COD_PRODUCTO = PRODUCTO.COD_PRODUCTO
	INNER JOIN
		BODEGA_SUCURSAL_PRODUCTO
	ON
		PRODUCTO.COD_PRODUCTO = BODEGA_SUCURSAL_PRODUCTO.COD_PRODUCTO
	INNER JOIN
		FACTURA
	ON
		PEDIDO_PRODUCTO.NUM_PEDIDO = FACTURA.NUM_PEDIDO
	INNER JOIN
		EMPLEADO
	ON
		FACTURA.COD_EMPLEADO = EMPLEADO.COD_EMPLEADO
	WHERE
		FECHA = FACTURA.FECHA_FACTURA AND COD_SUCURSAL = EMPLEADO.COD_SUCURSAL
	GROUP BY 
		DINERO_FACTURADO;
	
    RETURN DINERO_FACTURADO;
END
//

DELIMITER //
-- RETORNA EL IMPUESTO CORRESPONDIENTE A ESE PRODUCTO
CREATE FUNCTION SACAR_IMPUESTO_PRODUCTO (COD_PRODUCTO INT) RETURNS INT
BEGIN
	DECLARE PORC_IMPUESTO FLOAT;
    
    SELECT PORCENTAJE_IMP
    INTO PORC_IMPUESTO
    FROM 
		IMPUESTO
    INNER JOIN
		TIPO_PRODUCTO
	ON
		IMPUESTO.COD_IMPUESTO = TIPO_PRODUCTO.COD_IMPUESTO
	INNER JOIN
		PRODUCTO
	ON
		TIPO_PRODUCTO.COD_TIPO_PRODUCTO = PRODUCTO.COD_TIPO_PRODUCTO
	WHERE
		COD_PRODUCTO = PRODUCTO.COD_PRODUCTO;
	RETURN PORC_IMPUESTO;
END
//


DELIMITER //
-- CALCULA EL PRODUCTO CON IMPUESTO Y DESCUENTO
CREATE FUNCTION TOTAL_PAGAR_PRODUCTO (COD_PRODUCTO INT) RETURNS FLOAT
BEGIN
	DECLARE TOTAL FLOAT;
	DECLARE PRODUCTO_VENTA FLOAT;
    DECLARE DESCUENTO FLOAT DEFAULT 0;
    DECLARE IMPUESTO FLOAT DEFAULT 0;

	SELECT 
		BODEGA_SUCURSAL_PRODUCTO.PRECIO_COMPRA
	INTO PRODUCTO_VENTA
	FROM
		BODEGA_SUCURSAL_PRODUCTO
	INNER JOIN
		PRODUCTO
	ON
		BODEGA_SUCURSAL_PRODUCTO.COD_PRODUCTO = PRODUCTO.COD_PRODUCTO
	WHERE 
		COD_PRODUCTO = PRODUCTO.COD_PRODUCTO;
	
    IF (DIAS_CADUCIDAD_PRODUCTO(COD_PRODUCTO) <= 7) THEN
			SET DESCUENTO = 10.0;
	END IF;
    
    SET IMPUESTO = SACAR_IMPUESTO_PRODUCTO(COD_PRODUCTO);
	SET TOTAL = PRODUCTO_VENTA + 
				(PRODUCTO_VENTA * IMPUESTO) /100 -
				(PRODUCTO_VENTA * DESCUENTO)/100;
	RETURN TOTAL;
END
//

DELIMITER //
/*------------------------------------------------------------ REVISA SI EL PEDIDO REQUIERE ENVIO ------------------------------------------------------------*/
CREATE FUNCTION REQUIERE_ENVIO (NUM_PEDIDO INT) RETURNS TINYINT
BEGIN
	DECLARE ESTADO_ENVIO TINYINT;
    SELECT ENVIO
    INTO ESTADO_ENVIO
    FROM
		PEDIDO
	WHERE
		NUM_PEDIDO = PEDIDO.NUM_PEDIDO;
	RETURN ESTADO_ENVIO;
END
//


/*------------------------------------------------------------ CALCULA EL TOTAL A PAGAR DE UNA FACTURA ------------------------------------------------------------*/
DELIMITER //
CREATE FUNCTION TOTAL_FACTURA (NUM_PEDIDO INT) RETURNS FLOAT
BEGIN
	DECLARE TOTAL FLOAT DEFAULT 0;
    SELECT 
		TOTAL + PEDIDO_PRODUCTO.CANTIDAD_PRODUCTO * BODEGA_SUCURSAL_PRODUCTO.PRECIO_COMPRA
	INTO
		TOTAL
	FROM
		PEDIDO_PRODUCTO
	INNER JOIN
		FACTURA
	ON
		PEDIDO_PRODUCTO.NUM_PEDIDO = FACTURA.NUM_PEDIDO
	INNER JOIN
		PRODUCTO
	ON
		PRODUCTO.COD_PRODUCTO = PEDIDO_PRODUCTO.COD_PRODUCTO
	INNER JOIN
		BODEGA_SUCURSAL_PRODUCTO
	ON
		BODEGA_SUCURSAL_PRODUCTO.COD_PRODUCTO = PRODUCTO.COD_PRODUCTO
	WHERE
		NUM_PEDIDO = FACTURA.NUM_PEDIDO;
	
    IF (REQUIERE_ENVIO (NUM_PEDIDO) != 0) THEN
		-- EL 0.1% DEL TOTAL A PAGAR
		SET TOTAL = TOTAL + (TOTAL/1000);
	RETURN TOTAL;
	END IF;
END
//

DELIMITER //
/*---------------------------------------------------- TODOS LOS PRODUCTOS QUE FUERON FACTURADOS EN UNA FECHA -------------------------------------------------------*/
CREATE PROCEDURE VENTA_PRODUCTO_FECHA (FECHA DATE, COD_SUCURSAL INT) 
BEGIN
	SELECT 
		PEDIDO_PRODUCTO.COD_PRODUCTO AS 'CODIGO',
		SUM(PEDIDO_PRODUCTO.CANTIDAD_PRODUCTO) AS 'CANTIDAD',
		PRODUCTO.NOMBRE_PRODUCTO AS 'NOMBRE'
	FROM
		PEDIDO_PRODUCTO
	INNER JOIN
		PRODUCTO
	ON
		PEDIDO_PRODUCTO.COD_PRODUCTO = PRODUCTO.COD_PRODUCTO
	INNER JOIN
		FACTURA
	ON
		PEDIDO_PRODUCTO.NUM_PEDIDO = FACTURA.NUM_PEDIDO
	INNER JOIN
		EMPLEADO
	ON
		FACTURA.COD_EMPLEADO = EMPLEADO.COD_EMPLEADO
	WHERE
		FECHA = FACTURA.FECHA_FACTURA AND COD_SUCURSAL = EMPLEADO.COD_SUCURSAL
	GROUP BY
		PEDIDO_PRODUCTO.COD_PRODUCTO, PEDIDO_PRODUCTO.CANTIDAD_PRODUCTO, PRODUCTO.NOMBRE_PRODUCTO;
END
//

DELIMITER //
/*---------------------------------------------------- TODOS LOS PRODUCTOS QUE PROVEE UN PROVEEDOR -------------------------------------------------------*/
CREATE PROCEDURE PROVEEDOR_PRODUCTOS (COD_PROVEEDOR INT)
BEGIN
	SELECT 
		PRODUCTO.COD_PRODUCTO AS 'CODIGO',
		PRODUCTO.NOMBRE_PRODUCTO AS 'NOMBRE',
        BODEGA_PROVEEDOR_PRODUCTO.CANTIDAD_EN_BODEGA AS 'CANTIDAD'
	FROM
		PRODUCTO
	INNER JOIN
		BODEGA_PROVEEDOR_PRODUCTO
	ON
		PRODUCTO.COD_PRODUCTO = BODEGA_PROVEEDOR_PRODUCTO.COD_PRODUCTO
	WHERE
		COD_PROVEEDOR = BODEGA_PROVEEDOR_PRODUCTO.COD_PROVEEDOR;
END
//

DELIMITER //
/*---------------------------------------------------- ASIGNA EL BONO A UN EMPLEADO -------------------------------------------------------*/
CREATE PROCEDURE BONOS_EMPLEADO_ASIGNACION (pCOD_EMPLEADO INT, pMONTO_BONO FLOAT, pFECHA_BONO DATE)
BEGIN
	IF (CANTIDAD_FACTURAS_EMPLEADO(pCOD_EMPLEADO) > 20) OR (TIEMPO_LABORAL_EMPLEADO(pCOD_EMPLEADO) >= 91) THEN	-- 91 dias equivale a 3 meses
        CALL CRUD_BONOSEMP (pCOD_EMPLEADO, pMONTO_BONO, pFECHA_BONO, 'CREATE');
	END IF;
END
//

DELIMITER //
/*---------------------------------------------------- RETIRA LOS PRODUCTOS EXPIRADOS DE LA BODEGA DE LA SUCURSAL -------------------------------------------------------*/
CREATE PROCEDURE RETIRA_PRODUCTOS_EXPIRADOS (COD_PRODUCTO INT, COD_BODEGA_SUCURSAL INT)
BEGIN
	IF (DIAS_CADUCIDAD_PRODUCTO(COD_PRODUCTO) < 0) THEN
		CALL CRUD_PRODUCTO_EXPIRADO ( NULL, 
									COD_PRODUCTO,
                                    (SELECT CANTIDAD_ACTUAL FROM BODEGA_SUCURSAL_PRODUCTO WHERE COD_PRODUCTO = BODEGA_SUCURSAL_PRODUCTO.COD_PRODUCTO),
                                    (SELECT COD_BODE_SUCU_PRODU FROM BODEGA_SUCURSAL_PRODUCTO WHERE COD_PRODUCTO = BODEGA_SUCURSAL_PRODUCTO.COD_PRODUCTO), 
                                    'CREATE');
        CALL CRUD_BODESUCUPRODU (COD_BODEGA_SUCURSAL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'DELETE');
	END IF;
END
//

DELIMITER //
/*---------------------------------------------------- REPORTE DE PRODUCTOS EXPIRADOS -------------------------------------------------------*/
CREATE PROCEDURE REPORTE_PRODUCTOS_EXPIRADOS () 
BEGIN
	SELECT 
		COD_PRODUCTO_EXP AS 'CODIGO',
        COD_PRODUCTO AS 'CODIGO DEL PRODUCTO',
        CANTIDAD_PRODUCTOS AS 'CANTIDAD',
        COD_BODE_SUCU_PRODU AS 'CODIGO DE BODEGA SUCURSAL'
    FROM PRODUCTO_EXPIRADO;
END
//

DELIMITER //
/*---------------------------------------------------- GANANCIA DE UN PRODUCTO -------------------------------------------------------*/
CREATE FUNCTION GANANCIAS_PRODUCTO (COD_PRODUCTO INT) RETURNS FLOAT
BEGIN
	DECLARE GANANCIA FLOAT;
    SELECT
		TOTAL_PAGAR_PRODUCTO(COD_PRODUCTO) - BODEGA_PROVEEDOR_PRODUCTO.PRECIO_VENTA
	INTO
		GANANCIA
	FROM
		BODEGA_PROVEEDOR_PRODUCTO
	WHERE
		COD_PRODUCTO = BODEGA_PROVEEDOR_PRODUCTO.COD_PRODUCTO;
	RETURN GANANCIA;
END
//

DELIMITER //
/*---------------------------------------------------- ORDENA LOS EMPLEADOS CON SUS VENTAS -------------------------------------------------------*/
CREATE PROCEDURE EMPLEADOS_VENTAS ()
BEGIN
	SELECT 
		-- Devuelve el número secuencial de cada fila dentro de su partición.
		ROW_NUMBER()
			OVER(
				PARTITION BY FACTURA.COD_EMPLEADO
				ORDER BY FACTURA.COD_EMPLEADO DESC
			) AS
			'ORDEN',
			FACTURA.COD_EMPLEADO,
			FACTURA.NUM_FACTURA,
			FACTURA.FECHA_FACTURA
	FROM
		FACTURA;
END
//

DELIMITER ;
;
/*---------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------PRUEBAS----------------------------------------------------
----------------------------------------------------------------------------------------------------------------------*/

call CRUD_PAIS(507,'Panama', 'CREATE');
call CRUD_PROVINCIA(5071,'Chiriqui',507,'CREATE');
call CRUD_PROVINCIA(5072,'Ciudad de Panama',507,'CREATE');

call CRUD_PAIS(506,'Costa Rica', 'CREATE');
call CRUD_PROVINCIA(1,'San Jose',506,'CREATE');
call CRUD_PROVINCIA(2,'Alajuela',506,'CREATE');
call CRUD_PROVINCIA(3,'Cartago',506,'CREATE');

call CRUD_CIUDAD(11,'San Jose Centro',1,'CREATE');
call CRUD_CIUDAD(12,'Perez Zeledon',1,'CREATE');
call CRUD_CIUDAD(13,'Desamparados',1,'CREATE');

call CRUD_SUCURSAL(111,'PZ TOWN',11,'CREATE');

call CRUD_SEXO(1,'Masculino','CREATE');
call CRUD_SEXO(2,'Femenino','CREATE');
call CRUD_SEXO(3,'Otro','CREATE');

call CRUD_PERSONA(118440792,'Jose Pablo','Hidalgo Navarro',"2002-06-05",'Barrio Lourdes',1,12,'CREATE');
call CRUD_PERSONA(111111111,'Maria del Mar','Fernandez Vega',"1998-04-15",'Barrio Bloque K',2,11,'CREATE');
call CRUD_PERSONA(122222222,'Kevin','Nuñez Cruz',"1995-01-21",'Barrio Escalante',1,11,'CREATE');
call CRUD_PERSONA(133333333,'Estefanny','Gamboa Jimenez',"2003-12-01",'Curridabat',2,11,'CREATE');
call CRUD_PERSONA(144444444,'Mario','Segura Mendez',"2001-01-01",'La Carpio',1,13,'CREATE');
call CRUD_PERSONA(155555555,'Javier Ernaldo','Benabidez Cruz',"2001-10-11",'Daniel Flores',1,12,'CREATE');
call CRUD_PERSONA(166666666,'Alonso','Zegheline Ovierira',"2001-07-15",'Zapote',1,11,'CREATE');
call CRUD_PERSONA(177777777,'Fabian Josué','Solano Rojas',"1993-08-17",'Daniel Flores',1,12,'CREATE');

call CRUD_PULABORAL(10,'Manager Sucursal',300000,'CREATE');
call CRUD_PULABORAL(20,'Cajero',150000,'CREATE');
call CRUD_PULABORAL(30,'Limpieza', 150000,'CREATE');

call CRUD_EMPLEADO(1000,"2020-05-30",40,111,10,118440792,'CREATE');
call CRUD_EMPLEADO(2000,"2019-07-04",20,111,20,111111111,'CREATE');
call CRUD_EMPLEADO(3000,"2022-09-25",40,111,30,122222222,'CREATE');
call CRUD_EMPLEADO(4000,"2021-04-15",50,111,20,133333333,'CREATE');
call CRUD_EMPLEADO(5000,"2020-03-06",40,111,30,144444444,'CREATE');

call CRUD_TIPUSUARIO(1,'Basico','CREATE');
call CRUD_TIPUSUARIO(2,'Starter','CREATE');
call CRUD_TIPUSUARIO(3,'Premiun','CREATE');

call CRUD_USUARIO(250, 'Javezuela1','1234', 'javiZZZ@gmail.com',1,155555555,'CREATE');
call CRUD_USUARIO(260, 'AloOvi','abcd', 'alonsoO@gmail.com',2,166666666,'CREATE');
call CRUD_USUARIO(270, 'SoloJosueF','Fabi15', 'josueF@gmail.com',3,177777777,'CREATE');
call CRUD_USUARIO(280, 'PabloHHH','32545', 'pablo@gmail.com',1,118440792,'CREATE');

call CRUD_CLIENTE(250,250,'CREATE');
call CRUD_CLIENTE(260,260,'CREATE');
call CRUD_CLIENTE(270,270,'CREATE');

call CRUD_PROVEEDOR(1000, 'Dos Pinos', 24.5, 13, 'CREATE');
call CRUD_PROVEEDOR(2000, 'Verdulería Feliz', 35.7, 12, 'CREATE');
call CRUD_PROVEEDOR(3000, 'Electrodomesticos KSA', 50.0, 11, 'CREATE');

call CRUD_IMPUESTO(13, 13.0, 'IVA',  'CREATE');
call CRUD_IMPUESTO(1, 0.0, 'Excento',  'CREATE');
call CRUD_IMPUESTO(2, 2.0, 'Canasta Basica',  'CREATE');

call CRUD_TIPPRODU(110, 'Fruta', 'Fruta', 13, 'CREATE');
call CRUD_TIPPRODU(220, 'Verdura', 'Verdura', 13, 'CREATE');
call CRUD_TIPPRODU(330, 'Legumbre', 'Legumbre', 13, 'CREATE');
call CRUD_TIPPRODU(410, 'Lacteo', 'Leche', 13, 'CREATE');
call CRUD_TIPPRODU(420, 'Lacteo', 'Queso', 13, 'CREATE');
call CRUD_TIPPRODU(430, 'Lacteo', 'Yogurth', 13, 'CREATE');
call CRUD_TIPPRODU(440, 'Lacteo', 'Helado', 13, 'CREATE');
call CRUD_TIPPRODU(510, 'Electrodomestico', 'Televisores', 13, 'CREATE');
call CRUD_TIPPRODU(520, 'Electrodomestico', 'Celulares', 13, 'CREATE');
call CRUD_TIPPRODU(530, 'Electrodomestico', 'Microondas', 13, 'CREATE');
call CRUD_TIPPRODU(540, 'Electrodomestico', 'Olla Arrocera', 13, 'CREATE');
call CRUD_TIPPRODU(550, 'Electrodomestico', 'Laptop', 13, 'CREATE');

call CRUD_PRODUCTO(111,  'Manzana', 110, 10, 25, 'CREATE');
call CRUD_PRODUCTO(112,  'Banano', 110, 20, 60, 'CREATE');
call CRUD_PRODUCTO(113,  'Sandía', 110, 5, 15, 'CREATE');
call CRUD_PRODUCTO(221,  'Lechuga', 220, 7, 25, 'CREATE');
call CRUD_PRODUCTO(222,  'Brocoli', 220, 5, 20, 'CREATE');
call CRUD_PRODUCTO(223,  'Ayote', 220, 10, 30, 'CREATE');
call CRUD_PRODUCTO(331,  'Papa', 330, 20, 55, 'CREATE');
call CRUD_PRODUCTO(332,  'Zanahoria', 330, 10, 35, 'CREATE');
call CRUD_PRODUCTO(333,  'Camote', 330, 7, 21, 'CREATE');
call CRUD_PRODUCTO(411,  'Leche Entera', 410, 15, 35, 'CREATE');
call CRUD_PRODUCTO(412,  'Leche Semidescremada', 410, 15, 30, 'CREATE');
call CRUD_PRODUCTO(413,  'Leche Condensada', 410, 5, 20, 'CREATE');
call CRUD_PRODUCTO(421,  'Queso Turrialba', 420, 10, 20, 'CREATE');
call CRUD_PRODUCTO(422,  'Queso Amarillo', 420, 10, 25, 'CREATE');
call CRUD_PRODUCTO(431,  'Yogurth Griego', 430, 5, 15, 'CREATE');
call CRUD_PRODUCTO(432,  'Yogurth de Fresa', 430, 10, 20, 'CREATE');
call CRUD_PRODUCTO(441,  'Helado de Vainilla', 440, 7, 23, 'CREATE');
call CRUD_PRODUCTO(442,  'Helado Napolitano', 440, 7, 20, 'CREATE');
call CRUD_PRODUCTO(443,  'Helado de Menta', 440, 5, 19, 'CREATE');
call CRUD_PRODUCTO(511,  'TV 40p Samsung', 510, 5, 10, 'CREATE');
call CRUD_PRODUCTO(512,  'TV 40p TCL', 510, 5, 10, 'CREATE');
call CRUD_PRODUCTO(513,  'TV 30p Samsung', 510, 7, 17, 'CREATE');
call CRUD_PRODUCTO(521,  'Xiaomi  RedMi 10', 520, 4, 13, 'CREATE');
call CRUD_PRODUCTO(522,  'Samsung S10 Pro', 520, 3, 14, 'CREATE');
call CRUD_PRODUCTO(523,  'iPhone 11 Pro Max', 520, 5, 13, 'CREATE');
call CRUD_PRODUCTO(531,  'Microondas BlackDecker', 530, 5, 10, 'CREATE');
call CRUD_PRODUCTO(532,  'Microondas Huawei', 530, 4, 11, 'CREATE');
call CRUD_PRODUCTO(541,  'Olla Arrocera BlackDecker', 540, 5, 13, 'CREATE');
call CRUD_PRODUCTO(542,  'Olla Arrocera Ostrel', 540, 4, 15, 'CREATE');
call CRUD_PRODUCTO(551,  'Laptop Acer Aspire 5', 550, 2, 8, 'CREATE');
call CRUD_PRODUCTO(552,  'Laptop Huawei Pro', 550, 3, 9, 'CREATE');
call CRUD_PRODUCTO(553,  'Laptop iMac 3', 550, 4, 10, 'CREATE');

call CRUD_TELEFPERSO(155555555, '70264789', null, 'CREATE');
call CRUD_TELEFPERSO(155555555, '84578103', null, 'CREATE');
call CRUD_TELEFPERSO(166666666, '65892145', null, 'CREATE');
call CRUD_TELEFPERSO(177777777, '70704156', null, 'CREATE');

call CRUD_CRIPTOCARTERA(250, 'CCBTC778991516684510', null, 'CREATE');
call CRUD_CRIPTOCARTERA(250, 'CCETH871474456711331', null, 'CREATE');

call CRUD_TARJECREDI(260, 'CR78459881045478', null, 'CREATE');
call CRUD_TARJECREDI(260, 'CR78789231520546', null, 'CREATE');
call CRUD_TARJECREDI(270, 'CR25637252897722', null, 'CREATE');

call CRUD_CHEQUE(250, '65274578246710', null, 'CREATE');
call CRUD_CHEQUE(250, '67684100269252', null, 'CREATE');
call CRUD_CHEQUE(260, '21572848104784', null, 'CREATE');

call CRUD_BODEPROVEPRODU(null, 1000, 411, 700, 50, "2022-04-05", "2022-04-30", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 1000, 412, 800, 30, "2022-05-05", "2022-05-30", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 1000, 413, 900, 20, "2022-05-05", "2022-08-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 1000, 421, 1000, 32, "2021-06-10", "2022-08-15", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 1000, 422, 900, 15, "2021-04-07", "2022-09-10", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 1000, 431, 1500, 40, "2022-04-07", "2022-10-20", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 1000, 432, 1300, 25, "2022-06-05", "2022-08-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 1000, 441, 2000, 25, "2022-01-27", "2023-09-27", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 1000, 442, 1750, 20, "2022-01-25", "2023-09-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 1000, 443, 2500, 16, "2022-01-15", "2023-09-16", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 2000, 111, 150, 60, "2022-01-05", "2022-03-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 2000, 112, 25, 75, "2022-02-05", "2022-04-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 2000, 113, 900, 80, "2022-03-05", "2022-05-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 2000, 221, 400, 45, "2022-04-05", "2022-06-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 2000, 222, 1300, 36, "2022-02-05", "2022-07-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 2000, 223, 560, 19, "2022-06-05", "2022-08-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 2000, 331, 650, 29, "2022-07-05", "2022-09-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 2000, 332, 430, 37, "2022-08-05", "2022-10-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 2000, 333, 400, 28, "2022-09-05", "2022-11-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 3000, 511, 1450000, 8, "2022-08-05", "2022-10-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 3000, 512, 800000, 10, "2022-08-05", "2022-10-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 3000, 513, 710025, 9, "2022-08-05", "2022-10-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 3000, 521, 201400, 7, "2022-08-05", "2022-10-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 3000, 522, 450000, 9, "2022-08-05", "2022-10-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 3000, 523, 950000, 13, "2022-08-05", "2022-10-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 3000, 531, 25000, 16, "2022-08-05", "2022-10-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 3000, 532, 45000, 13, "2022-08-05", "2022-10-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 3000, 541, 23000, 18, "2022-08-05", "2022-10-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 3000, 542, 35000, 15, "2022-08-05", "2022-10-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 3000, 551, 452000, 8, "2022-08-05", "2022-10-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 3000, 552, 560000, 9, "2022-08-05", "2022-10-25", 'CREATE');
call CRUD_BODEPROVEPRODU(null, 3000, 553, 780000, 5, "2022-08-05", "2022-10-25", 'CREATE');

call CRUD_BODESUCUPRODU(null, 112, 111, 75, 2000, "2022-01-15", 20, "2022-02-05", "2022-04-25", 'CREATE');
call CRUD_BODESUCUPRODU(null, 111, 111, 200, 2000, "2022-01-15", 30, "2022-01-05", "2022-03-25", 'CREATE');
call CRUD_BODESUCUPRODU(null, 221, 111, 600, 2000, "2022-01-15", 20, "2022-04-05", "2022-06-25", 'CREATE');
call CRUD_BODESUCUPRODU(null, 222, 111, 1500, 2000, "2022-01-15", 16, "2022-02-05", "2022-07-25", 'CREATE');
call CRUD_BODESUCUPRODU(null, 223, 111, 650, 2000, "2022-01-15", 10, "2022-06-05", "2022-07-25", 'CREATE');
call CRUD_BODESUCUPRODU(null, 332, 111, 475, 2000, "2022-01-15", 10, "2022-08-05", "2022-10-25", 'CREATE');
call CRUD_BODESUCUPRODU(null, 331, 111, 700, 2000, "2022-01-15", 10, "2022-07-05", "2022-09-25", 'CREATE');
call CRUD_BODESUCUPRODU(null, 333, 111, 450, 2000, "2022-01-15", 15, "2022-09-05", "2022-11-25", 'CREATE');
call CRUD_BODESUCUPRODU(null, 411, 111, 850, 1000, "2022-01-15", 10, "2022-04-05", "2022-04-30", 'CREATE');
call CRUD_BODESUCUPRODU(null, 412, 111, 1100, 1000, "2022-01-15", 10, "2022-05-05", "2022-05-30", 'CREATE');
call CRUD_BODESUCUPRODU(null, 413, 111, 1500, 1000, "2022-01-15", 6, "2022-05-05", "2022-08-25", 'CREATE');
call CRUD_BODESUCUPRODU(null, 422, 111, 1050, 1000, "2022-01-15", 9, "2021-04-07", "2022-09-10", 'CREATE');

call CRUD_ESTADOP(1,  'En espera', 'CREATE');
call CRUD_ESTADOP(2,  'Completado', 'CREATE');
call CRUD_ESTADOP(3,  'Cancelado', 'CREATE');

call CRUD_PEDIDO (1001, "2022-10-15", 260, 1, 1, 111, 'CREATE');
call CRUD_PEDIDO (1011, "2022-10-15", 260, 2, 1, 111, 'CREATE');
call CRUD_PEDIDO (1021, "2022-08-12", 260, 2, 1, 111, 'CREATE');
call CRUD_PEDIDO (1031, "2022-08-15", 260, 1, 1, 111, 'CREATE');
call CRUD_PEDIDO (1041, "2022-08-02", 260, 3, 1, 111, 'CREATE');

call CRUD_PEDIDO (2001, "2022-12-03", 250, 3, 0, 111, 'CREATE');
call CRUD_PEDIDO (1051, "2022-12-06", 250, 3, 1, 111, 'CREATE');
call CRUD_PEDIDO (2011, "2022-12-05", 250, 2, 0, 111, 'CREATE');
call CRUD_PEDIDO (2021, "2023-02-08", 250, 1, 0, 111, 'CREATE');
call CRUD_PEDIDO (1061, "2023-01-15", 250, 1, 1, 111, 'CREATE');

call CRUD_PEDIDO (2031, "2023-01-12", 270, 1, 0, 111, 'CREATE');
call CRUD_PEDIDO (2041, "2023-03-11", 270, 1, 0, 111, 'CREATE');
call CRUD_PEDIDO (1071, "2023-03-15", 270, 1, 1, 111, 'CREATE');
call CRUD_PEDIDO (1081, "2023-06-15", 270, 3, 1, 111, 'CREATE');
call CRUD_PEDIDO (1091, "2023-11-08", 270, 3, 1, 111, 'CREATE');
call CRUD_PEDIDO (1101, "2023-08-11", 270, 1, 1, 111, 'CREATE');
/*
call CRUD_PEDIDO (2051, "2023-09-10", 260, 1, 1, 111, 'CREATE');
call CRUD_PEDIDOxPRODU (2051, 413, 2, 0, "No", 'CREATE');
call CRUD_FACTURA (576218, "2022-11-20", 250, 2000, 'Cheque', 2051, 'CREATE');
*/
call CRUD_PEDIDOxPRODU (1001, 111, 2, 0, "No", 'CREATE');
call CRUD_PEDIDOxPRODU (1001, 112, 3, 0, "No", 'CREATE');
call CRUD_PEDIDOxPRODU (1001, 331, 1, 0, "No", 'CREATE');
call CRUD_PEDIDOxPRODU (1001, 411, 1, 0, "No", 'CREATE');
call CRUD_PEDIDOxPRODU (1011, 111, 2, 0, "No", 'CREATE');
call CRUD_PEDIDOxPRODU (1011, 413, 1, 0, "No", 'CREATE');
call CRUD_PEDIDOxPRODU (1021, 112, 2, 0, "No", 'CREATE');
call CRUD_PEDIDOxPRODU (1021, 333, 2, 0, "No", 'CREATE');
call CRUD_PEDIDOxPRODU (1021, 412, 1, 0, "No", 'CREATE');
call CRUD_PEDIDOxPRODU (1031, 422, 2, 0, "No", 'CREATE');
call CRUD_PEDIDOxPRODU (1041, 333, 3, 0, "No", 'CREATE');
call CRUD_PEDIDOxPRODU (2001, 111, 1, 0, "No", 'CREATE');
call CRUD_PEDIDOxPRODU (1051, 222, 3, 0, "No", 'CREATE');
call CRUD_PEDIDOxPRODU (2011, 413, 1, 0, "No", 'CREATE');
call CRUD_PEDIDOxPRODU (2021, 112, 3, 0, "No", 'CREATE');
call CRUD_PEDIDOxPRODU (1061, 112, 5, 0, "No", 'CREATE');
call CRUD_PEDIDOxPRODU (1061, 413, 1, 0, "No", 'CREATE');
call CRUD_PEDIDOxPRODU (2031, 422, 1, 0, "No", 'CREATE');
call CRUD_PEDIDOxPRODU (2041, 332, 2, 0, "No", 'CREATE');
call CRUD_PEDIDOxPRODU (1071, 223, 2, 0, "No", 'CREATE');
call CRUD_PEDIDOxPRODU (1081, 111, 4, 0, "No", 'CREATE');
call CRUD_PEDIDOxPRODU (1091, 413, 2, 0, "No", 'CREATE');
call CRUD_PEDIDOxPRODU (1101, 331, 2, 0, "No", 'CREATE');

call CRUD_FACTURA (580488, "2022-11-23", 250, 2000, 'Cheque', 2011, 'CREATE');
call CRUD_FACTURA (697652, "2022-11-23", 250, 2000, 'Cheque', 2001, 'CREATE');
call CRUD_FACTURA (841101, "2022-11-25", 250, 1000, 'Cheque', 2021, 'CREATE');
call CRUD_FACTURA (643010, "2022-11-26", 250, 2000, 'Criptocartera', 1051, 'CREATE');
call CRUD_FACTURA (373337, "2022-11-26", 250, 1000, 'Cheque', 1061, 'CREATE');
call CRUD_FACTURA (616915, "2022-11-26", 260, 2000, 'Tarjeta_credito', 1001, 'CREATE');
call CRUD_FACTURA (189213, "2022-11-26", 260, 1000, 'Tarjeta_credito', 1011, 'CREATE');
call CRUD_FACTURA (209640, "2022-12-01", 260, 2000, 'Tarjeta_credito', 1021, 'CREATE');
call CRUD_FACTURA (373603, "2022-12-01", 260, 4000, 'Tarjeta_credito', 1031, 'CREATE');
call CRUD_FACTURA (979523, "2022-12-02", 260, 4000, 'Cheque', 1041, 'CREATE');
call CRUD_FACTURA (564208, "2022-12-03", 270, 4000, 'Tarjeta_credito', 2031, 'CREATE');
call CRUD_FACTURA (210997, "2022-12-03", 270, 4000, 'Tarjeta_credito', 1071, 'CREATE');
call CRUD_FACTURA (104848, "2022-12-04", 270, 1000, 'Tarjeta_credito', 2041, 'CREATE');
call CRUD_FACTURA (308304, "2022-12-04", 270, 2000, 'Tarjeta_credito', 1081, 'CREATE');
call CRUD_FACTURA (790022, "2022-12-04", 270, 2000, 'Tarjeta_credito', 1091, 'CREATE');
call CRUD_FACTURA (619797, "2022-12-04", 270, 2000, 'Tarjeta_credito', 1101, 'CREATE');