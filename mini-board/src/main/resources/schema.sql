CREATE TABLE users (
`id` INT(10) NOT NULL AUTO_INCREMENT,
`username` VARCHAR(32) NOT NULL,
`password` VARCHAR(64) NOT NULL,
`email` VARCHAR(64) NOT NULL,
`created_at` DATETIME DEFAULT CURRENT_TIMESTAMP(),
`updated_at` DATETIME DEFAULT current_timestamp() ON UPDATE current_timestamp(),
PRIMARY KEY(id)
);

CREATE TABLE posts (
`id` INT(10) NOT NULL AUTO_INCREMENT,
`category_id` VARCHAR(32) NOT NULL,
`user_id` INT(10) NOT NULL,
`title` VARCHAR(64) NOT NULL,
`content` TEXT NOT NULL,
`view_count` INT(11),
`created_at` DATETIME DEFAULT CURRENT_TIMESTAMP(),
`updated_at` DATETIME DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP(),
PRIMARY KEY(id),
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE comments (
`id` INT(10) NOT NULL AUTO_INCREMENT,
`user_id` INT(10) NOT NULL,
`post_id` INT(10) NOT NULL,
`content` TEXT NOT NULL,
`created_at` DATETIME DEFAULT CURRENT_TIMESTAMP(),
PRIMARY KEY(id),
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (post_id) REFERENCES posts(id)
);

CREATE TABLE categories (
`id` INT(10) NOT NULL AUTO_INCREMENT,
`name` VARCHAR(32) NOT NULL,
PRIMARY KEY(id)
);