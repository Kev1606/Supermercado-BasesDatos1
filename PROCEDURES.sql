/*-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------PROCEDURES----------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------*/

DELIMITER //
/*------------------------------------------------------------ CANTIDAD DE TIEMPO QUE LLEVA TRABAJANDO UN EMPLEADO ------------------------------------------------------------*/
CREATE PROCEDURE TIEMPO_LABORAL_EMPLEADO (pCodEmpleado INT)
BEGIN
    DECLARE Fecha_Actual DATE;
    SET Fecha_Actual = NOW();
    SELECT DATEDIFF(Fecha_Actual, EMPLEADO.Fecha_Contratado)
    FROM EMPLEADO
    WHERE pCodEmpleado = EMPLEADO.Cod_Empleado;
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
	SELECT COUNT(EMPLEADO.Cod_Empleado)
	FROM EMPLEADO
	INNER JOIN SUCURSAL ON EMPLEADO.Cod_Sucursal = SUCURSAL.Cod_Sucursal	
	WHERE pCodSucursal = SUCURSAL.Cod_Sucursal;
END
//

DELIMITER //
/*------------------------------------------------------------ CANTIDAD DE PRODUCTOS EN UNA SUCURSAL ------------------------------------------------------------*/
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
END;
//

SET GLOBAL LOG_BIN_TRUST_FUNCTION_CREATORS = 1;

DELIMITER  //
#CANTIDAD DE DIAS QUE HACEN FALTA PARA QUE CADUQUE UN PRODUCTO
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
    DINERO_FACTURADO + FACTURA_PRODUCTO.CANTIDAD_PRODUCTO * BODEGA_SUCURSAL_PRODUCTO.PRECIO_COMPRA
	INTO DINERO_FACTURADO
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
		FECHA = FACTURA.FECHA_FACTURA AND COD_SUCURSAL = EMPLEADO.COD_SUCURSAL;
	
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
		BODEGA_COMPRA.PRECIO_COMPRA
	INTO PRODUCTO_VENTA
	FROM
		BODEGA_COMPRA
	INNER JOIN
		PRODUCTO
	ON
		BODEGA_COMPRA.COD_PRODUCTO = PRODUCTO.COD_PRODUCTO
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
CREATE FUNCTION TOTAL_FACTURA (NUM_FACTURA INT, NUM_PEDIDO INT) RETURNS FLOAT
BEGIN
	DECLARE TOTAL FLOAT DEFAULT 0;
    SELECT 
		TOTAL + FACTURA_PRODUCTO.CANTIDAD_PRODUCTO * BODEGA_SUCURSAL_PRODUCTO.PRECIO_COMPRA
	INTO
		TOTAL
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
		NUM_FACTURA = FACTURA.NUM_FACTURA AND NUM_PEDIDO = FACTURA.NUM_PEDIDO;
	
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
		FACTURA_PRODUCTO.COD_PRODUCTO AS 'CODIGO',
		SUM(FACTURA_PRODUCTO.CANTIDAD_PRODUCTO) AS 'CANTIDAD',
		PRODUCTO.NOMBRE_PRODUCTO AS 'NOMBRE'
	FROM
		FACTURA_PRODUCTO
	INNER JOIN
		PRODUCTO
	ON
		FACTURA_PRODUCTO.COD_PRODUCTO = PRODUCTO.COD_PRODUCTO
	INNER JOIN
		FACTURA
	ON
		FACTURA_PRODUCTO.NUM_FACTURA = FACTURA.NUM_FACTURA
	INNER JOIN
		EMPLEADO
	ON
		FACTURA.COD_EMPLEADO = EMPLEADO.COD_EMPLEADO
	WHERE
		FECHA = FACTURA.FECHA_FACTURA AND COD_SUCURSAL = EMPLEADO.COD_SUCURSAL
	GROUP BY
		FACTURA_PRODUCTO.COD_PRODUCTO, FACTURA_PRODUCTO.CANTIDAD_PRODUCTO, PRODUCTO.NOMBRE_PRODUCTO;
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
	IF (CANTIDAD_FACTURAS_EMPLEADO(pCOD_EMPLEADO) > 20) THEN
		-- MANDAR A LLAMAR EL CRUD DE LA TABLA BONOS_EMPLEADO EN VEZ DE ESTO
        CALL CRUD_BONOSEMP (pCOD_EMPLEADO, pMONTO_BONO, pFECHA_BONO, 'CREATE');
	END IF;
END
//

DELIMITER //
/*---------------------------------------------------- RETIRA LOS PRODUCTOS EXPIRADOS DE LA SUCURSAL -------------------------------------------------------*/
CREATE PROCEDURE RETIRA_PRODUCTOS_EXPIRADOS (COD_PRODUCTO INT, COD_BODEGA_SUCURSAL INT)
BEGIN
	IF (DIAS_CADUCIDAD_PRODUCTO(COD_PRODUCTO) < 0) THEN
		CALL CRUD_PRODUCTO_EXPIRADO ( COD_PRODUCTO, (SELECT NOMBRE_PRODUCTO FROM PRODUCTO WHERE COD_PRODUCTO = PRODUCTO.COD_PRODUCTO), 'CREATE');
        -- (pCodBodega INT, pCodProdu INT, pCodSucursal INT, pPrecioCompra FLOAT, pCodProveedor INT, pFechaCompra INT, pCantCompra INT, pFechaProduc DATE, pFechaVenci DATE, pOperacion VARCHAR(10))
        CALL CRUD_BODESUCUPRODU (COD_BODEGA_SUCURSAL, COD_PRODUCTO, 'DELETE');
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
        NOMBRE_PRODUCTO AS 'NOMBRE DEL PRODUCTO'
    FROM PRODUCTO_EXPIRADO;
END
//