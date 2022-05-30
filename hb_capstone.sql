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
    voting_style character varying,
    description character varying,
    winner integer,
    completed boolean,
    admin_id integer
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
    email character varying,
    chat_color character varying,
    chat_bg_color character varying
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
1	vgame	Life is Strange	2
2	vgame	Fallout 2	2
3	vgame	Kyrandia hand of fate	2
4	vgame	Dune-ii	2
5	vgame	legend of the red dragon	2
6	boardgame	Concordia	1
7	boardgame	Stone age	1
8	boardgame	Viticulture: Essential Edition	1
9	boardgame	Spartacus: A Game of Blood and Treachery	1
10	boardgame	Machi Koro	1
11	movie	Gattaca	3
12	movie	Clerks	3
13	movie	Your Name	3
14	movie	Before Sunset	6
15	movie	Before Sunrise	6
16	movie	Chasing Amy	6
17	movie	Gattaca	6
18	vgame	Monkey Island 2: LeChuck's Revenge	5
19	vgame	Legend of Kyrandia: Hand of Fate, The (Book Two)	5
20	vgame	MechWarrior 2: Mercenaries	5
21	vgame	Wing Commander: Privateer	5
22	vgame	Fallout 2	5
23	boardgame	Scoville	\N
24	boardgame	Five Tribes	\N
25	boardgame	Lords of Waterdeep	\N
26	boardgame	Scythe	\N
27	boardgame	Scoville	\N
28	boardgame	Five Tribes	\N
29	boardgame	Scythe: Invaders from Afar	\N
30	boardgame	Five Tribes	\N
31	boardgame	Lords of Waterdeep	\N
32	boardgame	Great Western Trail	\N
33	boardgame	Scoville: Labs	\N
34	boardgame	Mage Knight	\N
35	boardgame	Modern Art	\N
36	boardgame	Scoville	\N
37	boardgame	Five Tribes	\N
38	boardgame	Scoville: Labs	\N
39	boardgame	Firefly: The Game	\N
40	boardgame	Yahtzee	\N
41	movie	Clerks II	\N
42	movie	Clerks	\N
43	movie	Clerks III	\N
44	movie	Snowball Effect: The Story of Clerks	\N
45	boardgame	Five Tribes	\N
46	boardgame	Five Tribes: Galbells	\N
50	movie	Captain Marvel	\N
51	movie	Marvel One-Shot: Agent Carter	\N
52	movie	Marvel Rising: Secret Warriors	\N
53	movie	Marvel Rising: Battle of the Bands	\N
47	tv	Chuck	\N
48	tv	The Adventures of Chuck and Friends	\N
49	movie	Manchester by the Sea	\N
54	vgame	Resident Evil 5	19
55	vgame	Resident Evil 4	19
56	vgame	Resident Evil 2	19
57	vgame	Resident Evil: Village	19
59	vgame	Tomb Raider (2013)	19
60	vgame	Resident Evil 3	19
62	tv	Chuck	21
63	tv	Community	21
64	tv	Reaper	21
65	tv	Corporate	21
66	tv	What We Do in the Shadows	21
67	tv	Video Game High School	21
68	tv	The Good Place	21
69	tv	Superstore	21
70	boardgame	Res Arcana	22
71	boardgame	Concordia	22
73	boardgame	Lords of Waterdeep	22
74	boardgame	Viticulture: Essential Edition	22
75	boardgame	Five Tribes	22
76	boardgame	Stone Age	22
79	boardgame	Spartacus: A Game of Blood and Treachery	22
80	boardgame	The Castles of Burgundy	22
81	boardgame	Cyclades	22
82	boardgame	Android: Netrunner	22
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: echo
--

COPY public.events (event_id, room_code, voting_style, description, winner, completed, admin_id) FROM stdin;
1	h0rl	fptp	pick a boardgame!	\N	f	3
2	o9jp	fptp	which video game?	\N	f	1
3	9wuu	fptp	what we watchin?	\N	f	5
6	5u8s	fptp	FPTP test room	\N	f	2
5	n15n	random	Shan's Random Room Test	19	t	6
19	6ejh	fptp	new fp test	\N	f	6
21	rulp	random	Random TV poll	\N	f	6
22	bfk4	fptp	Weekend Boardgame	\N	f	2
\.


--
-- Data for Name: user_events; Type: TABLE DATA; Schema: public; Owner: echo
--

COPY public.user_events (user_id, event_id) FROM stdin;
1	2
2	2
3	3
3	2
4	3
1	1
4	1
5	3
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: echo
--

COPY public.users (user_id, first_name, last_name, user_name, password, email, chat_color, chat_bg_color) FROM stdin;
1	korra	korra	avatar	$2b$12$6HwXvQb61ZO87kErQqhPZegNdFn6Im1ek0iurqeFHB7jv0bP/ZiQi	korra@test.com	#223CC1	#FFFFFF
4	chloe	price	chloe	$2b$12$gho2QB6CAfP8LGelYBAC9O4kO/UrXGY3yGozHKFR5OSFla6zWHTgK	chloe@arcadia.bay	#223CC1	#FFFFFF
5	rachel	amber	rachel	$2b$12$CSNDumITwqlhsSXY10RBue9T1HD3kT/hiHDC2.4aKwB2.5eS2fTNG	rachel@blackwell.edu	#223CC1	#FFFFFF
6	shanny	bunny	shan	$2b$12$RQdEG5u9P.RJ1wtVXP6OMOkjHlRCIn4Oyk1iNCukopaOi.CHx7GRG	shanny@bunny.com	#ee72a3	#121111
3	max	caulfield	max	$2b$12$C/1Kej5D2yu5RDk4wm4HbucDiVVlMW16vLe/c4Dwxc7CGJmteVxwG	max@blackwell.edu	#e1e6a3	#c062bd
2	asami	sato	korrasami	$2b$12$IEzNQtmHg2exFSPjAlRUU.C0kV7wLi7a.nHV.Pf/wGhaUWjoWbPZW	asami@test.com	#000000	#ffb5b5
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
9	1	2	14
10	1	6	16
11	1	6	17
12	1	6	17
13	1	6	59
14	1	3	56
15	1	6	56
16	1	6	54
17	1	6	54
18	1	6	59
19	1	6	59
20	1	6	59
21	1	3	56
22	1	6	57
23	1	3	55
24	1	3	55
25	1	3	55
26	1	6	60
27	1	6	60
28	1	3	55
29	1	6	79
30	1	6	79
31	1	6	79
32	1	6	79
33	1	6	79
34	1	6	79
35	1	6	79
36	1	6	79
37	1	6	79
38	1	2	71
39	1	2	71
40	1	2	71
41	1	2	71
42	1	2	71
43	1	2	71
44	1	2	71
45	1	2	71
46	1	2	71
47	1	2	73
48	1	2	73
49	1	2	73
50	1	2	73
51	1	2	73
52	1	2	73
53	1	2	73
54	1	6	74
55	1	6	74
56	1	6	74
57	1	6	74
58	1	6	74
59	1	6	74
60	1	6	74
61	1	6	74
62	1	2	76
63	1	2	76
64	1	2	76
65	1	2	76
66	1	2	76
67	1	6	70
68	1	6	70
69	1	6	70
70	1	6	70
71	1	6	70
72	1	6	70
73	1	6	70
74	1	6	70
75	1	2	80
76	1	2	80
77	1	2	80
78	1	2	80
79	1	6	75
80	1	6	75
81	1	6	75
82	1	6	75
83	1	2	81
\.


--
-- Name: choices_choice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: echo
--

SELECT pg_catalog.setval('public.choices_choice_id_seq', 82, true);


--
-- Name: events_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: echo
--

SELECT pg_catalog.setval('public.events_event_id_seq', 22, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: echo
--

SELECT pg_catalog.setval('public.users_user_id_seq', 6, true);


--
-- Name: votes_vote_id_seq; Type: SEQUENCE SET; Schema: public; Owner: echo
--

SELECT pg_catalog.setval('public.votes_vote_id_seq', 83, true);


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
-- Name: events events_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: echo
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.users(user_id);


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

