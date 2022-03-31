PROMPT CREATE TABLE historico_entidades_excluidas
CREATE TABLE historico_entidades_excluidas (
  id                    NUMBER(11,0) NOT NULL,
  tipo_identificacion   VARCHAR2(3)  NULL,
  numero_identificacion VARCHAR2(11) NULL,
  usuario_actualizacion NUMBER(10,0) NULL,
  fecha_actualizacion   DATE         NULL,
  accion                VARCHAR2(12) NOT NULL
)
  STORAGE (
    NEXT       1024 K
  )
/


