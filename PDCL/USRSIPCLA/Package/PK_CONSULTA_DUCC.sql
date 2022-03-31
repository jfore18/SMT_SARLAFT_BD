PROMPT CREATE OR REPLACE PACKAGE pk_consulta_ducc
CREATE OR REPLACE PACKAGE pk_consulta_ducc IS
  PROCEDURE consultar;
  PROCEDURE abrirArchivo          (ubicacion     IN     VARCHAR2,
                                   nombre        IN     VARCHAR2,
                                   modoApertura  IN     VARCHAR2,
		                               archivo       OUT    UTL_FILE.FILE_TYPE);
  PROCEDURE escribirArchivo       (archivo       IN OUT UTL_FILE.FILE_TYPE,
	                                 mensaje       IN     VARCHAR2);

  PROCEDURE cerrarArchivo         (archivo       IN OUT UTL_FILE.FILE_TYPE);

  PROCEDURE formatoConcepto       (concepto      IN OUT VARCHAR2);

END;
/

