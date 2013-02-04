DROP DATABASE IF EXISTS task_list;
CREATE DATABASE `task_list` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `task_list`;
CREATE TABLE IF NOT EXISTS `task` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `timecreated` datetime NOT NULL,
  `summary` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `reporter` varchar(128) NOT NULL,
  `owner` varchar(128) NOT NULL,
  `rank` int(10) unsigned NOT NULL,
  `status` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;
INSERT INTO `task` (`id`,`timecreated`, `summary`, `content`, `reporter`, `owner`, `rank`, `status`) VALUES
(1, '2013-02-01 15:00:00', 'Sketch UI', 'Mockups for UI', 'mmmartin','mmmartin', 1, 'todo'),
(2, '2013-02-01 15:00:00', 'Get stuff displaying!', 'Display the tasks on a web page, ranked in priority order', 'mmmartin','mmmartin', 2, 'todo'),
(3, '2013-02-01 15:00:00', 'Let people add stuff!', 'Add a form to allow people to create their own tasks', 'mmmartin','mmmartin', 3, 'todo'),
(4, '2013-02-01 15:00:00', 'Let people prioritise stuff!', 'Let people drag and drop their taks to rank them', 'mmmartin','mmmartin', 4, 'todo'),
(5, '2013-02-01 15:00:00', 'Make it look bearable!', 'Tidy up the UI', 'mmmartin','mmmartin', 5, 'todo'),
(6, '2013-02-01 15:00:00', 'Iterate', 'Expand the schema, add auth etc.', 'mmmartin','mmmartin', 6, 'todo');
