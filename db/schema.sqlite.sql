CREATE TABLE 'articles' (
  'id'          INTEGER PRIMARY KEY NOT NULL,
  'title'       VARCHAR(255) DEFAULT NULL,
  'author'      VARCHAR(255) DEFAULT NULL,
  'body'        TEXT DEFAULT NULL,
  'body_html'   TEXT DEFAULT NULL,
  'extended'    TEXT DEFAULT NULL,
  'excerpt'     TEXT DEFAULT NULL,
  'keywords'    TEXT DEFAULT NULL,
  'allow_comments' INTEGER DEFAULT 1,  
  'allow_pings'    INTEGER DEFAULT 1,  
  'published'   INTEGER DEFAULT 1,  
  'created_at'  DATETIME DEFAULT NULL,
  'updated_at'  DATETIME DEFAULT NULL
);
CREATE TABLE 'articles_categories' (
  'article_id'	INTEGER,
  'category_id'	INTEGER,
  'is_primary' INTEGER DEFAULT 0
);
CREATE TABLE 'categories' (
  'id'          INTEGER PRIMARY KEY NOT NULL,
  'name'        VARCHAR(255) DEFAULT NULL,
  'position'    INTEGER
);
CREATE TABLE 'comments' (
  'id'          INTEGER PRIMARY KEY NOT NULL,
  'article_id'  INTEGER DEFAULT NULL,
  'author'      VARCHAR(255) DEFAULT NULL,
  'email'       VARCHAR(255) DEFAULT NULL,
  'url'         VARCHAR(255) DEFAULT NULL,
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
CREATE TABLE 'sidebar_blocks' (
  'id'          INTEGER PRIMARY KEY NOT NULL,
  'type'        VARCHAR(255) DEFAULT NULL,
  'data'        TEXT, 
  'position'    INTEGER
);
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
