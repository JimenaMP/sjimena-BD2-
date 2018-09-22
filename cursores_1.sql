SET SERVEROUTPUT ON;

--EJERCICIO 1 CURSORES DE TIPO IMPLICITO
--A) CREAR LA TABLA
CREATE TABLE EMPLEADO
  ( ID INTEGER PRIMARY KEY,
    NOMBRE VARCHAR2 (80),
    SUELDO_BASE FLOAT);
  --b) INSERTAR DATOS
INSERT INTO EMPLEADO VALUES(1, 'ANA',400); 
INSERT INTO EMPLEADO VALUES(2, 'JUAN',350);
INSERT INTO EMPLEADO VALUES(3, 'PEDRO',600);
INSERT INTO EMPLEADO VALUES(4, 'LUIS',520);

SELECT * FROM EMPLEADO;

--YA QUE TODO ESTA OK CON LA TABLITA, SEGUIMOS CON EL CURSOR!!
--EL CURSOR IMPLICITO ES UNA SOLA OCURRENCIA
--VA EN UN BLOQUE PL-SQL

DECLARE
NUM_EMPLEADOS INTEGER;
BEGIN
--EL SIGUIENTE ES EL CURSOR:
SELECT COUNT(*) INTO NUM_EMPLEADOS FROM EMPLEADO;
DBMS_OUTPUT.PUT_LINE('LOS EMPLEADOS SON '||NUM_EMPLEADOS);
END;
/