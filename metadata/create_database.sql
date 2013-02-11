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
(1, CURRENT_TIMESTAMP, 'Add new projects', 'Add new projects through the admin interface.', 'mmmartin','mmmartin', 1, 'todo'),
(2, CURRENT_TIMESTAMP, 'Add sub projects', 'Add sub projects through the admin interface', 'mmmartin','mmmartin', 2, 'todo'),
(3, CURRENT_TIMESTAMP, 'Project Dropdown', 'Select a different Project from a drop down when giving feedback.', 'mmmartin','mmmartin', 3, 'todo'),
(4, CURRENT_TIMESTAMP, 'Sub Project Dropdown', 'Select a different sub project from a drop down when giving feedback on a project.', 'mmmartin','mmmartin', 4, 'todo'),
(5, CURRENT_TIMESTAMP, 'Help Screens', 'Click on help link to view annotated screens explaining the interface', 'mmmartin','mmmartin', 5, 'todo'),
(6, CURRENT_TIMESTAMP, 'Restrict export options', 'Restrict export option to admin and production?', 'mmmartin','mmmartin', 6, 'todo'),
(7, CURRENT_TIMESTAMP, 'Delete image option', 'Delete an image after it has been attached it to an entry', 'mmmartin','mmmartin', 7, 'todo'),
(8, CURRENT_TIMESTAMP, 'Delete an entry', 'Expand the schema, add auth etc.', 'mmmartin','mmmartin', 8, 'todo'),
(9, CURRENT_TIMESTAMP, 'Detect Build Automatically', 'Automagically detect what build you are playing when giving feedback', 'mmmartin','mmmartin', 9, 'todo'),
(10, CURRENT_TIMESTAMP, 'Real time attachements', 'Capture and attach a screenshot of what’s on your screen in real time.', 'mmmartin','mmmartin', 10, 'todo'),
(11, CURRENT_TIMESTAMP, 'Integrate with task system', 'Integrate with a system that helps people manage and rank their tasks.', 'mmmartin','mmmartin', 11, 'todo');


-- (1, '2013-02-01 15:00:00', 'Sketch UI', 'Mockups for UI', 'mmmartin','mmmartin', 1, 'todo'),
-- (2, '2013-02-01 15:00:00', 'Get stuff displaying!', 'Display the tasks on a web page, ranked in priority order', 'mmmartin','mmmartin', 2, 'todo'),
-- (3, '2013-02-01 15:00:00', 'Let people add stuff!', 'Add a form to allow people to create their own tasks', 'mmmartin','mmmartin', 3, 'todo'),
-- (4, '2013-02-01 15:00:00', 'Let people prioritise stuff!', 'Let people drag and drop their taks to rank them', 'mmmartin','mmmartin', 4, 'todo'),
-- (5, '2013-02-01 15:00:00', 'Make it look bearable!', 'Tidy up the UI', 'mmmartin','mmmartin', 5, 'todo'),
-- (6, '2013-02-01 15:00:00', 'Iterate', 'Expand the schema, add auth etc.', 'mmmartin','mmmartin', 6, 'todo');
