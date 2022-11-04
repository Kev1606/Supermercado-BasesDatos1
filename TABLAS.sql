CREATE DATABASE SUPERMERCADO;

CREATE TABLE IF NOT EXISTS SUCURSAL (
    ID_SUCURSAL INT NOT NULL AUTO_INCREMENT,
    NOMBRE_SUCURSAL VARCHAR(50) NOT NULL,
    PRIMARY KEY (ID_SUCURSAL)
);

CREATE TABLE IF NOT EXISTS CIUDAD (
	ID_CIUDAD INT NOT NULL AUTO_INCREMENT,
    NOMBRE_CIUDAD VARCHAR(50) NOT NULL,
    PRIMARY KEY (ID_CIUDAD)
);

CREATE TABLE IF NOT EXISTS SEXO (
	ID_SEXO INT NOT NULL AUTO_INCREMENT,
    DESCRIPCION_SEXO VARCHAR (15) NOT NULL,
    PRIMARY KEY (ID_SEXO)
);

CREATE TABLE IF NOT EXISTS PERSONA (
	ID_PERSONA INT NOT NULL AUTO_INCREMENT,
    NOMBRE VARCHAR(30) NOT NULL,
    APELLIDO VARCHAR(30) NOT NULL,
    FECHA_NACIMIENTO DATE NOT NULL,
    IDENTIFICACION VARCHAR(20) NOT NULL UNIQUE,
    DIRECCION_RESIDENCIA VARCHAR(20) NOT NULL,
    ID_CIUDAD INT NOT NULL,
    ID_SEXO INT NOT NULL,
    PRIMARY KEY (ID_PERSONA),
    FOREIGN KEY (ID_CIUDAD) REFERENCES CIUDAD (ID_CIUDAD),
    FOREIGN KEY (ID_SEXO) REFERENCES SEXO (ID_SEXO)
);

CREATE TABLE IF NOT EXISTS TELEFONO (
	ID_TELEFONO INT NOT NULL AUTO_INCREMENT,
    N_TELEFONO VARCHAR(8) NOT NULL,
    ID_PERSONA INT NOT NULL,
    PRIMARY KEY (ID_TELEFONO),
    FOREIGN KEY (ID_PERSONA) REFERENCES PERSONA (ID_PERSONA)
);

CREATE TABLE IF NOT EXISTS EMPLEADO (
	ID_EMPLEADO INT NOT NULL AUTO_INCREMENT,
    FECHA_CONTRATADO DATE NOT NULL,
    HORAS_LABORALES INT DEFAULT 0,
    ID_SUCURSAL INT NOT NULL,
    ID_PERSONA INT NOT NULL,
    PRIMARY KEY (ID_EMPLEADO),
    FOREIGN KEY (ID_SUCURSAL) REFERENCES SUCURSAL (ID_SUCURSAL),
    FOREIGN KEY (ID_PERSONA) REFERENCES PERSONA (ID_PERSONA)
);

CREATE TABLE IF NOT EXISTS CLIENTE (
	ID_CLIENTE INT NOT NULL AUTO_INCREMENT,
    ID_PERSONA INT NOT NULL,
    PRIMARY KEY (ID_CLIENTE),
    FOREIGN KEY (ID_PERSONA) REFERENCES PERSONA (ID_PERSONA)
);

CREATE TABLE IF NOT EXISTS CARGA_LABORAL (
	ID_CARGA_LABORAL INT NOT NULL AUTO_INCREMENT,
    DESCRIPCION VARCHAR(30) NOT NULL,
    SALARIO_MENSUAL FLOAT DEFAULT 0.0,
    PRIMARY KEY (ID_CARGA_LABORAL)
);

CREATE TABLE IF NOT EXISTS TIPO_USUARIO (
	ID_TIPO_USUARIO INT NOT NULL AUTO_INCREMENT,
    DESCRIPCION VARCHAR(30) NOT NULL,
    PRIMARY KEY (ID_TIPO_USUARIO)
);

CREATE TABLE IF NOT EXISTS USUARIO (
	ID_USUARIO INT NOT NULL AUTO_INCREMENT,
    NOMBRE_USUARIO VARCHAR(20) NOT NULL,
    CONTRASEÑA VARCHAR(20) NOT NULL,
    ID_TIPO_USUARIO INT NOT NULL,
    ID_PERSONA INT NOT NULL,
    PRIMARY KEY (ID_USUARIO),
    FOREIGN KEY (ID_TIPO_USUARIO) REFERENCES TIPO_USUARIO (ID_TIPO_USUARIO),
    FOREIGN KEY (ID_PERSONA) REFERENCES PERSONA (ID_PERSONA)
);

CREATE TABLE IF NOT EXISTS PROVEEDOR (
	ID_PROVEEDOR INT NOT NULL AUTO_INCREMENT,
    NOMBRE_PROVEEDOR VARCHAR(50) NOT NULL,
    PRIMARY KEY (ID_PROVEEDOR)
);

CREATE TABLE IF NOT EXISTS TIPO_PRODUCTO (
	ID_TIPO INT NOT NULL AUTO_INCREMENT,
    NOMBRE_TIPO VARCHAR(50) NOT NULL,
    DESCRIPCION VARCHAR(30) NOT NULL,
    PRIMARY KEY (ID_TIPO)
);

CREATE TABLE IF NOT EXISTS FACTURA (
	ID_FACTURA INT NOT NULL AUTO_INCREMENT,
    FECHA_FACTURA DATE NOT NULL,
    ID_SUCURSAL INT NOT NULL,
    ID_CLIENTE INT NOT NULL,
    ID_EMPLEADO INT NOT NULL,
    PRIMARY KEY (ID_FACTURA),
    FOREIGN KEY (ID_SUCURSAL) REFERENCES SUCURSAL (ID_SUCURSAL),
    FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTE (ID_CLIENTE),
    FOREIGN KEY (ID_EMPLEADO) REFERENCES EMPLEADO (ID_EMPLEADO)
);

CREATE TABLE IF NOT EXISTS PRODUCTO (
	ID_PRODUCTO INT NOT NULL AUTO_INCREMENT,
    NOMBRE_PRODUCTO VARCHAR(50) NOT NULL,
    FECHA_VENCIMIENTO DATE NOT NULL,
    COMPRA_PRODUCTO FLOAT NOT NULL,
    VENTA_PRODUCTO FLOAT NOT NULL,
    CANTIDAD_PRODUCTO INT DEFAULT 0,
    DESCRIPCION VARCHAR(30),
    ID_TIPO INT NOT NULL,
    ID_SUCURSAL INT NOT NULL,
    PRIMARY KEY (ID_PRODUCTO),
    FOREIGN KEY (ID_TIPO) REFERENCES TIPO_PRODUCTO (ID_TIPO),
    FOREIGN KEY (ID_SUCURSAL) REFERENCES SUCURSAL (ID_SUCURSAL)
);

CREATE TABLE IF NOT EXISTS FACTURA_PRODUCTO (
	ID_FACTURA INT NOT NULL,
    ID_PRODUCTO INT NOT NULL,
    FOREIGN KEY (ID_FACTURA) REFERENCES FACTURA (ID_FACTURA),
    FOREIGN KEY (ID_PRODUCTO) REFERENCES PRODUCTO (ID_PRODUCTO)
);

CREATE TABLE IF NOT EXISTS PRODUCTO_PROVEEDOR (
	ID_PRODUCTO INT NOT NULL,
    ID_PROVEEDOR INT NOT NULL,
    FOREIGN KEY (ID_PRODUCTO) REFERENCES PRODUCTO (ID_PRODUCTO),
    FOREIGN KEY (ID_PROVEEDOR) REFERENCES PROVEEDOR (ID_PROVEEDOR)
);