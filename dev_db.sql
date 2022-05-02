CREATE TABLE "users" (
  "user_id" SERIAL PRIMARY KEY,
  "first_name" varchar,
  "last_name" varchar(),
  "user_name" varchar,
  "password" varchar,
  "email" varchar
);

CREATE TABLE "user_events" (
  "user_events_id" SERIAL PRIMARY KEY,
  "user_id" int,
  "event_id" int
);

CREATE TABLE "votes" (
  "vote_id" SERIAL PRIMARY KEY,
  "amount" int DEFAULT 1,
  "user_id" integer NOT NULL,
  "choice_id" integer NOT NULL
);

CREATE TABLE "chat_board" (
  "chat_board_id" SERIAL PRIMARY KEY,
  "posted_time" datetime DEFAULT 'now',
  "comment" varchar,
  "user_id" int,
  "event_id" int
);

CREATE TABLE "events" (
  "event_id" SERIAL PRIMARY KEY,
  "room_location" varchar,
  "description" varchar DEFAULT 'room_title',
  "participants" integer
);

CREATE TABLE "choices" (
  "choice_id" SERIAL PRIMARY KEY,
  "type" varchar,
  "title" varchar,
  "event" integer
);

ALTER TABLE "user_events" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");

ALTER TABLE "user_events" ADD FOREIGN KEY ("event_id") REFERENCES "events" ("event_id");

ALTER TABLE "votes" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");

ALTER TABLE "votes" ADD FOREIGN KEY ("choice_id") REFERENCES "choices" ("choice_id");

ALTER TABLE "users" ADD FOREIGN KEY ("user_id") REFERENCES "chat_board" ("user_id");

ALTER TABLE "events" ADD FOREIGN KEY ("event_id") REFERENCES "chat_board" ("event_id");

ALTER TABLE "choices" ADD FOREIGN KEY ("event") REFERENCES "events" ("event_id");
