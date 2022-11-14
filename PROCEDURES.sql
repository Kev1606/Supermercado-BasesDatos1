# PROCEDIMIENTOS Y FUNCIONES
DELIMITER  //
/* CANTIDAD DE DIAS QUE HACEN FALTA PARA QUE CADUQUE UN PRODUCTO */
CREATE PROCEDURE DIAS_CADUCIDAD_PRODUCTO (COD_PRODUCTO  int) 
BEGIN
  	DECLARE CADUCIDAD_DIAS INT;
    DECLARE FECHA_ACTUAL DATE;
    SET FECHA_ACTUAL = CAST(GETDATE() AS DATE);
    
    /* Devuelve el número de días entre dos valores de fecha */
    SELECT CADUCIDAD_DIAS = DATEDIFF(FECHA_ACTUAL, BODEGA_COMPRA.FECHA_VENCIMIENTO)
    FROM BODEGA_COMPRA 
    INNER JOIN PRODUCTO
    ON BODEGA_COMPRA.COD_PRODUCTO = PRODUCTO.COD_PRODUCTO
    WHERE @COD_PRODUCTO = PRODUCTO.COD_PRODUCTO;
    
    IF (CADUCIDAD_DIAS < 0) THEN
		SET CADUCIDAD_DIAS = 0;
	END IF;
END
//

DELIMITER //
/* CANTIDAD DE TIEMPO QUE LLEVA TRABAJANDO UN EMPLEADO */
CREATE PROCEDURE TIEMPO_LABORAL_EMPLEADO (COD_EMPLEADO INT)
BEGIN
	DECLARE DIAS INT;
	DECLARE FECHA_CONTRATACION DATE;
    DECLARE FECHA_ACTUAL DATE;
    SET FECHA_ACTUAL = CAST(GETDATE() AS DATE);
    
	SELECT 
		FECHA_CONTRATACION = EMPLEADO.FECHA_CONTRATADO
    FROM 
		EMPLEADO
    WHERE 
		@COD_EMPLEADO = EMPLEADO.COD_EMPLEADO;
    SET DIAS = DATEDIFF(FECHA_CONTRATACION, FECHA_ACTUAL);
END
//

DELIMITER //
/* CANTIDAD DE FACTURAS QUE REALIZA UN EMPLEADO */
CREATE PROCEDURE CANTIDAD_FACTURAS_EMPLEADO (COD_EMPLEADO INT)
BEGIN
	DECLARE CANTIDAD_FACTURAS INT;
    
    SELECT
		CANTIDAD_FACTURAS = COUNT(FACTURA.NUM_FACTURA)
	FROM 
		FACTURA
	WHERE
		@COD_EMPLEADO = FACTURA.COD_EMPLEADO;
END
//

DELIMITER //
/* CANTIDAD DE EMPLEADOS DE UNA SUCURSAL */
CREATE PROCEDURE EMPLEADOS_SUCURSAL (COD_SUCURSAL INT)
BEGIN
	DECLARE CANTIDAD_EMPLEADOS INT;
    
	SELECT 
		CANTIDAD_EMPLEADOS = COUNT(EMPLEADO.COD_EMPLEADO)
	FROM 
		EMPLEADO
	INNER JOIN
		SUCURSAL
	ON
		EMPLEADO.COD_SUCURSAL = SUCURSAL.COD_SUCURSAL	
	WHERE 
		@COD_SUCURSAL = SUCURSAL.COD_SUCURSAL;
END
//

/*
DELIMITER //
/* CANTIDAD DE PRODUCTOS EN UNA SUCURSAL
CREATE PROCEDURE PRODUCTOS_SUCURSAL (COD_SUCURSAL INT)
BEGIN
	DECLARE CANTIDAD_PRODUCTOS INT;
    
    SELECT
		CANTIDAD_PRODUCTOS = SUM(PRODUCTO.CANTIDAD_PRODUCTO)
	FROM
		PRODUCTO
	WHERE
		ID_SUCURSAL = PRODUCTO.ID_SUCURSAL;
END
//
*/

DELIMITER //
/* CANTIDAD DE SUCURSALES EN UN PAIS */
CREATE PROCEDURE SUCURSALES_PAIS (COD_PAIS INT)
BEGIN
	DECLARE CANTIDAD_SUCURSALES INT;
    
    SELECT
		CANTIDAD_SUCURSALES = COUNT(SUCURSAL.COD_SUCURSAL)
	FROM
		SUCURSAL
	INNER JOIN
		CIUDAD
	ON
		SUCURSAL.COD_CIUDAD = CIUDAD.COD_CIUDAD
	INNER JOIN
		PROVINCIA
	ON
		CIUDAD.COD_PROVINCIA = PROVINCIA.COD_PROVINCIA
	INNER JOIN
		PAIS
	ON
		PROVINCIA.COD_PAIS = PAIS.COD_PAIS

    WHERE
		@COD_PAIS = PAIS.COD_PAIS;
END
//

/*
DELIMITER //
/* DINERO FACTURADO EN UNA FECHA
CREATE PROCEDURE VENDIDO_FECHA (FECHA DATE, COD_SUCURSAL INT)
BEGIN
	DECLARE DINERO_FACTURADO FLOAT;
    SET DINERO_FACTURADO = 0.0;
    
    SELECT 
		DINERO_FACTURADO = DINERO_FACTURADO + FACTURA_PRODUCTO.CANTIDAD_PRODUCTO * BODEGA_COMPRA.PRECIO_COMPRA
	FROM FACTURA_PRODUCTO
	INNER JOIN
		PRODUCTO
	ON
		FACTURA_PRODUCTO.COD_PRODUCTO = PRODUCTO.COD_PRODUCTO
	INNER JOIN
		BODEGA_COMPRA
	ON
		PRODUCTO.COD_PRODUCTO = BODEGA_COMPRA.COD_PRODUCTO
	INNER JOIN
		FACTURA
	ON
		FACTURA_PRODUCTO.NUM_FACTURA = FACTURA.NUM_FACTURA
	WHERE
		FECHA = FACTURA.FECHA_FACTURA AND COD_SUCURSAL = FACTURA.ID_SUCURSAL;
END
DELIMITER ;
*/

-- CANTIDAD DE EMPLEADOS CON EL MISMO CARGO
DELIMITER //
CREATE PROCEDURE EMPLEADOS_CARGO (CARGO INT)
BEGIN
	DECLARE CANTIDAD_EMPLEADOS INT;
	SELECT 
		CANTIDAD_EMPLEADOS = COUNT(EMPLEADO.COD_EMPLEADO)
	FROM 
		EMPLEADO
	WHERE 
		@CARGO = EMPLEADO.COD_PUESTO_LABORAL;
END
//

DELIMITER //
CREATE PROCEDURE EMPLEADO_DINERO_HORA (COD_EMPLEADO INT)
BEGIN
	DECLARE HORAS_LABORALES INT;
	DECLARE SALARIO_MENSUAL FLOAT;

	SELECT 
		HORAS_LABORALES = EMPLEADO.HORAS_LABORALES,
		SALARIO_MENSUAL = PUESTO_LABORAL.SALARIO_MENSUAL
	FROM
		EMPLEADO
	INNER JOIN 
		PUESTO_LABORAL
	ON
		EMPLEADO.COD_PUESTO_LABORAL = PUESTO_LABORAL.COD_PUESTO_LABORAL
	WHERE 
		@COD_EMPLEADO = EMPLEADO.COD_EMPLEADO;
END
//

DELIMITER //
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
			@COD_PRODUCTO = PRODUCTO.COD_PRODUCTO;
END
//

DELIMITER //
-- CALCULA EL PRODUCTO CON IMPUESTO Y DESCUENTO
CREATE PROCEDURE TOTAL_PAGAR_PRODUCTO (COD_PRODUCTO INT, IMPUESTO FLOAT, DESCUENTO FLOAT)
BEGIN
	DECLARE TOTAL FLOAT;
	DECLARE PRODUCTO_VENTA FLOAT;

	SELECT 
		PRODUCTO_VENTA = BODEGA_COMPRA.PRECIO_COMPRA
	FROM
		BODEGA_COMPRA
	INNER JOIN
		PRODUCTO
	ON
		BODEGA_COMPRA.COD_PRODUCTO = PRODUCTO.COD_PRODUCTO
	WHERE 
		COD_PRODUCTO = PRODUCTO.COD_PRODUCTO;

	SET TOTAL = PRODUCTO_VENTA + 
				(PRODUCTO_VENTA * IMPUESTO) /100 -
				(PRODUCTO_VENTA * DESCUENTO)/100;
END
//
/*
DELIMITER //
-- TODOS LOS EMPLEADOS DE LA SUCURSAL
CREATE PROCEDURE SUCURSAL_EMPLEADOS_CARGO (COD_SUCURSAL INT)
BEGIN
	DECLARE COD_EMPLEADO INT;
    DECLARE COD_PUESTO_LABORAL INT;
    
	DECLARE EMPLEADOS CURSOR FOR
		SELECT 
			EMPLEADO.COD_EMPLEADO,
			EMPLEADO.COD_PUESTO_LABORAL
		FROM 
			EMPLEADO
		WHERE 
			COD_SUCURSAL = EMPLEADO.COD_SUCURSAL;
	
	CREATE TEMPORARY TABLE Z_SUCURSAL_EMPLEADOS ( 
                COD_EMPLEADO INT NOT NULL, 
                COD_PUESTO_LABORAL INT NOT NULL
	);

	OPEN EMPLEADOS;
		FETCH EMPLEADOS INTO COD_EMPLEADO, COD_PUESTO_LABORAL;
        lop:
		WHILE @@FETCH_STATUS = 0 DO
		BEGIN		
			INSERT INTO Z_SUCURSAL_EMPLEADOS
				VALUES
				(
					COD_EMPLEADO, COD_PUESTO_LABORAL
				);

			FETCH NEXT FROM EMPLEADOS INTO COD_EMPLEADO, COD_PUESTO_LABORAL;
		END;
	CLOSE EMPLEADOS;
	DEALLOCATE PREPARE EMPLEADOS;
END;
//


DELIMITER //
-- BUSCA LA ULTIMA VENTA DE TODOS LOS EMPLEADOS
CREATE PROCEDURE ULTIMA_VENTA_EMPLEADO ()
BEGIN
	DECLARE FINISHED INT DEFAULT 0;
	DECLARE COD_SUCURSAL INT;
    DECLARE COD_EMPLEADO INT;
    DECLARE FECHA_VENTA DATE;
    
	DECLARE FACTURAS CURSOR FOR
		SELECT 
			FACTURA.COD_SUCURSAL,
			FACTURA.COD_EMPLEADO,
			FACTURA.FECHA_FACTURA
		FROM
			FACTURA
		ORDER BY
			FACTURA.COD_EMPLEADO,
			FACTURA.FECHA_FACTURA DESC;
	
    DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET FINISHED = 1;
	
    CREATE TEMPORARY TABLE Z_ULTIMA_VENTA_EMPLEADO ( 
				COD_SUCURSAL INT NOT NULL, 
                COD_EMPLEADO INT NOT NULL, 
                FECHA_VENTA DATE NOT NULL
	);
    
    OPEN FACTURAS;
    
    loopeando: LOOP
		FETCH FACTURAS INTO COD_SUCURSAL, COD_EMPLEADO, FECHA_VENTA;
		IF FINISHED = 1 THEN 
			LEAVE loopeando;
		END IF;
        IF NOT EXISTS(
				SELECT Z_ULTIMA_VENTA_EMPLEADO.COD_EMPLEADO
				FROM Z_ULTIMA_VENTA_EMPLEADO
				WHERE COD_EMPLEADO = Z_ULTIMA_VENTA_EMPLEADO.COD_EMPLEADO
		) THEN
        BEGIN IF
			INSERT INTO Z_ULTIMA_VENTA_EMPLEADO
					VALUES
					(
						COD_EMPLEADO, 
						COD_SUCURSAL,
						FECHA_VENTA	
			);
        END IF;
	END;
    CLOSE FACTURAS;
	DEALLOCATE PREPARE FACTURAS;
END;
//
*/