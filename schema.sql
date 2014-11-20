--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: add_role(integer, text); Type: FUNCTION; Schema: public; Owner: simon
--

CREATE FUNCTION add_role(integer, text) RETURNS text[]
    LANGUAGE sql
    AS $_$

update member set roles = roles || text($2) where id = $1
returning roles;

$_$;


ALTER FUNCTION public.add_role(integer, text) OWNER TO simon;

--
-- Name: remove_role(integer, text); Type: FUNCTION; Schema: public; Owner: simon
--

CREATE FUNCTION remove_role(integer, text) RETURNS text[]
    LANGUAGE sql
    AS $_$

update member set roles = array_remove(roles, text($2)) where id = $1
returning roles;

$_$;


ALTER FUNCTION public.remove_role(integer, text) OWNER TO simon;

--
-- Name: update_wallet_balance(); Type: FUNCTION; Schema: public; Owner: simon
--

CREATE FUNCTION update_wallet_balance() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
update wallet set balance = balance + NEW.income - NEW.expense
where id = NEW.dst_wallet_id;
update wallet set balance = balance - NEW.income + NEW.expense
where id = NEW.src_wallet_id;
return NEW;
END;$$;


ALTER FUNCTION public.update_wallet_balance() OWNER TO simon;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: alliance; Type: TABLE; Schema: public; Owner: simon; Tablespace: 
--

CREATE TABLE alliance (
    id integer NOT NULL,
    name text NOT NULL,
    type text,
    created timestamp without time zone DEFAULT now()
);


ALTER TABLE public.alliance OWNER TO simon;

--
-- Name: alliance_id_seq; Type: SEQUENCE; Schema: public; Owner: simon
--

CREATE SEQUENCE alliance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.alliance_id_seq OWNER TO simon;

--
-- Name: alliance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: simon
--

ALTER SEQUENCE alliance_id_seq OWNED BY alliance.id;


--
-- Name: alliance_store; Type: TABLE; Schema: public; Owner: simon; Tablespace: 
--

CREATE TABLE alliance_store (
    id integer NOT NULL,
    alliance_id integer NOT NULL,
    key text NOT NULL,
    value text,
    created timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.alliance_store OWNER TO simon;

--
-- Name: alliance_store_id_seq; Type: SEQUENCE; Schema: public; Owner: simon
--

CREATE SEQUENCE alliance_store_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.alliance_store_id_seq OWNER TO simon;

--
-- Name: alliance_store_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: simon
--

ALTER SEQUENCE alliance_store_id_seq OWNED BY alliance_store.id;


--
-- Name: analytics; Type: TABLE; Schema: public; Owner: simon; Tablespace: 
--

CREATE TABLE analytics (
    id integer NOT NULL,
    member_id integer,
    path text,
    event text,
    created timestamp without time zone DEFAULT now()
);


ALTER TABLE public.analytics OWNER TO simon;

--
-- Name: TABLE analytics; Type: COMMENT; Schema: public; Owner: simon
--

COMMENT ON TABLE analytics IS 'No foreign key on this table, as member deletion should not cascade to analytics records.';


--
-- Name: analytics_id_seq; Type: SEQUENCE; Schema: public; Owner: simon
--

CREATE SEQUENCE analytics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.analytics_id_seq OWNER TO simon;

--
-- Name: analytics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: simon
--

ALTER SEQUENCE analytics_id_seq OWNED BY analytics.id;


--
-- Name: badge; Type: TABLE; Schema: public; Owner: simon; Tablespace: 
--

CREATE TABLE badge (
    id integer NOT NULL,
    member_id integer NOT NULL,
    name text NOT NULL,
    description text,
    created timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.badge OWNER TO simon;

--
-- Name: badge_id_seq; Type: SEQUENCE; Schema: public; Owner: simon
--

CREATE SEQUENCE badge_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.badge_id_seq OWNER TO simon;

--
-- Name: badge_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: simon
--

ALTER SEQUENCE badge_id_seq OWNED BY badge.id;


--
-- Name: clan; Type: TABLE; Schema: public; Owner: simon; Tablespace: 
--

CREATE TABLE clan (
    id integer NOT NULL,
    name character varying(256) NOT NULL,
    type character varying(32),
    created timestamp without time zone DEFAULT now() NOT NULL,
    alliance_id integer
);


ALTER TABLE public.clan OWNER TO simon;

--
-- Name: clan_id_seq; Type: SEQUENCE; Schema: public; Owner: simon
--

CREATE SEQUENCE clan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clan_id_seq OWNER TO simon;

--
-- Name: clan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: simon
--

ALTER SEQUENCE clan_id_seq OWNED BY clan.id;


--
-- Name: clan_store; Type: TABLE; Schema: public; Owner: simon; Tablespace: 
--

CREATE TABLE clan_store (
    id integer NOT NULL,
    clan_id integer NOT NULL,
    key text NOT NULL,
    value text,
    created timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.clan_store OWNER TO simon;

--
-- Name: clan_store_id_seq; Type: SEQUENCE; Schema: public; Owner: simon
--

CREATE SEQUENCE clan_store_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clan_store_id_seq OWNER TO simon;

--
-- Name: clan_store_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: simon
--

ALTER SEQUENCE clan_store_id_seq OWNED BY clan_store.id;


--
-- Name: contact; Type: TABLE; Schema: public; Owner: simon; Tablespace: 
--

CREATE TABLE contact (
    id integer NOT NULL,
    owner_id integer NOT NULL,
    member_id integer NOT NULL,
    type character varying(16),
    created timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.contact OWNER TO simon;

--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: simon
--

CREATE SEQUENCE contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contacts_id_seq OWNER TO simon;

--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: simon
--

ALTER SEQUENCE contacts_id_seq OWNED BY contact.id;


--
-- Name: currency; Type: TABLE; Schema: public; Owner: simon; Tablespace: 
--

CREATE TABLE currency (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.currency OWNER TO simon;

--
-- Name: currency_id_seq; Type: SEQUENCE; Schema: public; Owner: simon
--

CREATE SEQUENCE currency_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.currency_id_seq OWNER TO simon;

--
-- Name: currency_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: simon
--

ALTER SEQUENCE currency_id_seq OWNED BY currency.id;


--
-- Name: inbox; Type: TABLE; Schema: public; Owner: simon; Tablespace: 
--

CREATE TABLE inbox (
    id integer NOT NULL,
    member_id integer NOT NULL,
    from_member_id integer,
    type character varying(32),
    body text NOT NULL,
    read boolean DEFAULT false NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.inbox OWNER TO simon;

--
-- Name: inbox_id_seq; Type: SEQUENCE; Schema: public; Owner: simon
--

CREATE SEQUENCE inbox_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inbox_id_seq OWNER TO simon;

--
-- Name: inbox_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: simon
--

ALTER SEQUENCE inbox_id_seq OWNED BY inbox.id;


--
-- Name: journal; Type: TABLE; Schema: public; Owner: simon; Tablespace: 
--

CREATE TABLE journal (
    id integer NOT NULL,
    src_wallet_id integer NOT NULL,
    dst_wallet_id integer,
    income double precision NOT NULL,
    tx_id integer NOT NULL,
    created timestamp without time zone DEFAULT now(),
    expense double precision NOT NULL
);


ALTER TABLE public.journal OWNER TO simon;

--
-- Name: journal_id_seq; Type: SEQUENCE; Schema: public; Owner: simon
--

CREATE SEQUENCE journal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.journal_id_seq OWNER TO simon;

--
-- Name: journal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: simon
--

ALTER SEQUENCE journal_id_seq OWNED BY journal.id;


--
-- Name: mailqueue; Type: TABLE; Schema: public; Owner: simon; Tablespace: 
--

CREATE TABLE mailqueue (
    id integer NOT NULL,
    member_id integer,
    address character varying(256) NOT NULL,
    subject character varying(256),
    body text,
    sent boolean DEFAULT false NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    error boolean DEFAULT false NOT NULL
);


ALTER TABLE public.mailqueue OWNER TO simon;

--
-- Name: mailqueue_id_seq; Type: SEQUENCE; Schema: public; Owner: simon
--

CREATE SEQUENCE mailqueue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mailqueue_id_seq OWNER TO simon;

--
-- Name: mailqueue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: simon
--

ALTER SEQUENCE mailqueue_id_seq OWNED BY mailqueue.id;


--
-- Name: member; Type: TABLE; Schema: public; Owner: simon; Tablespace: 
--

CREATE TABLE member (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(256) NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    handle character varying(255) NOT NULL,
    clan_id integer,
    roles text[] DEFAULT '{}'::text[] NOT NULL
);


ALTER TABLE public.member OWNER TO simon;

--
-- Name: member_id_seq; Type: SEQUENCE; Schema: public; Owner: simon
--

CREATE SEQUENCE member_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.member_id_seq OWNER TO simon;

--
-- Name: member_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: simon
--

ALTER SEQUENCE member_id_seq OWNED BY member.id;


--
-- Name: member_store; Type: TABLE; Schema: public; Owner: simon; Tablespace: 
--

CREATE TABLE member_store (
    id integer NOT NULL,
    member_id integer NOT NULL,
    key text NOT NULL,
    value text,
    created timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.member_store OWNER TO simon;

--
-- Name: member_store_id_seq; Type: SEQUENCE; Schema: public; Owner: simon
--

CREATE SEQUENCE member_store_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.member_store_id_seq OWNER TO simon;

--
-- Name: member_store_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: simon
--

ALTER SEQUENCE member_store_id_seq OWNED BY member_store.id;


--
-- Name: object; Type: TABLE; Schema: public; Owner: simon; Tablespace: 
--

CREATE TABLE object (
    id integer NOT NULL,
    member_id integer NOT NULL,
    key character varying(255) NOT NULL,
    value text,
    created timestamp without time zone DEFAULT now(),
    clan_id integer,
    alliance_id integer
);


ALTER TABLE public.object OWNER TO simon;

--
-- Name: object_id_seq; Type: SEQUENCE; Schema: public; Owner: simon
--

CREATE SEQUENCE object_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.object_id_seq OWNER TO simon;

--
-- Name: object_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: simon
--

ALTER SEQUENCE object_id_seq OWNED BY object.id;


--
-- Name: password_reset_request; Type: TABLE; Schema: public; Owner: simon; Tablespace: 
--

CREATE TABLE password_reset_request (
    id integer NOT NULL,
    member_id integer NOT NULL,
    token character varying(8) NOT NULL,
    expires timestamp without time zone DEFAULT (now() + '24:00:00'::interval) NOT NULL
);


ALTER TABLE public.password_reset_request OWNER TO simon;

--
-- Name: password_reset_request_id_seq; Type: SEQUENCE; Schema: public; Owner: simon
--

CREATE SEQUENCE password_reset_request_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.password_reset_request_id_seq OWNER TO simon;

--
-- Name: password_reset_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: simon
--

ALTER SEQUENCE password_reset_request_id_seq OWNED BY password_reset_request.id;


--
-- Name: wallet; Type: TABLE; Schema: public; Owner: simon; Tablespace: 
--

CREATE TABLE wallet (
    id integer NOT NULL,
    member_id integer,
    currency_id integer NOT NULL,
    balance double precision DEFAULT 0 NOT NULL,
    name text
);


ALTER TABLE public.wallet OWNER TO simon;

--
-- Name: wallet_id_seq; Type: SEQUENCE; Schema: public; Owner: simon
--

CREATE SEQUENCE wallet_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wallet_id_seq OWNER TO simon;

--
-- Name: wallet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: simon
--

ALTER SEQUENCE wallet_id_seq OWNED BY wallet.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: simon
--

ALTER TABLE ONLY alliance ALTER COLUMN id SET DEFAULT nextval('alliance_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: simon
--

ALTER TABLE ONLY alliance_store ALTER COLUMN id SET DEFAULT nextval('alliance_store_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: simon
--

ALTER TABLE ONLY analytics ALTER COLUMN id SET DEFAULT nextval('analytics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: simon
--

ALTER TABLE ONLY badge ALTER COLUMN id SET DEFAULT nextval('badge_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: simon
--

ALTER TABLE ONLY clan ALTER COLUMN id SET DEFAULT nextval('clan_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: simon
--

ALTER TABLE ONLY clan_store ALTER COLUMN id SET DEFAULT nextval('clan_store_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: simon
--

ALTER TABLE ONLY contact ALTER COLUMN id SET DEFAULT nextval('contacts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: simon
--

ALTER TABLE ONLY currency ALTER COLUMN id SET DEFAULT nextval('currency_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: simon
--

ALTER TABLE ONLY inbox ALTER COLUMN id SET DEFAULT nextval('inbox_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: simon
--

ALTER TABLE ONLY journal ALTER COLUMN id SET DEFAULT nextval('journal_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: simon
--

ALTER TABLE ONLY mailqueue ALTER COLUMN id SET DEFAULT nextval('mailqueue_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: simon
--

ALTER TABLE ONLY member ALTER COLUMN id SET DEFAULT nextval('member_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: simon
--

ALTER TABLE ONLY member_store ALTER COLUMN id SET DEFAULT nextval('member_store_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: simon
--

ALTER TABLE ONLY object ALTER COLUMN id SET DEFAULT nextval('object_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: simon
--

ALTER TABLE ONLY password_reset_request ALTER COLUMN id SET DEFAULT nextval('password_reset_request_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: simon
--

ALTER TABLE ONLY wallet ALTER COLUMN id SET DEFAULT nextval('wallet_id_seq'::regclass);


--
-- Name: alliance_pkey; Type: CONSTRAINT; Schema: public; Owner: simon; Tablespace: 
--

ALTER TABLE ONLY alliance
    ADD CONSTRAINT alliance_pkey PRIMARY KEY (id);


--
-- Name: alliance_store_pkey; Type: CONSTRAINT; Schema: public; Owner: simon; Tablespace: 
--

ALTER TABLE ONLY alliance_store
    ADD CONSTRAINT alliance_store_pkey PRIMARY KEY (id);


--
-- Name: analytics_pkey; Type: CONSTRAINT; Schema: public; Owner: simon; Tablespace: 
--

ALTER TABLE ONLY analytics
    ADD CONSTRAINT analytics_pkey PRIMARY KEY (id);


--
-- Name: badge_pkey; Type: CONSTRAINT; Schema: public; Owner: simon; Tablespace: 
--

ALTER TABLE ONLY badge
    ADD CONSTRAINT badge_pkey PRIMARY KEY (id);


--
-- Name: clan_pkey; Type: CONSTRAINT; Schema: public; Owner: simon; Tablespace: 
--

ALTER TABLE ONLY clan
    ADD CONSTRAINT clan_pkey PRIMARY KEY (id);


--
-- Name: clan_store_pkey; Type: CONSTRAINT; Schema: public; Owner: simon; Tablespace: 
--

ALTER TABLE ONLY clan_store
    ADD CONSTRAINT clan_store_pkey PRIMARY KEY (id);


--
-- Name: contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: simon; Tablespace: 
--

ALTER TABLE ONLY contact
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: currency_name_key; Type: CONSTRAINT; Schema: public; Owner: simon; Tablespace: 
--

ALTER TABLE ONLY currency
    ADD CONSTRAINT currency_name_key UNIQUE (name);


--
-- Name: currency_pkey; Type: CONSTRAINT; Schema: public; Owner: simon; Tablespace: 
--

ALTER TABLE ONLY currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (id);


--
-- Name: inbox_pkey; Type: CONSTRAINT; Schema: public; Owner: simon; Tablespace: 
--

ALTER TABLE ONLY inbox
    ADD CONSTRAINT inbox_pkey PRIMARY KEY (id);


--
-- Name: journal_pkey; Type: CONSTRAINT; Schema: public; Owner: simon; Tablespace: 
--

ALTER TABLE ONLY journal
    ADD CONSTRAINT journal_pkey PRIMARY KEY (id);


--
-- Name: mailqueue_pkey; Type: CONSTRAINT; Schema: public; Owner: simon; Tablespace: 
--

ALTER TABLE ONLY mailqueue
    ADD CONSTRAINT mailqueue_pkey PRIMARY KEY (id);


--
-- Name: member_pkey; Type: CONSTRAINT; Schema: public; Owner: simon; Tablespace: 
--

ALTER TABLE ONLY member
    ADD CONSTRAINT member_pkey PRIMARY KEY (id);


--
-- Name: member_store_pkey; Type: CONSTRAINT; Schema: public; Owner: simon; Tablespace: 
--

ALTER TABLE ONLY member_store
    ADD CONSTRAINT member_store_pkey PRIMARY KEY (id);


--
-- Name: objects_pkey; Type: CONSTRAINT; Schema: public; Owner: simon; Tablespace: 
--

ALTER TABLE ONLY object
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: password_reset_request_pkey; Type: CONSTRAINT; Schema: public; Owner: simon; Tablespace: 
--

ALTER TABLE ONLY password_reset_request
    ADD CONSTRAINT password_reset_request_pkey PRIMARY KEY (id);


--
-- Name: wallet_pkey; Type: CONSTRAINT; Schema: public; Owner: simon; Tablespace: 
--

ALTER TABLE ONLY wallet
    ADD CONSTRAINT wallet_pkey PRIMARY KEY (id);


--
-- Name: alliance_id_key; Type: INDEX; Schema: public; Owner: simon; Tablespace: 
--

CREATE UNIQUE INDEX alliance_id_key ON alliance USING btree (id);


--
-- Name: alliance_lower_idx; Type: INDEX; Schema: public; Owner: simon; Tablespace: 
--

CREATE UNIQUE INDEX alliance_lower_idx ON alliance USING btree (lower(name));


--
-- Name: alliance_store_alliance_id_key_idx; Type: INDEX; Schema: public; Owner: simon; Tablespace: 
--

CREATE UNIQUE INDEX alliance_store_alliance_id_key_idx ON alliance_store USING btree (alliance_id, key);


--
-- Name: clan_id_key; Type: INDEX; Schema: public; Owner: simon; Tablespace: 
--

CREATE UNIQUE INDEX clan_id_key ON clan USING btree (id);


--
-- Name: clan_lower_idx; Type: INDEX; Schema: public; Owner: simon; Tablespace: 
--

CREATE UNIQUE INDEX clan_lower_idx ON clan USING btree (lower((name)::text));


--
-- Name: clan_store_clan_id_key_idx; Type: INDEX; Schema: public; Owner: simon; Tablespace: 
--

CREATE UNIQUE INDEX clan_store_clan_id_key_idx ON clan_store USING btree (clan_id, key);


--
-- Name: currency_id_key; Type: INDEX; Schema: public; Owner: simon; Tablespace: 
--

CREATE UNIQUE INDEX currency_id_key ON currency USING btree (id);


--
-- Name: member_email_key; Type: INDEX; Schema: public; Owner: simon; Tablespace: 
--

CREATE UNIQUE INDEX member_email_key ON member USING btree (lower((email)::text));


--
-- Name: member_handle_key; Type: INDEX; Schema: public; Owner: simon; Tablespace: 
--

CREATE UNIQUE INDEX member_handle_key ON member USING btree (lower((handle)::text));


--
-- Name: member_id_key; Type: INDEX; Schema: public; Owner: simon; Tablespace: 
--

CREATE UNIQUE INDEX member_id_key ON member USING btree (id);


--
-- Name: member_store_member_id_key_idx; Type: INDEX; Schema: public; Owner: simon; Tablespace: 
--

CREATE UNIQUE INDEX member_store_member_id_key_idx ON member_store USING btree (member_id, key);


--
-- Name: wallet_id_key; Type: INDEX; Schema: public; Owner: simon; Tablespace: 
--

CREATE UNIQUE INDEX wallet_id_key ON wallet USING btree (id);


--
-- Name: update_wallet_balance; Type: TRIGGER; Schema: public; Owner: simon
--

CREATE TRIGGER update_wallet_balance AFTER INSERT ON journal FOR EACH ROW EXECUTE PROCEDURE update_wallet_balance();


--
-- Name: alliance_store_alliance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: simon
--

ALTER TABLE ONLY alliance_store
    ADD CONSTRAINT alliance_store_alliance_id_fkey FOREIGN KEY (alliance_id) REFERENCES alliance(id);


--
-- Name: badge_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: simon
--

ALTER TABLE ONLY badge
    ADD CONSTRAINT badge_member_id_fkey FOREIGN KEY (member_id) REFERENCES member(id) ON DELETE CASCADE;


--
-- Name: clan_alliance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: simon
--

ALTER TABLE ONLY clan
    ADD CONSTRAINT clan_alliance_id_fkey FOREIGN KEY (alliance_id) REFERENCES alliance(id) ON DELETE SET NULL;


--
-- Name: clan_store_clan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: simon
--

ALTER TABLE ONLY clan_store
    ADD CONSTRAINT clan_store_clan_id_fkey FOREIGN KEY (clan_id) REFERENCES clan(id);


--
-- Name: contacts_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: simon
--

ALTER TABLE ONLY contact
    ADD CONSTRAINT contacts_member_id_fkey FOREIGN KEY (member_id) REFERENCES member(id);


--
-- Name: contacts_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: simon
--

ALTER TABLE ONLY contact
    ADD CONSTRAINT contacts_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES member(id);


--
-- Name: inbox_from_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: simon
--

ALTER TABLE ONLY inbox
    ADD CONSTRAINT inbox_from_member_id_fkey FOREIGN KEY (from_member_id) REFERENCES member(id) ON DELETE SET NULL;


--
-- Name: inbox_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: simon
--

ALTER TABLE ONLY inbox
    ADD CONSTRAINT inbox_member_id_fkey FOREIGN KEY (member_id) REFERENCES member(id) ON DELETE CASCADE;


--
-- Name: journal_from_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: simon
--

ALTER TABLE ONLY journal
    ADD CONSTRAINT journal_from_wallet_id_fkey FOREIGN KEY (src_wallet_id) REFERENCES wallet(id) ON DELETE CASCADE;


--
-- Name: journal_to_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: simon
--

ALTER TABLE ONLY journal
    ADD CONSTRAINT journal_to_wallet_id_fkey FOREIGN KEY (dst_wallet_id) REFERENCES wallet(id) ON DELETE CASCADE;


--
-- Name: mailqueue_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: simon
--

ALTER TABLE ONLY mailqueue
    ADD CONSTRAINT mailqueue_member_id_fkey FOREIGN KEY (member_id) REFERENCES member(id) ON DELETE CASCADE;


--
-- Name: member_clan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: simon
--

ALTER TABLE ONLY member
    ADD CONSTRAINT member_clan_id_fkey FOREIGN KEY (clan_id) REFERENCES clan(id) ON DELETE SET NULL;


--
-- Name: member_store_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: simon
--

ALTER TABLE ONLY member_store
    ADD CONSTRAINT member_store_member_id_fkey FOREIGN KEY (member_id) REFERENCES member(id);


--
-- Name: object_alliance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: simon
--

ALTER TABLE ONLY object
    ADD CONSTRAINT object_alliance_id_fkey FOREIGN KEY (alliance_id) REFERENCES alliance(id) ON DELETE CASCADE;


--
-- Name: object_clan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: simon
--

ALTER TABLE ONLY object
    ADD CONSTRAINT object_clan_id_fkey FOREIGN KEY (clan_id) REFERENCES clan(id) ON DELETE CASCADE;


--
-- Name: object_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: simon
--

ALTER TABLE ONLY object
    ADD CONSTRAINT object_member_id_fkey FOREIGN KEY (member_id) REFERENCES member(id) ON DELETE CASCADE;


--
-- Name: password_reset_request_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: simon
--

ALTER TABLE ONLY password_reset_request
    ADD CONSTRAINT password_reset_request_member_id_fkey FOREIGN KEY (member_id) REFERENCES member(id) ON DELETE CASCADE;


--
-- Name: wallet_currency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: simon
--

ALTER TABLE ONLY wallet
    ADD CONSTRAINT wallet_currency_id_fkey FOREIGN KEY (currency_id) REFERENCES currency(id) ON DELETE CASCADE;


--
-- Name: wallet_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: simon
--

ALTER TABLE ONLY wallet
    ADD CONSTRAINT wallet_member_id_fkey FOREIGN KEY (member_id) REFERENCES member(id) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

