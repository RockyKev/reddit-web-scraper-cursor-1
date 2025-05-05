--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8
-- Dumped by pg_dump version 16.8

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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: reddit_scraper
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO reddit_scraper;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: reddit_scraper
--

CREATE TABLE public.comments (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    post_id uuid NOT NULL,
    author_id character varying(255),
    content text NOT NULL,
    score integer DEFAULT 0,
    contribution_score double precision,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    reddit_created_at timestamp with time zone,
    is_archived boolean DEFAULT false,
    reddit_id character varying(255)
);


ALTER TABLE public.comments OWNER TO reddit_scraper;

--
-- Name: pgmigrations; Type: TABLE; Schema: public; Owner: reddit_scraper
--

CREATE TABLE public.pgmigrations (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    run_on timestamp without time zone NOT NULL
);


ALTER TABLE public.pgmigrations OWNER TO reddit_scraper;

--
-- Name: pgmigrations_id_seq; Type: SEQUENCE; Schema: public; Owner: reddit_scraper
--

CREATE SEQUENCE public.pgmigrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pgmigrations_id_seq OWNER TO reddit_scraper;

--
-- Name: pgmigrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reddit_scraper
--

ALTER SEQUENCE public.pgmigrations_id_seq OWNED BY public.pgmigrations.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: reddit_scraper
--

CREATE TABLE public.posts (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    subreddit_id uuid NOT NULL,
    author_id character varying(255),
    title text NOT NULL,
    selftext text,
    content_url text,
    score integer DEFAULT 0,
    num_comments integer DEFAULT 0,
    permalink text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    reddit_created_at timestamp with time zone,
    is_archived boolean DEFAULT false,
    is_locked boolean DEFAULT false,
    post_type character varying(50) NOT NULL,
    daily_score double precision DEFAULT 0,
    daily_rank integer DEFAULT 0,
    keywords text[],
    author_score double precision,
    top_commenters jsonb,
    summary text,
    sentiment jsonb
);


ALTER TABLE public.posts OWNER TO reddit_scraper;

--
-- Name: subreddits; Type: TABLE; Schema: public; Owner: reddit_scraper
--

CREATE TABLE public.subreddits (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.subreddits OWNER TO reddit_scraper;

--
-- Name: users; Type: TABLE; Schema: public; Owner: reddit_scraper
--

CREATE TABLE public.users (
    id character varying(255) NOT NULL,
    username character varying(255) NOT NULL,
    total_posts integer DEFAULT 0,
    total_comments integer DEFAULT 0,
    total_posts_score integer DEFAULT 0,
    total_comments_score integer DEFAULT 0,
    contributor_score double precision DEFAULT 0,
    first_seen timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    last_seen timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO reddit_scraper;

--
-- Name: pgmigrations id; Type: DEFAULT; Schema: public; Owner: reddit_scraper
--

ALTER TABLE ONLY public.pgmigrations ALTER COLUMN id SET DEFAULT nextval('public.pgmigrations_id_seq'::regclass);


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: reddit_scraper
--

COPY public.comments (id, post_id, author_id, content, score, contribution_score, created_at, updated_at, reddit_created_at, is_archived, reddit_id) FROM stdin;
c881f90c-e9b5-4a37-bb98-5ae24756ced7	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_r6yba	The only sponsor: https://www.oregonlegislature.gov/smithd\n\n\nhttps://upload.wikimedia.org/wikipedia/commons/8/81/David_Brock_Smith.jpg	161	\N	2025-04-01 06:13:44.18282+00	2025-04-01 06:30:21.616714+00	2025-03-31 14:06:24+00	f	mkoqz2t
71d30185-b8b7-47a1-95fc-a5caadbfeebc	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_xu6jr	Just the GOP very openly supporting voter suppression. Nothing to see here…	389	\N	2025-04-01 06:13:44.185078+00	2025-04-01 06:30:21.618847+00	2025-03-31 13:55:19+00	f	mkooxb9
1f4ea9c2-22bd-4979-817f-46121a06c4dc	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_11loiiwhu3	I've voted in Texas, standing in line for hours at a church, and I've voted in Oregon receiving and sending my ballot by mail. You'll never guess which one I prefer.	26	\N	2025-04-01 06:13:44.187405+00	2025-04-01 06:30:21.620766+00	2025-03-31 15:43:11+00	f	mkp9voc
c14bf4b4-3e67-471e-a9a3-a0e677fa48b2	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_a7u1t	Yea. No chance this passes. It’s just a GOP chucklefuck messaging bill.	59	\N	2025-04-01 06:13:44.189727+00	2025-04-01 06:30:21.622745+00	2025-03-31 14:02:48+00	f	mkoqb3q
13cf96e9-7f15-454c-a18c-7f3afb935a87	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_6pnnamf6	Absolutely no way this goes anywhere. We have one of the highest voter participation rates in the country.	34	\N	2025-04-01 06:13:44.192193+00	2025-04-01 06:30:21.624787+00	2025-03-31 14:20:15+00	f	mkotkxu
1cedb2aa-2cb5-4073-b9ec-4b38a7b8e2e4	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_m37k8q45	https://preview.redd.it/p00q0y3fn1se1.jpeg?width=1179&amp;format=pjpg&amp;auto=webp&amp;s=2c19e97ac1b1611298cd479629a8db76d143ad2d\n\nSent an e-mail. I assume this has zero chance of passing, but it still pisses me off. These Trump dick riders in state houses are trying to make the states as dysfunctional as the feds, and I fucking hate it!	51	\N	2025-04-01 06:13:44.194621+00	2025-04-01 06:30:21.626814+00	2025-03-31 15:32:41+00	f	mkp7tgf
82a85f86-a1bd-4f19-bd03-5d54a104c698	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_9jbs9	There are a couple of central principles in risk management. They include identifying what’s at risk and how it’s at risk.\n\nSo far, so good. But the next step is prioritizing the threats and allocating mitigation resources based on those priorities. The problem I have with this bill is I have not seen any but the most anecdotal evidence suggesting there is any sort of significant risk from vote-by-mail.  People are confusing the THEORETICAL risk with the ACTUAL risk.\n\nDoes anyone really think there is ballot box stuffing going on? Does anyone really believe there is widespread voter fraud? Sigh. I just don’t buy it.	42	\N	2025-04-01 06:13:44.19691+00	2025-04-01 06:30:21.628866+00	2025-03-31 14:08:28+00	f	mkorcsg
54a6982c-8739-4fd3-961b-cac7ae867662	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_10o6uc	I love it when MAGA shows up claiming there is so much voter fraud with mail-in voting and it typically turns out it's MAGA doing the fraud. 	22	\N	2025-04-01 06:13:44.199169+00	2025-04-01 06:30:21.630886+00	2025-03-31 14:26:49+00	f	mkoutsy
b3c6dff0-678b-448e-9ee5-b5aa79c1a3a2	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_lx47kp68	Chances of this getting done are limited; vote by mail is pretty well loved and protected in our state. \n\nBut not a bad idea to let anyone you know in Curry, Coos, and Douglas Counties (District 1) that their Oregon state senator/human potato, David Brock Smith is willingly trying to disenfranchise them and their vote simply to catch the favor for a chance to slobber and suck on Trump's toes. \n\nDavid Brock Smith is a turd with appendages. He's a lumbering scoop of moldy mashed potatoes that scares children when he smiles.	10	\N	2025-04-01 06:13:44.201335+00	2025-04-01 06:30:21.632994+00	2025-03-31 16:45:48+00	f	mkpmf4s
7b906661-3a99-428a-9c11-280a5f6bd647	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_ex3lj	LITERALLY NO ONE WANTS THIS	6	\N	2025-04-01 06:13:44.203532+00	2025-04-01 06:30:21.635092+00	2025-03-31 17:18:37+00	f	mkpt0e3
02b763fc-e411-4bad-9b75-f9a1dd774387	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_131oot	Can we just mail in our testimony?	17	\N	2025-04-01 06:13:44.205764+00	2025-04-01 06:30:21.637182+00	2025-03-31 13:55:43+00	f	mkop01i
9dbaa122-08a5-4229-8f22-10d95d5ea1af	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_a9u4krk	You can take away my vote-by-mail when you peg it from my cold dead fingers. Nothing better than voting in your bathrobe.	5	\N	2025-04-01 06:13:44.20808+00	2025-04-01 06:30:21.639254+00	2025-03-31 15:15:14+00	f	mkp4cgx
9873e043-a249-45c4-aea1-b5ace4857846	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_at9omuhxn	This is a really bad idea. Voting by mail is safe and allows the most amount of people to vote. Anyone wanting mailing voting to go away is just trying to suppress voting. No there reason!	4	\N	2025-04-01 06:13:44.210726+00	2025-04-01 06:30:21.641435+00	2025-03-31 16:39:17+00	f	mkpl4mq
d1be38cf-3603-48cb-962c-163a7aaae2e4	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_43iz3fdn	This doesn't have a chance of passing, but I submitted testimony anyways to help own the chud who proposed it.	4	\N	2025-04-01 06:13:44.212906+00	2025-04-01 06:30:21.643394+00	2025-03-31 18:57:24+00	f	mkqd15j
96454114-af06-4f44-90ae-16bbc89b33b7	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_hvgz0	Well then they better give me the day off to go vote.	3	\N	2025-04-01 06:13:44.214968+00	2025-04-01 06:30:21.645461+00	2025-03-31 14:43:02+00	f	mkoxz2m
060ffbcd-0bd4-44ae-8388-92827683ac16	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_xoxpvm	I did my part	3	\N	2025-04-01 06:13:44.217007+00	2025-04-01 06:30:21.649171+00	2025-03-31 16:17:19+00	f	mkpgs18
c6ab83dc-3e09-42ca-b9ae-19ba5deea6d6	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_3z0lk9yw	https://preview.redd.it/bm9ex70ou2se1.jpeg?width=494&amp;format=pjpg&amp;auto=webp&amp;s=b2e32490bc0102e4fff39e5a7a62cf93c00fa68c	3	\N	2025-04-01 06:13:44.219003+00	2025-04-01 06:30:21.653706+00	2025-03-31 19:32:45+00	f	mkqk3p8
6b1217d7-7c3c-42b5-a22d-d7e082d1ba9d	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_mhb2m2z3h	Damn these fucking republicans suck…	3	\N	2025-04-01 06:13:44.221033+00	2025-04-01 06:30:21.658181+00	2025-03-31 19:59:43+00	f	mkqpkxy
788dc123-e09e-46d9-8f82-0020e3ac341d	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_cazkt	Thanks for posting. Civic engagement is a muscle that you need to stretch. Or a dog you need to walk. Or some kind of metaphor.	3	\N	2025-04-01 06:13:44.225295+00	2025-04-01 06:30:21.668157+00	2025-03-31 15:43:55+00	f	mkpa0x8
28e8a45a-1a41-448b-86ec-302874e04d69	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_136s1d	Done! And shared with others.	2	\N	2025-04-01 06:13:44.227572+00	2025-04-01 06:30:21.672761+00	2025-03-31 15:09:49+00	f	mkp39rp
1658f3d2-4333-4f60-bc62-90088890dd83	57497f47-f069-4453-bfc3-a9d231102776	t2_avn8ao	Totally fine, inbound from the airport is likely to be less crowded than trains going the other way anyway	3	\N	2025-04-01 06:30:52.569719+00	2025-04-01 06:30:52.569719+00	2025-03-31 20:52:19+00	f	mkr07ze
72f1470f-32ee-4755-b9f0-ff38ac595050	57497f47-f069-4453-bfc3-a9d231102776	t2_erav1	I mean, there's no special place to put your bags or anything. But so long as you don't mind that, you can and I have taken a suitcase and backpack to the airport.	2	\N	2025-04-01 06:30:52.571611+00	2025-04-01 06:30:52.571611+00	2025-03-31 19:20:55+00	f	mkqhr5x
5f6dc5b9-c99a-43f2-a204-5d93adc620f0	57497f47-f069-4453-bfc3-a9d231102776	t2_4wrob	Unless you're bringing like an entire storefront it'll be fine. Just keep your bags corralled and don't let them roll off into other people.	2	\N	2025-04-01 06:30:52.573326+00	2025-04-01 06:30:52.573326+00	2025-03-31 21:30:44+00	f	mkr7lmc
1c07adc2-7975-4264-9862-76f383f95b83	57497f47-f069-4453-bfc3-a9d231102776	t2_5yppr	Last December, I saw a large family on the red line with probably 10 pieces of luggage including a rollerbag for what looked like a pop up canopy. If they can all fit, I think you will be fine.	2	\N	2025-04-01 06:30:52.574938+00	2025-04-01 06:30:52.574938+00	2025-03-31 22:27:48+00	f	mkrhyr9
d48f5a67-7b51-4c6f-8d38-690628c38f0d	57497f47-f069-4453-bfc3-a9d231102776	t2_f7rf258a	If you’re wanting to spread your stuff all over the priority/accessible seating area as is tradition keep in mind most of those spots get taken up by e-bikes lately, so there may not be sufficient luggage space there.	1	\N	2025-04-01 06:30:52.576548+00	2025-04-01 06:30:52.576548+00	2025-03-31 17:35:08+00	f	mkpwf6r
2b2ba39d-a5e3-4d3e-b01c-11180e935984	432aca04-f976-4d15-8350-c12476bdebaf	t2_9scvr	Love this, I end up walking like 4 miles carrying poop on a long walk because there’s so few trashcans around Portland. My best bet has always been schools or bus stops.	6	\N	2025-04-11 03:32:56.782926+00	2025-04-11 03:32:56.782926+00	2025-04-10 18:44:26+00	f	mmfmwyv
b2689250-27d7-47e1-8310-c59c39a53499	432aca04-f976-4d15-8350-c12476bdebaf	t2_bv5qp	I jog past this often, makes me smile every time :)	6	\N	2025-04-11 03:32:56.786365+00	2025-04-11 03:32:56.786365+00	2025-04-10 19:21:54+00	f	mmfufhj
6f021978-ac73-40a9-8106-7f071cbe02c5	432aca04-f976-4d15-8350-c12476bdebaf	t2_363twqzf	I used to leave one out until the crows found it made them a great bird bath (they already have two,and one that I have for the buggos)- wondering about a workaround.	6	\N	2025-04-11 03:32:56.789777+00	2025-04-11 03:32:56.789777+00	2025-04-10 19:59:50+00	f	mmg25ca
c89c324c-9e81-45b4-b3d5-148cad1d577f	432aca04-f976-4d15-8350-c12476bdebaf	t2_rmqbblc98	Another reason i love Portland	18	\N	2025-04-11 03:32:56.792928+00	2025-04-11 03:32:56.792928+00	2025-04-10 17:02:18+00	f	mmf1pp2
f21560e2-dd92-411f-86b8-f471307c5c74	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_3kh6gj25	You can submit testimony easily, and by “testimony” you can just say “I oppose this bill to eliminate mail in voting for Oregonians.” \n\nIt looks like we do need to enter today though. \n\nhttps://olis.oregonlegislature.gov/liz/2025R1/Testimony/SRULES/SB/210/0000-00-00-00-00?area=Measures\n\nEDIT: Hey wow! I second guessed even sharing this, wondering if it would be valuable. Your responses are a reminder: Never underestimate the power of taking some time to make it easy for folks to share their voices and take action. I hope they were FLOODED with opposition today—and continue to feel the weight of our collective voices :)	602	\N	2025-04-01 06:13:44.179448+00	2025-04-01 06:30:21.613471+00	2025-03-31 14:16:24+00	f	mkosukk
b4cfce6b-5fa4-4696-8506-ef3324ccbde4	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_13242	Text of the proposed bill: https://olis.oregonlegislature.gov/liz/2025R1/Downloads/MeasureDocument/SB210/Introduced\n\n## Summary:\n\n&gt; Digest: Makes voting in person the normal method for voting. Requires voters to show picture ID when voting or requesting a ballot. Refers the Act to the people at the next general election.\n\n&gt; Makes in-person voting on the date of an election the standard method for conducting an election. Allows an elector to request a ballot that may be voted by mail if the elector is unable to vote in person on the date of the election. Retains vote by mail as the primary method for conducting elections for military and overseas electors and for electors who have a mailing address outside of Oregon.\n\n&gt; Requires electors to present valid government-issued identification when appearing in-person to vote or when requesting a ballot be sent by mail. Requires all ballots to be returned by the date of an election.\n\n&gt; Removes a requirement that the state pay postage for ballots returned by mail. Refers the Act to the people for their approval or rejection at the next general election	2	\N	2025-04-01 06:13:44.229772+00	2025-04-01 06:30:21.677403+00	2025-03-31 17:47:18+00	f	mkpywxl
31483674-0201-4ce9-a9d2-b3e7cf67c45d	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_9rlpscet	Explain this to someone who may be ignorant(hi it’s me)	2	\N	2025-04-01 06:13:44.231899+00	2025-04-01 06:30:21.682472+00	2025-03-31 20:00:07+00	f	mkqpnz2
d82b3383-f729-40c4-84cd-148fa54a5906	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_yoxh0od	Why would we remove it? Gives me time to research and I can vote while researching. I’m more informed than if I had to vote in person.	2	\N	2025-04-01 06:13:44.233828+00	2025-04-01 06:30:21.6871+00	2025-03-31 20:30:10+00	f	mkqvqxy
edd6c817-b642-45ef-9a82-55294db87427	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_hmowc	Another rural dipstick from the middle of nowhere sucking up to FNG	3	\N	2025-04-01 06:13:44.235799+00	2025-04-01 06:30:21.691714+00	2025-03-31 14:45:06+00	f	mkoydiq
fcb517f2-8e20-4f98-8712-a898e0da37e4	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_5uke6htd	We know how this will go.  Red counties will want it, blue counties won’t.	3	\N	2025-04-01 06:13:44.237748+00	2025-04-01 06:30:21.696402+00	2025-03-31 14:07:31+00	f	mkor6ds
fefb61a7-2997-46c5-9b06-086f45c470ba	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_e5tlwqhl	Is it paranoia or rational thought that makes me pause… "this is just another easy way to identify people who don't want Trump to have a third term"	1	\N	2025-04-01 06:13:44.239625+00	2025-04-01 06:30:21.701083+00	2025-03-31 17:29:01+00	f	mkpv5kw
741860b5-dffd-4d8c-8748-a9a1489fbd66	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_4cjkd	Fuck *that*.	1	\N	2025-04-01 06:13:44.241886+00	2025-04-01 06:30:21.705699+00	2025-03-31 23:25:35+00	f	mkrs31m
fcea82fd-d97d-4650-9fa0-e2e458291125	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_8ae1b	Does submitted testimony ever actually do anything?\n\nI'm not suggesting repealing vote-by-mail. I like our vote-by-mail. I just wonder if anyone can point to any bill that changed due to public testimony or died in committee because of it.	1	\N	2025-04-01 06:13:44.24423+00	2025-04-01 06:30:21.71031+00	2025-03-31 23:53:08+00	f	mkrwtqi
114bbace-b136-4ec8-92ac-92ab16ad4c52	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_kjfudh2kq	This is DOA. I'm not sure why the media is giving it so much hype. The Republican goofball who proposed it is wasting everyone's time.	1	\N	2025-04-01 06:13:44.246389+00	2025-04-01 06:30:21.713859+00	2025-03-31 23:54:15+00	f	mkrx0hu
9c46a92c-7ba3-48f3-96ac-f2f31425a4a9	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_6oh81kre	Submitted, and just sent the instructions and link to my family.	1	\N	2025-04-01 06:13:44.248433+00	2025-04-01 06:30:21.717154+00	2025-04-01 00:44:44+00	f	mks5abz
195c93af-d16f-42fe-8f41-368e12e7e2f3	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_1e23vraic8	Yes but I don't think it will happen here.  We are a blue state and even the repulsive like vote by mail.	1	\N	2025-04-01 06:13:44.250551+00	2025-04-01 06:30:21.72046+00	2025-04-01 02:03:06+00	f	mkshwy4
1d8777fa-e716-4a6c-85df-57c6c351aa57	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_7trgw	I don't even need to do any research to know this is clearly some MAGA BS sponsored bill. Fuck this. Voting by mail is the best and we all know why 'they' don't want it.	1	\N	2025-04-01 06:13:44.252549+00	2025-04-01 06:30:21.72347+00	2025-04-01 02:06:32+00	f	mksigys
77b92fee-6ab7-47e4-be49-de4da923007c	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_rkbtv	Why does Senator David Brock Smith, the senator that proposed this assault on our freedoms, hate our democracy so much?	1	\N	2025-04-01 06:13:44.254536+00	2025-04-01 06:30:21.726529+00	2025-04-01 02:57:30+00	f	mksqdlx
74a3be35-91a1-4846-ae95-1a8291095600	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_du35t	9 thousand maga tools have spoken	1	\N	2025-04-01 06:13:44.256462+00	2025-04-01 06:30:21.729684+00	2025-04-01 03:17:29+00	f	mksta42
ea8035ac-321f-46b3-895a-e9e5c73f754a	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_f106vp85	Done!!! And +1	1	\N	2025-04-01 06:13:44.258812+00	2025-04-01 06:30:21.732831+00	2025-04-01 04:03:46+00	f	mkszje9
8c5c84ac-b262-4984-9bfa-995cd6d945f3	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_6m8jkwyh	Done!   Thanks for the link	1	\N	2025-04-01 06:13:44.261235+00	2025-04-01 06:30:21.736973+00	2025-03-31 15:55:04+00	f	mkpc9st
0cac69fa-b207-4935-b7af-c2ecff70892c	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_6wb6v22p	I tried,  but not sure it worked. It froze after hitting submit	1	\N	2025-04-01 06:13:44.263419+00	2025-04-01 06:30:21.740005+00	2025-03-31 18:00:01+00	f	mkq1j2d
18e691ff-08f4-4240-9a61-a53c9d7afc9d	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_2rh9yh3a	This is rage bait, the bill will never even make it out of committee or even to a committee work session. Let alone go to a floor vote in either chamber, let alone pass them, let alone avoid a gubernatorial veto.\n\nThe press is just fishing for clicks from scared liberals. Don't fall for this crap or the press will keep publishing it.	-4	\N	2025-04-01 06:13:44.265345+00	2025-04-01 06:30:21.742825+00	2025-03-31 14:33:41+00	f	mkow59o
ae1f6595-f204-43d6-89c3-8726be4bb8e4	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_1gly3daz2e	If we’re in a “let’s repeal and destroy” mood start with the bottle bill!!!!\n\nDems + Reps hate the bottle bill!	-5	\N	2025-04-01 06:13:44.267293+00	2025-04-01 06:30:21.744977+00	2025-03-31 14:38:54+00	f	mkox60v
9065dca7-04af-4032-9511-924f833e4aed	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_8rdsw	So according to this you have 48 hours after the meeting to submit a testimony? I already submitted mine this weekend but if you look at the comments, someone points out it can be done up to 48 hours after.\n\nhttps://www.reddit.com/r/Portland/s/cEpsFkxgb2	-1	\N	2025-04-01 06:13:44.269327+00	2025-04-01 06:30:21.74737+00	2025-03-31 14:54:23+00	f	mkp07wv
b8b43447-05d8-49f0-b2d7-754b24efb15a	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_733gn	You know this is GOP posturing. it's not happening. at least not this way.	-2	\N	2025-04-01 06:13:44.271378+00	2025-04-01 06:30:21.749706+00	2025-03-31 16:50:00+00	f	mkpn92z
cd37c337-480c-4738-a6dd-f011a7f742ca	432aca04-f976-4d15-8350-c12476bdebaf	t2_733gn	in general, a big shout out to people who put out water bowls and keep water in them. As someone who has one in their yard it is crazy how often they get emptied (and also stolen but that is a different story).	132	\N	2025-04-11 03:32:56.765761+00	2025-04-11 03:32:56.765761+00	2025-04-10 16:55:28+00	f	mmf0b05
c14d666c-1707-42fe-bfff-37593a742d97	432aca04-f976-4d15-8350-c12476bdebaf	t2_eta1l	There is a nice one just south of the SW Entrance to Mt. Tabor park near 64th and Lincoln.  It has treats (two per dog per day), dog poop bags/trash, water, AND A STICK LIBRARY!	89	\N	2025-04-11 03:32:56.772769+00	2025-04-11 03:32:56.772769+00	2025-04-10 17:48:42+00	f	mmfbecv
f7a77f24-fa52-4d6a-a991-187113cf533b	432aca04-f976-4d15-8350-c12476bdebaf	t2_725lo	For anyone interested, this is around Willamette and Buchanan in St John's. We walk past it every week when headed to the coffee shop across the street.	26	\N	2025-04-11 03:32:56.776156+00	2025-04-11 03:32:56.776156+00	2025-04-10 19:47:30+00	f	mmfzkbz
11cc4c8a-b119-46c5-9d87-65bbdcaad11f	ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	t2_4pl1ubhw	you can email the sponsor here\n\n[Sen.DavidBrockSmith@oregonlegislature.gov](mailto:Sen.DavidBrockSmith@oregonlegislature.gov)\n\nHere some copy to use if you like \n\nI strongly oppose SB-210 ending vote by mail in Oregon.\n\n​Senate Bill 210 proposes a shift from Oregon's established vote-by-mail system to predominantly in-person voting, a move that would significantly reduce voter participation by imposing barriers for individuals with disabilities, the elderly, and those residing in remote areas. The bill's requirement for government-issued photo identification disenfranchise eligible voters who lack such documentation, effectively suppressing their right to vote. Oregon's vote-by-mail system has a proven track record of enhancing voter turnout and ensuring electoral integrity; dismantling it in favor of in-person voting lacks justification and undermines decades of successful practice. The proposed changes could lead to increased administrative costs and logistical challenges, straining county resources and potentially causing confusion among voters. Maintaining the current vote-by-mail system preserves accessibility, convenience, and the democratic principle of inclusive participation for all eligible Oregonians.	3	\N	2025-04-01 06:13:44.223051+00	2025-04-01 06:30:21.662876+00	2025-03-31 22:06:47+00	f	mkre9bz
45fa1291-48ef-4ac4-ae53-6b25b51930eb	4b1ffde6-84ab-4e43-8ac6-5c580313446e	t2_8du7p9b1	Rare mating of the Max’s caught on film	126	\N	2025-04-01 06:30:30.351798+00	2025-04-01 06:30:30.351798+00	2025-03-31 15:20:04+00	f	mkp5api
a10b262f-a782-4880-a73c-3ef2d77ab112	4b1ffde6-84ab-4e43-8ac6-5c580313446e	t2_86nxh	Sorry, local stops only	112	\N	2025-04-01 06:30:30.35587+00	2025-04-01 06:30:30.35587+00	2025-03-31 15:18:42+00	f	mkp50wq
d1e72168-058f-479d-b0e2-4f38e6e2ebf0	4b1ffde6-84ab-4e43-8ac6-5c580313446e	t2_y2gbp	Why’d you walk off SNL smh	62	\N	2025-04-01 06:30:30.359089+00	2025-04-01 06:30:30.359089+00	2025-03-31 15:27:48+00	f	mkp6ubb
7a2b556b-ac64-43bf-b5f0-1aaf8ccd7bb8	4b1ffde6-84ab-4e43-8ac6-5c580313446e	t2_c3dee	So you’re on the red line this morning?	21	\N	2025-04-01 06:30:30.362037+00	2025-04-01 06:30:30.362037+00	2025-03-31 15:24:30+00	f	mkp66jz
7274b468-d133-4c4e-a0a2-53130a66cab0	4b1ffde6-84ab-4e43-8ac6-5c580313446e	t2_1cx9xq9cec	IM NEVER LEAVING PORTLAND	21	\N	2025-04-01 06:30:30.364881+00	2025-04-01 06:30:30.364881+00	2025-03-31 19:04:08+00	f	mkqee8v
92cfbc41-3cc2-47f7-b5e3-1fe505caaf6f	4b1ffde6-84ab-4e43-8ac6-5c580313446e	t2_4lqn3822	https://preview.redd.it/ixeliu1d52se1.jpeg?width=2282&amp;format=pjpg&amp;auto=webp&amp;s=347154083d3aaf88b9b05fa7f1d70273bb6caab5	56	\N	2025-04-01 06:30:30.367656+00	2025-04-01 06:30:30.367656+00	2025-03-31 17:10:57+00	f	mkprg4t
0a8e55a9-99cb-4b68-8b5d-72862179e6d1	4b1ffde6-84ab-4e43-8ac6-5c580313446e	t2_9rb7awwf	So god's country is at the Killingsworth stop on the MAX line?	13	\N	2025-04-01 06:30:30.370305+00	2025-04-01 06:30:30.370305+00	2025-03-31 19:18:43+00	f	mkqhb90
39483626-d112-49eb-ade4-cd68cf322942	4b1ffde6-84ab-4e43-8ac6-5c580313446e	t2_1fgu7qgrfu	Needs more *descriptive audio* on the local broadcast	11	\N	2025-04-01 06:30:30.374071+00	2025-04-01 06:30:30.374071+00	2025-03-31 18:34:48+00	f	mkq8igy
26531f30-255b-4683-85c8-a1d556a505b3	4b1ffde6-84ab-4e43-8ac6-5c580313446e	t2_fb8hw	This my version too lmao	9	\N	2025-04-01 06:30:30.376993+00	2025-04-01 06:30:30.376993+00	2025-03-31 15:38:03+00	f	mkp8v5t
2a3f5969-7991-460c-a597-6c0ae79b7724	4b1ffde6-84ab-4e43-8ac6-5c580313446e	t2_1k8w0wntro	I love living in Portland	6	\N	2025-04-01 06:30:30.379726+00	2025-04-01 06:30:30.379726+00	2025-03-31 23:46:09+00	f	mkrvmxu
cf504e45-ba41-42bc-b69c-28c3f04e8df6	4b1ffde6-84ab-4e43-8ac6-5c580313446e	t2_4nn7joy1	This gods country has an amazing meme potential.	5	\N	2025-04-01 06:30:30.382406+00	2025-04-01 06:30:30.382406+00	2025-04-01 02:53:33+00	f	mkspsav
34d8fa68-17a6-4979-a1a3-76243e91af72	4b1ffde6-84ab-4e43-8ac6-5c580313446e	t2_6aih3qz9	Looks like they’re going tip to tip.	2	\N	2025-04-01 06:30:30.385048+00	2025-04-01 06:30:30.385048+00	2025-03-31 22:27:46+00	f	mkrhyjh
87c39614-bbd6-47fc-94b6-25bb7769ee71	4b1ffde6-84ab-4e43-8ac6-5c580313446e	t2_9plibs0w	🙌🙌🙌	5	\N	2025-04-01 06:30:30.388151+00	2025-04-01 06:30:30.388151+00	2025-03-31 15:18:10+00	f	mkp4x7v
b56032c2-df6f-430b-92b9-c7f8c56813b5	4b1ffde6-84ab-4e43-8ac6-5c580313446e	t2_4nfo0o3t	https://preview.redd.it/5006e1e5v4se1.jpeg?width=360&amp;format=pjpg&amp;auto=webp&amp;s=ec8384422c0ba55a998f579972a96bf49dbc603f	1	\N	2025-04-01 06:30:30.391364+00	2025-04-01 06:30:30.391364+00	2025-04-01 02:19:00+00	f	mkskgx9
0649092c-bfc6-422f-8210-91ff0b8018ba	4b1ffde6-84ab-4e43-8ac6-5c580313446e	t2_1iq0cr64tz	I don't get it.	1	\N	2025-04-01 06:30:30.394339+00	2025-04-01 06:30:30.394339+00	2025-04-01 04:08:56+00	f	mkt07al
32223bf9-819c-4a3e-932e-f5dcb68ab05c	4b1ffde6-84ab-4e43-8ac6-5c580313446e	t2_riovcvu6	Boot licking	1	\N	2025-04-01 06:30:30.397608+00	2025-04-01 06:30:30.397608+00	2025-04-01 01:43:27+00	f	mkseqfm
2c201f16-2aaa-41f1-862c-3c7453134e27	4b1ffde6-84ab-4e43-8ac6-5c580313446e	t2_11pz34qbf1	Get me to where people are illiterate and women are forced to give birth after being raped	-2	\N	2025-04-01 06:30:30.400638+00	2025-04-01 06:30:30.400638+00	2025-04-01 02:21:10+00	f	mkskt7n
5bde7290-eb21-485a-995e-97dedb2aed24	f9b55f6a-4989-4e0c-b1be-a8e98fbbe16b	t2_mth7x32n	If either of you have OHP (Oregon Health Plan), the Oregon Health Authority has a housing assistance program that includes eviction defense and rent assistance. If she doesn’t, I’d recommend going into an Oregon Department of Human Services office and asking to apply for OHP (you also can do so online just call an office after to schedule an appointment if you do).	279	\N	2025-04-01 06:30:44.003023+00	2025-04-01 06:30:44.003023+00	2025-03-31 14:17:26+00	f	mkot1gh
d2650c2e-0935-40cb-87f5-1f3b08c32f59	f9b55f6a-4989-4e0c-b1be-a8e98fbbe16b	t2_t641g9ze	Talk to your landlord and ask if there is anything you can do to avoid the actual eviction. If you are willing to leave on good terms and establish a payment plan for unpaid rent, they may be willing to work with you. An eviction isn’t desirable for either of you. And as sad as it is, you need to rehome those cats. You cannot afford to give them the life they deserve. And frankly when this is your living scenario you should not be putting money towards anything except housing stability.	157	\N	2025-04-01 06:30:44.006409+00	2025-04-01 06:30:44.006409+00	2025-03-31 14:00:07+00	f	mkoptjk
5d37a297-0f04-4480-a92b-76cfccdff7f3	f9b55f6a-4989-4e0c-b1be-a8e98fbbe16b	t2_12b1u3	Is your Grandma getting government assistance, like social security, medicare or medicaid? You should definitely call 211 and be honest with them.	34	\N	2025-04-01 06:30:44.009525+00	2025-04-01 06:30:44.009525+00	2025-03-31 14:18:17+00	f	mkot7dk
9c1f9049-39d6-450b-80dd-26e8909ea3ed	f9b55f6a-4989-4e0c-b1be-a8e98fbbe16b	t2_l86g3c8f	Okay the eviction process is quite intense in Portland you have your first trial date. SHOW UP! There they will give you a few options. 1) there will be representatives there from rent assistance programs that are income based and you can apply which will postpone the eviction until you receive an approval or not from those programs. 2) they will give you the option to voluntarily vacate the property (this will not be an eviction on your record but past rent will still be owed to the landlord and you can set up payments with them) or 3) your landlord may allow you to make payments to stay within the property. But make sure you attend the first trial because if you don’t they will rule in favor of the property owner and you will be removed that day.	15	\N	2025-04-01 06:30:44.012251+00	2025-04-01 06:30:44.012251+00	2025-03-31 22:23:52+00	f	mkrha4o
8fcac0fa-eeb2-4bf3-aa33-7443e1d474d1	f9b55f6a-4989-4e0c-b1be-a8e98fbbe16b	t2_98u9v87n	I'm so sorry. Please remember that death is a permanent solution to a temporary problem. If you have those thoughts avainn plllease seek help. Call or text 988.\n\nThere is an eviction Legal defense fund that I would start with. This is legal help from the city and Legal Aid and you need to check with them asap. https://oregonlawcenter.org/eviction-defense-project/\n\nPortland tenants united which is volunteers also has a program https://www.pdxtu.org/eviction_resistance\n\nCall 211 to see if there are currently any rental assistance programs available\n\nDo you or grandma have oregon health plan? I know someone else they are paying rent for because them becoming homeless will make their mental/health much worse. I'd look into that especially based on what you said here. You would start by calling your health home/ care coordinator. \n\nYou can file for unemployment because you've been available to work but nfoodiven many shifts. (Former unemployment worker here)\n\nYou probably also qualify for SNAP (food benefits) if you don't already have them.	36	\N	2025-04-01 06:30:44.015182+00	2025-04-01 06:30:44.015182+00	2025-03-31 14:20:25+00	f	mkotm3k
732f1f53-4bcb-4734-9a50-fe38fb4acc63	432aca04-f976-4d15-8350-c12476bdebaf	t2_96uhxwxj	What an amazing idea! I wish I had a space to implement one in my yard. All the free dog pets....	18	\N	2025-04-11 03:32:56.779396+00	2025-04-11 03:32:56.779396+00	2025-04-10 16:55:11+00	f	mmf08yo
febe9753-5e4e-4ffe-9436-b10636f88429	f9b55f6a-4989-4e0c-b1be-a8e98fbbe16b	t2_10pm0enps0	Hey OP, that's really hard. Take all the legal help you can get, take a deep breath, and start looking for jobs because the one you're at is obviously not cutting it. \n\nIt's going to be ok. You need more support than you have right now, but you *will* get through this. I was really depressed and unemployed for a while- I was essentially spending all day doing .. frankly, pretty demeaning art to make ends meet. \n\nIt felt impossible to get out of that hole. I was living with family, super obese, I spent all day mentally berating myself, and I just kept spiralling further into food addiction and self hate. But, one day, I reached out for help at Old Town Clinic. I got treatment for my mental health, and I started actually being able to function and make healthier choices. I was still isolated, but I started making online friends. I started feeling better physically, and I found I had energy to get to the job hunt. I landed a job, then I found a DnD group, got my own place, and I'm building up a social network, slowly but surely. I got promoted at work. Life isn't perfect, but an upward spiral started and I'm holding on for dear life. This all happened to me over the course of about 8 months. I hope it helps to read this, at least a little.	20	\N	2025-04-01 06:30:44.018373+00	2025-04-01 06:30:44.018373+00	2025-03-31 16:15:27+00	f	mkpgej9
c442593b-1123-4f9b-9481-7672bf07fb89	f9b55f6a-4989-4e0c-b1be-a8e98fbbe16b	t2_mbhzfm6c	reach out to dontevictpdx and see if they can help you	14	\N	2025-04-01 06:30:44.02155+00	2025-04-01 06:30:44.02155+00	2025-03-31 14:06:02+00	f	mkoqwm6
61584c3e-6d6b-4ff7-8491-fe968dff7dc1	f9b55f6a-4989-4e0c-b1be-a8e98fbbe16b	t2_49d55	Sorry you're going through a rough time. I think the most important thing for you is to maintain perspective so you can tackle the challenges you need to face. These are very solvable, trust.\n\nYou are way too young &amp; this is way too small a problem to even consider yourself a failure, let alone ponder self-harm. It can be difficult to see that clearly when you're in the thick of it but I promise you can come back from this quite easily.\n\nHere's some context to understand my point:\n\n* the average American carries over $50k debt personally\n* the average household carries over $105k debt\n\nSo, compared to the average American you're financially in better shape. You have an urgent need to address, sure, but overall things aren't as bleak as they may seem.\n\nYour rent is quite low for Portland so trying to work something out to stay put is probably your best option. Since you have $2k you can offer to pay April and May upfront, plus a longer term plan to repay your unpaid rent over time. Before you send any cash though, make sure you get whatever plan you agree to in writing signed by both you and your landlord. If you need help wording this in a letter just ask.\n\nTo make good on that commitment, and generally to make it as an adult, you need to find a reliable source of income so start looking for another job to add to your current one or replace it. The minimum wage in Portland is around $16 per hour and the city is quite commutable without a car, so you can cover your living expenses with literally any full time job.\n\nGood luck &amp; keep your head up!	2	\N	2025-04-01 06:30:44.025331+00	2025-04-01 06:30:44.025331+00	2025-03-31 23:50:21+00	f	mkrwcxb
e8ecdf21-6b7e-4610-aef0-b4a358c9d859	f9b55f6a-4989-4e0c-b1be-a8e98fbbe16b	t2_548kqhya	Have you not been paying rent? \nWhat resulted in the eviction?	6	\N	2025-04-01 06:30:44.028268+00	2025-04-01 06:30:44.028268+00	2025-03-31 15:44:15+00	f	mkpa3ch
2025305f-8e11-448c-9ea0-0d0e7f3675ac	f9b55f6a-4989-4e0c-b1be-a8e98fbbe16b	t2_kr7bmyzvz	https://multco.us/info/housing-legal-resources	4	\N	2025-04-01 06:30:44.031164+00	2025-04-01 06:30:44.031164+00	2025-03-31 14:54:49+00	f	mkp0b29
074a8817-6719-4329-8418-7e1edb1c5019	f9b55f6a-4989-4e0c-b1be-a8e98fbbe16b	t2_kr7bmyzvz	If you're in Portland and it's a no-fault eviction,  the landlord has to give you 90-days notice. You also may be eligible for relocation monetary assistance in certain situations. \n\nhttps://oregonlawcenter.org/eviction-defense-project/	2	\N	2025-04-01 06:30:44.033705+00	2025-04-01 06:30:44.033705+00	2025-03-31 14:54:28+00	f	mkp08k0
3b824e97-cf84-4ce9-aae3-79c52e21aa6a	f9b55f6a-4989-4e0c-b1be-a8e98fbbe16b	t2_e7qppv4x	There are plenty of good paying jobs out there for people willing to put in a hard days work.	-6	\N	2025-04-01 06:30:44.0368+00	2025-04-01 06:30:44.0368+00	2025-03-31 17:33:13+00	f	mkpw0u9
8ec46073-904f-40ac-8830-26232b38f745	f9b55f6a-4989-4e0c-b1be-a8e98fbbe16b	t2_7omq4	9 CATS!?!?\n13000/750=17.333 \nYOU GUYS NEVER PAID ANYTHING FOR 17 MONTHS. LOL\nTHEY WILL NOT WORK WITH YOU.\nSALVATION ARMY AND GOODWILL ARE ALWAYS HIRING.	-7	\N	2025-04-01 06:30:44.039947+00	2025-04-01 06:30:44.039947+00	2025-03-31 21:03:02+00	f	mkr2c67
0d7d2607-f175-458a-b389-3db13208c9d1	57497f47-f069-4453-bfc3-a9d231102776	t2_3do3ef02	The Max goes to the airport for a reason...	85	\N	2025-04-01 06:30:52.5479+00	2025-04-01 06:30:52.5479+00	2025-03-31 17:18:24+00	f	mkpsyqg
65be263b-1485-42df-a007-48870a25831e	57497f47-f069-4453-bfc3-a9d231102776	t2_79xvq	Anybody getting their jimmies rustled about a piece of luggage on public transport can have one of my dog's trazadone pills. \n\nThe NYC subway, the London tube, all major transit systems are used by people carrying luggage all the time. As long as you're not trying to move an upright piano or carrying multiple suitcases large enough to contain an adult human cadaver, you're fine, and anyone giving you side eye can suck it.	75	\N	2025-04-01 06:30:52.550122+00	2025-04-01 06:30:52.550122+00	2025-03-31 17:54:09+00	f	mkq0bkk
31646695-bbff-4749-8c76-9e453b525cc7	57497f47-f069-4453-bfc3-a9d231102776	t2_vlm2sqhj	If the luggage is manageable for you, it'll be for others, too. Red line has air travelers with roll -aboards all the time. You'll be counter-commuting at that time, too.	27	\N	2025-04-01 06:30:52.552615+00	2025-04-01 06:30:52.552615+00	2025-03-31 17:18:04+00	f	mkpsw9a
6c52344f-d4ea-4f38-9152-d2fa2dca1e30	57497f47-f069-4453-bfc3-a9d231102776	t2_186w0fp4	If you can carry or roll it through the airport, it won't be any problem at all. If you're bringing so much stuff you need a donkey cart or something, then you'll probably need to get a ride.	16	\N	2025-04-01 06:30:52.554655+00	2025-04-01 06:30:52.554655+00	2025-03-31 17:20:18+00	f	mkptcye
5d9e496e-bb01-4427-b509-e629f2156482	57497f47-f069-4453-bfc3-a9d231102776	t2_pafbr	The luggage question seems to be handled (no big deal) but if you didn't know, you can just tap a credit or debit card to ride (or apple/Google pay). You don’t need to buy a ticket from the machine. You can ride for 2.5 hours. After 2.5 hours, tap again with the same card and get a day pass.	7	\N	2025-04-01 06:30:52.55663+00	2025-04-01 06:30:52.55663+00	2025-03-31 18:35:19+00	f	mkq8m7w
15054a2e-122f-46f5-a7e8-738841b12995	57497f47-f069-4453-bfc3-a9d231102776	t2_i42xi	It’s not annoying at all. Major pro tip though: hop in the front car furthest away from the platform for a lot more space. The majority of people getting on the Max at the airport just hop in the back one.	13	\N	2025-04-01 06:30:52.558559+00	2025-04-01 06:30:52.558559+00	2025-03-31 17:17:35+00	f	mkpssrb
7289e7ba-b31b-450f-b828-5d00fa61e816	57497f47-f069-4453-bfc3-a9d231102776	t2_nyrvt2p1c	Getting FROM pdx with luggage is super easy. It is the end of the line so when you get to the train from baggage claim it will be empty or just have a few other travelers on it. There are areas in the middle of each train that have no seats or fold up seats, plenty of room for luggage. \n\nGoing TO the airport with luggage is the more difficult task, because the train going eastward might be on the full side when it gets to your stop.	6	\N	2025-04-01 06:30:52.560649+00	2025-04-01 06:30:52.560649+00	2025-03-31 18:18:01+00	f	mkq55ry
20028b47-ee1e-481e-a52e-e0fcded497b4	57497f47-f069-4453-bfc3-a9d231102776	t2_54x24sdnm	People bring full shopping carts full of trash onto the Max. You’re good	10	\N	2025-04-01 06:30:52.562596+00	2025-04-01 06:30:52.562596+00	2025-03-31 18:15:16+00	f	mkq4lsh
29a93d3f-248b-4d5f-8161-3ddb68c5f2a3	57497f47-f069-4453-bfc3-a9d231102776	t2_16qeu0	If you have 1 or 2 roller bags it'll be fine. If you brought your whole bedroom, then a uhaul. But for real, it is great. As long as it's not the old style max with stairs it'll be a breeze.	3	\N	2025-04-01 06:30:52.564691+00	2025-04-01 06:30:52.564691+00	2025-03-31 18:37:53+00	f	mkq94m3
b03152bd-934a-4468-862e-86dc506fcd08	57497f47-f069-4453-bfc3-a9d231102776	t2_81ldsjtg	The Max is one of the easiest forms of ground transportation from PDX, IMO, depending on how much luggage you have and where you are going to. 1 checked bag and a carryon should be no problem.	3	\N	2025-04-01 06:30:52.567454+00	2025-04-01 06:30:52.567454+00	2025-03-31 19:43:25+00	f	mkqm8fk
831c4ce2-4d7b-41ad-9e2e-931bcee61609	432aca04-f976-4d15-8350-c12476bdebaf	t2_lanpf29	This is amazing! Nice to see someone who welcomes dogs instead of signs telling them to go away! Thank you for doing this!	9	\N	2025-04-11 03:32:56.796018+00	2025-04-11 03:32:56.796018+00	2025-04-10 17:29:22+00	f	mmf7ccx
7c9c15fb-06a4-4129-a69d-c10ba33133fa	432aca04-f976-4d15-8350-c12476bdebaf	t2_rwmcg8apd	There was a popular post the other day complaining about little kids and their mom in someone else's front yard. I'm glad to see the antithesis to that.	6	\N	2025-04-11 03:32:56.799101+00	2025-04-11 03:32:56.799101+00	2025-04-10 18:17:38+00	f	mmfhffe
e7e980da-0afa-48b5-abbf-ceb2efde5b65	432aca04-f976-4d15-8350-c12476bdebaf	t2_iw284	is this the one on Willamette?	2	\N	2025-04-11 03:32:56.80221+00	2025-04-11 03:32:56.80221+00	2025-04-10 20:13:23+00	f	mmg5208
55c42a5b-2a75-47eb-a1a7-b9beddfe7753	432aca04-f976-4d15-8350-c12476bdebaf	t2_1h6qatpz	So cute	1	\N	2025-04-11 03:32:56.805187+00	2025-04-11 03:32:56.805187+00	2025-04-10 20:52:40+00	f	mmgd5ab
3d4a5734-6a69-462a-baa3-2aaa938443d7	432aca04-f976-4d15-8350-c12476bdebaf	t2_anyv0	This is sooooo cool!	1	\N	2025-04-11 03:32:56.808177+00	2025-04-11 03:32:56.808177+00	2025-04-10 21:24:53+00	f	mmgjhbs
288d7eaf-202f-4a04-a253-904646e0c138	432aca04-f976-4d15-8350-c12476bdebaf	t2_117xp2jpyl	This is adorable! Plus having a designated spot for a poo is a really good way to combat the random poop bombs without being a jerk (either party)	1	\N	2025-04-11 03:32:56.811095+00	2025-04-11 03:32:56.811095+00	2025-04-10 21:28:16+00	f	mmgk4it
cdbfd3b6-cf6f-4916-8727-cb3e715f310e	432aca04-f976-4d15-8350-c12476bdebaf	t2_e7gjo	I fucking love this. This is indeed very Portland, and I’m inspired to blow up my front yard for something like this	1	\N	2025-04-11 03:32:56.814182+00	2025-04-11 03:32:56.814182+00	2025-04-10 23:52:40+00	f	mmh9rrm
7ceb49da-f8d5-4a31-8e0a-84a0848ceabd	432aca04-f976-4d15-8350-c12476bdebaf	t2_x0zk	Dang!  At first I thought it was a park for tiny dogs, and I was going to bring my chihuahua to hang out with other little beings, but I guess the reality is pretty cool too.	1	\N	2025-04-11 03:32:56.81711+00	2025-04-11 03:32:56.81711+00	2025-04-11 00:31:40+00	f	mmhg98r
bb4fee41-ecf9-4b25-bccc-7e919d2eb90b	432aca04-f976-4d15-8350-c12476bdebaf	t2_i8lt2	So many people get pissed off by anyone setting foot on their property, it's refreshing to see someone invite people in.	1	\N	2025-04-11 03:32:56.820015+00	2025-04-11 03:32:56.820015+00	2025-04-10 21:37:36+00	f	mmglw2p
98dd1b97-363c-4cf2-bf31-da303c19bf70	432aca04-f976-4d15-8350-c12476bdebaf	t2_3lwn6a7n	SO Portland💙	0	\N	2025-04-11 03:32:56.822908+00	2025-04-11 03:32:56.822908+00	2025-04-10 20:19:50+00	f	mmg6ei4
f6daeee6-3d22-4781-a2f5-67e94bcc8802	c3b07639-3763-488f-920c-3182facbf284	t2_lwgx87c	That’s my street!	16	\N	2025-04-11 03:33:04.867429+00	2025-04-11 03:33:04.867429+00	2025-04-10 13:30:36+00	f	mmdvkxt
95eb8f54-aff5-4e06-87e8-a6916f34f1c1	c3b07639-3763-488f-920c-3182facbf284	t2_8bpjy0c0	What neighborhood is that ?	8	\N	2025-04-11 03:33:04.870542+00	2025-04-11 03:33:04.870542+00	2025-04-10 05:44:05+00	f	mmcdyhc
0df58ac6-1f36-414c-bf71-878f444ed35a	c3b07639-3763-488f-920c-3182facbf284	t2_3jsbv	Are you 8ft tall?	26	\N	2025-04-11 03:33:04.873591+00	2025-04-11 03:33:04.873591+00	2025-04-10 05:44:09+00	f	mmcdyrr
d47a092e-d216-4101-ad8b-e2e78c382dfe	c3b07639-3763-488f-920c-3182facbf284	t2_uxqvda3s	Best time of year for biking!\n\nI mean all the times are better than being in a car but i especially enjoy spring and noticing the advances of flowers and new green.	7	\N	2025-04-11 03:33:04.877185+00	2025-04-11 03:33:04.877185+00	2025-04-10 15:28:09+00	f	mmeikob
636f5040-4bca-4734-af1d-02c480bc1646	c3b07639-3763-488f-920c-3182facbf284	t2_363twqzf	I can smell this, makes me so happy my head won't blow up from allergies. Thank you,OTC antihistamines.	4	\N	2025-04-11 03:33:04.880318+00	2025-04-11 03:33:04.880318+00	2025-04-10 15:30:19+00	f	mmej0cp
23f9ed5f-7351-4354-bf67-7345fc080b2d	c3b07639-3763-488f-920c-3182facbf284	t2_10s82e	I love Portland so much. Every day I’m more and more glad I moved here	3	\N	2025-04-11 03:33:04.883376+00	2025-04-11 03:33:04.883376+00	2025-04-10 16:41:29+00	f	mmexgli
750a1b06-21d7-42fc-97fd-5b3c6eb7293d	c3b07639-3763-488f-920c-3182facbf284	t2_92sa0	what's your camera? do you like it? I've been looking into getting one	3	\N	2025-04-11 03:33:04.886432+00	2025-04-11 03:33:04.886432+00	2025-04-10 16:59:31+00	f	mmf153v
c2808f91-e612-4783-9963-fef8e21bd8b1	c3b07639-3763-488f-920c-3182facbf284	t2_46izuqga	I miss Portland man	3	\N	2025-04-11 03:33:04.889697+00	2025-04-11 03:33:04.889697+00	2025-04-10 15:51:39+00	f	mmenbjj
5d274204-6cf8-4b41-8d49-3225d6d46a01	c3b07639-3763-488f-920c-3182facbf284	t2_2a9stiwu	I might have saw you pass as I walked my dog on SE 14th near Morrison yesterday.  I remember thinking, cool camera!	1	\N	2025-04-11 03:33:04.893026+00	2025-04-11 03:33:04.893026+00	2025-04-10 16:43:26+00	f	mmexuz0
69acdb9b-3b39-4ba7-bfb1-268164af89c5	c3b07639-3763-488f-920c-3182facbf284	t2_8d1h1	This is beautiful	1	\N	2025-04-11 03:33:04.896121+00	2025-04-11 03:33:04.896121+00	2025-04-10 17:21:07+00	f	mmf5m4v
16114578-d4cc-4e85-b346-ae3411ea2727	c3b07639-3763-488f-920c-3182facbf284	t2_1cz59tledg	Big Pink takes on a new meaning	1	\N	2025-04-11 03:33:04.899238+00	2025-04-11 03:33:04.899238+00	2025-04-10 20:59:08+00	f	mmgeguo
d0e97280-6a54-4776-805d-8cd0fdd6c78b	c3b07639-3763-488f-920c-3182facbf284	t2_4ydgo	Oh man. Thank you for this. I haven’t spent much time in Portland but I absolutely love driving down these roads. ❤️	1	\N	2025-04-11 03:33:04.902301+00	2025-04-11 03:33:04.902301+00	2025-04-10 21:17:13+00	f	mmgi0kq
de2d4bd5-3f80-4fe5-b615-591ff93ee80a	c3b07639-3763-488f-920c-3182facbf284	t2_14zrt1	Impossible for me to ride a bike in our neighborhood greenways in the Spring without smiling.	1	\N	2025-04-11 03:33:04.905474+00	2025-04-11 03:33:04.905474+00	2025-04-10 22:24:58+00	f	mmgukxb
b8e4bf0e-cbf5-48c2-b896-3732a03b5958	c3b07639-3763-488f-920c-3182facbf284	t2_47q8uf48	Some of us would be propelled backwards rapidly by forceful sneezing alone. Perhaps if we pedaled we could simply stay put. \n\n  \nI used to live a block from there, really lovely to *look* at in spring.	1	\N	2025-04-11 03:33:04.908831+00	2025-04-11 03:33:04.908831+00	2025-04-11 01:18:17+00	f	mmhnt9u
9aaa1c90-fc31-4c53-922d-b3c2f454b348	c3b07639-3763-488f-920c-3182facbf284	t2_n4kfdzix	That is THE bike ride that I take the most! Gives me riding through my neighborhood in the 90s vibes.	1	\N	2025-04-11 03:33:04.912044+00	2025-04-11 03:33:04.912044+00	2025-04-11 01:53:16+00	f	mmhtf8r
8b6fda3e-4750-4c21-a670-5f9b3ae8de46	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_ul68190p	I’m so sorry for everything you’re going through. Right across the bridge from Portland, in Vancouver, try calling the Queer Youth Resource Center, if you’re under 24, they may be able to help.	88	\N	2025-04-11 03:33:18.78739+00	2025-04-11 03:33:18.78739+00	2025-04-10 13:44:18+00	f	mmdy0kj
8f4d9e26-ed55-4a83-9c93-0ad992120c21	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_qjqf3	If you’re on Facebook, post in the PDX anarchist buy nothing group. Tons of folks have suggestions and resources on there. \nSo sorry you’re going through this. It sounds like you’ve had a tough year ❤️‍🩹	232	\N	2025-04-11 03:33:18.789653+00	2025-04-11 03:33:18.789653+00	2025-04-10 13:49:02+00	f	mmdyw1d
e8b7ce0b-c63c-4fba-9146-c7af2b669372	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_jvadzdse	Here in Portland, reach out to Outside In downtown on 13th Ave.  They specialize in homeless youth, including LGTBQ.  You're doing the right thing by reaching out, stay strong!  🥰	48	\N	2025-04-11 03:33:18.791811+00	2025-04-11 03:33:18.791811+00	2025-04-10 14:09:54+00	f	mme2uyd
7c33880d-6928-4203-b4a1-dd32293fe2b7	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_5jcsg	I'm so sorry about your home life becoming unsafe. That really sucks. \nWhat kind of jobs have you done, do you have work experience? I can help you make a resume so you can at least start getting out of that house and back into the workforce!	47	\N	2025-04-11 03:33:18.794237+00	2025-04-11 03:33:18.794237+00	2025-04-10 13:52:17+00	f	mmdzi1i
34138b10-1e19-4f0f-b003-ac65e94d56dc	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_111ein	Maybe look into WWOOF? You help on a farm or house in exchange for living quarters. Just be careful regardless of what you choose, as someone from a similar background we may not know what is healthy or a red flag. Making some friends can help for mutual safety especially for queer people who may not have good family ties.	46	\N	2025-04-11 03:33:18.796547+00	2025-04-11 03:33:18.796547+00	2025-04-10 14:35:19+00	f	mme7wbb
73dfe960-73ba-4efb-9988-c0efc583db17	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_6dk6i	I have a room open in my north Portland house and we need someone to fill it by the 20th. We're two partnered trans women and me, a nonbinary amab person. we're all queer as hell. Shoot me a message here if you're interested. We'd be happy to take you and Dax in.: [https://www.roomies.com/rooms/709122](https://www.roomies.com/rooms/709122)	44	\N	2025-04-11 03:33:18.798585+00	2025-04-11 03:33:18.798585+00	2025-04-10 17:37:32+00	f	mmf91xf
6a177fa5-e797-44cd-88f6-ea25a73b78c7	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_6lqdky50	Grits &amp; Gravy is pretty good, kind of a trendy diner with great southern style food and they are open for dinner hours Wednesday through Sunday. \n\nIf you are wanting a more nostalgic, old-timey diner experience try Fuller Coffee Shop or John’s Cafe (cash only!), but neither of those two options is open for dinner hours. \n\nAll three are on the westside in the downtown area, a quick walk from TriMet	2	\N	2025-04-11 03:33:27.241072+00	2025-04-11 03:33:27.241072+00	2025-04-10 22:41:14+00	f	mmgxfda
f94ec79f-7c79-4a6b-a5c9-a51c2b8a6f72	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_1ug8ol1n	I feel for you and Dax. I know you are drowning right now and everything probably feels impossible, but things will get better. Hang in there!\n\nI'm hoping some of the resources people posted can help you. But just a word of caution: be careful. There are slimy people out there who will take adantage of you because they know you need to escape a bad situation.\n\nAlso - can you find a grief support group? Maybe one that meets on Zoom calls? Being around people who understand what you are going through and support you will make you feel understood/heard and that is *so* important. If you search for "grief support group Oregon" you can find many options.\n\nFinal note: if you need pragmatic help doing small things like editing your resume, I could help with that (ChatGPT is honestly pretty good too). Are you looking for jobs in Portland? Or are you in a space where that's not even on your radar right now? When I've felt hopelessly behind/overwhelmed by life, often the best thing I can do is pick one small thing and accomplish it. Check out Tiny Habits by Dr. Fogg. He has a free program where he will get on phone calls with you and sometimes just hearing a friendly / supportive voice can be good (same goes for grief support group!).	13	\N	2025-04-11 03:33:18.800747+00	2025-04-11 03:33:18.800747+00	2025-04-10 16:53:19+00	f	mmezv9h
1c744f7d-68fe-4fa6-ba04-e1d490d76f25	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_4de9762c	I think Northwesr housing alternatives has pet friendly housing services \n\n(503) 655-8575	10	\N	2025-04-11 03:33:18.80297+00	2025-04-11 03:33:18.80297+00	2025-04-10 13:50:32+00	f	mmdz67s
3e060842-e614-4150-b716-285706d57c1a	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_iskky02k	Apply to Kroger. Say you have open availability and you’ll be hired	11	\N	2025-04-11 03:33:18.804886+00	2025-04-11 03:33:18.804886+00	2025-04-10 16:51:07+00	f	mmezf2e
bbd51be9-ad91-4e0c-8b68-4c3729b66f47	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_9igtz6vh	So sorry you're going through this! I would try to find a live-in caregiver job. It gives you housing and then pays you to care for someone you live with. Great way to earn money and have a roof over your head while you recover. Best of luck!!	20	\N	2025-04-11 03:33:18.806851+00	2025-04-11 03:33:18.806851+00	2025-04-10 13:56:41+00	f	mme0c6j
d91548e1-5f2c-4a20-abd1-4141cd8a87ea	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_166u5b51z5	Tou can try calling 988. It’s a free crisis line and they can provide resources in your area. It sounds like you have more to talk about than just finding a safe place to stay. \n\nI’m sorry to hear of your loss, I hope you and Dax are able to find peace.	8	\N	2025-04-11 03:33:18.80879+00	2025-04-11 03:33:18.80879+00	2025-04-10 15:27:14+00	f	mmeie2g
093b57cd-73a2-4109-89ac-75d3f826e927	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_155iqt	Not dramatic at all- you’ve lost so much so quickly. I’m so sorry you are going through all this. This is devastating. I created a loose “grief gang” group for people who are experiencing loss, the discord link is: https://discord.gg/Z8NC66Nh\n\nThe group is Portland/Vancouver based, and I know there are people in transitional housing situations that may have a place for you or resources that can help. I don’t have housing suggestions, but myself (and others in the grief gang I’m sure) could help you move. At the very least, it’s a safe space to vent about all of this and meet some friends locally who feel safe. \n\nPeople in Portland are so friendly and understanding. When I reached out for help here on Reddit, the responses were overwhelming. I hope you have the same experience as I did ♥️	7	\N	2025-04-11 03:33:18.810924+00	2025-04-11 03:33:18.810924+00	2025-04-10 17:18:58+00	f	mmf55w4
c6da6f2b-36da-4318-9f72-b43c3de8b580	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_dvxzp	Check out the Portland queer housing group on Facebook. And check all the buy nothing groups as others mentioned. If you find a place and need starting supplies, Dm me if you need an air mattress I can give one along with sheets comforter pillows and extra storage furniture for a bedroom. I don’t have reliable space though as I’m moving. I can give food as well  to help with the transition.	6	\N	2025-04-11 03:33:18.812824+00	2025-04-11 03:33:18.812824+00	2025-04-10 17:40:05+00	f	mmf9l23
dbb5acd9-70c7-4ff6-9edf-2857e58ee047	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_6geys27r	I'm so sorry you're going through this. Defiantly listen to some of the comments about home options. Especially live in care giver or those work programs. I also suggest calling Homeforward and talking to them about your options. They're a low income/housing kinda help program most of portland area/s section 8/hud housing programs use.\n\n  \nIf you need help with resume reach out to me, I'll gladly help build you one to use to apply for jobs. If you just want a friend in the area to talk to and we can go on walks just to get out please reach out. Grief is hard on your own in a new area and not having friends can be rough.	3	\N	2025-04-11 03:33:18.814733+00	2025-04-11 03:33:18.814733+00	2025-04-10 17:01:42+00	f	mmf1l9g
1b5873d3-52cd-4bb8-8dd5-0d30e3094e4c	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_19jg1jlqh7	You might look at park ranger jobs or something that provides housing for the summer . Gives you a chance to same up and make plans. Also it's good healthy work. \n\n\nUnfortunately I'm not sure what is out there at the moment though. My friend lived in Alaska a few summers and had good times doing trail work.	13	\N	2025-04-11 03:33:18.816884+00	2025-04-11 03:33:18.816884+00	2025-04-10 13:50:26+00	f	mmdz5jb
8e2fdcdd-891e-4e5e-b064-c9474ec2170d	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_1jnt6wh6tz	Hi sweetheart. First, I am so sorry for what you're going through, I can't imagine losing my partner and being in this world, at this time, especially queer, alone. \nMy partner and I are new to Portland. As much as I wish I had stable housing to potentially offer you, or even great resources, I don't. \nI can offer you a shoulder to lean on. You're welcome to message me any time for any reason. I am in my early 30s, female, and queer.  I am "Cali sober."(I use cannabis, but currently, my financial situation doesn't allow for that). \nI hope that you find somewhere safe, or at least some good resources.  I'm sure some people on this thread will have those for you.\nHang in there.\nYou're NOT alone. Things will get better if you work at it.	12	\N	2025-04-11 03:33:18.818849+00	2025-04-11 03:33:18.818849+00	2025-04-10 14:30:51+00	f	mme6zyx
7f6ffc98-f2e8-4033-98cd-ae39115bf741	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_16c55uou1t	Commenting to boost 💜 please keep your chin up, friend, you can do this. And I’m so sorry for your loss.	12	\N	2025-04-11 03:33:18.820697+00	2025-04-11 03:33:18.820697+00	2025-04-10 13:44:53+00	f	mmdy4bf
0847b65b-15fa-458e-85a4-b0334234ec29	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_2qvznld3	I don’t have any advice or suggestions but I hope some of the other comments give you the resources you need. Best vibes for the future for you &amp; Dax.\n\n(Edit: wrote an, meant any, fixed it)	6	\N	2025-04-11 03:33:18.822481+00	2025-04-11 03:33:18.822481+00	2025-04-10 14:25:17+00	f	mme5vrv
0b2ada74-ed40-477d-af5b-d464a9814900	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_1ezi73	Sending love. I know it's not all you need, is what I got to give.	7	\N	2025-04-11 03:33:18.824404+00	2025-04-11 03:33:18.824404+00	2025-04-10 14:00:59+00	f	mme15o1
d3045153-d5ce-476c-a0b8-37f342e597f5	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_7loxvigr	Hey, I'm really sorry to hear you're going through this. I dread facing the same, or leaving my partner to do so, so I feel for you. I don't have the resources to share with you, as far as places I know are safe, but Portland should have resources (off the top of my head Street Roots is the only example I can offer).\n\nKeep your head up, because you can absolutely make it through this, even if it's the hardest thing you've ever faced. I know you can. Keep that fire burning, and don't let anyone take it from you.	3	\N	2025-04-11 03:33:18.826577+00	2025-04-11 03:33:18.826577+00	2025-04-10 14:15:58+00	f	mme414x
c484aaf2-8b4c-4d5e-bf7d-9b1b0ce6a0bc	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_19cfuchlpn	Would you consider Vertical Diner? It’s great for vegans and vegetarians - but it’s great for everyone else too! Get the Buffalo Tigers.	1	\N	2025-04-11 03:33:27.244114+00	2025-04-11 03:33:27.244114+00	2025-04-11 01:41:51+00	f	mmhrla6
89f256c6-3584-4092-8b18-6520f26f10cf	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_4jid17ii	Tom’s Pancake House (the owner Greg is just the best) or 60s Cafe &amp; Diner (very friendly owners as well. They gave me tater tots for free)!!	1	\N	2025-04-11 03:33:27.247186+00	2025-04-11 03:33:27.247186+00	2025-04-11 02:44:04+00	f	mmi1f42
cb291e72-cc07-44fe-a5f1-429dd09024bf	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_cmqsw	Oh man. Grief is such a difficult thing, and to be dealing with it on top of an inadequate support network is that much worse. \n\nI'm so sorry for your loss and ongoing difficulties. \n\nThings can get better, and I'm sure you know this, time helps but only as much as you let it. \n\nI'm glad you are reaching out.  Do you hope to land in Portland or are you wanting somewhere more rural? What kind of work are you hoping to move into? Do you have a car?\n\n Do you have any hobbies or sports you play? Perhaps getting involved in one of those communities locally can help you get out of your dad's house more.\n\nThere are some online education resources that could help you get a certificate to be better qualified for certain jobs, that could be something to focus on while finding safe housing. I think most can be done with a phone. If you're interested in that DM me and I'll help you out. I would love to offer you a place to stay but I'm in transition right now myself and am not able to currently. \n\n\nMostly I just want to feed you and hug you. But I can't so I've tried to offer some tips. I really feel for you and hope you get what you need.	2	\N	2025-04-11 03:33:18.828609+00	2025-04-11 03:33:18.828609+00	2025-04-10 17:51:53+00	f	mmfc2mi
07051f6e-7d12-48e3-924d-a4fb67bb3fda	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_6zas4uzi	Sending love - feeling heartbreak and greivous loss myself. Hold on, brother, hoping you find a safe space soon.	2	\N	2025-04-11 03:33:18.830732+00	2025-04-11 03:33:18.830732+00	2025-04-10 18:12:07+00	f	mmfgaav
d16afa1c-f449-420d-aa77-7afac1888a65	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_c02a6qja	Look into the Q center in Portland for queer-centered resources and connections. Longer term if you like music, check out Portland Gay Men’s Chorus to build community (not just for men).\n\nhttps://www.pdxqcenter.org\n\nhttps://www.pdxgmc.org/about/sing-with-us/	2	\N	2025-04-11 03:33:18.832596+00	2025-04-11 03:33:18.832596+00	2025-04-10 18:54:11+00	f	mmfowmo
b5abea4d-6104-4fb5-af3f-d98dcb6f59b6	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_363twqzf	Q Center https://www.pdxqcenter.org/\nIt's a call for appointment now,but hoping for the best for you all ❤️	2	\N	2025-04-11 03:33:18.834443+00	2025-04-11 03:33:18.834443+00	2025-04-10 20:04:36+00	f	mmg36fi
65176a33-17c1-4d15-9a86-bdd31e49a1de	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_9y3dx	My cat is Dax too. We send you the best of luck &lt;3 [https://imgur.com/a/lqh2REs](https://imgur.com/a/lqh2REs)	1	\N	2025-04-11 03:33:18.836324+00	2025-04-11 03:33:18.836324+00	2025-04-10 22:09:56+00	f	mmgrwjp
8ce697fb-c6f3-47eb-883b-d68f89f87bdf	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_y94wo	Ugh, La Pine is one of the worst places to be in this state. I’m so sorry. The ache is real with this loss. I wish I had more to offer than a Hello and I see you.	1	\N	2025-04-11 03:33:18.838308+00	2025-04-11 03:33:18.838308+00	2025-04-11 00:15:48+00	f	mmhdnpc
585dc607-203d-4d3a-881b-fcac43dfa738	6a4d199b-5021-44fb-b32a-3926227b5e8d	t2_t49rvv0	I just sent you a DM. I don’t have a place for you but I do have two small things to offer that might help. Details in my message. I’m so sorry for everything you’re going through. I’ll be thinking of you. 💜	1	\N	2025-04-11 03:33:18.840103+00	2025-04-11 03:33:18.840103+00	2025-04-10 17:16:46+00	f	mmf4p8d
f54ef2d1-111c-4bab-885c-77b7119b247e	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_79xvq	Clyde's Prime Rib!	61	\N	2025-04-11 03:33:27.183813+00	2025-04-11 03:33:27.183813+00	2025-04-10 22:58:00+00	f	mmh0dzj
1562831c-b169-4052-a3de-15d3e0104328	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_wyak4	Sayler's Old Country Kitchen over on SE Stark at 105th has been a purveyor of fine steaks since 1946. It's a Portland tradition for many folks. Not fancy, but consistent.	68	\N	2025-04-11 03:33:27.187459+00	2025-04-11 03:33:27.187459+00	2025-04-10 22:45:15+00	f	mmgy4rk
074e55d0-4106-481d-879c-e869e039749f	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_3lg3qfa	Clyde's!	17	\N	2025-04-11 03:33:27.190939+00	2025-04-11 03:33:27.190939+00	2025-04-10 22:59:17+00	f	mmh0m6v
c4f54348-944c-42d3-b71f-e168c5e716fa	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_1i3enfevbb	Congratulations!	14	\N	2025-04-11 03:33:27.194308+00	2025-04-11 03:33:27.194308+00	2025-04-10 22:54:48+00	f	mmgztpg
271bcd82-5b32-4e48-850b-570a9f5d9489	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_1t3m7be	Huber's	17	\N	2025-04-11 03:33:27.197444+00	2025-04-11 03:33:27.197444+00	2025-04-10 22:53:37+00	f	mmgzm6g
d655a799-9451-4c2d-a4bc-f4ed9385a844	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_1b5jtsct	[Skavone's](https://sckavonesrestaurant.wordpress.com/sckavones-menus/) should do the trick.	16	\N	2025-04-11 03:33:27.20055+00	2025-04-11 03:33:27.20055+00	2025-04-10 22:46:14+00	f	mmgyaxj
b6e66e4b-f224-447c-a088-f63d9fc24e1f	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_jvadzdse	Maybe Clyde's on NE Sandy (do the restaurant tonight, you can do the bar on another visit) or Sayler's Old Country Kitchen by Mall 205.	16	\N	2025-04-11 03:33:27.203611+00	2025-04-11 03:33:27.203611+00	2025-04-10 22:47:23+00	f	mmgyi96
93f24750-1ff2-4b27-95c3-e6764198ed45	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_wyak4	If you just want a diner experience go to Tom's on 39th &amp; Division or Fuller's downtown. Or catch a slice of true Americana at My Father's Place on Grand Ave around 1am.	12	\N	2025-04-11 03:33:27.206875+00	2025-04-11 03:33:27.206875+00	2025-04-10 23:03:21+00	f	mmh1by0
fb4cdc5c-dfe6-4eac-9019-570b9e1afde9	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_atfhy	If you feel up to a separate trip, Lauretta Jean's is the best pie in town but Pie Spot makes pie milkshakes! I don't know if either has apple pies at the moment, but maybe.	6	\N	2025-04-11 03:33:27.209845+00	2025-04-11 03:33:27.209845+00	2025-04-10 23:11:31+00	f	mmh2r5d
6cc9f657-ede9-4ed4-af50-62e51fc3a72e	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_668wi1i0	Skyline Diner! They've got amazing milkshakes, can do drive-in or dine-in style eating, and it's as American as you can get. Definitely not fancy, though, so if you're looking for upscale might want to give it a pass.	10	\N	2025-04-11 03:33:27.212835+00	2025-04-11 03:33:27.212835+00	2025-04-10 23:15:44+00	f	mmh3hao
6de581db-92ae-4639-8687-33a21646dba2	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_1dq13pl	Clyde's is great!\n\nFor a breakfast American diner you can't go wrong with My Father's Place ( dive bar and breakfast diner at the same time ), Original Hotcake House, or Gateway Breakfast House ( I think this is the one Obama visited when he was here during his term )	4	\N	2025-04-11 03:33:27.215757+00	2025-04-11 03:33:27.215757+00	2025-04-10 23:01:54+00	f	mmh12ny
2a3a28ca-20ce-4e4d-838f-7063e47cb909	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_xvwkf	I haven't been there in years, but I feel like Nite Hawk is the experience you're looking for.	5	\N	2025-04-11 03:33:27.218679+00	2025-04-11 03:33:27.218679+00	2025-04-10 23:04:00+00	f	mmh1g0l
9797d413-7ae0-4abf-b88b-3fcc69a3736c	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_6uu8d	Huber's Cafe downtown. Has been run by the same family for over 100 years. The food is fantastic the atmosphere is historic although it does get a little loud in there but you can ask to sit in the front dining room which was much quieter. \n\nThey were made famous back in the early 1900s for serving turkey sandwiches while people played cards. \n\nFrom there they started serving ham and turkey dinners and they've been going ever since. \n\nMake sure you get a Spanish coffee it's fantastic and leave a good tip because they put on a good show when they make it!	4	\N	2025-04-11 03:33:27.222336+00	2025-04-11 03:33:27.222336+00	2025-04-10 23:25:26+00	f	mmh55i8
54e56a8c-29f5-45ad-a8f7-db4b019eeb5e	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_mj307pjt	Sayler’s or Clyde’s	4	\N	2025-04-11 03:33:27.225769+00	2025-04-11 03:33:27.225769+00	2025-04-10 23:47:26+00	f	mmh8vkx
a8541d65-c896-465d-b4b8-378e0cfa8ab9	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_f0gxl	Maybe a bit of a drive but the carver hanger	2	\N	2025-04-11 03:33:27.228959+00	2025-04-11 03:33:27.228959+00	2025-04-10 23:07:05+00	f	mmh1zb7
9292cb6a-78ec-4e86-8cd8-f9c1ae9a7479	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_czzo0ad7	Saylor’s!  Clyde’s is a close second.  If you go to Saylor’s.. they give you a scoop of ice cream (included with a meal) at the end… get the spumoni ice cream flavor!	2	\N	2025-04-11 03:33:27.231958+00	2025-04-11 03:33:27.231958+00	2025-04-10 23:57:27+00	f	mmhakw9
416ac5bb-9a2f-4a0e-9814-68fc12623a0e	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_90zkb	Congratulations!! For BBQ I highly recommend Miss Delta on Mississippi Ave (North Portland). They have incredible fried chicken, chicken &amp; waffle, mashed potatoes with the skin on, and amazing Mac &amp; cheese. They have a lot of other traditional BBQ meats on the menu, but I've tried all the specific stuff I listed. It also has good American diner vibes	2	\N	2025-04-11 03:33:27.234973+00	2025-04-11 03:33:27.234973+00	2025-04-11 00:24:07+00	f	mmhf0tb
a50bbf7b-ac07-434b-80ae-e72471eeb465	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_ez04y3cs	Mother's Bistro downtown	3	\N	2025-04-11 03:33:27.238103+00	2025-04-11 03:33:27.238103+00	2025-04-10 22:39:15+00	f	mmgx2vn
2951545f-8e51-4307-ba8a-cc81e03319f3	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_nfcolw2b	Y’all are awesome! Had to take our kitty to the vet short notice but will definitely hit some of these up over the next few weeks.	1	\N	2025-04-11 03:33:27.250243+00	2025-04-11 03:33:27.250243+00	2025-04-11 02:45:56+00	f	mmi1p99
f294fc30-b217-450c-acc9-1d744425c442	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_85ht5	Bannings in Tigard. Really good food and apple pie. :)	1	\N	2025-04-11 03:33:27.253666+00	2025-04-11 03:33:27.253666+00	2025-04-11 03:27:07+00	f	mmi7maj
760f2140-1d6d-4dc7-a2c4-561f5dfbd88c	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_f3zpr	Ringside! I'd love a reason to go. All American steak dinner. Congrats, on your dual citizenship.	2	\N	2025-04-11 03:33:27.257259+00	2025-04-11 03:33:27.257259+00	2025-04-10 22:37:49+00	f	mmgwtwt
6de109ef-631a-4c0e-a11e-2c385b4fb908	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_wyak4	Take yourself downtown &amp; try Portland City Grill at the top of the (soon to be not) US Bancorp Building. It's a bit of a splurge, but the views are spectacular, even on a rainy day.	0	\N	2025-04-11 03:33:27.26038+00	2025-04-11 03:33:27.26038+00	2025-04-10 22:52:15+00	f	mmgzdfc
1fc50e85-ef51-4307-82ce-fc20e7f6c513	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_wyak4	Papa Haydn in Sellwood only has one steak on the menu, but many other solid classics, like a pork chop. Their desserts are unmatched. Another Portland institution since 1978.	0	\N	2025-04-11 03:33:27.263437+00	2025-04-11 03:33:27.263437+00	2025-04-10 22:57:12+00	f	mmh08y0
4006af68-fb8e-4f64-b465-ad69993da50b	ca53424a-6500-4357-9bc3-cf27a44d6758	t2_l559btzf	Black Bear Diner	0	\N	2025-04-11 03:33:27.266428+00	2025-04-11 03:33:27.266428+00	2025-04-11 00:07:06+00	f	mmhc7ce
5c0c56df-7e9d-406c-837f-76daefd85260	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_bz1kk	It's funny to me just how much people talk about Portland when it's so *normal*. Lots of pretty trees and some businesses with funny names, but most day to day things about Portland are completely standard. \n\nSo glad you're enjoying your visit! You picked the perfect time of year, the weather has been lovely this spring.	36	\N	2025-04-28 00:16:42.43492+00	2025-04-28 05:54:45.31707+00	2025-04-27 22:50:42+00	f	mpe4dzo
74849aaa-cec6-4c38-939c-b58d27c6d40e	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_x0zk	Probably worth saying that this is a particularly auspicious time of year to visit Portland and the PNW in general.  Everything is in bloom with greenery overflowing everywhere and most of us are a still a little stunned and starstruck at the reappearance of the sun and reasonably cheerful weather.  \n\nThat said, having lived in other big cities and in different countries, I've never been on the Portland as a post-apocalyptic hell-hole bandwagon in the first place, so maybe I'm a little biased.	15	\N	2025-04-28 00:16:42.450128+00	2025-04-28 05:54:45.326796+00	2025-04-28 00:00:36+00	f	mpegdpv
ec56e4c5-e9a2-4c4d-b7ab-84aed4a9f243	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_92u1i	I'm guessing your conservative family members are older and watch Fox news? There are people living here who were convinced the entirety of Portland was burning because of "riots and lawlessness on the streets" because Fox news was running with that 24/7 for a while. I had patients who wouldn't be convinced otherwise, and I'm like "I live in Portland...do I look like I'm on fire right now?"\n\nSo now we're back to Portland being vilified on the news and the cycle continues.\n\nPortland really is a nice city with lots to do, and the surrounding areas are amazing for outdoorsy people.\n\nPeople hating on Portland is like people hating on the Midwest, you know? Calling all the Midwest "flyover Monsanto states with nothing but corn and cow shit". That wouldn't be remotely accurate.	21	\N	2025-04-28 00:16:42.44346+00	2025-04-28 05:54:45.346274+00	2025-04-27 22:45:29+00	f	mpe3giu
a2be2650-9229-4563-9d7b-3c4d5480792a	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_186w0fp4	It's almost like it's a propaganda campaign against one of the nicest cities in the country that happens to have a ton of queer and progressive folks, a lot of whom are anticapitalist.	152	\N	2025-04-28 00:16:42.428453+00	2025-04-28 05:54:45.321938+00	2025-04-27 22:35:00+00	f	mpe1iu5
984ccf6c-14fb-4dd0-a1cd-b359db0e231d	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_zvv246l3g	Yeah, my parents in Iowa were pretty shocked when they actually visited	66	\N	2025-04-28 00:16:42.425225+00	2025-04-28 05:54:45.312432+00	2025-04-27 22:23:27+00	f	mpdze1c
d7e8a49c-28eb-4469-950b-dd5d45edcd56	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_n62oysdu	That is all??? No, come on now, we've been through a lot here with all the Trump and Fox News demonizing ... compliment us some more, please!	28	\N	2025-04-28 00:16:42.431597+00	2025-04-28 05:54:45.351019+00	2025-04-27 22:13:48+00	f	mpdxn5o
cea37d14-111f-4fb0-9fcd-881ee5950177	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_5qk14fog	I'm curious to hear what you've enjoyed while visiting	5	\N	2025-04-28 00:16:42.440028+00	2025-04-28 05:54:45.36567+00	2025-04-27 22:18:23+00	f	mpdygsh
ccf9e43e-e877-4264-8226-4b48a396422c	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_3olc5gnu	You don't need to tell us. We live here. You should be telling this to your Midwest conservative family members	5	\N	2025-04-28 00:16:42.451889+00	2025-04-28 05:54:45.380475+00	2025-04-27 23:17:21+00	f	mpe909g
3345d546-ce28-4995-8c24-dcc7bccb60e9	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_195ts0jwox	OP - check out Washington Park while you’re here. Follow the signs for the arboretum. Wear hiking shoes :)	30	\N	2025-04-28 00:16:42.426871+00	2025-04-28 05:54:45.331729+00	2025-04-27 22:44:40+00	f	mpe3b6w
a34645e0-8a8b-485a-8fea-5895f8381287	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_ygopj	The media really likes to take things to extremes. I've lived in the Portland metropolitan area my entire life and moved to Portland proper 5 years ago. I've loved it for years and love it even more living here. Thank you for your kind words.	5	\N	2025-04-28 00:16:42.446589+00	2025-04-28 05:54:45.355995+00	2025-04-27 23:31:33+00	f	mpebg82
118f4245-1d23-4183-ab0f-a0b46aeb9b7a	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_3b26rfa5	Thanks. Let's keep this to ourselves, don't need anyone spilling the beans and having a bunch of conservatives find out they've been getting lied to and learning it's not non-stop mayhem around here.	8	\N	2025-04-28 00:16:42.441867+00	2025-04-28 05:54:45.390485+00	2025-04-27 22:16:04+00	f	mpdy1uz
af6bb41a-9dbe-4be4-abc7-4b96be8638ff	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_8m0wnruu	You missed the old city, before the entire place burned down. It was just like FOX News described it then. People died by the thousands...	7	\N	2025-04-28 00:16:42.438246+00	2025-04-28 05:54:45.385591+00	2025-04-27 23:11:26+00	f	mpe7zmy
1d92b7b4-f2f1-41d2-8b08-8771cffdfe13	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_u4cs4	It's truly unbelievable how delusional people are. I'm so glad you fought through (lol) all the propaganda and came and enjoyed it! You are welcome back any time : )  and we are proud! I've been here over 30 years now, seen a lot of change and still and always love my city.	5	\N	2025-04-28 00:16:42.436434+00	2025-04-28 05:54:45.426702+00	2025-04-27 23:01:22+00	f	mpe69d6
9621bf31-fb2b-4035-bf57-f12dad36527d	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_vogpg3w9	It's all culture war bs. Portland outside of a few select areas is great. Just don't expect the police to ever come.	26	\N	2025-04-28 00:16:42.433179+00	2025-04-28 05:54:45.360924+00	2025-04-27 22:20:16+00	f	mpdyt2p
1cb4c5d4-6491-420e-a803-8a651b934628	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_4vq8k32g	It has its down. I’m not gonna lie. We have a homeless community, but the city is beautiful.\n\nThese people are just trying to survive, so who are we to judge? We don’t know their story. We don’t know everybody on the streets.	1	\N	2025-04-28 00:16:42.448433+00	2025-04-28 05:54:45.471753+00	2025-04-27 23:51:39+00	f	mpeevcf
d288f3a9-a1a1-4219-9efc-7605b99d515c	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_7nvp11r2l	I love Portland and I love people who love Portland.	64	\N	2025-04-28 00:16:42.430026+00	2025-04-28 05:54:45.292406+00	2025-04-27 22:47:14+00	f	mpe3rq7
3a67f538-45ee-4fd6-b661-1dd1fb8ce5f6	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_iukms	Living here, us Portlanders criticize Portland all the time, but for the mundane stuff, like potholes not getting fixed. It's wild that a political party gets away with making our city a scapegoat for their fundraising efforts.	22	\N	2025-04-28 00:16:42.445021+00	2025-04-28 05:54:45.30255+00	2025-04-27 23:09:16+00	f	mpe7mbc
154aea2b-2a68-4682-add2-1f2af44f6949	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_8itijzo4	Could you try staying in an Airbnb in Portland for a week or two to try out the commute? \n\nI know that’s an expensive suggestion but it might be nice to test out commute times and your energy level for doing fun things after work	44	\N	2025-04-28 00:17:04.155908+00	2025-04-28 00:17:04.155908+00	2025-04-27 02:00:00+00	f	mp8woq7
34e72f7e-4ba9-4a08-85b0-f1a3662699b4	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_3sbwjjxw	It sounds rough. For me any commute over 30 minutes puts me on the verge of a mental breakdown but for some it’s no big deal. \n\nI think the best thing to do is to be very honest with yourself and really think about it long term. Maybe you could handle it for a month but could you really handle it for a year or more. I don’t think anyone else can answer that for you.	14	\N	2025-04-28 00:17:04.158564+00	2025-04-28 00:17:04.158564+00	2025-04-27 02:30:26+00	f	mp91apc
47f51101-aa8e-41c5-80c8-453f734e4f45	c8025fda-8490-43bc-93ac-cda53581687d	t2_p4ll3igpt	Go yell! Literally walk the streets yelling his name! Rattle the treat bag! \n\nI’ve had a few indoors escape. They won’t go too far. You just have to find them now. Any smell, their blanket, take it outside.\n\nFeel no shame in the search. He’s within a 1/4 mile of you. If you wake people, tell them you want your cat back. They will help.\n\nBest thing you can do now if you don’t get him back with treats and smell is set everything he sleeps on on the front porch. Everything. Food, water, blankets. He will smell it back. Stay awake and grab him when he comes on the porch	21	\N	2025-04-28 00:16:50.579021+00	2025-04-28 02:41:45.578526+00	2025-04-27 06:14:46+00	f	mp9tqw2
8b422e40-53bd-4a37-b62a-d00b528bd73b	c8025fda-8490-43bc-93ac-cda53581687d	t2_5p9tk	Aww, that sweet face! Bump to the top!! Hope you two are connected soon.	12	\N	2025-04-28 00:16:50.581417+00	2025-04-28 02:41:45.585985+00	2025-04-27 04:51:42+00	f	mp9kn7c
f7bb3801-c3b0-4079-b23f-84e439886374	c8025fda-8490-43bc-93ac-cda53581687d	t2_qzmwnkvi	Boosting this. Let’s find this handsome geriatric one-eyed feline. ♥️	6	\N	2025-04-28 00:16:50.583487+00	2025-04-28 02:41:45.593292+00	2025-04-27 05:23:50+00	f	mp9ob6x
60afab4e-a133-4b98-9e44-ab63be5baa08	c8025fda-8490-43bc-93ac-cda53581687d	t2_j9q2n4l	https://www.wikihow.com/Find-a-Lost-Cat\n\nI hope you find Simon. Be sure to check near your house; you might be surprised, especially if he is not an outdoor cat. He might not have gone very far (this happened to my cat, who was a long-haired Siamese and got out by punching out a screen—he was found in a neighbor’s yard two hours later).	6	\N	2025-04-28 00:16:50.5855+00	2025-04-28 02:41:45.600885+00	2025-04-27 05:30:03+00	f	mp9ozrg
864fadab-3983-43ed-a543-87230bd72a83	c8025fda-8490-43bc-93ac-cda53581687d	t2_1i9lvril	Senior pets are so precious 💕 I hope you’re reunited quickly!!	4	\N	2025-04-28 00:16:50.587276+00	2025-04-28 02:41:45.608204+00	2025-04-27 05:32:05+00	f	mp9p7pt
bb7cd519-db2d-40fa-9fc5-f74f5b15d973	c8025fda-8490-43bc-93ac-cda53581687d	t2_1cq2jfk2el	Come home Simon!!!	3	\N	2025-04-28 00:16:50.589263+00	2025-04-28 02:41:45.615575+00	2025-04-27 05:49:09+00	f	mp9r288
9a1cc641-32a0-4348-8320-7d29378b18aa	c8025fda-8490-43bc-93ac-cda53581687d	t2_c5hvueip8	POSTING FOR PUBLICITY!!\n\nBOOSTING FOR A REUNION!!	3	\N	2025-04-28 00:16:50.591488+00	2025-04-28 02:41:45.622555+00	2025-04-27 06:10:38+00	f	mp9tbei
70fbeecf-6244-4376-9155-bbb4014a0dfc	c8025fda-8490-43bc-93ac-cda53581687d	t2_rfc2fz55	Please take the advice to patrol with sounds and smells he'll recognize. Please let us know when you find him.	4	\N	2025-04-28 00:16:50.593965+00	2025-04-28 02:41:45.629756+00	2025-04-27 13:00:39+00	f	mpb184q
4d4e4995-0b48-4485-a643-e6d9147801e4	c8025fda-8490-43bc-93ac-cda53581687d	t2_298dqz7p	This video has some other important things you can do that others haven’t mentioned https://youtu.be/g2eCoC63B9I?si=8kCNvmIPNcRNz97K	3	\N	2025-04-28 00:16:50.596092+00	2025-04-28 02:41:45.634858+00	2025-04-27 16:47:14+00	f	mpc6c2l
1015fc54-4e62-46e0-8e8b-5fb9e9934896	c8025fda-8490-43bc-93ac-cda53581687d	t2_1imaqljvt8	I would try and put his litter box outside if you can. They can smell that from very far away. Also try looking for him at night when it quiets down.	2	\N	2025-04-28 00:16:50.598009+00	2025-04-28 02:41:45.639842+00	2025-04-27 09:35:40+00	f	mpad9l7
3a2871fb-f922-48e5-a615-aa4035ba9ecb	c8025fda-8490-43bc-93ac-cda53581687d	t2_q53d4pva	What a little bud! Fingers crossed for speedy homecoming 🩷	2	\N	2025-04-28 00:16:50.599852+00	2025-04-28 02:41:45.645031+00	2025-04-27 16:38:14+00	f	mpc4lmf
0192b3f7-bbb2-4bea-9034-f4a5e916250d	c8025fda-8490-43bc-93ac-cda53581687d	t2_8nddrcpz	Boosting!! I live in the area and will keep an eye out	2	\N	2025-04-28 00:16:50.601753+00	2025-04-28 02:41:45.650003+00	2025-04-27 17:07:36+00	f	mpcae7n
3b18d7d0-7c10-4a14-8297-f257b57c2d83	8e4f3362-f041-4973-b352-4d5b5e0b120c	t2_174paq	Price went up.	-2	\N	2025-04-28 02:13:14.739678+00	2025-04-28 02:42:39.515076+00	2025-04-27 17:48:03+00	f	mpcinaz
348aeab3-2324-4001-a589-66bf2f57e032	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_5oadqibk	Absolutely!\nAnyone have you-pick recommendations for different seasonal stuff? I've been to Sauvis Island for apples, cherries, strawberries and blueberries, but some nuts or other fruits would be welcome too. \n\n\nBut yes. Love our berry season. 	14	\N	2025-04-28 02:13:27.514241+00	2025-04-28 02:43:00.493197+00	2025-04-27 19:16:03+00	f	mpcztmd
99ef380b-b32b-4b75-991c-3da79a1c18f2	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_u05f4qpy	/heavy breathing	13	\N	2025-04-28 02:13:27.517016+00	2025-04-28 02:43:00.501322+00	2025-04-27 19:15:27+00	f	mpczpje
6b865838-11c4-4da8-9c26-ad931e42681d	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_rm0t3	God when I lived in the valley, I had a bush in my back yard.  It was a pain to fight back, but the amount of cobbler I made on a whim was mind blowing.  We don't see many of these in the central part of the state now, but when I drive over the mountain, I have a few spots I like to stop and pick.	10	\N	2025-04-28 02:13:27.519992+00	2025-04-28 02:43:00.508167+00	2025-04-27 19:17:52+00	f	mpd05wb
32aac7d2-e5eb-4752-81e3-be0aa3e20c84	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_10e5tmyqfh	Berry much! 😁	7	\N	2025-04-28 02:13:27.522297+00	2025-04-28 02:43:00.51614+00	2025-04-27 19:36:32+00	f	mpd3pcc
2938e364-daa7-40b3-94d3-dd094bd19ea0	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_1cyu41o5xk	![gif](giphy|l2YWzsoRQP3fjt6Ks|downsized)\n\nI’m excited for berries for pie!	6	\N	2025-04-28 02:13:27.524198+00	2025-04-28 02:43:00.523629+00	2025-04-27 19:22:01+00	f	mpd0ybc
c3ab5765-84b1-4950-a4dd-06ac6eecea1e	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_9nkie1mb	TY	2	\N	2025-04-28 00:16:42.456124+00	2025-04-28 05:54:45.395406+00	2025-04-27 23:14:01+00	f	mpe8fmf
0285b2ad-529a-4d72-9483-d58a72ca4a45	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_n0o7v9vc	I’m a regular Portland visitor. It “was” a beautiful city for sure. Now, it’s plagued with so much homeless, trash, and lawlessness it makes it hard to like. I hope Portlanders are able to get their city back.	-11	\N	2025-04-28 00:16:42.461641+00	2025-04-28 05:54:45.500777+00	2025-04-27 23:49:32+00	f	mpeei7n
58cc8fa2-c2b7-43e1-801f-6c22a3c91351	f075f22a-1478-4a8c-a1ad-28ee1915b33b	t2_hwutb	Thanks! This and their pickle recipe and baby\n you’ve got a nostalgia stew going.	11	\N	2025-04-28 05:55:19.749788+00	2025-04-28 05:55:19.749788+00	2025-04-28 01:33:07+00	f	mpeveo7
720a99b3-0e9f-4ec6-9240-04601ab135eb	f075f22a-1478-4a8c-a1ad-28ee1915b33b	t2_16152u3z	Thanks. I miss this place all the time.	4	\N	2025-04-28 05:55:19.760114+00	2025-04-28 05:55:19.760114+00	2025-04-28 02:24:12+00	f	mpf3l8q
310fbf28-a66e-482c-8620-924a995848f3	f075f22a-1478-4a8c-a1ad-28ee1915b33b	t2_fgp12	I miss their sabich so much.	3	\N	2025-04-28 05:55:19.767375+00	2025-04-28 05:55:19.767375+00	2025-04-28 03:42:33+00	f	mpff1iv
300b87af-0e81-4fe4-a28f-f02fa7185b5d	f075f22a-1478-4a8c-a1ad-28ee1915b33b	t2_tswiitd	Uh oh. I pronounce it "tap-uhn-AHD". Laughable or not?\n\nThanks for the recipe in any case. I love falafel!	7	\N	2025-04-28 05:55:19.773836+00	2025-04-28 05:55:19.773836+00	2025-04-28 01:36:26+00	f	mpevxwl
093f3429-abe0-4282-92df-fcc8fc9c36f0	82ca34f8-93f4-4ff4-a301-9ff00525a369	t2_28x18o9k	I misread this as "Group Theory" and was very briefly super excited about a math club. Thanks for the crushing disappointment, OP.	8	\N	2025-04-28 05:55:28.035269+00	2025-04-28 05:55:28.035269+00	2025-04-27 18:00:36+00	f	mpcl6hy
ebd73541-e3c8-4a40-83dd-5a554bc4df0f	82ca34f8-93f4-4ff4-a301-9ff00525a369	t2_fvqym	These are such great suggestions	4	\N	2025-04-28 05:55:28.039124+00	2025-04-28 05:55:28.039124+00	2025-04-27 16:51:27+00	f	mpc75sp
53d4ff87-4702-4da5-bcb7-532a16b8f5ef	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_1t23ckfy	I used to live in Pdx and work in Salem. And the commute is not too bad, if you can drive down and back later (or earlier, but it's gotta be EARLIER) than the mob. About forty-forty-five  minutes, I guess!	16	\N	2025-04-28 00:17:04.161743+00	2025-04-28 00:17:04.161743+00	2025-04-27 00:10:29+00	f	mp8fhc3
787561ae-3ab8-4f0f-b457-b01c8b0fa573	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_q0lwifpm	I know a lot of people make this commute, but every time it's mentioned, I think of this sad day [https://www.oregonlive.com/portland/2014/09/in\\_death\\_dr\\_steve\\_fritz\\_rememb.html](https://www.oregonlive.com/portland/2014/09/in_death_dr_steve_fritz_rememb.html)	20	\N	2025-04-28 00:17:04.164225+00	2025-04-28 00:17:04.164225+00	2025-04-27 00:33:26+00	f	mp8j33l
6409f7de-171e-4feb-bfa1-e696a4349ed1	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_6eg0e68t	Will you feel like hanging out in Portland after that commute?	8	\N	2025-04-28 00:17:04.16671+00	2025-04-28 00:17:04.16671+00	2025-04-27 00:57:55+00	f	mp8n052
f076e17b-5066-40f7-b4a4-0afc21f4159f	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_6ne9tzh8	I worked with a guy that has been doing it for 30 years but in reverse.   He never seemed to mind it.	7	\N	2025-04-28 00:17:04.16914+00	2025-04-28 00:17:04.16914+00	2025-04-27 00:35:09+00	f	mp8jczb
1d7e2eb8-73d0-42c9-9225-051e1ce8f9d8	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_wqw1j	I live in Portland and work for the state. I used to have to commute 4 days a week to Salem. After working remotely, I don’t know how I could back to that commute regularly. It can be exhausting. Taking the bus from Wilsonville can help break it up and save on gas/ parking. If you do decide to relocate, I would suggest looking in SW Portland and surrounding burbs rather than inner PDX.	7	\N	2025-04-28 00:17:04.171549+00	2025-04-28 00:17:04.171549+00	2025-04-27 01:26:05+00	f	mp8rdq0
6bd7be24-b229-491b-856a-c62dbfd8d218	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_flt7lpno	I would consider somewhere like Wilsonville so you are pretty close to Portland but have a shorter commute to Salem 	20	\N	2025-04-28 00:17:04.174054+00	2025-04-28 00:17:04.174054+00	2025-04-27 00:27:14+00	f	mp8i3gq
50c157ba-8d33-475f-9f66-d86ee82211c2	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_o19j38tvx	I'm friends with many legislative staffers who live in Portland and commute to Salem. It's definitely doable	4	\N	2025-04-28 00:17:04.176909+00	2025-04-28 00:17:04.176909+00	2025-04-27 01:17:29+00	f	mp8q1tr
b76555fd-5047-40a1-84af-80cd3060637c	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_83g0o	It's the salem to pdx employees commute that is the standstillI. The opposite commute is fine.  I do it all the time. Mornings are a straight 45, pretty easy. It's the curves on the way home that can drag and cause delays. If you can leave Salem by 4:30 instead of 5pm it's much better, but honestly the drive is not bad at all. Throw on a podcast, and time passes quick. The people saying it takes hours are thinking of the live in salem, work in pdx drive.	5	\N	2025-04-28 00:17:04.179517+00	2025-04-28 00:17:04.179517+00	2025-04-27 03:24:20+00	f	mp997x7
9178ce53-858c-4f48-8c8b-a6a0ec871105	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_15ul75	I do the drive often and what sucks is spending an hour in the car coming home then hitting rush hour in portland and taking 30 min to go to the last 3.5 miles. If you were to do it I’d say live in multnomah village, which helps avoid a bunch of the congestion but is still cute and in portland. 	4	\N	2025-04-28 00:17:04.181881+00	2025-04-28 00:17:04.181881+00	2025-04-27 05:01:30+00	f	mp9lsid
db721594-cda7-49d0-b191-f958eb001582	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_razcv	I'm a big fan of &lt;10 minutes commutes, personally. I had a 36 mile commute once in my life and I'd never do it again. One accident, a little ice, someone getting pulled over, etc and your commute time multiplies. I'd much rather commute for fun than work. If the weather is bad, you're probably not going out anyways. If you do it, maybe pick a town in-between but then you're not close to anything. There is differing cost of living as well. A quick search says the COL is 17% higher in Portland. Your gas and car wear &amp; tear is higher. You shouldn't consider your time free (4 extra hours per week in your car). Your pay will remain the same since you're keeping your job. It's a lot to consider.	4	\N	2025-04-28 00:17:04.184497+00	2025-04-28 00:17:04.184497+00	2025-04-27 09:05:37+00	f	mpaahou
f58223d6-de3d-4021-815c-3f2ca75e612e	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_em3kl	I wouldn’t do it. but if you want to give it a try, go for it. set yourself up so you can’t change things if it sucks (eg, don’t get locked into a 2-year lease, etc)	3	\N	2025-04-28 00:17:04.187065+00	2025-04-28 00:17:04.187065+00	2025-04-27 01:01:10+00	f	mp8nixa
8b7a22c4-f697-445c-9880-22ff05c3df0f	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_8qhgpfve	If you have friends in Portland, try it stay with him for a week or two and try it. Find that sweet spot of time when you can get on the road and make it in time. You’ll probably have to get up at like three or 4 AM to make it to work on time.	3	\N	2025-04-28 00:17:04.190021+00	2025-04-28 00:17:04.190021+00	2025-04-27 02:45:42+00	f	mp93luy
b0e61583-f8a8-489e-be61-7e6152505ad1	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_1dqzldv6rs	When I first moved to Portland I was still commuting to Salem 2 days a week for my M-F 8-5. That was doable. Then it went to 3 days and I started looking for a job up here because that was too much for me. \n\nIf you do decide to do it, you want to get a place that is very close to the HWY ramp as it will really make the commute much faster. So SE close to 205 or downtown/SW close to I5.	2	\N	2025-04-28 00:17:04.192524+00	2025-04-28 00:17:04.192524+00	2025-04-27 04:43:12+00	f	mp9jmbm
e59ea8f2-f86c-446b-993d-9ff6beff2021	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_56o2jpyg	It’s not bad I lived in Forest Grove and commuted to Salem. If I left at 7:00 AM I’d be in my desk at 7:40-7:50-ish. If you can try to start work at 7:30 or earlier. Living south of the Terwilliger Turns helps.	2	\N	2025-04-28 00:17:04.195297+00	2025-04-28 00:17:04.195297+00	2025-04-27 05:18:52+00	f	mp9nraw
0ad0bcd2-9631-4069-ac47-a4995b4077d5	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_ncobv	I'd never make that commute for less than mid-six figures.\n\nI think it'll kill your soul.\n\nEspecially if you do both ways 4-5 days a week.	2	\N	2025-04-28 00:17:04.197888+00	2025-04-28 00:17:04.197888+00	2025-04-27 05:19:44+00	f	mp9nuro
bd19bc6f-b286-4121-8add-a2756f6c7f52	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_eh34oy8mk	I'm making the commute Monday through Friday leaving SE at 7am and leaving Salem between 3-4pm. Honestly, it is an easy commute. Traffic is significantly heavier the other direction. The morning drive is 55 minutes and the afternoon 1hr15-1hr30. \n\nDepending on where in Portland you live will matter for sure. I've got an easy hop over the Hawthorne and boom I5 in a jiffy. I always skip the risk of a train on 11th. If I were on the westside the drive would be marginally easier but only maybe. North Portland would make things slightly worse but not a horrible drive either.	4	\N	2025-04-28 00:17:04.200203+00	2025-04-28 00:17:04.200203+00	2025-04-27 00:16:46+00	f	mp8ggwd
1d40f46f-39c4-4e82-b062-dc5112b92a6b	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_et1rqpmiz	I was the opposite lived in Salem and commuted to Portland it wasn’t too bad most times. Though Portland can be expensive so maybe check for places in between the two cities?	4	\N	2025-04-28 00:17:04.203005+00	2025-04-28 00:17:04.203005+00	2025-04-27 00:27:09+00	f	mp8i2zu
da3b498b-f6ac-4b00-b8fe-b1384aae8b0e	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_8qhgpfve	I drive back-and-forth from Salem to Portland 2 to 3 days a week. I lived by the airport and I drive to South Salem to take care of my grandma with dementia. I take her grocery shopping. Sometimes it takes me three hours to get to Salem and get home at night. It’s better to drive like late. Late at night don’t even try to drive between 6 AM and 10 AM. Or anytime between 2 PM and 6 PM because you will definitely be in the car for four hours. My sciatic nerve started messing up from sitting for so long. You think it’s not that big of a deal but because of traffic it’s a huge deal.	1	\N	2025-04-28 00:17:04.205663+00	2025-04-28 00:17:04.205663+00	2025-04-27 02:42:57+00	f	mp9377z
d811a796-0b97-4fdb-94eb-4656e581dcfe	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_jcaaqyr	We live in NE Portland and my wife works at Chemeketa. The commute just keeps getting worse, but we love living here.	1	\N	2025-04-28 00:17:04.208223+00	2025-04-28 00:17:04.208223+00	2025-04-27 05:14:47+00	f	mp9natr
d8431bfd-e106-4aee-bc8e-543b65b6173c	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_128trysv	The bus from Wilsonville is great if your job is around the Capitol or downtown. Driving 4 days a week would be tougher but you can zone out on the bus.	1	\N	2025-04-28 00:17:04.210483+00	2025-04-28 00:17:04.210483+00	2025-04-27 15:19:29+00	f	mpbpesw
d07ec6d2-0cf0-4e34-974d-f257448b8f0f	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_j3jkz3dv	Plenty of people do it. Be prepared for long days. Try and find a place in the southern metro area. Wilsonville or Tualatin are both nice.	1	\N	2025-04-28 00:17:04.213083+00	2025-04-28 00:17:04.213083+00	2025-04-27 15:47:05+00	f	mpbur7g
9985e674-e72a-4b39-90e6-8a7fc8d94999	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_6j079	There are daily shuttles also	1	\N	2025-04-28 00:17:04.215697+00	2025-04-28 00:17:04.215697+00	2025-04-27 17:32:31+00	f	mpcfgf7
8b5f45c3-5bbd-4a27-a722-e507ce160c25	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_92gvyj7r	I would live somewhere halfway between them or at least south of Portland like Oregon City, Woodburn, Molalla, Wilsonville, etc.	1	\N	2025-04-28 00:17:04.21811+00	2025-04-28 00:17:04.21811+00	2025-04-27 17:45:58+00	f	mpci7x4
e9049460-8eeb-439f-b06e-e86e54dcd6cf	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_15il6r	I do this 4 days a week currently and have for about 6 months. There’s usually no traffic, occasionally you hit it on the way back into pdx around the curves but even that is rare. If you don’t mind listening to podcasts and spending lots of money on gas plus car maintenance it’s not bad! It works for me since I have a lot of friends up here in Portland and I like the city so much. If you don’t have ties to the city or its many amenities it’s probably not worth it.\n\nIf you do decide to do it make sure you get a safe, reliable, and high mpg car. Something like a Prius where you get close to 50mpg and won’t have to fix it a bunch. I started off doing it in a Subaru and spent about $500 a month on gas. Prius would be about $200. Also the winters can be wacky, the drive there is fine but the way back in the dark with heavy rain can be exhausting when you do it everyday	1	\N	2025-04-28 00:17:04.220568+00	2025-04-28 00:17:04.220568+00	2025-04-27 18:33:03+00	f	mpcrij1
2d6b358e-3f10-4d98-a88a-b9450a268b89	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_h18xhvix	I’ve done that commute for 4 years now, from different parts of the city. Honestly, it was very doable for me when I lived in SW Portland, in John’s Landing. It’s a straight shot down I5, for me less than 40 minutes in the morning and 50 minutes tops coming home in the afternoon (my place of work in Salem is directly off the Portland road exit). We moved to SE off of Powell a couple years ago, not quite as doable from this side of town and am looking for a job up here. \n\nI also lived in Salem before moving to SW 4 years ago, and I would say if you’re able to find something in SW Portland, the commute is well worth the opportunities of living in Portland over Salem.	1	\N	2025-04-28 00:17:04.22303+00	2025-04-28 00:17:04.22303+00	2025-04-27 19:09:15+00	f	mpcyj0h
2d527c75-de80-4fb8-975e-0c7194b77360	18932a85-f8bb-4446-b32a-47b146e1e8d2	t2_d7jgyi4w	if you choose an apartment, rent a place with gated secure parking. not joking. so many car break-ins.	-6	\N	2025-04-28 00:17:04.225605+00	2025-04-28 00:17:04.225605+00	2025-04-27 00:49:47+00	f	mp8lpk9
46f3f5dd-7b52-4ac2-a175-396a485fa43d	d4d41462-a7ff-49f8-b9e0-2522c8561b4b	t2_cd2j8	Have you ever heard the little pulses that sound sort of like a coffee grinder when the MAX is slowing down or going up a bridge ramp? That’s the sand being dispensed onto the tracks.	2	\N	2025-04-28 00:17:12.02751+00	2025-04-28 02:42:08.193841+00	2025-04-27 16:35:18+00	f	mpc41qs
3355e81b-9dd4-430a-abac-f2939085563b	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_13qk8tncip	I was at a trade show on the East Coast and had somebody apologize to me when I said I lived in Portland. "Oh my God. That's horrible I'm so sorry! Is it as bad as they say? You know, with the queers and antifa?"\n\nMe: "Yes. It's pretty wonderful that way."	307	\N	2025-04-28 00:16:42.423383+00	2025-04-28 05:54:45.286047+00	2025-04-27 23:10:04+00	f	mpe7rao
102daaf3-b329-46e2-bcfb-4fec10027079	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_3ab9k	In 2021, I went on a road trip and camped out in remote locations across the Western US. Every little town I’d stop in, someone would end up asking where I was from. When they heard Portland, they’d essentially apologize. I tried to explain that 3 blocks from “the riots” were people eating Italian food on a patio. It made me understand that the news only talks about the bad and will exaggerate the extremes. Most places I’ve been have charm. Except Fresno.	8	\N	2025-04-28 00:16:42.459826+00	2025-04-28 05:54:45.336495+00	2025-04-27 23:56:48+00	f	mpefqnv
3e8887f4-0089-44dd-9ed8-7c57dc26e4eb	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_6glju	My fiancé and I are actively talking about moving to Portland from New Jersey. We visited once in October 2023 and absolutely fell in love. At least once a month we reminisce about our trip (and we've been on many since, including a week in Hawaii).	7	\N	2025-04-28 02:12:20.747556+00	2025-04-28 05:54:45.341337+00	2025-04-28 00:22:35+00	f	mpejysl
0407e2bd-fb43-4b16-bea2-baccb934cb8c	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_8e9k4	Yeah, we keep tourists away from the burned out husk parts of the city. It is a huge pain in the ass, especially since so many Portlandia skits were filmed there.	3	\N	2025-04-28 00:16:42.457987+00	2025-04-28 05:54:45.370555+00	2025-04-27 23:30:35+00	f	mpebaa1
7c92a368-5935-48c3-b842-70992845b5d9	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_2gk6p4um	Glad you enjoyed your visit!!	2	\N	2025-04-28 02:12:20.764302+00	2025-04-28 05:54:45.40026+00	2025-04-28 00:52:39+00	f	mpeovb2
6fcfbe3c-e241-43fa-8e3b-2234b489b163	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_12rrca38kt	The national media unintentionally helping us with the housing crisis by making conservatives and "moderates" afraid to come here. Though with distrust of the media at an all time high, I wonder how long this trend will last.	3	\N	2025-04-28 02:12:20.770281+00	2025-04-28 05:54:45.431534+00	2025-04-28 00:46:56+00	f	mpeny5d
30b55ed5-48c8-4664-8d4e-96f4b6a8dba7	d4d41462-a7ff-49f8-b9e0-2522c8561b4b	t2_7nvp11r2l	Sand dispenser drops sand onto the tracks when the train needs additional traction.	17	\N	2025-04-28 00:17:12.015311+00	2025-04-28 02:42:08.177233+00	2025-04-27 04:37:08+00	f	mp9ivvt
7b5cb9e7-d18f-4a05-bf3f-48ece9d05746	d4d41462-a7ff-49f8-b9e0-2522c8561b4b	t2_o7rmn8i	To sand the rails for extra grip	3	\N	2025-04-28 00:17:12.024006+00	2025-04-28 02:42:08.188406+00	2025-04-27 15:50:37+00	f	mpbvg8a
cc135da7-3b9e-4079-9e55-9b75ebf17336	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_jh1xi	Everyone I know in Oregon who hates on Portland does so either because of a bad experience in heavy traffic or because of some news-ass bullshit they heard about. There are a lot of people who love the city and work really hard to make it clean and nice without being cruel to the less fortunate. Did you check out any natural areas? Those are the best part of the city, in my opinion - especially Oaks Bottom.	272	\N	2025-04-28 00:16:42.417313+00	2025-04-28 05:54:45.297726+00	2025-04-27 22:12:56+00	f	mpdxhdu
67fa2c08-37f9-4329-86b3-e59578170e28	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_dddoyiejv	I love portland, but I am leaving for unrelated reasons, and it breaks my heart...	1	\N	2025-04-28 02:12:20.772465+00	2025-04-28 05:54:45.47674+00	2025-04-28 00:45:07+00	f	mpenngp
11ee03c4-683f-4e79-b3d3-2dd2c165bc34	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_kc3da	The city is great to visit, no doubt, especially this time of year. But if you were to live here you may find it very unappealing. I don't know what you do for a living but if you make any kind of money you will be taxed out the ass for the dumbest shit you can think of, and the tax money goes into an unaccountable black hole that produces meager results. Portland considers anyone making over 120k "rich" and taxes them accordingly.	-1	\N	2025-04-28 02:12:20.780853+00	2025-04-28 05:54:45.49134+00	2025-04-28 01:52:13+00	f	mpeyidk
dc74bf31-56aa-46f6-b7c7-614b2bc6dfb7	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_tbx29	Take it to Lake Oswego!	457	\N	2025-04-28 02:12:29.078341+00	2025-04-28 05:54:54.423337+00	2025-04-27 22:53:04+00	f	mpe4sxy
ebf714ff-760c-4bbd-b9b2-2b07b565ebe0	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_cspso	Wear a lifejacket!	64	\N	2025-04-28 02:12:29.089849+00	2025-04-28 05:54:54.441115+00	2025-04-27 23:15:21+00	f	mpe8nw7
446bba17-6e0e-4dc9-b593-8f5e9d323101	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_54b831s9i	I don’t see their boaters tags	24	\N	2025-04-28 02:12:29.097429+00	2025-04-28 05:54:54.447094+00	2025-04-27 23:28:17+00	f	mpeavxs
7b506546-9169-4c38-9d25-fdab2b880152	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_4cqbt	Friggin' crypto millionaires...	38	\N	2025-04-28 02:12:29.093691+00	2025-04-28 05:54:54.453337+00	2025-04-27 23:32:40+00	f	mpebmz4
9bd5ce6e-24c3-4d83-9618-433b328cf0c7	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_1cq2jfk2el	Take that bad boy over to Lake Oswego and rip off your sleeves	23	\N	2025-04-28 02:12:29.1096+00	2025-04-28 05:54:54.465174+00	2025-04-27 23:14:29+00	f	mpe8iii
7d4fb1c6-0a53-4040-89a5-c6ab1b25f8bb	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_176jt9	That's rad! It's just called a 'Sherp' for the record.	41	\N	2025-04-28 02:12:29.101924+00	2025-04-28 05:54:54.470819+00	2025-04-27 22:43:25+00	f	mpe331p
05167c9d-fbb7-4203-b55e-802343d3a4eb	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_5wx6bt5g	why?	5	\N	2025-04-28 02:12:29.157928+00	2025-04-28 05:54:54.476648+00	2025-04-28 01:22:56+00	f	mpetr9i
5e0da50a-e7bc-4fa9-9c57-2aa01e6e0e27	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_ozgtd	FFS. If you have that kind of cash, why not just go buy an actual bigger penis? 	10	\N	2025-04-28 02:12:29.117354+00	2025-04-28 05:54:54.482541+00	2025-04-28 00:52:59+00	f	mpeox8v
2d3052f5-0bec-4fe0-98f3-fda8145a1cf5	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_16a1he	I have never seen one. Is this the thing that's made in Ukraine?	6	\N	2025-04-28 02:12:29.113281+00	2025-04-28 05:54:54.488375+00	2025-04-28 00:04:35+00	f	mpeh1o4
fca09de3-6230-40ac-9f44-e2d027a2b7ff	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_28jh0rmg	Call me when they have one that fits in my apartment’s parking space.	3	\N	2025-04-28 02:12:29.165337+00	2025-04-28 05:54:54.494265+00	2025-04-28 02:03:33+00	f	mpf0cfp
dcfccebf-2a75-4a39-980c-01ab1d014aff	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_feusox64	Ridiculous but kind of cool	5	\N	2025-04-28 02:12:29.161481+00	2025-04-28 05:54:54.49998+00	2025-04-28 01:30:30+00	f	mpeuzgj
35dcf80b-fee4-4cbe-9df6-a4d710c27777	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_1u2lytm2	Does this damage the river bed?	6	\N	2025-04-28 02:12:29.124867+00	2025-04-28 05:54:54.505919+00	2025-04-28 00:08:05+00	f	mpehm8n
9462c86b-c02a-4351-a50d-d04b400330bb	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_7uclp	What's that thing on the front? Some sort of flip-down windshield cover?	2	\N	2025-04-28 02:12:29.121136+00	2025-04-28 05:54:54.51165+00	2025-04-27 23:30:05+00	f	mpeb73c
9de78b68-d69d-4aaf-8da6-4e0b502464ca	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_86lq1ly8	Gotta love Tech Bros /s	8	\N	2025-04-28 02:12:29.128591+00	2025-04-28 05:54:54.523336+00	2025-04-27 23:20:19+00	f	mpe9ipp
41a61318-5ad2-450d-841d-8e14ef4d0e69	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_assnp	If I was rich I’d get a sherp	2	\N	2025-04-28 02:12:29.146866+00	2025-04-28 05:54:54.558261+00	2025-04-27 23:43:33+00	f	mpedhl7
962e9b8e-b016-42c5-aa1c-0ec77227056c	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_2wl4gshk	The vehicle that does (nearly) everything poorly.	-1	\N	2025-04-28 02:12:29.187764+00	2025-04-28 05:54:54.610856+00	2025-04-28 01:12:03+00	f	mpes079
72620f1c-bf18-4d34-8755-bf5de58d8da0	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_j9knq6jk	Cringe	4	\N	2025-04-28 02:12:29.139554+00	2025-04-28 05:54:54.529155+00	2025-04-27 23:49:23+00	f	mpeehau
af0b0d55-053e-4ebc-bb61-b04d1ab578a5	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_sk5k0gea	Humans are so fucking weird. All I see here is a lot of wasted money, a torn up river bottom, and a bunch of terrified wildlife.	3	\N	2025-04-28 02:12:29.135874+00	2025-04-28 05:54:54.535283+00	2025-04-28 00:32:18+00	f	mpelkqu
639248c1-11a4-47b7-bfd1-fae8a5edc2ae	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_riovcvu6	More like derpa. Toolbags	3	\N	2025-04-28 02:12:29.143305+00	2025-04-28 05:54:54.541373+00	2025-04-27 23:02:40+00	f	mpe6hap
b67bbf6a-6ce0-413d-979c-56fe70c5b755	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_9qoqcx9c	The largest version is the Ark, for those who have a lot of animals.	2	\N	2025-04-28 02:12:29.150519+00	2025-04-28 05:54:54.5469+00	2025-04-28 00:59:14+00	f	mpepxiv
34a633cb-3804-4453-b648-c347f72a77f4	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_b6nly	Second hand embarrassment for anyone that knows this guy	2	\N	2025-04-28 02:12:29.132294+00	2025-04-28 05:54:54.552589+00	2025-04-28 01:04:02+00	f	mpeqpj5
ab4885f3-5023-4434-94e2-0837412c92b3	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_tbob5i1d6	Sweet! It reminded me of the coot amphibious vehicle my uncle had when I was a kid.	1	\N	2025-04-28 02:12:29.172878+00	2025-04-28 05:54:54.575903+00	2025-04-27 23:20:36+00	f	mpe9kdz
d594f5b7-1c27-4b91-98fc-8df6c874bbca	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_1hl028x9iw	Woah!! Really interesting/cool to see in action. 	1	\N	2025-04-28 02:12:29.180134+00	2025-04-28 05:54:54.581901+00	2025-04-27 23:51:24+00	f	mpeetuo
3838e888-78d5-427d-8fb5-be491c57f152	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_3wk26	The tires are 1800x600-25.  They are massive.	1	\N	2025-04-28 02:12:29.154394+00	2025-04-28 05:54:54.587658+00	2025-04-28 01:22:54+00	f	mpetr45
eb6190b3-2c6d-450a-97b0-eb6010b7efc6	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_7ikzmeht	I want one.	0	\N	2025-04-28 02:12:29.169101+00	2025-04-28 05:54:54.59944+00	2025-04-28 00:03:49+00	f	mpegx5e
4484cfb9-2348-48ec-af81-fd6f93bfcdbc	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_10l4kx	Disgusting waste of destruction to the river.  I guess it’s still a super fund river, oh yea, that got defunded.	-12	\N	2025-04-28 02:12:29.176532+00	2025-04-28 05:54:54.605097+00	2025-04-27 23:12:40+00	f	mpe8748
a59e3390-7a8b-4a2d-9de5-d3bc0d371171	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_i0g9vgwn4	How is this legal? Seems like it has to be polluting the river.	-17	\N	2025-04-28 02:12:29.183803+00	2025-04-28 02:41:37.595501+00	2025-04-27 22:39:47+00	f	mpe2f88
bc0ba640-ea86-4ad4-ad53-6ad3edd5e568	a3a6e6fd-0861-40c2-b9df-d6e41d0f0f43	t2_9iitf4e1	Chart House? Sw but has the Nw feel because, Terwillger	31	\N	2025-04-28 02:12:43.87592+00	2025-04-28 02:42:00.235673+00	2025-04-27 19:14:51+00	f	mpczld2
eece8d47-b841-4849-967a-b3b5de30c01d	a3a6e6fd-0861-40c2-b9df-d6e41d0f0f43	t2_6oj3tnz7	Seasons &amp; Regions?	16	\N	2025-04-28 02:12:43.884917+00	2025-04-28 02:42:00.250572+00	2025-04-27 19:16:09+00	f	mpczu81
2b57202f-3100-499c-9f53-ba8800f6395c	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_8xlvlzvo	I grew up in the Chicago suburbs but have lived here for almost 30 years.  I was in Duluth, MN last summer at a store that asked me my phone number at check out.  The clerk unsolicited told that he knew all about the fentanyl hellhole that was Oregon and Portland specifically.  He has a brother who lives in Vancouver and knows all about it.  Needless to say I thought Duluth sucked.  😅	3	\N	2025-04-28 02:12:20.777547+00	2025-04-28 05:54:45.375652+00	2025-04-28 01:50:10+00	f	mpey6br
12c402d1-10d2-4571-9c3b-6d7bb10d824b	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_71mvijin	Is this buoyant or driving on the river bottom?	50	\N	2025-04-28 02:12:29.082465+00	2025-04-28 05:54:54.429419+00	2025-04-27 22:51:49+00	f	mpe4l3y
592856a0-e2a3-4e5b-89cd-a4da2811e301	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_16o3d2	As a white man, sometimes even I have to say, damn that’s some white people nonsense right there	102	\N	2025-04-28 02:12:29.086197+00	2025-04-28 05:54:54.43528+00	2025-04-28 00:04:38+00	f	mpeh1w8
0d4585d0-3483-419a-a24d-2d855d027b19	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_3vpwr	Teenjus?	19	\N	2025-04-28 02:12:29.105856+00	2025-04-28 05:54:54.459328+00	2025-04-27 23:39:00+00	f	mpecpjz
e90b7493-d027-4138-80c7-2f08471fea84	a3a6e6fd-0861-40c2-b9df-d6e41d0f0f43	t2_9lx3edga	I have no idea what food they used to serve, but could it have been Skyline Tavern? (It has been closed as long as I have lived here post-pandemic but they had lovely outdoor seating.) https://m.yelp.com/biz/skyline-tavern-project-portland-3	14	\N	2025-04-28 02:12:43.895327+00	2025-04-28 02:42:00.264558+00	2025-04-27 19:46:31+00	f	mpd5m87
13d9d9fc-3cb0-4546-90b5-42fe611e1e3a	a3a6e6fd-0861-40c2-b9df-d6e41d0f0f43	t2_fujkijew	Fun game. Paley's Place? It checks out for best-of lists, NW, leafy, patio (IIRC), was in an old house I think. Otoh it was in the NW neighborhood.	7	\N	2025-04-28 02:12:43.900875+00	2025-04-28 02:42:00.269176+00	2025-04-27 19:48:21+00	f	mpd5zbl
8cc38371-28dc-4602-b558-d0f60e933534	a3a6e6fd-0861-40c2-b9df-d6e41d0f0f43	t2_baue4jos1	Rock Creek Tavern?	5	\N	2025-04-28 02:12:43.905269+00	2025-04-28 02:42:00.273943+00	2025-04-27 20:10:50+00	f	mpdabpa
5df09c63-91cf-41c4-83bc-d96770dc6111	a3a6e6fd-0861-40c2-b9df-d6e41d0f0f43	t2_7dlgedhz	Helvetia Tavern?	3	\N	2025-04-28 02:12:43.909638+00	2025-04-28 02:42:00.278891+00	2025-04-27 19:59:00+00	f	mpd81o7
c1c68736-44c5-47a6-b98c-dc0c2755cb89	a3a6e6fd-0861-40c2-b9df-d6e41d0f0f43	t2_4d3ydwhz	Was it Verde Cocina? Used to be in NW right off 26.	5	\N	2025-04-28 02:12:43.914084+00	2025-04-28 02:42:00.28359+00	2025-04-27 20:24:07+00	f	mpdcx7b
fc668fd9-fa39-4141-aa49-988b0090ae5b	a3a6e6fd-0861-40c2-b9df-d6e41d0f0f43	t2_iuni9l4l	Wildwood?	4	\N	2025-04-28 02:12:43.918543+00	2025-04-28 02:42:00.28835+00	2025-04-27 20:29:43+00	f	mpde105
d9c1ecbe-9159-4008-8faf-25ef7969e8a0	a3a6e6fd-0861-40c2-b9df-d6e41d0f0f43	t2_ni23fp5	Was it the restaurant house in Cornel Farms? (its in the forest park area behind the zoo/past the pittock mansion in NW\n\nhttps://cornellfarms.com/	3	\N	2025-04-28 02:12:43.923183+00	2025-04-28 02:42:00.293102+00	2025-04-27 19:31:22+00	f	mpd2pth
fb6602ba-0e38-4a8b-a82e-19e2a6c8c624	a3a6e6fd-0861-40c2-b9df-d6e41d0f0f43	t2_2afeak7g	Maybe L' Auberge? \n\nhttps://www.pdxmonthly.com/eat-and-drink/2016/08/in-the-70s-and-80s-this-prolific-portland-restaurateur-redefined-fine-dining	2	\N	2025-04-28 02:12:43.931856+00	2025-04-28 02:42:00.30257+00	2025-04-27 19:41:49+00	f	mpd4oyw
b5a4c75f-163b-4a2f-b94e-f3402654c663	a3a6e6fd-0861-40c2-b9df-d6e41d0f0f43	t2_fmqln	Besaw?	2	\N	2025-04-28 02:12:43.936144+00	2025-04-28 02:42:00.307366+00	2025-04-27 20:43:39+00	f	mpdgs7p
56b8ce10-f84e-414a-ae12-7521bd75ea0d	a3a6e6fd-0861-40c2-b9df-d6e41d0f0f43	t2_ggyi3	It was probably Goose Hollow Inn.	2	\N	2025-04-28 02:12:43.941058+00	2025-04-28 02:42:00.312531+00	2025-04-27 21:22:30+00	f	mpdo9tj
9d7796b4-a43d-4bd2-a657-d8058c42bd28	a3a6e6fd-0861-40c2-b9df-d6e41d0f0f43	t2_knk724pv	Leaky Roof?	1	\N	2025-04-28 02:12:43.94539+00	2025-04-28 02:42:00.317226+00	2025-04-27 19:53:34+00	f	mpd6zwm
77685913-ccf7-445a-8aa6-e70cdea5fe51	a3a6e6fd-0861-40c2-b9df-d6e41d0f0f43	t2_8bo4nsb3	Sort of sounds like Vista Spring Cafe but the menu doesn't match. But I wonder if they offered seafood when you ate there years ago.	1	\N	2025-04-28 02:12:43.94976+00	2025-04-28 02:42:00.321929+00	2025-04-27 20:58:13+00	f	mpdjlvb
f0883af3-4f57-4e38-9738-13e820644f56	a3a6e6fd-0861-40c2-b9df-d6e41d0f0f43	t2_5yb1leq5	Jones landing had a seafood spot. I think it just closed	1	\N	2025-04-28 02:12:43.954217+00	2025-04-28 02:42:00.32672+00	2025-04-27 21:01:22+00	f	mpdk8zi
1968493d-01e4-41e9-a6a2-c2d0a4e7bf1b	d4d41462-a7ff-49f8-b9e0-2522c8561b4b	t2_5hdd3	They drop sand to add traction between the wheels and the track when the wheel slips.	37	\N	2025-04-28 00:17:12.011274+00	2025-04-28 02:42:08.171019+00	2025-04-27 04:36:45+00	f	mp9iu4t
1aca5b43-7a75-43ec-9e11-5ac6395993dc	d4d41462-a7ff-49f8-b9e0-2522c8561b4b	t2_oan07fr	These are hoppers that hold sand that is dispensed onto the rails when the train loses traction. I believe it may be a semi/fully automatic system. You’ll hear it when it happens, somewhat of a buzzy/whirring noise that lasts for a few seconds, usually if the train is going uphill and it’s raining.	9	\N	2025-04-28 00:17:12.020237+00	2025-04-28 02:42:08.18264+00	2025-04-27 06:09:55+00	f	mp9t8pg
695abc25-640d-4dd5-a598-7d20f1f9e40f	4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	t2_3gvei	Influencers. Sherps so hot right now.	31	\N	2025-04-28 02:13:04.561818+00	2025-04-28 02:42:29.760294+00	2025-04-27 22:59:08+00	f	mpe5vfc
fbfeb035-4a44-4518-8fe2-81f21a559f01	4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	t2_v7kcrnf3	I heard Lake Oswego loves Sherpas	27	\N	2025-04-28 02:13:04.566983+00	2025-04-28 02:42:29.768238+00	2025-04-27 23:43:28+00	f	mpedh47
0f03a7a1-8875-48cc-b253-efcd59808ad7	4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	t2_1hep3hgxgj	To be a rich yuppie who's life is basically runescape...	91	\N	2025-04-28 02:13:04.564711+00	2025-04-28 02:42:29.776512+00	2025-04-27 23:01:17+00	f	mpe68sd
7e90ee6c-4ee2-4e89-be05-f291ec0ffdc1	4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	t2_ozgtd	In 15 years, it’ll be a hoboat.	13	\N	2025-04-28 02:13:04.569269+00	2025-04-28 02:42:29.7844+00	2025-04-27 23:18:47+00	f	mpe9937
b6ec9088-c055-4047-a608-2f3b580c0b62	4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	t2_yfo8s	I decided to look this up. I was hoping it was some handmade thing called a "Sherpa"... turns out SHERP is a brand, and this thing comes like this out of the box.\n\nI would have been genuinely amused and impressed if this douche nozzle built it himself.\n\nETA: Good lord these things are well over $100k. "Mission critical." AHHAHAHA. \n\n[https://sherpatvsales.com/](https://sherpatvsales.com/)	9	\N	2025-04-28 02:13:04.576019+00	2025-04-28 02:42:29.792556+00	2025-04-28 00:57:33+00	f	mpepnky
f68a8483-8fa7-42bd-9463-0dc8f39dc46d	4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	t2_riovcvu6	Sherpa? I just see someone with way too much money looking for attention…	39	\N	2025-04-28 02:13:04.571442+00	2025-04-28 02:42:29.800295+00	2025-04-27 22:58:02+00	f	mpe5oi2
4e5027d0-37f7-4b1f-bbe4-0e5c7aa3182f	4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	t2_16utwzlgzv	Taking that shit down to whole foods	9	\N	2025-04-28 02:13:04.573841+00	2025-04-28 02:42:29.808333+00	2025-04-27 23:21:00+00	f	mpe9mv9
aeff1352-f3af-4913-a06d-c5a32e6357ff	4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	t2_1hhevxcyyu	That looks tippy.😬	6	\N	2025-04-28 02:13:04.578206+00	2025-04-28 02:42:30.938824+00	2025-04-27 23:10:12+00	f	mpe7s1x
df2f4b58-c7f3-441a-a7a3-ad469a9f2d57	4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	t2_jhual	Portlanders seeing this are probably having an aneurysm as their "Keep Portland Weird" and "if it doesn't affect me I have no problem with it" sentiment is tested to its absolute limit.	6	\N	2025-04-28 02:13:04.580483+00	2025-04-28 02:42:30.947975+00	2025-04-28 00:21:57+00	f	mpejuzc
60fa417c-0b1d-45e4-b441-7c36cc87d952	4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	t2_16tftm	I loathe everything about this.	33	\N	2025-04-28 02:13:04.582817+00	2025-04-28 02:42:30.959469+00	2025-04-27 22:37:51+00	f	mpe22bs
a791dacb-7635-44bb-bfda-f6578b029bcf	4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	t2_9n1dddxn	EVERYBODY LOOK AT ME! I'M SO UNIQUE AND QUIRKY!!!!!11!	21	\N	2025-04-28 02:13:04.58493+00	2025-04-28 02:42:30.96782+00	2025-04-27 22:59:02+00	f	mpe5urd
3d1a668b-c829-492d-a18f-1b974140fa29	4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	t2_7su1xp7b	The type of person who when it snows would be slowing to a crawl when approaching a hill…like everyone on hood with a jeep or Subaru who doesn’t actually know how to drive in snow….\n\nBut tbh the Sherpas are sick. No practical use if you’re not in a war zone or own extremely rugged property, but still pretty cool.	8	\N	2025-04-28 02:13:04.588894+00	2025-04-28 02:42:30.975855+00	2025-04-27 23:32:13+00	f	mpebkco
559d9f8a-399e-4a72-9c65-b1940dcb8de6	4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	t2_wldkk7ns1	This might be the single greatest thing ever posted on here. I want one so badly now. If we get a sick kicker next year?  Forget the jetski, imma cop one.  Well, they’re like $100k used so maybe I need a few years of kicker to pick one up.\n\nhttps://sherpatvsales.com/sherp-atv-sales/used-sherp/	11	\N	2025-04-28 02:13:04.586922+00	2025-04-28 02:42:30.983266+00	2025-04-27 22:39:16+00	f	mpe2bvm
855405e7-7dd4-4994-8c96-bafa80cfbacd	4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	t2_6lioxeqa	Terrible for the river	8	\N	2025-04-28 02:13:04.591018+00	2025-04-28 02:42:30.988571+00	2025-04-27 23:16:26+00	f	mpe8ujt
4c836d46-caff-468c-a8f0-269e2afe663f	4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	t2_aljc9jr9	The cyber truck of water	2	\N	2025-04-28 02:13:04.593409+00	2025-04-28 02:42:30.99902+00	2025-04-28 00:26:19+00	f	mpeklb1
ab23c9ae-ab96-4369-9b0a-4bded0833cd4	4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	t2_1iatx7hx	Small Dick Energy.	3	\N	2025-04-28 02:13:04.595532+00	2025-04-28 02:42:31.00463+00	2025-04-27 23:41:54+00	f	mped7ig
937ab328-ae0a-45a0-8d43-d82b8a12076f	4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	t2_dykka9ikx	Portlanders really be using anything but a car to get around	1	\N	2025-04-28 02:13:04.597565+00	2025-04-28 02:42:31.009928+00	2025-04-28 00:22:49+00	f	mpek08h
587a007e-23a6-480e-8160-5217cffe87f1	4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	t2_a8n3zjf6	What an absolute d-bag	1	\N	2025-04-28 02:13:04.599699+00	2025-04-28 02:42:31.015204+00	2025-04-28 02:01:58+00	f	mpf03a6
0b5b5552-b12c-44f7-8f78-0980d94ade88	4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	t2_3oczi0j1	We saw it while fishing by Lake O today.  it looked like a tractor trying to get out of the mud and moved about as fast as one.   I bet they got great done video🙄.	-1	\N	2025-04-28 02:13:04.604071+00	2025-04-28 02:42:31.038043+00	2025-04-27 23:58:22+00	f	mpeg07b
c6f13747-c16e-4110-bc31-5f670987c1b9	8e4f3362-f041-4973-b352-4d5b5e0b120c	t2_1au5yp5cnh	As a transit rider, I can tell trimet is trying to bolster security on their facilities. Unfortunately until the City of Portland and MultNo County stop the enabling, it won’t matter. 	133	\N	2025-04-28 02:13:14.703117+00	2025-04-28 02:42:39.404425+00	2025-04-27 17:36:34+00	f	mpcgade
4de7ef57-7b12-407c-8f94-9c31c92b0f43	8e4f3362-f041-4973-b352-4d5b5e0b120c	t2_3z4fu	Are the same number of people commuting to office buildings downtown as in 2019? Has anything changed since then?	11	\N	2025-04-28 02:13:14.706881+00	2025-04-28 02:42:39.416783+00	2025-04-27 18:27:16+00	f	mpcqesb
8acd64f1-756b-40d1-953e-f16e11f94bae	8e4f3362-f041-4973-b352-4d5b5e0b120c	t2_56ncduiz	They’ve chased all the businesses out of the City by doing nothing about crime, drugs, mentally ill zombies and homeless squatters	66	\N	2025-04-28 02:13:14.708787+00	2025-04-28 02:42:39.422808+00	2025-04-27 18:04:50+00	f	mpcm0ho
a9e649f2-cbb0-4ac4-8c0e-5d5fb9c2fb60	8e4f3362-f041-4973-b352-4d5b5e0b120c	t2_9tazgiix7	It would be nice if headways were increased. It’s annoying having to wait 15 minutes for a train at a lot of stations. Also I hate how they are often only running one-car trains for the Green Line. I take it in the morning and it’s always packed and I have to run to catch the one car (versus two cars meaning there is a further distance that the train extends).\n\nNow as for safety, in my experience it’s not as much of a concern as cleanliness (at least during the day). I have noticed increased security around stations which is a good thing.	7	\N	2025-04-28 02:13:14.710578+00	2025-04-28 02:42:39.428841+00	2025-04-27 20:11:32+00	f	mpdagj5
be0597a4-340d-475e-9301-5b8322a7deb0	8e4f3362-f041-4973-b352-4d5b5e0b120c	t2_xfao7	The other story in the provided graph is that even pre-pandemic, TriMet's ridership had flatlined, despite the addition of new Max lines, and significant growth in the metro's population.  \n\nRidership was 96.9 million in 2005, and 96.7 million in 2019.\n\nNot to worry, though - the solution, as always, is to raise taxes.\n\n[https://news.trimet.org/2025/04/trimet-warns-of-cuts-to-transit-service-without-an-increase-in-transit-funding-in-2025-oregon-transportation-package/](https://news.trimet.org/2025/04/trimet-warns-of-cuts-to-transit-service-without-an-increase-in-transit-funding-in-2025-oregon-transportation-package/)	27	\N	2025-04-28 02:13:14.712477+00	2025-04-28 02:42:39.435056+00	2025-04-27 18:13:18+00	f	mpcnoge
ef324f8c-cdfc-496c-b4e6-71c2e4314575	8e4f3362-f041-4973-b352-4d5b5e0b120c	t2_2unnwhpi	I'm trying to wait for at least 6 months of no violence on public transport. This includes hair cutting and drugged out zombies.	23	\N	2025-04-28 02:13:14.714335+00	2025-04-28 02:42:39.441058+00	2025-04-27 18:03:48+00	f	mpclt4h
6e926167-c914-401d-907b-b15256bedfc0	8e4f3362-f041-4973-b352-4d5b5e0b120c	t2_12rbk6eo96	People don't want to be stuck in a metal tube with unpredictably violent, diseased, mentally ill junkies who know they are allowed to ride free and unchecked?\n\nColor me shocked. \n\nI don't own a car and still avoid the Meth Addict Express whenever feasible.	14	\N	2025-04-28 02:13:14.716815+00	2025-04-28 02:42:39.447117+00	2025-04-27 19:30:53+00	f	mpd2min
a2b54cac-b8c1-40af-9f5f-1d28393f6905	8e4f3362-f041-4973-b352-4d5b5e0b120c	t2_nu5e48ou	The answer is simple. Get rid of the homeless and drug addicts. Slash corporate taxes. Make downtown desirable and compete for commercial business from the suburbs. Right now, our politicians only care about providing ineffective services to our homeless drug addicts. If they don’t care about making downtown desirable, then slash public transit. What’s the point if there are no jobs to go to anyway?	5	\N	2025-04-28 02:13:14.719351+00	2025-04-28 02:42:39.453141+00	2025-04-27 22:52:35+00	f	mpe4pvs
bb8039b3-bd32-434d-a234-f3169d89b606	8e4f3362-f041-4973-b352-4d5b5e0b120c	t2_gxgwcndt	I will ride when every car has a security officer to chase away the scary people. Until then, no ride.	6	\N	2025-04-28 02:13:14.721429+00	2025-04-28 02:42:39.45917+00	2025-04-27 20:34:56+00	f	mpdf24h
8512c88b-87ea-4b31-ba1b-395c18a566e4	8e4f3362-f041-4973-b352-4d5b5e0b120c	t2_rn2242km	I don’t want to take my kids on public transportation here because there’s a high chance of some criddler or addict on. It’s too bad because public transportation is so necessary to a metro area like Portland	8	\N	2025-04-28 02:13:14.723311+00	2025-04-28 02:42:39.465436+00	2025-04-27 19:58:23+00	f	mpd7xf3
b8c1d5b9-23cc-4b83-963b-f9f247b8645c	8e4f3362-f041-4973-b352-4d5b5e0b120c	t2_lhtmspsf	How do they track riders that aren’t even paying to ride? I’m skeptical of these numbers. This is the only transit system I’ve seen with such wide open access to the train, you could easily ride trimet everyday for free without even having to jump a turnstile or gate or even the most basic barrier.	6	\N	2025-04-28 02:13:14.725147+00	2025-04-28 02:42:39.471615+00	2025-04-27 20:10:05+00	f	mpda6gt
98a21f78-3287-4dee-830c-a9cd747a8300	8e4f3362-f041-4973-b352-4d5b5e0b120c	t2_j7wxco9wh	And the bridge won’t happen bc no one on the WA side wants the TriMet coming over there. Every year we wait to build a simpler bridge it gets more expensive. The federal funding portion now literally just pays for the TriMet addition, so it’s pointless.	5	\N	2025-04-28 02:13:14.727143+00	2025-04-28 02:42:39.477718+00	2025-04-27 20:52:04+00	f	mpdif4y
f7fac0a7-7041-47dd-8ee4-56c4f27e0929	8e4f3362-f041-4973-b352-4d5b5e0b120c	t2_3m5gh	We need the 91019 London style, "reporting it and we'll sort it". Anybody feels uncomfortable or seea some shitty thing on public transit there should be police or people to deal with it AT THE NEXT STOP.\n\nOtherwise it will not be utilized enough. I mean, there were multiple people killed on the Max in recent history.	5	\N	2025-04-28 02:13:14.729109+00	2025-04-28 02:42:39.483592+00	2025-04-27 19:36:25+00	f	mpd3ol2
aff26cff-0566-42d4-8b68-9ecb469638bb	8e4f3362-f041-4973-b352-4d5b5e0b120c	t2_2q9ln	Tri-Meth	8	\N	2025-04-28 02:13:14.7315+00	2025-04-28 02:42:39.489693+00	2025-04-27 18:43:15+00	f	mpcthk5
6ffa4fd1-0064-46c6-8ec0-091c1aca825f	8e4f3362-f041-4973-b352-4d5b5e0b120c	t2_auoe29qa	The solution to the problems the transit agency are outside their hands sad to say	3	\N	2025-04-28 02:13:14.734031+00	2025-04-28 02:42:39.496101+00	2025-04-27 18:42:41+00	f	mpctdgl
5118b2b4-6367-476e-a4c3-a0daa45f18c5	8e4f3362-f041-4973-b352-4d5b5e0b120c	t2_2q1fyhbj	Probably not the main factor but I’m curious how much ridership has suffered with the Blazers being bad? That used to be 41 home games plus playoffs of packed trains.	3	\N	2025-04-28 02:13:14.737949+00	2025-04-28 02:42:39.502335+00	2025-04-27 18:01:30+00	f	mpclcui
ce48dcff-5123-4d2b-a68f-0c77686ea26e	8e4f3362-f041-4973-b352-4d5b5e0b120c	t2_gzrz0	Outsider looking in…\n\nMy family will get here in the summer.  I plan on taking them out on day trips on the max, bus and trolley.  They are 8 and 10.\n\nIt will be good.  Portland is a gritty enough of a city to learn about situational awareness and clean sight lines.  It is quasi-safe to safe, especially during the day.\n\nNot thrilled that on a long enough of a time horizon they will witness a fent-foily or a meth pipe.  Son is already aware that the reason for bathroom closures in cities is due to OD’s.	2	\N	2025-04-28 02:13:14.736099+00	2025-04-28 02:42:39.508573+00	2025-04-27 19:41:35+00	f	mpd4ngi
9b1ee3d8-2bd6-4c65-bd0a-e27124e1b912	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_4rpllxpy	https://preview.redd.it/99b8sa7nhfxe1.jpeg?width=1125&amp;format=pjpg&amp;auto=webp&amp;s=cec78132971705aea80871495b127b9d8a3cfd67\n\nThis year is going to be even better than lasts. Triple crown, can only fit 10 berries per handful at peak season. Thornless and abundant in the back yard.	3	\N	2025-04-28 02:13:27.528154+00	2025-04-28 02:43:00.538926+00	2025-04-27 19:24:28+00	f	mpd1f6y
0f7dc672-9325-478c-bf86-b72708b1ea2c	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_7c59h	Fuck yeah!  I mean thats one of the best reasons for living here.	3	\N	2025-04-28 02:13:27.530117+00	2025-04-28 02:43:00.545941+00	2025-04-27 20:42:32+00	f	mpdgkbj
d6612dc9-d6bd-4634-a5a2-082994447ba9	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_19h9qmai3l	i've got strawberries coming in right now!	3	\N	2025-04-28 02:13:27.532433+00	2025-04-28 02:43:00.552925+00	2025-04-27 19:21:05+00	f	mpd0rud
987466cb-1f8b-42e3-aa17-55035f122914	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_6f2m2	My porch strawberries are putting out their first flowers this weekend! Two plants is never that many berries, but it’s always so wonderful to have a fresh one from the patio.\n\nAlso, all of the Oregon grapes in the neighborhood are starting to show little green berries. We’re almost there! I’m considering harvesting a bunch from the various landscaping Oregon grapes around my apartment complex this year. Last year most of the berries rotted on the plants at the end of summer, even ones right along the sidewalk	3	\N	2025-04-28 02:13:27.534662+00	2025-04-28 02:43:00.559126+00	2025-04-27 19:56:50+00	f	mpd7mit
74c23db0-6f2c-4085-9139-663f433a5ab8	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_574azgzu	This stirs up childhood memories of trawling local neighborhoods for huge roadside Himalayan blackberry bushes and filling a bucket for baked goods. We all gotta do our part to keep the invasives from spreading, you know.	3	\N	2025-04-28 02:13:27.536856+00	2025-04-28 02:43:00.56392+00	2025-04-27 21:20:09+00	f	mpdnu8u
4e490f8e-a569-429c-84bc-cad7049b0814	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_14610q	My ARFID 7yo is that “refuses to eat any thing” guy.  He also has sensory issues that make activities outside (there’s bugs and dirt out there, mom!) really difficult.\n\nBut picking blackberries is his very favorite.  He asks all the time when the blackberries in the backyard will be ready.  We’re just starting to see blossoms and we’re so excited for the first ripe berries!	3	\N	2025-04-28 02:13:27.538695+00	2025-04-28 02:43:00.568554+00	2025-04-27 21:45:20+00	f	mpdsgkj
911ee571-2c4e-4749-b1ce-d1c7d324604f	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_h7e4xd6a	Yes! We have blackberries all over our “neighborhood” (country area out on the Clackamas river area) and when I go on evening walks in the summer, it turns into me just gorging myself on roadside berry bushes like a chubby little cubby. The smell of warm blackberries ripening on the vine = Devine.	3	\N	2025-04-28 02:13:27.54056+00	2025-04-28 02:43:00.572975+00	2025-04-27 23:00:38+00	f	mpe64rl
024b744b-a3d4-4d93-916e-2204663f7cca	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_5qv31m0	Ya, live on 40 acres. Got many different varieties.	2	\N	2025-04-28 02:13:27.543195+00	2025-04-28 02:43:00.576675+00	2025-04-27 19:37:53+00	f	mpd3yh9
55c88dd3-7ba1-4e16-a1d4-0884cc5dc0a4	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_3kdsemee	Ah yes. Our renown berries are coming into bloom.	2	\N	2025-04-28 02:13:27.545092+00	2025-04-28 02:43:00.580431+00	2025-04-27 19:51:57+00	f	mpd6oi7
a71e5d42-640d-440f-9934-17e6f371923c	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_kbj6lu5p	Oh yeah. There’s a wall of them near me that hardly anyone seems to pick. Can’t wait	2	\N	2025-04-28 02:13:27.546981+00	2025-04-28 02:43:00.584197+00	2025-04-27 20:11:56+00	f	mpdaj9x
8fb03f1b-bc7a-4e7e-88ca-4ba4428cdf7d	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_e65gg	Can't wait to take my son blueberry picking :)	2	\N	2025-04-28 02:13:27.549354+00	2025-04-28 02:43:00.587893+00	2025-04-27 20:13:35+00	f	mpdauvs
2f100bd8-0025-47ae-b9ee-aa022e5604f2	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_22bnbf0s	Not only am i ready, i have a dream.of finding enough salmon berries to make some hand pies.	2	\N	2025-04-28 02:13:27.552222+00	2025-04-28 02:43:00.591665+00	2025-04-27 20:21:19+00	f	mpdcde3
57af6521-9a04-4a2a-8194-089e34f182bb	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_4r6lw8qs	Picked enough last year, froze and vacuum packed, that I am down to my last bags. Enough for a daily smoothie, all fresh. All for free!	2	\N	2025-04-28 02:13:27.554932+00	2025-04-28 02:43:00.595623+00	2025-04-27 20:25:21+00	f	mpdd5pi
ad5c7d39-bdc9-43fd-8cb4-dc3a6448a2db	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_vnt6gv6tn	Those look yummy	2	\N	2025-04-28 02:13:27.557508+00	2025-04-28 02:43:00.599587+00	2025-04-27 21:42:03+00	f	mpdrv6e
d71ebf57-c5e2-45c1-a024-ad9d93578730	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_9rb7awwf	Strawberry season can't start soon enough. Hopefully it's starts in a couple of weeks.	2	\N	2025-04-28 02:13:27.559965+00	2025-04-28 02:43:00.603212+00	2025-04-27 22:06:39+00	f	mpdwd5v
61f075cb-5575-4cd1-86ee-a0d3bf354f87	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_obi8a	hell yeah. free lunch season. 😂👍🏻	2	\N	2025-04-28 02:13:27.562509+00	2025-04-28 02:43:00.607417+00	2025-04-27 23:18:11+00	f	mpe95ez
5ee7c5a3-d1c8-4258-8895-3bc741dd40f1	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_5ydov	Every summer I go to my local u-pick blueberry farm and pick a couple buckets of blueberries...I freeze...some. \n\nThe rest I devour fresh by the handful. No regrets!	2	\N	2025-04-28 02:13:27.565351+00	2025-04-28 02:43:00.611946+00	2025-04-28 00:22:07+00	f	mpejvyl
bbb96457-8da6-4df5-be73-ff15bb332bdd	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_480v9iw8	Can we just get to Summer first?	1	\N	2025-04-28 02:13:27.568402+00	2025-04-28 02:43:00.616476+00	2025-04-27 21:26:33+00	f	mpdp0y7
ff3c6d2c-aee9-4e16-9c2a-19f56e8d9845	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_1fwtb58odh	Marionberries	1	\N	2025-04-28 02:13:27.573558+00	2025-04-28 02:43:00.620935+00	2025-04-27 22:09:36+00	f	mpdwvzw
3dde14b2-1da3-4560-a744-c46137be95a2	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_625wr4al	Yes	1	\N	2025-04-28 02:13:27.576617+00	2025-04-28 02:43:00.625426+00	2025-04-27 23:53:50+00	f	mpef8tu
ba8b1382-7827-45d7-bb39-49e8bdf258f3	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_962gpaone	YES!	1	\N	2025-04-28 02:13:27.579447+00	2025-04-28 02:43:00.629968+00	2025-04-28 00:48:57+00	f	mpeo9wk
bd46127f-32a3-43e4-8e74-664f91e7cdf2	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_eyni6	We just moved into a new place and we have several unknown berry bushes growing. Can’t wait to learn what they are!	1	\N	2025-04-28 02:13:27.582264+00	2025-04-28 02:43:00.634164+00	2025-04-28 01:59:23+00	f	mpezodt
0737a2a4-63cb-4797-a902-4c57a932d361	897058e3-6721-46d2-bf94-276843bc87c3	t2_4kgv3um4	Oregon is intoxicating! So glad you enjoyed your time!	35	\N	2025-04-28 02:13:35.503042+00	2025-04-28 02:43:10.660708+00	2025-04-28 00:22:15+00	f	mpejwtk
fd21f482-9541-44bc-b67c-93b68089c3a9	897058e3-6721-46d2-bf94-276843bc87c3	t2_d8iitwtm	Bring your job and you’ll love it.	31	\N	2025-04-28 02:13:35.504769+00	2025-04-28 02:43:10.665773+00	2025-04-28 00:22:21+00	f	mpejxd8
fba5e574-fb2f-4e9b-9265-5cef2b5a9902	897058e3-6721-46d2-bf94-276843bc87c3	t2_5hp1766al	I love Rockaway Beach!! Check out nearby Manzanita, too, when you come back. &lt;3	11	\N	2025-04-28 02:13:35.508599+00	2025-04-28 02:43:10.670372+00	2025-04-28 00:44:13+00	f	mpenial
640628e8-90f7-4650-ad6e-01ec72b4dda2	897058e3-6721-46d2-bf94-276843bc87c3	t2_e3x3uslyj	That’s rad! Believe it or not, you barely scratched the surface of this state’s beauty. I’ve been here 13 years now and it still blows me away how much natural beauty is in this state. Come on and move out. It’s a great place to live!	27	\N	2025-04-28 02:13:35.50658+00	2025-04-28 02:43:10.67481+00	2025-04-28 00:14:56+00	f	mpeipw0
f8422db2-1f96-400f-bdeb-5be2025e5d96	897058e3-6721-46d2-bf94-276843bc87c3	t2_1eggn1vj	If you can work remotely then go for it. All the small towns you mentioned have very few well paying jobs.	7	\N	2025-04-28 02:13:35.510646+00	2025-04-28 02:43:10.679906+00	2025-04-28 00:49:17+00	f	mpeobyz
c9d96f57-b739-40dc-b66d-766fdec0ad3e	897058e3-6721-46d2-bf94-276843bc87c3	t2_ho4tlcam	You are more than welcome.  Here’s the thing, you now know our secret, please lie to everyone else and say we are horrible.  You can keep a secret? 🥰	7	\N	2025-04-28 02:13:35.512644+00	2025-04-28 02:43:10.684415+00	2025-04-28 01:11:18+00	f	mpervt8
032542ee-181a-42d3-ae6e-dbc11607f8c1	897058e3-6721-46d2-bf94-276843bc87c3	t2_ykou8	You were blessed with some uncharacteristically lovely spring weather over these last 10 days!	5	\N	2025-04-28 02:13:35.5146+00	2025-04-28 02:43:10.688644+00	2025-04-28 01:03:21+00	f	mpeqlhz
94e6fda6-6731-474f-ba5a-88aa3c3944d1	f249ff7a-a6dc-4b42-9669-017a88eace81	t2_wldkk7ns1	Those dogs are delicious. Yeah they’re unlicensed, yeah they’re shady AF, but damn if they aren’t amazing after some $14 beers in the stadium.	65	\N	2025-04-28 05:55:03.057414+00	2025-04-28 05:55:03.057414+00	2025-04-27 21:19:27+00	f	mpdnpge
ab23fb5a-3a4b-4abd-8489-1696968728ab	f249ff7a-a6dc-4b42-9669-017a88eace81	t2_rwmcg8apd	Can anyone read the hand written part?	7	\N	2025-04-28 05:55:03.061675+00	2025-04-28 05:55:03.061675+00	2025-04-27 20:17:18+00	f	mpdbl5f
5fa8086b-dc52-4fa4-841a-4a4368f48ef6	f249ff7a-a6dc-4b42-9669-017a88eace81	t2_assnp	I ate one of those after a blazers game and got the worst food poisoning ever	15	\N	2025-04-28 05:55:03.065311+00	2025-04-28 05:55:03.065311+00	2025-04-27 21:43:19+00	f	mpds3i1
c5b00db8-20f3-4c88-b2b9-d9c445f9ee32	c8025fda-8490-43bc-93ac-cda53581687d	t2_14n8tryf56	Oof—I’ve been there. All my good luck to you.\n\nThey’re crepuscular, so evening or early morning may be the best times to cross paths. If Simon is not familiar with the outdoors, you’re likely to find him very close to your place, but well hidden. They get spooked being without their usual environment and will likely hide. Check all the little crannies you can. Mine was found playing in a box literally the next building over, but was gone for days. He never responded to my calls, despite being a gregarious and social cat. If you have chill neighbors, maybe give them a heads up that you’ll be patrolling the ‘hood for a cat so they don’t call the cops on you (ask me how I know.) If you sit outside in the quieter times (we did this in the late evening) and just talk casually with someone, he may come to the sound of your voice. Leaving litter out seems to be advocated by some and not advocated by others. He may smell himself and come to it, but it can also attract other animals, which could serve to keep him away from it. That’s all the lost-cat brain dump I can recall at the moment, but I’ll come back if I remember more.\n\nHoping Simon is home ASAP! He’s a beautiful cat.	2	\N	2025-04-28 00:16:50.603816+00	2025-04-28 02:41:45.654937+00	2025-04-27 18:31:30+00	f	mpcr7x4
d89ede48-ae2e-4157-b631-b30801a6d8be	a3a6e6fd-0861-40c2-b9df-d6e41d0f0f43	t2_139yylgyln	Update - SOLVED. I'm almost positive we were in the sunroom at Seasons &amp; Regions.\n\nI found some older photos of the sunroom when they were using wrought-iron furniture and it really looks like a match. Which would mean my memory failed me on a couple of things (it's SW and not on a hillside), but I guess that's gonna happen when you're 49 and trying to remember a resto you went to once 10 years ago.\n\nWill have to go back there this summer and relive it!\n\nThank you for all the guesses—gave me a couple of suggestions of new (to me) places to try that are still open.	29	\N	2025-04-28 02:12:43.880428+00	2025-04-28 02:42:00.24287+00	2025-04-27 22:27:58+00	f	mpe08hw
882327e1-7076-46d9-9497-ca98f6c2be74	a3a6e6fd-0861-40c2-b9df-d6e41d0f0f43	t2_dlhh6	Maybe Meriwether’s? It was in NW close to Montgomery Park. I’m not sure what you mean by “not in a NW neighborhood but wider NW quadrant.”	16	\N	2025-04-28 02:12:43.890864+00	2025-04-28 02:42:00.257748+00	2025-04-27 19:18:13+00	f	mpd087l
a11593a5-8f1a-44a6-a683-9139e86fe5a1	897058e3-6721-46d2-bf94-276843bc87c3	t2_1cyu41o5xk	https://preview.redd.it/and93prszgxe1.jpeg?width=1284&amp;format=pjpg&amp;auto=webp&amp;s=84be1681abc73cb3772ee9b5f736458dca622ce5	10	\N	2025-04-28 02:13:35.52149+00	2025-04-28 02:43:10.697211+00	2025-04-28 00:27:07+00	f	mpekq2n
71e2c387-c267-4535-be1a-4bd82324521b	897058e3-6721-46d2-bf94-276843bc87c3	t2_2zm2paeq	If you have kids and care about education I'd recommend against it. We're ranked 31st in the nation with a safety rating at 44th worst. If you like the nature of Oregon I'd recommend Washington, they're 4th in the nation and 24th for safety.	2	\N	2025-04-28 02:13:35.518412+00	2025-04-28 02:43:10.70131+00	2025-04-28 01:20:47+00	f	mpeteui
d22bdd62-64af-4ab4-8e29-84561f300cd7	897058e3-6721-46d2-bf94-276843bc87c3	t2_h6zmd9mq2	Come back in late November and see if you really want to live here. Spring/Summer is deceiving	3	\N	2025-04-28 02:13:35.520153+00	2025-04-28 02:43:10.705374+00	2025-04-28 01:34:43+00	f	mpevo03
4dc9a4ca-df8c-4228-9aec-df01101ebf18	897058e3-6721-46d2-bf94-276843bc87c3	t2_y8g5o	You should, you won't regret it.	1	\N	2025-04-28 02:13:35.52649+00	2025-04-28 02:43:10.709869+00	2025-04-28 02:06:50+00	f	mpf0v2i
e98df71b-c294-4bfd-aca3-d1856b357a36	897058e3-6721-46d2-bf94-276843bc87c3	t2_izwy2t4p	It’s a great state to visit if you don’t mind horrible traffic everywhere.	-1	\N	2025-04-28 02:13:35.524855+00	2025-04-28 02:43:10.718343+00	2025-04-28 01:01:03+00	f	mpeq82x
1d88bbe6-2b90-4af3-96fe-45c7b63589f3	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_dz6qx2d3	I live in the midwest now and am moving to Portland in June. \n\nMy conservative parents and extended family are disgusted by my decision to move. They are convinced I’m going to kidnapped and murdered by a crack addict and that there will be no cops to protect me.\n\nMeanwhile I’m like the urban vibes mixed with gorgeous nature seems like the ideal city for me. Plus I got a great relocation package from my new job. I’m so excited for this new adventure.	20	\N	2025-04-28 02:12:20.774393+00	2025-04-28 05:54:45.307364+00	2025-04-28 01:41:51+00	f	mpewtrz
e96c1d32-7e40-438b-abc8-b9d5b5c7fdde	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_sjy5o92	I got absolutely eviscerated on askreddit for pusing back against the statement that Portland is plagued by "astonishing levels of poverty". I don't know why I even bother	2	\N	2025-04-28 02:41:29.192535+00	2025-04-28 05:54:45.405257+00	2025-04-28 02:35:22+00	f	mpf5b5m
ae2cf905-04db-408b-842f-be71f0252223	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_733gn	Where you surprised red hat, conspiracy theory loving relatives were wrong?	1	\N	2025-04-28 02:41:29.208379+00	2025-04-28 05:54:45.4816+00	2025-04-28 02:15:11+00	f	mpf26lk
b78b0e0e-ac8b-4c76-bf4f-4f1cecbc4d11	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_81s6cpaa2	Sip sip \nsippin on a Sherpa\nSippin on a Sherpa	1	\N	2025-04-28 02:41:37.578409+00	2025-04-28 05:54:54.564162+00	2025-04-28 02:31:12+00	f	mpf4o7q
7ff910a6-0d7d-4739-a015-3ea48df8d5c7	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_23o6	Good thing he got his amphibious thingy from AliExpress before the tariffs went into effect.	0	\N	2025-04-28 02:41:37.574958+00	2025-04-28 05:54:54.616507+00	2025-04-28 02:29:28+00	f	mpf4ehy
7c3002e8-0111-4a30-97f4-76e61b1e6be7	f249ff7a-a6dc-4b42-9669-017a88eace81	t2_15eqpo	If a seagull was selling me a hotdog I would eat once and chew like cud the rest of the day as I periodically burped bits of it up, that seagull would absolutely be allowed to stand on that sign.	6	\N	2025-04-28 05:55:03.068793+00	2025-04-28 05:55:03.068793+00	2025-04-27 20:26:49+00	f	mpddg5e
bbe3f5dd-bd24-4fad-b38a-bcfe0c423136	f249ff7a-a6dc-4b42-9669-017a88eace81	t2_63yzx	Initially read this as “No Sidewalk Venting”	2	\N	2025-04-28 05:55:03.072276+00	2025-04-28 05:55:03.072276+00	2025-04-27 22:18:39+00	f	mpdyiit
2d39679c-b126-4801-b70d-03a9ddd3bfd1	f249ff7a-a6dc-4b42-9669-017a88eace81	t2_3mm9p	I'm pretty sure "no seagulls" signs aren't a real thing, and that image is a silly Photoshop :-D	2	\N	2025-04-28 05:55:03.076383+00	2025-04-28 05:55:03.076383+00	2025-04-28 01:05:38+00	f	mpeqyry
c058c10c-d1b1-4224-b71c-96d58473dca0	f249ff7a-a6dc-4b42-9669-017a88eace81	t2_ppp0rff5	These places always kick ass. Keep them going	5	\N	2025-04-28 05:55:03.079808+00	2025-04-28 05:55:03.079808+00	2025-04-27 23:46:04+00	f	mpedx03
e70e1416-9963-4b6b-a2ed-7780bd6d57f7	f249ff7a-a6dc-4b42-9669-017a88eace81	t2_v3sn4jwd	I respect the hustle. I don’t respect not being licensed and permitted when so many other local restaurants are paying their fair share.	8	\N	2025-04-28 05:55:03.083615+00	2025-04-28 05:55:03.083615+00	2025-04-27 21:09:47+00	f	mpdlvwn
17627827-99be-4e96-95d7-fe131388c19c	f249ff7a-a6dc-4b42-9669-017a88eace81	t2_k7c2rffpc	Whatever your feelings about a Thorns final score, there will always be street corner hotdogs	1	\N	2025-04-28 05:55:03.08701+00	2025-04-28 05:55:03.08701+00	2025-04-28 05:52:44+00	f	mpfuqds
c87d8c47-5955-454c-bac9-849bbd7aff5f	f249ff7a-a6dc-4b42-9669-017a88eace81	t2_16tftm	where is this? ( just playing guess-that-location and I'm stumped.)	1	\N	2025-04-28 05:55:03.090402+00	2025-04-28 05:55:03.090402+00	2025-04-27 22:22:50+00	f	mpdz9yu
3fef1a13-c540-44cb-ad83-99cff8f2cb2c	f249ff7a-a6dc-4b42-9669-017a88eace81	t2_11gk9c	When does the city actually start enforcing scoff laws...	-1	\N	2025-04-28 05:55:03.09496+00	2025-04-28 05:55:03.09496+00	2025-04-27 20:48:36+00	f	mpdhqqt
39754843-7e54-4290-b5aa-5cd654f58fd6	5d3fe894-4aba-458d-9dbd-9dfbc388d8ea	t2_29tgtdna	 Neighbor found bird!!!!! All 😊	83	\N	2025-04-28 05:55:11.412064+00	2025-04-28 05:55:11.412064+00	2025-04-28 03:55:56+00	f	mpfgu94
d8e19da6-42c3-4529-9f15-b5eb879cbb1b	5d3fe894-4aba-458d-9dbd-9dfbc388d8ea	t2_29tgtdna	Lost at N Arlington and Wabash	16	\N	2025-04-28 05:55:11.416265+00	2025-04-28 05:55:11.416265+00	2025-04-28 00:46:20+00	f	mpenulp
4278ead1-d92e-4708-8c49-59257cf1c8c9	5d3fe894-4aba-458d-9dbd-9dfbc388d8ea	t2_ivjjw	so cute. hope they get home soon!!	7	\N	2025-04-28 05:55:11.419959+00	2025-04-28 05:55:11.419959+00	2025-04-28 02:16:50+00	f	mpf2fxy
a709c55f-0e08-4374-8740-9e04a5dfe40a	0f630be1-6dd1-4241-9edd-ed8264326840	t2_c9uvu	Why would you post this garbage?	16	\N	2025-04-28 05:56:02.389917+00	2025-04-28 05:56:02.389917+00	2025-04-27 17:38:32+00	f	mpcgosx
54fff82c-90c2-49c2-8cf4-a3cd294b1ecc	a3a6e6fd-0861-40c2-b9df-d6e41d0f0f43	t2_j4iu5o1z	Raised deck that doesn't over look a street, serves seafood, nice but not fine dining, homey feel, appears on "best of" lists, and not really a "neighborhood". Wouldn't be *Caro Amico* would it? It is in SW but it is very close in and could easily be mixed up in memory.	3	\N	2025-04-28 02:12:43.927534+00	2025-04-28 02:42:00.297659+00	2025-04-27 22:22:01+00	f	mpdz4ft
eae20000-c644-4727-8fa8-72b1e8674265	2a23728f-6dd6-4c21-b2dc-c077e779ac31	t2_4wl6khda	Cool Aunt Cleaners (owner/operator Anna-Marie Ortiz) is amazing and a great deal. I think I saw they might have had a coupon recently for services. They are on IG @coolauntcleaners	9	\N	2025-04-28 02:42:15.993285+00	2025-04-28 02:42:15.993285+00	2025-04-27 03:22:27+00	f	mp98ybo
bff79529-bb8b-4cb6-9729-e94a525498fb	2a23728f-6dd6-4c21-b2dc-c077e779ac31	t2_16mi4pmc6o	Depends on what part of the city you're in, but I'd clean for $20/hr plus cost of supplies. If you have the necessary supplies, I could just use yours and keep it a flat $20/hr. Probably a lot cheaper than a company would be.	1	\N	2025-04-28 02:42:16.006022+00	2025-04-28 02:42:16.006022+00	2025-04-27 23:58:52+00	f	mpeg374
52fd3032-ea8c-4b70-befd-93bac7638981	4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	t2_1zlii9oq	I mean if I had the money I would buy one of these, pretty cool pieces of equipment. Idk why people are hating.  It’s no worse than a boat.  I only hope he brings it to lake Oswego	1	\N	2025-04-28 02:42:30.993649+00	2025-04-28 02:42:30.993649+00	2025-04-28 02:27:58+00	f	mpf4670
68fcfe6a-afd3-4c9a-81e9-7df5c49a449e	4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	t2_brqkezgm	Seeing a Unimog is fucking awesome. I don't like seeing it on our waters, but I am impressed for what it is.?here.	1	\N	2025-04-28 02:13:04.601842+00	2025-04-28 02:42:31.02042+00	2025-04-28 02:02:35+00	f	mpf06un
bed6185f-2da0-4531-b555-a09aa7f60cb5	4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	t2_1cjph7pzqi	Rapetastic.	1	\N	2025-04-28 02:42:31.025991+00	2025-04-28 02:42:31.025991+00	2025-04-28 02:31:32+00	f	mpf4q0m
8e15eaa0-d635-41a5-8410-6e02b78e1007	4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	t2_auoe29qa	Passed that today while not catching any salmon on the river 😖	1	\N	2025-04-28 02:42:31.031968+00	2025-04-28 02:42:31.031968+00	2025-04-28 02:40:52+00	f	mpf654j
f578855b-3cbd-43a0-849a-0d0561bf1c82	8e4f3362-f041-4973-b352-4d5b5e0b120c	t2_6eg0e68t	If we had more extensive rail service, I would ride a lot more. It just takes too long to get to a lot of places. I can't afford to spend that much time on public transit. It can easily take three or four times as long once you figure in transfer times. I also don't like dealing with the bad smells and unstable people on the train, but that is a lower priority for me than the amount of time. I don't like how dirty everything feels on our public transit and miss the cleaner buses we had during the pandemic. The closest transit to me is Lombard and Interstate. I see people fucking, pissing, and shitting there at 2AM. Someone is always doing drugs or just being a creep around this intersection regardless of time. I just can't deal with that before or after a ten hour shift. I don't have it in me.	44	\N	2025-04-28 02:13:14.70509+00	2025-04-28 02:42:39.410506+00	2025-04-27 18:54:02+00	f	mpcvl76
90ecff9a-3253-4f51-97c6-ff3f3b370460	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_wldkk7ns1	I'm a bit biased but NW23rd is great.  Lots of shops and restaurants and very walkable.  If you're feeling adventurous you can walk to Forest Park through the Lower Macleay trailhead.  Enjoy!	61	\N	2025-04-28 02:42:47.670398+00	2025-04-28 02:42:47.670398+00	2025-04-27 17:19:45+00	f	mpccu4v
6b6b1e80-7612-4d9e-9c0a-48789002a071	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_8y3zcg9r	Hit up CoCo donuts or Jinju Patisserie on N Williams Ave then pop into all the cute shops there. Walk a few blocks over to Mississippi Street which has more local shops. Both streets have lots of great food/bars!	34	\N	2025-04-28 02:42:47.675238+00	2025-04-28 02:42:47.675238+00	2025-04-27 17:20:26+00	f	mpccyz0
d1907362-8306-4fc2-a050-cdaf3c85648d	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_d45u6	Ok OP, born and raised in Portland here. Here's the reality. The people suggesting Voodoo aren't from Portland. For years it's well known to be the biggest tourist trap in the state by many. Downtown is where you're supposed to go. However, it's only for tourists and employees from the suburbs. We actually have neighborhoods/districts where the real locals go. Honestly, the only real reason to go there is because of Powell's, Pioneer Square, and OMSI. Chinatown isn't what you think it is. It's not a real Chinatown. It's where our meth clinics are. Anything that used to be Chinese is ran down and closed except 2 things. People only say otherwise because we're desperate for people to go back. Downtown. Downtown was hurting during the pandemic	13	\N	2025-04-28 02:42:47.679296+00	2025-04-28 02:42:47.679296+00	2025-04-27 18:10:02+00	f	mpcn1gk
346e9b12-1c59-446b-8772-c0d3f6c847f9	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_nl8mc332	Nob Hill (nw23rd and nw21st) def has some great stuff! Hawthorne and Belmont are great too! And I def agree with the Alberta comment! Can’t forget Mississippi between skidmore and Fremont too!	10	\N	2025-04-28 02:42:47.683199+00	2025-04-28 02:42:47.683199+00	2025-04-27 17:31:07+00	f	mpcf66k
1392a8cc-41e4-495c-b5bc-9448d3483539	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_q6dek0i7e	Pips on N Fremont is delicious and it’s a great little walk of shops, etc.	16	\N	2025-04-28 02:42:47.687056+00	2025-04-28 02:42:47.687056+00	2025-04-27 17:23:10+00	f	mpcdj5a
1693b2a0-200a-42f1-b6de-241faf45136c	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_9y6q7	Alberta st between 15th and 33rd, or Mississippi between Skidmore and Fremont	22	\N	2025-04-28 02:42:47.691135+00	2025-04-28 02:42:47.691135+00	2025-04-27 17:22:37+00	f	mpcdf27
f9a4a923-fd5a-472c-93fa-d0630f0de20e	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_bk4hwz7y	Check out Proud Mary on Alberta street and walk the strip! Lots of shops and artsy vibe	11	\N	2025-04-28 02:42:47.694989+00	2025-04-28 02:42:47.694989+00	2025-04-27 17:20:54+00	f	mpcd2ma
4f5ce267-864d-4ad3-a382-a574efbb8626	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_2z6rcciu	 NW 23rd and Pearl have a pretty good concentration of spots, even downtown itself has a few but I always recommend the eastside, with Division, Hawthorne, Belmont, Burnside etc. can’t really go wrong and all only a few mins from each other.	10	\N	2025-04-28 02:42:47.698947+00	2025-04-28 02:42:47.698947+00	2025-04-27 17:22:36+00	f	mpcdf11
a3109a86-e31d-4417-b238-a506c42187e2	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_9smo0mkf	Pip's Original Doughnuts and Chai on Fremont is a unique donut experience and the neighborhood is cute too. Not as busy/thriving as some others. Also highly recommend Blue Star donuts (several locations in more high foot traffic areas)	5	\N	2025-04-28 02:42:47.702912+00	2025-04-28 02:42:47.702912+00	2025-04-27 17:24:50+00	f	mpcdvdl
eb96ce74-3941-4beb-9c7f-e0ff6b5e185a	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_enld9bxz	NW 23rd/21st, SE Division, SE Hawthorne, N Mississippi, NE Alberta are the best "walking around and having a nice time in Portland" streets (though there are lots of other neighborhood gems beyond those!)\n\nBest breakfast sandwiches are pie spot (not on one of those walkable strips but it is amazing), fried egg I'm in love, either/or, lottie and zulas (can hoof up to Mississippi from there), and Bernstein, spielman, and Henry higgins bagels.\n\nBest donuts are pips, doe, delicious, sesame, and, yes, blue star	4	\N	2025-04-28 02:42:47.706734+00	2025-04-28 02:42:47.706734+00	2025-04-27 18:35:15+00	f	mpcrxw9
239b3163-22c0-4400-b0f6-96fb483669c3	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_5koa0fh3	I love Doe donuts. Not the greatest place to walk but the donuts are amazing	3	\N	2025-04-28 02:42:47.711008+00	2025-04-28 02:42:47.711008+00	2025-04-27 17:32:05+00	f	mpcfdcs
0931089a-f9a1-4e70-8f1e-f26c77e3cba3	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_d45u6	Born and raised in Portland here. Spend as little time downtown as possible. Downtown isn't what you think it is. I know downtown is supposed to be the place where everything is. Believe me, I get it. However, downtown is only for tourists and employees from the suburbs. Our downtown isn't much different from any other downtown on the planet. Aside from Pioneer Square and Powell's Books there really isn't anything different	7	\N	2025-04-28 02:42:47.715214+00	2025-04-28 02:42:47.715214+00	2025-04-27 18:01:37+00	f	mpcldnn
3f89fa3b-e21d-4e56-8079-7f5e346597fa	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_q4o411y69	Head on over to Old Town/Chinatown for one of our famous Voodoo Donuts and a nice stroll around one of the quaintest neighborhoods for a calm, peaceful experience of the finest that Portland has to offer.\n\n\n/s	9	\N	2025-04-28 02:42:47.719194+00	2025-04-28 02:42:47.719194+00	2025-04-27 17:23:04+00	f	mpcdidi
b25da534-f5c7-4c8b-8622-acb1b98d951a	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_13s5eo3fak	Alberta or Mississippi	2	\N	2025-04-28 02:42:47.723256+00	2025-04-28 02:42:47.723256+00	2025-04-27 17:51:41+00	f	mpcje0j
cca36717-1b1d-48ba-88e3-279528d77a6c	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_136jc18f8h	Ok, I have donut LOVE. Here’s the dets, Sesame Donuts is located around 39th/Ceasar Chavez and Powell, same side as the Safeway but a bit east. Their devils food donuts are slap me amazing. Not the chocolate, you can get one of those to compare with the devils food, but there is no comparison. \nNext try Heavenly Donuts. At least 3 locations in Portland and one in Milwaukie. These are hood approved (Portland does NOT have any hood anything, but ?). Try their fritters; apple, raspberry or pineapple. Their old fashioned donuts are also tasty. \nLast one and I can’t remember the name is on Sandy in NE across from a Safeway. Also good. \nNow! I want a donut. I’ll take a shower instead.	2	\N	2025-04-28 02:42:47.727374+00	2025-04-28 02:42:47.727374+00	2025-04-27 17:51:52+00	f	mpcjf97
7693bfcf-69f8-4ad6-a03e-d70e9f46ea90	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_3b26rfa5	If OP is from Chicago they'll understand that like Chicago, Portland is a city of neighborhoods.  My vote for the *Portland-est* neighborhood would be a toss up between NW23rd Ave. and the Hawthorne neighborhood.  NW23rd is more aspirational than Hawthorne.\n\nWith one day, visiting a lot of neighborhoods is a big ask.  I don't know that I would bother with the Pearl, even though it's one of the city's great neighborhoods for better or worse it's freakishly similar to River West in Chicago.\n\nGood luck!	2	\N	2025-04-28 02:42:47.731235+00	2025-04-28 02:42:47.731235+00	2025-04-27 19:19:38+00	f	mpd0huz
ece59583-2db6-418c-b16a-c2f11d89ba24	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_p84wvxp2k	start at 23rd and burnside and head north - this is the Alphabet District- shops and restaurants line the streets  - Fireside is a good midway point to stop for a bite - continue all the way down to Thurman ST. and head West (take a left).  Small neighborhood shops - get to Betsy and Iya and decide - more shopping or hike?  for a nice hike head to lower McClay -	1	\N	2025-04-28 02:42:47.735191+00	2025-04-28 02:42:47.735191+00	2025-04-27 17:24:32+00	f	mpcdt6m
8c188888-df90-491d-b21c-889b3b836273	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_gmoryfbh	Portland’s all about the neighborhoods too!  Hawthorne, NW 23rd/21st, the area around E Burnside and 28th, Alberta, Mississippi, St. John’s (which sorta feels like a Chicago neighborhood business district to me), Kenton, Woodstock,  Sellwood.   It’s really hard to go wrong!	1	\N	2025-04-28 02:42:47.739134+00	2025-04-28 02:42:47.739134+00	2025-04-27 18:32:55+00	f	mpcrhpm
e56f9b67-59a2-4bbe-848c-bbc74a22693e	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_6xopa	Sterling Coffee on 21st/Glisan has amazing coffee and a caramel sticky cinnamon roll type thing I crave daily. Great spot for lunch down from there too called Kung POW! Their noodles are so good.	1	\N	2025-04-28 02:42:47.743002+00	2025-04-28 02:42:47.743002+00	2025-04-27 18:40:20+00	f	mpcsx7o
51d32955-d345-4514-926a-c8867859f8d7	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_41euzczp	Tanaka downtown has a really good egg sandwich and coffee (I recommend the fries, trust me they’ll hit the breakfast spot), not a charming neighborhood since it’s downtown but there are some interesting shops around there.\n\nLots of good recs here for neighborhoods, but if you’re staying downtown and want something nearby you should def check them out.	1	\N	2025-04-28 02:42:47.747166+00	2025-04-28 02:42:47.747166+00	2025-04-27 19:59:20+00	f	mpd83z2
c6811db8-6dec-489c-a130-e9d59db98fae	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_sdra1f82	Old town	1	\N	2025-04-28 02:42:47.751135+00	2025-04-28 02:42:47.751135+00	2025-04-27 20:19:10+00	f	mpdbybs
4135b2f6-7f67-45b1-9e0f-011024bafe4d	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_32vzj	Doe donuts is Amazing vegan donuts, and we know for sure they protect worker's rights! (Not true with voodoo donuts for example).	1	\N	2025-04-28 02:42:47.755089+00	2025-04-28 02:42:47.755089+00	2025-04-27 20:40:47+00	f	mpdg7w1
3e52960c-bb04-4762-b1bd-29ee55e31830	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_ugsewebo	A bit out of the way, but Case Study on on 53rd and Sandy is great, and Bakeshop two doors down has the best almond croissant I've ever eaten.	1	\N	2025-04-28 02:42:47.758876+00	2025-04-28 02:42:47.758876+00	2025-04-27 21:01:35+00	f	mpdkaj5
89c8963f-fd20-420e-b36b-4b6e02526186	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_j5o2ghyz	Hawthorne bc Mochi Donuts 😋	1	\N	2025-04-28 02:42:47.762726+00	2025-04-28 02:42:47.762726+00	2025-04-27 22:24:12+00	f	mpdzj7h
6d45a202-fc49-496a-b436-099c905b91b4	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_16fznn	Lotsa great places, but I'm missing some love for Kerns.   \n  \nEspecially Burnside around the area between 24th and 28th. No pref coffee is really great and I do love me some Screen Door. Soro Soro is worth checking out too for the cute desserts. There's Laurelhurst theater which might be fun if you want to watch a movie while having some drinks in a historical movie theather.\n\nThere's a local music shop and if you head forward towards 32th, a cool record shop. 28th itself has great options going both north and south. I like mikiko mochi donuts, montelupo and stammtisch and last but not least Ken's Artisan Pizza, but there are really many other little restaurants and shops in these streets.\n\nAnkeny has some nice stuff too close to 28th.\n\nLaurelhurst park is around this area too, and it's quite nice.\n\nCheck it out if you can.  \n[https://www.kernside.org](https://www.kernside.org)	2	\N	2025-04-28 02:42:47.766666+00	2025-04-28 02:42:47.766666+00	2025-04-27 22:25:29+00	f	mpdzrx4
0472abfc-7467-4e45-a15f-8804e975da56	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_1j25slr6	Voodoo old town.	1	\N	2025-04-28 02:42:47.770672+00	2025-04-28 02:42:47.770672+00	2025-04-28 00:50:59+00	f	mpeolov
4b7da64d-dfb9-4578-a57a-e425f80f169c	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_3nbaas5g	Most of the other options are better for getting a feel for Portland's culture, but another idea is to go to the south waterfront neighborhood. There's a donut shop and several cafes, and once you pick up a coffee you can take the Portland Aerial tram to get an amazing view of the city .	1	\N	2025-04-28 02:42:47.774576+00	2025-04-28 02:42:47.774576+00	2025-04-27 17:40:36+00	f	mpch4dy
971d7bea-ccb3-4b39-ba5c-3c3e1f7feeae	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_nnnwiwhu2	You may have heard of Salt and Straw but personally I would give it a pass. I had some for the first time recently and spent the next four hours feeling nauseous. And I had a more traditional flavor, not one of the adventurous ones.	1	\N	2025-04-28 02:42:47.778395+00	2025-04-28 02:42:47.778395+00	2025-04-27 17:50:51+00	f	mpcj7rt
fc86359b-dc50-4b1a-9b0b-e61bcb6408c6	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_wyc4v7z2j	Currently enjoying a coffee at Seven Virtues (NE Sandy) and donut from Doe’s up the street (Hollywood district). Both pleasant.	1	\N	2025-04-28 02:42:47.782454+00	2025-04-28 02:42:47.782454+00	2025-04-27 18:59:29+00	f	mpcwn3e
dee056ed-4c46-4207-b480-d5ea9b065e6c	c5d7e872-d01b-411b-9b33-3a4ded18c008	t2_4v4srbbu	If you wana go out on a Saturday THEN Voo doo is worth it. On Saturday right next to it, is the Saturday Market. Lots of great shopping and art.	-2	\N	2025-04-28 02:42:47.786288+00	2025-04-28 02:42:47.786288+00	2025-04-27 17:58:14+00	f	mpckpfz
41bc2c0c-661e-4a0e-bfb3-cfcc55634421	55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	t2_3okb3c2m	Yes! The parks and drives are lined with bushes already. I can usually walk down to the end of road, fill a collander, and come home. I do this a couple of times a season. Last season, they were really small here, but we had a very dry spring last year. We are definitely making up for it this year, so I am hoping the sun comes out soon for bountiful crops!	4	\N	2025-04-28 02:13:27.526074+00	2025-04-28 02:43:00.531366+00	2025-04-27 19:21:36+00	f	mpd0vhu
ae38ca74-66cb-4434-b4b8-95e1a577041b	897058e3-6721-46d2-bf94-276843bc87c3	t2_3awfkpbb	Coming up on 9 years living in Portland and I love it. All of the things people bitch about are things you'll find in any major city. You're always like an hour or two from almost any nature thing you could want and the weather is beautiful like 80% of the time. Trees everywhere. I lived in Phoenix most of my life and I am thankful every single day I wake up here instead lol	6	\N	2025-04-28 02:13:35.51658+00	2025-04-28 02:43:10.692988+00	2025-04-28 01:09:22+00	f	mperkga
32362e82-4d98-4830-ad1e-b9c7edd4601a	5d3fe894-4aba-458d-9dbd-9dfbc388d8ea	t2_2xc2vxjo	Leave their cage outside if you can! You can also try posting in the Facebook group 911 Parrot Alert. I’ve seen them find and connect a lot of people who have lost their birds! \n\nI have a greenie and I’d be devastated if he got out! I hope they come back! 	8	\N	2025-04-28 05:55:11.423172+00	2025-04-28 05:55:11.423172+00	2025-04-28 02:43:27+00	f	mpf6j9d
94df7341-47a5-4c89-98b9-3ea8953f95d6	5d3fe894-4aba-458d-9dbd-9dfbc388d8ea	t2_122eyg61	Commenting to boost visibility! I hope you find your babies!	6	\N	2025-04-28 05:55:11.427047+00	2025-04-28 05:55:11.427047+00	2025-04-28 02:28:38+00	f	mpf49xi
59632c8f-e0c1-44ea-b5b9-fffe03be9676	897058e3-6721-46d2-bf94-276843bc87c3	t2_1jdhdxmqv5	Depending on where you are from, there are places to live all over the state that may be similar to what you are used to. Coastline - north or south coasts (further north is colder and windier but more rugged). Desert city with four season weather with trees and plateaus - Central Oregon (Bend, Redmond, Sisters). High desert with higher mountains - Eastern Oregon (La Grande, Pendleton, Burns). More greenery with more rain and more population - Willamette Valley (Portland, Salem, Eugene). Still green with more mountains and less population - Southern Oregon (Roseburg, Medford, Grants Pass)…. Plus, so many other amazing cities/towns (Crater Lake, Mt Hood, Mt Bachelor, Shakespeare Festival, Kite Festivals, rock hunting, gold panning, skiing, hiking, mountain biking……) and options to visit/live that would fill up books. If you go to the State of Oregon Visitor’s website, they have all kinds of videos and data of the state. It has pretty much anything you would want to know about. Hope that helps. Good luck with your decision!	2	\N	2025-04-28 02:13:35.523063+00	2025-04-28 02:43:10.714158+00	2025-04-28 00:35:05+00	f	mpem12x
699610f0-c1d5-43a8-8671-5232e70b4b64	e08aa3dc-13c6-49f2-9e86-5539c13308dc	t2_3oz4pn1m	Great shot!	1	\N	2025-04-28 02:43:18.518703+00	2025-04-28 02:43:18.518703+00	2025-04-27 05:04:23+00	f	mp9m4i0
d473d07f-6e1e-4ab4-9dbc-2dffa281f90a	e08aa3dc-13c6-49f2-9e86-5539c13308dc	t2_vojxvwgu	There's a nest around there.	1	\N	2025-04-28 02:43:18.527307+00	2025-04-28 02:43:18.527307+00	2025-04-27 11:22:03+00	f	mpao5aq
06229521-c13d-46b4-8709-e780fb05c587	e08aa3dc-13c6-49f2-9e86-5539c13308dc	t2_1d9zp38yqd	Wow, impressive shot!	1	\N	2025-04-28 02:43:18.53476+00	2025-04-28 02:43:18.53476+00	2025-04-27 14:00:51+00	f	mpbaxkw
44148aca-17c0-4943-8d55-d6a501f78a5a	e08aa3dc-13c6-49f2-9e86-5539c13308dc	t2_vhswh5gz	Good beach break out there in front of the state park wayside	1	\N	2025-04-28 02:43:18.541839+00	2025-04-28 02:43:18.541839+00	2025-04-27 19:35:43+00	f	mpd3jn6
1ff24c94-7f5a-4384-93ae-f26451e6c068	e08aa3dc-13c6-49f2-9e86-5539c13308dc	t2_1k9jiou51k	I have one from around there with eagle just chilling in the tide	1	\N	2025-04-28 02:43:18.547603+00	2025-04-28 02:43:18.547603+00	2025-04-28 01:47:06+00	f	mpexojd
b81e4fc3-ad1d-429f-91f7-18e455d427e1	04c7771e-89d5-4d14-b40f-e63611d9a23c	t2_a1t2ob4u	Cocklick is also appropriate here.	6	\N	2025-04-28 02:43:30.915426+00	2025-04-28 02:43:30.915426+00	2025-04-26 18:30:56+00	f	mp6qu88
0a05d784-7164-4d56-a481-ee0d5f1ffd7e	ead4eb41-8dd3-4145-bcb0-b58fd77c545d	t2_2sd46a7f	Can the two Portland 50501 groups please at least alternate event dates? I see asks for volunteers and talking about burn out but then planning events the same day. There are literally 3 events listed on the 50501 website for mayday.\n\n\nIt's be better if they could unite, but if that's not possible at least stop dividing the movement by planning things the same day. 	2	\N	2025-04-28 02:43:45.44468+00	2025-04-28 02:43:45.44468+00	2025-04-27 19:34:25+00	f	mpd3afe
c8eb4169-897a-45d3-a090-d2c72b5f595f	6f34a1e7-0f99-4311-a0f7-798218f4001c	t2_j4y6r	Great job, y'all!	8	\N	2025-04-28 02:44:15.476789+00	2025-04-28 02:44:15.476789+00	2025-04-27 19:32:40+00	f	mpd2yk9
74084bbd-f99a-47d1-9d6f-dbf126942fe3	6f34a1e7-0f99-4311-a0f7-798218f4001c	t2_moa11ba	You all rock!!	4	\N	2025-04-28 02:44:15.490176+00	2025-04-28 02:44:15.490176+00	2025-04-27 21:12:02+00	f	mpdmbdc
1ab8764e-599d-48c8-80c3-0e2ea9601bf5	6f34a1e7-0f99-4311-a0f7-798218f4001c	t2_10r1m5zyvg	ABG fellow gamblers! Good stewardship, and thank you!	3	\N	2025-04-28 02:44:15.501889+00	2025-04-28 02:44:15.501889+00	2025-04-27 22:00:15+00	f	mpdv76j
6291b90e-14d1-46a6-9344-b7559850aff1	6f34a1e7-0f99-4311-a0f7-798218f4001c	t2_9dd4jovw	Takes a special kind of dumb asshole to dump a freezer full of meat in the woods. Waste of food, waste of a freezer, and he made it someone else's problem. It's a damn shame.\n\nThanks for being better than that!	1	\N	2025-04-28 02:44:15.514833+00	2025-04-28 02:44:15.514833+00	2025-04-28 02:36:51+00	f	mpf5j7k
65653bef-4319-45ab-8a99-2b6d458274d9	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_sgq9wdoo	Well this is nice 🥹\nWe never get nice. Thank you 🙏	2	\N	2025-04-28 05:54:45.410264+00	2025-04-28 05:54:45.410264+00	2025-04-28 03:10:33+00	f	mpfakv6
9ab89c53-a685-485f-b7ef-6016831a017a	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_fbbtv	Please let your family keep their opinions.\n\nSeriously.	2	\N	2025-04-28 05:54:45.416611+00	2025-04-28 05:54:45.416611+00	2025-04-28 03:11:33+00	f	mpfaq4b
d7d6543e-cc7d-49ae-a3c2-640ac6da6186	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_btnufvou	My partner and I had very low expectations when we visited for the first time last October. We’re moving there in August.	2	\N	2025-04-28 05:54:45.421868+00	2025-04-28 05:54:45.421868+00	2025-04-28 03:40:18+00	f	mpfeqjs
a2bb8cba-88e9-434e-b61d-ccdd10dfe30c	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_8duvo	Portland has immensely improved since the lulls of 2020-2022.\n\nAdditionally tourists don't deal with the problems that residents do.  Tourists don't have to worry about a homeless encampment blocking the sidewalk in front of their house for months on end. Tourists don't have to deal with a school system that's ineffective and losing students to the suburbs, and facing massive cuts in the near future. Tourists don't have to worry about the near impossibility of building housing due to an insanely expensive and slow permitting system. Tourists don't have the worry about the some of the highest income taxes in the nation. Tourists don't have to worry about a police force that depending on who you ask, is either intentionally ineffective or severely under-resourced. \n\nPortland is a great city, and it's got tons of potential, but there are very real problems and people in these threads just post  "see everything is great here, any negativity is a lie" miss the mark.	6	\N	2025-04-28 00:16:42.453722+00	2025-04-28 05:54:45.436391+00	2025-04-27 22:51:27+00	f	mpe4itu
267e931e-7a60-4725-a8c7-32a1c07164b6	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_9dd4jovw	Glad you had a good time here! I feel the exact opposite whenever I have to visit my in-laws in Ohio lol	1	\N	2025-04-28 05:54:45.441897+00	2025-04-28 05:54:45.441897+00	2025-04-28 03:27:48+00	f	mpfd0jj
ff35e572-cb30-4e9c-b11b-e19ad18b5748	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_beun3	It should be obvious to anyone who isn't a complete moron to realize that our real estate market is a beacon that should eliminate the idea that it sucks here.	1	\N	2025-04-28 05:54:45.4469+00	2025-04-28 05:54:45.4469+00	2025-04-28 04:04:05+00	f	mpfhwqj
d0cd7b40-6cff-4095-97aa-d4af3b2a0d91	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_46pg7v1j	Thank you, I'm tired of people parroting faux "news" and trying to say Portland is the seventh level of hell.	1	\N	2025-04-28 05:54:45.452107+00	2025-04-28 05:54:45.452107+00	2025-04-28 04:05:25+00	f	mpfi2ze
c36c9588-4f57-45b4-bd52-bee5c3b0e7ad	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_2l7xsm9k	I live a few miles from downtown but it was my understanding it had burned down..	1	\N	2025-04-28 05:54:45.457187+00	2025-04-28 05:54:45.457187+00	2025-04-28 04:45:55+00	f	mpfn5e3
e9ce6d1e-8e3f-4daf-95a4-863eb8d8475c	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_jporzab1	How about not listening to your conservative family members about anything?	1	\N	2025-04-28 05:54:45.462079+00	2025-04-28 05:54:45.462079+00	2025-04-28 04:59:12+00	f	mpfoq0c
73ef7217-20c1-467c-a3b2-50debb1b790b	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_77x3t	I used to have fun telling my mom back in New England that I’m going to Portland.\n\n“Oh, be careful of the riots blah blah blah Antifa blah blah blah”	1	\N	2025-04-28 05:54:45.467026+00	2025-04-28 05:54:45.467026+00	2025-04-28 05:47:46+00	f	mpfu78e
7a5f8391-814b-4606-b10f-aee5a09d5161	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_dsbm4hzy9	Take them on a drive anywhere in portland for 30 min. Everyone I have had visit is blown away by the homeless and drug use. I have no idea what people are talking about, it cannot be ignored. It’s everywhere in portland and 10% as bad in other cities.	1	\N	2025-04-28 05:54:45.486386+00	2025-04-28 05:54:45.486386+00	2025-04-28 03:27:39+00	f	mpfczse
9f508731-0d48-41c7-b4c3-1df6f42e6f93	cd0595f5-e0a5-4878-a35c-ecb77c52392f	t2_3mf49wtw	"grew up hearing?" I don't know your age but....you mean you heard "horrible" things about Portland for 20-30-40 years???	0	\N	2025-04-28 05:54:45.496022+00	2025-04-28 05:54:45.496022+00	2025-04-28 04:48:54+00	f	mpfniar
8c467a85-1b66-4260-a275-d8054161980e	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_qho98	Not as cool as James Bond’s car/submarine 🤷‍♂️	2	\N	2025-04-28 05:54:54.517476+00	2025-04-28 05:54:54.517476+00	2025-04-28 04:41:40+00	f	mpfmn6x
636250f8-8096-4597-984c-07c05f23bf28	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_82lkxf4e	I thought that was Uncle Baby Billy at first	1	\N	2025-04-28 05:54:54.56992+00	2025-04-28 05:54:54.56992+00	2025-04-28 04:14:20+00	f	mpfj8os
65d757b1-1bd5-4b7b-95aa-3276eb38b3ef	da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	t2_6g1sh8l4	That's CJ Goes! [https://www.youtube.com/shorts/r26UBHDcZXw](https://www.youtube.com/shorts/r26UBHDcZXw)	1	\N	2025-04-28 05:54:54.593462+00	2025-04-28 05:54:54.593462+00	2025-04-28 03:22:05+00	f	mpfc7v8
39b1ffe0-aa2f-4b1d-9044-f4619669c8bf	5d3fe894-4aba-458d-9dbd-9dfbc388d8ea	t2_j20zulhl	Really hope you get your bird back 🥺❤️ post everywhere you can!	3	\N	2025-04-28 05:55:11.43139+00	2025-04-28 05:55:11.43139+00	2025-04-28 03:04:39+00	f	mpf9phj
e2a0685e-9cca-4e40-90e8-bf3344c5a6f9	82ca34f8-93f4-4ff4-a301-9ff00525a369	t2_80dsjugj	I'm surprised run clubs aren't on the list. There are a ton, mostly organized by neighborhood (so there's almost certainly one by you!). The ones I've been to normally meet weekly, start and end at a bar, offer a few routes or distances (usually a 5k and a 10k) and are open to and include runners of every level.	4	\N	2025-04-28 05:55:28.043589+00	2025-04-28 05:55:28.043589+00	2025-04-27 21:18:43+00	f	mpdnkn3
5c7c8ddf-0dfe-4876-8075-c3723fadc101	82ca34f8-93f4-4ff4-a301-9ff00525a369	t2_w7oj2v2c	The fact that this might be something anyone actually needs to hear is reflective of the severe state of alienation and cultural stagnation we are experiencing.	-5	\N	2025-04-28 05:55:28.047768+00	2025-04-28 05:55:28.047768+00	2025-04-27 18:14:17+00	f	mpcnvfg
c2b09bd3-e6db-4271-9fe0-203d05eece36	7a4cd048-f2c4-4117-a01f-6f2cda1b95f0	t2_1y4gm6gp	Filled out the form for Friday morning if it's still open.	1	\N	2025-04-28 05:55:36.346425+00	2025-04-28 05:55:36.346425+00	2025-04-28 05:03:24+00	f	mpfp7pa
023bdd15-8671-440d-90db-c61fb30bbe5f	2b1e4f07-5018-44f1-b30f-ba4d53b7957b	t2_2wflniu5	There are currently [two competing noise ordinance codes](https://www.kptv.com/2025/04/08/portland-music-community-fights-repeal-conflicting-noise-ordinance/), which the committee unanimously agreed for it to go to a vote before the full city council a few weeks ago. And these are the limits for[ Title 18.](https://www.portland.gov/ppd/noise/about-noise-program/about-title-18-noise-code)	18	\N	2025-04-28 05:55:44.765405+00	2025-04-28 05:55:44.765405+00	2025-04-28 01:05:32+00	f	mpeqy6a
d18452ae-0cd8-45cc-b0f1-535967406de8	2b1e4f07-5018-44f1-b30f-ba4d53b7957b	t2_hghxgqd	I saw Mogwai like 15 years ago in Dallas at the Granada Theater, and it was the show that made me realize I need to start wearing earplugs at concerts.	13	\N	2025-04-28 05:55:44.774494+00	2025-04-28 05:55:44.774494+00	2025-04-28 01:25:49+00	f	mpeu89o
4d2ea910-0a72-4dff-a3a8-e533e964a922	2b1e4f07-5018-44f1-b30f-ba4d53b7957b	t2_bse9x	As someone who works in sound loudness and decibels aren't always the same thing, a lot of the end product of how good/loud a band sounds is up to the space acoustics, the PA system, &amp; the mixing engineer. If one of those things suck then you're likely not going to get a loud experience in the audience.\n\nCrystal Ballroom is a notoriously bad space acoustically (still love them, they're working with what they have). I've had the best audience experience at the Get Down, Mississippi Studios or the Aladdin Theater.	10	\N	2025-04-28 05:55:44.783801+00	2025-04-28 05:55:44.783801+00	2025-04-28 01:53:55+00	f	mpeysc9
692592be-8755-4cfc-94e0-a4161f977ec6	2b1e4f07-5018-44f1-b30f-ba4d53b7957b	t2_png8	It's definitely quieter than Austin, and the shows are earlier.	9	\N	2025-04-28 05:55:44.793695+00	2025-04-28 05:55:44.793695+00	2025-04-28 00:15:32+00	f	mpeitho
7a194170-fb16-4262-b349-7150398ff71e	2b1e4f07-5018-44f1-b30f-ba4d53b7957b	t2_bxxw8	Mogwai was quiet as hell. Last time I saw them I was borderline nauseous from the low end when I stood in front of the sub array.\n\nRelated: fuck security at Roseland forever.	9	\N	2025-04-28 05:55:44.806066+00	2025-04-28 05:55:44.806066+00	2025-04-28 01:24:40+00	f	mpeu1hn
047f0451-676a-41b6-a996-f9a56f215b67	2b1e4f07-5018-44f1-b30f-ba4d53b7957b	t2_117xp2jpyl	The sound system at the Crystal is FUCKING DEPLORABLE. \n\nAbsolutely the worst.  So it cannot be used in a fair comparison against any other venue's sound system.	6	\N	2025-04-28 05:55:44.818988+00	2025-04-28 05:55:44.818988+00	2025-04-28 01:28:03+00	f	mpeul8d
1081bce5-32c3-4eb3-82fc-cb30832f33fe	2b1e4f07-5018-44f1-b30f-ba4d53b7957b	t2_2cu1rupk	I saw Acid Mother's Temple at Aladdin and my ears have never hurt so much. If there's an ordinance I don't think they were following it.	3	\N	2025-04-28 05:55:44.83197+00	2025-04-28 05:55:44.83197+00	2025-04-28 01:49:11+00	f	mpey0jv
04cb60e7-3246-439e-aae6-a225a41ed708	2b1e4f07-5018-44f1-b30f-ba4d53b7957b	t2_6mc8o	The Sunn O))) show from a couple years ago and their opener at rev hall were def the loudest sets I’d ever experienced, it was like going to noise church to worship the amps or something. I’m pretty sure I lost hearing even with earplugs in.	3	\N	2025-04-28 05:55:44.84536+00	2025-04-28 05:55:44.84536+00	2025-04-28 04:01:46+00	f	mpfhlwl
20fb78e7-a822-4e69-be55-ae1d9011325a	2b1e4f07-5018-44f1-b30f-ba4d53b7957b	t2_riovcvu6	Depends on the venue: neighborhood venues definitely have ordinances they have to abide by. More so it’s about sound quality, safety for guests and staff and avoiding liability. \nA lot of venues had ridiculous sound quality/production where speakers were popping and it sounded like shit, but that was a “thing”. People were too drunk to notice.  Thankfully, technology and reason prevailed where shows are more engineered to provide a good experience and you’re not deaf for a week. \nMaybe stand next to the speakers?	2	\N	2025-04-28 05:55:44.858288+00	2025-04-28 05:55:44.858288+00	2025-04-28 01:22:58+00	f	mpetriz
7d45d17e-5369-4057-89f5-8daac757b24a	2b1e4f07-5018-44f1-b30f-ba4d53b7957b	t2_gdxma	_tinnitus intensifies_	1	\N	2025-04-28 05:55:44.871526+00	2025-04-28 05:55:44.871526+00	2025-04-28 05:06:12+00	f	mpfpjef
a22c87a9-863e-49d6-bd68-fe715bcd5708	2b1e4f07-5018-44f1-b30f-ba4d53b7957b	t2_12rrca38kt	I've never had an issue. My only other frame of reference is Seattle and the volume levels are about the same between the two cities. \n\nAFAIK there isn't a decibel ordinance but some venues have to close early depending on location (Misdemeanor meadows is a good example, the residential noise ordinance applies to them).	2	\N	2025-04-28 05:55:44.884196+00	2025-04-28 05:55:44.884196+00	2025-04-28 00:42:36+00	f	mpen8ys
3b96eea3-6693-49ac-9a83-93c8d975c8ef	2b1e4f07-5018-44f1-b30f-ba4d53b7957b	t2_l84ys	60db at the property line is not very loud. I live right next to a new theater that's held a couple of events and 60db in the venue = 55 in my apartment.	1	\N	2025-04-28 05:55:44.896854+00	2025-04-28 05:55:44.896854+00	2025-04-28 02:22:48+00	f	mpf3dhk
806ecc50-d1cf-4aff-84e7-a74697dd1f85	2b1e4f07-5018-44f1-b30f-ba4d53b7957b	t2_5e5ruc3m	I agree w ur logic on 106db for Mogwai = external forces at work. Truly insufficient volume, at least 20db shy of par for them. \nI can’t vouch for their most recent show but previous Sunn O))) shows here have been at physically upsetting volumes.	1	\N	2025-04-28 05:55:44.909591+00	2025-04-28 05:55:44.909591+00	2025-04-28 05:01:55+00	f	mpfp1jn
93e105dc-4963-43c0-9dac-472dbb139c35	2b1e4f07-5018-44f1-b30f-ba4d53b7957b	t2_7ygh3	Wouldn't expect a Mogwai show to be loud.  I wish I could've gone to that.	-2	\N	2025-04-28 05:55:44.922276+00	2025-04-28 05:55:44.922276+00	2025-04-28 01:14:18+00	f	mpesd8k
57379952-6af0-42b2-89e9-ab3ad02875e2	8be3d57b-3bbe-4098-8f86-c4ed54959298	t2_9cq03	She drew a heart on my receipt when I was leaving, it must be love!	11	\N	2025-04-28 05:55:53.298059+00	2025-04-28 05:55:53.298059+00	2025-04-27 21:44:38+00	f	mpdsby9
95c0067f-9706-4d04-8493-86cf73e28da3	8be3d57b-3bbe-4098-8f86-c4ed54959298	t2_8h45vndqj	Wait, there are whole isles inside Costco? Seems like it would get pretty sandy.	7	\N	2025-04-28 05:55:53.307567+00	2025-04-28 05:55:53.307567+00	2025-04-27 21:52:35+00	f	mpdttdj
f522f90e-226f-42de-b675-d30edbbb165f	8be3d57b-3bbe-4098-8f86-c4ed54959298	t2_92u1i	You could have enticed her by your Napoleon Dynamite impressions or by showing her your Pokemons but you dropped the ball, man.	9	\N	2025-04-28 05:55:53.317108+00	2025-04-28 05:55:53.317108+00	2025-04-27 21:38:35+00	f	mpdr8al
64410a95-93f7-4c73-a703-bed67ce63c32	8be3d57b-3bbe-4098-8f86-c4ed54959298	t2_wey97	I heard she works at costco. next time take your wife’s boyfriend to wingman	4	\N	2025-04-28 05:55:53.325997+00	2025-04-28 05:55:53.325997+00	2025-04-27 21:43:29+00	f	mpds4i8
510d4cee-1402-456f-a198-ec66dfc7c697	8be3d57b-3bbe-4098-8f86-c4ed54959298	t2_1204ch	Times like that I wish I had had ice in my veins.	1	\N	2025-04-28 05:55:53.334422+00	2025-04-28 05:55:53.334422+00	2025-04-28 00:00:04+00	f	mpegagc
7eb600d7-3d90-45a5-b5d0-68d172f4c4a1	0f630be1-6dd1-4241-9edd-ed8264326840	t2_j0e8rxn	Genuinely curious, did anyone commenting actually read the article to the end?	16	\N	2025-04-28 05:56:02.34186+00	2025-04-28 05:56:02.34186+00	2025-04-27 19:13:39+00	f	mpczdab
6cfd6794-409e-4d0f-b529-1427bfa58ce7	0f630be1-6dd1-4241-9edd-ed8264326840	t2_fiuqh	Feels like an article from 2 or 3 years ago teleported to today	9	\N	2025-04-28 05:56:02.353132+00	2025-04-28 05:56:02.353132+00	2025-04-27 19:24:35+00	f	mpd1fx3
b141e6ea-437a-4547-a11e-05ab8062202c	0f630be1-6dd1-4241-9edd-ed8264326840	t2_q53d4pva	Can we stop throwing around the term "war zone"? Americans haven't experienced a war zone since around the 1860s.\n\nedit\\* spelling	19	\N	2025-04-28 05:56:02.363709+00	2025-04-28 05:56:02.363709+00	2025-04-27 17:45:01+00	f	mpci0zv
cca3f327-4212-433a-9269-073060535594	0f630be1-6dd1-4241-9edd-ed8264326840	t2_74oojiwa	can’t believe people still don’t understand the difference between legalization and decriminalization. no, fentanyl is not legal stop being so brain dead.	16	\N	2025-04-28 05:56:02.373508+00	2025-04-28 05:56:02.373508+00	2025-04-27 17:47:28+00	f	mpcij0h
7db6ece4-2c10-44b3-8207-1d408e08a8c8	0f630be1-6dd1-4241-9edd-ed8264326840	t2_4xg8c	MAGA slop hit piece	19	\N	2025-04-28 05:56:02.382606+00	2025-04-28 05:56:02.382606+00	2025-04-27 17:36:15+00	f	mpcg816
56fafec3-f65b-4d2d-b881-7f7428735104	0f630be1-6dd1-4241-9edd-ed8264326840	t2_54dre5id	Diarrhea article from someone who doesn’t know what they are talking about	7	\N	2025-04-28 05:56:02.394922+00	2025-04-28 05:56:02.394922+00	2025-04-27 17:44:06+00	f	mpchu6j
4a57b0fa-ec4e-4428-a380-766f613744d4	0f630be1-6dd1-4241-9edd-ed8264326840	t2_448naq1y	Great article. It’s true. All of it.	2	\N	2025-04-28 05:56:02.399844+00	2025-04-28 05:56:02.399844+00	2025-04-27 18:39:40+00	f	mpcssj1
b396f018-9081-438f-9cc0-4794770f28dd	0f630be1-6dd1-4241-9edd-ed8264326840	t2_15eqpo	Sweet, author has no experience with either war zones or jurisprudence and is just using words based on vibes. \n\n\nI will continue my decades long campaign of not giving a single fuck about anything that Rolling Stone publishes. \n\nEdit: Actually, looking into it, this author very much has experiences with war zones. They should categorically know better, and I’ll move my opinion from “base commercial interest” to “informed and at best duplicitous bullshit”. 	1	\N	2025-04-28 05:56:02.405126+00	2025-04-28 05:56:02.405126+00	2025-04-27 17:41:45+00	f	mpchcyr
2ceff5b8-e556-4d7f-a1a1-efcd86e4a527	0f630be1-6dd1-4241-9edd-ed8264326840	t2_dsbm4hzy9	Funny people refuse to confront reality. To be clear California and Seattle are laughing at us not maga. Portland is alone on a hill.	-1	\N	2025-04-28 05:56:02.410186+00	2025-04-28 05:56:02.410186+00	2025-04-27 18:46:57+00	f	mpcu7kv
57c86770-c537-4b6c-babf-fa217cb0cf75	0f630be1-6dd1-4241-9edd-ed8264326840	t2_12rrca38kt	Right wingers unintentionally helping ease the housing crisis by making conservatives and "moderates" scared of Portland lmao.	0	\N	2025-04-28 05:56:02.415368+00	2025-04-28 05:56:02.415368+00	2025-04-27 19:04:16+00	f	mpcxkhy
\.


--
-- Data for Name: pgmigrations; Type: TABLE DATA; Schema: public; Owner: reddit_scraper
--

COPY public.pgmigrations (id, name, run_on) FROM stdin;
1	20240428_rename_url_column	2025-04-28 03:51:43.424516
\.


--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: reddit_scraper
--

COPY public.posts (id, subreddit_id, author_id, title, selftext, content_url, score, num_comments, permalink, created_at, updated_at, reddit_created_at, is_archived, is_locked, post_type, daily_score, daily_rank, keywords, author_score, top_commenters, summary, sentiment) FROM stdin;
ec5af1ac-d020-4a9c-be43-3f7bd77e2ca4	0024ca45-298a-4145-820f-56e3878e14db	t2_xu6jr	New bill proposes repealing vote-by-mail in Oregon, public invited to testify		https://www.koin.com/news/politics/new-bill-proposes-repealing-vote-by-mail-in-oregon-public-invited-to-testify/	865	191	/r/Portland/comments/1jo3fbw/new_bill_proposes_repealing_votebymail_in_oregon/	2025-04-01 06:13:44.173717+00	2025-04-01 06:30:21.609886+00	2025-03-31 13:39:51+00	f	f	link	0	0	{https,00,bill,mail,testimony,just,amp,today,oregonlegislature,gov}	\N	\N	\N	\N
4b1ffde6-84ab-4e43-8ac6-5c580313446e	0024ca45-298a-4145-820f-56e3878e14db	t2_dgn9u	Get me to God’s country		https://i.redd.it/g1rt84tkj1se1.jpeg	599	40	/r/Portland/comments/1jo5fwd/get_me_to_gods_country/	2025-04-01 06:30:30.346637+00	2025-04-01 06:30:30.346637+00	2025-03-31 15:08:48+00	f	f	image	0	0	{00,bill,mail,testimony,just,https,today,oregonlegislature,gov,voices}	\N	\N	\N	\N
f9b55f6a-4989-4e0c-b1be-a8e98fbbe16b	d3bfc5e8-6902-46e1-bfc9-17fb29e0942b	t2_c53tvtf9	19, with an eviction notice. What to do?	Hello last night I just found out that me and my grandma have an eviction notice and are supposed to be out by the 23rd of next month. This is the most scared I’ve been and I genuinely have no clue what to do. Some things to note: I started a gofundme and made a few tiktoks to try and promote it but nothing more than a few hundred views. My grandma is not employed (since 2020) her mom died and is dealing with major depression and a drug addiction. I am employed but due to poor scheduling I’ve been scheduled once a week for the past month. I have 2k in savings. No drivers license. No diploma. Not many options housing wise, just my mom but I would only go to her as a last resort (untreated bipolar/schizophrenia). I don’t have much real world experience. I don’t want to leave my grandma all alone either but I feel like it might have to be the case. I have about 7 cats to also worry about if we don’t figure out a solution. The debt is almost 13k. That’s about all, sorry for such a shitty post. I’ll be willing to answer more questions if needed, I’m struggling with a lot right now, even considered ending it all last night. Words of advice, resources or any stories of your own would help. Thank you for even reading this.	https://www.reddit.com/r/askportland/comments/1jo3qrq/19_with_an_eviction_notice_what_to_do/	97	49	/r/askportland/comments/1jo3qrq/19_with_an_eviction_notice_what_to_do/	2025-04-01 06:30:43.999353+00	2025-04-01 06:30:43.999353+00	2025-03-31 13:54:35+00	f	f	text	0	0	{00,bill,mail,testimony,just,amp,https,today,oregonlegislature,gov}	\N	\N	\N	\N
57497f47-f069-4453-bfc3-a9d231102776	d3bfc5e8-6902-46e1-bfc9-17fb29e0942b	t2_cxzmwzng	MAX from PDX to convention center- luggage?	How annoying (for myself and other people) is it to bring your luggage on the MAX? My flight gets in at about 4:30p, so might be a busier time than usual. Can't wait to see the new airport!!! Thanks!! 	https://www.reddit.com/r/askportland/comments/1jo8e1j/max_from_pdx_to_convention_center_luggage/	20	32	/r/askportland/comments/1jo8e1j/max_from_pdx_to_convention_center_luggage/	2025-04-01 06:30:52.545585+00	2025-04-01 06:30:52.545585+00	2025-03-31 17:11:43+00	f	f	text	0	0	{00,bill,mail,testimony,https,amp,today,oregonlegislature,gov,voices}	\N	\N	\N	\N
2a23728f-6dd6-4c21-b2dc-c077e779ac31	d3bfc5e8-6902-46e1-bfc9-17fb29e0942b	t2_dsrl8x15s	Who Can I Hire To Help Me?	I’ve just gone through a couple of months of severe health problems. My place looks like a tornado hit it and i need someone or some company to come in and clean it. Also, my dog peed on the carpet and it needs to be taken away  and cleaned.\n\nCan anybody help me with some recommendations? Thank you, good and wise people of Portland.	https://www.reddit.com/r/askportland/comments/1k8udcu/who_can_i_hire_to_help_me/	15	2	/r/askportland/comments/1k8udcu/who_can_i_hire_to_help_me/	2025-04-28 02:42:15.977835+00	2025-04-28 05:56:02.435297+00	2025-04-27 03:12:01+00	f	f	text	19	23	{20,help,just,company,clean,hr,supplies,hire,ve,gone}	\N	\N	\N	\N
55052d72-0fa3-47dd-af1d-4a1ccbecf9e8	b79cbb17-f8ce-4612-a75d-a37338f4f99b	t2_1eur09i1gj	Anyone else looking forward to berry season?		https://www.reddit.com/gallery/1k9bwe0	504	44	/r/oregon/comments/1k9bwe0/anyone_else_looking_forward_to_berry_season/	2025-04-28 02:13:27.511218+00	2025-04-28 05:56:02.435297+00	2025-04-27 19:13:53+00	f	f	text	592	3	{berry,anyone,season,pick,back,else,looking,forward,absolutely,recommendations}	\N	\N	\N	\N
4e1252d4-ccdf-4e66-afdd-efe9a8ebd4e0	47b7edd5-0646-4bcd-a0cb-673293727756	t2_3pono	Sherpa on the Willamette Today	The younger cousin of the UniMog.  	https://v.redd.it/zj3hqc0eegxe1	317	62	/r/PortlandOR/comments/1k9gblg/sherpa_on_the_willamette_today/	2025-04-28 02:13:04.558108+00	2025-04-28 05:56:02.435297+00	2025-04-27 22:27:14+00	f	f	hosted:video	441	4	{sherpa,willamette,today,younger,cousin,unimog,rich,yuppie,life,basically}	\N	\N	\N	\N
432aca04-f976-4d15-8350-c12476bdebaf	0024ca45-298a-4145-820f-56e3878e14db	t2_a4wamqfy	Whoever put this tiny dog park/rest stop in their yard - you’re cute.		https://i.redd.it/ugd85qmxd1ue1.jpeg	1237	32	/r/Portland/comments/1jw2isz/whoever_put_this_tiny_dog_parkrest_stop_in_their/	2025-04-11 03:32:56.755147+00	2025-04-12 01:09:12.495742+00	2025-04-10 16:45:45+00	f	f	image	1301	1	{dog,yard,water,one,put,park,per,whoever,tiny,rest}	\N	\N	\N	\N
c3b07639-3763-488f-920c-3182facbf284	0024ca45-298a-4145-820f-56e3878e14db	t2_82jrdm7b	Love this time of year	My favorite week of the year for this stretch of my daily commute.	https://v.redd.it/bhsdx84pyxte1	1098	36	/r/Portland/comments/1jvq8or/love_this_time_of_year/	2025-04-11 03:33:04.86386+00	2025-04-12 01:09:12.495742+00	2025-04-10 05:14:47+00	f	f	hosted:video	1170	2	{dog,yard,water,one,put,park,per,whoever,tiny,rest}	\N	\N	\N	\N
6a4d199b-5021-44fb-b32a-3926227b5e8d	d3bfc5e8-6902-46e1-bfc9-17fb29e0942b	t2_dhjpds8q	I’m lost in Oregon after my partner died — just trying to survive with our cat. Any one out safe out there?	I don’t know how to write this without sounding dramatic, but everything’s fallen apart and I’m out of ideas.\n\nI moved to La Pine after my boyfriend Kevin died. He was the love of my life — my person — and losing him wrecked me. We had two cats together, and now it’s just me and Dax. He was Kevin’s baby. I already had to give our other cat away and I can’t do that to Dax. He’s all I have left of our little family.\n\nI ended up in Oregon because I had nowhere else to go. I’m staying with my dad and his girlfriend, and it’s been constant fighting, yelling, meth use — I don’t feel safe here, and honestly I don’t think I’m okay anymore. I’m not working. I don’t have money. I don’t have friends here. I don’t have anyone in the whole state, really. I’m queer and grieving and losing my grip on everything, including myself.\n\nI need help. I need somewhere safe to go — even short-term — where Dax and I can breathe. Somewhere queer-friendly. Somewhere I don’t have to hide my grief or who I am. I can trade work, cleaning, house-sitting, pet-sitting — anything. I’m an artist too — I paint and customize furniture, weird little pieces, memorial stuff. I’m willing to do whatever it takes.\n\nIf you know of anyone — even outside Portland — who has a room, a cabin, a guest house, a corner of a safe place… please message me. Or just say hi. I’m trying to hold on, but I can’t do this completely alone.\n\nThanks for reading.	https://www.reddit.com/r/askportland/comments/1jvxz4b/im_lost_in_oregon_after_my_partner_died_just/	301	38	/r/askportland/comments/1jvxz4b/im_lost_in_oregon_after_my_partner_died_just/	2025-04-11 03:33:18.784929+00	2025-04-12 01:09:12.495742+00	2025-04-10 13:31:23+00	f	f	text	377	3	{dog,yard,water,one,put,park,per,whoever,tiny,rest}	\N	\N	\N	\N
ca53424a-6500-4357-9bc3-cf27a44d6758	d3bfc5e8-6902-46e1-bfc9-17fb29e0942b	t2_nfcolw2b	Where to go for an American din(n)er?	Became a US citizen today (thankfully dual citizenship). Where should my husband and I go for a celebratory dinner? No chain restaurants please but looking for a typical diner experience or steak or BBQ or other ideas (bonus points for apple pie or milkshakes as dessert options). We’re in SE but can travel. 	https://www.reddit.com/r/askportland/comments/1jwaqxn/where_to_go_for_an_american_dinner/	73	55	/r/askportland/comments/1jwaqxn/where_to_go_for_an_american_dinner/	2025-04-11 03:33:27.179998+00	2025-04-12 01:09:12.495742+00	2025-04-10 22:31:40+00	f	f	text	183	4	{dog,yard,water,one,put,park,per,whoever,tiny,rest}	\N	\N	\N	\N
8e4f3362-f041-4973-b352-4d5b5e0b120c	47b7edd5-0646-4bcd-a0cb-673293727756	t2_ojggvv2u	TriMet ridership remains down by a third from 2019, and the recovery is slowing		https://www.oregonlive.com/business/2025/04/trimet-ridership-remains-down-by-a-third-from-2019-and-the-recovery-is-slowing.html	84	73	/r/PortlandOR/comments/1k99ii8/trimet_ridership_remains_down_by_a_third_from/	2025-04-28 02:13:14.700544+00	2025-04-28 05:56:02.435297+00	2025-04-27 17:32:54+00	f	f	link	230	7	{transit,trimet,2025,ridership,service,just,time,public,don,96}	\N	\N	\N	\N
a3a6e6fd-0861-40c2-b9df-d6e41d0f0f43	d3bfc5e8-6902-46e1-bfc9-17fb29e0942b	t2_139yylgyln	Help identify a restaurant I went to 10+ years ago?	I realize this place may be long gone...\n\nI've lived in OR for 10+ years (in the Gorge), but before we moved here from out of state, I came to scope out Portland on a week long vacation. This would have been around 2013, give or take half a year. On that trip, we ate at a restaurant somewhere in the NW quadrant (not a NW neighborhood, the wider NW quadrant) that I'd love to track down if it still exists.\n\nIt would have been showing up on a lot of Portland's best-of lists at the time, since everywhere we went was pretty heavily researched. Wouldn't have been an obscure spot. What I remember most about it is that it was in more of a hilly, forested natural area, not an urban neighborhood. More like the feel around the zoo, Forest Park, Pittock Mansion. It may have been a suburb, but I don't think it was a very far drive (we were staying NE). We sat on a patio with an outdoorsy view, which may or may not have been enclosed. The menu had seafood, probably not strictly seafood, more like your standard PNW fare. Not fine dining, not fancy, but nice. Very good food. The building may have been a house at one point, had a homey feel, not industrial or modern.\n\nSince we live in the Gorge, I'm still a tourist in Portland. I come into the city often on weekenders to explore, but my memory is totally failing me about where this place might have been. Anyone have guesses?\n\nUpdate - SOLVED. I'm almost positive we were in the sunroom at Seasons &amp; Regions.	https://www.reddit.com/r/askportland/comments/1k9bq62/help_identify_a_restaurant_i_went_to_10_years_ago/	18	48	/r/askportland/comments/1k9bq62/help_identify_a_restaurant_i_went_to_10_years_ago/	2025-04-28 02:12:43.869143+00	2025-04-28 05:56:02.435297+00	2025-04-27 19:06:24+00	f	f	text	114	13	{not,nw,may,portland,10,went,years,long,quadrant,neighborhood}	\N	\N	\N	\N
c5d7e872-d01b-411b-9b33-3a4ded18c008	47b7edd5-0646-4bcd-a0cb-673293727756	t2_czf1k	Visiting Portland - best local neighborhood to check out for donut &amp; coffee and a good walk around?	Hi all,\n\nI’ll be visiting Portland later this week but will only have a day. Coming from Chicago. I know most of the stuff to see is outside downtown but otherwise it looks like there are so many awesome neighborhoods — artsy, music scene, residential, etc. \n\nCan anyone recommend a neighborhood or two to check out if I’m looking to walk around and check out some local stores, maybe grab a pastry or a donut or coffee or a sandwich?\n\nSeems the Pearl district is close to downtown but I’m willing to go anywhere as I’ll have a car. Appreciate any help!	https://www.reddit.com/r/PortlandOR/comments/1k993nr/visiting_portland_best_local_neighborhood_to/	16	97	/r/PortlandOR/comments/1k993nr/visiting_portland_best_local_neighborhood_to/	2025-04-28 02:42:47.664406+00	2025-04-28 05:56:02.435297+00	2025-04-27 17:15:47+00	f	f	text	210	8	{walk,downtown,go,portland,shops,local,check,great,re,people}	\N	\N	\N	\N
da6bd0ea-b7aa-40a1-90c4-c0395c01ad3e	0024ca45-298a-4145-820f-56e3878e14db	t2_3pono	Sherpa on the Willamette Today	The younger cousin of the UniMog.  	https://v.redd.it/qjwd86faegxe1	623	131	/r/Portland/comments/1k9gb78/sherpa_on_the_willamette_today/	2025-04-28 02:12:29.0733+00	2025-04-28 05:56:02.435297+00	2025-04-27 22:26:42+00	f	f	hosted:video	885	2	{white,sherpa,willamette,today,younger,cousin,unimog,lake,oswego,man}	\N	\N	\N	\N
c8025fda-8490-43bc-93ac-cda53581687d	0024ca45-298a-4145-820f-56e3878e14db	t2_8x9p5kwj	Lost Siamese N Portland Eliot neighborhood	My older disabled Siamese cat escaped sometime Friday night and I am desperate to find him. He is incredibly friendly and trusting, his name is Simon but he will respond to any attention. He has a shortened tail and is missing an eye. Hes approximately 10lbs and is wearing a flea collar. He needs special food for his kidneys and is not very able to defend himself against predators. Last seen on Thompson near Williams ave. Please keep a lookout !!!! 	https://www.reddit.com/gallery/1k8vvfr	284	14	/r/Portland/comments/1k8vvfr/lost_siamese_n_portland_eliot_neighborhood/	2025-04-28 00:16:50.576437+00	2025-04-28 05:56:02.435297+00	2025-04-27 04:41:37+00	f	f	text	312	6	{cat,find,siamese,will,not,smell,back,hope,lost,name}	\N	\N	\N	\N
cd0595f5-e0a5-4878-a35c-ecb77c52392f	0024ca45-298a-4145-820f-56e3878e14db	t2_5rkmg4jl9	thoughts on portland from a midwestern visitor	as someone who grew up hearing horrible things about portland from conservative family members - my “expectations” have been completely demolished since coming here. you all have a beautiful city, and i hope you’re so proud of it.\n\nthat is all &lt;3	https://www.reddit.com/r/Portland/comments/1k9fvo5/thoughts_on_portland_from_a_midwestern_visitor/	751	164	/r/Portland/comments/1k9fvo5/thoughts_on_portland_from_a_midwestern_visitor/	2025-04-28 00:16:42.398498+00	2025-04-28 05:56:02.435297+00	2025-04-27 22:06:33+00	f	f	text	1079	1	{portland,love,city,horrible,bad,know,pretty,lot,people,thoughts}	\N	\N	\N	\N
f249ff7a-a6dc-4b42-9669-017a88eace81	3c4f8228-bfd7-4863-83f6-8f4ebdaf1780	t2_cxjl2	Reminds me of the seagull standing on the "no seagulls" sign		https://i.redd.it/tjsw7vanpfxe1.jpeg	119	38	/r/Portland/comments/1k9d6al/reminds_me_of_the_seagull_standing_on_the_no/	2025-04-28 05:55:03.052866+00	2025-04-28 05:56:02.435297+00	2025-04-27 20:08:28+00	f	f	image	195	9	{seagull,sign,yeah,re,respect,14,reminds,standing,no,seagulls}	\N	\N	\N	\N
5d3fe894-4aba-458d-9dbd-9dfbc388d8ea	3c4f8228-bfd7-4863-83f6-8f4ebdaf1780	t2_29tgtdna	Lost (Kenton) green cheek conure	Lost in Kenton. If found please call 971-506-9840. They usually fly back but been gone for hours. Heartbreaking and we just want them back. 	https://www.reddit.com/gallery/1k9iy61	121	14	/r/Portland/comments/1k9iy61/lost_kenton_green_cheek_conure/	2025-04-28 05:55:11.407553+00	2025-04-28 05:56:02.435297+00	2025-04-28 00:37:40+00	f	f	text	149	11	{lost,back,hope,kenton,found,find,506,911,971,9840}	\N	\N	\N	\N
f075f22a-1478-4a8c-a1ad-28ee1915b33b	3c4f8228-bfd7-4863-83f6-8f4ebdaf1780	t2_t3ir6uukh	Wolf and Bears Falafel Recipe	I see Wolf and Bears mentioned here quite a bit. Today I found and made their falafel recipe from the Food Network website. I used to work there and the smell alone took me back. Made me want to smoke a cigarette and laugh about how customers pronounce tapenade.\n\nFor anyone else who misses Wolf and Bear’s food, here’s the link if you want to try it:\n https://www.foodnetwork.com/recipes/wolf-and-bears-falafel-2137259.amp	https://www.reddit.com/r/Portland/comments/1k9jdr8/wolf_and_bears_falafel_recipe/	39	9	/r/Portland/comments/1k9jdr8/wolf_and_bears_falafel_recipe/	2025-04-28 05:55:19.737978+00	2025-04-28 05:56:02.435297+00	2025-04-28 01:00:35+00	f	f	text	57	15	{wolf,falafel,recipe,bears,thanks,made,food,want,pronounce,miss}	\N	\N	\N	\N
2b1e4f07-5018-44f1-b30f-ba4d53b7957b	3c4f8228-bfd7-4863-83f6-8f4ebdaf1780	t2_w25aa	Is there a concert/club maximum decibel ordinance here or something?	I am a little newer to Portland, moved here in 2022. I'm curious if there is a law in place limiting maximum concert volume. I first got curious after my first few shows here because they just seemed overall quieter than I was expecting.\n\nAt one point, at Crystal Ballroom (pretty sure it was there, an Oh Sees show, I think?) I noticed a decibel meter display near the soundboard, which hovered very closely to 100 the entire time. I've since noticed that meter display at other venues and haven't seen anything above 100, really.\n\nThe clincher for me to even post this was Mogwai last night- it got to about 106 dB max, and only when I was in line with a speaker array. I have seen them elsewhere many times before and those shows blew my socks off. Not saying it was a bad show (Roseland Theater being awful aside), they are always good, just was hoping for just a bit more. I use the NIOSH sound level meter app and while that may not be terribly accurate (?), it has closely tracked with the meters I see in use at places.\n\nI love a very loud show from time to time, not ear-piercing but that stomach-rumbling presence that venue PAs can produce. I have been craving that and haven't yet been satisfied. I looked at the [city code for noise](https://www.portland.gov/code/18/all), but that seems to be about general neighborhood noise, etc, not anything specific to nightclubs/venues. \n\nWhat's going on here? Is someone out there looking out for me and my ears who I'll thank in 20 years? Is it some occupational rule for a safe workplace for the venue staff? (I'd support that, even if I wish my experience was different). Or a state or county regulation going on?\n\nI know in the past 10-15 years venues in many cities have gotten more serious about volume. I also record music and protecting my ears is important to me, but the sensory experience of feeling frozen in time from sheer volume is also quite special too (it doesn't need to be dangerous, decent earplugs can preserve the sound while keeping your ears safe). OR maybe I have gotten old and my ears and body aren't what they used to be. OR something. I dunno.\n\nCurious if there are any sound/venue staff or musicians here who can tell me if I'm onto something or if I'm making it all up. Just don't tell me that the Sunn O))) show here I missed had that brown note or whatever it is i'm looking for going on...	https://www.reddit.com/r/Portland/comments/1k9d555/is_there_a_concertclub_maximum_decibel_ordinance/	2	21	/r/Portland/comments/1k9d555/is_there_a_concertclub_maximum_decibel_ordinance/	2025-04-28 05:55:44.75469+00	2025-04-28 05:56:02.435297+00	2025-04-27 20:07:04+00	f	f	text	44	17	{noise,show,time,not,portland,just,sound,going,ears,experience}	\N	\N	\N	\N
82ca34f8-93f4-4ff4-a301-9ff00525a369	3c4f8228-bfd7-4863-83f6-8f4ebdaf1780	t2_anecn	Group Therapy - Finding friends (and fun!) in Portland with group activities | Portland Mercury		https://www.portlandmercury.com/city-guide-2025/2025/04/24/47751220/group-therapy	12	7	/r/Portland/comments/1k94qig/group_therapy_finding_friends_and_fun_in_portland/	2025-04-28 05:55:28.031132+00	2025-04-28 05:56:02.435297+00	2025-04-27 14:05:43+00	f	f	link	26	21	{group,portland,therapy,finding,friends,fun,activities,mercury,misread,theory}	\N	\N	\N	\N
8be3d57b-3bbe-4098-8f86-c4ed54959298	3c4f8228-bfd7-4863-83f6-8f4ebdaf1780	t2_vfz62twd	Missed Connection - Clackamas Costco	You:  \nI think your name tag read, "Celinda"  \n5'5"ish  \nDirty blonde hair  \nCostco red long sleeve shirt tucked in to your high waist blue jeans.  \n  \nMe:  \n5'5''  \nCurly dark hair.  \nTshirt of a cat riding a raptor (The Oatmeal) with a black REI fleece vest with blue jeans.  \n  \nI was pushing my cart through the Sunday throng of people getting my dog her food and some treats. We briefly made eye contact as you were pulling a giant pile of boxes through the isles. You locked eye contact with me and gave a smile with the energy of someone with confidence. I surprised myself by getting unusually shy and breaking eye contact. I instantly regretted not locking into your eyes but something about you caught me off guard. I saw you later up front near checkout and wanted to make eye contact again but you were busy in what looked like a team huddle with a Lead. Would love to look into your eyes again as you throw me off with a smirk.	https://www.reddit.com/r/Portland/comments/1k9f5dp/missed_connection_clackamas_costco/	0	11	/r/Portland/comments/1k9f5dp/missed_connection_clackamas_costco/	2025-04-28 05:55:53.28696+00	2025-04-28 05:56:02.435297+00	2025-04-27 21:34:12+00	f	f	text	22	22	{costco,eye,contact,hair,blue,jeans,getting,isles,eyes,off}	\N	\N	\N	\N
7a4cd048-f2c4-4117-a01f-6f2cda1b95f0	3c4f8228-bfd7-4863-83f6-8f4ebdaf1780	t2_166lrpkyei	Urgent Need for Dental Hygiene Patients – Free Cleaning at Concorde Portland!	Hi everyone!\n\nI’m a senior dental hygiene student at Concorde Career College in Portland, and I’m looking for patients for my clinic sessions. I have an **ASAP opening tomorrow (Monday, 4/28) from 7:30–10:45 AM**, as well as **openings this Wednesday (4/30) and Friday (5/1)** from **7:30–11:00 AM**.\n\n**Details:**\n\n* **Cost:** Completely **FREE** – no charge for any services!\n* **Location:** 1425 NE Irving St, Portland, OR\n* **Time Commitment:** Each appointment lasts about **3 hours**. Depending on your oral health needs, multiple visits may be needed.\n* **Why volunteer?** You'll receive one of the **most thorough dental cleanings** possible, all under the supervision of licensed instructors.\n\n**All ages and situations are encouraged to sign up!**  \nEspecially if it’s been a *long time* since your last cleaning — no judgment, we’re here to help.\n\n🚨 **Please note:**  \nI am posting this across multiple sites, so the **first person to respond** will get the immediate opening.  \nIf you're still interested, **please fill out this quick form** so I can get you scheduled for another date:  \n👉 [https://forms.gle/GM5bGA1mGYN2YWcB6](https://forms.gle/GM5bGA1mGYN2YWcB6)  \nI’ll be reaching out personally once I receive your form!\n\nYou can also **text me directly at (971) 236-1798** if you have any questions!\n\n**Important:**  \nIf a morning appointment doesn’t work for you, **we also have afternoon clinic sessions**, and I’m happy to pass your information along to my classmates.  \nI’m actively looking for patients for **all four days I’m in clinic each week**, so even if these dates don't work, there are plenty of opportunities!\n\nThank you so much for considering — your support truly helps us future dental hygienists grow! 🦷✨	https://www.reddit.com/r/Portland/comments/1k9lqq9/urgent_need_for_dental_hygiene_patients_free/	17	1	/r/Portland/comments/1k9lqq9/urgent_need_for_dental_hygiene_patients_free/	2025-04-28 05:55:36.329346+00	2025-04-28 05:56:02.435297+00	2025-04-28 03:08:08+00	f	f	self	19	24	{dental,30,patients,portland,clinic,form,hygiene,free,cleaning,concorde}	\N	\N	\N	\N
761f31df-7507-4b1c-985c-9ab9518a6835	bc6962f8-e4d9-4461-a8b9-101062fdb88f	t2_1cxhl4zg91	Follow up message from the 2nd moderator of 50501	\nDear 50501 community of Reddit this is a follow-up post in response to the post from my account titled EMERGENCY as well as a post I had written titled “A message from the 2nd moderator of r/50501” for context see my post history. \n\nI apologize for again using my position for exposure but I believe it is necessary to share my observations given the position I have found myself in. \n\nI am aware there has been some confusion on the leadership and direction of 50501. I am not asking you to trust me as an authority of 50501. In fact I am asking for you to turn your trust back towards your local organizations. 50501 in its original form was meant to be a call to action to the people by the people to support our constitutional governance. In the process of coordinating these protests, local communities within the states have formed strong relations that I have the utmost faith can coordinate the peoples future self advocacy. \n\nThe following are my suggestions to the community moving forward. \n\nAs a concept 50501 is not subject to ownership. The concept is that we all show up, at all 50 states, at each of the 50 state capitols in the solidarity of our support of our most basic human rights. \n\nNo one in this community has the authority to tell you what days you can or cannot protest as long as it is organized through the proper legal channels. \n\nNo one in this community has the right to tell you you don't have the authority to organize a protest as directed by the first amendment in the spirit of 50501. If you would like to form a community then do so. \n\nWe must participate in the democracy we wish to live in. This means our continued participation in elections, this means running for office on any level, this means civil discourse and exercising our first amendment rights. \n\n50501 does not win by outcompeting supportive movements. There are so many great communities already in place to find your voice and they need our support. \n\nWe must expect ourselves and our leaders to embody the ideals we wish for our society. This means remaining civil when we use our voice in our public spaces and when organizing we do so in a conscious and informed manner. If a leader does not act in accord with the core ideals of a society they are not representative of the will of the people and should not be followed. \n\n\nI believe that this is the best path forward if you agree, please share this message. \n\n\n\n\n	https://www.reddit.com/r/50501PDX/comments/1k9efyb/follow_up_message_from_the_2nd_moderator_of_50501/	18	0	/r/50501PDX/comments/1k9efyb/follow_up_message_from_the_2nd_moderator_of_50501/	2025-04-28 02:43:53.19896+00	2025-04-28 05:56:02.435297+00	2025-04-27 21:03:29+00	f	f	text	18	25	{50501,not,community,post,means,message,authority,people,support,50}	\N	\N	\N	\N
897058e3-6721-46d2-bf94-276843bc87c3	b79cbb17-f8ce-4612-a75d-a37338f4f99b	t2_s60b6u0	Thank you, Oregon	I wanted to thank the beautiful state of Oregon. I just spent the past 10 days there (first time visitor) with my family. I fell in love. \n\nWe stayed in suburban Portland, but visited Tillamook, Garibaldi, Seaside, Astoria, Keizer, and spent two nights in Rockaway Beach. \nWe were all amazed by the scenery, the people, the food…even the weather cooperated. \n\nI’m seriously thinking about relocating there with my family. 	https://www.reddit.com/r/oregon/comments/1k9iffu/thank_you_oregon/	224	56	/r/oregon/comments/1k9iffu/thank_you_oregon/	2025-04-28 02:13:35.500944+00	2025-04-28 05:56:02.435297+00	2025-04-28 00:10:45+00	f	f	text	336	5	{oregon,state,love,amp,thank,spent,time,family,rockaway,beach}	\N	\N	\N	\N
e08aa3dc-13c6-49f2-9e86-5539c13308dc	b79cbb17-f8ce-4612-a75d-a37338f4f99b	t2_98z4tdz2	Eagle GLENEDEN BEACH		https://i.redd.it/ltpv0rueraxe1.jpeg	163	5	/r/oregon/comments/1k8uo1b/eagle_gleneden_beach/	2025-04-28 02:43:18.508717+00	2025-04-28 05:56:02.435297+00	2025-04-27 03:29:24+00	f	f	image	173	10	{eagle,beach,shot,around,gleneden,great,nest,wow,impressive,good}	\N	\N	\N	\N
0f630be1-6dd1-4241-9edd-ed8264326840	3c4f8228-bfd7-4863-83f6-8f4ebdaf1780	t2_107l4h	‘IT’S LIKE A WAR ZONE’: WHAT HAPPENED WHEN PORTLAND LEGALIZED FENTANYL	\n	https://www.rollingstone.com/culture/culture-features/portland-fentanyl-legalized-overdose-crisis-1235323248/	0	71	/r/Portland/comments/1k99ejj/its_like_a_war_zone_what_happened_when_portland/	2025-04-28 05:56:02.331059+00	2025-04-28 05:56:02.435297+00	2025-04-27 17:28:23+00	f	f	link	142	12	{war,zone,fentanyl,stop,around,happened,portland,legalized,throwing,term}	\N	\N	\N	\N
04c7771e-89d5-4d14-b40f-e63611d9a23c	3f497645-595c-4039-a7d6-7533fc5514b5	t2_hj51s	NY plate that just cut me off twice on High St	Go back to fucking Manhattan if you’re gonna drive like you’re still there, dickfuck. That’s all.	https://www.reddit.com/r/portlandcomplaining/comments/1k8jneu/ny_plate_that_just_cut_me_off_twice_on_high_st/	39	1	/r/portlandcomplaining/comments/1k8jneu/ny_plate_that_just_cut_me_off_twice_on_high_st/	2025-04-28 02:43:30.91113+00	2025-04-28 05:56:02.435297+00	2025-04-26 18:25:57+00	f	f	text	41	18	{re,ny,plate,just,cut,off,twice,high,st,go}	\N	\N	\N	\N
d4d41462-a7ff-49f8-b9e0-2522c8561b4b	d3bfc5e8-6902-46e1-bfc9-17fb29e0942b	t2_hoevugmjw	Why does the front seat of the Max have a little window full of sand?	I took a pic but cant attach it. For those of you who sit in the front of the max, on one of the models the very front seat has a window built in and it looks like its full of sand? The driver had no clue	https://www.reddit.com/r/askportland/comments/1k8vq6c/why_does_the_front_seat_of_the_max_have_a_little/	17	6	/r/askportland/comments/1k8vq6c/why_does_the_front_seat_of_the_max_have_a_little/	2025-04-28 00:17:12.007315+00	2025-04-28 05:56:02.435297+00	2025-04-27 04:32:25+00	f	f	text	29	20	{sand,front,max,traction,onto,train,seat,little,window,full}	\N	\N	\N	\N
18932a85-f8bb-4446-b32a-47b146e1e8d2	d3bfc5e8-6902-46e1-bfc9-17fb29e0942b	t2_vmzkuj0ox	Living in Portland working in Salem?	Hey all,\n\nI was born and raised in Salem. I’m 30 years old now and I’ve had about enough of it. Nothing to do unless you want to go to work and workout. Not to mention dating here is a challenge. I’m typically in Portland every weekend to visit friends or go to events.\n\nI work for the state with a pretty good gig. I’ve been there about 7 years now and there’s no way I can work remote. I do own a home in Salem but I’m in the process of renting it out. I’ve come to a point where I want to move to Portland but I will have to deal with that commute 4 days a week.\n\nHave any of y’all done this and how was it for you? I know I would be happier living in Portland but is it worth dealing with the commute?	https://www.reddit.com/r/askportland/comments/1k8qxrz/living_in_portland_working_in_salem/	23	34	/r/askportland/comments/1k8qxrz/living_in_portland_working_in_salem/	2025-04-28 00:17:04.152874+00	2025-04-28 05:56:02.435297+00	2025-04-27 00:06:14+00	f	f	text	91	14	{city,lot,portland,horrible,news,know,bad,pretty,thoughts,midwestern}	\N	\N	\N	\N
6f34a1e7-0f99-4311-a0f7-798218f4001c	9670d48c-95be-4466-8a7f-c1606e44db72	t2_mdbsacda9	Results from Pick Up The Burn 2025	We has about 12 people join our Trash No Land group.  The other 48 people dispersed to other areas (and many of them cleaned mostly target shooting sites.  Our group got 2 areas, plus a disgusting old freezer full of rotten meat. YUK!  Our first spot was a huge mess that included household refuse dumped, tires and lots of shooting debris.  But now it's in great shape once again.  \n  \nElsewhere, a shot up abandoned pickup truck was dragged out to the roadway where DNR can get it hauled off (video in the comments on TNL's Facebook page).  Lots of stuff happened all over the forest yesterday and it was all good.  Still hearing about other's adventures.\n\nNext up is North Fork Wolf Creek shooting lanes, May 17th.  I'll be posting details soon.  It'll be a great time!\n\nBill\n\nLink to Results: Pick Up The Burn 2025  \n[https://www.trashnoland.org/results-pick-up-the-burn-25/](https://www.trashnoland.org/results-pick-up-the-burn-25/)	https://www.reddit.com/r/pdxgunnuts/comments/1k9c4tz/results_from_pick_up_the_burn_2025/	45	4	/r/pdxgunnuts/comments/1k9c4tz/results_from_pick_up_the_burn_2025/	2025-04-28 02:44:15.463167+00	2025-04-28 05:56:02.435297+00	2025-04-27 19:23:52+00	f	f	self	53	16	{results,pick,burn,shooting,freezer,great,25,2025,people,group}	\N	\N	\N	\N
ead4eb41-8dd3-4145-bcb0-b58fd77c545d	bc6962f8-e4d9-4461-a8b9-101062fdb88f	t2_xvn13ics1	I can’t wait to come together in solidarity with workers, immigrants, students to push back against the greedy billionaires, demand equity, and stand up for justice.		https://i.redd.it/50hhngie7fxe1.jpeg	29	2	/r/50501PDX/comments/1k9as9q/i_cant_wait_to_come_together_in_solidarity_with/	2025-04-28 02:43:45.433618+00	2025-04-28 05:56:02.435297+00	2025-04-27 18:26:10+00	f	f	image	33	19	{50501,least,planning,events,day,wait,together,solidarity,workers,immigrants}	\N	\N	\N	\N
9b1c32f0-fa3a-48b5-bf2a-0e782497ba40	bc6962f8-e4d9-4461-a8b9-101062fdb88f	t2_5o3jcmtx	CALL TO BOYCOTT: Trader Joe's wants to end the NLRB which ends the NLRA, which effectively ends worker rights. DON'T LET THEM		https://i.redd.it/xqysjnvw20xe1.png	13	0	/r/50501PDX/comments/1k9gomy/call_to_boycott_trader_joes_wants_to_end_the_nlrb/	2025-04-28 02:44:01.071024+00	2025-04-28 05:56:02.435297+00	2025-04-27 22:44:34+00	f	f	image	13	26	{ends,call,boycott,trader,joe,wants,end,nlrb,nlra,effectively}	\N	\N	\N	\N
\.


--
-- Data for Name: subreddits; Type: TABLE DATA; Schema: public; Owner: reddit_scraper
--

COPY public.subreddits (id, name, description, created_at, updated_at) FROM stdin;
0024ca45-298a-4145-820f-56e3878e14db	portland	\N	2025-04-01 06:13:34.977267+00	2025-04-28 02:41:19.130341+00
9670d48c-95be-4466-8a7f-c1606e44db72	pdxgunnuts	\N	2025-04-28 02:44:07.857964+00	2025-04-28 05:16:40.608543+00
bc6962f8-e4d9-4461-a8b9-101062fdb88f	50501PDX	\N	2025-04-28 02:43:37.910121+00	2025-04-28 05:16:50.557815+00
b28bd702-31d6-45fb-a870-02e22808a312	PDXTech	\N	2025-04-28 05:16:58.284443+00	2025-04-28 05:16:58.284443+00
9e8f6501-5c73-4e52-a7ea-5a1af48e5c07	PDXEmployment	\N	2025-04-28 05:17:05.997692+00	2025-04-28 05:17:05.997692+00
68335422-e548-4c66-a737-0100cab0a415	PDXLostAndFound	\N	2025-04-28 05:17:13.793041+00	2025-04-28 05:17:13.793041+00
9bd1ca20-dffc-438d-9f9d-317fa23c153f	pdxcouncilagenda	\N	2025-04-28 05:17:23.564792+00	2025-04-28 05:17:23.564792+00
b3a3ab3e-4f52-4dfb-8d15-dab262f6337b	PNW	\N	2025-04-28 05:17:31.294071+00	2025-04-28 05:17:31.294071+00
ba653ad9-28fc-4ea6-967a-a6afb093c334	CyclePDX	\N	2025-04-28 05:17:38.995593+00	2025-04-28 05:17:38.995593+00
48cf1453-5836-4bdd-ba33-005af6f493e0	Portlandia	\N	2025-04-28 05:17:46.821067+00	2025-04-28 05:17:46.821067+00
6380986b-f6fc-42d5-b8f7-477b0c80b868	OregonCoast	\N	2025-04-28 05:17:57.141354+00	2025-04-28 05:17:57.141354+00
3f497645-595c-4039-a7d6-7533fc5514b5	portlandcomplaining	\N	2025-04-28 02:43:23.4117+00	2025-04-28 05:18:05.236916+00
43a20842-a166-4147-b0e2-c51505fe4dc4	PortlandPsychSociety	\N	2025-04-28 05:18:13.041912+00	2025-04-28 05:18:13.041912+00
3c0a260b-3257-4a04-ab23-951bbc06f38d	pdxwhisky	\N	2025-04-28 05:18:25.970638+00	2025-04-28 05:18:25.970638+00
3eb7f8f5-7eac-403d-9d5b-74545f5e98a9	PDXjobs	\N	2025-04-28 05:18:33.702391+00	2025-04-28 05:18:33.702391+00
a46a00a3-11ec-4b57-bae9-3c760d1e4441	PDXPlantSwap	\N	2025-04-28 05:18:41.437706+00	2025-04-28 05:18:41.437706+00
5e2b044a-2c61-45b9-86ba-b70feecb915b	RunPDX	\N	2025-04-28 05:18:56.141411+00	2025-04-28 05:18:56.141411+00
b3082433-6571-413d-844f-33bc584cb7ef	JobsInPortland	\N	2025-04-28 05:19:03.803415+00	2025-04-28 05:19:03.803415+00
2d685196-3904-4f16-bedd-8ad83df2f4ec	HistoryOfPortland	\N	2025-04-28 05:19:11.570018+00	2025-04-28 05:19:11.570018+00
c5abcee2-db5c-4cf6-bb7f-7bb5c73376db	FindPortlandRoommate	\N	2025-04-28 05:19:19.355338+00	2025-04-28 05:19:19.355338+00
7dc0770d-b6ec-4b51-baa1-01e65db3766b	instacartPortland	\N	2025-04-28 05:19:29.209555+00	2025-04-28 05:19:29.209555+00
0b3a4948-63b8-4b7c-aed9-ee5efae58842	PortlandSandbox	\N	2025-04-28 05:19:37.00276+00	2025-04-28 05:19:37.00276+00
a33318d6-75a1-4ffa-a5e3-331f3630617b	PortlandForward	\N	2025-04-28 05:19:44.902832+00	2025-04-28 05:19:44.902832+00
8fc1325d-a533-4df7-a26c-483d19a8261e	PortlandPickles	\N	2025-04-28 05:19:52.641695+00	2025-04-28 05:19:52.641695+00
da158745-74ea-488b-847a-ccd649790c61	PortlandLeather	\N	2025-04-28 05:20:02.581673+00	2025-04-28 05:20:02.581673+00
4d920e94-9ace-42ce-95ad-45934bc2ae8b	PortlandBooks	\N	2025-04-28 05:20:15.114386+00	2025-04-28 05:20:15.114386+00
04aecde7-9aed-461d-a00d-fbea872429a3	PortlandVegans	\N	2025-04-28 05:20:22.840018+00	2025-04-28 05:20:22.840018+00
b602fd3f-e77e-462c-8945-f1f779de94c6	50501Portland	\N	2025-04-28 05:20:32.817245+00	2025-04-28 05:20:32.817245+00
ac2c0e7a-a2eb-4070-bda8-97559b1afa4e	PortlandPNW	\N	2025-04-28 05:20:40.570794+00	2025-04-28 05:20:40.570794+00
1ae86c14-8019-44b5-8128-4946b2cba91d	Cascadia	\N	2025-04-28 05:20:48.152877+00	2025-04-28 05:20:48.152877+00
dd5fcc7a-0498-4764-b965-0305b85bd448	PortlandRemote	\N	2025-04-28 05:20:55.943738+00	2025-04-28 05:20:55.943738+00
52c77c3e-600b-499f-b9c7-abf024395f28	portlandmusic	\N	2025-04-28 05:21:05.889336+00	2025-04-28 05:21:05.889336+00
28414987-1e09-4ba8-8d30-7d07c1e5a625	PortlandOre	\N	2025-04-28 05:21:18.582166+00	2025-04-28 05:21:18.582166+00
c39a1529-1e09-4f2d-865a-72d0268eb5a6	PortlandGaming	\N	2025-04-28 05:21:26.956681+00	2025-04-28 05:21:26.956681+00
b79cbb17-f8ce-4612-a75d-a37338f4f99b	oregon	\N	2025-04-28 02:13:19.692731+00	2025-04-28 05:21:36.199493+00
47b7edd5-0646-4bcd-a0cb-673293727756	portlandOR	\N	2025-04-28 02:12:56.743929+00	2025-04-28 05:21:44.314654+00
d3bfc5e8-6902-46e1-bfc9-17fb29e0942b	askportland	\N	2025-04-01 06:30:35.60505+00	2025-04-28 05:21:52.421252+00
3c4f8228-bfd7-4863-83f6-8f4ebdaf1780	Portland	\N	2025-04-28 05:54:36.557507+00	2025-04-28 05:54:36.557507+00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: reddit_scraper
--

COPY public.users (id, username, total_posts, total_comments, total_posts_score, total_comments_score, contributor_score, first_seen, last_seen, created_at, updated_at) FROM stdin;
t2_136s1d	rebeccanotbecca	0	0	0	0	0	2025-04-01 06:13:44.122705+00	2025-04-01 06:30:21.563168+00	2025-04-01 06:13:44.122705+00	2025-04-01 06:30:21.563168+00
t2_13242	retsotrembla	0	0	0	0	0	2025-04-01 06:13:44.124977+00	2025-04-01 06:30:21.565711+00	2025-04-01 06:13:44.124977+00	2025-04-01 06:30:21.565711+00
t2_3kh6gj25	flabbergastednerfcat	0	0	0	0	0	2025-04-01 06:13:44.064858+00	2025-04-01 06:30:21.499408+00	2025-04-01 06:13:44.064858+00	2025-04-01 06:30:21.499408+00
t2_r6yba	JJinPDX	0	0	0	0	0	2025-04-01 06:13:44.06804+00	2025-04-01 06:30:21.501955+00	2025-04-01 06:13:44.06804+00	2025-04-01 06:30:21.501955+00
t2_xu6jr	picturesofbowls	0	0	0	0	0	2025-04-01 06:13:44.053718+00	2025-04-01 06:30:21.504715+00	2025-04-01 06:13:44.053718+00	2025-04-01 06:30:21.504715+00
t2_11loiiwhu3	SlopDrudge69	0	0	0	0	0	2025-04-01 06:13:44.073947+00	2025-04-01 06:30:21.507398+00	2025-04-01 06:13:44.073947+00	2025-04-01 06:30:21.507398+00
t2_a7u1t	fuckofakaboom	0	0	0	0	0	2025-04-01 06:13:44.083291+00	2025-04-01 06:30:21.510055+00	2025-04-01 06:13:44.083291+00	2025-04-01 06:30:21.510055+00
t2_6pnnamf6	19peacelily85	0	0	0	0	0	2025-04-01 06:13:44.085862+00	2025-04-01 06:30:21.512569+00	2025-04-01 06:13:44.085862+00	2025-04-01 06:30:21.512569+00
t2_m37k8q45	ScoobNShiz	0	0	0	0	0	2025-04-01 06:13:44.088375+00	2025-04-01 06:30:21.515387+00	2025-04-01 06:13:44.088375+00	2025-04-01 06:30:21.515387+00
t2_9jbs9	djasonpenney	0	0	0	0	0	2025-04-01 06:13:44.091377+00	2025-04-01 06:30:21.518256+00	2025-04-01 06:13:44.091377+00	2025-04-01 06:30:21.518256+00
t2_10o6uc	DarXIV	0	0	0	0	0	2025-04-01 06:13:44.093946+00	2025-04-01 06:30:21.521817+00	2025-04-01 06:13:44.093946+00	2025-04-01 06:30:21.521817+00
t2_lx47kp68	AndyTakeaLittleSnoo	0	0	0	0	0	2025-04-01 06:13:44.09639+00	2025-04-01 06:30:21.524465+00	2025-04-01 06:13:44.09639+00	2025-04-01 06:30:21.524465+00
t2_ex3lj	codepossum	0	0	0	0	0	2025-04-01 06:13:44.098802+00	2025-04-01 06:30:21.527243+00	2025-04-01 06:13:44.098802+00	2025-04-01 06:30:21.527243+00
t2_131oot	frez1001	0	0	0	0	0	2025-04-01 06:13:44.101112+00	2025-04-01 06:30:21.530147+00	2025-04-01 06:13:44.101112+00	2025-04-01 06:30:21.530147+00
t2_a9u4krk	Itinerant0987	0	0	0	0	0	2025-04-01 06:13:44.103008+00	2025-04-01 06:30:21.53342+00	2025-04-01 06:13:44.103008+00	2025-04-01 06:30:21.53342+00
t2_at9omuhxn	Successful_Data3680	0	0	0	0	0	2025-04-01 06:13:44.105274+00	2025-04-01 06:30:21.536182+00	2025-04-01 06:13:44.105274+00	2025-04-01 06:30:21.536182+00
t2_43iz3fdn	CHiZZoPs1	0	0	0	0	0	2025-04-01 06:13:44.107647+00	2025-04-01 06:30:21.538957+00	2025-04-01 06:13:44.107647+00	2025-04-01 06:30:21.538957+00
t2_hvgz0	Syorkw	0	0	0	0	0	2025-04-01 06:13:44.110022+00	2025-04-01 06:30:21.54169+00	2025-04-01 06:13:44.110022+00	2025-04-01 06:30:21.54169+00
t2_xoxpvm	broganb16	0	0	0	0	0	2025-04-01 06:13:44.111844+00	2025-04-01 06:30:21.55092+00	2025-04-01 06:13:44.111844+00	2025-04-01 06:30:21.55092+00
t2_3z0lk9yw	itsScarlettyall	0	0	0	0	0	2025-04-01 06:13:44.11385+00	2025-04-01 06:30:21.553617+00	2025-04-01 06:13:44.11385+00	2025-04-01 06:30:21.553617+00
t2_mhb2m2z3h	Silly-Scene6524	0	0	0	0	0	2025-04-01 06:13:44.116054+00	2025-04-01 06:30:21.556088+00	2025-04-01 06:13:44.116054+00	2025-04-01 06:30:21.556088+00
t2_4pl1ubhw	notalurkjerk	0	0	0	0	0	2025-04-01 06:13:44.118344+00	2025-04-01 06:30:21.558432+00	2025-04-01 06:13:44.118344+00	2025-04-01 06:30:21.558432+00
t2_cazkt	AlphaPotato	0	0	0	0	0	2025-04-01 06:13:44.120439+00	2025-04-01 06:30:21.560493+00	2025-04-01 06:13:44.120439+00	2025-04-01 06:30:21.560493+00
t2_9rlpscet	TurbulentNobody9411	0	0	0	0	0	2025-04-01 06:13:44.127271+00	2025-04-01 06:30:21.567902+00	2025-04-01 06:13:44.127271+00	2025-04-01 06:30:21.567902+00
t2_yoxh0od	Allthedramastics	0	0	0	0	0	2025-04-01 06:13:44.129503+00	2025-04-01 06:30:21.569915+00	2025-04-01 06:13:44.129503+00	2025-04-01 06:30:21.569915+00
t2_hmowc	GaiusMarcus	0	0	0	0	0	2025-04-01 06:13:44.131721+00	2025-04-01 06:30:21.572041+00	2025-04-01 06:13:44.131721+00	2025-04-01 06:30:21.572041+00
t2_5uke6htd	bidhopper	0	0	0	0	0	2025-04-01 06:13:44.13393+00	2025-04-01 06:30:21.574149+00	2025-04-01 06:13:44.13393+00	2025-04-01 06:30:21.574149+00
t2_e5tlwqhl	ConversationNo5440	0	0	0	0	0	2025-04-01 06:13:44.136153+00	2025-04-01 06:30:21.576326+00	2025-04-01 06:13:44.136153+00	2025-04-01 06:30:21.576326+00
t2_4cjkd	Comms	0	0	0	0	0	2025-04-01 06:13:44.138296+00	2025-04-01 06:30:21.57847+00	2025-04-01 06:13:44.138296+00	2025-04-01 06:30:21.57847+00
t2_8ae1b	wowthatsucked	0	0	0	0	0	2025-04-01 06:13:44.14057+00	2025-04-01 06:30:21.580884+00	2025-04-01 06:13:44.14057+00	2025-04-01 06:30:21.580884+00
t2_kjfudh2kq	Gold_Comfort156	0	0	0	0	0	2025-04-01 06:13:44.143039+00	2025-04-01 06:30:21.58303+00	2025-04-01 06:13:44.143039+00	2025-04-01 06:30:21.58303+00
t2_6oh81kre	kate-with-an-e	0	0	0	0	0	2025-04-01 06:13:44.145448+00	2025-04-01 06:30:21.585043+00	2025-04-01 06:13:44.145448+00	2025-04-01 06:30:21.585043+00
t2_1e23vraic8	Toniimack	0	0	0	0	0	2025-04-01 06:13:44.147604+00	2025-04-01 06:30:21.587089+00	2025-04-01 06:13:44.147604+00	2025-04-01 06:30:21.587089+00
t2_7trgw	IPAle81	0	0	0	0	0	2025-04-01 06:13:44.149767+00	2025-04-01 06:30:21.589039+00	2025-04-01 06:13:44.149767+00	2025-04-01 06:30:21.589039+00
t2_rkbtv	hatlock	0	0	0	0	0	2025-04-01 06:13:44.151863+00	2025-04-01 06:30:21.590995+00	2025-04-01 06:13:44.151863+00	2025-04-01 06:30:21.590995+00
t2_du35t	markeydusod	0	0	0	0	0	2025-04-01 06:13:44.153868+00	2025-04-01 06:30:21.592979+00	2025-04-01 06:13:44.153868+00	2025-04-01 06:30:21.592979+00
t2_f106vp85	B0RED_as_F	0	0	0	0	0	2025-04-01 06:13:44.155898+00	2025-04-01 06:30:21.594907+00	2025-04-01 06:13:44.155898+00	2025-04-01 06:30:21.594907+00
t2_6m8jkwyh	ZoomingBrain	0	0	0	0	0	2025-04-01 06:13:44.158192+00	2025-04-01 06:30:21.596918+00	2025-04-01 06:13:44.158192+00	2025-04-01 06:30:21.596918+00
t2_6wb6v22p	nothanksiliketowatch	0	0	0	0	0	2025-04-01 06:13:44.16059+00	2025-04-01 06:30:21.598831+00	2025-04-01 06:13:44.16059+00	2025-04-01 06:30:21.598831+00
t2_2rh9yh3a	AdvancedInstruction	0	0	0	0	0	2025-04-01 06:13:44.162813+00	2025-04-01 06:30:21.600549+00	2025-04-01 06:13:44.162813+00	2025-04-01 06:30:21.600549+00
t2_1gly3daz2e	king-boofer	0	0	0	0	0	2025-04-01 06:13:44.164897+00	2025-04-01 06:30:21.602278+00	2025-04-01 06:13:44.164897+00	2025-04-01 06:30:21.602278+00
t2_8rdsw	Imprezive503	0	0	0	0	0	2025-04-01 06:13:44.167057+00	2025-04-01 06:30:21.603678+00	2025-04-01 06:13:44.167057+00	2025-04-01 06:30:21.603678+00
t2_dgn9u	nsctank	0	0	0	0	0	2025-04-01 06:30:30.28491+00	2025-04-01 06:30:30.28491+00	2025-04-01 06:30:30.28491+00	2025-04-01 06:30:30.28491+00
t2_8du7p9b1	AceMcStace	0	0	0	0	0	2025-04-01 06:30:30.291798+00	2025-04-01 06:30:30.291798+00	2025-04-01 06:30:30.291798+00	2025-04-01 06:30:30.291798+00
t2_86nxh	Gravelsack	0	0	0	0	0	2025-04-01 06:30:30.29557+00	2025-04-01 06:30:30.29557+00	2025-04-01 06:30:30.29557+00	2025-04-01 06:30:30.29557+00
t2_y2gbp	DespiteStraightLines	0	0	0	0	0	2025-04-01 06:30:30.299278+00	2025-04-01 06:30:30.299278+00	2025-04-01 06:30:30.299278+00	2025-04-01 06:30:30.299278+00
t2_c3dee	AndrewPDXGSE	0	0	0	0	0	2025-04-01 06:30:30.302742+00	2025-04-01 06:30:30.302742+00	2025-04-01 06:30:30.302742+00	2025-04-01 06:30:30.302742+00
t2_1cx9xq9cec	DopeSeek	0	0	0	0	0	2025-04-01 06:30:30.306603+00	2025-04-01 06:30:30.306603+00	2025-04-01 06:30:30.306603+00	2025-04-01 06:30:30.306603+00
t2_4lqn3822	valencia_merble	0	0	0	0	0	2025-04-01 06:30:30.310788+00	2025-04-01 06:30:30.310788+00	2025-04-01 06:30:30.310788+00	2025-04-01 06:30:30.310788+00
t2_733gn	greazysteak	0	2	0	2	0	2025-04-01 06:13:44.16904+00	2025-04-28 05:54:45.257681+00	2025-04-01 06:13:44.16904+00	2025-04-28 05:54:45.484013+00
t2_1fgu7qgrfu	HatchbackUAP	0	0	0	0	0	2025-04-01 06:30:30.317931+00	2025-04-01 06:30:30.317931+00	2025-04-01 06:30:30.317931+00	2025-04-01 06:30:30.317931+00
t2_fb8hw	Airweldon	0	0	0	0	0	2025-04-01 06:30:30.320625+00	2025-04-01 06:30:30.320625+00	2025-04-01 06:30:30.320625+00	2025-04-01 06:30:30.320625+00
t2_1k8w0wntro	Glittering-King1418	0	0	0	0	0	2025-04-01 06:30:30.323341+00	2025-04-01 06:30:30.323341+00	2025-04-01 06:30:30.323341+00	2025-04-01 06:30:30.323341+00
t2_4nn7joy1	HighMarshalSigismund	0	0	0	0	0	2025-04-01 06:30:30.326036+00	2025-04-01 06:30:30.326036+00	2025-04-01 06:30:30.326036+00	2025-04-01 06:30:30.326036+00
t2_6aih3qz9	pnw_ovrlandr	0	0	0	0	0	2025-04-01 06:30:30.328549+00	2025-04-01 06:30:30.328549+00	2025-04-01 06:30:30.328549+00	2025-04-01 06:30:30.328549+00
t2_9plibs0w	farfetchds_leek	0	0	0	0	0	2025-04-01 06:30:30.331665+00	2025-04-01 06:30:30.331665+00	2025-04-01 06:30:30.331665+00	2025-04-01 06:30:30.331665+00
t2_4nfo0o3t	LloydChristmas_PDX	0	0	0	0	0	2025-04-01 06:30:30.334688+00	2025-04-01 06:30:30.334688+00	2025-04-01 06:30:30.334688+00	2025-04-01 06:30:30.334688+00
t2_1iq0cr64tz	TheGeekFreak1994	0	0	0	0	0	2025-04-01 06:30:30.337416+00	2025-04-01 06:30:30.337416+00	2025-04-01 06:30:30.337416+00	2025-04-01 06:30:30.337416+00
t2_11pz34qbf1	BootyCrunchXL	0	0	0	0	0	2025-04-01 06:30:30.343163+00	2025-04-01 06:30:30.343163+00	2025-04-01 06:30:30.343163+00	2025-04-01 06:30:30.343163+00
t2_c53tvtf9	Complete_Victory_272	0	0	0	0	0	2025-04-01 06:30:43.93959+00	2025-04-01 06:30:43.93959+00	2025-04-01 06:30:43.93959+00	2025-04-01 06:30:43.93959+00
t2_mth7x32n	kmartpnw	0	0	0	0	0	2025-04-01 06:30:43.947274+00	2025-04-01 06:30:43.947274+00	2025-04-01 06:30:43.947274+00	2025-04-01 06:30:43.947274+00
t2_t641g9ze	PianoEducational4648	0	0	0	0	0	2025-04-01 06:30:43.953387+00	2025-04-01 06:30:43.953387+00	2025-04-01 06:30:43.953387+00	2025-04-01 06:30:43.953387+00
t2_12b1u3	TeenzBeenz	0	0	0	0	0	2025-04-01 06:30:43.958649+00	2025-04-01 06:30:43.958649+00	2025-04-01 06:30:43.958649+00	2025-04-01 06:30:43.958649+00
t2_l86g3c8f	bosshawk708219	0	0	0	0	0	2025-04-01 06:30:43.962612+00	2025-04-01 06:30:43.962612+00	2025-04-01 06:30:43.962612+00	2025-04-01 06:30:43.962612+00
t2_98u9v87n	Mammoth_Temporary905	0	0	0	0	0	2025-04-01 06:30:43.966883+00	2025-04-01 06:30:43.966883+00	2025-04-01 06:30:43.966883+00	2025-04-01 06:30:43.966883+00
t2_10pm0enps0	Pelli_Furry_Account	0	0	0	0	0	2025-04-01 06:30:43.971294+00	2025-04-01 06:30:43.971294+00	2025-04-01 06:30:43.971294+00	2025-04-01 06:30:43.971294+00
t2_mbhzfm6c	skeletonwytch	0	0	0	0	0	2025-04-01 06:30:43.9751+00	2025-04-01 06:30:43.9751+00	2025-04-01 06:30:43.9751+00	2025-04-01 06:30:43.9751+00
t2_49d55	rarehugs	0	0	0	0	0	2025-04-01 06:30:43.978077+00	2025-04-01 06:30:43.978077+00	2025-04-01 06:30:43.978077+00	2025-04-01 06:30:43.978077+00
t2_548kqhya	Turbo_mannnn	0	0	0	0	0	2025-04-01 06:30:43.981043+00	2025-04-01 06:30:43.981043+00	2025-04-01 06:30:43.981043+00	2025-04-01 06:30:43.981043+00
t2_kr7bmyzvz	Imaginary-Method4694	0	0	0	0	0	2025-04-01 06:30:43.983862+00	2025-04-01 06:30:43.986681+00	2025-04-01 06:30:43.983862+00	2025-04-01 06:30:43.986681+00
t2_e7qppv4x	StriplinTree	0	0	0	0	0	2025-04-01 06:30:43.989612+00	2025-04-01 06:30:43.989612+00	2025-04-01 06:30:43.989612+00	2025-04-01 06:30:43.989612+00
t2_7omq4	DirkIsGestolen	0	0	0	0	0	2025-04-01 06:30:43.992636+00	2025-04-01 06:30:43.992636+00	2025-04-01 06:30:43.992636+00	2025-04-01 06:30:43.992636+00
t2_cxzmwzng	MTsharkbait	0	0	0	0	0	2025-04-01 06:30:52.505689+00	2025-04-01 06:30:52.505689+00	2025-04-01 06:30:52.505689+00	2025-04-01 06:30:52.505689+00
t2_3do3ef02	McGeeze	0	0	0	0	0	2025-04-01 06:30:52.508279+00	2025-04-01 06:30:52.508279+00	2025-04-01 06:30:52.508279+00	2025-04-01 06:30:52.508279+00
t2_vlm2sqhj	likethus	0	0	0	0	0	2025-04-01 06:30:52.513194+00	2025-04-01 06:30:52.513194+00	2025-04-01 06:30:52.513194+00	2025-04-01 06:30:52.513194+00
t2_pafbr	suitopseudo	0	0	0	0	0	2025-04-01 06:30:52.519701+00	2025-04-01 06:30:52.519701+00	2025-04-01 06:30:52.519701+00	2025-04-01 06:30:52.519701+00
t2_i42xi	thisisclaytonk	0	0	0	0	0	2025-04-01 06:30:52.522895+00	2025-04-01 06:30:52.522895+00	2025-04-01 06:30:52.522895+00	2025-04-01 06:30:52.522895+00
t2_nyrvt2p1c	Serious-Spread-6924	0	0	0	0	0	2025-04-01 06:30:52.524971+00	2025-04-01 06:30:52.524971+00	2025-04-01 06:30:52.524971+00	2025-04-01 06:30:52.524971+00
t2_54x24sdnm	WitchProjecter	0	0	0	0	0	2025-04-01 06:30:52.527165+00	2025-04-01 06:30:52.527165+00	2025-04-01 06:30:52.527165+00	2025-04-01 06:30:52.527165+00
t2_16qeu0	threebillion6	0	0	0	0	0	2025-04-01 06:30:52.529341+00	2025-04-01 06:30:52.529341+00	2025-04-01 06:30:52.529341+00	2025-04-01 06:30:52.529341+00
t2_81ldsjtg	jayfinanderson	0	0	0	0	0	2025-04-01 06:30:52.531562+00	2025-04-01 06:30:52.531562+00	2025-04-01 06:30:52.531562+00	2025-04-01 06:30:52.531562+00
t2_avn8ao	gloriapeterson	0	0	0	0	0	2025-04-01 06:30:52.534058+00	2025-04-01 06:30:52.534058+00	2025-04-01 06:30:52.534058+00	2025-04-01 06:30:52.534058+00
t2_erav1	c3534l	0	0	0	0	0	2025-04-01 06:30:52.536142+00	2025-04-01 06:30:52.536142+00	2025-04-01 06:30:52.536142+00	2025-04-01 06:30:52.536142+00
t2_4wrob	ChaosEsper	0	0	0	0	0	2025-04-01 06:30:52.538316+00	2025-04-01 06:30:52.538316+00	2025-04-01 06:30:52.538316+00	2025-04-01 06:30:52.538316+00
t2_5yppr	AlexV348	0	0	0	0	0	2025-04-01 06:30:52.540764+00	2025-04-01 06:30:52.540764+00	2025-04-01 06:30:52.540764+00	2025-04-01 06:30:52.540764+00
t2_f7rf258a	deliriumelixr	0	0	0	0	0	2025-04-01 06:30:52.543022+00	2025-04-01 06:30:52.543022+00	2025-04-01 06:30:52.543022+00	2025-04-01 06:30:52.543022+00
t2_a4wamqfy	pnwdoggolover	0	0	0	0	0	2025-04-11 03:32:56.682994+00	2025-04-11 03:32:56.682994+00	2025-04-11 03:32:56.682994+00	2025-04-11 03:32:56.682994+00
t2_725lo	cjicantlie	0	0	0	0	0	2025-04-11 03:32:56.699408+00	2025-04-11 03:32:56.699408+00	2025-04-11 03:32:56.699408+00	2025-04-11 03:32:56.699408+00
t2_96uhxwxj	Klutzy-Reaction5536	0	0	0	0	0	2025-04-11 03:32:56.703267+00	2025-04-11 03:32:56.703267+00	2025-04-11 03:32:56.703267+00	2025-04-11 03:32:56.703267+00
t2_9scvr	er-day	0	0	0	0	0	2025-04-11 03:32:56.706706+00	2025-04-11 03:32:56.706706+00	2025-04-11 03:32:56.706706+00	2025-04-11 03:32:56.706706+00
t2_bv5qp	Joe503	0	0	0	0	0	2025-04-11 03:32:56.710282+00	2025-04-11 03:32:56.710282+00	2025-04-11 03:32:56.710282+00	2025-04-11 03:32:56.710282+00
t2_rmqbblc98	KronicKimchi420	0	0	0	0	0	2025-04-11 03:32:56.717326+00	2025-04-11 03:32:56.717326+00	2025-04-11 03:32:56.717326+00	2025-04-11 03:32:56.717326+00
t2_lanpf29	dmslucy	0	0	0	0	0	2025-04-11 03:32:56.720534+00	2025-04-11 03:32:56.720534+00	2025-04-11 03:32:56.720534+00	2025-04-11 03:32:56.720534+00
t2_iw284	palmquac	0	0	0	0	0	2025-04-11 03:32:56.726185+00	2025-04-11 03:32:56.726185+00	2025-04-11 03:32:56.726185+00	2025-04-11 03:32:56.726185+00
t2_1h6qatpz	WoodpeckerGingivitis	0	0	0	0	0	2025-04-11 03:32:56.729043+00	2025-04-11 03:32:56.729043+00	2025-04-11 03:32:56.729043+00	2025-04-11 03:32:56.729043+00
t2_anyv0	BentleyTock	0	0	0	0	0	2025-04-11 03:32:56.732025+00	2025-04-11 03:32:56.732025+00	2025-04-11 03:32:56.732025+00	2025-04-11 03:32:56.732025+00
t2_e7gjo	coffeeandkerouac	0	0	0	0	0	2025-04-11 03:32:56.738271+00	2025-04-11 03:32:56.738271+00	2025-04-11 03:32:56.738271+00	2025-04-11 03:32:56.738271+00
t2_i8lt2	snakebite75	0	0	0	0	0	2025-04-11 03:32:56.744235+00	2025-04-11 03:32:56.744235+00	2025-04-11 03:32:56.744235+00	2025-04-11 03:32:56.744235+00
t2_3lwn6a7n	tropicmanu	0	0	0	0	0	2025-04-11 03:32:56.747246+00	2025-04-11 03:32:56.747246+00	2025-04-11 03:32:56.747246+00	2025-04-11 03:32:56.747246+00
t2_82jrdm7b	scooterinpdx	0	0	0	0	0	2025-04-11 03:33:04.808758+00	2025-04-11 03:33:04.808758+00	2025-04-11 03:33:04.808758+00	2025-04-11 03:33:04.808758+00
t2_lwgx87c	srirachamatic	0	0	0	0	0	2025-04-11 03:33:04.814812+00	2025-04-11 03:33:04.814812+00	2025-04-11 03:33:04.814812+00	2025-04-11 03:33:04.814812+00
t2_8bpjy0c0	Calm_One_1228	0	0	0	0	0	2025-04-11 03:33:04.818572+00	2025-04-11 03:33:04.818572+00	2025-04-11 03:33:04.818572+00	2025-04-11 03:33:04.818572+00
t2_3jsbv	Pinot911	0	0	0	0	0	2025-04-11 03:33:04.821952+00	2025-04-11 03:33:04.821952+00	2025-04-11 03:33:04.821952+00	2025-04-11 03:33:04.821952+00
t2_uxqvda3s	GenericDesigns	0	0	0	0	0	2025-04-11 03:33:04.825347+00	2025-04-11 03:33:04.825347+00	2025-04-11 03:33:04.825347+00	2025-04-11 03:33:04.825347+00
t2_79xvq	lexuh	0	0	0	0	0	2025-04-01 06:30:52.51083+00	2025-04-11 03:33:27.106982+00	2025-04-01 06:30:52.51083+00	2025-04-11 03:33:27.106982+00
t2_10s82e	xbad_wolfxi	0	0	0	0	0	2025-04-11 03:33:04.832161+00	2025-04-11 03:33:04.832161+00	2025-04-11 03:33:04.832161+00	2025-04-11 03:33:04.832161+00
t2_92sa0	TASTY_TASTY_WAFFLES	0	0	0	0	0	2025-04-11 03:33:04.835236+00	2025-04-11 03:33:04.835236+00	2025-04-11 03:33:04.835236+00	2025-04-11 03:33:04.835236+00
t2_46izuqga	ScuderiaEnzo	0	0	0	0	0	2025-04-11 03:33:04.838082+00	2025-04-11 03:33:04.838082+00	2025-04-11 03:33:04.838082+00	2025-04-11 03:33:04.838082+00
t2_2a9stiwu	wxsherri	0	0	0	0	0	2025-04-11 03:33:04.840834+00	2025-04-11 03:33:04.840834+00	2025-04-11 03:33:04.840834+00	2025-04-11 03:33:04.840834+00
t2_8d1h1	MyNameIsRJ	0	0	0	0	0	2025-04-11 03:33:04.84377+00	2025-04-11 03:33:04.84377+00	2025-04-11 03:33:04.84377+00	2025-04-11 03:33:04.84377+00
t2_1cz59tledg	littl3-fish	0	0	0	0	0	2025-04-11 03:33:04.846886+00	2025-04-11 03:33:04.846886+00	2025-04-11 03:33:04.846886+00	2025-04-11 03:33:04.846886+00
t2_4ydgo	Skedoozy	0	0	0	0	0	2025-04-11 03:33:04.849744+00	2025-04-11 03:33:04.849744+00	2025-04-11 03:33:04.849744+00	2025-04-11 03:33:04.849744+00
t2_363twqzf	AGGROCrombiE1967	0	0	0	0	0	2025-04-11 03:32:56.713847+00	2025-04-11 03:33:18.774862+00	2025-04-11 03:32:56.713847+00	2025-04-11 03:33:18.774862+00
t2_riovcvu6	allislost77	0	4	0	44	0	2025-04-01 06:30:30.340168+00	2025-04-28 05:55:44.717239+00	2025-04-01 06:30:30.340168+00	2025-04-28 05:55:44.865721+00
t2_117xp2jpyl	wakeupintherain	0	1	0	6	0	2025-04-11 03:32:56.735274+00	2025-04-28 05:55:44.701798+00	2025-04-11 03:32:56.735274+00	2025-04-28 05:55:44.825874+00
t2_eta1l	humanclock	0	0	0	0	0	2025-04-11 03:32:56.695288+00	2025-04-28 05:21:05.637414+00	2025-04-11 03:32:56.695288+00	2025-04-28 05:21:05.637414+00
t2_x0zk	serpentjaguar	0	2	0	18	0	2025-04-11 03:32:56.741159+00	2025-04-28 05:54:45.157152+00	2025-04-11 03:32:56.741159+00	2025-04-28 05:54:45.329296+00
t2_186w0fp4	QuercusSambucus	0	2	0	267	0	2025-04-01 06:30:52.515473+00	2025-04-28 05:54:45.152011+00	2025-04-01 06:30:52.515473+00	2025-04-28 05:54:45.324449+00
t2_9rb7awwf	Wrayven77	0	1	0	2	0	2025-04-01 06:30:30.314705+00	2025-04-28 05:21:43.933918+00	2025-04-01 06:30:30.314705+00	2025-04-28 05:21:43.933918+00
t2_rwmcg8apd	xojz	0	1	0	7	0	2025-04-11 03:32:56.723382+00	2025-04-28 05:55:03.031596+00	2025-04-11 03:32:56.723382+00	2025-04-28 05:55:03.063681+00
t2_14zrt1	poopmongral	0	0	0	0	0	2025-04-11 03:33:04.852676+00	2025-04-11 03:33:04.852676+00	2025-04-11 03:33:04.852676+00	2025-04-11 03:33:04.852676+00
t2_47q8uf48	AggressivePayment0	0	0	0	0	0	2025-04-11 03:33:04.85631+00	2025-04-11 03:33:04.85631+00	2025-04-11 03:33:04.85631+00	2025-04-11 03:33:04.85631+00
t2_n4kfdzix	How-Did-I-Get-Here89	0	0	0	0	0	2025-04-11 03:33:04.859721+00	2025-04-11 03:33:04.859721+00	2025-04-11 03:33:04.859721+00	2025-04-11 03:33:04.859721+00
t2_dhjpds8q	Economy_Signature_54	0	0	0	0	0	2025-04-11 03:33:18.71925+00	2025-04-11 03:33:18.71925+00	2025-04-11 03:33:18.71925+00	2025-04-11 03:33:18.71925+00
t2_ul68190p	Common_Mess_8635	0	0	0	0	0	2025-04-11 03:33:18.722597+00	2025-04-11 03:33:18.722597+00	2025-04-11 03:33:18.722597+00	2025-04-11 03:33:18.722597+00
t2_qjqf3	allWIdoiswin	0	0	0	0	0	2025-04-11 03:33:18.725608+00	2025-04-11 03:33:18.725608+00	2025-04-11 03:33:18.725608+00	2025-04-11 03:33:18.725608+00
t2_5jcsg	rocketmanatee	0	0	0	0	0	2025-04-11 03:33:18.731878+00	2025-04-11 03:33:18.731878+00	2025-04-11 03:33:18.731878+00	2025-04-11 03:33:18.731878+00
t2_111ein	rupert101	0	0	0	0	0	2025-04-11 03:33:18.734022+00	2025-04-11 03:33:18.734022+00	2025-04-11 03:33:18.734022+00	2025-04-11 03:33:18.734022+00
t2_6dk6i	8bitrevolt	0	0	0	0	0	2025-04-11 03:33:18.736437+00	2025-04-11 03:33:18.736437+00	2025-04-11 03:33:18.736437+00	2025-04-11 03:33:18.736437+00
t2_1ug8ol1n	FantasticBreadfruit8	0	0	0	0	0	2025-04-11 03:33:18.738774+00	2025-04-11 03:33:18.738774+00	2025-04-11 03:33:18.738774+00	2025-04-11 03:33:18.738774+00
t2_4de9762c	shopkins402	0	0	0	0	0	2025-04-11 03:33:18.740843+00	2025-04-11 03:33:18.740843+00	2025-04-11 03:33:18.740843+00	2025-04-11 03:33:18.740843+00
t2_iskky02k	Automatic-Being-	0	0	0	0	0	2025-04-11 03:33:18.742998+00	2025-04-11 03:33:18.742998+00	2025-04-11 03:33:18.742998+00	2025-04-11 03:33:18.742998+00
t2_9igtz6vh	Desperate_Fun8940	0	0	0	0	0	2025-04-11 03:33:18.744847+00	2025-04-11 03:33:18.744847+00	2025-04-11 03:33:18.744847+00	2025-04-11 03:33:18.744847+00
t2_166u5b51z5	AccountAQuiltYBuddy	0	0	0	0	0	2025-04-11 03:33:18.747915+00	2025-04-11 03:33:18.747915+00	2025-04-11 03:33:18.747915+00	2025-04-11 03:33:18.747915+00
t2_155iqt	roundish_square_face	0	0	0	0	0	2025-04-11 03:33:18.750145+00	2025-04-11 03:33:18.750145+00	2025-04-11 03:33:18.750145+00	2025-04-11 03:33:18.750145+00
t2_dvxzp	JohnMayerCd	0	0	0	0	0	2025-04-11 03:33:18.752194+00	2025-04-11 03:33:18.752194+00	2025-04-11 03:33:18.752194+00	2025-04-11 03:33:18.752194+00
t2_6geys27r	cupcakemon	0	0	0	0	0	2025-04-11 03:33:18.754398+00	2025-04-11 03:33:18.754398+00	2025-04-11 03:33:18.754398+00	2025-04-11 03:33:18.754398+00
t2_19jg1jlqh7	SammlerWorksArt	0	0	0	0	0	2025-04-11 03:33:18.756408+00	2025-04-11 03:33:18.756408+00	2025-04-11 03:33:18.756408+00	2025-04-11 03:33:18.756408+00
t2_1jnt6wh6tz	waryfairycattails	0	0	0	0	0	2025-04-11 03:33:18.758429+00	2025-04-11 03:33:18.758429+00	2025-04-11 03:33:18.758429+00	2025-04-11 03:33:18.758429+00
t2_16c55uou1t	Antique_Parsley_5285	0	0	0	0	0	2025-04-11 03:33:18.759994+00	2025-04-11 03:33:18.759994+00	2025-04-11 03:33:18.759994+00	2025-04-11 03:33:18.759994+00
t2_2qvznld3	pathoj3nn	0	0	0	0	0	2025-04-11 03:33:18.762158+00	2025-04-11 03:33:18.762158+00	2025-04-11 03:33:18.762158+00	2025-04-11 03:33:18.762158+00
t2_1ezi73	2nd_best_time	0	0	0	0	0	2025-04-11 03:33:18.764638+00	2025-04-11 03:33:18.764638+00	2025-04-11 03:33:18.764638+00	2025-04-11 03:33:18.764638+00
t2_7loxvigr	DepreciatedSelfImage	0	0	0	0	0	2025-04-11 03:33:18.7668+00	2025-04-11 03:33:18.7668+00	2025-04-11 03:33:18.7668+00	2025-04-11 03:33:18.7668+00
t2_cmqsw	rctid12345	0	0	0	0	0	2025-04-11 03:33:18.768825+00	2025-04-11 03:33:18.768825+00	2025-04-11 03:33:18.768825+00	2025-04-11 03:33:18.768825+00
t2_6zas4uzi	PsychologicalLuck343	0	0	0	0	0	2025-04-11 03:33:18.770946+00	2025-04-11 03:33:18.770946+00	2025-04-11 03:33:18.770946+00	2025-04-11 03:33:18.770946+00
t2_c02a6qja	pomchip	0	0	0	0	0	2025-04-11 03:33:18.77294+00	2025-04-11 03:33:18.77294+00	2025-04-11 03:33:18.77294+00	2025-04-11 03:33:18.77294+00
t2_9y3dx	izzieraine	0	0	0	0	0	2025-04-11 03:33:18.776891+00	2025-04-11 03:33:18.776891+00	2025-04-11 03:33:18.776891+00	2025-04-11 03:33:18.776891+00
t2_y94wo	LivinthatDream	0	0	0	0	0	2025-04-11 03:33:18.779277+00	2025-04-11 03:33:18.779277+00	2025-04-11 03:33:18.779277+00	2025-04-11 03:33:18.779277+00
t2_t49rvv0	bendywhoops	0	0	0	0	0	2025-04-11 03:33:18.781601+00	2025-04-11 03:33:18.781601+00	2025-04-11 03:33:18.781601+00	2025-04-11 03:33:18.781601+00
t2_3lg3qfa	mama_O_moon	0	0	0	0	0	2025-04-11 03:33:27.113785+00	2025-04-11 03:33:27.113785+00	2025-04-11 03:33:27.113785+00	2025-04-11 03:33:27.113785+00
t2_1i3enfevbb	Coriander70	0	0	0	0	0	2025-04-11 03:33:27.117087+00	2025-04-11 03:33:27.117087+00	2025-04-11 03:33:27.117087+00	2025-04-11 03:33:27.117087+00
t2_1t3m7be	normanbeets	0	0	0	0	0	2025-04-11 03:33:27.120642+00	2025-04-11 03:33:27.120642+00	2025-04-11 03:33:27.120642+00	2025-04-11 03:33:27.120642+00
t2_jvadzdse	hkohne	0	0	0	0	0	2025-04-11 03:33:18.728867+00	2025-04-11 03:33:27.126393+00	2025-04-11 03:33:18.728867+00	2025-04-11 03:33:27.126393+00
t2_92u1i	TrendySpork	0	3	0	43	0	2025-04-28 00:16:42.364834+00	2025-04-28 05:55:53.264748+00	2025-04-28 00:16:42.364834+00	2025-04-28 05:55:53.321875+00
t2_atfhy	Aestro17	0	0	0	0	0	2025-04-11 03:33:27.13116+00	2025-04-11 03:33:27.13116+00	2025-04-11 03:33:27.13116+00	2025-04-11 03:33:27.13116+00
t2_668wi1i0	EdgeJG	0	0	0	0	0	2025-04-11 03:33:27.133388+00	2025-04-11 03:33:27.133388+00	2025-04-11 03:33:27.133388+00	2025-04-11 03:33:27.133388+00
t2_1dq13pl	shrug_addict	0	0	0	0	0	2025-04-11 03:33:27.135315+00	2025-04-11 03:33:27.135315+00	2025-04-11 03:33:27.135315+00	2025-04-11 03:33:27.135315+00
t2_xvwkf	MmmnonmmM	0	0	0	0	0	2025-04-11 03:33:27.13778+00	2025-04-11 03:33:27.13778+00	2025-04-11 03:33:27.13778+00	2025-04-11 03:33:27.13778+00
t2_6uu8d	whythiskink	0	0	0	0	0	2025-04-11 03:33:27.13993+00	2025-04-11 03:33:27.13993+00	2025-04-11 03:33:27.13993+00	2025-04-11 03:33:27.13993+00
t2_mj307pjt	BankManager69420	0	0	0	0	0	2025-04-11 03:33:27.142037+00	2025-04-11 03:33:27.142037+00	2025-04-11 03:33:27.142037+00	2025-04-11 03:33:27.142037+00
t2_f0gxl	RIP_MAC_DRE	0	0	0	0	0	2025-04-11 03:33:27.143873+00	2025-04-11 03:33:27.143873+00	2025-04-11 03:33:27.143873+00	2025-04-11 03:33:27.143873+00
t2_czzo0ad7	agoodveilsays	0	0	0	0	0	2025-04-11 03:33:27.145863+00	2025-04-11 03:33:27.145863+00	2025-04-11 03:33:27.145863+00	2025-04-11 03:33:27.145863+00
t2_90zkb	ScenicFrost	0	0	0	0	0	2025-04-11 03:33:27.147851+00	2025-04-11 03:33:27.147851+00	2025-04-11 03:33:27.147851+00	2025-04-11 03:33:27.147851+00
t2_ez04y3cs	Puzzled_Respond_3335	0	0	0	0	0	2025-04-11 03:33:27.149834+00	2025-04-11 03:33:27.149834+00	2025-04-11 03:33:27.149834+00	2025-04-11 03:33:27.149834+00
t2_6lqdky50	DetectiveMoosePI	0	0	0	0	0	2025-04-11 03:33:27.151835+00	2025-04-11 03:33:27.151835+00	2025-04-11 03:33:27.151835+00	2025-04-11 03:33:27.151835+00
t2_19cfuchlpn	RuckFeddit980	0	0	0	0	0	2025-04-11 03:33:27.154616+00	2025-04-11 03:33:27.154616+00	2025-04-11 03:33:27.154616+00	2025-04-11 03:33:27.154616+00
t2_4jid17ii	user5789223522347721	0	0	0	0	0	2025-04-11 03:33:27.157791+00	2025-04-11 03:33:27.157791+00	2025-04-11 03:33:27.157791+00	2025-04-11 03:33:27.157791+00
t2_nfcolw2b	Individual-Push3412	0	0	0	0	0	2025-04-11 03:33:27.10165+00	2025-04-11 03:33:27.16075+00	2025-04-11 03:33:27.10165+00	2025-04-11 03:33:27.16075+00
t2_85ht5	altoidsyn	0	0	0	0	0	2025-04-11 03:33:27.163683+00	2025-04-11 03:33:27.163683+00	2025-04-11 03:33:27.163683+00	2025-04-11 03:33:27.163683+00
t2_f3zpr	tsarchasm1	0	0	0	0	0	2025-04-11 03:33:27.166516+00	2025-04-11 03:33:27.166516+00	2025-04-11 03:33:27.166516+00	2025-04-11 03:33:27.166516+00
t2_zvv246l3g	RealisticNecessary50	0	2	0	117	0	2025-04-28 00:16:42.341878+00	2025-04-28 05:54:45.141091+00	2025-04-28 00:16:42.341878+00	2025-04-28 05:54:45.314859+00
t2_wyak4	pdxczmate	0	0	0	0	0	2025-04-11 03:33:27.110199+00	2025-04-11 03:33:27.173087+00	2025-04-11 03:33:27.110199+00	2025-04-11 03:33:27.173087+00
t2_l559btzf	Fun_Wait1183	0	0	0	0	0	2025-04-11 03:33:27.175845+00	2025-04-11 03:33:27.175845+00	2025-04-11 03:33:27.175845+00	2025-04-11 03:33:27.175845+00
t2_iukms	terra_pericolosa	0	2	0	28	0	2025-04-28 00:16:42.367084+00	2025-04-28 05:54:45.125858+00	2025-04-28 00:16:42.367084+00	2025-04-28 05:54:45.305038+00
t2_195ts0jwox	DevilsDetailsDiva	0	2	0	48	0	2025-04-28 00:16:42.343781+00	2025-04-28 05:54:45.162047+00	2025-04-28 00:16:42.343781+00	2025-04-28 05:54:45.334145+00
t2_jh1xi	casualnarcissist	0	2	0	482	0	2025-04-28 00:16:42.337483+00	2025-04-28 05:54:45.118235+00	2025-04-28 00:16:42.337483+00	2025-04-28 05:54:45.300153+00
t2_bz1kk	ShiraCheshire	0	2	0	55	0	2025-04-28 00:16:42.354097+00	2025-04-28 05:54:45.146966+00	2025-04-28 00:16:42.354097+00	2025-04-28 05:54:45.319514+00
t2_5qk14fog	piuoureigh	0	2	0	8	0	2025-04-28 00:16:42.360315+00	2025-04-28 05:54:45.188056+00	2025-04-28 00:16:42.360315+00	2025-04-28 05:54:45.368177+00
t2_8m0wnruu	DurianGris	0	2	0	14	0	2025-04-28 00:16:42.358247+00	2025-04-28 05:54:45.200421+00	2025-04-28 00:16:42.358247+00	2025-04-28 05:54:45.388063+00
t2_3b26rfa5	takefiftyseven	0	3	0	20	0	2025-04-28 00:16:42.362909+00	2025-04-28 05:54:45.203211+00	2025-04-28 00:16:42.362909+00	2025-04-28 05:54:45.392992+00
t2_u4cs4	WeAreClouds	0	2	0	9	0	2025-04-28 00:16:42.356221+00	2025-04-28 05:54:45.221057+00	2025-04-28 00:16:42.356221+00	2025-04-28 05:54:45.429182+00
t2_5rkmg4jl9	chesnutsandbananas	10	0	5854	0	0	2025-04-28 00:16:42.33135+00	2025-04-28 05:54:45.092089+00	2025-04-28 00:16:42.33135+00	2025-04-28 05:56:02.425418+00
t2_vogpg3w9	notanaigeneratedname	0	2	0	52	0	2025-04-28 00:16:42.352299+00	2025-04-28 05:54:45.184999+00	2025-04-28 00:16:42.352299+00	2025-04-28 05:54:45.363294+00
t2_13qk8tncip	PDX-Wino	0	2	0	464	0	2025-04-28 00:16:42.339772+00	2025-04-28 05:54:45.102908+00	2025-04-28 00:16:42.339772+00	2025-04-28 05:54:45.289744+00
t2_1b5jtsct	MountScottRumpot	0	0	0	0	0	2025-04-11 03:33:27.123823+00	2025-04-28 05:19:19.076955+00	2025-04-11 03:33:27.123823+00	2025-04-28 05:19:19.076955+00
t2_n62oysdu	PoutineMeInCoach	0	2	0	53	0	2025-04-28 00:16:42.350304+00	2025-04-28 05:54:45.178509+00	2025-04-28 00:16:42.350304+00	2025-04-28 05:54:45.353521+00
t2_7nvp11r2l	FatedAtropos	0	3	0	114	0	2025-04-28 00:16:42.348066+00	2025-04-28 05:54:45.110074+00	2025-04-28 00:16:42.348066+00	2025-04-28 05:54:45.295047+00
t2_8itijzo4	light_layers	0	0	0	0	0	2025-04-28 00:17:04.080086+00	2025-04-28 00:17:04.080086+00	2025-04-28 00:17:04.080086+00	2025-04-28 00:17:04.080086+00
t2_3sbwjjxw	1questions	0	0	0	0	0	2025-04-28 00:17:04.082652+00	2025-04-28 00:17:04.082652+00	2025-04-28 00:17:04.082652+00	2025-04-28 00:17:04.082652+00
t2_1t23ckfy	DichotomyJones	0	0	0	0	0	2025-04-28 00:17:04.084852+00	2025-04-28 00:17:04.084852+00	2025-04-28 00:17:04.084852+00	2025-04-28 00:17:04.084852+00
t2_q0lwifpm	Corran22	0	0	0	0	0	2025-04-28 00:17:04.087717+00	2025-04-28 00:17:04.087717+00	2025-04-28 00:17:04.087717+00	2025-04-28 00:17:04.087717+00
t2_6ne9tzh8	rdg5220	0	0	0	0	0	2025-04-28 00:17:04.093067+00	2025-04-28 00:17:04.093067+00	2025-04-28 00:17:04.093067+00	2025-04-28 00:17:04.093067+00
t2_wqw1j	lovebeervana	0	0	0	0	0	2025-04-28 00:17:04.095836+00	2025-04-28 00:17:04.095836+00	2025-04-28 00:17:04.095836+00	2025-04-28 00:17:04.095836+00
t2_flt7lpno	SATURATION203	0	0	0	0	0	2025-04-28 00:17:04.098611+00	2025-04-28 00:17:04.098611+00	2025-04-28 00:17:04.098611+00	2025-04-28 00:17:04.098611+00
t2_o19j38tvx	jazzyoctopi	0	0	0	0	0	2025-04-28 00:17:04.101119+00	2025-04-28 00:17:04.101119+00	2025-04-28 00:17:04.101119+00	2025-04-28 00:17:04.101119+00
t2_83g0o	ma_miya	0	0	0	0	0	2025-04-28 00:17:04.103636+00	2025-04-28 00:17:04.103636+00	2025-04-28 00:17:04.103636+00	2025-04-28 00:17:04.103636+00
t2_15ul75	MetoliusOR	0	0	0	0	0	2025-04-28 00:17:04.10656+00	2025-04-28 00:17:04.10656+00	2025-04-28 00:17:04.10656+00	2025-04-28 00:17:04.10656+00
t2_razcv	CJ_MR	0	0	0	0	0	2025-04-28 00:17:04.109175+00	2025-04-28 00:17:04.109175+00	2025-04-28 00:17:04.109175+00	2025-04-28 00:17:04.109175+00
t2_em3kl	scrawesome	0	0	0	0	0	2025-04-28 00:17:04.111294+00	2025-04-28 00:17:04.111294+00	2025-04-28 00:17:04.111294+00	2025-04-28 00:17:04.111294+00
t2_1dqzldv6rs	SarisweetieD	0	0	0	0	0	2025-04-28 00:17:04.116934+00	2025-04-28 00:17:04.116934+00	2025-04-28 00:17:04.116934+00	2025-04-28 00:17:04.116934+00
t2_56o2jpyg	Ralph_O_nator	0	0	0	0	0	2025-04-28 00:17:04.119323+00	2025-04-28 00:17:04.119323+00	2025-04-28 00:17:04.119323+00	2025-04-28 00:17:04.119323+00
t2_ncobv	Blueskyminer	0	0	0	0	0	2025-04-28 00:17:04.121439+00	2025-04-28 00:17:04.121439+00	2025-04-28 00:17:04.121439+00	2025-04-28 00:17:04.121439+00
t2_eh34oy8mk	staredecisisdeeznutz	0	0	0	0	0	2025-04-28 00:17:04.123685+00	2025-04-28 00:17:04.123685+00	2025-04-28 00:17:04.123685+00	2025-04-28 00:17:04.123685+00
t2_et1rqpmiz	Salty-Loquat5311	0	0	0	0	0	2025-04-28 00:17:04.126009+00	2025-04-28 00:17:04.126009+00	2025-04-28 00:17:04.126009+00	2025-04-28 00:17:04.126009+00
t2_8qhgpfve	SafePractice2826	0	0	0	0	0	2025-04-28 00:17:04.11396+00	2025-04-28 00:17:04.128864+00	2025-04-28 00:17:04.11396+00	2025-04-28 00:17:04.128864+00
t2_jcaaqyr	schrammalama	0	0	0	0	0	2025-04-28 00:17:04.131439+00	2025-04-28 00:17:04.131439+00	2025-04-28 00:17:04.131439+00	2025-04-28 00:17:04.131439+00
t2_128trysv	Volgnes	0	0	0	0	0	2025-04-28 00:17:04.134205+00	2025-04-28 00:17:04.134205+00	2025-04-28 00:17:04.134205+00	2025-04-28 00:17:04.134205+00
t2_j3jkz3dv	who_peed_in_my_soup	0	0	0	0	0	2025-04-28 00:17:04.136946+00	2025-04-28 00:17:04.136946+00	2025-04-28 00:17:04.136946+00	2025-04-28 00:17:04.136946+00
t2_6j079	jaco1001	0	0	0	0	0	2025-04-28 00:17:04.139359+00	2025-04-28 00:17:04.139359+00	2025-04-28 00:17:04.139359+00	2025-04-28 00:17:04.139359+00
t2_92gvyj7r	CertifiedPeach	0	0	0	0	0	2025-04-28 00:17:04.141518+00	2025-04-28 00:17:04.141518+00	2025-04-28 00:17:04.141518+00	2025-04-28 00:17:04.141518+00
t2_15il6r	Mcswagnuggets	0	0	0	0	0	2025-04-28 00:17:04.144141+00	2025-04-28 00:17:04.144141+00	2025-04-28 00:17:04.144141+00	2025-04-28 00:17:04.144141+00
t2_h18xhvix	EmbarrassedIce678	0	0	0	0	0	2025-04-28 00:17:04.146729+00	2025-04-28 00:17:04.146729+00	2025-04-28 00:17:04.146729+00	2025-04-28 00:17:04.146729+00
t2_d7jgyi4w	OodaliOoo	0	0	0	0	0	2025-04-28 00:17:04.149023+00	2025-04-28 00:17:04.149023+00	2025-04-28 00:17:04.149023+00	2025-04-28 00:17:04.149023+00
t2_3olc5gnu	SwitchCube64	0	2	0	12	0	2025-04-28 00:16:42.380047+00	2025-04-28 05:54:45.197448+00	2025-04-28 00:16:42.380047+00	2025-04-28 05:54:45.383015+00
t2_8xlvlzvo	Substantial-Rough160	0	2	0	4	0	2025-04-28 02:12:20.691445+00	2025-04-28 05:54:45.19438+00	2025-04-28 02:12:20.691445+00	2025-04-28 05:54:45.37804+00
t2_ygopj	sizzlepie	0	2	0	7	0	2025-04-28 00:16:42.369472+00	2025-04-28 05:54:45.181721+00	2025-04-28 00:16:42.369472+00	2025-04-28 05:54:45.358554+00
t2_8duvo	16semesters	0	2	0	9	0	2025-04-28 00:16:42.384189+00	2025-04-28 05:54:45.227193+00	2025-04-28 00:16:42.384189+00	2025-04-28 05:54:45.439351+00
t2_6glju	maxstolfe	0	2	0	10	0	2025-04-28 02:12:20.634606+00	2025-04-28 05:54:45.170049+00	2025-04-28 02:12:20.634606+00	2025-04-28 05:54:45.343898+00
t2_9nkie1mb	JuggernautVirtual830	0	2	0	4	0	2025-04-28 00:16:42.387273+00	2025-04-28 05:54:45.20626+00	2025-04-28 00:16:42.387273+00	2025-04-28 05:54:45.397923+00
t2_tbx29	beerandloathingpdx	0	2	0	816	0	2025-04-28 02:12:28.962136+00	2025-04-28 05:54:54.23704+00	2025-04-28 02:12:28.962136+00	2025-04-28 05:54:54.426471+00
t2_8e9k4	hamellr	0	2	0	5	0	2025-04-28 00:16:42.389453+00	2025-04-28 05:54:45.191275+00	2025-04-28 00:16:42.389453+00	2025-04-28 05:54:45.373258+00
t2_3ab9k	Verbz	0	2	0	10	0	2025-04-28 00:16:42.391782+00	2025-04-28 05:54:45.166699+00	2025-04-28 00:16:42.391782+00	2025-04-28 05:54:45.338989+00
t2_oan07fr	MrFireAlarms	0	1	0	9	0	2025-04-28 00:17:11.994081+00	2025-04-28 02:42:08.138659+00	2025-04-28 00:17:11.994081+00	2025-04-28 02:42:08.185618+00
t2_o7rmn8i	SpaceCancer0	0	1	0	3	0	2025-04-28 00:17:11.997772+00	2025-04-28 02:42:08.145369+00	2025-04-28 00:17:11.997772+00	2025-04-28 02:42:08.191388+00
t2_cd2j8	DmnJuice	0	1	0	2	0	2025-04-28 00:17:12.001601+00	2025-04-28 02:42:08.151296+00	2025-04-28 00:17:12.001601+00	2025-04-28 02:42:08.196606+00
t2_71mvijin	Plastic-Campaign-654	0	2	0	89	0	2025-04-28 02:12:28.967868+00	2025-04-28 05:54:54.242181+00	2025-04-28 02:12:28.967868+00	2025-04-28 05:54:54.432425+00
t2_2gk6p4um	ghostwalls	0	2	0	4	0	2025-04-28 02:12:20.667857+00	2025-04-28 05:54:45.208697+00	2025-04-28 02:12:20.667857+00	2025-04-28 05:54:45.402704+00
t2_cspso	smootex	0	2	0	114	0	2025-04-28 02:12:28.976029+00	2025-04-28 05:54:54.252413+00	2025-04-28 02:12:28.976029+00	2025-04-28 05:54:54.444184+00
t2_6eg0e68t	KingOfCatProm	0	1	0	44	0	2025-04-28 00:17:04.09075+00	2025-04-28 02:42:39.311822+00	2025-04-28 00:17:04.09075+00	2025-04-28 02:42:39.413816+00
t2_q53d4pva	peregrina_e	0	2	0	21	0	2025-04-28 00:16:50.569487+00	2025-04-28 05:56:02.277211+00	2025-04-28 00:16:50.569487+00	2025-04-28 05:56:02.368888+00
t2_4vq8k32g	PrestigiousAd3701	0	2	0	1	0	2025-04-28 00:16:42.372568+00	2025-04-28 05:54:45.252557+00	2025-04-28 00:16:42.372568+00	2025-04-28 05:54:45.474298+00
t2_dddoyiejv	onewiththegoldenpath	0	2	0	1	0	2025-04-28 02:12:20.684411+00	2025-04-28 05:54:45.255184+00	2025-04-28 02:12:20.684411+00	2025-04-28 05:54:45.479228+00
t2_kc3da	MingMecca	0	2	0	0	0	2025-04-28 02:12:20.693994+00	2025-04-28 05:54:45.262646+00	2025-04-28 02:12:20.693994+00	2025-04-28 05:54:45.493758+00
t2_n0o7v9vc	Donewith398	0	2	0	-22	0	2025-04-28 00:16:42.393956+00	2025-04-28 05:54:45.267426+00	2025-04-28 00:16:42.393956+00	2025-04-28 05:54:45.503374+00
t2_dz6qx2d3	Ok-Caramel-1989	0	2	0	21	0	2025-04-28 02:12:20.688147+00	2025-04-28 05:54:45.134265+00	2025-04-28 02:12:20.688147+00	2025-04-28 05:54:45.3101+00
t2_16o3d2	drumscrubby	0	2	0	162	0	2025-04-28 02:12:28.972278+00	2025-04-28 05:54:54.247327+00	2025-04-28 02:12:28.972278+00	2025-04-28 05:54:54.438299+00
t2_54b831s9i	LendogGovy	0	2	0	40	0	2025-04-28 02:12:28.984326+00	2025-04-28 05:54:54.257377+00	2025-04-28 02:12:28.984326+00	2025-04-28 05:54:54.450049+00
t2_4cqbt	FocusFlukeGyro	0	2	0	66	0	2025-04-28 02:12:28.980768+00	2025-04-28 05:54:54.262077+00	2025-04-28 02:12:28.980768+00	2025-04-28 05:54:54.456462+00
t2_1cq2jfk2el	BlackMagicWorman	0	3	0	50	0	2025-04-28 00:16:50.558901+00	2025-04-28 05:54:54.272726+00	2025-04-28 00:16:50.558901+00	2025-04-28 05:54:54.468205+00
t2_176jt9	SAlovicious	0	2	0	82	0	2025-04-28 02:12:28.988094+00	2025-04-28 05:54:54.277606+00	2025-04-28 02:12:28.988094+00	2025-04-28 05:54:54.473799+00
t2_12rrca38kt	notPabst404	0	4	0	7	0	2025-04-28 02:12:20.680393+00	2025-04-28 05:56:02.322069+00	2025-04-28 02:12:20.680393+00	2025-04-28 05:56:02.417853+00
t2_rfc2fz55	framedhorseshoe	0	1	0	4	0	2025-04-28 00:16:50.563467+00	2025-04-28 02:41:45.545079+00	2025-04-28 00:16:50.563467+00	2025-04-28 02:41:45.632447+00
t2_p4ll3igpt	RemyOregon	0	1	0	21	0	2025-04-28 00:16:50.546559+00	2025-04-28 02:41:45.501603+00	2025-04-28 00:16:50.546559+00	2025-04-28 02:41:45.582432+00
t2_5p9tk	Meeeps	0	1	0	12	0	2025-04-28 00:16:50.548658+00	2025-04-28 02:41:45.507626+00	2025-04-28 00:16:50.548658+00	2025-04-28 02:41:45.589773+00
t2_qzmwnkvi	Neverdoubt-PDX	0	1	0	6	0	2025-04-28 00:16:50.551875+00	2025-04-28 02:41:45.513783+00	2025-04-28 00:16:50.551875+00	2025-04-28 02:41:45.597284+00
t2_j9q2n4l	PNW-er	0	1	0	6	0	2025-04-28 00:16:50.553937+00	2025-04-28 02:41:45.520374+00	2025-04-28 00:16:50.553937+00	2025-04-28 02:41:45.604597+00
t2_1i9lvril	phbalancedshorty	0	1	0	4	0	2025-04-28 00:16:50.556349+00	2025-04-28 02:41:45.527446+00	2025-04-28 00:16:50.556349+00	2025-04-28 02:41:45.612046+00
t2_3pono	whawkins4	20	0	8224	0	0	2025-04-28 02:12:28.956037+00	2025-04-28 05:54:54.22986+00	2025-04-28 02:12:28.956037+00	2025-04-28 05:56:02.425418+00
t2_c5hvueip8	peterthbest23	0	1	0	3	0	2025-04-28 00:16:50.561316+00	2025-04-28 02:41:45.540504+00	2025-04-28 00:16:50.561316+00	2025-04-28 02:41:45.626379+00
t2_298dqz7p	PreviousMarsupial	0	1	0	3	0	2025-04-28 00:16:50.565488+00	2025-04-28 02:41:45.549193+00	2025-04-28 00:16:50.565488+00	2025-04-28 02:41:45.637287+00
t2_1imaqljvt8	azlwren	0	1	0	2	0	2025-04-28 00:16:50.567524+00	2025-04-28 02:41:45.553023+00	2025-04-28 00:16:50.567524+00	2025-04-28 02:41:45.642526+00
t2_8nddrcpz	siisii93	0	1	0	2	0	2025-04-28 00:16:50.571234+00	2025-04-28 02:41:45.560528+00	2025-04-28 00:16:50.571234+00	2025-04-28 02:41:45.652547+00
t2_14n8tryf56	OhGeezAhHeck	0	1	0	2	0	2025-04-28 00:16:50.573244+00	2025-04-28 02:41:45.564127+00	2025-04-28 00:16:50.573244+00	2025-04-28 02:41:45.657655+00
t2_5hdd3	kshump	0	1	0	37	0	2025-04-28 00:17:11.986916+00	2025-04-28 02:42:08.125949+00	2025-04-28 00:17:11.986916+00	2025-04-28 02:42:08.174399+00
t2_3gvei	Ropes	0	1	0	31	0	2025-04-28 02:13:04.482262+00	2025-04-28 05:21:52.007694+00	2025-04-28 02:13:04.482262+00	2025-04-28 05:21:52.007694+00
t2_139yylgyln	courtpchrist	10	1	180	29	0	2025-04-28 02:12:43.650416+00	2025-04-28 02:42:00.156591+00	2025-04-28 02:12:43.650416+00	2025-04-28 05:56:02.425418+00
t2_feusox64	BeffreyJeffstein	0	2	0	6	0	2025-04-28 02:12:29.044503+00	2025-04-28 05:54:54.302481+00	2025-04-28 02:12:29.044503+00	2025-04-28 05:54:54.503044+00
t2_16a1he	vfittipaldi	0	2	0	11	0	2025-04-28 02:12:28.999393+00	2025-04-28 05:54:54.292696+00	2025-04-28 02:12:28.999393+00	2025-04-28 05:54:54.491478+00
t2_yfo8s	blargblahblahblarg	0	1	0	9	0	2025-04-28 02:13:04.513788+00	2025-04-28 05:21:52.044973+00	2025-04-28 02:13:04.513788+00	2025-04-28 05:21:52.044973+00
t2_j9knq6jk	Icegrill10	0	2	0	8	0	2025-04-28 02:12:29.02361+00	2025-04-28 05:54:54.326353+00	2025-04-28 02:12:29.02361+00	2025-04-28 05:54:54.532233+00
t2_10l4kx	Nature1st	0	2	0	-23	0	2025-04-28 02:12:29.058649+00	2025-04-28 05:54:54.397173+00	2025-04-28 02:12:29.058649+00	2025-04-28 05:54:54.608052+00
t2_1u2lytm2	ladymouserat	0	2	0	13	0	2025-04-28 02:12:29.009651+00	2025-04-28 05:54:54.307077+00	2025-04-28 02:12:29.009651+00	2025-04-28 05:54:54.508922+00
t2_86lq1ly8	No-Bluejay-3035	0	2	0	14	0	2025-04-28 02:12:29.013132+00	2025-04-28 05:54:54.321042+00	2025-04-28 02:12:29.013132+00	2025-04-28 05:54:54.526361+00
t2_sk5k0gea	JtinCascadia	0	2	0	6	0	2025-04-28 02:12:29.020235+00	2025-04-28 05:54:54.332635+00	2025-04-28 02:12:29.020235+00	2025-04-28 05:54:54.538547+00
t2_9qoqcx9c	Flat-Story-7079	0	2	0	4	0	2025-04-28 02:12:29.034078+00	2025-04-28 05:54:54.344817+00	2025-04-28 02:12:29.034078+00	2025-04-28 05:54:54.549842+00
t2_b6nly	bloopybear	0	2	0	4	0	2025-04-28 02:12:29.016733+00	2025-04-28 05:54:54.351007+00	2025-04-28 02:12:29.016733+00	2025-04-28 05:54:54.555345+00
t2_tbob5i1d6	or_iviguy	0	2	0	2	0	2025-04-28 02:12:29.055125+00	2025-04-28 05:54:54.372132+00	2025-04-28 02:12:29.055125+00	2025-04-28 05:54:54.578824+00
t2_1hl028x9iw	onthesylvansea	0	2	0	2	0	2025-04-28 02:12:29.06202+00	2025-04-28 05:54:54.376806+00	2025-04-28 02:12:29.06202+00	2025-04-28 05:54:54.584864+00
t2_7uclp	SwingNinja	0	2	0	4	0	2025-04-28 02:12:29.006425+00	2025-04-28 05:54:54.311339+00	2025-04-28 02:12:29.006425+00	2025-04-28 05:54:54.514658+00
t2_2wl4gshk	MtHoodMikeZ	0	2	0	-3	0	2025-04-28 02:12:29.068846+00	2025-04-28 05:54:54.401758+00	2025-04-28 02:12:29.068846+00	2025-04-28 05:54:54.613781+00
t2_3wk26	traitorous_8	0	2	0	3	0	2025-04-28 02:12:29.037383+00	2025-04-28 05:54:54.381441+00	2025-04-28 02:12:29.037383+00	2025-04-28 05:54:54.590641+00
t2_assnp	Adulations	0	3	0	19	0	2025-04-28 02:12:29.030618+00	2025-04-28 05:55:03.033911+00	2025-04-28 02:12:29.030618+00	2025-04-28 05:55:03.067068+00
t2_7ikzmeht	Baconpanthegathering	0	2	0	1	0	2025-04-28 02:12:29.051655+00	2025-04-28 05:54:54.392575+00	2025-04-28 02:12:29.051655+00	2025-04-28 05:54:54.602341+00
t2_i0g9vgwn4	FriendlyEyeFloater	0	1	0	-17	0	2025-04-28 02:12:29.065395+00	2025-04-28 02:41:37.480151+00	2025-04-28 02:12:29.065395+00	2025-04-28 02:41:37.597321+00
t2_3vpwr	8th_Dynasty	0	2	0	33	0	2025-04-28 02:12:28.99166+00	2025-04-28 05:54:54.267464+00	2025-04-28 02:12:28.99166+00	2025-04-28 05:54:54.462282+00
t2_dlhh6	adelaidepdx	0	1	0	16	0	2025-04-28 02:12:43.720415+00	2025-04-28 02:42:00.1644+00	2025-04-28 02:12:43.720415+00	2025-04-28 02:42:00.261796+00
t2_ozgtd	Penis_Colata	0	3	0	30	0	2025-04-28 02:12:29.002999+00	2025-04-28 05:54:54.288058+00	2025-04-28 02:12:29.002999+00	2025-04-28 05:54:54.485516+00
t2_9iitf4e1	324Cees	0	1	0	31	0	2025-04-28 02:12:43.672617+00	2025-04-28 02:42:00.152076+00	2025-04-28 02:12:43.672617+00	2025-04-28 02:42:00.239527+00
t2_9lx3edga	Euphoric_Berry9728	0	1	0	14	0	2025-04-28 02:12:43.732523+00	2025-04-28 02:42:00.168554+00	2025-04-28 02:12:43.732523+00	2025-04-28 02:42:00.266969+00
t2_fujkijew	TangledWoof99	0	1	0	7	0	2025-04-28 02:12:43.745768+00	2025-04-28 02:42:00.172847+00	2025-04-28 02:12:43.745768+00	2025-04-28 02:42:00.271669+00
t2_baue4jos1	NaturalObvious5264	0	1	0	5	0	2025-04-28 02:12:43.756262+00	2025-04-28 02:42:00.176552+00	2025-04-28 02:12:43.756262+00	2025-04-28 02:42:00.276563+00
t2_7dlgedhz	Hot-Refrigerator-500	0	1	0	3	0	2025-04-28 02:12:43.770008+00	2025-04-28 02:42:00.180263+00	2025-04-28 02:12:43.770008+00	2025-04-28 02:42:00.28131+00
t2_4d3ydwhz	ItIsLiterallyMe	0	1	0	5	0	2025-04-28 02:12:43.781376+00	2025-04-28 02:42:00.184664+00	2025-04-28 02:12:43.781376+00	2025-04-28 02:42:00.286015+00
t2_iuni9l4l	Interesting_Tea_6734	0	1	0	4	0	2025-04-28 02:12:43.79398+00	2025-04-28 02:42:00.188828+00	2025-04-28 02:12:43.79398+00	2025-04-28 02:42:00.290784+00
t2_ni23fp5	Barnaclebills	0	1	0	3	0	2025-04-28 02:12:43.805236+00	2025-04-28 02:42:00.192765+00	2025-04-28 02:12:43.805236+00	2025-04-28 02:42:00.295433+00
t2_j4iu5o1z	Mister_Wednesday_	0	1	0	3	0	2025-04-28 02:12:43.818437+00	2025-04-28 02:42:00.196465+00	2025-04-28 02:12:43.818437+00	2025-04-28 02:42:00.300266+00
t2_2afeak7g	emkayPDX	0	1	0	2	0	2025-04-28 02:12:43.829674+00	2025-04-28 02:42:00.200656+00	2025-04-28 02:12:43.829674+00	2025-04-28 02:42:00.304924+00
t2_fmqln	pingu_thepenguin	0	1	0	2	0	2025-04-28 02:12:43.843167+00	2025-04-28 02:42:00.204676+00	2025-04-28 02:12:43.843167+00	2025-04-28 02:42:00.309895+00
t2_ggyi3	pdxscout	0	1	0	2	0	2025-04-28 02:12:43.84834+00	2025-04-28 02:42:00.208455+00	2025-04-28 02:12:43.84834+00	2025-04-28 02:42:00.314929+00
t2_knk724pv	Substantial-Fun-1	0	1	0	1	0	2025-04-28 02:12:43.852394+00	2025-04-28 02:42:00.211965+00	2025-04-28 02:12:43.852394+00	2025-04-28 02:42:00.319654+00
t2_8bo4nsb3	Accomplished_Pea_118	0	1	0	1	0	2025-04-28 02:12:43.856519+00	2025-04-28 02:42:00.215953+00	2025-04-28 02:12:43.856519+00	2025-04-28 02:42:00.32437+00
t2_5yb1leq5	bluejay1185	0	1	0	1	0	2025-04-28 02:12:43.860696+00	2025-04-28 02:42:00.22007+00	2025-04-28 02:12:43.860696+00	2025-04-28 02:42:00.32928+00
t2_28jh0rmg	letshavearace	0	2	0	4	0	2025-04-28 02:12:29.048175+00	2025-04-28 05:54:54.297642+00	2025-04-28 02:12:29.048175+00	2025-04-28 05:54:54.497174+00
t2_6oj3tnz7	JawnDoe503	0	1	0	16	0	2025-04-28 02:12:43.70208+00	2025-04-28 02:42:00.160692+00	2025-04-28 02:12:43.70208+00	2025-04-28 02:42:00.254189+00
t2_v7kcrnf3	Fit_Description_2911	0	1	0	27	0	2025-04-28 02:13:04.49382+00	2025-04-28 05:21:52.02058+00	2025-04-28 02:13:04.49382+00	2025-04-28 05:21:52.02058+00
t2_16utwzlgzv	terrierdad420	0	1	0	9	0	2025-04-28 02:13:04.510612+00	2025-04-28 05:21:52.032968+00	2025-04-28 02:13:04.510612+00	2025-04-28 05:21:52.032968+00
t2_1hhevxcyyu	money4ponies	0	1	0	6	0	2025-04-28 02:13:04.516853+00	2025-04-28 05:21:52.051316+00	2025-04-28 02:13:04.516853+00	2025-04-28 05:21:52.051316+00
t2_16tftm	oooortclouuud	0	2	0	34	0	2025-04-28 02:13:04.523634+00	2025-04-28 05:55:03.047262+00	2025-04-28 02:13:04.523634+00	2025-04-28 05:55:03.09291+00
t2_jhual	Sheister7789	0	1	0	6	0	2025-04-28 02:13:04.520234+00	2025-04-28 05:21:52.075693+00	2025-04-28 02:13:04.520234+00	2025-04-28 05:21:52.075693+00
t2_6lioxeqa	bettesue	0	1	0	8	0	2025-04-28 02:13:04.535565+00	2025-04-28 05:21:52.099536+00	2025-04-28 02:13:04.535565+00	2025-04-28 05:21:52.099536+00
t2_7su1xp7b	Isurewouldliketo	0	1	0	8	0	2025-04-28 02:13:04.532419+00	2025-04-28 05:21:52.087336+00	2025-04-28 02:13:04.532419+00	2025-04-28 05:21:52.087336+00
t2_dykka9ikx	Ok-Turnip1512	0	1	0	1	0	2025-04-28 02:13:04.545056+00	2025-04-28 05:21:52.105212+00	2025-04-28 02:13:04.545056+00	2025-04-28 05:21:52.105212+00
t2_1iatx7hx	KananDoom	0	1	0	3	0	2025-04-28 02:13:04.542112+00	2025-04-28 05:21:52.11565+00	2025-04-28 02:13:04.542112+00	2025-04-28 05:21:52.11565+00
t2_brqkezgm	RumpelFrogskin	0	1	0	1	0	2025-04-28 02:13:04.551171+00	2025-04-28 05:21:52.119883+00	2025-04-28 02:13:04.551171+00	2025-04-28 05:21:52.119883+00
t2_aljc9jr9	ADrenalinnjunky	0	1	0	2	0	2025-04-28 02:13:04.538931+00	2025-04-28 05:21:52.110808+00	2025-04-28 02:13:04.538931+00	2025-04-28 05:21:52.110808+00
t2_wldkk7ns1	SpezGarblesMyGooch	0	3	0	137	0	2025-04-28 02:13:04.529591+00	2025-04-28 05:55:03.029718+00	2025-04-28 02:13:04.529591+00	2025-04-28 05:55:03.060046+00
t2_3oczi0j1	bimbamshamalam	0	1	0	-1	0	2025-04-28 02:13:04.554307+00	2025-04-28 05:21:52.139958+00	2025-04-28 02:13:04.554307+00	2025-04-28 05:21:52.139958+00
t2_a8n3zjf6	CrystlGivesGoodBrain	0	1	0	1	0	2025-04-28 02:13:04.547869+00	2025-04-28 05:21:52.1484+00	2025-04-28 02:13:04.547869+00	2025-04-28 05:21:52.1484+00
t2_1au5yp5cnh	skysurfguy1213	0	1	0	133	0	2025-04-28 02:13:14.662072+00	2025-04-28 02:42:39.306521+00	2025-04-28 02:13:14.662072+00	2025-04-28 02:42:39.40757+00
t2_1hep3hgxgj	TenThousandFireAnts	0	1	0	91	0	2025-04-28 02:13:04.487846+00	2025-04-28 05:21:52.014035+00	2025-04-28 02:13:04.487846+00	2025-04-28 05:21:52.014035+00
t2_3z4fu	Monkt	0	1	0	11	0	2025-04-28 02:13:14.66594+00	2025-04-28 02:42:39.316573+00	2025-04-28 02:13:14.66594+00	2025-04-28 02:42:39.419881+00
t2_56ncduiz	Apart-Engine	0	1	0	66	0	2025-04-28 02:13:14.668007+00	2025-04-28 02:42:39.321484+00	2025-04-28 02:13:14.668007+00	2025-04-28 02:42:39.425854+00
t2_9tazgiix7	osoberry_cordial	0	1	0	7	0	2025-04-28 02:13:14.670146+00	2025-04-28 02:42:39.326775+00	2025-04-28 02:13:14.670146+00	2025-04-28 02:42:39.432076+00
t2_xfao7	witty_namez	0	1	0	27	0	2025-04-28 02:13:14.671795+00	2025-04-28 02:42:39.331604+00	2025-04-28 02:13:14.671795+00	2025-04-28 02:42:39.438122+00
t2_2unnwhpi	40ozSmasher	0	1	0	23	0	2025-04-28 02:13:14.673899+00	2025-04-28 02:42:39.33636+00	2025-04-28 02:13:14.673899+00	2025-04-28 02:42:39.444159+00
t2_12rbk6eo96	DobbysLeftTubeSock	0	1	0	14	0	2025-04-28 02:13:14.675472+00	2025-04-28 02:42:39.341143+00	2025-04-28 02:13:14.675472+00	2025-04-28 02:42:39.450218+00
t2_nu5e48ou	Grand-Battle8009	0	1	0	5	0	2025-04-28 02:13:14.677121+00	2025-04-28 02:42:39.346131+00	2025-04-28 02:13:14.677121+00	2025-04-28 02:42:39.456209+00
t2_gxgwcndt	FuelAccurate5066	0	1	0	6	0	2025-04-28 02:13:14.678958+00	2025-04-28 02:42:39.350668+00	2025-04-28 02:13:14.678958+00	2025-04-28 02:42:39.462422+00
t2_rn2242km	Critical_Hedgehog_79	0	1	0	8	0	2025-04-28 02:13:14.68081+00	2025-04-28 02:42:39.355475+00	2025-04-28 02:13:14.68081+00	2025-04-28 02:42:39.468615+00
t2_lhtmspsf	Itinerant-Degenerate	0	1	0	6	0	2025-04-28 02:13:14.682737+00	2025-04-28 02:42:39.36055+00	2025-04-28 02:13:14.682737+00	2025-04-28 02:42:39.474713+00
t2_5wx6bt5g	ProfHanley	0	2	0	8	0	2025-04-28 02:12:29.0409+00	2025-04-28 05:54:54.28304+00	2025-04-28 02:12:29.0409+00	2025-04-28 05:54:54.479754+00
t2_19h9qmai3l	6thClass	0	1	0	3	0	2025-04-28 02:13:27.460935+00	2025-04-28 05:21:43.893897+00	2025-04-28 02:13:27.460935+00	2025-04-28 05:21:43.893897+00
t2_sjy5o92	The_salty_swab	0	2	0	3	0	2025-04-28 02:41:29.043614+00	2025-04-28 05:54:45.210964+00	2025-04-28 02:41:29.043614+00	2025-04-28 05:54:45.407767+00
t2_81s6cpaa2	tropoduzzo	0	2	0	2	0	2025-04-28 02:41:37.470693+00	2025-04-28 05:54:54.363038+00	2025-04-28 02:41:37.470693+00	2025-04-28 05:54:54.567154+00
t2_1eur09i1gj	campfirebeer	10	0	5040	0	0	2025-04-28 02:13:27.437625+00	2025-04-28 05:21:43.849154+00	2025-04-28 02:13:27.437625+00	2025-04-28 05:56:02.425418+00
t2_obi8a	EE7A	0	1	0	2	0	2025-04-28 02:13:27.493295+00	2025-04-28 05:21:43.938824+00	2025-04-28 02:13:27.493295+00	2025-04-28 05:21:43.938824+00
t2_4wl6khda	100percenthatwitch	0	1	0	9	0	2025-04-28 02:42:15.962278+00	2025-04-28 02:42:15.962278+00	2025-04-28 02:42:15.962278+00	2025-04-28 02:42:16.000059+00
t2_16mi4pmc6o	WaterChestnut01	0	1	0	1	0	2025-04-28 02:42:15.968933+00	2025-04-28 02:42:15.968933+00	2025-04-28 02:42:15.968933+00	2025-04-28 02:42:16.013065+00
t2_nl8mc332	Secure_Ordinary_7765	0	1	0	10	0	2025-04-28 02:42:47.580499+00	2025-04-28 02:42:47.580499+00	2025-04-28 02:42:47.580499+00	2025-04-28 02:42:47.685242+00
t2_1zlii9oq	pancakesnarfer	0	1	0	1	0	2025-04-28 02:42:29.714183+00	2025-04-28 05:21:52.093383+00	2025-04-28 02:42:29.714183+00	2025-04-28 05:21:52.093383+00
t2_auoe29qa	Chameleon_coin	0	2	0	4	0	2025-04-28 02:13:14.691532+00	2025-04-28 05:21:52.123745+00	2025-04-28 02:13:14.691532+00	2025-04-28 05:21:52.123745+00
t2_1cjph7pzqi	LupusDeiAngelica	0	1	0	1	0	2025-04-28 02:42:29.738933+00	2025-04-28 05:21:52.152429+00	2025-04-28 02:42:29.738933+00	2025-04-28 05:21:52.152429+00
t2_2q1fyhbj	nnanpei	0	1	0	3	0	2025-04-28 02:13:14.695259+00	2025-04-28 02:42:39.384089+00	2025-04-28 02:13:14.695259+00	2025-04-28 02:42:39.505546+00
t2_gzrz0	bigblue2011	0	1	0	2	0	2025-04-28 02:13:14.693334+00	2025-04-28 02:42:39.388909+00	2025-04-28 02:13:14.693334+00	2025-04-28 02:42:39.511832+00
t2_174paq	transplanthater	0	1	0	-2	0	2025-04-28 02:13:14.697317+00	2025-04-28 02:42:39.392658+00	2025-04-28 02:13:14.697317+00	2025-04-28 02:42:39.518302+00
t2_23o6	cafedude	0	2	0	1	0	2025-04-28 02:41:37.468715+00	2025-04-28 05:54:54.406324+00	2025-04-28 02:41:37.468715+00	2025-04-28 05:54:54.61949+00
t2_8y3zcg9r	Give-And-Toke	0	1	0	34	0	2025-04-28 02:42:47.571407+00	2025-04-28 02:42:47.571407+00	2025-04-28 02:42:47.571407+00	2025-04-28 02:42:47.677463+00
t2_u05f4qpy	Shrewdwoodworks	0	1	0	13	0	2025-04-28 02:13:27.443663+00	2025-04-28 05:21:43.864895+00	2025-04-28 02:13:27.443663+00	2025-04-28 05:21:43.864895+00
t2_j7wxco9wh	UrzaKenobi	0	1	0	5	0	2025-04-28 02:13:14.684748+00	2025-04-28 02:42:39.365231+00	2025-04-28 02:13:14.684748+00	2025-04-28 02:42:39.480668+00
t2_3m5gh	Zalenka	0	1	0	5	0	2025-04-28 02:13:14.687225+00	2025-04-28 02:42:39.370015+00	2025-04-28 02:13:14.687225+00	2025-04-28 02:42:39.486683+00
t2_2q9ln	canyoudiggitman	0	1	0	8	0	2025-04-28 02:13:14.689564+00	2025-04-28 02:42:39.374896+00	2025-04-28 02:13:14.689564+00	2025-04-28 02:42:39.493002+00
t2_q6dek0i7e	Ok-Error-574	0	1	0	16	0	2025-04-28 02:42:47.584273+00	2025-04-28 02:42:47.584273+00	2025-04-28 02:42:47.584273+00	2025-04-28 02:42:47.689298+00
t2_9y6q7	pumpkin_pasties	0	1	0	22	0	2025-04-28 02:42:47.587969+00	2025-04-28 02:42:47.587969+00	2025-04-28 02:42:47.587969+00	2025-04-28 02:42:47.693193+00
t2_bk4hwz7y	DougieDouger	0	1	0	11	0	2025-04-28 02:42:47.591907+00	2025-04-28 02:42:47.591907+00	2025-04-28 02:42:47.591907+00	2025-04-28 02:42:47.697074+00
t2_2z6rcciu	therealbento	0	1	0	10	0	2025-04-28 02:42:47.59577+00	2025-04-28 02:42:47.59577+00	2025-04-28 02:42:47.59577+00	2025-04-28 02:42:47.701007+00
t2_9smo0mkf	liberationonly-772	0	1	0	5	0	2025-04-28 02:42:47.5996+00	2025-04-28 02:42:47.5996+00	2025-04-28 02:42:47.5996+00	2025-04-28 02:42:47.704943+00
t2_d45u6	holmquistc	0	2	0	20	0	2025-04-28 02:42:47.576366+00	2025-04-28 02:42:47.609422+00	2025-04-28 02:42:47.576366+00	2025-04-28 02:42:47.717267+00
t2_rm0t3	Atillion	0	1	0	10	0	2025-04-28 02:13:27.446012+00	2025-04-28 05:21:43.869663+00	2025-04-28 02:13:27.446012+00	2025-04-28 05:21:43.869663+00
t2_10e5tmyqfh	falr687	0	1	0	7	0	2025-04-28 02:13:27.448541+00	2025-04-28 05:21:43.874021+00	2025-04-28 02:13:27.448541+00	2025-04-28 05:21:43.874021+00
t2_1cyu41o5xk	MedfordQuestions	0	2	0	16	0	2025-04-28 02:13:27.450908+00	2025-04-28 05:21:43.877908+00	2025-04-28 02:13:27.450908+00	2025-04-28 05:21:43.877908+00
t2_h6zmd9mq2	Direct_Village_5134	0	1	0	3	0	2025-04-28 02:13:35.491483+00	2025-04-28 02:43:10.647654+00	2025-04-28 02:13:35.491483+00	2025-04-28 02:43:10.707538+00
t2_7c59h	paulmania1234	0	1	0	3	0	2025-04-28 02:13:27.45849+00	2025-04-28 05:21:43.886014+00	2025-04-28 02:13:27.45849+00	2025-04-28 05:21:43.886014+00
t2_4rpllxpy	Ichthius	0	1	0	3	0	2025-04-28 02:13:27.455534+00	2025-04-28 05:21:43.890237+00	2025-04-28 02:13:27.455534+00	2025-04-28 05:21:43.890237+00
t2_5qv31m0	bigsampsonite	0	1	0	2	0	2025-04-28 02:13:27.473514+00	2025-04-28 05:21:43.897725+00	2025-04-28 02:13:27.473514+00	2025-04-28 05:21:43.897725+00
t2_574azgzu	Ok_Umpire_8108	0	1	0	3	0	2025-04-28 02:13:27.465604+00	2025-04-28 05:21:43.906281+00	2025-04-28 02:13:27.465604+00	2025-04-28 05:21:43.906281+00
t2_14610q	Caira_Ru	0	1	0	3	0	2025-04-28 02:13:27.468008+00	2025-04-28 05:21:43.909946+00	2025-04-28 02:13:27.468008+00	2025-04-28 05:21:43.909946+00
t2_h7e4xd6a	Mondub_15	0	1	0	3	0	2025-04-28 02:13:27.470554+00	2025-04-28 05:21:43.913539+00	2025-04-28 02:13:27.470554+00	2025-04-28 05:21:43.913539+00
t2_3kdsemee	Green-Inkling	0	1	0	2	0	2025-04-28 02:13:27.476353+00	2025-04-28 05:21:43.917536+00	2025-04-28 02:13:27.476353+00	2025-04-28 05:21:43.917536+00
t2_6f2m2	JtheNinja	0	1	0	3	0	2025-04-28 02:13:27.463262+00	2025-04-28 05:21:43.901923+00	2025-04-28 02:13:27.463262+00	2025-04-28 05:21:43.901923+00
t2_kbj6lu5p	danjoreddit	0	1	0	2	0	2025-04-28 02:13:27.478557+00	2025-04-28 05:21:43.921258+00	2025-04-28 02:13:27.478557+00	2025-04-28 05:21:43.921258+00
t2_e65gg	PenguinPeng1	0	1	0	2	0	2025-04-28 02:13:27.480919+00	2025-04-28 05:21:43.923991+00	2025-04-28 02:13:27.480919+00	2025-04-28 05:21:43.923991+00
t2_22bnbf0s	5ohtree503	0	1	0	2	0	2025-04-28 02:13:27.483193+00	2025-04-28 05:21:43.926366+00	2025-04-28 02:13:27.483193+00	2025-04-28 05:21:43.926366+00
t2_4r6lw8qs	NHLToPDX	0	1	0	2	0	2025-04-28 02:13:27.485621+00	2025-04-28 05:21:43.928749+00	2025-04-28 02:13:27.485621+00	2025-04-28 05:21:43.928749+00
t2_vnt6gv6tn	ChasedWarrior	0	1	0	2	0	2025-04-28 02:13:27.488402+00	2025-04-28 05:21:43.931374+00	2025-04-28 02:13:27.488402+00	2025-04-28 05:21:43.931374+00
t2_1fwtb58odh	Ule24	0	1	0	1	0	2025-04-28 02:13:27.500601+00	2025-04-28 05:21:43.936308+00	2025-04-28 02:13:27.500601+00	2025-04-28 05:21:43.936308+00
t2_5ydov	distraughtmonkey	0	1	0	2	0	2025-04-28 02:13:27.495696+00	2025-04-28 05:21:43.941102+00	2025-04-28 02:13:27.495696+00	2025-04-28 05:21:43.941102+00
t2_eyni6	carolinefelicity	0	1	0	1	0	2025-04-28 02:13:27.508265+00	2025-04-28 05:21:43.943534+00	2025-04-28 02:13:27.508265+00	2025-04-28 05:21:43.943534+00
t2_625wr4al	FlippyChica	0	1	0	1	0	2025-04-28 02:13:27.503315+00	2025-04-28 05:21:43.948571+00	2025-04-28 02:13:27.503315+00	2025-04-28 05:21:43.948571+00
t2_5oadqibk	SeashellChimes	0	1	0	14	0	2025-04-28 02:13:27.440727+00	2025-04-28 05:21:43.858574+00	2025-04-28 02:13:27.440727+00	2025-04-28 05:21:43.858574+00
t2_962gpaone	Pure_Refrigerator111	0	1	0	1	0	2025-04-28 02:13:27.506046+00	2025-04-28 05:21:43.950934+00	2025-04-28 02:13:27.506046+00	2025-04-28 05:21:43.950934+00
t2_9n1dddxn	Reasonable-Profile84	0	1	0	21	0	2025-04-28 02:13:04.526737+00	2025-04-28 05:21:52.057253+00	2025-04-28 02:13:04.526737+00	2025-04-28 05:21:52.057253+00
t2_480v9iw8	fnbannedbymods	0	1	0	1	0	2025-04-28 02:13:27.498152+00	2025-04-28 05:21:43.946078+00	2025-04-28 02:13:27.498152+00	2025-04-28 05:21:43.946078+00
t2_4kgv3um4	normalizeequality0	0	1	0	35	0	2025-04-28 02:13:35.474933+00	2025-04-28 02:43:10.620253+00	2025-04-28 02:13:35.474933+00	2025-04-28 02:43:10.663344+00
t2_3okb3c2m	Tampadarlyn	0	1	0	4	0	2025-04-28 02:13:27.453014+00	2025-04-28 05:21:43.881898+00	2025-04-28 02:13:27.453014+00	2025-04-28 05:21:43.881898+00
t2_d8iitwtm	MsMo999	0	1	0	31	0	2025-04-28 02:13:35.476728+00	2025-04-28 02:43:10.623305+00	2025-04-28 02:13:35.476728+00	2025-04-28 02:43:10.668164+00
t2_5hp1766al	Clear-Frame9108	0	1	0	11	0	2025-04-28 02:13:35.480221+00	2025-04-28 02:43:10.62628+00	2025-04-28 02:13:35.480221+00	2025-04-28 02:43:10.672626+00
t2_e3x3uslyj	Royal-Pen3516	0	1	0	27	0	2025-04-28 02:13:35.478538+00	2025-04-28 02:43:10.629271+00	2025-04-28 02:13:35.478538+00	2025-04-28 02:43:10.67736+00
t2_1eggn1vj	Sisu_pdx	0	1	0	7	0	2025-04-28 02:13:35.482044+00	2025-04-28 02:43:10.633289+00	2025-04-28 02:13:35.482044+00	2025-04-28 02:43:10.682282+00
t2_ho4tlcam	WillametteWanderer	0	1	0	7	0	2025-04-28 02:13:35.484055+00	2025-04-28 02:43:10.636449+00	2025-04-28 02:13:35.484055+00	2025-04-28 02:43:10.686663+00
t2_ykou8	portlandparalegal	0	1	0	5	0	2025-04-28 02:13:35.486043+00	2025-04-28 02:43:10.638971+00	2025-04-28 02:13:35.486043+00	2025-04-28 02:43:10.690689+00
t2_3awfkpbb	nowalkietalkies13	0	1	0	6	0	2025-04-28 02:13:35.488384+00	2025-04-28 02:43:10.64119+00	2025-04-28 02:13:35.488384+00	2025-04-28 02:43:10.695286+00
t2_2zm2paeq	hunter503	0	1	0	2	0	2025-04-28 02:13:35.489947+00	2025-04-28 02:43:10.645344+00	2025-04-28 02:13:35.489947+00	2025-04-28 02:43:10.703323+00
t2_y8g5o	BeebleBoxn	0	1	0	1	0	2025-04-28 02:13:35.498211+00	2025-04-28 02:43:10.649479+00	2025-04-28 02:13:35.498211+00	2025-04-28 02:43:10.712057+00
t2_1jdhdxmqv5	holycow2412	0	1	0	2	0	2025-04-28 02:13:35.494717+00	2025-04-28 02:43:10.651412+00	2025-04-28 02:13:35.494717+00	2025-04-28 02:43:10.716338+00
t2_izwy2t4p	Then-Wealth-1481	0	1	0	-1	0	2025-04-28 02:13:35.496348+00	2025-04-28 02:43:10.65354+00	2025-04-28 02:13:35.496348+00	2025-04-28 02:43:10.720379+00
t2_czf1k	manlymatt83	10	0	160	0	0	2025-04-28 02:42:47.562453+00	2025-04-28 02:42:47.562453+00	2025-04-28 02:42:47.562453+00	2025-04-28 05:56:02.425418+00
t2_s60b6u0	barnesb1974	10	0	2240	0	0	2025-04-28 02:13:35.472901+00	2025-04-28 02:43:10.617097+00	2025-04-28 02:13:35.472901+00	2025-04-28 05:56:02.425418+00
t2_enld9bxz	trilliumbee	0	1	0	4	0	2025-04-28 02:42:47.60322+00	2025-04-28 02:42:47.60322+00	2025-04-28 02:42:47.60322+00	2025-04-28 02:42:47.708875+00
t2_5koa0fh3	Cocoakrispie88	0	1	0	3	0	2025-04-28 02:42:47.606544+00	2025-04-28 02:42:47.606544+00	2025-04-28 02:42:47.606544+00	2025-04-28 02:42:47.713082+00
t2_q4o411y69	McGannahanSkjellyfet	0	1	0	9	0	2025-04-28 02:42:47.61212+00	2025-04-28 02:42:47.61212+00	2025-04-28 02:42:47.61212+00	2025-04-28 02:42:47.721352+00
t2_13s5eo3fak	Nikkibird49	0	1	0	2	0	2025-04-28 02:42:47.614902+00	2025-04-28 02:42:47.614902+00	2025-04-28 02:42:47.614902+00	2025-04-28 02:42:47.725391+00
t2_136jc18f8h	Dry_Sample948	0	1	0	2	0	2025-04-28 02:42:47.617576+00	2025-04-28 02:42:47.617576+00	2025-04-28 02:42:47.617576+00	2025-04-28 02:42:47.729483+00
t2_p84wvxp2k	Least-Bet8439	0	1	0	1	0	2025-04-28 02:42:47.62363+00	2025-04-28 02:42:47.62363+00	2025-04-28 02:42:47.62363+00	2025-04-28 02:42:47.73716+00
t2_gmoryfbh	winkler456	0	1	0	1	0	2025-04-28 02:42:47.626641+00	2025-04-28 02:42:47.626641+00	2025-04-28 02:42:47.626641+00	2025-04-28 02:42:47.74113+00
t2_6xopa	grizzybear	0	1	0	1	0	2025-04-28 02:42:47.62952+00	2025-04-28 02:42:47.62952+00	2025-04-28 02:42:47.62952+00	2025-04-28 02:42:47.74527+00
t2_41euzczp	Agamemnon777	0	1	0	1	0	2025-04-28 02:42:47.631977+00	2025-04-28 02:42:47.631977+00	2025-04-28 02:42:47.631977+00	2025-04-28 02:42:47.749237+00
t2_sdra1f82	Hopeful_Feeling3910	0	1	0	1	0	2025-04-28 02:42:47.634702+00	2025-04-28 02:42:47.634702+00	2025-04-28 02:42:47.634702+00	2025-04-28 02:42:47.753205+00
t2_32vzj	mangorocket	0	1	0	1	0	2025-04-28 02:42:47.637595+00	2025-04-28 02:42:47.637595+00	2025-04-28 02:42:47.637595+00	2025-04-28 02:42:47.756947+00
t2_ugsewebo	glitteringdreamer	0	1	0	1	0	2025-04-28 02:42:47.640382+00	2025-04-28 02:42:47.640382+00	2025-04-28 02:42:47.640382+00	2025-04-28 02:42:47.760836+00
t2_16fznn	fardaw	0	1	0	2	0	2025-04-28 02:42:47.646139+00	2025-04-28 02:42:47.646139+00	2025-04-28 02:42:47.646139+00	2025-04-28 02:42:47.768712+00
t2_1j25slr6	SnorfOfWallStreet	0	1	0	1	0	2025-04-28 02:42:47.648945+00	2025-04-28 02:42:47.648945+00	2025-04-28 02:42:47.648945+00	2025-04-28 02:42:47.772674+00
t2_3nbaas5g	scratpac4774	0	1	0	1	0	2025-04-28 02:42:47.651756+00	2025-04-28 02:42:47.651756+00	2025-04-28 02:42:47.651756+00	2025-04-28 02:42:47.776525+00
t2_nnnwiwhu2	Past-Meet7658	0	1	0	1	0	2025-04-28 02:42:47.654464+00	2025-04-28 02:42:47.654464+00	2025-04-28 02:42:47.654464+00	2025-04-28 02:42:47.780537+00
t2_wyc4v7z2j	Todd_Lasagna	0	1	0	1	0	2025-04-28 02:42:47.657137+00	2025-04-28 02:42:47.657137+00	2025-04-28 02:42:47.657137+00	2025-04-28 02:42:47.78447+00
t2_4v4srbbu	arcticpandand	0	1	0	-2	0	2025-04-28 02:42:47.659758+00	2025-04-28 02:42:47.659758+00	2025-04-28 02:42:47.659758+00	2025-04-28 02:42:47.788225+00
t2_9dd4jovw	NutSockMushroom	0	2	0	2	0	2025-04-28 02:44:15.453256+00	2025-04-28 05:54:45.229919+00	2025-04-28 02:44:15.453256+00	2025-04-28 05:54:45.444572+00
t2_3oz4pn1m	Rhianna83	0	1	0	1	0	2025-04-28 02:43:18.47779+00	2025-04-28 02:43:18.47779+00	2025-04-28 02:43:18.47779+00	2025-04-28 02:43:18.523489+00
t2_vojxvwgu	PossibleJazzlike2804	0	1	0	1	0	2025-04-28 02:43:18.484012+00	2025-04-28 02:43:18.484012+00	2025-04-28 02:43:18.484012+00	2025-04-28 02:43:18.531311+00
t2_1d9zp38yqd	DappleFrog25	0	1	0	1	0	2025-04-28 02:43:18.490184+00	2025-04-28 02:43:18.490184+00	2025-04-28 02:43:18.490184+00	2025-04-28 02:43:18.539014+00
t2_vhswh5gz	Necessary-Sock7075	0	1	0	1	0	2025-04-28 02:43:18.496148+00	2025-04-28 02:43:18.496148+00	2025-04-28 02:43:18.496148+00	2025-04-28 02:43:18.544899+00
t2_1k9jiou51k	lapponian_dynamite	0	1	0	1	0	2025-04-28 02:43:18.501845+00	2025-04-28 02:43:18.501845+00	2025-04-28 02:43:18.501845+00	2025-04-28 02:43:18.5506+00
t2_1cxhl4zg91	StrWtchng	10	0	180	0	0	2025-04-28 02:43:53.193872+00	2025-04-28 05:20:40.306544+00	2025-04-28 02:43:53.193872+00	2025-04-28 05:56:02.425418+00
t2_5o3jcmtx	allthekeals	10	0	130	0	0	2025-04-28 02:44:01.063239+00	2025-04-28 02:44:01.063239+00	2025-04-28 02:44:01.063239+00	2025-04-28 05:56:02.425418+00
t2_j5o2ghyz	lookeyloowho	0	1	0	1	0	2025-04-28 02:42:47.643188+00	2025-04-28 05:18:05.067195+00	2025-04-28 02:42:47.643188+00	2025-04-28 05:18:05.067195+00
t2_8x9p5kwj	Soft_Increase	10	0	2840	0	0	2025-04-28 00:16:50.544391+00	2025-04-28 02:41:45.494168+00	2025-04-28 00:16:50.544391+00	2025-04-28 05:56:02.425418+00
t2_98z4tdz2	Egotraoped	10	0	1630	0	0	2025-04-28 02:43:18.471496+00	2025-04-28 02:43:18.471496+00	2025-04-28 02:43:18.471496+00	2025-04-28 05:56:02.425418+00
t2_dsrl8x15s	Mydogisbestdoggy	10	0	150	0	0	2025-04-28 02:42:15.954206+00	2025-04-28 02:42:15.954206+00	2025-04-28 02:42:15.954206+00	2025-04-28 05:56:02.425418+00
t2_a1t2ob4u	UnkleClarke	0	1	0	6	0	2025-04-28 02:43:30.909026+00	2025-04-28 05:18:12.782835+00	2025-04-28 02:43:30.909026+00	2025-04-28 05:18:12.782835+00
t2_hj51s	Atticus248	10	0	390	0	0	2025-04-28 02:43:30.907061+00	2025-04-28 05:18:12.773487+00	2025-04-28 02:43:30.907061+00	2025-04-28 05:56:02.425418+00
t2_hoevugmjw	SkylieBunnyGirl	10	0	170	0	0	2025-04-28 00:17:11.983148+00	2025-04-28 02:42:08.118369+00	2025-04-28 00:17:11.983148+00	2025-04-28 05:56:02.425418+00
t2_mdbsacda9	trashnoland	10	0	450	0	0	2025-04-28 02:44:15.42784+00	2025-04-28 05:16:50.220677+00	2025-04-28 02:44:15.42784+00	2025-04-28 05:56:02.425418+00
t2_ojggvv2u	Confident_Bee_2705	10	0	840	0	0	2025-04-28 02:13:14.659903+00	2025-04-28 02:42:39.300096+00	2025-04-28 02:13:14.659903+00	2025-04-28 05:56:02.425418+00
t2_j4y6r	nateted4	0	1	0	8	0	2025-04-28 02:44:15.434534+00	2025-04-28 05:16:50.231717+00	2025-04-28 02:44:15.434534+00	2025-04-28 05:16:50.231717+00
t2_vmzkuj0ox	Key_Matter9004	9	0	207	0	0	2025-04-28 00:17:04.077167+00	2025-04-28 00:17:04.077167+00	2025-04-28 00:17:04.077167+00	2025-04-28 05:56:02.425418+00
t2_xvn13ics1	SnailGuardianArt	10	0	290	0	0	2025-04-28 02:43:45.422276+00	2025-04-28 05:16:58.022979+00	2025-04-28 02:43:45.422276+00	2025-04-28 05:56:02.425418+00
t2_moa11ba	shiftymcgrill_1	0	1	0	4	0	2025-04-28 02:44:15.4408+00	2025-04-28 05:16:50.238845+00	2025-04-28 02:44:15.4408+00	2025-04-28 05:16:50.238845+00
t2_10r1m5zyvg	Routine_Guitar_5519	0	1	0	3	0	2025-04-28 02:44:15.44692+00	2025-04-28 05:16:50.246092+00	2025-04-28 02:44:15.44692+00	2025-04-28 05:16:50.246092+00
t2_2sd46a7f	TheMalPal	0	1	0	2	0	2025-04-28 02:43:45.428088+00	2025-04-28 05:16:58.032074+00	2025-04-28 02:43:45.428088+00	2025-04-28 05:16:58.032074+00
t2_1cedjtr4	PuzzleHeaded424	0	0	0	0	0	2025-04-28 05:17:05.754205+00	2025-04-28 05:17:05.754205+00	2025-04-28 05:17:05.754205+00	2025-04-28 05:17:05.754205+00
t2_fhj895we9	Remote-Wonder9577	0	0	0	0	0	2025-04-28 05:17:13.535755+00	2025-04-28 05:17:13.535755+00	2025-04-28 05:17:13.535755+00	2025-04-28 05:17:13.535755+00
t2_2gu3feye	Butterman5k	0	0	0	0	0	2025-04-28 05:17:23.356178+00	2025-04-28 05:17:23.356178+00	2025-04-28 05:17:23.356178+00	2025-04-28 05:17:23.356178+00
t2_gq12z	pdxapibot	0	0	0	0	0	2025-04-28 05:17:31.065845+00	2025-04-28 05:17:31.065845+00	2025-04-28 05:17:31.065845+00	2025-04-28 05:17:31.065845+00
t2_7hkal36p	wwespider	0	0	0	0	0	2025-04-28 05:17:38.740917+00	2025-04-28 05:17:38.740917+00	2025-04-28 05:17:38.740917+00	2025-04-28 05:17:38.740917+00
t2_15lcxr7o0a	do_not_troll	0	0	0	0	0	2025-04-28 05:17:46.556088+00	2025-04-28 05:17:46.556088+00	2025-04-28 05:17:46.556088+00	2025-04-28 05:17:46.556088+00
t2_tzmf1ya	dolphs4	0	0	0	0	0	2025-04-28 05:17:46.564543+00	2025-04-28 05:17:46.564543+00	2025-04-28 05:17:46.564543+00	2025-04-28 05:17:46.564543+00
t2_gadny	supersavant	0	0	0	0	0	2025-04-28 05:17:46.57118+00	2025-04-28 05:17:46.57118+00	2025-04-28 05:17:46.57118+00	2025-04-28 05:17:46.57118+00
t2_gpgm56ihs	andhausen	0	0	0	0	0	2025-04-28 05:17:46.577406+00	2025-04-28 05:17:46.577406+00	2025-04-28 05:17:46.577406+00	2025-04-28 05:17:46.577406+00
t2_4x430	chrislehr	0	0	0	0	0	2025-04-28 05:17:46.583722+00	2025-04-28 05:17:46.583722+00	2025-04-28 05:17:46.583722+00	2025-04-28 05:17:46.583722+00
t2_2uteub7m	Wafer_Friendly	0	0	0	0	0	2025-04-28 05:17:46.589719+00	2025-04-28 05:17:46.589719+00	2025-04-28 05:17:46.589719+00	2025-04-28 05:17:46.589719+00
t2_f96pxpulc	anon36485	0	0	0	0	0	2025-04-28 05:17:46.596553+00	2025-04-28 05:17:46.596553+00	2025-04-28 05:17:46.596553+00	2025-04-28 05:17:46.596553+00
t2_11xjyz	pdxlxxix	0	0	0	0	0	2025-04-28 05:17:46.603531+00	2025-04-28 05:17:46.603531+00	2025-04-28 05:17:46.603531+00	2025-04-28 05:17:46.603531+00
t2_5xjao9gw	Fragrant_Ideal_6001	0	0	0	0	0	2025-04-28 05:17:46.609468+00	2025-04-28 05:17:46.609468+00	2025-04-28 05:17:46.609468+00	2025-04-28 05:17:46.609468+00
t2_cqgk032b	Moof_the_cyclist	0	0	0	0	0	2025-04-28 05:17:46.61495+00	2025-04-28 05:17:46.61495+00	2025-04-28 05:17:46.61495+00	2025-04-28 05:17:46.61495+00
t2_pn4y5nh7	DogsGoingAround	0	0	0	0	0	2025-04-28 05:17:46.619085+00	2025-04-28 05:17:46.619085+00	2025-04-28 05:17:46.619085+00	2025-04-28 05:17:46.619085+00
t2_2zcg6fjp	ironyisdeadish	0	0	0	0	0	2025-04-28 05:17:46.623252+00	2025-04-28 05:17:46.623252+00	2025-04-28 05:17:46.623252+00	2025-04-28 05:17:46.623252+00
t2_jzpt7r5a	amidwesternpotato	0	0	0	0	0	2025-04-28 05:17:56.763463+00	2025-04-28 05:17:56.763463+00	2025-04-28 05:17:56.763463+00	2025-04-28 05:17:56.763463+00
t2_tqooarz0	Quirky_Ball_3519	0	0	0	0	0	2025-04-28 05:17:56.771891+00	2025-04-28 05:17:56.771891+00	2025-04-28 05:17:56.771891+00	2025-04-28 05:17:56.771891+00
t2_h8a75dqn	callmeapoetandudie	0	0	0	0	0	2025-04-28 05:17:56.77825+00	2025-04-28 05:17:56.77825+00	2025-04-28 05:17:56.77825+00	2025-04-28 05:17:56.77825+00
t2_iuuiehqv	thedudeabides2022	0	0	0	0	0	2025-04-28 05:17:56.784776+00	2025-04-28 05:17:56.784776+00	2025-04-28 05:17:56.784776+00	2025-04-28 05:17:56.784776+00
t2_lliuizrf	MsBenovanStanchiano	0	0	0	0	0	2025-04-28 05:17:56.79101+00	2025-04-28 05:17:56.79101+00	2025-04-28 05:17:56.79101+00	2025-04-28 05:17:56.79101+00
t2_bex1dy9d	RetrauxClem	0	0	0	0	0	2025-04-28 05:17:56.797099+00	2025-04-28 05:17:56.797099+00	2025-04-28 05:17:56.797099+00	2025-04-28 05:17:56.797099+00
t2_1t3l97px	dingleberries54	0	0	0	0	0	2025-04-28 05:17:56.801907+00	2025-04-28 05:17:56.801907+00	2025-04-28 05:17:56.801907+00	2025-04-28 05:17:56.801907+00
t2_qg3dj	Se7enCostanza10	0	0	0	0	0	2025-04-28 05:17:56.805368+00	2025-04-28 05:17:56.805368+00	2025-04-28 05:17:56.805368+00	2025-04-28 05:17:56.805368+00
t2_3uf9gh3h	xZOMBIETAGx	0	0	0	0	0	2025-04-28 05:17:56.808481+00	2025-04-28 05:17:56.808481+00	2025-04-28 05:17:56.808481+00	2025-04-28 05:17:56.808481+00
t2_23u828ju	lizzyleigh	0	0	0	0	0	2025-04-28 05:17:56.811584+00	2025-04-28 05:17:56.811584+00	2025-04-28 05:17:56.811584+00	2025-04-28 05:17:56.811584+00
t2_scm6l	peterpeterllini	0	0	0	0	0	2025-04-28 05:17:56.814798+00	2025-04-28 05:17:56.814798+00	2025-04-28 05:17:56.814798+00	2025-04-28 05:17:56.814798+00
t2_7ppdkegv	aaron__valve	0	0	0	0	0	2025-04-28 05:17:56.818006+00	2025-04-28 05:17:56.818006+00	2025-04-28 05:17:56.818006+00	2025-04-28 05:17:56.818006+00
t2_j6wp4	justafuckingpear	0	0	0	0	0	2025-04-28 05:17:56.821161+00	2025-04-28 05:17:56.821161+00	2025-04-28 05:17:56.821161+00	2025-04-28 05:17:56.821161+00
t2_u8rhmz8y	ojiret	0	0	0	0	0	2025-04-28 05:17:56.824115+00	2025-04-28 05:17:56.824115+00	2025-04-28 05:17:56.824115+00	2025-04-28 05:17:56.824115+00
t2_bt6pt62e	Boring_Park1178	0	0	0	0	0	2025-04-28 05:17:56.827121+00	2025-04-28 05:17:56.827121+00	2025-04-28 05:17:56.827121+00	2025-04-28 05:17:56.827121+00
t2_a4ibgu39	Historical_Life9410	0	0	0	0	0	2025-04-28 05:17:56.830216+00	2025-04-28 05:17:56.830216+00	2025-04-28 05:17:56.830216+00	2025-04-28 05:17:56.830216+00
t2_9a53n	somewherein72	0	0	0	0	0	2025-04-28 05:17:56.833458+00	2025-04-28 05:17:56.833458+00	2025-04-28 05:17:56.833458+00	2025-04-28 05:17:56.833458+00
t2_8eg58l2jx	whatdoesitallmean_21	0	0	0	0	0	2025-04-28 05:17:56.836285+00	2025-04-28 05:17:56.836285+00	2025-04-28 05:17:56.836285+00	2025-04-28 05:17:56.836285+00
t2_sl98j4ge	Specialist_Chef3070	0	0	0	0	0	2025-04-28 05:17:56.839696+00	2025-04-28 05:17:56.839696+00	2025-04-28 05:17:56.839696+00	2025-04-28 05:17:56.839696+00
t2_6b3q709v	EmploymentCapital806	0	0	0	0	0	2025-04-28 05:17:56.84266+00	2025-04-28 05:17:56.84266+00	2025-04-28 05:17:56.84266+00	2025-04-28 05:17:56.84266+00
t2_z6pwmjxvx	JDanzy	0	0	0	0	0	2025-04-28 05:17:56.845614+00	2025-04-28 05:17:56.845614+00	2025-04-28 05:17:56.845614+00	2025-04-28 05:17:56.845614+00
t2_ensi10ww	Educational_Tour_273	0	0	0	0	0	2025-04-28 05:18:05.000516+00	2025-04-28 05:18:05.000516+00	2025-04-28 05:18:05.000516+00	2025-04-28 05:18:05.000516+00
t2_imc9gzwp8	CruisinRightBayou	0	0	0	0	0	2025-04-28 05:18:05.002945+00	2025-04-28 05:18:05.002945+00	2025-04-28 05:18:05.002945+00	2025-04-28 05:18:05.002945+00
t2_u4z70a7p	greycatdaddy	0	0	0	0	0	2025-04-28 05:18:05.004941+00	2025-04-28 05:18:05.004941+00	2025-04-28 05:18:05.004941+00	2025-04-28 05:18:05.004941+00
t2_2zkkxkxl	parkerwilder1	0	0	0	0	0	2025-04-28 05:18:05.00683+00	2025-04-28 05:18:05.00683+00	2025-04-28 05:18:05.00683+00	2025-04-28 05:18:05.00683+00
t2_4qhb9	occamsracer	0	0	0	0	0	2025-04-28 05:18:05.008338+00	2025-04-28 05:18:05.008338+00	2025-04-28 05:18:05.008338+00	2025-04-28 05:18:05.008338+00
t2_a22mc26q	c2h5oh_yes	0	0	0	0	0	2025-04-28 05:18:05.010185+00	2025-04-28 05:18:05.010185+00	2025-04-28 05:18:05.010185+00	2025-04-28 05:18:05.010185+00
t2_73gs8	spblat	0	0	0	0	0	2025-04-28 05:18:05.01178+00	2025-04-28 05:18:05.01178+00	2025-04-28 05:18:05.01178+00	2025-04-28 05:18:05.01178+00
t2_b8bduehx	KindaKrayz222	0	0	0	0	0	2025-04-28 05:18:05.013282+00	2025-04-28 05:18:05.013282+00	2025-04-28 05:18:05.013282+00	2025-04-28 05:18:05.013282+00
t2_jv2rcoip	SoManyQuestions5200	0	0	0	0	0	2025-04-28 05:18:05.01482+00	2025-04-28 05:18:05.01482+00	2025-04-28 05:18:05.01482+00	2025-04-28 05:18:05.01482+00
t2_1gsly2dh7j	vfam51	0	0	0	0	0	2025-04-28 05:18:05.016669+00	2025-04-28 05:18:05.016669+00	2025-04-28 05:18:05.016669+00	2025-04-28 05:18:05.016669+00
t2_t8pnwgtg	runningwithsticks	0	0	0	0	0	2025-04-28 05:18:05.01897+00	2025-04-28 05:18:05.01897+00	2025-04-28 05:18:05.01897+00	2025-04-28 05:18:05.01897+00
t2_1hrmt2fng6	Coureur_des_bruh	0	0	0	0	0	2025-04-28 05:18:05.021104+00	2025-04-28 05:18:05.021104+00	2025-04-28 05:18:05.021104+00	2025-04-28 05:18:05.021104+00
t2_ij9ycd25o	timewithbrad	0	0	0	0	0	2025-04-28 05:18:05.023062+00	2025-04-28 05:18:05.023062+00	2025-04-28 05:18:05.023062+00	2025-04-28 05:18:05.023062+00
t2_axegnwwf	joeitaliano24	0	0	0	0	0	2025-04-28 05:18:05.024855+00	2025-04-28 05:18:05.024855+00	2025-04-28 05:18:05.024855+00	2025-04-28 05:18:05.024855+00
t2_1d6poezm63	TheStranger24	0	0	0	0	0	2025-04-28 05:18:05.026683+00	2025-04-28 05:18:05.026683+00	2025-04-28 05:18:05.026683+00	2025-04-28 05:18:05.026683+00
t2_rgc78hqga	SilverNo9424	0	0	0	0	0	2025-04-28 05:18:05.02867+00	2025-04-28 05:18:05.02867+00	2025-04-28 05:18:05.02867+00	2025-04-28 05:18:05.02867+00
t2_4zgu4	awesomecubed	0	0	0	0	0	2025-04-28 05:18:05.030729+00	2025-04-28 05:18:05.030729+00	2025-04-28 05:18:05.030729+00	2025-04-28 05:18:05.030729+00
t2_eioauaq0w	FartGPT	0	0	0	0	0	2025-04-28 05:18:05.032868+00	2025-04-28 05:18:05.032868+00	2025-04-28 05:18:05.032868+00	2025-04-28 05:18:05.032868+00
t2_1bxzc1ctak	thenextolympics	0	0	0	0	0	2025-04-28 05:18:05.037525+00	2025-04-28 05:18:05.037525+00	2025-04-28 05:18:05.037525+00	2025-04-28 05:18:05.037525+00
t2_p8y1k98	squidparkour	0	0	0	0	0	2025-04-28 05:18:05.039527+00	2025-04-28 05:18:05.039527+00	2025-04-28 05:18:05.039527+00	2025-04-28 05:18:05.039527+00
t2_jpag6u6d	KurtStation68	0	0	0	0	0	2025-04-28 05:18:05.04134+00	2025-04-28 05:18:05.04134+00	2025-04-28 05:18:05.04134+00	2025-04-28 05:18:05.04134+00
t2_554732sb	shonkle	0	0	0	0	0	2025-04-28 05:18:05.043236+00	2025-04-28 05:18:05.043236+00	2025-04-28 05:18:05.043236+00	2025-04-28 05:18:05.043236+00
t2_2qiiofw8	dgeniesse	0	0	0	0	0	2025-04-28 05:18:05.045541+00	2025-04-28 05:18:05.045541+00	2025-04-28 05:18:05.045541+00	2025-04-28 05:18:05.045541+00
t2_czv9fm0s	Valuable-Army-1914	0	0	0	0	0	2025-04-28 05:18:05.047692+00	2025-04-28 05:18:05.047692+00	2025-04-28 05:18:05.047692+00	2025-04-28 05:18:05.047692+00
t2_gb2q3u9ta	GrumpyBear1969	0	0	0	0	0	2025-04-28 05:18:05.04968+00	2025-04-28 05:18:05.04968+00	2025-04-28 05:18:05.04968+00	2025-04-28 05:18:05.04968+00
t2_9gkgkw54	Jealous_Journalist_9	0	0	0	0	0	2025-04-28 05:18:05.051623+00	2025-04-28 05:18:05.051623+00	2025-04-28 05:18:05.051623+00	2025-04-28 05:18:05.051623+00
t2_8ixh3gkl	zoobaking	0	0	0	0	0	2025-04-28 05:18:05.053336+00	2025-04-28 05:18:05.053336+00	2025-04-28 05:18:05.053336+00	2025-04-28 05:18:05.053336+00
t2_4ltemhh4	Strong-Experience504	0	0	0	0	0	2025-04-28 05:18:05.055226+00	2025-04-28 05:18:05.055226+00	2025-04-28 05:18:05.055226+00	2025-04-28 05:18:05.055226+00
t2_2i54sznn	PeteDontCare	0	0	0	0	0	2025-04-28 05:18:05.057528+00	2025-04-28 05:18:05.057528+00	2025-04-28 05:18:05.057528+00	2025-04-28 05:18:05.057528+00
t2_9cpvrjjm	MisterSandKing	0	0	0	0	0	2025-04-28 05:18:05.059629+00	2025-04-28 05:18:05.059629+00	2025-04-28 05:18:05.059629+00	2025-04-28 05:18:05.059629+00
t2_1409b5na69	Current-Section-3429	0	0	0	0	0	2025-04-28 05:18:05.06145+00	2025-04-28 05:18:05.06145+00	2025-04-28 05:18:05.06145+00	2025-04-28 05:18:05.06145+00
t2_1i8sftq491	Excellent_Gap_428	0	0	0	0	0	2025-04-28 05:18:05.063358+00	2025-04-28 05:18:05.063358+00	2025-04-28 05:18:05.063358+00	2025-04-28 05:18:05.063358+00
t2_3y1wd	wordgirl	0	0	0	0	0	2025-04-28 05:18:05.065235+00	2025-04-28 05:18:05.065235+00	2025-04-28 05:18:05.065235+00	2025-04-28 05:18:05.065235+00
t2_98xyo	Picklopolis	0	0	0	0	0	2025-04-28 05:18:05.069139+00	2025-04-28 05:18:05.069139+00	2025-04-28 05:18:05.069139+00	2025-04-28 05:18:05.069139+00
t2_9ols0	MistaPink	0	0	0	0	0	2025-04-28 05:18:05.071031+00	2025-04-28 05:18:05.071031+00	2025-04-28 05:18:05.071031+00	2025-04-28 05:18:05.071031+00
t2_68zd5bcc	MauveUluss	0	0	0	0	0	2025-04-28 05:18:05.072807+00	2025-04-28 05:18:05.072807+00	2025-04-28 05:18:05.072807+00	2025-04-28 05:18:05.072807+00
t2_2uel0qtk	bestinthenorthwest	0	0	0	0	0	2025-04-28 05:18:25.767031+00	2025-04-28 05:18:25.767031+00	2025-04-28 05:18:25.767031+00	2025-04-28 05:18:25.767031+00
t2_5dmr1jqa	toomanywhiskey	0	0	0	0	0	2025-04-28 05:18:25.770096+00	2025-04-28 05:18:25.770096+00	2025-04-28 05:18:25.770096+00	2025-04-28 05:18:25.770096+00
t2_1hsddobsrh	EvolutionarySkip	0	0	0	0	0	2025-04-28 05:18:33.52435+00	2025-04-28 05:18:33.52435+00	2025-04-28 05:18:33.52435+00	2025-04-28 05:18:33.52435+00
t2_klu5l	N0tAnExp3rt	0	0	0	0	0	2025-04-28 05:18:33.52736+00	2025-04-28 05:18:33.52736+00	2025-04-28 05:18:33.52736+00	2025-04-28 05:18:33.52736+00
t2_1e32854w62	dontlooknow677	0	0	0	0	0	2025-04-28 05:18:41.126611+00	2025-04-28 05:18:41.126611+00	2025-04-28 05:18:41.126611+00	2025-04-28 05:18:41.126611+00
t2_17ahapj02o	Unfair-External-7561	0	0	0	0	0	2025-04-28 05:18:48.918606+00	2025-04-28 05:18:48.918606+00	2025-04-28 05:18:48.918606+00	2025-04-28 05:18:48.918606+00
t2_6spqg	goatsahoy	0	0	0	0	0	2025-04-28 05:18:48.928301+00	2025-04-28 05:18:48.928301+00	2025-04-28 05:18:48.928301+00	2025-04-28 05:18:48.928301+00
t2_hg1i95fsw	Zombie_Apostate	0	0	0	0	0	2025-04-28 05:18:48.935808+00	2025-04-28 05:18:48.935808+00	2025-04-28 05:18:48.935808+00	2025-04-28 05:18:48.935808+00
t2_2iroygxp	it_snow_problem	0	0	0	0	0	2025-04-28 05:19:03.59693+00	2025-04-28 05:19:03.59693+00	2025-04-28 05:19:03.59693+00	2025-04-28 05:19:03.59693+00
t2_6jwrnget	1stAgeTuvo	0	0	0	0	0	2025-04-28 05:19:11.312161+00	2025-04-28 05:19:11.312161+00	2025-04-28 05:19:11.312161+00	2025-04-28 05:19:11.312161+00
t2_djubt88r	ArtemasTheProvincial	0	0	0	0	0	2025-04-28 05:19:19.08573+00	2025-04-28 05:19:19.08573+00	2025-04-28 05:19:19.08573+00	2025-04-28 05:19:19.08573+00
t2_sfuda23p	giantSUNflowers	0	0	0	0	0	2025-04-28 05:19:29.007591+00	2025-04-28 05:19:29.007591+00	2025-04-28 05:19:29.007591+00	2025-04-28 05:19:29.007591+00
t2_9dztg1w	pinkpizzapie	0	0	0	0	0	2025-04-28 05:19:36.755653+00	2025-04-28 05:19:36.755653+00	2025-04-28 05:19:36.755653+00	2025-04-28 05:19:36.755653+00
t2_4ffh4td6	Bitter-Lengthiness-2	0	0	0	0	0	2025-04-28 05:19:52.350555+00	2025-04-28 05:19:52.350555+00	2025-04-28 05:19:52.350555+00	2025-04-28 05:19:52.350555+00
t2_a2yw91qu	buttnuggs4269	0	0	0	0	0	2025-04-28 05:19:52.35864+00	2025-04-28 05:19:52.35864+00	2025-04-28 05:19:52.35864+00	2025-04-28 05:19:52.35864+00
t2_ratv7kr	DefinitelyMaybeBeige	0	0	0	0	0	2025-04-28 05:20:02.282545+00	2025-04-28 05:20:02.282545+00	2025-04-28 05:20:02.282545+00	2025-04-28 05:20:02.282545+00
t2_9z37f8oj	BSN_tg_bgg	0	0	0	0	0	2025-04-28 05:20:02.291795+00	2025-04-28 05:20:02.291795+00	2025-04-28 05:20:02.291795+00	2025-04-28 05:20:02.291795+00
t2_6oir0r5x	theheidaway	0	0	0	0	0	2025-04-28 05:20:10.132615+00	2025-04-28 05:20:10.132615+00	2025-04-28 05:20:10.132615+00	2025-04-28 05:20:10.132615+00
t2_wifqo	Littlebotweak	0	0	0	0	0	2025-04-28 05:20:10.140318+00	2025-04-28 05:20:10.140318+00	2025-04-28 05:20:10.140318+00	2025-04-28 05:20:10.140318+00
t2_5w3ieg7q	lizvan82	0	0	0	0	0	2025-04-28 05:20:10.145777+00	2025-04-28 05:20:10.145777+00	2025-04-28 05:20:10.145777+00	2025-04-28 05:20:10.145777+00
t2_19mljmja69	cosmosanddaisies	0	0	0	0	0	2025-04-28 05:20:10.151359+00	2025-04-28 05:20:10.151359+00	2025-04-28 05:20:10.151359+00	2025-04-28 05:20:10.151359+00
t2_6cmlezrd	zsabb	0	0	0	0	0	2025-04-28 05:20:22.605087+00	2025-04-28 05:20:22.605087+00	2025-04-28 05:20:22.605087+00	2025-04-28 05:20:22.605087+00
t2_4mun4	gemsong	0	0	0	0	0	2025-04-28 05:20:32.515519+00	2025-04-28 05:20:32.515519+00	2025-04-28 05:20:32.515519+00	2025-04-28 05:20:32.515519+00
t2_jr24t48bu	Slight_Canary737	0	0	0	0	0	2025-04-28 05:19:44.579891+00	2025-04-28 05:20:47.957257+00	2025-04-28 05:19:44.579891+00	2025-04-28 05:20:47.957257+00
t2_kpa6e	ABreckenridge	0	0	0	0	0	2025-04-28 05:20:55.745839+00	2025-04-28 05:20:55.745839+00	2025-04-28 05:20:55.745839+00	2025-04-28 05:20:55.745839+00
t2_1azs0amu6o	Gray_OSPIRG	0	0	0	0	0	2025-04-28 05:21:05.629+00	2025-04-28 05:21:05.629+00	2025-04-28 05:21:05.629+00	2025-04-28 05:21:05.629+00
t2_9xw1ujtd	International-Suit21	0	0	0	0	0	2025-04-28 05:21:13.467309+00	2025-04-28 05:21:13.467309+00	2025-04-28 05:21:13.467309+00	2025-04-28 05:21:13.467309+00
t2_4z5yam44	Mythic-Rare	0	0	0	0	0	2025-04-28 05:21:13.475398+00	2025-04-28 05:21:13.475398+00	2025-04-28 05:21:13.475398+00	2025-04-28 05:21:13.475398+00
t2_39nimwwy	QubeTubePDX	0	0	0	0	0	2025-04-28 05:21:26.074526+00	2025-04-28 05:21:26.074526+00	2025-04-28 05:21:26.074526+00	2025-04-28 05:21:26.074526+00
t2_74hgi	ryanbrownstar	0	0	0	0	0	2025-04-28 05:21:26.080283+00	2025-04-28 05:21:26.080283+00	2025-04-28 05:21:26.080283+00	2025-04-28 05:21:26.080283+00
t2_5npr7	goldenrule117	0	0	0	0	0	2025-04-28 05:21:35.852726+00	2025-04-28 05:21:35.860986+00	2025-04-28 05:21:35.852726+00	2025-04-28 05:21:35.860986+00
t2_6bldk8uk	chickenladydee	0	0	0	0	0	2025-04-28 05:21:43.95339+00	2025-04-28 05:21:43.95339+00	2025-04-28 05:21:43.95339+00	2025-04-28 05:21:43.95339+00
t2_76uz4	badcrass	0	0	0	0	0	2025-04-28 05:21:52.069727+00	2025-04-28 05:21:52.069727+00	2025-04-28 05:21:52.069727+00	2025-04-28 05:21:52.069727+00
t2_frddr	StopItWithThis	0	0	0	0	0	2025-04-28 05:21:52.127933+00	2025-04-28 05:21:52.127933+00	2025-04-28 05:21:52.127933+00	2025-04-28 05:21:52.127933+00
t2_1l54t954u1	Toroid_Taurus	0	0	0	0	0	2025-04-28 05:21:52.131999+00	2025-04-28 05:21:52.131999+00	2025-04-28 05:21:52.131999+00	2025-04-28 05:21:52.131999+00
t2_96kd78cy	timute	0	0	0	0	0	2025-04-28 05:21:52.136166+00	2025-04-28 05:21:52.136166+00	2025-04-28 05:21:52.136166+00	2025-04-28 05:21:52.136166+00
t2_hoibxirm	No-Preference-8357	0	0	0	0	0	2025-04-28 05:21:52.144112+00	2025-04-28 05:21:52.144112+00	2025-04-28 05:21:52.144112+00	2025-04-28 05:21:52.144112+00
t2_atbps91a	Agitated_Wafer3530	0	0	0	0	0	2025-04-28 05:21:59.996828+00	2025-04-28 05:21:59.996828+00	2025-04-28 05:21:59.996828+00	2025-04-28 05:21:59.996828+00
t2_5qav9	HandMeMyThinkingPipe	0	0	0	0	0	2025-04-28 05:22:00.002643+00	2025-04-28 05:22:00.002643+00	2025-04-28 05:22:00.002643+00	2025-04-28 05:22:00.002643+00
t2_8eez7ub6	Yung_rat_	0	0	0	0	0	2025-04-28 05:22:00.005802+00	2025-04-28 05:22:00.008836+00	2025-04-28 05:22:00.005802+00	2025-04-28 05:22:00.008836+00
t2_8nw2hn	tcollins317	0	0	0	0	0	2025-04-28 05:22:00.012078+00	2025-04-28 05:22:00.012078+00	2025-04-28 05:22:00.012078+00	2025-04-28 05:22:00.012078+00
t2_m4rfbgzsd	zenigatamondatta	0	0	0	0	0	2025-04-28 05:22:00.01541+00	2025-04-28 05:22:00.01541+00	2025-04-28 05:22:00.01541+00	2025-04-28 05:22:00.01541+00
t2_62gpplqz	GoblinCorp	0	0	0	0	0	2025-04-28 05:22:00.018764+00	2025-04-28 05:22:00.018764+00	2025-04-28 05:22:00.018764+00	2025-04-28 05:22:00.018764+00
t2_9w8ydc7o	Dingis_Dang	0	0	0	0	0	2025-04-28 05:22:00.022176+00	2025-04-28 05:22:00.022176+00	2025-04-28 05:22:00.022176+00	2025-04-28 05:22:00.022176+00
t2_3cenm	el_seano	0	0	0	0	0	2025-04-28 05:22:00.025445+00	2025-04-28 05:22:00.025445+00	2025-04-28 05:22:00.025445+00	2025-04-28 05:22:00.025445+00
t2_5ucq1pym	tdpoo	0	0	0	0	0	2025-04-28 05:22:00.032273+00	2025-04-28 05:22:00.032273+00	2025-04-28 05:22:00.032273+00	2025-04-28 05:22:00.032273+00
t2_10qmby	eitsirkkendrick	0	0	0	0	0	2025-04-28 05:22:00.035335+00	2025-04-28 05:22:00.035335+00	2025-04-28 05:22:00.035335+00	2025-04-28 05:22:00.035335+00
t2_sgq9wdoo	Dry-Result-1860	0	1	0	2	0	2025-04-28 05:54:45.213465+00	2025-04-28 05:54:45.213465+00	2025-04-28 05:54:45.213465+00	2025-04-28 05:54:45.414142+00
t2_fbbtv	thelifeofbob	0	1	0	2	0	2025-04-28 05:54:45.216034+00	2025-04-28 05:54:45.216034+00	2025-04-28 05:54:45.216034+00	2025-04-28 05:54:45.419572+00
t2_btnufvou	designerallie	0	1	0	2	0	2025-04-28 05:54:45.218543+00	2025-04-28 05:54:45.218543+00	2025-04-28 05:54:45.218543+00	2025-04-28 05:54:45.424444+00
t2_beun3	Podalirius	0	1	0	1	0	2025-04-28 05:54:45.233457+00	2025-04-28 05:54:45.233457+00	2025-04-28 05:54:45.233457+00	2025-04-28 05:54:45.449789+00
t2_46pg7v1j	Realistic_Trip9243	0	1	0	1	0	2025-04-28 05:54:45.236175+00	2025-04-28 05:54:45.236175+00	2025-04-28 05:54:45.236175+00	2025-04-28 05:54:45.454829+00
t2_2l7xsm9k	thoreau_away_acct	0	1	0	1	0	2025-04-28 05:54:45.239063+00	2025-04-28 05:54:45.239063+00	2025-04-28 05:54:45.239063+00	2025-04-28 05:54:45.459687+00
t2_jporzab1	Ex-zaviera	0	1	0	1	0	2025-04-28 05:54:45.241782+00	2025-04-28 05:54:45.241782+00	2025-04-28 05:54:45.241782+00	2025-04-28 05:54:45.464601+00
t2_77x3t	SchwillyMaysHere	0	1	0	1	0	2025-04-28 05:54:45.249933+00	2025-04-28 05:54:45.249933+00	2025-04-28 05:54:45.249933+00	2025-04-28 05:54:45.469489+00
t2_15eqpo	AllChem_NoEcon	0	2	0	7	0	2025-04-28 05:55:03.035939+00	2025-04-28 05:56:02.312405+00	2025-04-28 05:55:03.035939+00	2025-04-28 05:56:02.407698+00
t2_3mf49wtw	sarcasticDNA	0	1	0	0	0	2025-04-28 05:54:45.265032+00	2025-04-28 05:54:45.265032+00	2025-04-28 05:54:45.265032+00	2025-04-28 05:54:45.498563+00
t2_qho98	MerkinLuvr	0	1	0	2	0	2025-04-28 05:54:54.316332+00	2025-04-28 05:54:54.316332+00	2025-04-28 05:54:54.316332+00	2025-04-28 05:54:54.520536+00
t2_82lkxf4e	Dali_Parton138	0	1	0	1	0	2025-04-28 05:54:54.367769+00	2025-04-28 05:54:54.367769+00	2025-04-28 05:54:54.367769+00	2025-04-28 05:54:54.573072+00
t2_6g1sh8l4	OkHistorian9753	0	1	0	1	0	2025-04-28 05:54:54.387742+00	2025-04-28 05:54:54.387742+00	2025-04-28 05:54:54.387742+00	2025-04-28 05:54:54.596643+00
t2_29tgtdna	monkeyriots	2	2	242	99	0	2025-04-28 05:55:11.392123+00	2025-04-28 05:55:11.396625+00	2025-04-28 05:55:11.392123+00	2025-04-28 05:56:02.425418+00
t2_63yzx	Boomhauer14	0	1	0	2	0	2025-04-28 05:55:03.037652+00	2025-04-28 05:55:03.037652+00	2025-04-28 05:55:03.037652+00	2025-04-28 05:55:03.074411+00
t2_3mm9p	px403	0	1	0	2	0	2025-04-28 05:55:03.038861+00	2025-04-28 05:55:03.038861+00	2025-04-28 05:55:03.038861+00	2025-04-28 05:55:03.078205+00
t2_ppp0rff5	dangerousperson123	0	1	0	5	0	2025-04-28 05:55:03.040735+00	2025-04-28 05:55:03.040735+00	2025-04-28 05:55:03.040735+00	2025-04-28 05:55:03.081706+00
t2_v3sn4jwd	theartistformer	0	1	0	8	0	2025-04-28 05:55:03.043215+00	2025-04-28 05:55:03.043215+00	2025-04-28 05:55:03.043215+00	2025-04-28 05:55:03.085439+00
t2_k7c2rffpc	DPeachMode	0	1	0	1	0	2025-04-28 05:55:03.045504+00	2025-04-28 05:55:03.045504+00	2025-04-28 05:55:03.045504+00	2025-04-28 05:55:03.088754+00
t2_11gk9c	amnlkingdom	0	1	0	-1	0	2025-04-28 05:55:03.049535+00	2025-04-28 05:55:03.049535+00	2025-04-28 05:55:03.049535+00	2025-04-28 05:55:03.09701+00
t2_ivjjw	jackiesatrucker	0	1	0	7	0	2025-04-28 05:55:11.398783+00	2025-04-28 05:55:11.398783+00	2025-04-28 05:55:11.398783+00	2025-04-28 05:55:11.421424+00
t2_2xc2vxjo	vips7L	0	1	0	8	0	2025-04-28 05:55:11.4008+00	2025-04-28 05:55:11.4008+00	2025-04-28 05:55:11.4008+00	2025-04-28 05:55:11.425126+00
t2_122eyg61	GWNVKV	0	1	0	6	0	2025-04-28 05:55:11.402845+00	2025-04-28 05:55:11.402845+00	2025-04-28 05:55:11.402845+00	2025-04-28 05:55:11.429278+00
t2_j20zulhl	Future_Potential_108	0	1	0	3	0	2025-04-28 05:55:11.404457+00	2025-04-28 05:55:11.404457+00	2025-04-28 05:55:11.404457+00	2025-04-28 05:55:11.433059+00
t2_hwutb	derpinpdx	0	1	0	11	0	2025-04-28 05:55:19.70511+00	2025-04-28 05:55:19.70511+00	2025-04-28 05:55:19.70511+00	2025-04-28 05:55:19.755562+00
t2_16152u3z	Whatchab	0	1	0	4	0	2025-04-28 05:55:19.711328+00	2025-04-28 05:55:19.711328+00	2025-04-28 05:55:19.711328+00	2025-04-28 05:55:19.76402+00
t2_fgp12	Tumblehawk	0	1	0	3	0	2025-04-28 05:55:19.718497+00	2025-04-28 05:55:19.718497+00	2025-04-28 05:55:19.718497+00	2025-04-28 05:55:19.770836+00
t2_tswiitd	tinglingtriangle	0	1	0	7	0	2025-04-28 05:55:19.725924+00	2025-04-28 05:55:19.725924+00	2025-04-28 05:55:19.725924+00	2025-04-28 05:55:19.777185+00
t2_dsbm4hzy9	Local-Equivalent-151	0	2	0	0	0	2025-04-28 05:54:45.260282+00	2025-04-28 05:56:02.31712+00	2025-04-28 05:54:45.260282+00	2025-04-28 05:56:02.412959+00
t2_28x18o9k	LaplaceOperator	0	1	0	8	0	2025-04-28 05:55:28.021376+00	2025-04-28 05:55:28.021376+00	2025-04-28 05:55:28.021376+00	2025-04-28 05:55:28.037258+00
t2_fvqym	psbanka	0	1	0	4	0	2025-04-28 05:55:28.023259+00	2025-04-28 05:55:28.023259+00	2025-04-28 05:55:28.023259+00	2025-04-28 05:55:28.041622+00
t2_80dsjugj	Negotiation-Short	0	1	0	4	0	2025-04-28 05:55:28.024983+00	2025-04-28 05:55:28.024983+00	2025-04-28 05:55:28.024983+00	2025-04-28 05:55:28.045969+00
t2_w7oj2v2c	Armpitage	0	1	0	-5	0	2025-04-28 05:55:28.027143+00	2025-04-28 05:55:28.027143+00	2025-04-28 05:55:28.027143+00	2025-04-28 05:55:28.049757+00
t2_1y4gm6gp	Jklever716	0	1	0	1	0	2025-04-28 05:55:36.313549+00	2025-04-28 05:55:36.313549+00	2025-04-28 05:55:36.313549+00	2025-04-28 05:55:36.351324+00
t2_2wflniu5	de_pizan23	0	1	0	18	0	2025-04-28 05:55:44.677451+00	2025-04-28 05:55:44.677451+00	2025-04-28 05:55:44.677451+00	2025-04-28 05:55:44.770101+00
t2_hghxgqd	SpiciestBoy	0	1	0	13	0	2025-04-28 05:55:44.682479+00	2025-04-28 05:55:44.682479+00	2025-04-28 05:55:44.682479+00	2025-04-28 05:55:44.779629+00
t2_bse9x	parisbutler22	0	1	0	10	0	2025-04-28 05:55:44.687139+00	2025-04-28 05:55:44.687139+00	2025-04-28 05:55:44.687139+00	2025-04-28 05:55:44.789045+00
t2_png8	monad68	0	1	0	9	0	2025-04-28 05:55:44.691882+00	2025-04-28 05:55:44.691882+00	2025-04-28 05:55:44.691882+00	2025-04-28 05:55:44.800033+00
t2_bxxw8	SatanIsYourBuddy	0	1	0	9	0	2025-04-28 05:55:44.696965+00	2025-04-28 05:55:44.696965+00	2025-04-28 05:55:44.696965+00	2025-04-28 05:55:44.812956+00
t2_2cu1rupk	ioverated	0	1	0	3	0	2025-04-28 05:55:44.70639+00	2025-04-28 05:55:44.70639+00	2025-04-28 05:55:44.70639+00	2025-04-28 05:55:44.838726+00
t2_6mc8o	HydrogenatedBee	0	1	0	3	0	2025-04-28 05:55:44.711905+00	2025-04-28 05:55:44.711905+00	2025-04-28 05:55:44.711905+00	2025-04-28 05:55:44.852143+00
t2_gdxma	c_r_a_s_i_a_n	0	1	0	1	0	2025-04-28 05:55:44.722309+00	2025-04-28 05:55:44.722309+00	2025-04-28 05:55:44.722309+00	2025-04-28 05:55:44.878205+00
t2_l84ys	snowglobes4peace	0	1	0	1	0	2025-04-28 05:55:44.732192+00	2025-04-28 05:55:44.732192+00	2025-04-28 05:55:44.732192+00	2025-04-28 05:55:44.903414+00
t2_5e5ruc3m	mmemm5456	0	1	0	1	0	2025-04-28 05:55:44.736939+00	2025-04-28 05:55:44.736939+00	2025-04-28 05:55:44.736939+00	2025-04-28 05:55:44.916593+00
t2_7ygh3	portlandobserver	0	1	0	-2	0	2025-04-28 05:55:44.741481+00	2025-04-28 05:55:44.741481+00	2025-04-28 05:55:44.741481+00	2025-04-28 05:55:44.929034+00
t2_9cq03	zerocoolforschool	0	1	0	11	0	2025-04-28 05:55:53.248901+00	2025-04-28 05:55:53.248901+00	2025-04-28 05:55:53.248901+00	2025-04-28 05:55:53.30318+00
t2_8h45vndqj	moomooraincloud	0	1	0	7	0	2025-04-28 05:55:53.256365+00	2025-04-28 05:55:53.256365+00	2025-04-28 05:55:53.256365+00	2025-04-28 05:55:53.312867+00
t2_wey97	batchian320	0	1	0	4	0	2025-04-28 05:55:53.271331+00	2025-04-28 05:55:53.271331+00	2025-04-28 05:55:53.271331+00	2025-04-28 05:55:53.331391+00
t2_1204ch	-donethat	0	1	0	1	0	2025-04-28 05:55:53.27668+00	2025-04-28 05:55:53.27668+00	2025-04-28 05:55:53.27668+00	2025-04-28 05:55:53.337321+00
t2_j0e8rxn	screamingintothedark	0	1	0	16	0	2025-04-28 05:56:02.264314+00	2025-04-28 05:56:02.264314+00	2025-04-28 05:56:02.264314+00	2025-04-28 05:56:02.348194+00
t2_fiuqh	omnichord	0	1	0	9	0	2025-04-28 05:56:02.270503+00	2025-04-28 05:56:02.270503+00	2025-04-28 05:56:02.270503+00	2025-04-28 05:56:02.359009+00
t2_74oojiwa	Aggravating_Peach_70	0	1	0	16	0	2025-04-28 05:56:02.284254+00	2025-04-28 05:56:02.284254+00	2025-04-28 05:56:02.284254+00	2025-04-28 05:56:02.378495+00
t2_4xg8c	chrispdx	0	1	0	19	0	2025-04-28 05:56:02.291256+00	2025-04-28 05:56:02.291256+00	2025-04-28 05:56:02.291256+00	2025-04-28 05:56:02.387059+00
t2_c9uvu	NotApparent	0	1	0	16	0	2025-04-28 05:56:02.297699+00	2025-04-28 05:56:02.297699+00	2025-04-28 05:56:02.297699+00	2025-04-28 05:56:02.392499+00
t2_54dre5id	count_chocul4	0	1	0	7	0	2025-04-28 05:56:02.302739+00	2025-04-28 05:56:02.302739+00	2025-04-28 05:56:02.302739+00	2025-04-28 05:56:02.397566+00
t2_448naq1y	TappyMauvendaise	0	1	0	2	0	2025-04-28 05:56:02.307582+00	2025-04-28 05:56:02.307582+00	2025-04-28 05:56:02.307582+00	2025-04-28 05:56:02.402421+00
t2_107l4h	JustSayNeat	2	0	0	0	0	2025-04-28 05:56:02.255902+00	2025-04-28 05:56:02.255902+00	2025-04-28 05:56:02.255902+00	2025-04-28 05:56:02.425418+00
t2_166lrpkyei	Melodic-Republic3905	2	0	34	0	0	2025-04-28 05:55:36.30642+00	2025-04-28 05:55:36.30642+00	2025-04-28 05:55:36.30642+00	2025-04-28 05:56:02.425418+00
t2_anecn	probeguy	2	0	24	0	0	2025-04-28 05:55:28.019144+00	2025-04-28 05:55:28.019144+00	2025-04-28 05:55:28.019144+00	2025-04-28 05:56:02.425418+00
t2_cxjl2	Blackadder288	2	0	238	0	0	2025-04-28 05:55:03.027278+00	2025-04-28 05:55:03.027278+00	2025-04-28 05:55:03.027278+00	2025-04-28 05:56:02.425418+00
t2_t3ir6uukh	PeaAggressive8029	2	0	78	0	0	2025-04-28 05:55:19.698141+00	2025-04-28 05:55:19.698141+00	2025-04-28 05:55:19.698141+00	2025-04-28 05:56:02.425418+00
t2_vfz62twd	Malathion4Drinking	2	0	0	0	0	2025-04-28 05:55:53.240259+00	2025-04-28 05:55:53.240259+00	2025-04-28 05:55:53.240259+00	2025-04-28 05:56:02.425418+00
t2_w25aa	globaltetrahedron67	2	0	4	0	0	2025-04-28 05:55:44.669452+00	2025-04-28 05:55:44.669452+00	2025-04-28 05:55:44.669452+00	2025-04-28 05:56:02.425418+00
\.


--
-- Name: pgmigrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: reddit_scraper
--

SELECT pg_catalog.setval('public.pgmigrations_id_seq', 1, true);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: reddit_scraper
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: comments comments_reddit_id_key; Type: CONSTRAINT; Schema: public; Owner: reddit_scraper
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_reddit_id_key UNIQUE (reddit_id);


--
-- Name: pgmigrations pgmigrations_pkey; Type: CONSTRAINT; Schema: public; Owner: reddit_scraper
--

ALTER TABLE ONLY public.pgmigrations
    ADD CONSTRAINT pgmigrations_pkey PRIMARY KEY (id);


--
-- Name: posts posts_author_id_permalink_key; Type: CONSTRAINT; Schema: public; Owner: reddit_scraper
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_author_id_permalink_key UNIQUE (author_id, permalink);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: reddit_scraper
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: subreddits subreddits_name_key; Type: CONSTRAINT; Schema: public; Owner: reddit_scraper
--

ALTER TABLE ONLY public.subreddits
    ADD CONSTRAINT subreddits_name_key UNIQUE (name);


--
-- Name: subreddits subreddits_pkey; Type: CONSTRAINT; Schema: public; Owner: reddit_scraper
--

ALTER TABLE ONLY public.subreddits
    ADD CONSTRAINT subreddits_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: reddit_scraper
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_comments_author_id; Type: INDEX; Schema: public; Owner: reddit_scraper
--

CREATE INDEX idx_comments_author_id ON public.comments USING btree (author_id);


--
-- Name: idx_comments_contribution_score; Type: INDEX; Schema: public; Owner: reddit_scraper
--

CREATE INDEX idx_comments_contribution_score ON public.comments USING btree (contribution_score);


--
-- Name: idx_comments_created_at; Type: INDEX; Schema: public; Owner: reddit_scraper
--

CREATE INDEX idx_comments_created_at ON public.comments USING btree (created_at);


--
-- Name: idx_comments_post_id; Type: INDEX; Schema: public; Owner: reddit_scraper
--

CREATE INDEX idx_comments_post_id ON public.comments USING btree (post_id);


--
-- Name: idx_comments_reddit_created_at; Type: INDEX; Schema: public; Owner: reddit_scraper
--

CREATE INDEX idx_comments_reddit_created_at ON public.comments USING btree (reddit_created_at);


--
-- Name: idx_posts_author_id; Type: INDEX; Schema: public; Owner: reddit_scraper
--

CREATE INDEX idx_posts_author_id ON public.posts USING btree (author_id);


--
-- Name: idx_posts_created_at; Type: INDEX; Schema: public; Owner: reddit_scraper
--

CREATE INDEX idx_posts_created_at ON public.posts USING btree (created_at);


--
-- Name: idx_posts_daily_rank; Type: INDEX; Schema: public; Owner: reddit_scraper
--

CREATE INDEX idx_posts_daily_rank ON public.posts USING btree (daily_rank);


--
-- Name: idx_posts_keywords; Type: INDEX; Schema: public; Owner: reddit_scraper
--

CREATE INDEX idx_posts_keywords ON public.posts USING gin (keywords);


--
-- Name: idx_posts_reddit_created_at; Type: INDEX; Schema: public; Owner: reddit_scraper
--

CREATE INDEX idx_posts_reddit_created_at ON public.posts USING btree (reddit_created_at);


--
-- Name: idx_posts_sentiment; Type: INDEX; Schema: public; Owner: reddit_scraper
--

CREATE INDEX idx_posts_sentiment ON public.posts USING gin (sentiment);


--
-- Name: idx_posts_subreddit_id; Type: INDEX; Schema: public; Owner: reddit_scraper
--

CREATE INDEX idx_posts_subreddit_id ON public.posts USING btree (subreddit_id);


--
-- Name: idx_posts_top_commenters; Type: INDEX; Schema: public; Owner: reddit_scraper
--

CREATE INDEX idx_posts_top_commenters ON public.posts USING gin (top_commenters);


--
-- Name: idx_users_username; Type: INDEX; Schema: public; Owner: reddit_scraper
--

CREATE INDEX idx_users_username ON public.users USING btree (username);


--
-- Name: comments update_comments_updated_at; Type: TRIGGER; Schema: public; Owner: reddit_scraper
--

CREATE TRIGGER update_comments_updated_at BEFORE UPDATE ON public.comments FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: posts update_posts_updated_at; Type: TRIGGER; Schema: public; Owner: reddit_scraper
--

CREATE TRIGGER update_posts_updated_at BEFORE UPDATE ON public.posts FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: subreddits update_subreddits_updated_at; Type: TRIGGER; Schema: public; Owner: reddit_scraper
--

CREATE TRIGGER update_subreddits_updated_at BEFORE UPDATE ON public.subreddits FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: comments comments_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reddit_scraper
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id);


--
-- Name: comments comments_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reddit_scraper
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id);


--
-- Name: posts posts_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reddit_scraper
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id);


--
-- Name: posts posts_subreddit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reddit_scraper
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_subreddit_id_fkey FOREIGN KEY (subreddit_id) REFERENCES public.subreddits(id);


--
-- PostgreSQL database dump complete
--

