CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(80) default NULL,
  `password` varchar(40) default NULL,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

CREATE TABLE `articles` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `author` varchar(255) default NULL,
  `body` text,
  `body_html` text,
  `extended` text,
  `excerpt` text,
  `keywords` varchar(255) default NULL,
  `allow_comments` tinyint(1) default NULL,
  `allow_pings` tinyint(1) default NULL,
  `published` tinyint(1) NOT NULL default '1',
  `text_filter` varchar(20) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
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

CREATE TABLE `categories` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `position` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
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
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

CREATE TABLE `pings` (
  `id` int(11) NOT NULL auto_increment,
  `article_id` int(11) default NULL,
  `url` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`)
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

CREATE TABLE `settings` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(40) default NULL,
  `value` varchar(40) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM;

CREATE TABLE `sidebar_blocks` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(255) default NULL,
  `data` text,
  `position` int(11) default NULL,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

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
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

