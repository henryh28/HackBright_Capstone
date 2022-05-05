--
-- PostgreSQL database dump
--

-- Dumped from database version 13.6 (Ubuntu 13.6-1.pgdg20.04+1)
-- Dumped by pg_dump version 13.6 (Ubuntu 13.6-1.pgdg20.04+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: choices; Type: TABLE; Schema: public; Owner: echo
--

CREATE TABLE public.choices (
    choice_id integer NOT NULL,
    type character varying,
    title character varying,
    event_id integer
);


ALTER TABLE public.choices OWNER TO echo;

--
-- Name: choices_choice_id_seq; Type: SEQUENCE; Schema: public; Owner: echo
--

CREATE SEQUENCE public.choices_choice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.choices_choice_id_seq OWNER TO echo;

--
-- Name: choices_choice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: echo
--

ALTER SEQUENCE public.choices_choice_id_seq OWNED BY public.choices.choice_id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: echo
--

CREATE TABLE public.events (
    event_id integer NOT NULL,
    room_code character varying,
    description character varying
);


ALTER TABLE public.events OWNER TO echo;

--
-- Name: events_event_id_seq; Type: SEQUENCE; Schema: public; Owner: echo
--

CREATE SEQUENCE public.events_event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_event_id_seq OWNER TO echo;

--
-- Name: events_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: echo
--

ALTER SEQUENCE public.events_event_id_seq OWNED BY public.events.event_id;


--
-- Name: user_events; Type: TABLE; Schema: public; Owner: echo
--

CREATE TABLE public.user_events (
    user_id integer,
    event_id integer
);


ALTER TABLE public.user_events OWNER TO echo;

--
-- Name: users; Type: TABLE; Schema: public; Owner: echo
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    first_name character varying,
    last_name character varying,
    user_name character varying,
    password character varying,
    email character varying
);


ALTER TABLE public.users OWNER TO echo;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: echo
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO echo;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: echo
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: votes; Type: TABLE; Schema: public; Owner: echo
--

CREATE TABLE public.votes (
    vote_id integer NOT NULL,
    amount integer,
    user_id integer,
    choice_id integer
);


ALTER TABLE public.votes OWNER TO echo;

--
-- Name: votes_vote_id_seq; Type: SEQUENCE; Schema: public; Owner: echo
--

CREATE SEQUENCE public.votes_vote_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.votes_vote_id_seq OWNER TO echo;

--
-- Name: votes_vote_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: echo
--

ALTER SEQUENCE public.votes_vote_id_seq OWNED BY public.votes.vote_id;


--
-- Name: choices choice_id; Type: DEFAULT; Schema: public; Owner: echo
--

ALTER TABLE ONLY public.choices ALTER COLUMN choice_id SET DEFAULT nextval('public.choices_choice_id_seq'::regclass);


--
-- Name: events event_id; Type: DEFAULT; Schema: public; Owner: echo
--

ALTER TABLE ONLY public.events ALTER COLUMN event_id SET DEFAULT nextval('public.events_event_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: echo
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Name: votes vote_id; Type: DEFAULT; Schema: public; Owner: echo
--

ALTER TABLE ONLY public.votes ALTER COLUMN vote_id SET DEFAULT nextval('public.votes_vote_id_seq'::regclass);


--
-- Data for Name: choices; Type: TABLE DATA; Schema: public; Owner: echo
--

COPY public.choices (choice_id, type, title, event_id) FROM stdin;
1	food	a mixed berry smoothie	2
2	food	a bowl of ramen	2
3	food	a sack of caramel-peanut butter candy corn	2
4	game	Concordia	1
5	game	Stoneage	1
6	game	Viticulture	1
7	game	Spartacus	1
8	game	Machi Koro	1
9	movie	Gattaca	3
10	movie	Clerks	3
11	movie	Your Name	3
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: echo
--

COPY public.events (event_id, room_code, description) FROM stdin;
1	5iy0	pick a game!
2	cwq0	What we gonna eat?
3	0671	what we watchin?
\.


--
-- Data for Name: user_events; Type: TABLE DATA; Schema: public; Owner: echo
--

COPY public.user_events (user_id, event_id) FROM stdin;
1	2
2	2
3	2
4	1
1	1
3	3
4	3
5	3
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: echo
--

COPY public.users (user_id, first_name, last_name, user_name, password, email) FROM stdin;
1	korra	korra	avatar	test	korra@test.com
2	asami	sato	korrasami	test	asami@test.com
3	max	caulfield	mad_max	test	max@blackwell.edu
4	chloe	price	captain_chloe	test	chloe@arcadia.bay
5	rachel	amber	rach	test	rachel@blackwell.edu
\.


--
-- Data for Name: votes; Type: TABLE DATA; Schema: public; Owner: echo
--

COPY public.votes (vote_id, amount, user_id, choice_id) FROM stdin;
1	1	4	7
2	1	1	8
3	1	3	9
4	1	4	10
5	1	5	10
6	1	1	3
7	1	2	1
8	1	3	1
\.


--
-- Name: choices_choice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: echo
--

SELECT pg_catalog.setval('public.choices_choice_id_seq', 11, true);


--
-- Name: events_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: echo
--

SELECT pg_catalog.setval('public.events_event_id_seq', 3, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: echo
--

SELECT pg_catalog.setval('public.users_user_id_seq', 5, true);


--
-- Name: votes_vote_id_seq; Type: SEQUENCE SET; Schema: public; Owner: echo
--

SELECT pg_catalog.setval('public.votes_vote_id_seq', 8, true);


--
-- Name: choices choices_pkey; Type: CONSTRAINT; Schema: public; Owner: echo
--

ALTER TABLE ONLY public.choices
    ADD CONSTRAINT choices_pkey PRIMARY KEY (choice_id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: echo
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (event_id);


--
-- Name: events events_room_code_key; Type: CONSTRAINT; Schema: public; Owner: echo
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_room_code_key UNIQUE (room_code);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: echo
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: echo
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users users_user_name_key; Type: CONSTRAINT; Schema: public; Owner: echo
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_user_name_key UNIQUE (user_name);


--
-- Name: votes votes_pkey; Type: CONSTRAINT; Schema: public; Owner: echo
--

ALTER TABLE ONLY public.votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (vote_id);


--
-- Name: choices choices_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: echo
--

ALTER TABLE ONLY public.choices
    ADD CONSTRAINT choices_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: user_events user_events_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: echo
--

ALTER TABLE ONLY public.user_events
    ADD CONSTRAINT user_events_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: user_events user_events_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: echo
--

ALTER TABLE ONLY public.user_events
    ADD CONSTRAINT user_events_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: votes votes_choice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: echo
--

ALTER TABLE ONLY public.votes
    ADD CONSTRAINT votes_choice_id_fkey FOREIGN KEY (choice_id) REFERENCES public.choices(choice_id);


--
-- Name: votes votes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: echo
--

ALTER TABLE ONLY public.votes
    ADD CONSTRAINT votes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- PostgreSQL database dump complete
--

