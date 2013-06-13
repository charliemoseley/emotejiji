--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: emotes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE emotes (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    text character varying(255) NOT NULL,
    description text,
    text_rows integer NOT NULL,
    max_length integer NOT NULL,
    display_rows integer NOT NULL,
    display_columns integer NOT NULL,
    tags hstore DEFAULT ''::hstore NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: user_emotes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_emotes (
    id integer NOT NULL,
    kind character varying(255) NOT NULL,
    user_id uuid NOT NULL,
    emote_id uuid NOT NULL,
    tags text[],
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: user_emotes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_emotes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_emotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_emotes_id_seq OWNED BY user_emotes.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    email character varying(255),
    username character varying(255) NOT NULL,
    password_digest character varying(255) NOT NULL,
    remember_token character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_emotes ALTER COLUMN id SET DEFAULT nextval('user_emotes_id_seq'::regclass);


--
-- Name: emotes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY emotes
    ADD CONSTRAINT emotes_pkey PRIMARY KEY (id);


--
-- Name: user_emotes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_emotes
    ADD CONSTRAINT user_emotes_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_emotes_on_tags; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_emotes_on_tags ON emotes USING gin (tags);


--
-- Name: index_emotes_on_text; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_emotes_on_text ON emotes USING btree (text);


--
-- Name: index_user_emotes_on_kind_and_emote_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_emotes_on_kind_and_emote_id ON user_emotes USING btree (kind, emote_id);


--
-- Name: index_user_emotes_on_kind_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_emotes_on_kind_and_user_id ON user_emotes USING btree (kind, user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20130517183714');

INSERT INTO schema_migrations (version) VALUES ('20130517183930');

INSERT INTO schema_migrations (version) VALUES ('20130530074520');

INSERT INTO schema_migrations (version) VALUES ('20130609224848');
