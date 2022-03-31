PROMPT CREATE TABLE entidades_excluidas
CREATE TABLE entidades_excluidas (
  tipo_identificacion   VARCHAR2(3)  NOT NULL,
  numero_identificacion VARCHAR2(11) NOT NULL,
  flags_tipos           VARCHAR2(8)  NOT NULL,
  obligar_carga         NUMBER(1,0)  NOT NULL,
  nombre                VARCHAR2(40) NULL,
  fecha_actualizacion   DATE         NOT NULL
)
  STORAGE (
    NEXT       1024 K
  )
/

COMMENT ON TABLE entidades_excluidas IS 'La columna FLAGS_TIPOS permite identificar los tipos de tratamiento que tiene el cliente dependiendo de los archivos de carga de entidades excluidas. Es una cadena de 8 caracteres donde cada uno indica una característica del cliente, así:
caracter 1: ¿El cliente es Vigilado por la Superbancaria?:  0=no  1=sí
caracter 2: ¿El cliente es Gran Contribuyente?:  0=no  1=sí
caracter 3: ¿El cliente es Oficial?:  0=no  1=sí';

COMMENT ON COLUMN entidades_excluidas.flags_tipos IS 'La columna FLAGS_TIPOS permite identificar los tipos de tratamiento que tiene el cliente dependiendo de los archivos de carga de entidades excluidas. Es una cadena de 8 caracteres donde cada uno indica una característica del cliente, así:
caracter 1: ¿El cliente es Vigilado por la Superbancaria?:  0=no  1=sí
caracter 2: ¿El cliente es Gran Contribuyente?:  0=no  1=sí
caracter 3: ¿El cliente es Oficial?:  0=no  1=sí';

