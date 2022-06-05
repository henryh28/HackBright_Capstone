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
    art character varying,
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

COPY public.choices (choice_id, type, title, art, event_id) FROM stdin;
1	vgame	Life is Strange		2
2	vgame	Fallout 2		2
3	vgame	Kyrandia hand of fate		2
4	vgame	Dune-ii		2
5	vgame	legend of the red dragon		2
6	boardgame	Concordia		1
7	boardgame	Stone age		1
8	boardgame	Viticulture: Essential Edition		1
9	boardgame	Spartacus: A Game of Blood and Treachery		1
10	boardgame	Machi Koro		1
11	movie	Gattaca		3
12	movie	Clerks		3
13	movie	Your Name		3
14	boardgame	Concordia	https://s3-us-west-1.amazonaws.com/5cc.images/games/uploaded/1629323022645.jpg	4
16	boardgame	Stone Age	https://s3-us-west-1.amazonaws.com/5cc.images/games/uploaded/1559254167104-512BzBFksXNL.jpg	4
18	boardgame	Splendor	https://s3-us-west-1.amazonaws.com/5cc.images/games/uploaded/1559254164722-51AHDwGznvL.jpg	4
19	boardgame	Viticulture	https://s3-us-west-1.amazonaws.com/5cc.images/games/uploaded/1545169920564	4
20	tv	Chuck	https://image.tmdb.org/t/p/original/ejV52ysoiVdXUJBOiNI9KTM36el.jpg	5
21	tv	Community	https://image.tmdb.org/t/p/original/3KUjDt8XY7w2Ku70UE0SECmv1zP.jpg	5
22	tv	What We Do in the Shadows	https://image.tmdb.org/t/p/original/sI9Ys1MYtwwCPewWyyvJcz0s89t.jpg	5
23	tv	Mythic Quest	https://image.tmdb.org/t/p/original/z5yMKsYccNG6CDvPFgfWOVavoc9.jpg	5
24	tv	Fleabag	https://image.tmdb.org/t/p/original/27vEYsRKa3eAniwmoccOoluEXQ1.jpg	5
25	tv	Firefly	https://image.tmdb.org/t/p/original/vZcKsy4sGAvWMVqLluwYuoi11Kj.jpg	5
26	movie	Gattaca	https://image.tmdb.org/t/p/original/eSKr5Fl1MEC7zpAXaLWBWSBjgJq.jpg	\N
27	movie	Chasing Amy	https://image.tmdb.org/t/p/original/eFhPqkNmRDfRHyQiUzUdoQjpwgh.jpg	\N
28	movie	The Last Samurai	https://image.tmdb.org/t/p/original/lsasOSgYI85EHygtT5SvcxtZVYT.jpg	\N
29	movie	Before Sunrise	https://image.tmdb.org/t/p/original/khKJwHxgXSpDl3iKGJ5S15I8ABI.jpg	\N
30	movie	Before Sunset	https://image.tmdb.org/t/p/original/gycdE1ARByGQcK4fYR2mgpU6OO.jpg	\N
32	movie	Anna and the Apocalypse	https://image.tmdb.org/t/p/original/pb60xSzUnS9D5iDvrV8N6QOG3ZR.jpg	\N
34	movie	Gattaca	https://image.tmdb.org/t/p/original/eSKr5Fl1MEC7zpAXaLWBWSBjgJq.jpg	7
36	movie	Before Sunset	https://image.tmdb.org/t/p/original/gycdE1ARByGQcK4fYR2mgpU6OO.jpg	7
37	movie	Before Sunrise	https://image.tmdb.org/t/p/original/khKJwHxgXSpDl3iKGJ5S15I8ABI.jpg	7
38	movie	Before Midnight	https://image.tmdb.org/t/p/original/6wTw6762kAVTkyQWoHRUuUiRpBp.jpg	7
39	movie	Gran Torino	https://image.tmdb.org/t/p/original/zUybYvxWdAJy5hhYovsXtHSWI1l.jpg	7
40	vgame	Divinity: Original Sin 2	https://media.rawg.io/media/games/424/424facd40f4eb1f2794fe4b4bb28a277.jpg	8
41	vgame	Tom Clancy's Rainbow Six Siege	https://media.rawg.io/media/games/b34/b3419c2706f8f8dbe40d08e23642ad06.jpg	8
42	vgame	7 Days to Die	https://media.rawg.io/media/games/5cb/5cbbc5cd24677331c85253f961cad72a.jpg	8
43	vgame	League of Legends	https://media.rawg.io/media/games/78b/78bc81e247fc7e77af700cbd632a9297.jpg	8
44	vgame	PAYDAY 2	https://media.rawg.io/media/games/73e/73eecb8909e0c39fb246f457b5d6cbbe.jpg	8
45	vgame	Monster Hunter Rise	https://media.rawg.io/media/games/dbb/dbba6100aae179b5f24052c9141d426d.jpg	8
46	vgame	Diablo: Immortal	https://media.rawg.io/media/games/2fd/2fdbdf312cb0507e4f0772631926dfbb.jpg	8
47	movie	John Wick	https://image.tmdb.org/t/p/original/fZPSd91yGE9fCcCe6OoQr6E3Bev.jpg	9
48	movie	Clerks II	https://image.tmdb.org/t/p/original/cLSW0nW94XT0DmBS69ublcLfQ9c.jpg	9
49	movie	Mayhem	https://image.tmdb.org/t/p/original/3M6SQXW3UsEtWGoBLQoqFBvLYP0.jpg	9
50	movie	50 First Dates	https://image.tmdb.org/t/p/original/5NxTW4SS6aUKZYnbQzh7UYNivd.jpg	9
51	movie	Shaun of the Dead	https://image.tmdb.org/t/p/original/dgXPhzNJH8HFTBjXPB177yNx6RI.jpg	9
54	boardgame	Corporate America Game	https://s3-us-west-1.amazonaws.com/5cc.images/games/uploaded/1559258073261-51Bz3jYBX8L.jpg	10
56	vgame	Life is Strange	https://media.rawg.io/media/games/562/562553814dd54e001a541e4ee83a591c.jpg	10
58	tv	Castlevania	https://image.tmdb.org/t/p/original/lqS90fU1IEHSbga7X6Gej5amBvR.jpg	10
59	movie	Anna and the Apocalypse	https://image.tmdb.org/t/p/original/pb60xSzUnS9D5iDvrV8N6QOG3ZR.jpg	10
60	movie	Jojo Rabbit	https://image.tmdb.org/t/p/original/7GsM4mtM0worCtIVeiQt28HieeN.jpg	10
61	boardgame	Wingspan	https://s3-us-west-1.amazonaws.com/5cc.images/games/uploaded/1629325193747.png	10
62	tv	Arcane	https://image.tmdb.org/t/p/original/ohGz4HDYGTite1GmRhRuBMVAn03.jpg	10
64	tv	The Legend of Korra	https://image.tmdb.org/t/p/original/nhP0VGO2GSZbL4PUgmA6Vja48aM.jpg	10
65	boardgame	Scoville	https://s3-us-west-1.amazonaws.com/5cc.images/games/uploaded/1541702883246	4
67	boardgame	Scoville	https://s3-us-west-1.amazonaws.com/5cc.images/games/uploaded/1541702883246	\N
68	boardgame	Five Tribes	https://s3-us-west-1.amazonaws.com/5cc.images/games/uploaded/1559254126853-611YVb5GCwL.jpg	\N
70	boardgame	Lords of Waterdeep	https://s3-us-west-1.amazonaws.com/5cc.images/games/uploaded/1629324168873.jpg	\N
71	boardgame	Scythe: Invaders from Afar	https://s3-us-west-1.amazonaws.com/5cc.images/games/uploaded/1610393424024	\N
72	boardgame	Scoville	https://s3-us-west-1.amazonaws.com/5cc.images/games/uploaded/1541702883246	\N
73	boardgame	Scoville	https://s3-us-west-1.amazonaws.com/5cc.images/games/uploaded/1541702883246	\N
74	boardgame	Scoville	https://s3-us-west-1.amazonaws.com/5cc.images/games/uploaded/1541702883246	\N
75	boardgame	Scoville	https://s3-us-west-1.amazonaws.com/5cc.images/games/uploaded/1541702883246	\N
76	boardgame	Scoville	https://s3-us-west-1.amazonaws.com/5cc.images/games/uploaded/1541702883246	\N
77	boardgame	Lords of Waterdeep	https://s3-us-west-1.amazonaws.com/5cc.images/games/uploaded/1629324168873.jpg	\N
82	boardgame	Lords of Waterdeep	https://s3-us-west-1.amazonaws.com/5cc.images/games/uploaded/1629324168873.jpg	4
88	tv	BoJack Horseman	https://image.tmdb.org/t/p/original/pB9L0jAnEQLMKgexqCEocEW8TA.jpg	5
93	vgame	Legend of Kyrandia, The (Book One)	https://media.rawg.io/media/games/542/542b3c366fc7c3decc928e22c49b8336.jpg	18
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: echo
--

COPY public.events (event_id, room_code, voting_style, description, winner, completed, admin_id) FROM stdin;
1	ga07	fptp	pick a boardgame!	\N	f	3
2	rldw	fptp	which video game?	\N	f	1
3	oqsk	fptp	what we watchin?	\N	f	5
4	lv58	fptp	Shan's Boardgame Party	\N	f	6
5	37zh	random	Shan's TV poll	\N	f	6
7	pkz4	random	Arthouse Movies	\N	f	2
8	1zw4	fptp	Co-op game options	\N	f	6
9	zyxo	fptp	Chloe's movie option (pick something!)	\N	f	4
10	nxpc	random	Random mixed options!	\N	f	6
18	zpy6	random	testing room	\N	f	6
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
4	1
1	1
5	3
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: echo
--

COPY public.users (user_id, first_name, last_name, user_name, password, email, chat_color, chat_bg_color) FROM stdin;
1	korra	korra	avatar	$2b$12$Nl2Rg1FoZ78IcKM.//mNWOfIXGd6foBJQ4Lf9h.sU1JuHh8eJGsyW	korra@test.com	#223CC1	#FFFFFF
5	rachel	amber	rachel	$2b$12$eBHEzuKcDjv/g6bcA.NQcOCF4Upria7hs8Qif6Zht4MnmwVfl0pCS	rachel@blackwell.edu	#223CC1	#FFFFFF
6	shanny	bunny	shan	$2b$12$v5ek.nOcKPU6cVYIYoM1euuq8yhfpSm23h6Epv/C2olPc/1donSVu	shanny@bunny.com	#a9e79d	#ca53ba
2	asami	sato	korrasami	$2b$12$Nv11sLMtOOthkkCQGntjxed/ExVYN7xK1HJ8ykSjcK6B2mvTV2D5m	asami@test.com	#000000	#e67a7a
3	max	caulfield	max	$2b$12$itl4JfiUJ47hiYQ51Ml/HOwQJMszu/eauCnKqsSKHXMy6YoYa51hu	max@blackwell.edu	#3855dc	#ffffff
4	chloe	price	chloe	$2b$12$faM4bwoXyPEYuZR8Hl9.pOQBYuTNzVw0toZ28/5u24QFd3WtzUEIG	chloe@arcadia.bay	#932093	#9ad7f3
7	guest	user	guest	$2b$12$iM2y0IcgFPw1EmhTDHMU3eT5NkqwDW9vupSoh31mU3V.Gu/jtokRS	guest@user.com	#223CC1	#FFFFFF
8	temp	user	temp	$2b$12$E9nCPZJKGn7AoCxDQHlwJOn6SKYMuVLugwoR22MupuwUCIA2/6Uwe	temp@user.com	#223CC1	#FFFFFF
9	grey	bunny	grey	$2b$12$dboyuU46Ox6h40fOh/cX7.cSAnbkHR19eq//OwImeVxi8btCg1vbi	grey@bunny.com	#223CC1	#FFFFFF
10	ellie	bunny	ellie	$2b$12$5t0G2kyP/HHCyYU/cD060eSa7R/p0uBGXXXwF3kWmpi.VRZBw9G/.	ellie@bunny.com	#223CC1	#FFFFFF
11	fake	user	fake	$2b$12$H/YbmV6THSJWa2XMUvXSNOhvRO.lh0EHkrb7IL7NSPc4IOiAEUJTW	fake@user.com	#223CC1	#FFFFFF
12	test	user	test	$2b$12$j/ANSLMlNlRVZ20UWj.D1.IzVrLnTzMYotySzHLbE1Jyss5Ms0d2e	test@user.com	#223CC1	#FFFFFF
13	dog	cat	dogcat	$2b$12$90TjCMuAU60JoMAa5gtDeOZ7exAKpVf.MLEm4ZLfoaHigxrv6GbLy	dog@clat	#223CC1	#FFFFFF
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
9	1	2	18
11	1	3	19
13	1	2	43
14	1	3	40
15	1	4	42
16	1	4	14
12	1	6	45
17	1	2	51
18	1	4	47
19	1	6	48
21	1	5	45
22	1	5	47
23	1	7	50
24	1	7	43
26	1	1	16
27	1	1	44
28	1	1	51
10	1	6	\N
20	1	5	\N
29	1	\N	\N
30	1	10	19
31	1	10	42
32	1	10	49
33	1	9	65
34	1	9	41
35	1	9	47
25	1	7	18
37	1	12	2
38	1	12	9
36	1	12	14
39	1	12	45
40	1	6	14
\.


--
-- Name: choices_choice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: echo
--

SELECT pg_catalog.setval('public.choices_choice_id_seq', 100, true);


--
-- Name: events_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: echo
--

SELECT pg_catalog.setval('public.events_event_id_seq', 19, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: echo
--

SELECT pg_catalog.setval('public.users_user_id_seq', 13, true);


--
-- Name: votes_vote_id_seq; Type: SEQUENCE SET; Schema: public; Owner: echo
--

SELECT pg_catalog.setval('public.votes_vote_id_seq', 40, true);


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

