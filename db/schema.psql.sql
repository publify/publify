--
-- PostgreSQL schema file for Type
-- Modified by Robby Russell <robby@planetargon.com>
--

CREATE TABLE articles (
  id SERIAL PRIMARY KEY NOT NULL,
  title varchar(255) default NULL,
  author varchar(255) default NULL,
  body text,
  body_html text,
  extended text,
  excerpt text,
  keywords varchar(255) default NULL,
  allow_comments int default NULL,
  allow_pings int default NULL,
  published int NOT NULL default '1',
  text_filter varchar(20) default NULL,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

CREATE TABLE categories (
  id SERIAL PRIMARY KEY NOT NULL,
  name varchar(255) default NULL,
  position int NOT NULL default '0'
);

INSERT INTO categories (name, position) VALUES ('RubyOnRails', 1);
INSERT INTO categories (name, position) VALUES ('Typo', 2);


CREATE TABLE articles_categories (
  article_id int REFERENCES articles,
  category_id int REFERENCES categories,
  primary_item int default NULL
);

CREATE TABLE blacklist_patterns (
  id SERIAL PRIMARY KEY NOT NULL,
  type varchar(15) default NULL,
  pattern varchar(255) default NULL
);

CREATE TABLE comments (
  id SERIAL PRIMARY KEY NOT NULL,
  article_id int REFERENCES articles,
  title varchar(255) default NULL,
  author varchar(255) default NULL,
  email varchar(255) default NULL,
  url varchar(255) default NULL,
  ip varchar(15) default NULL,
  body text,
  body_html text,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

CREATE TABLE resources (
  id SERIAL PRIMARY KEY NOT NULL,
  size int default NULL,
  filename varchar(255) default NULL,
  mime varchar(255) default NULL,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

CREATE TABLE sessions (
  id SERIAL PRIMARY KEY NOT NULL,
  sessid varchar(255) default NULL,
  data text
);                                                                                                                                                                  

CREATE TABLE sidebar_blocks (
  id SERIAL PRIMARY KEY NOT NULL,
  type varchar(255) default NULL,
  data text,
  position int default NULL
);

CREATE TABLE settings (
  id SERIAL PRIMARY KEY NOT NULL,
  name varchar(255) default NULL,
  value varchar(255) default NULL,
  position int default NULL
);


CREATE TABLE trackbacks (
  id SERIAL PRIMARY KEY NOT NULL,
  article_id int REFERENCES articles,
  blog_name varchar(255) default NULL,
  title varchar(255) default NULL,
  excerpt varchar(255) default NULL,
  url varchar(255) default NULL,
  ip varchar(15) default NULL,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

