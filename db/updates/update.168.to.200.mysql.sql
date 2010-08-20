CREATE TABLE IF NOT EXISTS `blacklist_patterns` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(15) default NULL,
  `pattern` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
);

CREATE TABLE IF NOT EXISTS  `settings` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(40) default NULL,
  `value` varchar(40) default NULL,
  PRIMARY KEY  (`id`)
);

CREATE TABLE IF NOT EXISTS `sessions` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `sessid` varchar(32) default NULL,
  `data` text,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `sessid` (`sessid`)
);

CREATE TABLE IF NOT EXISTS  `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(80) default NULL,
  `password` varchar(40) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `login` (`login`)
);

ALTER TABLE `comments` ADD `ip` varchar(15) DEFAULT NULL;
ALTER TABLE `articles` ADD `text_filter` varchar(20) DEFAULT NULL;
