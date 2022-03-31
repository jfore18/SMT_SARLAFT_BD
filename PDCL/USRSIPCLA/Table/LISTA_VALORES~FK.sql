PROMPT ALTER TABLE lista_valores ADD CONSTRAINT fk_lista_usuario FOREIGN KEY
ALTER TABLE lista_valores
  ADD CONSTRAINT fk_lista_usuario FOREIGN KEY (
    usuario_actualizacion
  ) REFERENCES usuario (
    cedula
  )
/

