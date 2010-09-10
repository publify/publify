CREATE TABLE blacklist_patterns (
  id SERIAL PRIMARY KEY NOT NULL,
  type varchar(15) default NULL,
  pattern varchar(255) default NULL
);

CREATE TABLE sessions (
  id SERIAL PRIMARY KEY NOT NULL,
  sessid varchar(255) default NULL,
  data text,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

CREATE TABLE settings (
  id SERIAL PRIMARY KEY NOT NULL,
  name varchar(255) default NULL,
  value varchar(255) default NULL,
  position int default NULL
);

CREATE TABLE users (
  id SERIAL PRIMARY KEY NOT NULL,
  login varchar(40) default NULL,
  password varchar(40) default NULL,
  UNIQUE (login)
);

ALTER TABLE comments ADD ip varchar(15) DEFAULT NULL;
ALTER TABLE articles ADD text_filter varchar(20) DEFAULT NULL;
