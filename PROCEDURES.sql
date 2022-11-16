/*-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------PROCEDURES----------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------*/

DELIMITER //
/*------------------------------------------------------------ CANTIDAD DE TIEMPO QUE LLEVA TRABAJANDO UN EMPLEADO ------------------------------------------------------------*/
CREATE PROCEDURE TIEMPO_LABORAL_EMPLEADO (pCodEmpleado INT)
BEGIN
#FUNCTION supermercado.GETDATE does not exist	
    DECLARE Fecha_Actual DATE;
    SET Fecha_Actual = NOW();
    SELECT DATEDIFF(Fecha_Actual, EMPLEADO.Fecha_Contratado)
    FROM EMPLEADO
    WHERE pCodEmpleado = EMPLEADO.Cod_Empleado;
END
//

DELIMITER //
/*------------------------------------------------------------ CANTIDAD DE FACTURAS QUE REALIZA UN EMPLEADO ------------------------------------------------------------*/
CREATE PROCEDURE CANTIDAD_FACTURAS_EMPLEADO (pCodEmpleado INT)
BEGIN
    SELECT COUNT(FACTURA.Num_Factura)
	FROM FACTURA
	WHERE pCodEmpleado = FACTURA.Cod_Empleado;
END
//

DELIMITER //
/*------------------------------------------------------------ CANTIDAD DE EMPLEADOS DE UNA SUCURSAL ------------------------------------------------------------*/
CREATE PROCEDURE EMPLEADOS_SUCURSAL (pCodSucursal INT)
BEGIN
	SELECT COUNT(EMPLEADO.Cod_Empleado)
	FROM EMPLEADO
	INNER JOIN SUCURSAL ON EMPLEADO.Cod_Sucursal = SUCURSAL.Cod_Sucursal	
	WHERE pCodSucursal = SUCURSAL.Cod_Sucursal;
END
//

DELIMITER //
/*------------------------------------------------------------ CANTIDAD DE PRODUCTOS EN UNA SUCURSAL ------------------------------------------------------------*/
#¿productos totales o de uno en específico?
#arreglar el inner join
CREATE PROCEDURE PRODUCTOS_SUCURSAL(pCodSucursal INT)
BEGIN
    SELECT SUM(BODEGA_SUCURSAL_PRODUCTO.Cantidad_Actual)
	FROM BODEGA_SUCURSAL_PRODUCTO
	WHERE pCodSucursal = BODEGA_SUCURSAL_PRODUCTO.Cod_Sucursal;
END
//

DELIMITER //
/*------------------------------------------------------------ CANTIDAD DE SUCURSALES EN UN PAIS ------------------------------------------------------------*/
CREATE PROCEDURE SUCURSALES_PAIS (pCodPais INT)
BEGIN
    SELECT COUNT(SUCURSAL.Cod_Sucursal)
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
	SELECT PUESTO_LABORAL.Salario_Mensual/(EMPLEADO.Horas_Laborales*4) #horas_laborales son semanales *4 =mensuales
	FROM EMPLEADO
	INNER JOIN PUESTO_LABORAL ON EMPLEADO.Cod_Puesto_Laboral = PUESTO_LABORAL.Cod_Puesto_Laboral
	WHERE pCodEmpleado = EMPLEADO.Cod_Empleado;
END
//

DELIMITER //
/*------------------------------------------------------------ CANTIDAD DE EMPLEADOS POR PUESTO ------------------------------------------------------------*/
CREATE PROCEDURE EMPLEADO_CATEGORIA (pCodPuestoLabo INT)
BEGIN
    SELECT COUNT(EMPLEADO.Cod_Empleado)
	FROM EMPLEADO
	WHERE pCodPuestoLabo = EMPLEADO.Cod_Puesto_Laboral;
END
//

DELIMITER //
/*------------------------------------------------------------ CANTIDAD DE VECES QUE UN CLIENTE HA COMPRADO ------------------------------------------------------------*/
CREATE PROCEDURE COMPRAS_CLIENTE (pCodCliente INT)
BEGIN
    SELECT
		COUNT(FACTURA.Num_Factura)
	FROM
		FACTURA
	WHERE
		pCodCliente = FACTURA.Cod_Cliente;
END
//
																													/*ESTOS DE ABAJO NO SIRVEN*/
/*
DELIMITER  //
#CANTIDAD DE DIAS QUE HACEN FALTA PARA QUE CADUQUE UN PRODUCTO
CREATE PROCEDURE DIAS_CADUCIDAD_PRODUCTO (pCodProducto INT, pCodSucursal INT) 
BEGIN
    DECLARE FECHA_ACTUAL DATE;
    SET FECHA_ACTUAL = CAST(GETDATE() AS DATE);
    
    # Devuelve el número de días entre dos valores de fecha
    SELECT DATEDIFF(FECHA_ACTUAL, BODEGA_SUCURSAL_PRODUCTO.FECHA_VENCIMIENTO)
    FROM BODEGA_SUCURSAL_PRODUCTO 
    INNER JOIN PRODUCTO
    ON BODEGA_SUCURSAL_PRODUCTO.COD_PRODUCTO = PRODUCTO.COD_PRODUCTO
    WHERE @COD_PRODUCTO = PRODUCTO.COD_PRODUCTO;
    
    IF (CADUCIDAD_DIAS < 0) THEN
		SET CADUCIDAD_DIAS = 0;
	END IF;
END
//
*/

DELIMITER //
/*------------------------------------------------------------ DINERO FACTURADO EN UNA FECHA ------------------------------------------------------------*/
CREATE PROCEDURE VENDIDO_FECHA (FECHA DATE, COD_SUCURSAL INT)
BEGIN
	DECLARE DINERO_FACTURADO FLOAT;
    SET DINERO_FACTURADO = 0.0;
    
    SELECT 
		DINERO_FACTURADO = DINERO_FACTURADO + FACTURA_PRODUCTO.CANTIDAD_PRODUCTO * BODEGA_SUCURSAL_PRODUCTO.PRECIO_COMPRA
	FROM FACTURA_PRODUCTO
	INNER JOIN
		PRODUCTO
	ON
		FACTURA_PRODUCTO.COD_PRODUCTO = PRODUCTO.COD_PRODUCTO
	INNER JOIN
		BODEGA_SUCURSAL_PRODUCTO
	ON
		PRODUCTO.COD_PRODUCTO = BODEGA_SUCURSAL_PRODUCTO.COD_PRODUCTO
	INNER JOIN
		FACTURA
	ON
		FACTURA_PRODUCTO.NUM_FACTURA = FACTURA.NUM_FACTURA
	INNER JOIN
		EMPLEADO
	ON
		FACTURA.COD_EMPLEADO = EMPLEADO.COD_EMPLEADO
	WHERE
		@FECHA = FACTURA.FECHA_FACTURA AND @COD_SUCURSAL = EMPLEADO.COD_SUCURSAL;
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
-- CALCULA TOTAL A PAGAR DE UNA FACTURA
DELIMITER //
CREATE PROCEDURE TOTAL_FACTURA (NUM_FACTURA INT) 
BEGIN
	DECLARE TOTAL FLOAT DEFAULT 0;
    SELECT 
		@TOTAL = @TOTAL + FACTURA_PRODUCTO.CANTIDAD_PRODUCTO * BODEGA_SUCURSAL_PRODUCTO.PRECIO_COMPRA
	FROM
		FACTURA_PRODUCTO
	INNER JOIN
		FACTURA
	ON
		FACTURA_PRODUCTO.NUM_FACTURA = FACTURA.NUM_FACTURA
	INNER JOIN
		PRODUCTO
	ON
		PRODUCTO.COD_PRODUCTO = FACTURA_PRODUCTO.COD_PRODUCTO
	INNER JOIN
		BODEGA_SUCURSAL_PRODUCTO
	ON
		BODEGA_SUCURSAL_PRODUCTO.COD_PRODUCTO = PRODUCTO.COD_PRODUCTO
	WHERE
		@NUM_FACTURA = FACTURA.NUM_FACTURA;
END
//
*/