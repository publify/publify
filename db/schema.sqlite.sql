CREATE TABLE 'users' (
  'id'          INTEGER PRIMARY KEY NOT NULL,
  'login'       VARCHAR(80) DEFAULT NULL,
  'password'    VARCHAR(40) DEFAULT NULL,
  'name'	VARCHAR(80) DEFAULT NULL,
  'email'	VARCHAR(80) DEFAULT NULL
);

CREATE TABLE 'articles' (
  'id'          INTEGER PRIMARY KEY NOT NULL,
  'title'       VARCHAR(255) DEFAULT NULL,
  'author'      VARCHAR(255) DEFAULT NULL,
  'body'        TEXT DEFAULT NULL,
  'body_html'   TEXT DEFAULT NULL,
  'extended'    TEXT DEFAULT NULL,
  'extended_html'  TEXT DEFAULT NULL,
  'excerpt'     TEXT DEFAULT NULL,
  'keywords'    TEXT DEFAULT NULL,
  'allow_comments' INTEGER DEFAULT 1,  
  'allow_pings'    INTEGER DEFAULT 1,  
  'published'   INTEGER DEFAULT 1,  
  'text_filter' VARCHAR(20) DEFAULT NULL,
  'user_id'     INTEGER DEFAULT NULL,
  'created_at'  DATETIME DEFAULT NULL,
  'updated_at'  DATETIME DEFAULT NULL,
  'permalink'   VARCHAR(255) DEFAULT NULL,
  'guid' 	VARCHAR(255) DEFAULT NULL
);

CREATE TABLE 'articles_categories' (
  'article_id'	INTEGER,
  'category_id'	INTEGER,
  'is_primary' INTEGER DEFAULT 0
);

CREATE TABLE 'blacklist_patterns' (
  'id'          INTEGER PRIMARY KEY NOT NULL,
  'type'        VARCHAR(15) DEFAULT NULL,
  'pattern'     VARCHAR(255) DEFAULT NULL
);

CREATE TABLE 'page_caches' (
  'id'		INTEGER PRIMARY KEY NOT NULL,
  'name'   VARCHAR(255)
);

CREATE TABLE 'pages' (
  'id'          INTEGER PRIMARY KEY NOT NULL,
  'name'       VARCHAR(255) DEFAULT NULL,
  'title'       VARCHAR(255) DEFAULT NULL,
  'body'        TEXT DEFAULT NULL,
  'body_html'   TEXT DEFAULT NULL,
  'text_filter' VARCHAR(20) DEFAULT NULL,
  'user_id'     INTEGER DEFAULT NULL,
  'created_at'  DATETIME DEFAULT NULL,
  'updated_at'  DATETIME DEFAULT NULL
);

CREATE TABLE 'categories' (
  'id'          INTEGER PRIMARY KEY NOT NULL,
  'name'        VARCHAR(255) DEFAULT NULL,
  'position'    INTEGER,
  'permalink'   VARCHAR(255) DEFAULT NULL
);

CREATE TABLE 'comments' (
  'id'          INTEGER PRIMARY KEY NOT NULL,
  'article_id'  INTEGER DEFAULT NULL,
  'author'      VARCHAR(255) DEFAULT NULL,
  'email'       VARCHAR(255) DEFAULT NULL,
  'url'         VARCHAR(255) DEFAULT NULL,
  'ip'          VARCHAR(15) DEFAULT NULL,
  'body'        TEXT DEFAULT NULL,
  'body_html'   TEXT DEFAULT NULL,
  'created_at'  DATETIME DEFAULT NULL,
  'updated_at'  DATETIME DEFAULT NULL
);

CREATE TABLE 'pings' (
  'id'          INTEGER PRIMARY KEY NOT NULL,
  'article_id'  INTEGER,
  'url'         VARCHAR(15) DEFAULT NULL,
  'created_at'  DATETIME DEFAULT NULL
);

CREATE TABLE 'resources' (
  'id'          INTEGER PRIMARY KEY NOT NULL,
  'size'        INTEGER DEFAULT NULL,
  'filename'    VARCHAR(255) DEFAULT NULL,
  'mime'        VARCHAR(255) DEFAULT NULL,
  'created_at'  DATETIME DEFAULT NULL,
  'updated_at'  DATETIME DEFAULT NULL
);

CREATE TABLE 'sessions' (
  'id'          INTEGER PRIMARY KEY NOT NULL,
  'sessid'      VARCHAR(32) DEFAULT NULL,
  'data'        TEXT,
  'updated_at'  DATETIME DEFAULT NULL
);
                                                                               
CREATE TABLE 'settings' (
  'id'          INTEGER PRIMARY KEY NOT NULL,
  'name'        VARCHAR(255) DEFAULT NULL,
  'value'       VARCHAR(255) DEFAULT NULL,
  'position'    INTEGER
);

CREATE TABLE 'sidebars' (
  'id'          INTEGER PRIMARY KEY NOT NULL,
  'controller'  VARCHAR(32) DEFAULT NULL,
  'active_position' INTEGER,
  'active_config' TEXT,
  'staged_position' INTEGER,
  'staged_config' TEXT,
  'created_at'  DATETIME DEFAULT NULL,
  'updated_at'  DATETIME DEFAULT NULL
);                                                                                                                                                             
insert into sidebars (id,controller,active_position,staged_position)
  values (1,'category',0,0);
insert into sidebars (id,controller,active_position,staged_position)
  values (2,'static',1,1);
insert into sidebars (id,controller,active_position,staged_position)
  values (3,'xml',2,2);

CREATE TABLE 'trackbacks' (
  'id'          INTEGER PRIMARY KEY NOT NULL,
  'article_id'  INTEGER,
  'category_id' INTEGER,
  'blog_name'   VARCHAR(255) DEFAULT NULL,
  'title'       VARCHAR(255) DEFAULT NULL,
  'excerpt'     VARCHAR(255) DEFAULT NULL,
  'url'         VARCHAR(255) DEFAULT NULL,
  'ip'          VARCHAR(15) DEFAULT NULL,
  'created_at'  DATETIME DEFAULT NULL,
  'updated_at'  DATETIME DEFAULT NULL
);

CREATE TABLE 'schema_info' (
  'version' INTEGER
);

INSERT into schema_info VALUES (9);
