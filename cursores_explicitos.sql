-- CREAMOS LA TABLA ALMACEN
CREATE TABLE ALMACEN
(
  NUMERO_ALMACEN INTEGER,
  UBICACION_ALMACEN VARCHAR2(50),
  CONSTRAINT PK_NUM_ALMACEN PRIMARY KEY(NUMERO_ALMACEN)
);

--PRIMERO SE DEFINE EL NOMBRE Y TIPO DE CAMPO
--LUEGO ALS RESTRICCIONES (CONSTRAINT) EL NOMBRE DEL CONSTRAINT, ENTRE () EL CAMPO DEL COSNT.

--CREAMOS LA TABLA CLIENTE QUE SE RELACIONA A ALMACEN
CREATE TABLE CLIENTE
(
  NUMERO_CLIENTE INTEGER,
  NUMERO_ALMACEN INTEGER, --ESTE SER AEL FK
  NOMBRE_CLIENTE VARCHAR2(50),
  CONSTRAINT PK_NUM_CLIENTE PRIMARY KEY (NUMERO_CLIENTE),
  CONSTRAINT FK1_NUM_ALMACEN FOREIGN KEY (NUMERO_ALMACEN) REFERENCES ALMACEN(NUMERO_ALMACEN)
);

--PROCEDIMIENTO GUARDAR ALMACEN
CREATE OR REPLACE PROCEDURE GUARDAR_ALMACEN(MI_ID IN INTEGER, MI_UBI IN VARCHAR2)
AS
BEGIN
INSERT INTO ALMACEN VALUES(MI_ID,MI_UBI);
END;
/

--PROCEDIMIENTO GUARDAR CLIENTE
CREATE OR REPLACE PROCEDURE GUARDAR_CLIENTE(MI_ID IN INTEGER, ID_ALMACEN IN INTEGER, NOMB_CLIENTE IN VARCHAR2)
AS
BEGIN
INSERT INTO CLIENTE VALUES(MI_ID, ID_ALMACEN, NOMB_CLIENTE);
END;
/

--GENERAR LA TABLA VENDEDOR
CREATE TABLE VENDEDOR
(
  NUMERO_VENDEDOR INTEGER,
  NOMBRE_VENDEDOR VARCHAR2(50),
  AREA_VENTAS VARCHAR2(50),
  CONSTRAINT PK_NUM_VEND PRIMARY KEY (NUMERO_VENDEDOR)
);

--GENERAR LA TABLA VENTAS
CREATE TABLE VENTAS
(
  ID_VENTAS INTEGER,
  NUMERO_CLIENTE INTEGER,
  NUMERO_VENDEDOR INTEGER,
  MONTO_VENTAS FLOAT,
  CONSTRAINT PK_ID_VENTAS PRIMARY KEY (ID_VENTAS),
  CONSTRAINT FK1_NUM_VENDEDOR FOREIGN KEY (NUMERO_VENDEDOR) REFERENCES VENDEDOR (NUMERO_VENDEDOR),
  CONSTRAINT FK2_NUM_CLIENTE FOREIGN KEY (NUMERO_CLIENTE) REFERENCES CLIENTE (NUMERO_CLIENTE)
);

CREATE OR REPLACE PROCEDURE GUARDAR_VENDEDOR (ID_VENDEDOR IN INTEGER,NOMB_VEND IN VARCHAR2, MI_AREA IN VARCHAR2)
AS
BEGIN
INSERT INTO VENDEDOR VALUES(ID_VENDEDOR,NOMB_VEND,MI_AREA);
END;
/

--COMO EL ID DE VENTAS ES AUTOINCREMENTABLE, HACEMOS UN CURSOR.

--YA QUE ESTA LA TABLA, HACEMOS LA SECUENCIA QUE CONTORLA LA PK.

CREATE SEQUENCE SEC_VENTAS
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

--AHORA EL PROCEDIMIENTO PARA ASOCIAL LA SECUENCIA A LA TABLA DE VENTAS

CREATE OR REPLACE PROCEDURE GUARDAR_VENTAS(ID_VENTAS OUT INTEGER, NUM_CLIENTE IN INTEGER,
NUM_VENDEDOR IN INTEGER, MI_MONTO IN FLOAT)
AS
BEGIN
SELECT SEC_VENTAS.NEXTVAL INTO ID_VENTAS FROM DUAL;
INSERT INTO VENTAS VALUES(ID_VENTAS, NUM_CLIENTE, NUM_VENDEDOR, MI_MONTO);
END;
/

--LLENAMOS LAS TABLAS
--PRIMERO LOS ALMACENES

--HACEMOS UN BLOQUE PLSQL
BEGIN
GUARDAR_ALMACEN(1,'PLYMOUTH');
GUARDAR_ALMACEN(2,'SUPERIOR');
GUARDAR_ALMACEN(3,'BISMACK');
GUARDAR_ALMACEN(4,'FARGO');
END;
/

SELECT * FROM ALMACEN;

--AHORA GUARDAMOS LA INFORMACION EN VENDEDOR CON UN BLOQE NUEVO PLSQL EN LA TABLA VENDEDOR
BEGIN
GUARDAR_VENDEDOR(3462,'WATERS','WEST');
GUARDAR_VENDEDOR(3595,'DRYNE','EAST');
END;
/
SELECT * FROM VENDEDOR

--LLENAMOS LOS DATOS DE LOS CLIENTES CON U BLOQUE PLSQL
BEGIN
GUARDAR_CLIENTE(18765,4,'DELTA SYSTEMS');
GUARDAR_CLIENTE(18830,3,'A. LEVY AND SONS');
GUARDAR_CLIENTE(19242,3,'RAINIER COMPANY');
GUARDAR_CLIENTE(18841,2,'R.W. FLOOD INC');
GUARDAR_CLIENTE(18849,2,'SEWARD SYSTEM');
GUARDAR_CLIENTE(19565,1,'SOTOLAS INC.');
END;
/
SELECT * FROM CLIENTE
SELECT * FROM VENTAS
--VENTAS CON  PLSQL

DECLARE
VENTA INTEGER;
BEGIN
GUARDAR_VENTAS(VENTA,18765,3462,13540);
GUARDAR_VENTAS(VENTA,18830,3462,10600); 
GUARDAR_VENTAS(VENTA,19242,3462,9700);
GUARDAR_VENTAS(VENTA,18841,3595,11560);
GUARDAR_VENTAS(VENTA,18849,3595,2590);
GUARDAR_VENTAS(VENTA,19565,3595,8800);
END;
/

--17/10/18

--3) EFECTTUAR EL SELECT DEL ALMACEN
SELECT * FROM ALMACEN

--4) CU5RSOS EXPLICITO PARA ITERAR LA TABLA ALMACEN}
SET SERVEROUTPUT ON;
DECLARE
CURSOR CUR_ALMACEN IS SELECT * FROM ALMACEN;
--PARA RECORRERLO USAMOS UN CICLO FOR
begin
FOR FILA IN CUR_ALMACEN LOOP --REC PARA RECORRER
--EL INDICE O ES UN NUMERO. FILA ES EL INDICE
DBMS_OUTPUT.put_LINE('LA UBICACION DEL ALMACEN ES:'|| FILA.UBICACION_ALMACEN);

END LOOP;
END;
/

--procedmiENTO ECATERROR

DECLARE 
CURSOR CUR_ALMACEN IS SELECT * FROM ALMACEN FOR UPDATE;
--SE PONE FOR UPDATE POR QUE ES PARA ACTALIZAR.. DAAHH
--LA LOGICA (: :
BEGIN
FOR FILA IN CUR_ALMACEN LOOP
DBMS_OUTPUT.PUT_LINE('UBICACION ACTUAL '||FILA.UBICACION_ALMACEN);
UPDATE ALMACEN SET UBICACION_ALMACEN
=FILA.UBICACION_ALMACEN||',ECATERROR' WHERE CURRENT OF CUR_ALMACEN; --NO HAY NECESIDAD DE PONERLE ID, SE INDICA QUE ES EN EL CURSOR QUE ESTA VIGENTE, EN LA FILA QUE ESTA EN SE MOMENTO EN EL CURSOR
END LOOP;
END;
/

--ESTE CURSOR YA YA YA HACE CAMBIOS :)

SELECT * FROM ALMACEN

--EJER. 3
DECLARE 
CURSOR CUR_ALMACEN IS SELECT * FROM ALMACEN FOR UPDATE;
--SE PONE FOR UPDATE POR QUE ES PARA ACTALIZAR.. DAAHH
--LA LOGICA (: :
BEGIN
FOR FILA IN CUR_ALMACEN LOOP
DBMS_OUTPUT.PUT_LINE('UBICACION ACTUAL '||FILA.UBICACION_ALMACEN);
--CHECAMOS EL NUMERO DE ALMACEN
IF FILA.NUMERO_ALMACEN <=2 THEN
  UPDATE ALMACEN SET UBICACION_ALMACEN='NEZAYORK' WHERE CURRENT OF CUR_ALMACEN; --NO HAY NECESIDAD DE PONERLE ID, SE INDICA QUE ES EN EL CURSOR QUE ESTA VIGENTE, EN LA FILA QUE ESTA EN SE MOMENTO EN EL CURSOR
END IF;
END LOOP;
END;
/

--ej 4
DECLARE 
CURSOR CUR_ALMACEN IS SELECT * FROM ALMACEN;
--LA LOGICA (: :
BEGIN
FOR FILA IN CUR_ALMACEN LOOP
DBMS_OUTPUT.PUT_LINE('UBICACION ACTUAL '||FILA.UBICACION_ALMACEN);
IF FILA.NUMERO_ALMACEN == 'NEZAYORK' THEN
  UPDATE ALMACEN SET UBICACION_ALMACEN='NEZAYORK' WHERE CURRENT OF CUR_ALMACEN; --NO HAY NECESIDAD DE PONERLE ID, SE INDICA QUE ES EN EL CURSOR QUE ESTA VIGENTE, EN LA FILA QUE ESTA EN SE MOMENTO EN EL CURSOR
END IF;
UPDATE ALMACEN SET UBICACION_ALMACEN
=FILA.UBICACION_ALMACEN||',ECATERROR' WHERE CURRENT OF CUR_ALMACEN; --NO HAY NECESIDAD DE PONERLE ID, SE INDICA QUE ES EN EL CURSOR QUE ESTA VIGENTE, EN LA FILA QUE ESTA EN SE MOMENTO EN EL CURSOR
END LOOP;
END;
/
