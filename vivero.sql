-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler version: 1.0.4
-- PostgreSQL version: 15.0
-- Project Site: pgmodeler.io
-- Model Author: ---
-- -- object: pg_database_owner | type: ROLE --
-- -- DROP ROLE IF EXISTS pg_database_owner;
-- CREATE ROLE pg_database_owner WITH 
-- 	INHERIT
-- 	 PASSWORD '********';
-- -- ddl-end --
-- 
-- object: pgexercises | type: ROLE --
-- DROP ROLE IF EXISTS pgexercises;
CREATE ROLE pgexercises WITH 
	SUPERUSER
	CREATEDB
	CREATEROLE
	INHERIT
	LOGIN
	 PASSWORD '********';
-- ddl-end --


-- Database creation must be performed outside a multi lined SQL file. 
-- These commands were put in this file only as a convenience.
-- 
-- object: vivero | type: DATABASE --
-- DROP DATABASE IF EXISTS vivero;
CREATE DATABASE vivero
	ENCODING = 'UTF8'
	LC_COLLATE = 'Spanish_United States.1252'
	LC_CTYPE = 'Spanish_United States.1252'
	TABLESPACE = pg_default
	OWNER = postgres;
-- ddl-end --


-- object: public.vivero | type: TABLE --
-- DROP TABLE IF EXISTS public.vivero CASCADE;
CREATE TABLE public.vivero (
	codigo_tienda integer NOT NULL,
	telefono character varying(10),
	direccion character varying(100),
	responsable_dni character varying(9),
	periodo_inicio date,
	periodo_fin date,
	CONSTRAINT vivero_pkey PRIMARY KEY (codigo_tienda)
);
-- ddl-end --
ALTER TABLE public.vivero OWNER TO postgres;
-- ddl-end --

-- object: public.empleado | type: TABLE --
-- DROP TABLE IF EXISTS public.empleado CASCADE;
CREATE TABLE public.empleado (
	dni character varying(9) NOT NULL,
	nombre character varying(50),
	telefono character varying(10),
	CONSTRAINT empleado_pkey PRIMARY KEY (dni)
);
-- ddl-end --
ALTER TABLE public.empleado OWNER TO postgres;
-- ddl-end --

-- object: public.zona | type: TABLE --
-- DROP TABLE IF EXISTS public.zona CASCADE;
CREATE TABLE public.zona (
	codigo_tienda integer NOT NULL,
	nombre character varying(50) NOT NULL,
	CONSTRAINT zona_pkey PRIMARY KEY (codigo_tienda,nombre)
);
-- ddl-end --
ALTER TABLE public.zona OWNER TO postgres;
-- ddl-end --

-- object: public.producto | type: TABLE --
-- DROP TABLE IF EXISTS public.producto CASCADE;
CREATE TABLE public.producto (
	codigo_producto integer NOT NULL,
	tipo character varying(50),
	precio numeric(10,2),
	nombre character varying(50),
	cuidados character varying(200),
	CONSTRAINT producto_pkey PRIMARY KEY (codigo_producto)
);
-- ddl-end --
ALTER TABLE public.producto OWNER TO postgres;
-- ddl-end --

-- object: public.stock | type: TABLE --
-- DROP TABLE IF EXISTS public.stock CASCADE;
CREATE TABLE public.stock (
	codigo_tienda integer NOT NULL,
	codigo_producto integer NOT NULL,
	cantidad integer,
	zona_nombre character varying(50) NOT NULL,
	CONSTRAINT stock_pkey PRIMARY KEY (codigo_tienda,codigo_producto,zona_nombre)
);
-- ddl-end --
ALTER TABLE public.stock OWNER TO postgres;
-- ddl-end --

-- object: public.clubvip | type: TABLE --
-- DROP TABLE IF EXISTS public.clubvip CASCADE;
CREATE TABLE public.clubvip (
	dni character varying(9) NOT NULL,
	nombre character varying(50),
	direccion character varying(100),
	telefono character varying(10),
	fecha_incorporacion date,
	CONSTRAINT clubvip_pkey PRIMARY KEY (dni)
);
-- ddl-end --
ALTER TABLE public.clubvip OWNER TO postgres;
-- ddl-end --

-- object: public.pedido | type: TABLE --
-- DROP TABLE IF EXISTS public.pedido CASCADE;
CREATE TABLE public.pedido (
	numero_pedido integer NOT NULL,
	fecha_realizacion date,
	dni_cliente character varying(9),
	empleado_dni character varying(9),
	codigo_tienda integer,
	portes numeric(10,2),
	CONSTRAINT pedido_pkey PRIMARY KEY (numero_pedido)
);
-- ddl-end --
ALTER TABLE public.pedido OWNER TO postgres;
-- ddl-end --

-- object: public.detallepedido | type: TABLE --
-- DROP TABLE IF EXISTS public.detallepedido CASCADE;
CREATE TABLE public.detallepedido (
	numero_pedido integer NOT NULL,
	codigo_producto integer NOT NULL,
	unidades integer,
	descuento numeric(10,2),
	CONSTRAINT detallepedido_pkey PRIMARY KEY (numero_pedido,codigo_producto)
);
-- ddl-end --
ALTER TABLE public.detallepedido OWNER TO postgres;
-- ddl-end --

-- object: zona_codigo_tienda_fkey | type: CONSTRAINT --
-- ALTER TABLE public.zona DROP CONSTRAINT IF EXISTS zona_codigo_tienda_fkey CASCADE;
ALTER TABLE public.zona ADD CONSTRAINT zona_codigo_tienda_fkey FOREIGN KEY (codigo_tienda)
REFERENCES public.vivero (codigo_tienda) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: stock_codigo_tienda_fkey | type: CONSTRAINT --
-- ALTER TABLE public.stock DROP CONSTRAINT IF EXISTS stock_codigo_tienda_fkey CASCADE;
ALTER TABLE public.stock ADD CONSTRAINT stock_codigo_tienda_fkey FOREIGN KEY (codigo_tienda)
REFERENCES public.vivero (codigo_tienda) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: stock_codigo_producto_fkey | type: CONSTRAINT --
-- ALTER TABLE public.stock DROP CONSTRAINT IF EXISTS stock_codigo_producto_fkey CASCADE;
ALTER TABLE public.stock ADD CONSTRAINT stock_codigo_producto_fkey FOREIGN KEY (codigo_producto)
REFERENCES public.producto (codigo_producto) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: stock_codigo_tienda_zona_nombre_fkey | type: CONSTRAINT --
-- ALTER TABLE public.stock DROP CONSTRAINT IF EXISTS stock_codigo_tienda_zona_nombre_fkey CASCADE;
ALTER TABLE public.stock ADD CONSTRAINT stock_codigo_tienda_zona_nombre_fkey FOREIGN KEY (codigo_tienda,zona_nombre)
REFERENCES public.zona (codigo_tienda,nombre) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: pedido_dni_cliente_fkey | type: CONSTRAINT --
-- ALTER TABLE public.pedido DROP CONSTRAINT IF EXISTS pedido_dni_cliente_fkey CASCADE;
ALTER TABLE public.pedido ADD CONSTRAINT pedido_dni_cliente_fkey FOREIGN KEY (dni_cliente)
REFERENCES public.clubvip (dni) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: pedido_empleado_dni_fkey | type: CONSTRAINT --
-- ALTER TABLE public.pedido DROP CONSTRAINT IF EXISTS pedido_empleado_dni_fkey CASCADE;
ALTER TABLE public.pedido ADD CONSTRAINT pedido_empleado_dni_fkey FOREIGN KEY (empleado_dni)
REFERENCES public.empleado (dni) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: pedido_codigo_tienda_fkey | type: CONSTRAINT --
-- ALTER TABLE public.pedido DROP CONSTRAINT IF EXISTS pedido_codigo_tienda_fkey CASCADE;
ALTER TABLE public.pedido ADD CONSTRAINT pedido_codigo_tienda_fkey FOREIGN KEY (codigo_tienda)
REFERENCES public.vivero (codigo_tienda) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: detallepedido_numero_pedido_fkey | type: CONSTRAINT --
-- ALTER TABLE public.detallepedido DROP CONSTRAINT IF EXISTS detallepedido_numero_pedido_fkey CASCADE;
ALTER TABLE public.detallepedido ADD CONSTRAINT detallepedido_numero_pedido_fkey FOREIGN KEY (numero_pedido)
REFERENCES public.pedido (numero_pedido) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: detallepedido_codigo_producto_fkey | type: CONSTRAINT --
-- ALTER TABLE public.detallepedido DROP CONSTRAINT IF EXISTS detallepedido_codigo_producto_fkey CASCADE;
ALTER TABLE public.detallepedido ADD CONSTRAINT detallepedido_codigo_producto_fkey FOREIGN KEY (codigo_producto)
REFERENCES public.producto (codigo_producto) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: "grant_CU_26541e8cda" | type: PERMISSION --
GRANT CREATE,USAGE
   ON SCHEMA public
   TO pg_database_owner;
-- ddl-end --

-- object: "grant_U_cd8e46e7b6" | type: PERMISSION --
GRANT USAGE
   ON SCHEMA public
   TO PUBLIC;
-- ddl-end --


