SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS topchef;
CREATE SCHEMA topchef;
USE topchef;

CREATE TABLE images (
    images_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    imageData BLOB,
    lect_description VARCHAR(50) NOT NULL,
    PRIMARY KEY(images_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE cooks (
    cook_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    cook_name VARCHAR(45) NOT NULL,
    cook_surname VARCHAR(45) NOT NULL,
    contact_number CHAR(10) NOT NULL,
    date_of_birth CHAR(10) NOT NULL,
    age INT NOT NULL,
    image_id INT UNSIGNED,
    professional_level VARCHAR(45) NOT NULL,
    PRIMARY KEY (cook_id),
    KEY idx_cook_last_name (cook_surname),
    FOREIGN KEY (image_id) REFERENCES images(images_id) ON DELETE RESTRICT ON UPDATE CASCADE
    )ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE INDEX cook_id_index ON cooks(cook_id);
    
CREATE TABLE national_cuisine(
	cuisine_name VARCHAR(45) NOT NULL,
    cuisine_id int NOT NULL,
    recipe_id INT UNSIGNED NOT NULL REFERENCES recipes(recipe_id),
    cook_id int NOT NULL REFERENCES cooks(cook_id),
    KEY idx_recipe_id (recipe_id),
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE thematikes_enotites (
    thematikes_enotites_name VARCHAR(45) NOT NULL,
    description VARCHAR(45) 
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE recipes (
  recipe_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  recipe_name VARCHAR(45) NOT NULL,
  short_description VARCHAR(100) NOT NULL,
  national_cousine VARCHAR(45) NOT NULL,
  type_of_recipe VARCHAR(45) NOT NULL,
  difficulty int NOT NULL,
  tip_1 VARCHAR(100),
  tip_2 VARCHAR(100),
  tip_3 VARCHAR(100),
  preparetion_time int NOT NULL,
  cooking_time int NOT NULL,
  portions int NOT NULL,
  key_ingredient VARCHAR(45) NOT NULL,
  image_id int UNSIGNED,
  thematikh_enothta VARCHAR(45),
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (recipe_id)
  #CONSTRAINT  check_difficulty CHECK (difficulty IN (1, 2, 3, 4, 5)),
  #CONSTRAINT  check_type CHECK (type_of_recipe IN ("sweet","sour")),
  #KEY idx_image_id (image_id),
  #FOREIGN KEY (image_id) REFERENCES images(images_id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE INDEX recipe_id_index ON recipes (recipe_id);


CREATE TABLE contestant_pool (
    pool_id INT NOT NULL,
    cuisine_id int NOT NULL REFERENCES national_cuisine(cuisine_id) ,
    cook_id INT UNSIGNED NOT NULL REFERENCES cooks(cook_id),
    recipe_id INT UNSIGNED NOT NULL REFERENCES recipes(recipe_id),
    p1 int,
    p2 int,
    p3 int,
    sum_points INT,
    #PRIMARY KEY (pool_id),
    KEY idx_recipe_id (recipe_id),
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    #KEY idx_cuisine_id (cuisine_id),
	#FOREIGN KEY (cuisine_id) REFERENCES national_cuisine(cuisine_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    KEY idx_cook_id (cook_id),
	FOREIGN KEY (cook_id) REFERENCES cooks(cook_id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;




CREATE TABLE episodes (
    ep_id INT,
    pool_id INT,
    judge1_id INT,
    judge2_id INT,
    judge3_id int,
    winner_id INT,
    year_of_prod INT
    #PRIMARY KEY (ep_id)
    #FOREIGN KEY (pool_id) REFERENCES contestant_pool(pool_id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE INDEX ep_id_index ON episodes (ep_id);
CREATE INDEX pool_id_index ON episodes(pool_id);

create table judges(
judge_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
cook_id int,
ep_id int ,
PRIMARY KEY (judge_id),
#FOREIGN KEY (pool_id) REFERENCES contestant_pool(pool_id) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (ep_id) REFERENCES episodes(ep_id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE labels (
  label_name VARCHAR(45),
  label_id int NOT NULL,
  recipe_id INT UNSIGNED NOT NULL REFERENCES recipes(recipe_id),
  PRIMARY KEY  (label_id),
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE RESTRICT ON UPDATE CASCADE
  #CONSTRAINT `fk_recipe_id` FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE RESTRICT ON UPDATE CASCADE
  )ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE meals (
  recipe_id INT UNSIGNED NOT NULL REFERENCES recipes(recipe_id),
  category VARCHAR(45) NOT NULL,
  recipe_name VARCHAR(45),
  image_id INT UNSIGNED NOT NULL REFERENCES images(image_id),
  CONSTRAINT check_name CHECK (recipe_name IN (recipe_name)),
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (image_id) REFERENCES images(images_id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE equipment (
  equipment_id int NOT NULL,
  equipment_name VARCHAR(45),
  recipe_id INT UNSIGNED NOt NULL REFERENCES recipes(recipe_id),
  instructions VARCHAR(150),
  image_id INT UNSIGNED NOT NULL,
  PRIMARY KEY  (equipment_id),
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (image_id) REFERENCES images(images_id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE steps (
  step_id int NOT NULL,
  short_description VARCHAR(150),
  recipe_id INT UNSIGNED NOT NULL REFERENCES recipes(recipe_id),
  step_number int NOT NULL,
  PRIMARY KEY  (step_id),
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE food_groups (
	group_name VARCHAR(45) NOT NULL,
    description VARCHAR(150),
    image_id INT UNSIGNED NOT NULL REFERENCES images(image_id)
	#FOREIGN KEY (image_id) REFERENCES images(images_id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE ingredients (
  name VARCHAR(45) NOT NULL,
  quantity VARCHAR(45) NOT NULL,
  recipe_id INT UNSIGNED NOT NULL REFERENCES recipes(recipe_id),
  food_group VARCHAR(45) NOT NULL,
  calories_per_100g int NOT NULL,
  image_id INT UNSIGNED NOT NULL REFERENCES images(image_id),
  CONSTRAINT  check_food_group CHECK (food_group IN ('Grains', 'Sweets', 'Baking', 'Condiments', 'Proteins', 'Dairy', 'Oils', 'Meats', 'Beverages', 'Seafood', 'Vegetables', 'Nuts', 'Fruits', 'Herbs', 'Spices', 'Baking Ingredients', 'Sweeteners', 'Protein', 'Flavorings', 'Soup Base', 'Sauces', 'Produce', 'Alcohol')),
  #PRIMARY KEY  (name)
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE nutritial_info (
  recipe_id INT UNSIGNED NOT NULL REFERENCES recipes(recipe_id),
  fat_per_portion int NOT NULL,
  protein_per_portion int NOT NULL,
  carbohydrates_per_portion int NOT NULL,
  total_cal_per_portion int NOT NULL,
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE INDEX recipe_id_index ON contestant_pool (recipe_id);
CREATE INDEX recipe_id_index ON equipment (recipe_id);
CREATE INDEX pool_id_index ON contestant_pool (pool_id);
CREATE INDEX cook_id_index ON contestant_pool(cook_id);

#
#
#
#
#
#
#INSERT DATA
insert into thematikes_enotites(thematikes_enotites_name, description) values
	("exotic plates","exotic dishes from around the world"),
    ("mom's recipies","recipes we loved as kids"),
    ("casual sunday","easy recipies for a casual sunday"),
    ("best for the gym","recipes to built muscle"),
    ("fancy dinner","recipes to impress");


INSERT INTO cooks (cook_name, cook_surname, contact_number, date_of_birth, age, image_id, professional_level) VALUES
('John', 'Doe', '1234567890', '1990-05-15', 31, 1, 'Intermediate'),
('Alice', 'Smith', '9876543210', '1985-08-20', 36, 2, 'Expert'),
('Michael', 'Johnson', '5551234567', '1982-11-10', 39, 3, 'Advanced'),
('Emily', 'Brown', '3334567890', '1995-02-25', 27, 4, 'Intermediate'),
('Daniel', 'Martinez', '7778889999', '1988-07-12', 33, 5, 'Expert'),
('Sophia', 'Garcia', '6665554444', '1992-09-30', 29, 6, 'Intermediate'),
('William', 'Lopez', '1112223333', '1983-04-05', 38, 7, 'Advanced'),
('Olivia', 'Hernandez', '9998887777', '1998-12-20', 23, 8, 'Beginner'),
('James', 'Young', '4445556666', '1993-06-18', 28, 9, 'Intermediate'),
('Emma', 'White', '2223334444', '1996-03-10', 26, 10, 'Expert'),
('Alexander', 'Miller', '8887776666', '1980-01-05', 41, 11, 'Intermediate'),
('Ava', 'Jones', '7776665555', '1989-10-15', 32, 12, 'Advanced'),
('Ethan', 'Davis', '5556667777', '1997-07-20', 24, 13, 'Beginner'),
('Isabella', 'Gonzalez', '1112223333', '1987-04-30', 34, 14, 'Intermediate'),
('Mia', 'Rodriguez', '3334445555', '1994-08-25', 27, 15, 'Expert'),
('Michael', 'Wilson', '9998887777', '1984-11-10', 37, 16, 'Advanced'),
('Sophia', 'Taylor', '6667778888', '1991-01-15', 30, 17, 'Intermediate'),
('Jacob', 'Anderson', '2223334444', '1986-06-20', 35, 18, 'Beginner'),
('Emily', 'Thomas', '8889990000', '1999-03-05', 22, 19, 'Expert'),
('Matthew', 'Harris', '4445556666', '1981-09-30', 30, 20, 'Intermediate'),
('Charlotte', 'Clark', '5556667777', '1988-04-18', 33, 21, 'Advanced'),
('Amelia', 'Lewis', '6667778888', '1993-07-25', 28, 22, 'Intermediate'),
('Benjamin', 'Lee', '7778889999', '1990-02-10', 31, 23, 'Expert'),
('Daniel', 'Walker', '1112223333', '1985-05-20', 36, 24, 'Advanced'),
('Harper', 'Green', '8889990000', '1996-08-15', 25, 25, 'Beginner'),
('Evelyn', 'Baker', '3334445555', '1991-11-30', 30, 26, 'Intermediate'),
('Logan', 'Gonzales', '4445556666', '1989-03-18', 32, 27, 'Expert'),
('Michael', 'Nelson', '7778889999', '1983-06-25', 38, 28, 'Advanced'),
('Oliver', 'Carter', '2223334444', '1998-09-10', 23, 29, 'Intermediate'),
('Abigail', 'Mitchell', '6667778888', '1980-12-20', 29, 30, 'Beginner'),
('Sophia', 'Perez', '3334445555', '1997-05-05', 24, 31, 'Expert'),
('Alexander', 'Roberts', '1112223333', '1984-08-15', 37, 32, 'Advanced'),
('Charlotte', 'Turner', '9998887777', '1987-01-30', 34, 33, 'Intermediate'),
('Emma', 'Phillips', '4445556666', '1990-04-18', 31, 34, 'Beginner'),
('Lucas', 'Campbell', '8889990000', '1993-07-10', 28, 35, 'Expert'),
('Isabella', 'Parker', '5556667777', '1982-10-25', 39, 36, 'Advanced'),
('Mia', 'Evans', '6667778888', '1995-01-15', 26, 37, 'Intermediate'),
('Noah', 'Edwards', '7778889999', '1981-04-30', 40, 38, 'Beginner'),
('William', 'Collins', '2223334444', '1994-09-10', 27, 39, 'Expert'),
('Ava', 'Stewart', '1112223333', '1986-12-20', 35, 40, 'Advanced'),
('Logan', 'Morris', '9998887777', '1999-05-05', 22, 41, 'Intermediate'),
('Amelia', 'Watson', '3334445555', '1988-08-15', 23, 42, 'Beginner'),
('Harper', 'Brooks', '4445556666', '1991-11-30', 20, 43, 'Expert'),
('Benjamin', 'Price', '7778889999', '1984-02-10', 27, 44, 'Advanced'),
('Evelyn', 'Sanders', '2223334444', '1997-05-20', 24, 45, 'Intermediate'),
('Lucas', 'Wood', '6667778888', '1989-08-05', 32, 26, 'Beginner'),
('Oliver', 'Bennett', '5556667777', '1992-11-18', 29, 47, 'Expert'),
('Abigail', 'Rossi', '8889990000', '1985-02-15', 36, 48, 'Advanced'),
('Charlotte', 'Marshall', '1112223333', '1990-07-30', 31, 49, 'Intermediate'),
('Emma', 'Fisher', '4445556666', '1983-10-18', 28, 50, 'Beginner');


INSERT INTO equipment (equipment_id, equipment_name, recipe_id, instructions, image_id) VALUES
(1, 'Mixing bowl', 1, 'To mix', 1),
(2, 'Electric mixer', 1, 'To mix batter', 2),
(3, 'Cake pans', 1, 'To bake cake layers', 3),
(4, 'Oven', 1, 'To bake cake layers', 4),
(5, 'Cooling racks', 1, 'To cool cake layers', 5),
(6, 'Spatula', 1, 'To frost cake', 6),
(7, 'Frosting tools', 1, 'To frost cake', 7),
(8, 'Large pot', 2, 'To boil pasta', 8),
(9, 'Skillet or sauté pan', 2, 'To cook bacon/pancetta', 9),
(10, 'Mixing bowl', 2, 'To mix ingredients', 1),
(11, 'Tongs', 2, 'To toss pasta with sauce', 10),
(12, 'Mixing bowls', 3, 'To mix ingredients', 1),
(13, 'Electric mixer', 3, 'To mix mascarpone mixture', 2),
(14, 'Shallow dish', 3, 'To dip ladyfingers', 11),
(15, 'Serving dish', 3, 'To serve tiramisu', 12),
(16, 'Wok or large skillet', 4, 'To stir-fry ingredients', 13),
(17, 'Spatula or wok spatula', 4, 'To stir-fry ingredients', 6),
(18, 'Mixing bowls', 4, 'To mix sauce ingredients', 1),
(19, 'Tongs', 4, 'To toss noodles with sauce', 10),
(20, 'Pie dish', 5, 'To bake pie', 14),
(21, 'Rolling pin', 5, 'To roll out pie crust', 15),
(22, 'Pastry cutter or fork', 5, 'To crimp pie edges', 16),
(23, 'Mixing bowls', 5, 'To mix filling ingredients', 1),
(24, 'Peeler', 5, 'To peel apples', 17),
(25, 'Knife', 5, 'To slice apples', 18),
(26, 'Bamboo sushi mat', 6, 'To roll sushi rolls', 19),
(27, 'Sharp knife', 6, 'To cut sushi rolls', 20),
(28, 'Plastic wrap', 6, 'To roll sushi rolls', 21),
(29, 'Sushi rice paddle', 6, 'To spread sushi rice', 22),
(30, 'Cutting board', 6, 'To prepare ingredients', 23),
(31, 'Baking dish', 7, 'To bake baklava', 24),
(32, 'Pastry brush', 7, 'To brush layers with butter', 25),
(33, 'Saucepan', 7, 'To make syrup', 26),
(34, 'Knife', 7, 'To cut baklava into pieces', 18),
(35, 'Cutting board', 7, 'To prepare ingredients', 23),
(36, 'Soup pot', 8, 'To cook soup', 27),
(37, 'Ladle', 8, 'To serve soup', 28),
(38, 'Knife', 8, 'To prepare ingredients', 18),
(39, 'Cutting board', 8, 'To prepare ingredients', 23),
(40, 'Baking sheets', 9, 'To bake cookies', 29),
(41, 'Parchment paper or silicone baking mat', 9, 'To line baking sheets', 30),
(42, 'Mixing bowls', 9, 'To mix dough', 1),
(43, 'Electric mixer', 9, 'To cream butter and sugar', 2),
(44, 'Cookie scoop', 9, 'To portion cookie dough', 31),
(45, 'Baking dish', 10, 'To bake soup', 32),
(46, 'Soup pot', 10, 'To cook soup', 27),
(47, 'Ladle', 10, 'To serve soup', 28),
(48, 'Knife', 10, 'To prepare ingredients', 18),
(49, 'Cutting board', 10, 'To prepare ingredients', 23),
(50, 'Soup pot', 11, 'To cook soup', 27),
(51, 'Ladle', 11, 'To serve soup', 28),
(52, 'Knife', 11, 'To prepare ingredients', 18),
(53, 'Cutting board', 11, 'To prepare ingredients', 23),
(54, 'Pie dish', 12, 'To bake pie', 14),
(55, 'Mixing bowls', 12, 'To mix ingredients', 1),
(56, 'Whisk', 12, 'To mix filling ingredients', 32),
(57, 'Citrus juicer', 12, 'To juice limes', 33),
(58, 'Microplane grater', 12, 'To zest limes', 34),
(59, 'Skillet or sauté pan', 13, 'To cook beef', 9),
(60, 'Tongs', 13, 'To flip beef', 10),
(61, 'Mixing bowls', 13, 'To mix ingredients', 1),
(62, 'Pot', 13, 'To boil rice', 35),
(63, 'Rolling pin', 14, 'To roll out dough', 15),
(64, 'Baking sheets', 14, 'To bake cookies', 29),
(65, 'Parchment paper or silicone baking mat', 14, 'To line baking sheets', 30),
(66, 'Mixing bowls', 14, 'To mix dough', 1),
(67, 'Electric mixer', 14, 'To cream butter and sugar', 2),
(68, 'Cookie scoop', 14, 'To portion cookie dough', 31),
(69, 'Large pot', 15, 'To boil pasta', 8),
(70, 'Skillet or sauté pan', 15, 'To cook vegetables', 9),
(71, 'Mixing bowls', 15, 'To mix sauce ingredients', 1),
(72, 'Tongs', 15, 'To toss pasta with sauce', 10),
(73, 'Springform pan', 16, 'To bake cheesecake', 36),
(74, 'Electric mixer', 16, 'To mix ingredients', 2),
(75, 'Mixing bowls', 16, 'To mix ingredients', 1),
(76, 'Spatula', 16, 'To smooth batter', 6),
(77, 'Dutch oven or large pot', 17, 'To cook ratatouille', 37),
(78, 'Skillet or sauté pan', 17, 'To cook vegetables', 9),
(79, 'Knife', 17, 'To prepare ingredients', 18),
(80, 'Cutting board', 17, 'To prepare ingredients', 23),
(81, 'Skillet or sauté pan', 18, 'To cook tacos', 9),
(82, 'Tongs', 18, 'To flip tacos', 10),
(83, 'Mixing bowls', 18, 'To mix ingredients', 1),
(84, 'Serving plates or tortilla warmer', 18, 'To serve tacos', 38),
(85, 'Baking sheet', 19, 'To bake pavlova', 39),
(86, 'Parchment paper', 19, 'To line baking sheet', 40),
(87, 'Electric mixer', 19, 'To whip meringue', 2),
(88, 'Mixing bowls', 19, 'To mix ingredients', 1),
(89, 'Spatula', 19, 'To shape pavlova', 6),
(90, 'Bamboo sushi mat', 20, 'To roll sushi burrito', 19),
(91, 'Sharp knife', 20, 'To cut sushi burrito', 20),
(92, 'Plastic wrap', 20, 'To roll sushi burrito', 21),
(93, 'Sushi rice paddle', 20, 'To spread sushi rice', 22),
(94, 'Cutting board', 20, 'To prepare ingredients', 23),
(95, 'Large pot', 21, 'To cook risotto', 8),
(96, 'Ladle', 21, 'To stir risotto', 28),
(97, 'Stirring spoon', 21, 'To stir risotto', 41),
(98, 'Mixing bowls', 21, 'To mix ingredients', 1),
(99, 'Baking dish', 22, 'To bake biryani', 42),
(100, 'Spatula', 22, 'To spread biryani', 6),
(101, 'Mixing bowls', 22, 'To mix ingredients', 1),
(102, 'Serving plates or bowls', 22, 'To serve biryani', 38),
(103, 'Baking dish', 23, 'To bake lemon bars', 43),
(104, 'Mixing bowls', 23, 'To mix ingredients', 1),
(105, 'Spatula', 23, 'To spread batter', 6),
(106, 'Citrus juicer', 23, 'To juice lemons', 33),
(107, 'Knife', 23, 'To slice lemon bars', 18),
(108, 'Cutting board', 23, 'To prepare ingredients', 23),
(109, 'Blender or food processor', 24, 'To blend ingredients', 44),
(110, 'Mixing bowls', 24, 'To mix ingredients', 1),
(111, 'Knife', 24, 'To prepare ingredients', 18),
(112, 'Cutting board', 24, 'To prepare ingredients', 23),
(113, 'Skillet or sauté pan', 25, 'To cook chicken', 9),
(114, 'Mixing bowls', 25, 'To mix ingredients', 1),
(115, 'Tongs', 25, 'To flip chicken', 10),
(116, 'Knife', 25, 'To prepare ingredients', 18),
(117, 'Cutting board', 25, 'To prepare ingredients', 23),
(118, 'Ramekins', 26, 'To bake creme brulee', 45),
(119, 'Kitchen torch', 26, 'To caramelize sugar', 46),
(120, 'Mixing bowls', 26, 'To mix ingredients', 1),
(121, 'Fine mesh strainer', 26, 'To strain custard', 47),
(122, 'Skewers', 27, 'To skewer chicken', 48),
(123, 'Grill or grill pan', 27, 'To grill chicken', 49),
(124, 'Mixing bowls', 27, 'To mix marinade', 1),
(125, 'Tongs', 27, 'To flip chicken', 10),
(126, 'Pie dish', 28, 'To bake pie', 14),
(127, 'Mixing bowls', 28, 'To mix ingredients', 1),
(128, 'Whisk', 28, 'To mix filling ingredients', 32),
(129, 'Citrus juicer', 28, 'To juice lemons', 33),
(130, 'Microplane grater', 28, 'To zest lemons', 34),
(131, 'Baking sheet', 29, 'To bake beef wellington', 50),
(132, 'Pastry brush', 29, 'To brush pastry with egg wash', 25),
(133, 'Knife', 29, 'To slice beef wellington', 18),
(134, 'Cutting board', 29, 'To prepare ingredients', 23),
(135, 'Large pot', 30, 'To boil pasta', 8),
(136, 'Skillet or sauté pan', 30, 'To cook sauce', 9),
(137, 'Mixing bowls', 30, 'To mix ingredients', 1),
(138, 'Tongs', 30, 'To toss pasta with sauce', 10),
(139, 'Springform pan', 31, 'To bake cheesecake', 36),
(140, 'Electric mixer', 31, 'To mix ingredients', 2),
(141, 'Mixing bowls', 31, 'To mix ingredients', 1),
(142, 'Spatula', 31, 'To smooth batter', 6),
(143, 'Dutch oven or large pot', 32, 'To cook ratatouille', 37),
(144, 'Skillet or sauté pan', 32, 'To cook vegetables', 9),
(145, 'Knife', 32, 'To prepare ingredients', 18),
(146, 'Cutting board', 32, 'To prepare ingredients', 23),
(147, 'Skillet or sauté pan', 33, 'To cook eggs and tomato sauce', 9),
(148, 'Mixing bowls', 33, 'To mix ingredients', 1),
(149, 'Spatula', 33, 'To serve shakshuka', 6),
(150, 'Baking dish', 34, 'To bake moussaka', 51),
(151, 'Skillet or sauté pan', 34, 'To cook meat sauce', 9),
(152, 'Knife', 34, 'To slice moussaka', 18),
(153, 'Cutting board', 34, 'To prepare ingredients', 23),
(154, 'Ramekins', 35, 'To bake lava cake', 52),
(155, 'Baking sheet', 35, 'To place ramekins', 29),
(156, 'Mixing bowls', 35, 'To mix ingredients', 1),
(157, 'Whisk', 35, 'To mix batter', 32),
(158, 'Skewers or rotisserie', 36, 'To cook tacos al pastor', 53),
(159, 'Grill or grill pan', 36, 'To cook tacos al pastor', 49),
(160, 'Serving plates or tortilla warmer', 36, 'To serve tacos al pastor', 38),
(161, 'Large pot', 37, 'To cook risotto', 8),
(162, 'Ladle', 37, 'To stir risotto', 28),
(163, 'Stirring spoon', 37, 'To stir risotto', 41),
(164, 'Mixing bowls', 37, 'To mix ingredients', 1),
(165, 'Crepe pan or skillet', 38, 'To cook crepes', 54),
(166, 'Spatula', 38, 'To flip crepes', 6),
(167, 'Mixing bowls', 38, 'To mix batter', 1),
(168, 'Ladle', 38, 'To pour batter', 55),
(169, 'Skewers', 39, 'To skewer chicken', 56),
(170, 'Grill or grill pan', 39, 'To grill chicken', 49),
(171, 'Mixing bowls', 39, 'To mix marinade', 1),
(172, 'Tongs', 39, 'To flip chicken', 10),
(173, 'Large pot', 40, 'To cook vegetables', 8),
(174, 'Skillet or sauté pan', 40, 'To cook vegetables', 9),
(175, 'Serving plates or bowls', 40, 'To serve pav bhaji', 38),
(176, 'Dutch oven or large pot', 41, 'To cook coq au vin', 37),
(177, 'Skillet or sauté pan', 41, 'To cook vegetables', 9),
(178, 'Knife', 41, 'To prepare ingredients', 18),
(179, 'Cutting board', 41, 'To prepare ingredients', 23),
(180, 'Baking dish', 42, 'To bake cinnamon rolls', 57),
(181, 'Rolling pin', 42, 'To roll out dough', 15),
(182, 'Mixing bowls', 42, 'To mix dough', 1),
(183, 'Knife', 42, 'To slice cinnamon rolls', 18),
(184, 'Cutting board', 42, 'To prepare ingredients', 23),
(185, 'Large pot', 43, 'To cook broth', 8),
(186, 'Ladle', 43, 'To serve ramen', 28),
(187, 'Strainer', 43, 'To strain noodles', 58),
(188, 'Serving bowls', 43, 'To serve ramen', 38),
(189, 'Baking dish', 44, 'To bake apple crisp', 59),
(190, 'Mixing bowls', 44, 'To mix filling', 1),
(191, 'Spatula', 44, 'To spread topping', 6),
(192, 'Knife', 44, 'To slice apple crisp', 18),
(193, 'Cutting board', 44, 'To prepare ingredients', 23),
(194, 'Large pot', 45, 'To boil pasta', 8),
(195, 'Skillet or sauté pan', 45, 'To cook sauce', 9),
(196, 'Mixing bowls', 45, 'To mix sauce ingredients', 1),
(197, 'Tongs', 45, 'To toss pasta with sauce', 10),
(198, 'Springform pan', 46, 'To bake cheesecake', 36),
(199, 'Electric mixer', 46, 'To mix ingredients', 2),
(200, 'Mixing bowls', 46, 'To mix ingredients', 1),
(201, 'Spatula', 46, 'To smooth batter', 6),
(202, 'Skillet or sauté pan', 47, 'To cook shrimp', 9),
(203, 'Tongs', 47, 'To flip shrimp', 10),
(204, 'Mixing bowls', 47, 'To mix ingredients', 1),
(205, 'Serving dish', 47, 'To serve shrimp scampi', 12),
(206, 'Mixing bowls', 48, 'To mix ingredients', 1),
(207, 'Electric mixer', 48, 'To whip cream', 2),
(208, 'Serving cups or glasses', 48, 'To serve chocolate mousse', 38),
(209, 'Large soup pot', 49, 'To cook soup', 60),
(210, 'Ladle', 49, 'To serve soup', 28),
(211, 'Knife', 49, 'To prepare ingredients', 18),
(212, 'Cutting board', 49, 'To prepare ingredients', 23),
(213, 'Skillet or sauté pan', 50, 'To cook beef', 9),
(214, 'Tongs', 50, 'To flip beef', 10),
(215, 'Mixing bowls', 50, 'To mix ingredients', 1),
(216, 'Serving plates or tortilla warmer', 50, 'To serve beef tacos', 38);


INSERT INTO food_groups (group_name, description, image_id) VALUES
('Grains', 'Foods made from wheat, rice, oats, cornmeal, barley, or other cereal grains.', 1),
('Sweets', 'Desserts and sweet treats such as cakes, cookies, candies, and pastries.', 2),
('Baking', 'Ingredients used for baking, including flour, sugar, baking powder, and yeast.', 3),
('Condiments', 'Sauces, spreads, and seasonings used to add flavor to dishes.', 4),
('Proteins', 'Foods rich in protein, including meat, poultry, fish, tofu, and legumes.', 5),
('Dairy', 'Milk and milk products such as cheese, yogurt, and butter.', 6),
('Oils', 'Edible fats used for cooking and flavoring, such as olive oil, vegetable oil, and coconut oil.', 7),
('Meats', 'Various types of meat, including beef, pork, lamb, and game meats.', 8),
('Beverages', 'Drinks such as water, juice, tea, coffee, soda, and alcoholic beverages.', 9),
('Seafood', 'Various types of fish and shellfish, including salmon, shrimp, and tuna.', 10),
('Vegetables', 'Edible plants or parts of plants, including roots, stems, leaves, and flowers.', 11),
('Nuts', 'Edible seeds or fruits enclosed in a hard or tough shell, such as almonds, peanuts, and walnuts.', 12),
('Fruits', 'Sweet and flavorful products of flowering plants, typically containing seeds.', 13),
('Herbs', 'Leaves, stems, or flowers of plants used for flavoring, scenting, or medicinal purposes.', 14),
('Spices', 'Aromatic substances from the bark, roots, seeds, buds, or fruits of plants.', 15),
('Baking Ingredients', 'Ingredients specifically used for baking, such as flour, sugar, and baking powder.', 16),
('Sweeteners', 'Substances used to sweeten foods and beverages, such as sugar, honey, and syrup.', 17),
('Protein', 'Foods rich in protein, including meat, poultry, fish, tofu, and legumes.', 18),
('Flavorings', 'Substances used to enhance or add flavor to foods and beverages, such as vanilla extract and spices.', 19),
('Soup Base', 'The foundation of soups, typically consisting of broth, stock, or water.', 20),
('Sauces', 'Liquid or semi-solid condiments used to add flavor, moisture, and visual appeal to dishes.', 21),
('Produce', 'Fresh fruits and vegetables produced by farming or gardening.', 22),
('Alcohol', 'Beverages containing ethanol, typically produced by fermentation of sugars by yeast.', 23);
INSERT INTO ingredients (name, quantity, recipe_id, food_group, calories_per_100g, image_id) VALUES
-- Chocolate Cake
('Flour', '2 cups', 1, 'Grains', 364, 1),
('Sugar', '2 cups', 1, 'Sweets', 387, 2),
('Cocoa Powder', '3/4 cup', 1, 'Sweets', 228, 3),
('Baking Powder', '2 teaspoons', 1, 'Baking', 15, 4),
('Baking Soda', '1 1/2 teaspoons', 1, 'Baking', 0, 5),
('Salt', '1 teaspoon', 1, 'Condiments', 0, 6),
('Eggs', '2', 1, 'Proteins', 143, 7),
('Milk', '1 cup', 1, 'Dairy', 42, 8),
('Vegetable Oil', '1/2 cup', 1, 'Oils', 884, 9),
('Vanilla Extract', '2 teaspoons', 1, 'Condiments', 288, 10),
('Butter', '1/2 cup', 1, 'Dairy', 717, 11),
('Cream Cheese', '8 oz', 1, 'Dairy', 342, 12),
('Powdered Sugar', '4 cups', 1, 'Sweets', 389, 13),

-- Spaghetti Carbonara
('Spaghetti', '8 oz', 2, 'Grains', 131, 14),
('Pancetta', '4 oz', 2, 'Meats', 319, 15),
('Eggs', '3', 2, 'Proteins', 143, 7),
('Parmesan Cheese', '1 cup', 2, 'Dairy', 431, 16),
('Black Pepper', '1 teaspoon', 2, 'Condiments', 251, 17),
('Salt', '1/2 teaspoon', 2, 'Condiments', 0, 6),

-- Tiramisu
('Ladyfinger Biscuits', '24', 3, 'Grains', 371, 18),
('Espresso', '1 cup', 3, 'Beverages', 0, 19),
('Rum', '1/4 cup', 3, 'Beverages', 231, 20),
('Mascarpone Cheese', '16 oz', 3, 'Dairy', 429, 21),
('Heavy Cream', '1 cup', 3, 'Dairy', 345, 22),
('Granulated Sugar', '1/2 cup', 3, 'Sweets', 387, 23),
('Vanilla Extract', '1 teaspoon', 3, 'Condiments', 288, 10),
('Cocoa Powder', '2 tablespoons', 3, 'Sweets', 228, 3),

-- Pad Thai
('Rice Noodles', '8 oz', 4, 'Grains', 192, 24),
('Shrimp', '1/2 lb', 4, 'Seafood', 84, 25),
('Firm Tofu', '8 oz', 4, 'Proteins', 144, 26),
('Bean Sprouts', '1 cup', 4, 'Vegetables', 31, 27),
('Green Onions', '1/4 cup', 4, 'Vegetables', 23, 28),
('Garlic', '3 cloves', 4, 'Vegetables', 149, 29),
('Eggs', '2', 4, 'Proteins', 143, 7),
('Peanuts', '1/4 cup', 4, 'Nuts', 567, 30),
('Lime', '1', 4, 'Fruits', 30, 31),
('Cilantro', '1/4 cup', 4, 'Herbs', 23, 32),
('Fish Sauce', '3 tablespoons', 4, 'Condiments', 0, 33),
('Tamarind Paste', '2 tablespoons', 4, 'Condiments', 120, 34),
('Brown Sugar', '2 tablespoons', 4, 'Sweets', 380, 35),
('Vegetable Oil', '2 tablespoons', 4, 'Oils', 884, 9),
('Red Chili Flakes', '1/2 teaspoon', 4, 'Spices', 282, 36),
('Salt', '1/2 teaspoon', 4, 'Condiments', 0, 6),

-- Apple Pie
('Pie Crust', '2', 5, 'Grains', 384, 37),
('Apples', '6', 5, 'Fruits', 52, 38),
('Granulated Sugar', '3/4 cup', 5, 'Sweets', 387, 23),
('Brown Sugar', '1/4 cup', 5, 'Sweets', 380, 35),
('Cinnamon', '1 teaspoon', 5, 'Spices', 247, 39),
('Nutmeg', '1/4 teaspoon', 5, 'Spices', 525, 40),
('Butter', '2 tablespoons', 5, 'Dairy', 717, 11),
('All-Purpose Flour', '2 tablespoons', 5, 'Grains', 364, 1),

-- Sushi Rolls
('Sushi Rice', '2 cups', 6, 'Grains', 130, 41),
('Nori Sheets', '5', 6, 'Seafood', 33, 42),
('Raw Fish (e.g., Tuna, Salmon)', '1/2 lb', 6, 'Seafood', 142, 43),
('Cucumber', '1', 6, 'Vegetables', 16, 44),
('Avocado', '1', 6, 'Vegetables', 160, 45),
('Soy Sauce', '1/4 cup', 6, 'Condiments', 67, 46),
('Wasabi', '2 teaspoons', 6, 'Condiments', 66, 47),
('Pickled Ginger', '1/4 cup', 6, 'Vegetables', 28, 48),
('Rice Vinegar', '2 tablespoons', 6, 'Condiments', 18, 49),
('Sugar', '1 tablespoon', 6, 'Sweets', 387, 23),

-- Baklava
('Phyllo Dough', '1 lb', 7, 'Grains', 299, 50),
('Walnuts', '2 cups', 7, 'Nuts', 654, 51),
('Butter', '1 cup', 7, 'Dairy', 717, 11),
('Granulated Sugar', '1 cup', 7, 'Sweets', 387, 23),
('Water', '1 cup', 7, 'Beverages', 0, 52),
('Honey', '1 cup', 7, 'Sweets', 304, 53),
('Lemon Juice', '1/4 cup', 7, 'Fruits', 22, 54),
('Cinnamon', '1 teaspoon', 7, 'Spices', 247, 39),

-- Tom Yum Soup
('Chicken Broth', '4 cups', 8, 'Meats', 7, 55),
('Lemongrass', '2 stalks', 8, 'Herbs', 99, 56),
('Galangal', '3 slices', 8, 'Vegetables', 30, 57),
('Kaffir Lime Leaves', '4', 8, 'Vegetables', 43, 58),
('Thai Chilies', '2', 8, 'Vegetables', 40, 59),
('Mushrooms', '1 cup', 8, 'Vegetables', 22, 60),
('Tomatoes', '1/2 cup', 8, 'Vegetables', 18, 61),
('Fish Sauce', '3 tablespoons', 8, 'Condiments', 0, 33),
('Lime Juice', '2 tablespoons', 8, 'Fruits', 30, 31),
('Sugar', '1 tablespoon', 8, 'Sweets', 387, 23),
('Cilantro', '1/4 cup', 8, 'Herbs', 23, 32),
('Shrimp', '1/2 lb', 8, 'Seafood', 84, 25),

-- Chocolate Chip Cookies
('All-Purpose Flour', '2 1/4 cups', 9, 'Grains', 364, 1),
('Baking Soda', '1 teaspoon', 9, 'Baking', 0, 5),
('Salt', '1/2 teaspoon', 9, 'Condiments', 0, 6),
('Unsalted Butter', '1 cup', 9, 'Dairy', 717, 11),
('Granulated Sugar', '3/4 cup', 9, 'Sweets', 387, 23),
('Brown Sugar', '3/4 cup', 9, 'Sweets', 380, 35),
('Egg', '1', 9, 'Proteins', 143, 7),
('Vanilla Extract', '1 teaspoon', 9, 'Condiments', 288, 10),
('Chocolate Chips', '2 cups', 9, 'Sweets', 535, 62),

-- Miso Soup
('Dashi Stock', '4 cups', 10, 'Beverages', 0, 63),
('Miso Paste', '1/4 cup', 10, 'Condiments', 198, 64),
('Tofu', '1/2 block', 10, 'Proteins', 62, 65),
('Green Onions', '2 stalks', 10, 'Vegetables', 23, 28),
('Wakame Seaweed', '2 tablespoons', 10, 'Seafood', 45, 66),

-- Key Lime Pie
('Graham Cracker Crumbs', '1 1/2 cups', 11, 'Grains', 364, 1),
('Butter', '1/3 cup', 11, 'Dairy', 717, 11),
('Granulated Sugar', '1/2 cup', 11, 'Sweets', 387, 23),
('Egg Yolks', '3', 11, 'Proteins', 143, 7),
('Key Lime Juice', '3/4 cup', 11, 'Fruits', 30, 67),
('Sweetened Condensed Milk', '14 oz', 11, 'Dairy', 321, 68),
('Whipped Cream', 'For topping', 11, 'Dairy', 345, 22),
('Lime Zest', 'For garnish', 11, 'Fruits', 30, 69),

-- Beef Stroganoff
('Beef Sirloin Steak', '1 lb', 12, 'Meats', 191, 70),
('Butter', '2 tablespoons', 12, 'Dairy', 717, 11),
('Onion', '1 large', 12, 'Vegetables', 44, 71),
('Mushrooms', '8 oz', 12, 'Vegetables', 22, 60),
('Flour', '2 tablespoons', 12, 'Grains', 364, 1),
('Beef Broth', '1 cup', 12, 'Meats', 7, 55),
('Sour Cream', '1 cup', 12, 'Dairy', 193, 72),
('Worcestershire Sauce', '2 teaspoons', 12, 'Condiments', 36, 73),
('Dijon Mustard', '1 teaspoon', 12, 'Condiments', 66, 74),
('Egg Noodles', '8 oz', 12, 'Grains', 131, 14),

-- Croissant
('All-Purpose Flour', '2 1/2 cups', 13, 'Grains', 364, 1),
('Active Dry Yeast', '1 packet', 13, 'Baking', 105, 75),
('Granulated Sugar', '1/4 cup', 13, 'Sweets', 387, 23),
('Salt', '1 teaspoon', 13, 'Condiments', 0, 6),
('Unsalted Butter', '1 cup', 13, 'Dairy', 717, 11),
('Milk', '1/2 cup', 13, 'Dairy', 42, 8),
('Water', '1/2 cup', 13, 'Beverages', 0, 52),

-- Pho
('Beef Bones', '4 lbs', 14, 'Meats', 191, 76),
('Onion', '1 large', 14, 'Vegetables', 44, 71),
('Ginger', '1 knob', 14, 'Vegetables', 80, 77),
('Star Anise', '3 pods', 14, 'Spices', 337, 78),
('Cloves', '5', 14, 'Spices', 323, 79),
('Cinnamon Stick', '1', 14, 'Spices', 247, 39),
('Cardamom Pods', '3', 14, 'Spices', 311, 80),
('Beef Brisket', '1 lb', 14, 'Meats', 191, 70),
('Fish Sauce', '1/4 cup', 14, 'Condiments', 0, 33),
('Salt', '1 tablespoon', 14, 'Condiments', 0, 6),
('Sugar', '1 tablespoon', 14, 'Sweets', 387, 23),
('Rice Noodles', '8 oz', 14, 'Grains', 192, 24),
('Bean Sprouts', '1 cup', 14, 'Vegetables', 31, 27),
('Lime', '1', 14, 'Fruits', 30, 31),
('Thai Basil', 'For garnish', 14, 'Herbs', 23, 32),

-- Pancakes
('All-Purpose Flour', '1 1/2 cups', 15, 'Grains', 364, 1),
('Granulated Sugar', '3 tablespoons', 15, 'Sweets', 387, 23),
('Baking Powder', '1 tablespoon', 15, 'Baking', 15, 4),
('Salt', '1/2 teaspoon', 15, 'Condiments', 0, 6),
('Milk', '1 1/4 cups', 15, 'Dairy', 42, 8),
('Egg', '1', 15, 'Proteins', 143, 7),
('Butter', '3 tablespoons', 15, 'Dairy', 717, 11),

-- Pasta Primavera
('Pasta', '8 oz', 16, 'Grains', 131, 14),
('Olive Oil', '2 tablespoons', 16, 'Oils', 884, 9),
('Garlic', '3 cloves', 16, 'Vegetables', 149, 29),
('Broccoli', '1 cup', 16, 'Vegetables', 34, 81),
('Zucchini', '1', 16, 'Vegetables', 17, 82),
('Bell Pepper', '1', 16, 'Vegetables', 20, 83),
('Cherry Tomatoes', '1 cup', 16, 'Vegetables', 18, 84),
('Parmesan Cheese', '1/4 cup', 16, 'Dairy', 431, 16),
('Salt', 'To taste', 16, 'Condiments', 0, 6),
('Black Pepper', 'To taste', 16, 'Condiments', 251, 17),

-- Cheesecake
('Graham Cracker Crumbs', '1 1/2 cups', 17, 'Grains', 364, 1),
('Granulated Sugar', '1/4 cup', 17, 'Sweets', 387, 23),
('Butter', '1/3 cup', 17, 'Dairy', 717, 11),
('Cream Cheese', '24 oz', 17, 'Dairy', 342, 12),
('Sour Cream', '1 cup', 17, 'Dairy', 193, 72),
('Vanilla Extract', '1 teaspoon', 17, 'Condiments', 288, 10),
('Eggs', '4', 17, 'Proteins', 143, 7),
('Lemon Zest', '1 tablespoon', 17, 'Fruits', 30, 69),

-- Ratatouille
('Tomatoes', '4', 18, 'Vegetables', 18, 61),
('Zucchini', '2', 18, 'Vegetables', 17, 82),
('Eggplant', '1', 18, 'Vegetables', 25, 85),
('Bell Pepper', '1', 18, 'Vegetables', 20, 83),
('Onion', '1', 18, 'Vegetables', 44, 71),
('Garlic', '3 cloves', 18, 'Vegetables', 149, 29),
('Olive Oil', '2 tablespoons', 18, 'Oils', 884, 9),
('Herbes de Provence', '1 teaspoon', 18, 'Herbs', 0, 86),
('Salt', 'To taste', 18, 'Condiments', 0, 6),
('Black Pepper', 'To taste', 18, 'Condiments', 251, 17),

-- Tacos
('Ground Beef', '1 lb', 19, 'Meats', 191, 70),
('Taco Seasoning', '1 packet', 19, 'Spices', 282, 36),
('Water', '1/2 cup', 19, 'Beverages', 0, 52),
('Taco Shells', '8', 19, 'Grains', 384, 37),
('Shredded Lettuce', '1 cup', 19, 'Vegetables', 14, 87),
('Shredded Cheese', '1 cup', 19, 'Dairy', 431, 16),
('Tomato', '1', 19, 'Vegetables', 18, 61),
('Sour Cream', 'For topping', 19, 'Dairy', 193, 72),
('Salsa', 'For topping', 19, 'Condiments', 13, 88),

-- Pavlova
('Egg Whites', '4', 20, 'Proteins', 143, 7),
('Granulated Sugar', '1 cup', 20, 'Sweets', 387, 23),
('Cornstarch', '1 teaspoon', 20, 'Baking', 381, 89),
('White Vinegar', '1 teaspoon', 20, 'Condiments', 18, 90),
('Vanilla Extract', '1 teaspoon', 20, 'Condiments', 288, 10),
('Heavy Cream', '1 cup', 20, 'Dairy', 345, 22),
('Fresh Fruit', 'For topping', 20, 'Fruits', 52, 91),

-- Sushi Burrito
('Sushi Rice', '2 cups', 21, 'Grains', 130, 41),
('Nori Sheets', '2', 21, 'Seafood', 33, 42),
('Raw Tuna', '4 oz', 21, 'Seafood', 142, 43),
('Avocado', '1', 21, 'Vegetables', 160, 45),
('Cucumber', '1', 21, 'Vegetables', 16, 44),
('Carrot', '1', 21, 'Vegetables', 41, 92),
('Soy Sauce', 'For dipping', 21, 'Condiments', 67, 46),
('Wasabi', 'For dipping', 21, 'Condiments', 66, 47),
('Pickled Ginger', 'For dipping', 21, 'Vegetables', 28, 48),

-- Risotto
('Arborio Rice', '1 1/2 cups', 22, 'Grains', 364, 1),
('Chicken Broth', '4 cups', 22, 'Meats', 7, 55),
('Butter', '4 tablespoons', 22, 'Dairy', 717, 11),
('Parmesan Cheese', '1/2 cup', 22, 'Dairy', 431, 16),
('White Wine', '1/2 cup', 22, 'Beverages', 0, 93),
('Onion', '1/2 cup', 22, 'Vegetables', 44, 71),
('Garlic', '2 cloves', 22, 'Vegetables', 149, 29),

-- Biryani
('Basmati Rice', '2 cups', 23, 'Grains', 364, 1),
('Chicken', '1 lb', 23, 'Meats', 191, 70),
('Yogurt', '1/2 cup', 23, 'Dairy', 59, 94),
('Onion', '1 large', 23, 'Vegetables', 44, 71),
('Tomato', '1', 23, 'Vegetables', 18, 61),
('Ginger-Garlic Paste', '2 tablespoons', 23, 'Vegetables', 37, 95),
('Green Chilies', '2', 23, 'Vegetables', 40, 96),
('Mint Leaves', '1/4 cup', 23, 'Herbs', 70, 97),
('Coriander Leaves', '1/4 cup', 23, 'Herbs', 23, 98),
('Garam Masala', '1 teaspoon', 23, 'Spices', 535, 99),
('Turmeric Powder', '1/2 teaspoon', 23, 'Spices', 525, 40),
('Red Chili Powder', '1/2 teaspoon', 23, 'Spices', 282, 36),
('Cumin Powder', '1/2 teaspoon', 23, 'Spices', 375, 100),
('Coriander Powder', '1/2 teaspoon', 23, 'Spices', 23, 101),
('Bay Leaf', '1', 23, 'Herbs', 313, 102),
('Cinnamon Stick', '1', 23, 'Spices', 247, 39),
('Cardamom Pods', '3', 23, 'Spices', 311, 80),
('Cloves', '3', 23, 'Spices', 323, 79),

-- Lemon Bars
('All-Purpose Flour', '2 cups', 24, 'Grains', 364, 1),
('Confectioners Sugar', '1/2 cup', 24, 'Sweets', 389, 13),
('Unsalted Butter', '1 cup', 24, 'Dairy', 717, 11),
('Granulated Sugar', '2 cups', 24, 'Sweets', 387, 23),
('Eggs', '4', 24, 'Proteins', 143, 7),
('Lemon Juice', '1/2 cup', 24, 'Fruits', 22, 54),
('Lemon Zest', '1 tablespoon', 24, 'Fruits', 30, 69),
('Baking Powder', '1/2 teaspoon', 24, 'Baking', 15, 4),
('Salt', '1/4 teaspoon', 24, 'Condiments', 0, 6),
('Cornstarch', '2 tablespoons', 24, 'Baking', 381, 89),

-- Gazpacho
('Tomatoes', '2 lbs', 25, 'Vegetables', 18, 61),
('Cucumber', '1', 25, 'Vegetables', 16, 44),
('Red Bell Pepper', '1', 25, 'Vegetables', 20, 83),
('Red Onion', '1/2', 25, 'Vegetables', 44, 71),
('Garlic', '2 cloves', 25, 'Vegetables', 149, 29),
('Extra Virgin Olive Oil', '1/4 cup', 25, 'Oils', 884, 9),
('Red Wine Vinegar', '3 tablespoons', 25, 'Condiments', 0, 103),
('Salt', 'To taste', 25, 'Condiments', 0, 6),
('Black Pepper', 'To taste', 25, 'Condiments', 251, 17),

-- Chicken Tikka Masala
('Boneless, Skinless Chicken Thighs', '1 lb', 26, 'Meats', 191, 104),
('Yogurt', '1 cup', 26, 'Dairy', 59, 94),
('Lemon Juice', '2 tablespoons', 26, 'Fruits', 22, 54),
('Garam Masala', '2 teaspoons', 26, 'Spices', 535, 99),
('Ground Cumin', '2 teaspoons', 26, 'Spices', 375, 100),
('Ground Coriander', '2 teaspoons', 26, 'Spices', 23, 101),
('Cayenne Pepper', '1/2 teaspoon', 26, 'Spices', 282, 36),
('Ground Turmeric', '1/2 teaspoon', 26, 'Spices', 525, 40),
('Paprika', '1/2 teaspoon', 26, 'Spices', 282, 105),
('Salt', '1 teaspoon', 26, 'Condiments', 0, 6),
('Black Pepper', '1/2 teaspoon', 26, 'Condiments', 251, 17),
('Butter', '3 tablespoons', 26, 'Dairy', 717, 11),
('Onion', '1', 26, 'Vegetables', 44, 71),
('Garlic', '3 cloves', 26, 'Vegetables', 149, 29),
('Tomato Sauce', '1 cup', 26, 'Vegetables', 18, 106),
('Heavy Cream', '1 cup', 26, 'Dairy', 345, 22),
('Fresh Cilantro', 'For garnish', 26, 'Herbs', 23, 32),

-- Creme Brulee
('Heavy Cream', '1 cup', 27, 'Dairy', 345, 22),
('Vanilla Bean', '1', 27, 'Condiments', 288, 107),
('Egg Yolks', '6', 27, 'Proteins', 143, 7),
('Granulated Sugar', '1/2 cup', 27, 'Sweets', 387, 23),

-- Chicken Satay
('Chicken Breast', '1 lb', 28, 'Meats', 191, 108),
('Coconut Milk', '1 cup', 28, 'Dairy', 230, 109),
('Soy Sauce', '3 tablespoons', 28, 'Condiments', 67, 46),
('Brown Sugar', '2 tablespoons', 28, 'Sweets', 380, 35),
('Lime Juice', '2 tablespoons', 28, 'Fruits', 30, 54),
('Garlic', '2 cloves', 28, 'Vegetables', 149, 29),
('Ginger', '1 tablespoon', 28, 'Vegetables', 80, 77),
('Turmeric Powder', '1 teaspoon', 28, 'Spices', 525, 40),
('Coriander Powder', '1 teaspoon', 28, 'Spices', 23, 101),
('Cumin Powder', '1 teaspoon', 28, 'Spices', 375, 100),
('Salt', '1/2 teaspoon', 28, 'Condiments', 0, 6),

-- Lemon Meringue Pie
('Graham Cracker Crumbs', '1 1/2 cups', 29, 'Grains', 364, 1),
('Granulated Sugar', '1 cup', 29, 'Sweets', 387, 23),
('Butter', '1/3 cup', 29, 'Dairy', 717, 11),
('Eggs', '4', 29, 'Proteins', 143, 7),
('Lemon Juice', '1 cup', 29, 'Fruits', 22, 54),
('Cornstarch', '3 tablespoons', 29, 'Baking', 381, 89),
('Cream of Tartar', '1/4 teaspoon', 29, 'Condiments', 364, 110),
('Salt', '1/4 teaspoon', 29, 'Condiments', 0, 6),

-- Beef Wellington
('Beef Tenderloin', '2 lbs', 30, 'Meats', 191, 111),
('Butter', '2 tablespoons', 30, 'Dairy', 717, 11),
('Olive Oil', '2 tablespoons', 30, 'Oils', 884, 9),
('Mushrooms', '8 oz', 30, 'Vegetables', 22, 60),
('Shallots', '2', 30, 'Vegetables', 44, 112),
('Garlic', '2 cloves', 30, 'Vegetables', 149, 29),
('Puff Pastry', '1 sheet', 30, 'Grains', 364, 113),
('Prosciutto', '8 slices', 30, 'Meats', 191, 114),
('Dijon Mustard', '1 tablespoon', 30, 'Condiments', 66, 74),
('Egg', '1', 30, 'Proteins', 143, 7),

-- Pasta alla Puttanesca
('Spaghetti', '8 oz', 31, 'Grains', 131, 14),
('Olive Oil', '1/4 cup', 31, 'Oils', 884, 9),
('Anchovy Fillets', '4', 31, 'Seafood', 143, 115),
('Garlic', '3 cloves', 31, 'Vegetables', 149, 29),
('Red Pepper Flakes', '1/2 teaspoon', 31, 'Spices', 282, 116),
('Canned Tomatoes', '28 oz', 31, 'Vegetables', 18, 117),
('Kalamata Olives', '1/2 cup', 31, 'Vegetables', 115, 118),
('Capers', '1/4 cup', 31, 'Vegetables', 23, 119),
('Fresh Parsley', 'For garnish', 31, 'Herbs', 23, 120),

-- Black Forest Cake
('All-Purpose Flour', '1 3/4 cups', 32, 'Grains', 364, 1),
('Granulated Sugar', '1 3/4 cups', 32, 'Sweets', 387, 23),
('Cocoa Powder', '3/4 cup', 32, 'Baking', 384, 121),
('Baking Powder', '1 1/2 teaspoons', 32, 'Baking', 15, 4),
('Baking Soda', '1 1/2 teaspoons', 32, 'Baking', 0, 5),
('Salt', '1 teaspoon', 32, 'Condiments', 0, 6),
('Eggs', '2', 32, 'Proteins', 143, 7),
('Milk', '1 cup', 32, 'Dairy', 42, 8),
('Vegetable Oil', '1/2 cup', 32, 'Oils', 884, 9),
('Vanilla Extract', '2 teaspoons', 32, 'Condiments', 288, 10),
('Boiling Water', '1 cup', 32, 'Beverages', 0, 122),
('Cherries', '1 jar', 32, 'Fruits', 52, 123),
('Whipped Cream', 'For topping', 32, 'Dairy', 345, 22),

-- Shakshuka
('Tomatoes', '4', 33, 'Vegetables', 18, 61),
('Red Bell Pepper', '1', 33, 'Vegetables', 20, 83),
('Onion', '1', 33, 'Vegetables', 44, 71),
('Garlic', '2 cloves', 33, 'Vegetables', 149, 29),
('Olive Oil', '2 tablespoons', 33, 'Oils', 884, 9),
('Paprika', '1 teaspoon', 33, 'Spices', 282, 105),
('Cumin', '1 teaspoon', 33, 'Spices', 375, 100),
('Cayenne Pepper', '1/4 teaspoon', 33, 'Spices', 282, 36),
('Salt', 'To taste', 33, 'Condiments', 0, 6),
('Black Pepper', 'To taste', 33, 'Condiments', 251, 17),
('Eggs', '4', 33, 'Proteins', 143, 7),
('Feta Cheese', '1/4 cup', 33, 'Dairy', 738, 124),
('Fresh Parsley', 'For garnish', 33, 'Herbs', 23, 120),

-- Gazpacho
('Tomatoes', '2 lbs', 25, 'Vegetables', 18, 61),
('Cucumber', '1', 25, 'Vegetables', 16, 44),
('Red Bell Pepper', '1', 25, 'Vegetables', 20, 83),
('Red Onion', '1/2', 25, 'Vegetables', 44, 71),
('Garlic', '2 cloves', 25, 'Vegetables', 149, 29),
('Extra Virgin Olive Oil', '1/4 cup', 25, 'Oils', 884, 9),
('Red Wine Vinegar', '3 tablespoons', 25, 'Condiments', 0, 103),
('Salt', 'To taste', 25, 'Condiments', 0, 6),
('Black Pepper', 'To taste', 25, 'Condiments', 251, 17),

-- Chicken Tikka Masala
('Boneless, Skinless Chicken Thighs', '1 lb', 26, 'Meats', 191, 104),
('Yogurt', '1 cup', 26, 'Dairy', 59, 94),
('Lemon Juice', '2 tablespoons', 26, 'Fruits', 22, 54),
('Garam Masala', '2 teaspoons', 26, 'Spices', 535, 99),
('Ground Cumin', '2 teaspoons', 26, 'Spices', 375, 100),
('Ground Coriander', '2 teaspoons', 26, 'Spices', 23, 101),
('Cayenne Pepper', '1/2 teaspoon', 26, 'Spices', 282, 36),
('Ground Turmeric', '1/2 teaspoon', 26, 'Spices', 525, 40),
('Paprika', '1/2 teaspoon', 26, 'Spices', 282, 105),
('Salt', '1 teaspoon', 26, 'Condiments', 0, 6),
('Black Pepper', '1/2 teaspoon', 26, 'Condiments', 251, 17),
('Butter', '3 tablespoons', 26, 'Dairy', 717, 11),
('Onion', '1', 26, 'Vegetables', 44, 71),
('Garlic', '3 cloves', 26, 'Vegetables', 149, 29),
('Tomato Sauce', '1 cup', 26, 'Vegetables', 18, 106),
('Heavy Cream', '1 cup', 26, 'Dairy', 345, 22),
('Fresh Cilantro', 'For garnish', 26, 'Herbs', 23, 32),

-- Creme Brulee
('Heavy Cream', '1 cup', 27, 'Dairy', 345, 22),
('Vanilla Bean', '1', 27, 'Condiments', 288, 107),
('Egg Yolks', '6', 27, 'Proteins', 143, 7),
('Granulated Sugar', '1/2 cup', 27, 'Sweets', 387, 23),

-- Chicken Satay
('Chicken Breast', '1 lb', 28, 'Meats', 191, 108),
('Coconut Milk', '1 cup', 28, 'Dairy', 230, 109),
('Soy Sauce', '3 tablespoons', 28, 'Condiments', 67, 46),
('Brown Sugar', '2 tablespoons', 28, 'Sweets', 380, 35),
('Lime Juice', '2 tablespoons', 28, 'Fruits', 30, 54),
('Garlic', '2 cloves', 28, 'Vegetables', 149, 29),
('Ginger', '1 tablespoon', 28, 'Vegetables', 80, 77),
('Turmeric Powder', '1 teaspoon', 28, 'Spices', 525, 40),
('Coriander Powder', '1 teaspoon', 28, 'Spices', 23, 101),
('Cumin Powder', '1 teaspoon', 28, 'Spices', 375, 100),
('Salt', '1/2 teaspoon', 28, 'Condiments', 0, 6),

-- Lemon Meringue Pie
('Graham Cracker Crumbs', '1 1/2 cups', 29, 'Grains', 364, 1),
('Granulated Sugar', '1 cup', 29, 'Sweets', 387, 23),
('Butter', '1/3 cup', 29, 'Dairy', 717, 11),
('Eggs', '4', 29, 'Proteins', 143, 7),
('Lemon Juice', '1 cup', 29, 'Fruits', 22, 54),
('Cornstarch', '3 tablespoons', 29, 'Baking', 381, 89),
('Cream of Tartar', '1/4 teaspoon', 29, 'Condiments', 364, 110),
('Salt', '1/4 teaspoon', 29, 'Condiments', 0, 6),

-- Beef Wellington
('Beef Tenderloin', '2 lbs', 30, 'Meats', 191, 111),
('Butter', '2 tablespoons', 30, 'Dairy', 717, 11),
('Olive Oil', '2 tablespoons', 30, 'Oils', 884, 9),
('Mushrooms', '8 oz', 30, 'Vegetables', 22, 60),
('Shallots', '2', 30, 'Vegetables', 44, 112),
('Garlic', '2 cloves', 30, 'Vegetables', 149, 29),
('Puff Pastry', '1 sheet', 30, 'Grains', 364, 113),
('Prosciutto', '8 slices', 30, 'Meats', 191, 114),
('Dijon Mustard', '1 tablespoon', 30, 'Condiments', 66, 74),
('Egg', '1', 30, 'Proteins', 143, 7),

-- Pasta alla Puttanesca
('Spaghetti', '8 oz', 31, 'Grains', 131, 14),
('Olive Oil', '1/4 cup', 31, 'Oils', 884, 9),
('Anchovy Fillets', '4', 31, 'Seafood', 143, 115),
('Garlic', '3 cloves', 31, 'Vegetables', 149, 29),
('Red Pepper Flakes', '1/2 teaspoon', 31, 'Spices', 282, 116),
('Canned Tomatoes', '28 oz', 31, 'Vegetables', 18, 117),
('Kalamata Olives', '1/2 cup', 31, 'Vegetables', 115, 118),
('Capers', '1/4 cup', 31, 'Vegetables', 23, 119),
('Fresh Parsley', 'For garnish', 31, 'Herbs', 23, 120),

-- Black Forest Cake
('All-Purpose Flour', '1 3/4 cups', 32, 'Grains', 364, 1),
('Granulated Sugar', '1 3/4 cups', 32, 'Sweets', 387, 23),
('Cocoa Powder', '3/4 cup', 32, 'Baking', 384, 121),
('Baking Powder', '1 1/2 teaspoons', 32, 'Baking', 15, 4),
('Baking Soda', '1 1/2 teaspoons', 32, 'Baking', 0, 5),
('Salt', '1 teaspoon', 32, 'Condiments', 0, 6),
('Eggs', '2', 32, 'Proteins', 143, 7),
('Milk', '1 cup', 32, 'Dairy', 42, 8),
('Vegetable Oil', '1/2 cup', 32, 'Oils', 884, 9),
('Vanilla Extract', '2 teaspoons', 32, 'Condiments', 288, 10),
('Boiling Water', '1 cup', 32, 'Beverages', 0, 122),
('Cherries', '1 jar', 32, 'Fruits', 52, 123),
('Whipped Cream', 'For topping', 32, 'Dairy', 345, 22),

-- Shakshuka
('Tomatoes', '4', 33, 'Vegetables', 18, 61),
('Red Bell Pepper', '1', 33, 'Vegetables', 20, 83),
('Onion', '1', 33, 'Vegetables', 44, 71),
('Garlic', '2 cloves', 33, 'Vegetables', 149, 29),
('Olive Oil', '2 tablespoons', 33, 'Oils', 884, 9),
('Paprika', '1 teaspoon', 33, 'Spices', 282, 105),
('Cumin', '1 teaspoon', 33, 'Spices', 375, 100),
('Cayenne Pepper', '1/4 teaspoon', 33, 'Spices', 282, 36),
('Salt', 'To taste', 33, 'Condiments', 0, 6),
('Black Pepper', 'To taste', 33, 'Condiments', 251, 17),
('Eggs', '4', 33, 'Proteins', 143, 7),
('Feta Cheese', '1/4 cup', 33, 'Dairy', 738, 124),
('Fresh Parsley', 'For garnish', 33, 'Herbs', 23, 120),

-- Moussaka
('Eggplant', '2 large', 34, 'Vegetables', 25, 85),
('Ground Beef', '1 lb', 34, 'Meats', 191, 70),
('Onion', '1', 34, 'Vegetables', 44, 71),
('Garlic', '3 cloves', 34, 'Vegetables', 149, 29),
('Tomatoes', '2', 34, 'Vegetables', 18, 61),
('Red Wine', '1/2 cup', 34, 'Beverages', 0, 93),
('Cinnamon', '1/2 teaspoon', 34, 'Spices', 247, 39),
('Ground Nutmeg', '1/2 teaspoon', 34, 'Spices', 161, 125),
('Bay Leaf', '1', 34, 'Herbs', 313, 102),
('Olive Oil', '1/4 cup', 34, 'Oils', 884, 9),
('Potatoes', '4', 34, 'Vegetables', 77, 126),
('Butter', '2 tablespoons', 34, 'Dairy', 717, 11),
('All-Purpose Flour', '2 tablespoons', 34, 'Grains', 364, 1),
('Milk', '2 cups', 34, 'Dairy', 42, 8),
('Egg', '2', 34, 'Proteins', 143, 7),
('Grated Parmesan', '1/2 cup', 34, 'Dairy', 431, 16),

-- Lava Cake
('Dark Chocolate', '8 oz', 35, 'Sweets', 531, 127),
('Unsalted Butter', '1/2 cup', 35, 'Dairy', 717, 11),
('Eggs', '4', 35, 'Proteins', 143, 7),
('Granulated Sugar', '1/2 cup', 35, 'Sweets', 387, 23),
('All-Purpose Flour', '1/4 cup', 35, 'Grains', 364, 1),
('Salt', '1/4 teaspoon', 35, 'Condiments', 0, 6),

-- Tacos al Pastor
('Pork Shoulder', '2 lbs', 36, 'Meats', 191, 128),
('Ancho Chiles', '2', 36, 'Spices', 282, 129),
('Guajillo Chiles', '4', 36, 'Spices', 282, 130),
('Garlic', '3 cloves', 36, 'Vegetables', 149, 29),
('White Vinegar', '1/4 cup', 36, 'Condiments', 18, 90),
('Pineapple Juice', '1/4 cup', 36, 'Fruits', 53, 131),
('Orange Juice', '1/4 cup', 36, 'Fruits', 50, 132),
('Achiote Paste', '3 tablespoons', 36, 'Condiments', 282, 133),
('Cumin', '1 teaspoon', 36, 'Spices', 375, 100),
('Oregano', '1 teaspoon', 36, 'Spices', 265, 134),
('Salt', '1 teaspoon', 36, 'Condiments', 0, 6),
('Black Pepper', '1/2 teaspoon', 36, 'Condiments', 251, 17),
('Tortillas', '8', 36, 'Grains', 384, 37),

-- Mushroom Risotto
('Arborio Rice', '1 cup', 37, 'Grains', 364, 1),
('Chicken Broth', '4 cups', 37, 'Meats', 7, 55),
('Olive Oil', '2 tablespoons', 37, 'Oils', 884, 9),
('Onion', '1/2 cup', 37, 'Vegetables', 44, 71),
('Garlic', '2 cloves', 37, 'Vegetables', 149, 29),
('Mushrooms', '8 oz', 37, 'Vegetables', 22, 60),
('Dry White Wine', '1/2 cup', 37, 'Beverages', 0, 93),
('Parmesan Cheese', '1/2 cup', 37, 'Dairy', 431, 16),
('Butter', '2 tablespoons', 37, 'Dairy', 717, 11),
('Fresh Parsley', 'For garnish', 37, 'Herbs', 23, 120),

-- Crepes
('All-Purpose Flour', '1 cup', 38, 'Grains', 364, 1),
('Milk', '1 1/2 cups', 38, 'Dairy', 42, 8),
('Eggs', '2', 38, 'Proteins', 143, 7),
('Butter', '2 tablespoons', 38, 'Dairy', 717, 11),
('Salt', '1/2 teaspoon', 38, 'Condiments', 0, 6),

-- Tandoori Chicken
('Chicken', '2 lbs', 39, 'Meats', 191, 104),
('Yogurt', '1 cup', 39, 'Dairy', 59, 94),
('Lemon Juice', '2 tablespoons', 39, 'Fruits', 22, 54),
('Garam Masala', '2 teaspoons', 39, 'Spices', 535, 99),
('Ground Cumin', '2 teaspoons', 39, 'Spices', 375, 100),
('Ground Coriander', '2 teaspoons', 39, 'Spices', 23, 101),
('Cayenne Pepper', '1/2 teaspoon', 39, 'Spices', 282, 36),
('Ground Turmeric', '1/2 teaspoon', 39, 'Spices', 525, 40),
('Salt', '1 teaspoon', 39, 'Condiments', 0, 6),
('Black Pepper', '1/2 teaspoon', 39, 'Condiments', 251, 17),
('Ginger', '1 tablespoon', 39, 'Vegetables', 80, 77),
('Garlic', '3 cloves', 39, 'Vegetables', 149, 29),

-- Pav Bhaji
('Potatoes', '4 large', 40, 'Vegetables', 77, 126),
('Butter', '1/4 cup', 40, 'Dairy', 717, 11),
('Onion', '1', 40, 'Vegetables', 44, 71),
('Green Bell Pepper', '1', 40, 'Vegetables', 20, 135),
('Tomato', '2', 40, 'Vegetables', 18, 61),
('Green Peas', '1 cup', 40, 'Vegetables', 81, 136),
('Ginger-Garlic Paste', '2 tablespoons', 40, 'Vegetables', 37, 95),
('Pav Bhaji Masala', '2 tablespoons', 40, 'Spices', 282, 137),
('Turmeric Powder', '1/2 teaspoon', 40, 'Spices', 525, 40),
('Chili Powder', '1 teaspoon', 40, 'Spices', 282, 138),
('Salt', 'To taste', 40, 'Condiments', 0, 6),
('Cilantro', 'For garnish', 40, 'Herbs', 23, 32),

-- Coq au Vin
('Chicken', '1 whole', 41, 'Meats', 191, 104),
('Bacon', '4 slices', 41, 'Meats', 476, 139),
('Onion', '1', 41, 'Vegetables', 44, 71),
('Carrots', '2', 41, 'Vegetables', 41, 92),
('Garlic', '4 cloves', 41, 'Vegetables', 149, 29),
('Mushrooms', '8 oz', 41, 'Vegetables', 22, 60),
('Dry Red Wine', '2 cups', 41, 'Beverages', 0, 140),
('Chicken Broth', '2 cups', 41, 'Meats', 7, 55),
('Tomato Paste', '2 tablespoons', 41, 'Vegetables', 18, 141),
('All-Purpose Flour', '2 tablespoons', 41, 'Grains', 364, 1),
('Thyme', '3 sprigs', 41, 'Herbs', 23, 142),
('Bay Leaves', '2', 41, 'Herbs', 313, 102),
('Butter', '2 tablespoons', 41, 'Dairy', 717, 11),
('Olive Oil', '2 tablespoons', 41, 'Oils', 884, 9),
('Salt', 'To taste', 41, 'Condiments', 0, 6),
('Black Pepper', 'To taste', 41, 'Condiments', 251, 17),

-- Beef Stroganoff
('Beef Sirloin', '1 lb', 42, 'Meats', 191, 143),
('Onion', '1', 42, 'Vegetables', 44, 71),
('Garlic', '2 cloves', 42, 'Vegetables', 149, 29),
('White Mushrooms', '8 oz', 42, 'Vegetables', 22, 144),
('Beef Broth', '1 1/2 cups', 42, 'Meats', 7, 55),
('Worcestershire Sauce', '2 tablespoons', 42, 'Condiments', 376, 145),
('Dijon Mustard', '1 tablespoon', 42, 'Condiments', 66, 74),
('Paprika', '1 teaspoon', 42, 'Spices', 282, 105),
('Sour Cream', '1/2 cup', 42, 'Dairy', 193, 72),
('Salt', 'To taste', 42, 'Condiments', 0, 6),
('Black Pepper', 'To taste', 42, 'Condiments', 251, 17),
('Egg Noodles', '8 oz', 42, 'Grains', 192, 24),

-- Cinnamon Rolls Ingredients
('All-purpose flour', '4 cups', 42, 'Grains', 364, 1),
('Yeast', '2 1/4 teaspoons', 42, 'Baking Ingredients', 105, 2),
('Granulated sugar', '1/4 cup', 42, 'Sweeteners', 387, 3),
('Salt', '1 teaspoon', 42, 'Spices', 0, 4),
('Warm milk', '1 cup', 42, 'Dairy', 60, 5),
('Egg', '1', 42, 'Protein', 155, 6),
('Unsalted butter', '1/4 cup', 42, 'Dairy', 717, 7),
('Ground cinnamon', '2 tablespoons', 42, 'Spices', 247, 8),
('Brown sugar', '3/4 cup', 42, 'Sweeteners', 380, 9),
('Cream cheese', '4 ounces', 42, 'Dairy', 342, 10),
('Powdered sugar', '1 cup', 42, 'Sweeteners', 389, 11),
('Vanilla extract', '1 teaspoon', 42, 'Flavorings', 288, 12),

-- Ramen Ingredients
('Ramen noodles', '2 packs', 43, 'Grains', 435, 13),
('Chicken broth', '4 cups', 43, 'Soup Base', 7, 14),
('Soy sauce', '2 tablespoons', 43, 'Sauces', 61, 15),
('Sesame oil', '1 tablespoon', 43, 'Oils', 884, 16),
('Minced garlic', '2 cloves', 43, 'Produce', 149, 17),
('Sliced green onions', '1/4 cup', 43, 'Produce', 32, 18),
('Sliced mushrooms', '1 cup', 43, 'Produce', 22, 19),
('Sliced carrots', '1/2 cup', 43, 'Produce', 41, 20),
('Sliced bamboo shoots', '1/2 cup', 43, 'Produce', 27, 21),
('Boiled egg', '1', 43, 'Protein', 155, 22),
('Nori sheets', '2', 43, 'Grains', 35, 23),
('Sesame seeds', '1 tablespoon', 43, 'Spices', 573, 24),

-- Apple Crisp Ingredients
('Apples', '6 cups', 44, 'Produce', 52, 25),
('Granulated sugar', '1/2 cup', 44, 'Sweeteners', 387, 3),
('All-purpose flour', '1/2 cup', 44, 'Grains', 364, 1),
('Old-fashioned oats', '1/2 cup', 44, 'Grains', 389, 26),
('Ground cinnamon', '1 teaspoon', 44, 'Spices', 247, 8),
('Butter', '1/2 cup', 44, 'Dairy', 717, 27),
('Brown sugar', '1/2 cup', 44, 'Sweeteners', 380, 9),
('Lemon juice', '2 tablespoons', 44, 'Produce', 22, 28);

-- Fettuccine Alfredo Ingredients
INSERT INTO ingredients (name, quantity, recipe_id, food_group, calories_per_100g, image_id) VALUES
('Fettuccine pasta', '8 ounces', 45, 'Grains', 357, 29),
('Butter', '1/2 cup', 45, 'Dairy', 717, 27),
('Heavy cream', '1 cup', 45, 'Dairy', 340, 30),
('Garlic cloves', '2, minced', 45, 'Produce', 149, 31),
('Grated Parmesan cheese', '1 cup', 45, 'Dairy', 431, 32),
('Salt', '1/2 teaspoon', 45, 'Spices', 0, 4),
('Black pepper', '1/4 teaspoon', 45, 'Spices', 251, 33);

-- Tiramisu Cheesecake Ingredients
INSERT INTO ingredients (name, quantity, recipe_id, food_group, calories_per_100g, image_id) VALUES
('Cream cheese', '16 ounces', 46, 'Dairy', 342, 10),
('Granulated sugar', '3/4 cup', 46, 'Sweeteners', 387, 3),
('Eggs', '3', 46, 'Protein', 155, 6),
('Vanilla extract', '1 teaspoon', 46, 'Flavorings', 288, 12),
('Ladyfingers', '1 package', 46, 'Grains', 364, 34),
('Espresso coffee', '1 cup', 46, 'Beverages', 0, 35),
('Kahlua liqueur', '1/4 cup', 46, 'Alcohol', 512, 36),
('Cocoa powder', '2 tablespoons', 46, 'Spices', 228, 37);

-- Shrimp Scampi Ingredients
INSERT INTO ingredients (name, quantity, recipe_id, food_group, calories_per_100g, image_id) VALUES
('Linguine pasta', '8 ounces', 47, 'Grains', 357, 38),
('Shrimp', '1 pound', 47, 'Protein', 99, 39),
('Butter', '1/2 cup', 47, 'Dairy', 717, 27),
('Olive oil', '2 tablespoons', 47, 'Oils', 884, 40),
('Garlic cloves', '4, minced', 47, 'Produce', 149, 41),
('White wine', '1/2 cup', 47, 'Alcohol', 82, 42),
('Lemon juice', '2 tablespoons', 47, 'Produce', 22, 28),
('Chopped parsley', '2 tablespoons', 47, 'Produce', 36, 43);

-- Chocolate Mousse Ingredients
INSERT INTO ingredients (name, quantity, recipe_id, food_group, calories_per_100g, image_id) VALUES
('Semi-sweet chocolate', '8 ounces', 48, 'Baking Ingredients', 570, 44),
('Heavy cream', '1 cup', 48, 'Dairy', 340, 30),
('Powdered sugar', '1/4 cup', 48, 'Sweeteners', 389, 11),
('Vanilla extract', '1 teaspoon', 48, 'Flavorings', 288, 12);

-- Chicken Noodle Soup Ingredients
INSERT INTO ingredients (name, quantity, recipe_id, food_group, calories_per_100g, image_id) VALUES
('Egg noodles', '4 cups', 49, 'Grains', 435, 13),
('Chicken broth', '8 cups', 49, 'Soup Base', 7, 14),
('Chicken breast', '2, cooked and shredded', 49, 'Protein', 165, 45),
('Carrots', '2, sliced', 49, 'Produce', 41, 46),
('Celery stalks', '2, sliced', 49, 'Produce', 16, 47),
('Onion', '1, diced', 49, 'Produce', 40, 48),
('Garlic cloves', '2, minced', 49, 'Produce', 149, 41),
('Salt', '1 teaspoon', 49, 'Spices', 0, 4),
('Black pepper', '1/2 teaspoon', 49, 'Spices', 251, 33),
('Fresh parsley', '2 tablespoons, chopped', 49, 'Produce', 36, 43);

-- Beef Tacos Ingredients
INSERT INTO ingredients (name, quantity, recipe_id, food_group, calories_per_100g, image_id) VALUES
('Ground beef', '1 pound', 50, 'Protein', 250, 49),
('Taco seasoning', '1 packet', 50, 'Spices', 0, 50),
('Water', '1/4 cup', 50, 'Beverages', 0, 51),
('Taco shells', '12', 50, 'Grains', 435, 52),
('Shredded lettuce', '2 cups', 50, 'Produce', 14, 53),
('Diced tomatoes', '1 cup', 50, 'Produce', 18, 54),
('Shredded cheddar cheese', '1 cup', 50, 'Dairy', 400, 55),
('Sour cream', '1/2 cup', 50, 'Dairy', 230, 56),
('Salsa', '1/2 cup', 50, 'Condiments', 36, 57);

-- Inserting labels for recipes
INSERT INTO labels (label_name, label_id, recipe_id) VALUES
('Crowd-Pleasing Dishes', 1, 1),            -- Chocolate Cake
('Quick Lunch', 2, 2),                      -- Spaghetti Carbonara
('Easy Desserts', 3, 3),                    -- Tiramisu
('Quick Lunch', 4, 4),                      -- Pad Thai
('Comfort Food', 5, 5),                     -- Apple Pie
('Comfort Food', 6, 6),                     -- Sushi Rolls
('Party Appetizers', 7, 7),                 -- Baklava
('Family Dinner', 8, 8),                    -- Tom Yum Soup
('Easy Desserts', 9, 9),                    -- Chocolate Chip Cookies
('Quick Lunch', 10, 10),                    -- Miso Soup
('Comfort Food', 11, 11),                   -- Key Lime Pie
('Comfort Food', 12, 12),                   -- Beef Stroganoff
('Budget-Friendly Meals', 13, 13),          -- Croissant
('Party Appetizers', 14, 14),               -- Pho
('One-Pot Meals', 15, 15),                  -- Pancakes
('One-Pot Meals', 16, 16),                  -- Pasta Primavera
('Vegetarian Delights', 17, 17),            -- Cheesecake
('One-Pot Meals', 18, 18),                  -- Ratatouille
('One-Pot Meals', 19, 19),                  -- Tacos
('One-Pot Meals', 20, 20),                  -- Pavlova
('Street Food Favorites', 21, 21),          -- Sushi Burrito
('One-Pot Meals', 22, 22),                  -- Risotto
('Vegetarian Delights', 23, 23),            -- Biryani
('One-Pot Meals', 24, 24),                  -- Lemon Bars
('Vegetarian Delights', 25, 25),            -- Gazpacho
('Comfort Food', 26, 26),                   -- Chicken Tikka Masala
('Desserts', 27, 27),                       -- Creme Brulee
('Quick Lunch', 28, 28),                    -- Chicken Satay
('Desserts', 29, 29),                       -- Lemon Meringue Pie
('Comfort Food', 30, 30),                   -- Beef Wellington
('Quick Lunch', 31, 31),                    -- Pasta alla Puttanesca
('Quick Lunch', 32, 32),                    -- Black Forest Cake
('Comfort Food', 33, 33),                   -- Shakshuka
('Comfort Food', 34, 34),                   -- Moussaka
('Easy Desserts', 35, 35),                  -- Lava Cake
('Family Dinner', 36, 36),                  -- Tacos al Pastor
('Vegetarian Delights', 37, 37),            -- Mushroom Risotto
('Vegetarian Delights', 38, 38),            -- Crepes
('Family Dinner', 39, 39),                  -- Tandoori Chicken
('Family Dinner', 40, 40),                  -- Pav Bhaji
('Family Dinner', 41, 41),                  -- Coq au Vin
('Budget-Friendly Meals', 42, 42),          -- Cinnamon Rolls
('Quick Lunch', 43, 43),                    -- Ramen
('One-Pot Meals', 44, 44),                  -- Apple Crisp
('One-Pot Meals', 45, 45),                  -- Fettuccine Alfredo
('One-Pot Meals', 46, 46),                  -- Tiramisu Cheesecake
('One-Pot Meals', 47, 47),                  -- Shrimp Scampi
('One-Pot Meals', 48, 48),                  -- Chocolate Mousse
('Family Dinner', 49, 49),                  -- Chicken Noodle Soup
('One-Pot Meals', 50, 50);                  -- Beef Tacos


INSERT INTO meals (recipe_id, category,recipe_name, image_id) VALUES
(42,'Breakfast', 'Cinnamon Rolls', 1),
(13,'Breakfast', 'Croissant', 13),
(15,'Breakfast', 'Pancakes', 15),
(50,'Lunch', 'Beef Tacos', 19),
(49,'Lunch', 'Chicken Noodle Soup', 49),
(25,'Lunch', 'Gazpacho', 25),
(4,'Lunch', 'Pad Thai', 4),
(16,'Lunch', 'Pasta Primavera', 16),
(14,'Lunch', 'Pho', 14),
(43,'Lunch', 'Ramen', 43),
(33,'Lunch', 'Shakshuka', 33),
(21,'Lunch', 'Sushi Burrito', 21),
(19,'Lunch', 'Tacos', 36),
(36,'Lunch', 'Tacos al Pastor', 37),
(44,'Snack', 'Apple Crisp', 44),
(9,'Snack', 'Chocolate Chip Cookies', 9),
(24,'Snack', 'Lemon Bars', 24),
(20,'Snack', 'Pavlova', 20),
(7,'Dinner', 'Baklava', 7),
(12,'Dinner', 'Beef Stroganoff', 12),
(30,'Dinner', 'Beef Wellington', 30),
(23,'Dinner', 'Biryani', 23),
(32,'Dinner', 'Black Forest Cake', 32),
(17,'Dinner', 'Cheesecake', 17),
(28,'Dinner', 'Chicken Satay', 28),
(26,'Dinner', 'Chicken Tikka Masala', 26),
(1,'Dinner', 'Chocolate Cake', 1),
(48,'Dinner', 'Chocolate Mousse', 48),
(41,'Dinner', 'Coq au Vin', 41),
(27,'Dinner', 'Creme Brulee', 27),
(45,'Dinner', 'Fettuccine Alfredo', 45),
(11,'Snack', 'Key Lime Pie', 11),
(35,'Snack', 'Lava Cake', 35),
(29,'Snack', 'Lemon Meringue Pie', 29),
(10,'Dinner', 'Miso Soup', 10),
(43,'Lunch', 'Moussaka', 34),
(37,'Dinner', 'Mushroom Risotto', 37),
(31,'Dinner', 'Pasta alla Puttanesca', 31),
(40,'Dinner', 'Pav Bhaji', 40),
(22,'Dinner', 'Risotto', 22),
(47,'Dinner', 'Shrimp Scampi', 47),
(2,'Dinner', 'Spaghetti Carbonara', 2),
(6,'Dinner', 'Sushi Rolls', 6),
(39,'Dinner', 'Tandoori Chicken', 39),
(3,'Snack', 'Tiramisu', 3),
(46,'Snack', 'Tiramisu Cheesecake', 46),
(8,'Dinner', 'Tom Yum Soup', 8);


INSERT INTO recipes (recipe_name, short_description, national_cousine, type_of_recipe, difficulty, tip_1, tip_2, tip_3, preparetion_time, cooking_time, portions, key_ingredient, image_id) VALUES
('Chocolate Cake', 'Delicious chocolate cake for all occasions', 'American', 'sweet', 3, 'Use high-quality chocolate for best taste', 'Let the cake cool completely before frosting', 'Dust with powdered sugar for garnish', 30, 45, 12, 'Chocolate', 1),
('Spaghetti Carbonara', 'Classic Italian pasta dish with creamy sauce', 'Italian', 'sour', 4, 'Use pancetta instead of bacon for authentic flavor', 'Whisk eggs and cheese together quickly to prevent scrambling', 'Top with freshly cracked black pepper before serving', 20, 20, 4, 'Pasta', 2),
('Tiramisu', 'Traditional Italian dessert with coffee and mascarpone', 'Italian', 'sweet', 3, 'Dip ladyfingers briefly in coffee mixture to avoid soggy texture', 'Refrigerate for at least 4 hours before serving for best taste', 'Dust with cocoa powder just before serving', 30, 0, 8, 'Mascarpone', 3),
('Pad Thai', 'Popular Thai stir-fried noodle dish with sweet and sour flavors', 'Thai', 'sour', 3, 'Soak rice noodles in warm water until flexible before cooking', 'Use tamarind paste for authentic sour taste', 'Garnish with crushed peanuts and lime wedges', 20, 20, 4, 'Rice noodles', 4),
('Apple Pie', 'Classic American dessert made with fresh apples and flaky crust', 'American', 'sweet', 2, 'Use a mix of tart and sweet apples for balanced flavor', 'Brush the crust with egg wash for a golden brown finish', 'Serve warm with a scoop of vanilla ice cream', 40, 50, 8, 'Apples', 5),
('Sushi Rolls', 'Japanese delicacy of vinegared rice and fresh fish wrapped in seaweed', 'Japanese', 'sour', 5, 'Use sushi-grade fish for safe consumption', 'Wet your hands before handling rice to prevent sticking', 'Serve with soy sauce, pickled ginger, and wasabi', 60, 0, 4, 'Sushi rice', 6),
('Baklava', 'Traditional Middle Eastern dessert with layers of filo pastry and nuts', 'Middle Eastern', 'sweet', 4, 'Brush each layer of filo pastry with melted butter for richness', 'Cut baklava into diamond shapes before baking', 'Pour syrup over baklava while still hot', 45, 40, 16, 'Walnuts', 7),
('Tom Yum Soup', 'Spicy and sour Thai soup with shrimp and aromatic herbs', 'Thai', 'sour', 4, 'Add lemongrass and kaffir lime leaves for authentic flavor', 'Adjust spiciness with more or less chili paste', 'Garnish with fresh cilantro before serving', 15, 20, 4, 'Shrimp', 8),
('Chocolate Chip Cookies', 'Classic American cookies loaded with chocolate chips', 'American', 'sweet', 2, 'Chill cookie dough before baking for thicker cookies', 'Use a mix of milk and dark chocolate chips for variety', 'Bake until edges are golden brown but centers are still soft', 15, 12, 24, 'Chocolate chips', 9),
('Miso Soup', 'Traditional Japanese soup made with fermented soybean paste', 'Japanese', 'sour', 2, 'Add tofu and seaweed for extra flavor and texture', 'Do not boil miso paste to preserve its probiotic benefits', 'Garnish with thinly sliced green onions before serving', 10, 15, 4, 'Tofu', 10),
('Key Lime Pie', 'Refreshing dessert made with tangy key lime juice and graham cracker crust', 'American', 'sour', 3, 'Use freshly squeezed key lime juice for best flavor', 'Chill pie for at least 4 hours before serving', 'Top with whipped cream and lime zest for garnish', 30, 30, 8, 'Key lime juice', 11),
('Beef Stroganoff', 'Hearty Russian dish of tender beef in a creamy mushroom sauce', 'Russian', 'sour', 4, 'Slice beef thinly against the grain for tenderness', 'Cook mushrooms until golden brown for depth of flavor', 'Serve over egg noodles or mashed potatoes', 30, 30, 6, 'Beef', 12),
('Croissant', 'Flaky and buttery French pastry perfect for breakfast or brunch', 'French', 'sweet', 3, 'Use high-quality butter for best flavor and texture', 'Fold dough properly to create distinct layers', 'Bake until golden brown and puffed up', 60, 25, 12, 'Butter', 13),
('Pho', 'Vietnamese noodle soup with aromatic broth and tender beef or chicken', 'Vietnamese', 'sour', 4, 'Simmer bones and aromatics for several hours to develop rich flavor', 'Skim off any impurities that rise to the surface while cooking', 'Serve with fresh herbs, lime wedges, and bean sprouts', 20, 60, 4, 'Beef', 14),
('Pancakes', 'Fluffy and delicious breakfast staple topped with butter and maple syrup', 'American', 'sweet', 2, 'Let batter rest for 5 minutes before cooking for lighter pancakes', 'Flip pancakes when bubbles form on the surface', 'Keep cooked pancakes warm in a low oven while making the rest', 10, 15, 8, 'Flour', 15),
('Pasta Primavera', 'Light and fresh Italian pasta dish with seasonal vegetables', 'Italian', 'sour', 3, 'Use a variety of colorful vegetables for visual appeal', 'Cook pasta until al dente for best texture', 'Toss pasta with olive oil and Parmesan cheese before serving', 15, 20, 4, 'Pasta', 16),
('Cheesecake', 'Decadent dessert with a creamy filling and graham cracker crust', 'American', 'sweet', 4, 'Bake cheesecake in a water bath to prevent cracking', 'Chill cheesecake for at least 4 hours before serving', 'Top with fresh berries or fruit compote', 30, 60, 8, 'Cream cheese', 17),
('Ratatouille', 'Classic French vegetable stew bursting with flavor', 'French', 'sour', 3, 'Sauté vegetables separately before combining for optimal texture', 'Simmer stew over low heat to meld flavors together', 'Serve with crusty bread or over cooked grains', 30, 40, 6, 'Eggplant', 18),
('Tacos', 'Mexican street food favorite with seasoned meat and toppings', 'Mexican', 'sour', 2, 'Use homemade taco seasoning for authentic flavor', 'Warm tortillas on a hot skillet or grill before filling', 'Top with salsa, guacamole, and fresh cilantro', 20, 20, 4, 'Ground beef', 19),
('Pavlova', 'Light and airy dessert made with meringue and whipped cream', 'Australian', 'sweet', 3, 'Add a splash of vinegar to the meringue for stability', 'Pile high with whipped cream and fresh fruit just before serving', 'Dust with powdered sugar for a finishing touch', 20, 60, 8, 'Egg whites', 20),
('Sushi Burrito', 'Fusion of Japanese sushi and Mexican burrito in a convenient hand-held form', 'Japanese-Mexican', 'sour', 3, 'Use sushi-grade fish and fresh vegetables for filling', 'Roll tightly using a bamboo mat for best results', 'Serve with soy sauce and wasabi for dipping', 20, 0, 2, 'Sushi rice', 21),
('Risotto', 'Creamy Italian rice dish cooked with broth until tender', 'Italian', 'sour', 4, 'Toast rice in butter before adding broth for nutty flavor', 'Stir risotto constantly to release starch and create creaminess', 'Finish with a knob of butter and grated Parmesan cheese', 25, 30, 4, 'Arborio rice', 22),
('Biryani', 'Fragrant Indian rice dish with spiced meat or vegetables', 'Indian', 'sour', 4, 'Marinate meat with yogurt and spices for extra flavor', 'Layer rice and meat in a heavy-bottomed pot for even cooking', 'Garnish with fried onions and fresh cilantro before serving', 30, 45, 6, 'Basmati rice', 23),
('Lemon Bars', 'Tangy and sweet dessert with a buttery shortbread crust and lemon filling', 'American', 'sweet', 2, 'Chill lemon bars before cutting for clean edges', 'Dust with powdered sugar for a decorative finish', 'Store lemon bars in the refrigerator for up to 3 days', 30, 40, 12, 'Lemons', 24),
('Gazpacho', 'Refreshing Spanish cold soup made with tomatoes, peppers, and cucumbers', 'Spanish', 'sour', 2, 'Use ripe and flavorful tomatoes for best results', 'Chill gazpacho for at least 2 hours before serving', 'Garnish with chopped fresh herbs and a drizzle of olive oil', 20, 0, 4, 'Tomatoes', 25),
('Chicken Tikka Masala', 'Creamy Indian curry with tender chicken in a spiced tomato sauce', 'Indian', 'sour', 4, 'Marinate chicken in yogurt and spices for at least 1 hour', 'Simmer curry gently to develop flavors and tenderize chicken', 'Serve with basmati rice and naan bread for a complete meal', 30, 40, 4, 'Chicken', 26),
('Creme Brulee', 'Decadent French dessert with a rich custard base and caramelized sugar topping', 'French', 'sweet', 4, 'Scrape vanilla bean seeds into custard for intense flavor', 'Use a kitchen torch to caramelize sugar just before serving', 'Chill custards in the refrigerator for at least 2 hours', 30, 45, 6, 'Egg yolks', 27),
('Chicken Satay', 'Indonesian street food favorite with grilled chicken skewers and peanut sauce', 'Indonesian', 'sour', 3, 'Marinate chicken in coconut milk and spices for at least 2 hours', 'Grill skewers over high heat for charred edges and juicy meat', 'Serve with peanut sauce and cucumber salad', 30, 15, 4, 'Chicken', 28),
('Lemon Meringue Pie', 'Classic American dessert with tart lemon filling and fluffy meringue topping', 'American', 'sweet', 3, 'Use freshly squeezed lemon juice for best flavor', 'Spread meringue over hot filling to prevent weeping', 'Brown meringue under broiler for a golden finish', 45, 30, 8, 'Lemons', 29),
('Beef Wellington', 'Elegant British dish of tender beef wrapped in puff pastry', 'British', 'sour', 5, 'Sear beef fillet before wrapping in pastry for extra flavor', 'Chill pastry-wrapped beef before baking to prevent soggy crust', 'Slice Wellington into thick portions before serving', 45, 40, 4, 'Beef fillet', 30),
('Pasta alla Puttanesca', 'Italian pasta dish with a bold and flavorful tomato sauce', 'Italian', 'sour', 3, 'Use high-quality canned tomatoes for rich sauce', 'Add olives and capers for briny flavor', 'Top with fresh parsley and grated Parmesan cheese', 20, 20, 4, 'Pasta', 31),
('Black Forest Cake', 'Decadent German dessert with layers of chocolate cake, cherries, and whipped cream', 'German', 'sweet', 4, 'Use cherry liqueur to soak cake layers for extra flavor', 'Whip cream until stiff peaks form for stable frosting', 'Garnish with chocolate shavings and fresh cherries', 60, 45, 12, 'Cherries', 32),
('Shakshuka', 'Middle Eastern dish of poached eggs in a spicy tomato and pepper sauce', 'Middle Eastern', 'sour', 3, 'Simmer sauce until thick and flavorful before adding eggs', 'Make wells in sauce for eggs to nestle into', 'Serve with crusty bread for dipping and scooping', 20, 25, 4, 'Eggs', 33),
('Moussaka', 'Greek casserole with layers of eggplant, spiced meat, and creamy bechamel sauce', 'Greek', 'sour', 4, 'Salt eggplant slices and let drain to remove bitterness', 'Brown meat well before layering in casserole dish', 'Let moussaka rest for at least 30 minutes before slicing', 45, 60, 6, 'Eggplant', 34),
('Lava Cake', 'Indulgent dessert with a gooey chocolate center and crispy exterior', 'American', 'sweet', 3, 'Chill batter for 10 minutes before baking for molten center', 'Use high-quality chocolate with at least 60% cocoa solids', 'Serve immediately with vanilla ice cream or whipped cream', 15, 10, 4, 'Chocolate', 35),
('Tacos al Pastor', 'Mexican street food favorite with marinated pork cooked on a vertical spit', 'Mexican', 'sour', 3, 'Marinate pork with pineapple and spices for at least 4 hours', 'Cook pork on a vertical spit for authentic flavor and texture', 'Serve in corn tortillas with diced onion, cilantro, and salsa', 30, 20, 4, 'Pork', 36),
('Mushroom Risotto', 'Creamy Italian rice dish with mushrooms and Parmesan cheese', 'Italian', 'sour', 3, 'Sauté mushrooms until golden brown for depth of flavor', 'Stir in Parmesan cheese and butter for richness', 'Garnish with fresh parsley and extra cheese before serving', 25, 30, 4, 'Mushrooms', 37),
('Crepes', 'Thin French pancakes perfect for sweet or savory fillings', 'French', 'sweet', 2, 'Let batter rest for 30 minutes to relax gluten for tender crepes', 'Cook crepes over medium heat until lightly golden on both sides', 'Fill with Nutella, berries, or ham and cheese', 10, 20, 8, 'Flour', 38),
('Tandoori Chicken', 'Indian dish of marinated chicken roasted in a clay oven', 'Indian', 'sour', 4, 'Marinate chicken in yogurt and spices for at least 2 hours', 'Roast chicken at high temperature for charred edges', 'Serve with naan bread, rice, and cucumber raita', 30, 30, 4, 'Chicken', 39),
('Pav Bhaji', 'Indian street food favorite with spiced mashed vegetables served with buttered bread', 'Indian', 'sour', 2, 'Cook vegetables until soft before mashing for smooth texture', 'Toast bread with butter for extra flavor and crispiness', 'Serve with chopped onions, lemon wedges, and cilantro', 30, 40, 4, 'Vegetables', 40),
('Coq au Vin', 'French dish of chicken braised with wine, mushrooms, and onions', 'French', 'sour', 4, 'Marinate chicken in wine and aromatics for at least 2 hours', 'Simmer chicken until tender and sauce is reduced', 'Serve with crusty bread or over cooked noodles', 30, 60, 4, 'Chicken', 41),
('Cinnamon Rolls', 'Sweet and fluffy rolls filled with cinnamon sugar and topped with cream cheese icing', 'American', 'sweet', 3, 'Roll dough tightly to create distinct layers in the rolls', 'Let rolls rise in a warm place until doubled in size', 'Spread icing over warm rolls for gooey texture', 30, 25, 12, 'Cinnamon', 42),
('Ramen', 'Japanese noodle soup with flavorful broth, noodles, and toppings', 'Japanese', 'sour', 3, 'Simmer broth with kombu and bonito flakes for umami flavor', 'Cook noodles until just tender before serving', 'Top with sliced pork, soft-boiled egg, and nori', 20, 20, 4, 'Noodles', 43),
('Apple Crisp', 'Classic American dessert with baked apples and crispy oat topping', 'American', 'sweet', 2, 'Toss apples with sugar, cinnamon, and lemon juice for flavor', 'Make topping with oats, flour, butter, and brown sugar', 'Serve warm with vanilla ice cream or whipped cream', 20, 40, 8, 'Apples', 44),
('Fettuccine Alfredo', 'Creamy Italian pasta dish with butter, cream, and Parmesan cheese', 'Italian', 'sour', 3, 'Cook pasta until al dente before tossing with sauce', 'Use freshly grated Parmesan cheese for best flavor', 'Garnish with chopped parsley before serving', 20, 20, 4, 'Pasta', 45),
('Tiramisu Cheesecake', 'Decadent dessert combining the flavors of tiramisu and cheesecake', 'Italian', 'sweet', 4, 'Layer cheesecake batter and ladyfingers for a unique texture', 'Soak ladyfingers in coffee liqueur for authentic flavor', 'Dust with cocoa powder just before serving', 45, 50, 12, 'Mascarpone', 46),
('Shrimp Scampi', 'Italian-American dish of shrimp cooked in garlic, butter, and white wine sauce', 'Italian-American', 'sour', 3, 'Sauté shrimp until pink and opaque before adding sauce', 'Cook pasta until al dente and toss with shrimp and sauce', 'Garnish with chopped parsley and lemon wedges', 15, 20, 4, 'Shrimp', 47),
('Chocolate Mousse', 'Indulgent dessert made with rich chocolate and whipped cream', 'French', 'sweet', 2, 'Use high-quality chocolate with at least 60% cocoa solids', 'Fold whipped cream into chocolate mixture gently for light texture', 'Chill mousse for at least 2 hours before serving', 20, 0, 4, 'Chocolate', 48),
('Chicken Noodle Soup', 'Comforting soup made with tender chicken, vegetables, and egg noodles', 'American', 'sour', 2, 'Simmer chicken with aromatics until tender before shredding', 'Cook noodles separately and add to soup just before serving', 'Garnish with chopped parsley and a squeeze of lemon', 15, 30, 4, 'Chicken', 49),
('Beef Tacos', 'Mexican street food favorite with seasoned beef and toppings', 'Mexican', 'sour', 2, 'Season beef with chili powder, cumin, and garlic for flavor', 'Warm tortillas on a hot skillet or grill before filling', 'Top with salsa, guacamole, and shredded cheese', 20, 20, 4, 'Ground beef', 50);


INSERT INTO steps (step_id, short_description, recipe_id, step_number) VALUES
-- Chocolate Cake (recipe_id: 1)
(1, 'Preheat the oven to 350°F (175°C).', 1, 1),
(2, 'Grease and flour a cake pan.', 1, 2),
(3, 'Mix dry ingredients (flour, sugar, cocoa powder, baking powder, baking soda, salt) in a bowl.', 1, 3),
(4, 'Add wet ingredients (eggs, milk, oil, vanilla extract) to the dry mixture and beat until smooth.', 1, 4),
(5, 'Pour batter into the cake pan and bake for 30-35 minutes.', 1, 5),
(6, 'Let cool before frosting.', 1, 6),

-- Spaghetti Carbonara (recipe_id: 2)
(7, 'Cook spaghetti in salted boiling water until al dente.', 2, 1),
(8, 'Meanwhile, fry diced pancetta or bacon until crispy.', 2, 2),
(9, 'Whisk eggs, grated Parmesan cheese, and black pepper in a bowl.', 2, 3),
(10, 'Drain cooked pasta and add it to the pan with the pancetta.', 2, 4),
(11, 'Remove from heat and quickly stir in the egg mixture until the pasta is coated.', 2, 5),
(12, 'Serve immediately, garnished with additional Parmesan and black pepper.', 2, 6),

-- Tiramisu (recipe_id: 3)
(13, 'Mix espresso and rum in a shallow dish.', 3, 1),
(14, 'Dip ladyfinger biscuits briefly into the espresso mixture and line them in the bottom of a dish.', 3, 2),
(15, 'Beat together mascarpone cheese, sugar, and vanilla until smooth.', 3, 3),
(16, 'Spread half of the mascarpone mixture over the ladyfingers.', 3, 4),
(17, 'Repeat with another layer of dipped ladyfingers and mascarpone mixture.', 3, 5),
(18, 'Dust the top with cocoa powder.', 3, 6),
(19, 'Refrigerate for at least 4 hours before serving.', 3, 7),
-- Apple Pie (recipe_id: 5)
(20, 'Preheat the oven to 375°F (190°C).', 5, 1),
(21, 'Roll out one pie crust and place it in a pie dish.', 5, 2),
(22, 'Mix sliced apples, sugar, flour, cinnamon, and nutmeg in a bowl.', 5, 3),
(23, 'Pour the apple mixture into the pie crust.', 5, 4),
(24, 'Dot the top with butter and cover with the second pie crust.', 5, 5),
(25, 'Crimp the edges and cut slits in the top crust to vent.', 5, 6),
(26, 'Bake for 45-50 minutes, or until the crust is golden and the filling is bubbly.', 5, 7),

-- Sushi Rolls (recipe_id: 6)
(27, 'Cook sushi rice according to package instructions.', 6, 1),
(28, 'Lay a sheet of nori on a bamboo sushi mat.', 6, 2),
(29, 'Spread a thin layer of rice over the nori, leaving a border at the top.', 6, 3),
(30, 'Arrange fillings (e.g., fish, avocado, cucumber) on the rice.', 6, 4),
(31, 'Roll the sushi tightly using the bamboo mat.', 6, 5),
(32, 'Slice the roll into bite-sized pieces with a sharp knife.', 6, 6),
(33, 'Serve with soy sauce, pickled ginger, and wasabi.', 6, 7),

-- Baklava (recipe_id: 7)
(34, 'Preheat the oven to 350°F (175°C).', 7, 1),
(35, 'Mix chopped nuts, sugar, and cinnamon in a bowl.', 7, 2),
(36, 'Brush melted butter onto phyllo dough sheets.', 7, 3),
(37, 'Layer phyllo sheets in a baking dish, sprinkling nut mixture between layers.', 7, 4),
(38, 'Cut the baklava into diamond shapes with a sharp knife.', 7, 5),
(39, 'Bake for 45-50 minutes, or until golden brown and crisp.', 7, 6),
(40, 'Pour cooled syrup over the hot baklava and let it soak.', 7, 7),
(41, 'Allow to cool completely before serving.', 7, 8),
-- Tom Yum Soup (recipe_id: 8)
(42, 'Bring chicken broth to a boil in a pot.', 8, 1),
(43, 'Add lemongrass, kaffir lime leaves, galangal, and chilies to the broth.', 8, 2),
(44, 'Simmer for 10 minutes to infuse flavors.', 8, 3),
(45, 'Add shrimp, mushrooms, tomatoes, and lime juice to the pot.', 8, 4),
(46, 'Cook until shrimp are pink and opaque.', 8, 5),
(47, 'Season with fish sauce, sugar, and chili paste to taste.', 8, 6),
(48, 'Garnish with cilantro and serve hot.', 8, 7),

-- Chocolate Chip Cookies (recipe_id: 9)
(49, 'Preheat the oven to 375°F (190°C).', 9, 1),
(50, 'Cream together butter, sugar, and brown sugar in a bowl.', 9, 2),
(51, 'Add eggs and vanilla extract, beating until smooth.', 9, 3),
(52, 'Mix flour, baking soda, and salt in a separate bowl.', 9, 4),
(53, 'Gradually add the dry ingredients to the wet mixture.', 9, 5),
(54, 'Stir in chocolate chips.', 9, 6),
(55, 'Drop spoonfuls of dough onto a baking sheet.', 9, 7),
(56, 'Bake for 9-11 minutes, or until golden brown.', 9, 8),

-- Miso Soup (recipe_id: 10)
(57, 'Bring dashi broth to a simmer in a pot.', 10, 1),
(58, 'Add miso paste to the broth and whisk until dissolved.', 10, 2),
(59, 'Add tofu, sliced green onions, and wakame to the pot.', 10, 3),
(60, 'Simmer for 5 minutes, being careful not to boil.', 10, 4),
(61, 'Remove from heat and serve hot.', 10, 5),

-- Key Lime Pie (recipe_id: 11)
(62, 'Preheat the oven to 350°F (175°C).', 11, 1),
(63, 'Mix graham cracker crumbs, sugar, and melted butter in a bowl.', 11, 2),
(64, 'Press the mixture into a pie dish to form the crust.', 11, 3),
(65, 'Bake the crust for 10 minutes, then let it cool.', 11, 4),
(66, 'Mix sweetened condensed milk, key lime juice, and lime zest in a bowl.', 11, 5),
(67, 'Pour the filling into the cooled crust.', 11, 6),
(68, 'Bake for 15 minutes, or until set.', 11, 7),
(69, 'Let the pie cool, then refrigerate for at least 2 hours before serving.', 11, 8),
-- Beef Stroganoff (recipe_id: 12)
(70, 'Cook egg noodles according to package instructions.', 12, 1),
(71, 'Season beef strips with salt and pepper.', 12, 2),
(72, 'Sear beef in a hot skillet until browned.', 12, 3),
(73, 'Remove beef from skillet and set aside.', 12, 4),
(74, 'In the same skillet, sauté onions and mushrooms until softened.', 12, 5),
(75, 'Stir in flour and cook for 1 minute.', 12, 6),
(76, 'Add beef broth and bring to a simmer, stirring until thickened.', 12, 7),
(77, 'Return beef to the skillet and simmer until heated through.', 12, 8),
(78, 'Stir in sour cream and serve over cooked noodles.', 12, 9),

-- Croissant (recipe_id: 13)
(79, 'Mix yeast, warm water, and sugar in a bowl.', 13, 1),
(80, 'Let the mixture sit until frothy.', 13, 2),
(81, 'Mix flour, salt, and butter in a separate bowl.', 13, 3),
(82, 'Add yeast mixture to the flour mixture and knead until smooth.', 13, 4),
(83, 'Let the dough rise until doubled in size.', 13, 5),
(84, 'Roll out the dough and cut into triangles.', 13, 6),
(85, 'Roll up each triangle starting from the wide end.', 13, 7),
(86, 'Let the croissants rise again.', 13, 8),
(87, 'Bake until golden brown.', 13, 9),

-- Pho (recipe_id: 14)
(88, 'Toast spices (cinnamon, cloves, star anise, coriander seeds) in a dry skillet until fragrant.', 14, 1),
(89, 'Add toasted spices to a pot with beef broth and bring to a simmer.', 14, 2),
(90, 'Meanwhile, cook rice noodles according to package instructions.', 14, 3),
(91, 'Thinly slice beef and divide among serving bowls.', 14, 4),
(92, 'Pour hot broth over the beef.', 14, 5),
(93, 'Top with cooked noodles and garnishes (bean sprouts, basil, lime, jalapeños, onions).', 14, 6),
(94, 'Serve with hoisin sauce and sriracha on the side.', 14, 7),

-- Pancakes (recipe_id: 15)
(95, 'Preheat a griddle or skillet over medium heat.', 15, 1),
(96, 'Mix flour, sugar, baking powder, and salt in a bowl.', 15, 2),
(97, 'In a separate bowl, whisk together milk, egg, and melted butter.', 15, 3),
(98, 'Pour the wet ingredients into the dry ingredients and mix until just combined.', 15, 4),
(99, 'Pour batter onto the hot griddle and cook until bubbles form on the surface.', 15, 5),
(100, 'Flip and cook until golden brown on the other side.', 15, 6),
(101, 'Serve hot with butter and maple syrup.', 15, 7),

-- Pasta Primavera (recipe_id: 16)
(102, 'Cook pasta according to package instructions.', 16, 1),
(103, 'Meanwhile, heat olive oil in a large skillet over medium heat.', 16, 2),
(104, 'Add sliced vegetables (bell peppers, carrots, broccoli, snap peas) to the skillet.', 16, 3),
(105, 'Sauté until vegetables are tender-crisp.', 16, 4),
(106, 'Add cooked pasta to the skillet and toss to combine.', 16, 5),
(107, 'Season with salt, pepper, and grated Parmesan cheese.', 16, 6),
(108, 'Serve hot, garnished with chopped parsley.', 16, 7),

-- Cheesecake (recipe_id: 17)
(109, 'Preheat the oven to 325°F (160°C).', 17, 1),
(110, 'Mix graham cracker crumbs, sugar, and melted butter in a bowl.', 17, 2),
(111, 'Press the mixture into the bottom of a springform pan.', 17, 3),
(112, 'Beat cream cheese, sugar, and vanilla extract until smooth.', 17, 4),
(113, 'Add eggs one at a time, beating well after each addition.', 17, 5),
(114, 'Pour the filling over the crust and smooth the top.', 17, 6),
(115, 'Bake for 50-60 minutes, or until the center is set.', 17, 7),
(116, 'Let the cheesecake cool in the oven with the door ajar.', 17, 8),
(117, 'Chill in the refrigerator for at least 4 hours before serving.', 17, 9),


-- Ratatouille (recipe_id: 18)
(118, 'Preheat the oven to 375°F (190°C).', 18, 1),
(119, 'Slice vegetables (eggplant, zucchini, bell peppers, tomatoes, onions) thinly.', 18, 2),
(120, 'Arrange the vegetables in overlapping layers in a baking dish.', 18, 3),
(121, 'Drizzle with olive oil and season with salt, pepper, and herbs.', 18, 4),
(122, 'Cover the dish with foil and bake for 45 minutes.', 18, 5),
(123, 'Remove the foil and bake for an additional 15 minutes, or until vegetables are tender.', 18, 6),

-- Tacos (recipe_id: 19)
(124, 'Cook ground beef with taco seasoning in a skillet over medium heat.', 19, 1),
(125, 'Warm taco shells in the oven or microwave.', 19, 2),
(126, 'Fill each taco shell with seasoned beef.', 19, 3),
(127, 'Top with shredded lettuce, diced tomatoes, shredded cheese, and salsa.', 19, 4),
(128, 'Serve hot with sour cream and guacamole on the side.', 19, 5),

-- Pavlova (recipe_id: 20)
(129, 'Preheat the oven to 300°F (150°C).', 20, 1),
(130, 'Beat egg whites until stiff peaks form.', 20, 2),
(131, 'Gradually add sugar, beating until glossy.', 20, 3),
(132, 'Fold in cornstarch, vinegar, and vanilla extract.', 20, 4),
(133, 'Spoon the mixture onto a baking sheet lined with parchment paper.', 20, 5),
(134, 'Shape into a circle with a slight indentation in the center.', 20, 6),
(135, 'Bake for 1 hour, then turn off the oven and let the pavlova cool inside.', 20, 7),
(136, 'Whip cream and spread it over the pavlova.', 20, 8),
(137, 'Top with fresh fruit and serve.', 20, 9),

-- Sushi Burrito (recipe_id: 21)
(138, 'Lay a sheet of nori on a sushi mat.', 21, 1),
(139, 'Spread cooked sushi rice over the nori, leaving a border at the top.', 21, 2),
(140, 'Arrange fillings (e.g., fish, avocado, cucumber, carrots) on the rice.', 21, 3),
(141, 'Roll the sushi tightly using the bamboo mat.', 21, 4),
(142, 'Slice the roll in half crosswise.', 21, 5),
(143, 'Wrap each half in parchment paper for serving.', 21, 6),

-- Risotto (recipe_id: 22)
(144, 'Bring chicken broth to a simmer in a pot.', 22, 1),
(145, 'Sauté onions and garlic in olive oil until softened.', 22, 2),
(146, 'Add Arborio rice to the pot and cook until translucent.', 22, 3),
(147, 'Gradually add hot broth to the rice, stirring constantly.', 22, 4),
(148, 'Continue adding broth until the rice is creamy and tender.', 22, 5),
(149, 'Stir in grated Parmesan cheese and season with salt and pepper.', 22, 6),

-- Biryani (recipe_id: 23)
(150, 'Marinate chicken or meat in yogurt and spices.', 23, 1),
(151, 'Cook basmati rice with whole spices until partially cooked.', 23, 2),
(152, 'Layer the rice and marinated meat in a pot.', 23, 3),
(153, 'Cover and cook over low heat until the rice is fully cooked and the flavors are absorbed.', 23, 4),
(154, 'Garnish with fried onions, mint leaves, and cilantro.', 23, 5),

-- Lemon Bars (recipe_id: 24)
(155, 'Preheat the oven to 350°F (175°C).', 24, 1),
(156, 'Mix flour, powdered sugar, and butter in a bowl.', 24, 2),
(157, 'Press the mixture into the bottom of a baking dish.', 24, 3),
(158, 'Bake for 20 minutes, or until lightly golden.', 24, 4),
(159, 'Meanwhile, whisk together eggs, sugar, lemon juice, and lemon zest.', 24, 5),
(160, 'Pour the lemon mixture over the baked crust.', 24, 6),
(161, 'Bake for an additional 20-25 minutes, or until set.', 24, 7),
(162, 'Let cool, then dust with powdered sugar and cut into squares.', 24, 8),

-- Gazpacho (recipe_id: 25)
(163, 'Combine chopped tomatoes, cucumbers, bell peppers, onions, and garlic in a blender.', 25, 1),
(164, 'Blend until smooth, adding olive oil and vinegar while blending.', 25, 2),
(165, 'Season with salt, pepper, and hot sauce to taste.', 25, 3),
(166, 'Chill in the refrigerator for at least 2 hours before serving.', 25, 4),
(167, 'Serve cold, garnished with chopped herbs and croutons.', 25, 5),

-- Chicken Tikka Masala (recipe_id: 26)
(168, 'Marinate chicken in yogurt and spices for at least 1 hour.', 26, 1),
(169, 'Heat oil in a skillet and brown chicken on all sides.', 26, 2),
(170, 'Remove chicken from skillet and set aside.', 26, 3),
(171, 'In the same skillet, sauté onions, garlic, and ginger until softened.', 26, 4),
(172, 'Add tomato puree, spices, and cream to the skillet.', 26, 5),
(173, 'Simmer until the sauce thickens.', 26, 6),
(174, 'Return chicken to the skillet and simmer until heated through.', 26, 7),
(175, 'Serve hot with rice or naan.', 26, 8),

-- Creme Brulee (recipe_id: 27)
(176, 'Preheat the oven to 325°F (160°C).', 27, 1),
(177, 'Heat cream and vanilla bean in a saucepan until almost boiling.', 27, 2),
(178, 'In a bowl, whisk together egg yolks and sugar until pale and thick.', 27, 3),
(179, 'Slowly pour the hot cream mixture into the egg mixture, whisking constantly.', 27, 4),
(180, 'Strain the custard mixture and pour it into ramekins.', 27, 5),
(181, 'Place the ramekins in a baking dish and fill the dish with hot water.', 27, 6),
(182, 'Bake for 40-45 minutes, or until set but still jiggly in the center.', 27, 7),
(183, 'Chill in the refrigerator for at least 2 hours.', 27, 8),
(184, 'Sprinkle with sugar and caramelize with a torch just before serving.', 27, 9),

-- Chicken Satay (recipe_id: 28)
(185, 'Slice chicken into thin strips and thread onto skewers.', 28, 1),
(186, 'Mix coconut milk, peanut butter, soy sauce, lime juice, and curry powder in a bowl.', 28, 2),
(187, 'Marinate chicken skewers in the mixture for at least 1 hour.', 28, 3),
(188, 'Grill skewers over medium-high heat until cooked through and charred.', 28, 4),
(189, 'Serve hot with peanut sauce and cucumber salad.', 28, 5),

-- Lemon Meringue Pie (recipe_id: 29)
(190, 'Preheat the oven to 350°F (175°C).', 29, 1),
(191, 'Mix graham cracker crumbs, sugar, and melted butter in a bowl.', 29, 2),
(192, 'Press the mixture into the bottom of a pie dish.', 29, 3),
(193, 'Bake for 10 minutes, then let it cool.', 29, 4),
(194, 'Mix sugar, cornstarch, and water in a saucepan.', 29, 5),
(195, 'Cook over medium heat until thickened.', 29, 6),
(196, 'Stir in egg yolks, lemon juice, and lemon zest.', 29, 7),
(197, 'Pour the filling into the baked crust.', 29, 8),
(198, 'Beat egg whites until stiff peaks form.', 29, 9),
(199, 'Spread the meringue over the filling, sealing the edges.', 29, 10),
(200, 'Bake for 10-12 minutes, or until golden brown.', 29, 11),
(201, 'Let cool completely before serving.', 29, 12),

-- Beef Wellington (recipe_id: 30)
(202, 'Season beef tenderloin with salt and pepper.', 30, 1),
(203, 'Sear beef on all sides in a hot skillet.', 30, 2),
(204, 'Remove beef from skillet and let it cool.', 30, 3),
(205, 'Spread mushroom duxelles onto puff pastry.', 30, 4),
(206, 'Place beef on top of the mushroom layer.', 30, 5),
(207, 'Wrap the beef and mushrooms in the puff pastry, sealing the edges.', 30, 6),
(208, 'Brush with egg wash and score the top.', 30, 7),
(209, 'Bake for 35-40 minutes, or until pastry is golden brown.', 30, 8),

-- Pasta alla Puttanesca (recipe_id: 31)
(210, 'Cook pasta according to package instructions.', 31, 1),
(211, 'Meanwhile, heat olive oil in a skillet over medium heat.', 31, 2),
(212, 'Add anchovies, garlic, and red pepper flakes to the skillet.', 31, 3),
(213, 'Cook until anchovies dissolve and garlic is fragrant.', 31, 4),
(214, 'Stir in diced tomatoes, olives, capers, and oregano.', 31, 5),
(215, 'Simmer for 10-15 minutes, or until sauce thickens.', 31, 6),
(216, 'Add cooked pasta to the skillet and toss to combine.', 31, 7),
(217, 'Serve hot, garnished with chopped parsley and grated Parmesan cheese.', 31, 8),

-- Black Forest Cake (recipe_id: 32)
(218, 'Preheat the oven to 350°F (175°C).', 32, 1),
(219, 'Grease and flour two 9-inch cake pans.', 32, 2),
(220, 'Mix flour, sugar, cocoa powder, baking powder, baking soda, and salt in a bowl.', 32, 3),
(221, 'Add eggs, buttermilk, oil, and vanilla extract to the dry mixture.', 32, 4),
(222, 'Beat until smooth, then stir in hot coffee.', 32, 5),
(223, 'Divide batter evenly between the cake pans and bake for 30-35 minutes.', 32, 6),
(224, 'Let cakes cool in pans for 10 minutes, then transfer to wire racks to cool completely.', 32, 7),
(225, 'Whip cream until stiff peaks form.', 32, 8),
(226, 'Slice each cake layer in half horizontally.', 32, 9),
(227, 'Spread cherry pie filling between the layers.', 32, 10),
(228, 'Frost the cake with whipped cream and decorate with chocolate shavings and cherries.', 32, 11),

-- Shakshuka (recipe_id: 33)
(229, 'Heat olive oil in a skillet over medium heat.', 33, 1),
(230, 'Sauté onions, bell peppers, and garlic until softened.', 33, 2),
(231, 'Add diced tomatoes, paprika, cumin, and chili powder to the skillet.', 33, 3),
(232, 'Simmer for 10-15 minutes, or until the sauce thickens.', 33, 4),
(233, 'Make small wells in the sauce and crack eggs into them.', 33, 5),
(234, 'Cover and cook until eggs are set, about 5 minutes.', 33, 6),
(235, 'Garnish with chopped parsley and feta cheese.', 33, 7),
(236, 'Serve hot with crusty bread for dipping.', 33, 8),

-- Moussaka (recipe_id: 34)
(237, 'Preheat the oven to 375°F (190°C).', 34, 1),
(238, 'Slice eggplant and zucchini into thin rounds.', 34, 2),
(239, 'Arrange the slices in a single layer on baking sheets.', 34, 3),
(240, 'Brush with olive oil and season with salt and pepper.', 34, 4),
(241, 'Roast in the oven until tender and lightly browned, about 20 minutes.', 34, 5),
(242, 'Meanwhile, make the meat sauce by browning ground lamb with onions and garlic.', 34, 6),
(243, 'Add diced tomatoes, tomato paste, cinnamon, and oregano to the skillet.', 34, 7),
(244, 'Simmer for 10 minutes, then season with salt and pepper to taste.', 34, 8),
(245, 'Make the béchamel sauce by melting butter in a saucepan.', 34, 9),
(246, 'Whisk in flour, then gradually whisk in milk until smooth.', 34, 10),
(247, 'Cook until thickened, then season with nutmeg, salt, and pepper.', 34, 11),
(248, 'Layer roasted vegetables, meat sauce, and béchamel sauce in a baking dish.', 34, 12),
(249, 'Repeat layers until all ingredients are used, ending with béchamel sauce on top.', 34, 13),
(250, 'Bake for 45-50 minutes, or until golden brown and bubbly.', 34, 14),

-- Lava Cake (recipe_id: 35)
(251, 'Preheat the oven to 425°F (220°C).', 35, 1),
(252, 'Butter and flour four ramekins.', 35, 2),
(253, 'Microwave butter and chocolate in a bowl until melted.', 35, 3),
(254, 'Stir in powdered sugar and flour until smooth.', 35, 4),
(255, 'Add eggs and egg yolks, one at a time, stirring well after each addition.', 35, 5),
(256, 'Divide the batter evenly among the prepared ramekins.', 35, 6),
(257, 'Bake for 12-14 minutes, or until the edges are set but the center is still soft.', 35, 7),
(258, 'Let the cakes cool for 1 minute, then invert onto plates.', 35, 8),
(259, 'Dust with powdered sugar and serve immediately with vanilla ice cream.', 35, 9),

-- Tacos al Pastor (recipe_id: 36)
(260, 'Marinate thinly sliced pork in a mixture of pineapple juice, vinegar, and spices.', 36, 1),
(261, 'Thread marinated pork onto skewers.', 36, 2),
(262, 'Grill skewers over medium-high heat until charred and cooked through.', 36, 3),
(263, 'Meanwhile, heat corn tortillas on a grill or skillet.', 36, 4),
(264, 'Slice grilled pork thinly and serve in tortillas with diced pineapple, onions, and cilantro.', 36, 5),

-- Mushroom Risotto (recipe_id: 37)
(265, 'Bring chicken or vegetable broth to a simmer in a pot.', 37, 1),
(266, 'Sauté onions and garlic in olive oil until softened.', 37, 2),
(267, 'Add Arborio rice to the pot and cook until translucent.', 37, 3),
(268, 'Gradually add hot broth to the rice, stirring constantly.', 37, 4),
(269, 'Continue adding broth until the rice is creamy and tender.', 37, 5),
(270, 'Stir in sautéed mushrooms and grated Parmesan cheese.', 37, 6),

-- Crepes (recipe_id: 38)
(271, 'Whisk together flour, eggs, milk, melted butter, sugar, and salt until smooth.', 38, 1),
(272, 'Heat a lightly greased skillet over medium heat.', 38, 2),
(273, 'Pour a small amount of batter into the skillet, swirling to coat the bottom.', 38, 3),
(274, 'Cook until the edges are golden brown and the top is set.', 38, 4),
(275, 'Flip the crepe and cook for an additional 30 seconds.', 38, 5),
(276, 'Repeat with remaining batter.', 38, 6),
(277, 'Serve warm with your choice of fillings (e.g., Nutella, fruit, whipped cream).', 38, 7),

-- Tandoori Chicken (recipe_id: 39)
(278, 'Make a marinade with yogurt, lemon juice, ginger, garlic, and spices.', 39, 1),
(279, 'Coat chicken pieces in the marinade and refrigerate for at least 2 hours.', 39, 2),
(280, 'Preheat the grill to medium-high heat.', 39, 3),
(281, 'Remove chicken from marinade and grill until charred and cooked through.', 39, 4),
(282, 'Serve hot with naan, rice, and cucumber raita.', 39, 5),

-- Pav Bhaji (recipe_id: 40)
(283, 'Boil potatoes, cauliflower, peas, and carrots until tender.', 40, 1),
(284, 'Mash the boiled vegetables until smooth.', 40, 2),
(285, 'Heat butter in a skillet and sauté onions, bell peppers, and garlic until soft.', 40, 3),
(286, 'Add chopped tomatoes, pav bhaji masala, and chili powder to the skillet.', 40, 4),
(287, 'Cook until tomatoes break down and mixture thickens.', 40, 5),
(288, 'Add mashed vegetables to the skillet and mix well.', 40, 6),
(289, 'Cook until heated through and flavors are blended.', 40, 7),
(290, 'Serve hot with buttered buns, chopped onions, and cilantro.', 40, 8),

-- Coq au Vin (recipe_id: 41)
(291, 'Season chicken pieces with salt and pepper.', 41, 1),
(292, 'Sear chicken in a hot skillet until browned.', 41, 2),
(293, 'Remove chicken from skillet and set aside.', 41, 3),
(294, 'Sauté onions, carrots, and mushrooms in the same skillet until softened.', 41, 4),
(295, 'Add garlic and tomato paste to the skillet.', 41, 5),
(296, 'Deglaze the skillet with red wine, scraping up any browned bits.', 41, 6),
(297, 'Return chicken to the skillet and add chicken broth and herbs.', 41, 7),
(298, 'Simmer until chicken is cooked through and sauce is thickened.', 41, 8),
(299, 'Serve hot, garnished with chopped parsley.', 41, 9),

-- Cinnamon Rolls (recipe_id: 42)
(300, 'Mix yeast, warm milk, and sugar in a bowl.', 42, 1),
(301, 'Let the mixture sit until frothy.', 42, 2),
(302, 'Mix in flour, melted butter, and eggs to form a dough.', 42, 3),
(303, 'Knead the dough until smooth, then let it rise until doubled in size.', 42, 4),
(304, 'Roll out the dough into a rectangle.', 42, 5),
(305, 'Spread softened butter over the dough, then sprinkle with cinnamon and sugar.', 42, 6),
(306, 'Roll up the dough tightly, then slice into rolls.', 42, 7),
(307, 'Place the rolls in a greased baking dish and let them rise again.', 42, 8),
(308, 'Bake for 20-25 minutes, or until golden brown.', 42, 9),
(309, 'Mix powdered sugar, milk, and vanilla extract to make icing.', 42, 10),
(310, 'Drizzle icing over warm cinnamon rolls.', 42, 11),

-- Ramen (recipe_id: 43)
(311, 'Bring chicken or pork broth to a boil in a pot.', 43, 1),
(312, 'Meanwhile, cook ramen noodles according to package instructions.', 43, 2),
(313, 'Divide cooked noodles among serving bowls.', 43, 3),
(314, 'Top noodles with sliced cooked pork, soft-boiled eggs, and vegetables.', 43, 4),
(315, 'Pour hot broth over the noodles and garnish with green onions and nori.', 43, 5),
(316, 'Serve hot, with chili oil and soy sauce on the side.', 43, 6),

-- Apple Crisp (recipe_id: 44)
(317, 'Preheat the oven to 375°F (190°C).', 44, 1),
(318, 'Mix sliced apples with sugar, flour, and cinnamon.', 44, 2),
(319, 'Spread the apple mixture in a baking dish.', 44, 3),
(320, 'Mix oats, flour, brown sugar, cinnamon, and melted butter in a bowl.', 44, 4),
(321, 'Sprinkle the oat mixture over the apples in the baking dish.', 44, 5),
(322, 'Bake for 30-35 minutes, or until the topping is golden brown and the apples are tender.', 44, 6),
(323, 'Serve warm with vanilla ice cream or whipped cream.', 44, 7),

-- Fettuccine Alfredo (recipe_id: 45)
(324, 'Cook fettuccine according to package instructions.', 45, 1),
(325, 'Meanwhile, melt butter in a skillet over medium heat.', 45, 2),
(326, 'Add minced garlic and cook until fragrant.', 45, 3),
(327, 'Whisk in heavy cream and grated Parmesan cheese.', 45, 4),
(328, 'Simmer until the sauce thickens, then season with salt and pepper.', 45, 5),
(329, 'Add cooked fettuccine to the skillet and toss to coat in the sauce.', 45, 6),
(330, 'Serve hot, garnished with chopped parsley and extra Parmesan cheese.', 45, 7),

-- Tiramisu Cheesecake (recipe_id: 46)
(331, 'Preheat the oven to 350°F (175°C).', 46, 1),
(332, 'Mix graham cracker crumbs, sugar, and melted butter in a bowl.', 46, 2),
(333, 'Press the mixture into the bottom of a springform pan.', 46, 3),
(334, 'Beat cream cheese, sugar, and vanilla extract until smooth.', 46, 4),
(335, 'Add eggs one at a time, beating well after each addition.', 46, 5),
(336, 'Pour half of the cheesecake filling over the crust.', 46, 6),
(337, 'Dip ladyfingers in espresso and layer them over the filling.', 46, 7),
(338, 'Spread the remaining filling over the ladyfingers.', 46, 8),
(339, 'Bake for 45-50 minutes, or until the center is set.', 46, 9),
(340, 'Let the cheesecake cool in the oven with the door ajar.', 46, 10),
(341, 'Chill in the refrigerator for at least 4 hours before serving.', 46, 11),

-- Beef Tacos (recipe_id 50)
(342, 'Brown ground beef in a skillet over medium heat.', 50, 1),
(343, 'Add taco seasoning and water, simmer until thickened.', 50, 2),
(344, 'Warm taco shells in the oven or microwave.', 50, 3),
(345, 'Fill taco shells with seasoned beef and desired toppings.', 50, 4),
(346, 'Serve immediately and enjoy!', 50, 5),

-- Chicken Noodle Soup (recipe_id 49)
(347, 'Bring a pot of water to a boil and cook egg noodles.', 49, 1),
(348, 'In a separate pot, sauté diced onions, carrots, and celery until softened.', 49, 2),
(349, 'Add cooked chicken, chicken broth, and seasonings to the pot.', 49, 3),
(350, 'Simmer soup until flavors meld together.', 49, 4),
(351, 'Add cooked noodles to the soup and simmer until heated through.', 49, 5),
(352, 'Serve hot, garnished with chopped parsley if desired.', 49, 6),

-- Chocolate Mousse (recipe_id 48)
(353, 'Melt chocolate in a heatproof bowl set over a pot of simmering water.', 48, 1),
(354, 'In a separate bowl, whip heavy cream until stiff peaks form.', 48, 2),
(355, 'Gently fold whipped cream into melted chocolate until combined.', 48, 3),
(356, 'Pour mixture into serving glasses or bowls.', 48, 4),
(357, 'Chill in the refrigerator for at least 2 hours before serving.', 48, 5),

-- Shrimp Scampi (recipe_id 47)
(358, 'Cook shrimp in melted butter and garlic until pink and opaque.', 47, 1),
(359, 'Add white wine and lemon juice to the pan, simmer until slightly reduced.', 47, 2),
(360, 'Toss cooked pasta with the shrimp and sauce until well coated.', 47, 3),
(361, 'Serve hot, garnished with chopped parsley and lemon wedges.', 47, 4);


UPDATE ingredients
SET quantity = FLOOR(RAND() * 401) -- RAND() generates a random value between 0 and 1, multiplying it by 601 gives you a random number between 0 and 600
;
Update ingredients
SET quantity='1 cups' where recipe_id=1 and name='Flour';

-- Insert data into the national_cuisine table
DELETE FROM national_cuisine;
INSERT INTO national_cuisine (cuisine_name, cuisine_id, recipe_id, cook_id) VALUES
('American', 1, 1, 1),
('Italian', 2, 2, 2),
('Italian', 2, 3, 3),
('Thai', 3, 4, 4),
('American', 1, 5, 5),
('Japanese', 4, 6, 6),
('Middle Eastern', 5, 7, 7),
('Thai', 3, 8, 8),
('American', 1, 9, 9),
('Japanese', 4, 10, 10),
('American', 1, 11, 11),
('Russian', 6, 12, 12),
('French', 7, 13, 13),
('Vietnamese', 8, 14, 14),
('American', 1, 15, 15),
('Italian', 2, 16, 16),
('American', 1, 17, 17),
('French',7, 18, 18),
('Mexican', 9, 19, 19),
('Australian', 10, 20, 20),
('Japanese', 4, 21, 21),
('Italian', 2, 22, 22),
('Indian', 11, 23, 23),
('American', 1, 24, 24),
('Spanish', 12, 25, 25),
('Indian', 11, 26, 26),
('French', 7, 27, 27),
('Indonesian', 12, 28, 28),
('American', 1, 29, 29),
('British', 13, 30, 20),
('Italian', 2, 31, 31),
('German', 14, 32, 32),
('Middle Eastern', 5, 33, 33),
('Greek', 15, 34, 34),
('American', 1, 35, 35),
('Mexican', 9, 36, 36),
('Italian', 2, 37, 37),
('French', 7, 38, 38),
('Indian', 11, 39, 39),
('Indian', 11, 40, 40),
('French', 7, 41, 41),
('American', 1, 42, 42),
('Japanese', 4, 43, 43),
('American', 1, 44, 44),
('Italian', 2, 45, 45),
('Italian', 2, 46, 46),
('Italian', 2, 47, 47),
('French', 7, 48, 48),
('American', 1, 49,49),
('Mexican', 9, 50, 50);

INSERT INTO national_cuisine (cuisine_name, cuisine_id, recipe_id, cook_id) VALUES
('American', 1, 1, 50),
('Italian', 2, 2, 49),
('Italian', 2, 3, 48),
('Thai', 3, 4, 47),
('American', 1, 5, 49),
('Japanese', 4, 6, 45),
('Middle Eastern', 5, 7, 44),
('Thai', 3, 8, 43),
('American', 1, 9, 42),
('Japanese', 4, 10, 41),
('American', 1, 11, 40),
('Russian', 6, 12, 39),
('French', 7, 13, 39),
('Vietnamese', 8, 14, 37),
('American', 1, 15, 36),
('Italian', 2, 16, 35),
('American', 1, 17, 34),
('French',7, 18, 33),
('Mexican', 9, 19, 32),
('Australian', 10, 20, 31),
('Japanese', 4, 21, 30),
('Italian', 2, 22, 29),
('Indian', 11, 23, 28),
('American', 1, 24, 27),
('Spanish', 12, 25, 26),
('Indian', 11, 26, 25),
('French', 7, 27, 24),
('Indonesian', 12, 28, 23),
('American', 1, 29, 22),
('British', 13, 30, 21),
('Italian', 2, 31, 20),
('German', 14, 32, 19),
('Middle Eastern', 5, 33, 18),
('Greek', 15, 34, 17),
('American', 1, 35, 16),
('Mexican', 9, 36, 15),
('Italian', 2, 37, 14),
('French', 7, 38, 13),
('Indian', 11, 39, 12),
('Indian', 11, 40, 11),
('French', 7, 41, 9),
('American', 1, 42, 10),
('Japanese', 4, 43, 8),
('American', 1, 44, 7),
('Italian', 2, 45, 6),
('Italian', 2, 46, 5),
('Italian', 2, 47, 4),
('French', 7, 48, 3),
('American', 1, 49, 2),
('Mexican', 9, 50, 1);

INSERT INTO national_cuisine (cuisine_name, cuisine_id, recipe_id, cook_id) VALUES
('American', 1, 1, 34),
('Italian', 2, 2, 50),
('Italian', 2, 3, 32),
('Thai', 3, 4, 45),
('American', 1, 5, 36),
('Japanese', 4, 6, 27),
('Middle Eastern', 5, 7, 12),
('Thai', 3, 8, 22),
('American', 1, 9, 26),
('Japanese', 4, 10, 46),
('American', 1, 11, 42),
('Russian', 6, 12, 33),
('French', 7, 13, 49),
('Vietnamese', 8, 14, 39),
('American', 1, 15, 35),
('Italian', 2, 16, 32),
('American', 1, 17, 29),
('French',7, 18, 28),
('Mexican', 9, 19, 14),
('Australian', 10, 20, 19),
('Japanese', 4, 21, 46),
('Italian', 2, 22, 37),
('Indian', 11, 23, 28),
('American', 1, 24, 15),
('Spanish', 12, 25,5),
('Indian', 11, 26, 6),
('French', 7, 27, 36),
('Indonesian', 12, 28,9),
('American', 1, 29, 23),
('British', 13, 30, 7),
('Italian', 2, 31, 1),
('German', 14, 32, 50),
('Middle Eastern', 5, 33, 12),
('Greek', 15, 34, 4),
('American', 1, 35, 19),
('Mexican', 9, 36, 29),
('Italian', 2, 37, 27),
('French', 7, 38, 42),
('Indian', 11, 39, 47),
('Indian', 11, 40, 19),
('French', 7, 41, 35),
('American', 1, 42,45),
('Japanese', 4, 43, 17),
('American', 1, 44, 42),
('Italian', 2, 45, 23),
('Italian', 2, 46, 15),
('Italian', 2, 47, 32),
('French', 7, 48, 43),
('American', 1, 49, 13),
('Mexican', 9, 50, 35);



INSERT INTO nutritial_info (recipe_id, fat_per_portion, protein_per_portion, carbohydrates_per_portion, total_cal_per_portion) VALUES
(1, 20, 5, 40, 350),       -- Chocolate Cake
(2, 15, 25, 50, 450),      -- Spaghetti Carbonara
(3, 30, 10, 35, 400),      -- Tiramisu
(4, 10, 20, 60, 420),      -- Pad Thai
(5, 18, 3, 40, 320),       -- Apple Pie
(6, 12, 15, 50, 380),      -- Sushi Rolls
(7, 25, 5, 35, 380),       -- Baklava
(8, 8, 15, 30, 280),       -- Tom Yum Soup
(9, 22, 4, 45, 350),       -- Chocolate Chip Cookies
(10, 5, 10, 20, 180),      -- Miso Soup
(11, 15, 3, 30, 300),      -- Key Lime Pie
(12, 28, 20, 35, 480),     -- Beef Stroganoff
(13, 20, 5, 30, 350),      -- Croissant
(14, 10, 15, 50, 400),     -- Pho
(15, 15, 10, 40, 350),     -- Pancakes
(16, 8, 12, 50, 320),      -- Pasta Primavera
(17, 30, 8, 40, 420),      -- Cheesecake
(18, 5, 6, 35, 250),       -- Ratatouille
(19, 12, 18, 30, 350),     -- Tacos
(20, 5, 3, 60, 300),       -- Pavlova
(21, 15, 20, 45, 400),     -- Sushi Burrito
(22, 10, 5, 50, 350),      -- Risotto
(23, 20, 15, 55, 420),     -- Biryani
(24, 18, 3, 35, 320),      -- Lemon Bars
(25, 5, 2, 15, 120),       -- Gazpacho
(26, 25, 30, 40, 550),     -- Chicken Tikka Masala
(27, 30, 5, 25, 380),      -- Creme Brulee
(28, 15, 25, 35, 380),     -- Chicken Satay
(29, 20, 3, 30, 320),      -- Lemon Meringue Pie
(30, 35, 25, 30, 600),     -- Beef Wellington
(31, 12, 8, 40, 300),      -- Pasta alla Puttanesca
(32, 25, 6, 40, 400),      -- Black Forest Cake
(33, 15, 10, 30, 280),     -- Shakshuka
(34, 20, 15, 40, 420),     -- Moussaka
(35, 25, 5, 50, 400),      -- Lava Cake
(36, 15, 20, 35, 380),     -- Tacos al Pastor
(37, 10, 5, 45, 320),      -- Mushroom Risotto
(38, 10, 5, 30, 250),      -- Crepes
(39, 18, 20, 25, 380),     -- Tandoori Chicken
(40, 8, 5, 40, 280),       -- Pav Bhaji
(41, 30, 20, 30, 480),     -- Coq au Vin
(42, 25, 3, 40, 350),      -- Cinnamon Rolls
(43, 12, 15, 50, 400),     -- Ramen
(44, 15, 3, 35, 300),      -- Apple Crisp
(45, 20, 25, 55, 500),     -- Fettuccine Alfredo
(46, 28, 12, 45, 420),     -- Tiramisu Cheesecake
(47, 18, 15, 40, 380),     -- Shrimp Scampi
(48, 25, 5, 35, 380),      -- Chocolate Mousse
(49, 10, 15, 30, 280),     -- Chicken Noodle Soup
(50, 12, 18, 35, 350);     -- Beef Tacos



UPDATE recipes
SET thematikh_enothta="exotic plates"
WHERE recipe_name in ("Pad Thai", "Sushi Rolls", "Baklava", "Tom Yum Soup", "Pho", "Sushi Burrito", "Biryani", "Gazpacho", "Tacos al Pastor", "Tandoori Chicken", "Pav Bhaji", "Shakshuka", "Moussaka", "Ramen", "Chicken Tikka Masala");
UPDATE recipes
SET thematikh_enothta="mom's recipies"
WHERE recipe_name in ("Chocolate Chip Cookies", "Apple Pie", "Chocolate Cake", "Lemon Meringue Pie", "Beef Stroganoff", "Chicken Noodle Soup", "Pancakes", "Chicken Satay", "Cinnamon Rolls", "Apple Crisp");
UPDATE recipes
SET thematikh_enothta="casual sunday"
WHERE recipe_name in ("Croissant", "Crepes", "Pasta Primavera", "Ratatouille", "Crepes", "Chicken Tikka Masala", "Pasta alla Puttanesca", "Shrimp Scampi", "Mushroom Risotto", "Fettuccine Alfredo");
UPDATE recipes
SET thematikh_enothta="best for the gym"
WHERE recipe_name in ("Chicken Tikka Masala", "Tandoori Chicken", "Chicken Satay", "Beef Tacos");
UPDATE recipes
SET thematikh_enothta="fancy dinner"
WHERE recipe_name in ("Spaghetti Carbonara", "Tiramisu", "Cheesecake", "Beef Wellington", "Tiramisu Cheesecake", "Creme Brulee", "Chocolate Mousse", "Beef Tacos", "Lava Cake", "Pavlova");
