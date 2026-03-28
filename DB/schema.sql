--
-- PostgreSQL database dump
--

\restrict m9ZR36RFiFzffOHgylSirVbQtcJoKsu6dgfAZwQQzkW3neZ0SCYidbsUGg7c4fM

-- Dumped from database version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)

-- Started on 2026-03-28 20:38:36 -03

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 232 (class 1255 OID 17964)
-- Name: fn_select_chat_grupo_mensagem(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_select_chat_grupo_mensagem(p_codigo_empresa_chat bigint) RETURNS TABLE(nome_usuario character varying, codigo_mensagem bigint, codigo_grupo bigint, codigo_empresa_grupo bigint, codigo_usuario_remetente bigint, codigo_empresa_usuario_remetente bigint, mensagem text, data_envio timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN

    RETURN QUERY
    SELECT 
		CONCAT(tb_cad_usuario.usuario, ' - ', tb_cad_empresa.nome_fantasia)::VARCHAR(255) AS nome_usuario,
		tb_chat_grupo_mensagem.codigo_mensagem 			AS codigo_mensagem,
		tb_chat_grupo_mensagem.codigo_grupo 			AS codigo_grupo,
		tb_chat_grupo_mensagem.codigo_empresa_grupo 	AS codigo_empresa_grupo,
		tb_chat_grupo_mensagem.codigo_usuario 			AS codigo_usuario_remetente,
		tb_chat_grupo_mensagem.codigo_empresa_usuario 	AS codigo_empresa_usuario_remetente,
		tb_chat_grupo_mensagem.mensagem 				AS mensagem,
		tb_chat_grupo_mensagem.data_input 				AS data_envio
    FROM tb_chat_grupo_mensagem
	LEFT JOIN tb_cad_usuario 
	ON  tb_cad_usuario.codigo_empresa = tb_chat_grupo_mensagem.codigo_empresa_usuario
	AND tb_cad_usuario.codigo = tb_chat_grupo_mensagem.codigo_usuario
	INNER JOIN tb_cad_empresa
	ON  tb_cad_empresa.codigo = tb_cad_usuario.codigo_empresa
    WHERE tb_chat_grupo_mensagem.codigo_empresa_grupo = p_codigo_empresa_chat
	ORDER by tb_chat_grupo_mensagem.data_input;

END;
$$;


ALTER FUNCTION public.fn_select_chat_grupo_mensagem(p_codigo_empresa_chat bigint) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 17911)
-- Name: tb_cad_empresa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tb_cad_empresa (
    codigo bigint NOT NULL,
    nome_fantasia character varying(255),
    razao_social character varying(255),
    presta_suporte boolean
);


ALTER TABLE public.tb_cad_empresa OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 17980)
-- Name: tb_cad_grupo_empresa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tb_cad_grupo_empresa (
    codigo bigint NOT NULL,
    descricao character varying(255)
);


ALTER TABLE public.tb_cad_grupo_empresa OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 17970)
-- Name: tb_cad_grupo_empresa_empresas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tb_cad_grupo_empresa_empresas (
    codigo_grupo bigint NOT NULL,
    codigo_empresa bigint NOT NULL
);


ALTER TABLE public.tb_cad_grupo_empresa_empresas OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 17918)
-- Name: tb_cad_usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tb_cad_usuario (
    codigo bigint NOT NULL,
    codigo_empresa bigint NOT NULL,
    usuario character varying(255),
    nome character varying(255),
    usuario_adm boolean
);


ALTER TABLE public.tb_cad_usuario OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 17930)
-- Name: tb_chat_grupo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tb_chat_grupo (
    codigo bigint NOT NULL,
    codigo_empresa bigint NOT NULL,
    titulo character varying(255)
);


ALTER TABLE public.tb_chat_grupo OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 17940)
-- Name: tb_chat_grupo_mensagem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tb_chat_grupo_mensagem (
    codigo_mensagem bigint NOT NULL,
    codigo_grupo bigint NOT NULL,
    codigo_empresa_grupo bigint,
    codigo_usuario bigint,
    codigo_empresa_usuario bigint,
    mensagem text,
    data_input timestamp without time zone
);


ALTER TABLE public.tb_chat_grupo_mensagem OWNER TO postgres;

--
-- TOC entry 3431 (class 0 OID 17911)
-- Dependencies: 215
-- Data for Name: tb_cad_empresa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tb_cad_empresa (codigo, nome_fantasia, razao_social, presta_suporte) FROM stdin;
1	UserHelp Software	The Support solutions SA	t
2	Varejo Legal	Varejo & Comercio LTDA	f
3	Mega Industria	Industry and Tech SA	f
\.


--
-- TOC entry 3436 (class 0 OID 17980)
-- Dependencies: 220
-- Data for Name: tb_cad_grupo_empresa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tb_cad_grupo_empresa (codigo, descricao) FROM stdin;
1	EMPRESAS TIME A
2	EMPRESAS TIME B
\.


--
-- TOC entry 3435 (class 0 OID 17970)
-- Dependencies: 219
-- Data for Name: tb_cad_grupo_empresa_empresas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tb_cad_grupo_empresa_empresas (codigo_grupo, codigo_empresa) FROM stdin;
2	2
2	3
\.


--
-- TOC entry 3432 (class 0 OID 17918)
-- Dependencies: 216
-- Data for Name: tb_cad_usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tb_cad_usuario (codigo, codigo_empresa, usuario, nome, usuario_adm) FROM stdin;
1	1	Master User	Usuário mestre de suporte	t
2	1	User_One	Usuário 1	f
1	2	Varejo Owner	Dono do Varejo	f
2	2	Varejo User	usuario comum varejo	f
1	3	Industry Owner	Owner da Industry	f
2	3	Industry worker	Commom worker	f
\.


--
-- TOC entry 3433 (class 0 OID 17930)
-- Dependencies: 217
-- Data for Name: tb_chat_grupo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tb_chat_grupo (codigo, codigo_empresa, titulo) FROM stdin;
1	2	Suporte Varejo PDV
2	2	Suporte Faturamento 
1	3	Suporte apontamento
2	3	Suporte Requisicao estoque
\.


--
-- TOC entry 3434 (class 0 OID 17940)
-- Dependencies: 218
-- Data for Name: tb_chat_grupo_mensagem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tb_chat_grupo_mensagem (codigo_mensagem, codigo_grupo, codigo_empresa_grupo, codigo_usuario, codigo_empresa_usuario, mensagem, data_input) FROM stdin;
1	1	3	1	3	Olá, Preciso de ajuda	2026-03-28 19:49:06.439992
2	1	3	1	1	como podemos ajudar?	2026-03-28 19:49:51.618115
3	1	3	1	3	Os apontamentos estão travados	2026-03-28 19:52:37.779362
4	1	3	2	3	Acho que o APP caiu	2026-03-28 20:24:03.230255
\.


--
-- TOC entry 3276 (class 2606 OID 17934)
-- Name: tb_chat_grupo pk_chat_grupo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_chat_grupo
    ADD CONSTRAINT pk_chat_grupo PRIMARY KEY (codigo, codigo_empresa);


--
-- TOC entry 3272 (class 2606 OID 17917)
-- Name: tb_cad_empresa pk_empresa; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_cad_empresa
    ADD CONSTRAINT pk_empresa PRIMARY KEY (codigo);


--
-- TOC entry 3282 (class 2606 OID 17984)
-- Name: tb_cad_grupo_empresa pk_grupo_empresa; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_cad_grupo_empresa
    ADD CONSTRAINT pk_grupo_empresa PRIMARY KEY (codigo);


--
-- TOC entry 3280 (class 2606 OID 17974)
-- Name: tb_cad_grupo_empresa_empresas pk_grupo_empresa_empresas; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_cad_grupo_empresa_empresas
    ADD CONSTRAINT pk_grupo_empresa_empresas PRIMARY KEY (codigo_grupo, codigo_empresa);


--
-- TOC entry 3278 (class 2606 OID 17946)
-- Name: tb_chat_grupo_mensagem pk_grupo_mensagem; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_chat_grupo_mensagem
    ADD CONSTRAINT pk_grupo_mensagem PRIMARY KEY (codigo_mensagem, codigo_grupo);


--
-- TOC entry 3274 (class 2606 OID 17924)
-- Name: tb_cad_usuario pk_usuario; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_cad_usuario
    ADD CONSTRAINT pk_usuario PRIMARY KEY (codigo, codigo_empresa);


--
-- TOC entry 3285 (class 2606 OID 17947)
-- Name: tb_chat_grupo_mensagem fk_empresa_grupo_mensagem; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_chat_grupo_mensagem
    ADD CONSTRAINT fk_empresa_grupo_mensagem FOREIGN KEY (codigo_grupo, codigo_empresa_grupo) REFERENCES public.tb_chat_grupo(codigo, codigo_empresa);


--
-- TOC entry 3286 (class 2606 OID 17952)
-- Name: tb_chat_grupo_mensagem fk_empresa_grupo_mensagem_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_chat_grupo_mensagem
    ADD CONSTRAINT fk_empresa_grupo_mensagem_usuario FOREIGN KEY (codigo_usuario, codigo_empresa_usuario) REFERENCES public.tb_cad_usuario(codigo, codigo_empresa);


--
-- TOC entry 3284 (class 2606 OID 17935)
-- Name: tb_chat_grupo fk_grupo_empresa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_chat_grupo
    ADD CONSTRAINT fk_grupo_empresa FOREIGN KEY (codigo_empresa) REFERENCES public.tb_cad_empresa(codigo);


--
-- TOC entry 3287 (class 2606 OID 17975)
-- Name: tb_cad_grupo_empresa_empresas fk_grupo_empresa_empresas; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_cad_grupo_empresa_empresas
    ADD CONSTRAINT fk_grupo_empresa_empresas FOREIGN KEY (codigo_empresa) REFERENCES public.tb_cad_empresa(codigo);


--
-- TOC entry 3283 (class 2606 OID 17925)
-- Name: tb_cad_usuario fk_usuario_empresa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_cad_usuario
    ADD CONSTRAINT fk_usuario_empresa FOREIGN KEY (codigo_empresa) REFERENCES public.tb_cad_empresa(codigo);


-- Completed on 2026-03-28 20:38:36 -03

--
-- PostgreSQL database dump complete
--

\unrestrict m9ZR36RFiFzffOHgylSirVbQtcJoKsu6dgfAZwQQzkW3neZ0SCYidbsUGg7c4fM

