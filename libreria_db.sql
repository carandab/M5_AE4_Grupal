CREATE DATABASE IF NOT EXISTS libreria_db;

USE libreria_db;


-- TABLAS
CREATE TABLE clientes
(
  id_cliente        INT          NOT NULL AUTO_INCREMENT,
  nombre_cliente    VARCHAR(100) NOT NULL,
  correo_cliente    VARCHAR(100) NOT NULL,
  telefono_cliente  VARCHAR(15)  NOT NULL,
  direccion_cliente VARCHAR(100) NOT NULL,
  PRIMARY KEY (id_cliente)
);

CREATE TABLE detalles_pedido
(
  id_detalle     INT           NOT NULL AUTO_INCREMENT,
  id_pedido      INT           NOT NULL,
  id_libro       INT           NOT NULL,
  cantidad_libro INT           NOT NULL,
  precio_libro   DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id_detalle)
);

CREATE TABLE libros
(
  id_libro            INT           NOT NULL AUTO_INCREMENT,
  titulo_libro        VARCHAR(225)  NOT NULL,
  autor_libro         VARCHAR(100)  NOT NULL,
  precio_libro        VARCHAR(10,2) NOT NULL,
  cantidad_disponible INT           NOT NULL,
  categoria_libro     VARCHAR(50)   NOT NULL,
  PRIMARY KEY (id_libro)
);

CREATE TABLE pagos
(
  id_pago     INT           NOT NULL AUTO_INCREMENT,
  id_pedido   INT           NOT NULL,
  fecha_pago  DATE          NOT NULL,
  monto_pago  DECIMAL(10,2) NOT NULL,
  metodo_pago VARCHAR(50)   NOT NULL,
  PRIMARY KEY (id_pago)
);

CREATE TABLE pedidos
(
  id_pedido     INT         NOT NULL AUTO_INCREMENT,
  id_cliente    INT         NOT NULL,
  fecha_pedido  DATE        NOT NULL,
  total_pedido  DECIMAL(10,2)    NOT NULL,
  estado_pedido VARCHAR(50) NOT NULL,
  PRIMARY KEY (id_pedido)
);

-- RESTRICCIONES

-- Restricciones clientes

ALTER TABLE clientes
ADD CONSTRAINT CHK_telefono_numeros_longitud
CHECK (LENGTH(telefono_cliente) = 10 AND telefono_cliente NOT LIKE '%[^0-9]%');

-- Alternativa que me dio Gemini, dice que es una herramienta mucho mas poderosa
ALTER TABLE clientes
ADD CONSTRAINT CHK_telefono_numeros_longitud
CHECK (telefono_cliente REGEXP '^[0-9]{10}$')
-- REGEXP es un operador que busca patrones en una cadena (Regular Expression)
--  ^ indica que debe coincidir con el inicio de la cadena, [] conjunto de caracteres que se busca
--  {} cuantificador que indica la cantidad de veces que se debe repetir el conjunto ,  $ indica que debe coincidir con el final de la cadena

ADD CONSTRAINT UQ_correo_cliente UNIQUE (correo_cliente);

-- Restricciones libros

ALTER TABLE libros
ADD CONSTRAINT CHK_cantidad_positiva
CHECK (cantidad_disponible > 0);


-- Restricciones pedidos

ALTER TABLE pedidos
  ADD CONSTRAINT FK_clientes_TO_pedidos
    FOREIGN KEY (id_cliente)
    REFERENCES clientes (id_cliente);

ALTER TABLE pedidos
  ADD CONSTRAINT UQ_id_cliente UNIQUE (id_cliente);

-- Restricciones detalles_pedido

ALTER TABLE detalles_pedido
  ADD CONSTRAINT FK_pedidos_TO_detalles_pedido
    FOREIGN KEY (id_pedido)
    REFERENCES pedidos (id_pedido);

ALTER TABLE detalles_pedido
  ADD CONSTRAINT FK_libros_TO_detalles_pedido
    FOREIGN KEY (id_libro)
    REFERENCES libros (id_libro);

ALTER TABLE detalles_pedido
  ADD CONSTRAINT UQ_id_libro UNIQUE (id_libro);

-- Restricciones pagos

ALTER TABLE pagos
  ADD CONSTRAINT FK_pedidos_TO_pagos
    FOREIGN KEY (id_pedido)
    REFERENCES pedidos (id_pedido);

-- Modificaciones 

ALTER TABLE clientes
    MODIFY COLUMN telefono_cliente VARCHAR(20);

ALTER TABLE libros
    MODIFY COLUMN precio_libro DECIMAL(10,3);

ALTER TABLE pagos
    ADD COLUMN fecha_confirtmacion DATE AFTER monto_pago;

-- Eliminar tabla
DROP TABLE pagos;

-- Truncar tabla
TRUNCATE TABLE pedidos;