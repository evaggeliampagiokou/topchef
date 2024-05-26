#erwthma 3.1
SELECT 'Cook Average' AS category, AVG(total_points_cooks) AS average_total_points
FROM (
    SELECT SUM(p1 + p2 + p3) AS total_points_cooks
    FROM contestant_pool
    GROUP BY cook_id
) AS total_points_cooks

UNION ALL

SELECT 'Cuisine Average' AS category, AVG(total_points_cuisine) AS average_total_points
FROM (
    SELECT SUM(p1 + p2 + p3) AS total_points_cuisine
    FROM contestant_pool
    GROUP BY cuisine_id
) AS total_points_cuisine;

#erwthma 3.2  YOU HAVE TO RUN THE PROCEDURE, BECAUSE ITS FOR GIVEN CUISINE AND YEAR 
DELIMITER //
CREATE PROCEDURE er3_2(national_cuisine VARCHAR(45),year_of_production int )
BEGIN
      select cook_name, cook_surname, cook_id 
    from cooks
    where cook_id in(select cook_id 
					from contestant_pool
                    where pool_id in (select pool_id from episodes
													where year_of_prod=year_of_production)
					and cuisine_id=(select distinct cuisine_id 
								    from national_cuisine
							         where cuisine_name=national_cuisine) );
END //
DELIMITER ;

#erwthma 3.3 this might not give result given we dont know the ages, if we change the limit of age and then use only the subqueery we can see that the given results are correct.
SELECT c.cook_name, c.cook_surname, nc.cook_id, nc.recipe_count
FROM cooks c
JOIN (
    SELECT cook_id, COUNT(*) AS recipe_count
    FROM national_cuisine
    GROUP BY cook_id
    ORDER BY recipe_count DESC
    LIMIT 1
) AS nc ON c.cook_id = nc.cook_id
WHERE c.age < 30;

#erwthma 3.4
select cook_name,cook_surname,cook_id
from cooks
where cook_id not in (select cook_id from judges); 

#erwthma 3.5
WITH CookOccurrences AS (
    SELECT c.cook_name, c.cook_surname, COUNT(cp.cook_id) as occurrence_count, e.year_of_prod
    FROM cooks c
    JOIN contestant_pool cp ON c.cook_id = cp.cook_id
    JOIN episodes e ON cp.pool_id = e.pool_id
    GROUP BY c.cook_name, c.cook_surname, e.year_of_prod
    HAVING COUNT(cp.cook_id) > 3
),
OccurrenceGroups AS (
    SELECT occurrence_count, year_of_prod, COUNT(*) as cook_count
    FROM CookOccurrences
    GROUP BY occurrence_count, year_of_prod
    HAVING COUNT(*) > 1
)
SELECT co.cook_name, co.cook_surname, co.occurrence_count, co.year_of_prod
FROM CookOccurrences co
JOIN OccurrenceGroups og ON co.occurrence_count = og.occurrence_count AND co.year_of_prod = og.year_of_prod
ORDER BY co.year_of_prod, co.occurrence_count DESC, co.cook_name, co.cook_surname;

#erwthma3.7 it may  print nothing given we dont know the occurrences each time, though if we change the limit of uccurrances and run only the subqueere we can check our resu
select cook_name,cook_surname,cook_id
from cooks
where cook_id in(
			SELECT cook_id
			FROM (
					SELECT cook_id, COUNT(*) AS occurrences
					FROM contestant_pool
					GROUP BY cook_id
				) AS cp_counts
			WHERE occurrences > (
								SELECT MAX(occurrences) - 5
								FROM (
									SELECT COUNT(*) AS occurrences
									FROM contestant_pool
									GROUP BY cook_id
								) AS subquery
								)
			and occurrences !=(SELECT MAX(occurrences)
								FROM (
									SELECT COUNT(*) AS occurrences
									FROM contestant_pool
									GROUP BY cook_id
								) AS subquery)
);

#erwthma 3.8
SELECT e.ep_id,e.year_of_prod, COUNT(eq.equipment_name) as equipment_usage_count
FROM episodes e
JOIN contestant_pool cp ON e.pool_id = cp.pool_id
JOIN equipment eq ON cp.recipe_id = eq.recipe_id
GROUP BY e.ep_id
#ORDER BY e.ep_id
ORDER BY equipment_usage_count DESC
LIMIT 1;

#erwthma 3.9
   SELECT
   ep.year_of_prod,
    SUM(ni.carbohydrates_per_portion * r.portions) / COUNT(DISTINCT ep.ep_id) AS avg_carbohydrates_per_episode
FROM
    episodes ep
JOIN
    contestant_pool cp ON ep.pool_id = cp.pool_id
JOIN
    recipes r ON cp.recipe_id = r.recipe_id
JOIN
    nutritial_info ni ON r.recipe_id = ni.recipe_id
GROUP BY
    ep.year_of_prod
ORDER BY
    ep.year_of_prod;


#erwthma 3.10 
SELECT cuisine_name
FROM national_cuisine
WHERE cuisine_id IN (
    SELECT cuisine_id
    FROM (
        SELECT cp.cuisine_id, ep.year_of_prod,
               COUNT(*) AS num_occurrences
        FROM contestant_pool cp
        JOIN episodes ep ON cp.pool_id = ep.pool_id
        JOIN national_cuisine np ON cp.cuisine_id = np.cuisine_id
        GROUP BY cp.cuisine_id, ep.year_of_prod
        #HAVING num_occurrences > 3
    ) AS subquery
    GROUP BY cuisine_id
    HAVING COUNT(*) = 2
       AND COUNT(DISTINCT num_occurrences) = 1
);

#erwthma 3.12
SELECT e.year_of_prod, e.ep_id, e.total_difficulty AS max_difficulty
FROM ( #joins them and finds the difficulty and groups by year and ep_id
    SELECT e.year_of_prod, e.ep_id, SUM(r.difficulty) AS total_difficulty
    FROM episodes e
    JOIN contestant_pool cp ON e.pool_id = cp.pool_id
    JOIN recipes r ON cp.recipe_id = r.recipe_id
    GROUP BY e.year_of_prod, e.ep_id
) AS e
JOIN (
    SELECT year_of_prod, MAX(total_difficulty) AS max_total_difficulty
    FROM (
        SELECT e.year_of_prod, e.ep_id, SUM(r.difficulty) AS total_difficulty
        FROM episodes e
        JOIN contestant_pool cp ON e.pool_id = cp.pool_id
        JOIN recipes r ON cp.recipe_id = r.recipe_id
        GROUP BY e.year_of_prod, e.ep_id
    ) AS subquery
    GROUP BY year_of_prod
) AS max_difficulty_per_year
ON e.year_of_prod = max_difficulty_per_year.year_of_prod
AND e.total_difficulty = max_difficulty_per_year.max_total_difficulty;

#erwthma 3.13
SELECT e.ep_id
FROM episodes e
JOIN contestant_pool cp ON e.pool_id = cp.pool_id
JOIN cooks c ON cp.cook_id = c.cook_id
JOIN cooks c1 ON e.judge1_id = c1.cook_id
JOIN cooks c2 ON e.judge2_id = c2.cook_id
JOIN cooks c3 ON e.judge3_id = c3.cook_id
GROUP BY e.ep_id
ORDER BY SUM(CASE 
                  WHEN c.professional_level = 'Beginner' THEN 1
                  WHEN c.professional_level = 'Intermediate' THEN 2
                  WHEN c.professional_level = 'Advanced' THEN 3
                  WHEN c.professional_level = 'Expert' THEN 4
                  ELSE 0 END +
            CASE 
                  WHEN c1.professional_level = 'Beginner' THEN 1
                  WHEN c1.professional_level = 'Intermediate' THEN 2
                  WHEN c1.professional_level = 'Advanced' THEN 3
                  WHEN c1.professional_level = 'Expert' THEN 4
                  ELSE 0 END +
            CASE 
                  WHEN c2.professional_level = 'Beginner' THEN 1
                  WHEN c2.professional_level = 'Intermediate' THEN 2
                  WHEN c2.professional_level = 'Advanced' THEN 3
                  WHEN c2.professional_level = 'Expert' THEN 4
                  ELSE 0 END +
            CASE 
                  WHEN c3.professional_level = 'Beginner' THEN 1
                  WHEN c3.professional_level = 'Intermediate' THEN 2
                  WHEN c3.professional_level = 'Advanced' THEN 3
                  WHEN c3.professional_level = 'Expert' THEN 4
                  ELSE 0 END) ASC
LIMIT 1;

#erwthma 3.14
select thematikh_enothta ,COUNT(*) AS appearance_count
from recipes
where recipe_id in(select recipe_id 
from contestant_pool)
GROUP BY thematikh_enothta
ORDER BY appearance_count DESC
limit 1;
