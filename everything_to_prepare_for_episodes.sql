TRUNCATE TABLE judges;
TRUNCATE TABLE contestant_pool;
#truncate table episodes;
ALTER TABLE judges AUTO_INCREMENT = 1;
DELIMITER //

CREATE FUNCTION GenerateEpisodeIDs(n INT) returns int 
BEGIN
    DECLARE i INT DEFAULT 1;
    
    WHILE i <= n DO
        INSERT INTO episodes (ep_id) VALUES (i);
        SET i = i + 1;
    END WHILE;
    return 0;
END//

DELIMITER ;

DELIMITER //

CREATE FUNCTION Randomyear(n int)
RETURNS INT
BEGIN
    DECLARE random_year INT;
    SET random_year = 2000; 
    if n<10 then RETURN random_year;
    elseif n<20 then return random_year+1;
    elseif n<30 then return random_year+2;
    elseif n<40 then return random_year+3;
    else return random_year+4;
    end if;
END //

DELIMITER ;
DELIMITER //

CREATE PROCEDURE ChooseRandomJudge(
    IN ep_id_var INT,
	IN prev_judge_id_1 INT,
    IN prev_judge_id_2 INT,
    IN prev_judge_id_3 INT
)
BEGIN
    DECLARE cook_id_var INT;
    DECLARE judge_id_var INT;
    -- Choose a random cook_id from the cooks table
SET cook_id_var = (
    SELECT cook_id 
    FROM cooks 
    WHERE cook_id NOT IN (
        SELECT cook_id 
        FROM contestant_pool 
        WHERE pool_id = (
            SELECT pool_id 
            FROM episodes 
            WHERE ep_id = ep_id_var
        )
		) 
	AND cook_id not in (prev_judge_id_1,prev_judge_id_2,prev_judge_id_3)
    ORDER BY RAND() 
    LIMIT 1
);
	#select cook_id_var;
	

    -- Insert into the judges table and retrieve the judge_id
    INSERT INTO judges (cook_id, ep_id) VALUES (cook_id_var, ep_id_var);
    SET judge_id_var = LAST_INSERT_ID();
    IF prev_judge_id_1=0 THEN
        UPDATE episodes SET judge1_id = judge_id_var WHERE ep_id = ep_id_var;
    ELSEIF prev_judge_id_2=0 THEN
        UPDATE episodes SET judge2_id = judge_id_var WHERE ep_id = ep_id_var;
    ELSE
        UPDATE episodes SET judge3_id = judge_id_var WHERE ep_id = ep_id_var;
    END IF;
END //

DELIMITER ;
DELIMITER //

CREATE PROCEDURE CreateRandomPool()
BEGIN
	DECLARE pool_id_var INT;
    DROP TEMPORARY TABLE IF EXISTS temp;
    -- Generate a unique pool_id
    SET pool_id_var = (SELECT IFNULL(MAX(pool_id), 0) + 1 FROM contestant_pool);
    
    -- Call the ChooseRandomly procedure to populate the cuisine_cook_recipe_id temporary table
    CALL ChooseRandomly();
    
    -- Create a copy of the cuisine_cook_recipe_id table
     CREATE TEMPORARY TABLE temp AS
    SELECT *, pool_id_var AS pool_id FROM cuisine_cook_recipe_id;

    #UPDATE temp SET pool_id = pool_id_var;
    
    -- Insert the data into the random_pool table
    INSERT INTO contestant_pool (pool_id, cuisine_id, cook_id, recipe_id,p1,p2,p3,sum_points)
    SELECT pool_id_var, cuisine_id, cook_id, recipe_id ,p1,p2,p3,sum_points FROM temp;
    
    -- Drop the temporary table
    #DROP TEMPORARY TABLE IF EXISTS temp;
END //

DELIMITER ;
DELIMITER //

CREATE PROCEDURE ChooseRandomly()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE cuisine_id_var INT DEFAULT 0;
    DECLARE cuisine_id_list VARCHAR(255) DEFAULT '';
    DECLARE cook_id_var INT;
    DECLARE recipe_id_var INT;
    DECLARE p1_var INT;
    DECLARE p2_var INT;
    DECLARE p3_var INT;
    DECLARE sum_points_var int;
    DECLARE cur CURSOR FOR 
        SELECT distinct cuisine_id
        FROM national_cuisine
        ORDER BY RAND() -- Shuffle the rows
        LIMIT 10; -- Limit to 10 rows
	DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;
	DROP TEMPORARY TABLE IF EXISTS cuisine_cook_recipe_id;
    -- Create a table to store the randomly chosen cuisine_id values
    CREATE TEMPORARY TABLE cuisine_cook_recipe_id (
        cuisine_id INT,
        cook_id INT,
        recipe_id INT,
        p1 INT ,
        p2 INT,
        p3 INT,
        sum_points int
    );

    -- Declare cursor to fetch 10 distinct random cuisine_id values
      

    -- Declare handler for NOT FOUND condition
    

    -- Open the cursor
    OPEN cur;

    -- Start loop to fetch 10 distinct random cuisine_id values
    read_loop: LOOP
        -- Fetch the next cuisine_id
        FETCH cur INTO cuisine_id_var;
        
        -- Exit loop if there are no more rows or if 10 rows have been fetched
        IF done OR cuisine_id_var IS NULL THEN
            LEAVE read_loop;
        END IF;
        
        -- Randomly select one cook_id for the current cuisine_id
        SELECT cook_id FROM national_cuisine
        WHERE cuisine_id = cuisine_id_var
        ORDER BY RAND() -- Shuffle the rows
        LIMIT 1 -- Limit to 1 row
        INTO cook_id_var;
        
        SELECT recipe_id FROM national_cuisine
        WHERE cuisine_id = cuisine_id_var and cook_id=cook_id_var
        ORDER BY RAND() -- Shuffle the rows
        LIMIT 1 -- Limit to 1 row
        INTO recipe_id_var;
		SET p1_var = FLOOR(RAND() * 5) + 1;
		SET p2_var = FLOOR(RAND() * 5) + 1;
		SET p3_var = FLOOR(RAND() * 5) + 1;
        set sum_points_var=p1_var+p2_var+p3_var;
        -- Insert the randomly chosen cuisine_id and cook_id into the cuisine_cook_ids table
        INSERT INTO cuisine_cook_recipe_id (cuisine_id, cook_id, recipe_id,p1,p2,p3,sum_points) VALUES (cuisine_id_var, cook_id_var,recipe_id_var,p1_var,p2_var,p3_var,sum_points_var);
    END LOOP;


    -- Close the cursor
    CLOSE cur;

    -- Output the list of randomly chosen cuisine_id values
    #SELECT * FROM cuisine_cook_recipe_id;
    #DROP TEMPORARY TABLE IF EXISTS cuisine_cook_recipe_id;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE UpdateNutritionalInfo()
BEGIN
    DECLARE recipe_id_var INT;
    DECLARE total_amount_var DECIMAL(10,2);
    DECLARE done INT DEFAULT FALSE;
    DECLARE portion_var int;

    -- Declare cursor to iterate over distinct recipe_ids
    DECLARE cur CURSOR FOR 
        SELECT DISTINCT recipe_id
        FROM ingredients;

    -- Declare handler for NOT FOUND condition
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    -- Open the cursor
    OPEN cur;

    -- Start loop to iterate over each recipe_id
        read_loop: LOOP
		set total_amount_var =0;
        -- Fetch the next recipe_id
        FETCH cur INTO recipe_id_var;
        
        -- Exit loop if there are no more recipe_ids
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Calculate total amount for the current recipe_id using the total_amount function
        SELECT portions INTO portion_var
        FROM recipes
        WHERE recipe_id = recipe_id_var;
        SET total_amount_var = (total_amount(recipe_id_var))/portion_var;
        -- Update the calorie tuple in the nutr table with the calculated total for the current recipe_id
        UPDATE nutritial_info
        SET total_cal_per_portion = total_amount_var
        WHERE recipe_id = recipe_id_var;
        
    END LOOP;

    -- Close the cursor
    CLOSE cur;
END //

DELIMITER ;


DELIMITER //

CREATE FUNCTION total_amount(input INT) RETURNS DECIMAL(10,2)
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(
        CASE 
            WHEN SUBSTRING_INDEX(quantity, ' ', -1) = 'cups' THEN 
                ((SUBSTRING_INDEX(quantity, ' ', 1) + 0) * 240 / 100) * calories_per_100g
            ELSE 
                (quantity) / 100 * calories_per_100g -- Assume the quantity is in grams if no unit is specified
        END
    ) INTO total
    FROM ingredients
    WHERE recipe_id = input;
    RETURN total;
END//

DELIMITER ;



DELIMITER //

CREATE PROCEDURE CreateEpisode()
BEGIN
	DECLARE done INT DEFAULT FALSE;
    DECLARE ep_id_var INT;
    DECLARE pool_id_var INT;

    -- Declare cursor to fetch each ep_id
    DECLARE cur CURSOR FOR SELECT ep_id FROM episodes;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    select GenerateEpisodeIDs(50);
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO ep_id_var;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Call the CreateRandomPool procedure for each ep_id
        CALL CreateRandomPool();

        -- Retrieve the generated pool_id
        SET pool_id_var = (SELECT MAX(pool_id) FROM contestant_pool);

        -- Update the episoded table with the generated pool_id
        UPDATE episodes SET pool_id = pool_id_var WHERE ep_id = ep_id_var;
		SET @rand_year := Randomyear(ep_id_var);
        UPDATE episodes SET year_of_prod=@rand_year WHERE ep_id=ep_id_var;
		-- First call
        
        ALTER TABLE judges AUTO_INCREMENT = 1;
		CALL ChooseRandomJudge(ep_id_var, 0,0,0);

		-- Retrieve the generated judge_id from the first call
		SELECT judge_id INTO @judge1_id FROM judges ORDER BY judge_id DESC LIMIT 1;

		-- Second call
		CALL ChooseRandomJudge(ep_id_var, @judge1_id,0,0);

		-- Retrieve the generated judge_id from the second call
		SELECT judge_id INTO @judge2_id FROM judges ORDER BY judge_id DESC LIMIT 1;

		-- Third call
		CALL ChooseRandomJudge(ep_id_var, @judge1_id,@judge2_id,0);

		-- Retrieve the generated judge_id from the third call
		SELECT judge_id INTO @judge3_id FROM judges ORDER BY judge_id DESC LIMIT 1;
		UPDATE episodes
		SET winner_id = (
			SELECT cp.cook_id 
			FROM contestant_pool cp
			INNER JOIN cooks c ON cp.cook_id = c.cook_id
			WHERE cp.pool_id = pool_id_var
			ORDER BY cp.sum_points DESC, 
			CASE c.professional_level 
                 WHEN 'Expert' THEN 4
                 WHEN 'Advanced' THEN 3
                 WHEN 'Intermediate' THEN 2
                 WHEN 'Beginner' THEN 1
                 ELSE 0 -- Handle other cases if needed
			END DESC,
			RAND() 
			LIMIT 1
		)where ep_id=ep_id_var;

    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

call topchef.UpdateNutritionalInfo();
call topchef.CreateEpisode();

