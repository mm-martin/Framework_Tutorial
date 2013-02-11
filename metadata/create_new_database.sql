DROP DATABASE IF EXISTS mm_work;
CREATE DATABASE `mm_work` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `mm_work`;

CREATE TABLE IF NOT EXISTS `task` (
	`task_id` int unsigned NOT NULL AUTO_INCREMENT,
	`reporter_id` int unsigned NOT NULL,
	`owner_id` int unsigned NOT NULL,
	`rank` int unsigned NOT NULL,
	`status_id` int unsigned NOT NULL,
	`project_id` int unsigned NOT NULL,
	`milestone_id` int unsigned NOT NULL,
	PRIMARY KEY (`task_id`)
) ENGINE=INNODB  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `summary` (
	`summary_id` int unsigned NOT NULL AUTO_INCREMENT,
	`task_id` int unsigned NOT NULL,
	`user_id` int unsigned NOT NULL,
	`summary_text` varchar(255) NOT NULL,
	PRIMARY KEY (`summary_id`)
) ENGINE=INNODB  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `comment` (
	`comment_id` int unsigned NOT NULL AUTO_INCREMENT,
	`task_id` int unsigned NOT NULL,
	`user_id` int unsigned NOT NULL,
	`summary_text` text NOT NULL,
	PRIMARY KEY (`comment_id`)
) ENGINE=INNODB  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `attachment` (
	`attachment_id` int unsigned NOT NULL AUTO_INCREMENT,
	`summary_id` int unsigned NOT NULL,
	`attachment_uri` varchar(255) NOT NULL,
	PRIMARY KEY (`attachment_id`)
) ENGINE=INNODB  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `status` (
	`status_id` int unsigned NOT NULL AUTO_INCREMENT,
	`status_name` char(15) NOT NULL,
	`status_description` text NOT NULL,
	PRIMARY KEY (`status_id`)
) ENGINE=INNODB  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `project` (
	`project_id` int unsigned NOT NULL AUTO_INCREMENT,
	`project_name` char(15) NOT NULL,
	`project_description` text NOT NULL,
	`project_icon_uri` varchar(255) NOT NULL,
	PRIMARY KEY (`project_id`)
) ENGINE=INNODB  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `milestone` (
	`milestone_id` int unsigned NOT NULL AUTO_INCREMENT,
	`project_id` int unsigned NOT NULL,
	`milestone_name` char(15) NOT NULL,
	`milestone_description` text NOT NULL,
	`milestone_icon_uri` varchar(255) NOT NULL,
	PRIMARY KEY (`milestone_id`)
) ENGINE=INNODB  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `task_event` (
	`event_id` int unsigned NOT NULL AUTO_INCREMENT,
	`event_task` int unsigned NOT NULL, 
	`event_type` int unsigned NOT NULL,
	`event_time` datetime NOT NULL,
	`event_actor` int unsigned NOT NULL,
	`old_value` int unsigned NOT NULL,
	`new_value` int unsigned NOT NULL,
	PRIMARY KEY (`event_id`)
) ENGINE=INNODB  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `event_type` (
	`event_type_id` int unsigned NOT NULL AUTO_INCREMENT,
	`event_name` char(15) NOT NULL,
	`event_table_name` char(15) NOT NULL,
	`event_description` varchar(255) NOT NULL,
	PRIMARY KEY (`event_type_id`)
) ENGINE=INNODB  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `user` (
	`user_id` int unsigned NOT NULL AUTO_INCREMENT,
	`user_name` char(15) NOT NULL,
	`full_name` varchar(255) NOT NULL,
	`password` char(15) NOT NULL,
	PRIMARY KEY (`user_id`)
) ENGINE=INNODB  DEFAULT CHARSET=utf8;

ALTER TABLE task ADD FOREIGN KEY (`reporter_id`) references user(`user_id`);
ALTER TABLE task ADD FOREIGN KEY (`owner_id`) references user(`user_id`);
ALTER TABLE task ADD FOREIGN KEY (`owner_id`) references user(`user_id`);
ALTER TABLE task ADD FOREIGN KEY (`status_id`) references status(`status_id`);
ALTER TABLE task ADD FOREIGN KEY (`project_id`) references project(`project_id`);
ALTER TABLE task ADD FOREIGN KEY (`milestone_id`) references milestone(`milestone_id`);

ALTER TABLE	summary ADD FOREIGN KEY (`task_id`) references task(`task_id`);
ALTER TABLE summary ADD FOREIGN KEY (`user_id`) references user(`user_id`);

ALTER TABLE comment ADD FOREIGN KEY (`task_id`) references task(`task_id`);
ALTER TABLE comment ADD FOREIGN KEY (`user_id`) references user(`user_id`);

ALTER TABLE attachment ADD FOREIGN KEY (`summary_id`) references comment(`task_id`);

ALTER TABLE	milestone ADD FOREIGN KEY (`project_id`) references project(`project_id`);

ALTER TABLE task_event ADD FOREIGN KEY (`event_task`) references task(`task_id`);
ALTER TABLE task_event ADD FOREIGN KEY (`event_type`) references event_type(`event_type_id`);
ALTER TABLE task_event ADD FOREIGN KEY (`event_actor`) references user(`user_id`);


INSERT INTO `user` (`user_id`,`user_name`, `full_name`, `password`) VALUES
(1, 'mmmartin', 'Martin Lynagh', 'bunnyfunster'),
(2, 'mmmarvin', 'Evil Twin of Martin Lynagh', 'bunnyfunster');
-- INSERT INTO `task` (`id`,`timecreated`, `summary`, `content`, `reporter`, `owner`, `rank`, `status`) VALUES
-- (1, `2013-02-01 15:00:00`, `Sketch UI`, `Mockups for UI`, `mmmartin`,`mmmartin`, 1, `todo`),
-- (2, `2013-02-01 15:00:00`, `Get stuff displaying!`, `Display the tasks on a web page, ranked in priority order`, `mmmartin`,`mmmartin`, 2, `todo`),
-- (3, `2013-02-01 15:00:00`, `Let people add stuff!`, `Add a form to allow people to create their own tasks`, `mmmartin`,`mmmartin`, 3, `todo`),
-- (4, `2013-02-01 15:00:00`, `Let people prioritise stuff!`, `Let people drag and drop their taks to rank them`, `mmmartin`,`mmmartin`, 4, `todo`),
-- (5, `2013-02-01 15:00:00`, `Make it look bearable!`, `Tidy up the UI`, `mmmartin`,`mmmartin`, 5, `todo`),
-- (6, `2013-02-01 15:00:00`, `Iterate`, `Expand the schema, add auth etc.`, `mmmartin`,`mmmartin`, 6, `todo`);
