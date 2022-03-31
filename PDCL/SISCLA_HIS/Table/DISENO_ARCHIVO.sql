PROMPT CREATE TABLE diseno_archivo
CREATE TABLE diseno_archivo (
  codigo_archivo        NUMBER(5,0)  NOT NULL,
  secuencia_campo       NUMBER(10,0) NOT NULL,
  codigo                NUMBER(3,0)  NULL,
  posicion_inicial      NUMBER(4,0)  NULL,
  posicion_final        NUMBER(4,0)  NULL,
  requerido             NUMBER(1,0)  NULL,
  fijo                  NUMBER(1,0)  NULL,
  usuario_creacion      NUMBER(10,0) NULL,
  fecha_creacion        DATE         NULL,
  usuario_actualizacion NUMBER(10,0) NULL,
  fecha_actualizacion   DATE         NULL,
  nombre_columna        VARCHAR2(25) NULL
)
  STORAGE (
    NEXT       1024 K
  )
/


