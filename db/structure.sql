SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: frames; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE frames (
    id bigint NOT NULL,
    game_id bigint NOT NULL,
    next_frame_id bigint,
    type character varying NOT NULL
);


--
-- Name: frames_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE frames_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: frames_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE frames_id_seq OWNED BY frames.id;


--
-- Name: game_frames; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE game_frames (
    id bigint NOT NULL,
    game_id bigint NOT NULL,
    user_id bigint NOT NULL
);


--
-- Name: game_frames_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE game_frames_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: game_frames_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE game_frames_id_seq OWNED BY game_frames.id;


--
-- Name: games; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE games (
    id bigint NOT NULL
);


--
-- Name: games_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE games_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE games_id_seq OWNED BY games.id;


--
-- Name: rolls; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE rolls (
    id bigint NOT NULL,
    frame_id bigint NOT NULL,
    pins integer NOT NULL
);


--
-- Name: rolls_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rolls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rolls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rolls_id_seq OWNED BY rolls.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id bigint NOT NULL,
    name character varying NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: frames id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY frames ALTER COLUMN id SET DEFAULT nextval('frames_id_seq'::regclass);


--
-- Name: game_frames id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY game_frames ALTER COLUMN id SET DEFAULT nextval('game_frames_id_seq'::regclass);


--
-- Name: games id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY games ALTER COLUMN id SET DEFAULT nextval('games_id_seq'::regclass);


--
-- Name: rolls id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rolls ALTER COLUMN id SET DEFAULT nextval('rolls_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: frames frames_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY frames
    ADD CONSTRAINT frames_pkey PRIMARY KEY (id);


--
-- Name: game_frames game_frames_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY game_frames
    ADD CONSTRAINT game_frames_pkey PRIMARY KEY (id);


--
-- Name: games games_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: rolls rolls_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rolls
    ADD CONSTRAINT rolls_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_frames_on_game_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_frames_on_game_id ON public.frames USING btree (game_id);


--
-- Name: index_game_frames_on_game_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_game_frames_on_game_id ON public.game_frames USING btree (game_id);


--
-- Name: index_game_frames_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_game_frames_on_user_id ON public.game_frames USING btree (user_id);


--
-- Name: index_rolls_on_frame_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rolls_on_frame_id ON public.rolls USING btree (frame_id);


--
-- Name: game_frames fk_rails_467e754d69; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY game_frames
    ADD CONSTRAINT fk_rails_467e754d69 FOREIGN KEY (game_id) REFERENCES games(id);


--
-- Name: game_frames fk_rails_7f1664d866; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY game_frames
    ADD CONSTRAINT fk_rails_7f1664d866 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: frames fk_rails_ee0b37ac02; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY frames
    ADD CONSTRAINT fk_rails_ee0b37ac02 FOREIGN KEY (game_id) REFERENCES games(id);


--
-- Name: rolls fk_rails_f09717ac94; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rolls
    ADD CONSTRAINT fk_rails_f09717ac94 FOREIGN KEY (frame_id) REFERENCES frames(id);


--
-- Name: frames fk_rails_f7c268f9a4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY frames
    ADD CONSTRAINT fk_rails_f7c268f9a4 FOREIGN KEY (next_frame_id) REFERENCES frames(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20181025105605'),
('20181025115523'),
('20181025120537'),
('20181025132101'),
('20181025144610'),
('20181026123616'),
('20181026124152');


