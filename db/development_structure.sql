CREATE TABLE 'articles' (
  'id'          INTEGER PRIMARY KEY NOT NULL,
  'title'       VARCHAR(255) DEFAULT NULL,
  'category'    VARCHAR(255) DEFAULT NULL,
  'author'      VARCHAR(255) DEFAULT NULL,
  'body'        TEXT DEFAULT NULL,
  'body_html'   TEXT DEFAULT NULL,
  'published'   INTEGER DEFAULT 1,  
  'created_at'  DATETIME DEFAULT NULL,
  'updated_at'  DATETIME DEFAULT NULL
);
CREATE TABLE 'categories' (
  'id'          INTEGER PRIMARY KEY NOT NULL,
  'name'        VARCHAR(255) DEFAULT NULL,
  'position'    INTEGER
);
CREATE TABLE 'comments' (
  'id'          INTEGER PRIMARY KEY NOT NULL,
  'article_id'  INTEGER DEFAULT NULL,
  'title'       VARCHAR(255) DEFAULT NULL,
  'author'      VARCHAR(255) DEFAULT NULL,
  'email'       VARCHAR(255) DEFAULT NULL,
  'url'         VARCHAR(255) DEFAULT NULL,
  'body'        TEXT DEFAULT NULL,
  'body_html'   TEXT DEFAULT NULL,
  'created_at'  DATETIME DEFAULT NULL,
  'updated_at'  DATETIME DEFAULT NULL
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
