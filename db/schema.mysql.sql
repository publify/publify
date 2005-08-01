CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(80) default NULL,
  `password` varchar(40) default NULL,
  `name` varchar(80) default NULL,
  `email` varchar(80) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `login` (`login`)
) TYPE=MyISAM;

CREATE TABLE `articles` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `author` varchar(255) default NULL,
  `body` text,
  `body_html` text,
  `extended` text,
  `extended_html` text,
  `excerpt` text,
  `keywords` varchar(255) default NULL,
  `allow_comments` tinyint(1) default NULL,
  `allow_pings` tinyint(1) default NULL,
  `published` tinyint(1) NOT NULL default '1',
  `text_filter` varchar(20) default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `permalink` varchar(255) default NULL,
  `guid` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `articles_permalink_index` (`permalink`)
) TYPE=MyISAM;

CREATE TABLE `articles_categories` (
  `article_id` int(11) default NULL,
  `category_id` int(11) default NULL,
  `is_primary` tinyint(1) NOT NULL default '0'
) TYPE=MyISAM;

CREATE TABLE `blacklist_patterns` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(15) default NULL,
  `pattern` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

CREATE TABLE `page_caches` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `name` (`name`)
) TYPE=MyISAM;

CREATE TABLE `pages` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `title` varchar(255) default NULL,
  `body` text,
  `body_html` text,
  `text_filter` varchar(20) default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

CREATE TABLE `categories` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `position` int(11) NOT NULL default '0',
  `permalink` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `categories_permalink_index` (`permalink`)
) TYPE=MyISAM;

CREATE TABLE `comments` (
  `id` int(11) NOT NULL auto_increment,
  `article_id` int(11) default NULL,
  `author` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `ip` varchar(15) default NULL,
  `body` text,
  `body_html` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `article_id` (`article_id`)
) TYPE=MyISAM;

CREATE TABLE `pings` (
  `id` int(11) NOT NULL auto_increment,
  `article_id` int(11) default NULL,
  `url` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `article_id` (`article_id`)
) TYPE=MyISAM;

CREATE TABLE `resources` (
  `id` int(11) NOT NULL auto_increment,
  `size` int(11) default NULL,
  `filename` varchar(255) default NULL,
  `mime` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

CREATE TABLE `sessions` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `sessid` varchar(32) default NULL,
  `data` text,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `sessid` (`sessid`)
) TYPE=MyISAM;

CREATE TABLE `settings` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `value` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

CREATE TABLE `sidebars` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `controller` varchar(32) default NULL,
  `active_position` int(11),
  `active_config` text,
  `staged_position` int(11),
  `staged_config` text,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

insert into sidebars (id,controller,active_position,staged_position)
  values (1,'category',0,0);
insert into sidebars (id,controller,active_position,staged_position)
  values (2,'static',1,1);
insert into sidebars (id,controller,active_position,staged_position)
  values (3,'xml',2,2);

CREATE TABLE `trackbacks` (
  `id` int(11) NOT NULL auto_increment,
  `article_id` int(11) default NULL,
  `category_id` int(11) default NULL,
  `blog_name` varchar(255) default NULL,
  `title` varchar(255) default NULL,
  `excerpt` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `ip` varchar(15) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `article_id` (`article_id`)
) TYPE=MyISAM;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) TYPE=MyISAM;

INSERT into `schema_info` VALUES (9);
