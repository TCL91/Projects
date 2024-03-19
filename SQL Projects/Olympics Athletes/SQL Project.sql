--How many olympics games have been held?
SELECT COUNT(DISTINCT games) AS total_olympic_games
FROM olympics_history;

--List down all Olympics games held so far.
SELECT DISTINCT(year), season, city 
FROM olympics_history
ORDER BY year;

--Mention the total no of nations who participated in each olympics game?
SELECT oh.games, COUNT( DISTINCT nr.region )
FROM olympics_history oh
JOIN olympics_history_noc_regions nr 
ON nr.noc = oh.noc
GROUP BY games
ORDER BY games  ASC;

-- WITH all_countries as
--     (SELECT games, nr.region
--     FROM olympics_history oh
--     JOIN olympics_history_noc_regions nr ON nr.noc = oh.noc
--     GROUP BY games, nr.region)
-- SELECT games, COUNT(1) as total_countries
-- FROM all_countries
-- GROUP BY games
-- order by games;

--Which year saw the highest and lowest no of countries participating in olympics?
WITH all_countries AS
        (SELECT games, nr.region
        FROM olympics_history oh
        JOIN olympics_history_noc_regions nr ON nr.noc=oh.noc
        GROUP BY games, nr.region),
    tot_countries AS
        (SELECT games, count(1) AS total_countries
        FROM all_countries
        GROUP BY games)
SELECT DISTINCT
concat(FIRST_VALUE(games) OVER(ORDER BY total_countries)
, ' - '
, FIRST_VALUE(total_countries) OVER(ORDER BY total_countries)) AS Lowest_Countries,
concat(FIRST_VALUE(games) OVER(ORDER BY total_countries DESC)
, ' - '
, FIRST_VALUE(total_countries) OVER(ORDER BY total_countries DESC)) AS Highest_Countries
FROM tot_countries
ORDER BY lowest_countries;


SELECT oh.games, COUNT( DISTINCT nr.region ) as country
FROM olympics_history oh
JOIN olympics_history_noc_regions nr ON nr.noc=oh.noc
GROUP BY games
ORDER BY country  ASC
LIMIT 1

SELECT oh.games, COUNT( DISTINCT nr.region ) as country
FROM olympics_history oh
JOIN olympics_history_noc_regions nr ON nr.noc=oh.noc
GROUP BY games
ORDER BY country  DESC
LIMIT 1

--Which nation has participated in all of the olympic games?
WITH tot_games AS
              (SELECT COUNT(DISTINCT games) AS total_games
					FROM olympics_history),
          countries AS
              (SELECT games, nr.region AS country
              FROM olympics_history oh
              JOIN olympics_history_noc_regions nr ON nr.noc=oh.noc
              GROUP BY games, nr.region),
          countries_participated AS
              (SELECT country, COUNT(1) as total_participated_games
              FROM countries
              GROUP BY country)
      SELECT cp.*
      FROM countries_participated cp
      JOIN tot_games tg ON tg.total_games = cp.total_participated_games
      ORDER BY country;


--Identify the sport which was played in all summer olympics.
WITH t1 AS
	(SELECT COUNT(DISTINCT games) AS total_games
	FROM olympics_history WHERE season = 'Summer'),
	t2 AS
	(SELECT DISTINCT games, sport
	FROM olympics_history WHERE season = 'Summer'),
	t3 AS
	(SELECT sport, COUNT(1) AS no_of_games
	FROM t2
	GROUP BY sport)
SELECT *
FROM t3
JOIN t1 ON t1.total_games = t3.no_of_games;


-- WITH tot_games AS
--               (SELECT COUNT(DISTINCT games) AS total_games
-- 					FROM olympics_history
-- 			  WHERE season = 'Summer'),
-- 		 sports AS 
-- 		 	(SELECT sport, COUNT(1) AS total_sports
-- 			FROM olympics_history
-- 			GROUP BY sport)
-- 	  SELECT s.*
--       FROM sports s
--       JOIN tot_games tg ON tg.total_games = s.total_sports
--       ORDER BY sport;

--Which Sports were just played only once in the olympics?
WITH t1 AS
		(SELECT DISTINCT games,  sport
		FROM olympics_history),
	t2 AS
		(SELECT sport, COUNT(DISTINCT games) AS no_of_games
		FROM olympics_history
		GROUP BY sport
		HAVING COUNT(DISTINCT games) = 1)
SELECT t1.sport, t2.no_of_games, t1.games
FROM t2
INNER JOIN t1 ON t1.sport = t2.sport
ORDER BY t1.sport;

-- WITH t1 AS
--       (SELECT DISTINCT games, sport
--       FROM olympics_history),
--       t2 AS
--       (SELECT sport, COUNT(1) AS no_of_games
--       FROM t1
--       GROUP BY sport)
-- SELECT t2.*, t1.games
-- FROM t2
-- JOIN t1 ON t1.sport = t2.sport
-- WHERE t2.no_of_games = 1
-- ORDER BY t1.sport;


--Fetch the total no of sports played in each olympic games.
SELECT DISTINCT games, COUNT(DISTINCT sport) AS no_of_sports
FROM olympics_history
GROUP BY games
ORDER BY no_of_sports desc;

-- WITH t1 AS
-- 		(SELECT DISTINCT games, sport
-- 		FROM olympics_history),
-- 	 t2 AS
-- 		(SELECT games, COUNT(1) AS no_of_sports
-- 		FROM t1
-- 		GROUP BY games)
-- SELECT * FROM t2
-- ORDER BY no_of_sports DESC;

--Fetch details of the oldest athletes to win a gold medal.
SELECT name, sex, age, team, games, city, sport, event, medal
FROM olympics_history
WHERE medal = 'Gold' AND age != 'NA'
ORDER BY age DESC
LIMIT 2;


WITH t1 AS
        (SELECT name, sex, age, team, games, city, sport, event, medal
		FROM olympics_history
		WHERE medal = 'Gold' AND age != 'NA'),
    ranking AS
        (SELECT *, DENSE_RANK() OVER(ORDER BY age DESC) AS rnk
        FROM t1
        WHERE medal='Gold')
SELECT *
FROM ranking
WHERE rnk = 1;

-- WITH temp AS
--         (SELECT name, sex, CAST(CASE WHEN age = 'NA' THEN '0' ELSE age END AS int) AS age
--           ,team,games,city,sport, event, medal
--         FROM olympics_history),
--     ranking AS
--         (SELECT *, RANK() OVER(ORDER BY age DESC) AS rnk
--         FROM temp
--         WHERE medal='Gold')
-- SELECT *
-- FROM ranking
-- WHERE rnk = 1;


--Find the Ratio of male and female athletes participated in all olympic games.
SELECT COUNT(*)
FROM olympics_history
WHERE sex = 'M';

SELECT COUNT(*)
FROM olympics_history
WHERE sex = 'F'

SELECT 
    (CAST((SELECT COUNT(*) FROM olympics_history WHERE sex='M') AS FLOAT) / 
     CAST((SELECT COUNT(*) FROM olympics_history WHERE sex='F') AS FLOAT)) 
    AS ratioMaleFemale;
-- 	FROM olympics_history;

-- with t1 as
-- 		(select sex, count(1) as cnt
-- 		from olympics_history
-- 		group by sex),
-- 	t2 as
-- 		(select *, row_number() over(order by cnt) as rn
-- 			from t1),
-- 	min_cnt as
-- 		(select cnt from t2	where rn = 1),
-- 	max_cnt as
-- 		(select cnt from t2	where rn = 2)
-- select concat('1 : ', round(max_cnt.cnt::decimal/min_cnt.cnt, 2)) as ratio
-- from min_cnt, max_cnt;


--Fetch the top 5 athletes who have won the most gold medals.
SELECT name, team, COUNT(*) AS total_gold_medals
FROM olympics_history
WHERE medal = 'Gold'
GROUP BY name, team
ORDER BY total_gold_medals DESC
LIMIT 17;


WITH t1 AS
        (SELECT name, team, COUNT(*) AS total_gold_medals
		FROM olympics_history
		WHERE medal = 'Gold'
		GROUP BY name, team),
    ranking AS
        (SELECT *, DENSE_RANK() OVER(ORDER BY total_gold_medals DESC) AS rnk
        FROM t1
        )
SELECT name, team, total_gold_medals
FROM ranking
WHERE rnk <= 5
ORDER BY rnk;

-- with t1 as
--         (select name, team, count(1) as total_gold_medals
--         from olympics_history
--         where medal = 'Gold'
--         group by name, team
--         order by total_gold_medals desc),
--     t2 as
--         (select *, dense_rank() over (order by total_gold_medals desc) as rnk
--         from t1)
-- select name, team, total_gold_medals
-- from t2
-- where rnk <= 5;



--Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).

WITH t1 AS
        (SELECT name, team, COUNT(*) AS total_medals
		FROM olympics_history
		WHERE medal != 'NA'
		GROUP BY name, team),
    ranking AS
        (SELECT *, DENSE_RANK() OVER(ORDER BY total_medals DESC) AS rnk
        FROM t1
        )
SELECT name, team, total_medals
FROM ranking
WHERE rnk <= 5
ORDER BY rnk;

-- with t1 as
--         (select name, team, count(1) as total_medals
--         from olympics_history
--         where medal in ('Gold', 'Silver', 'Bronze')
--         group by name, team
--         order by total_medals desc),
--     t2 as
--         (select *, dense_rank() over (order by total_medals desc) as rnk
--         from t1)
-- select name, team, total_medals
-- from t2
-- where rnk <= 5;



--Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
WITH t1 AS
        (SELECT nr.region, COUNT(medal) AS total_medals
        FROM olympics_history oh
        JOIN olympics_history_noc_regions nr ON nr.noc = oh.noc
        WHERE medal != 'NA'
        GROUP BY nr.region
        ORDER BY total_medals DESC),
    t2 AS
        (SELECT *, DENSE_RANK() OVER(ORDER BY total_medals DESC) AS rnk
        FROM t1)
SELECT *
FROM t2
WHERE rnk <= 5;

--List down total gold, silver and broze medals won by each country.
-- CREATE EXTENSION TABLEFUNC;

-- SELECT nr.region as country, medal, count(medal) AS total_medals
-- FROM olympics_history oh
-- JOIN olympics_history_noc_regions nr 
-- ON nr.noc = oh.noc
-- WHERE medal != 'NA'
-- GROUP BY nr.region, medal
-- ORDER BY nr.region, medal;

SELECT country
	, COALESCE(gold, 0) as gold
	, COALESCE(silver, 0) as silver
	, COALESCE(bronze, 0) as bronze
FROM CROSSTAB('SELECT nr.region as country, medal, count(medal) AS total_medals
				FROM olympics_history oh
				JOIN olympics_history_noc_regions nr 
				ON nr.noc = oh.noc
				WHERE medal != ''NA''
				GROUP BY nr.region, medal
				ORDER BY nr.region, medal',
		'values (''Bronze''), (''Gold''), (''Silver'')')
AS FINAL_RESULT(country varchar, bronze bigint, gold bigint, silver bigint)
ORDER BY gold DESC, silver DESC, bronze DESC;

--List down total gold, silver and broze medals won by each country corresponding to each olympic games.




SELECT substring(games,1,position(' - ' in games) - 1) as games
    , substring(games,position(' - ' in games) + 3) as country
	, COALESCE(gold, 0) as gold
	, COALESCE(silver, 0) as silver
	, COALESCE(bronze, 0) as bronze
FROM CROSSTAB('SELECT concat(games, '' - '', nr.region) as games, medal, count(medal) AS total_medals
				FROM olympics_history oh
				JOIN olympics_history_noc_regions nr 
				ON nr.noc = oh.noc
				WHERE medal != ''NA''
				GROUP BY games, nr.region, medal
				ORDER BY games, medal',
		'values (''Bronze''), (''Gold''), (''Silver'')')
AS FINAL_RESULT(games varchar, bronze bigint, gold bigint, silver bigint);

-- SELECT substring(games,1,position(' - ' in games) - 1) as games
--     , substring(games,position(' - ' in games) + 3) as country
--     , coalesce(gold, 0) as gold
--     , coalesce(silver, 0) as silver
--     , coalesce(bronze, 0) as bronze
-- FROM CROSSTAB('SELECT concat(games, '' - '', nr.region) as games
--             , medal
--             , count(1) as total_medals
--             FROM olympics_history oh
--             JOIN olympics_history_noc_regions nr ON nr.noc = oh.noc
--             where medal <> ''NA''
--             GROUP BY games,nr.region,medal
--             order BY games,medal',
--         'values (''Bronze''), (''Gold''), (''Silver'')')
AS FINAL_RESULT(games text, bronze bigint, gold bigint, silver bigint);


--Identify which country won the most gold, most silver and most bronze medals in each olympic games.
WITH temp as
	(SELECT substring(games, 1, position(' - ' in games) - 1) as games
		, substring(games, position(' - ' in games) + 3) as country
		, coalesce(gold, 0) as gold
		, coalesce(silver, 0) as silver
		, coalesce(bronze, 0) as bronze
	FROM CROSSTAB('SELECT concat(games, '' - '', nr.region) as games
					, medal
					, count(1) as total_medals
					FROM olympics_history oh
					JOIN olympics_history_noc_regions nr ON nr.noc = oh.noc
					where medal <> ''NA''
					GROUP BY games,nr.region,medal
					order BY games,medal',
				'values (''Bronze''), (''Gold''), (''Silver'')')
				AS FINAL_RESULT(games text, bronze bigint, gold bigint, silver bigint))
select distinct games
	, concat(first_value(country) over(partition by games order by gold desc)
			, ' - '
			, first_value(gold) over(partition by games order by gold desc)) as Max_Gold
	, concat(first_value(country) over(partition by games order by silver desc)
			, ' - '
			, first_value(silver) over(partition by games order by silver desc)) as Max_Silver
	, concat(first_value(country) over(partition by games order by bronze desc)
			, ' - '
			, first_value(bronze) over(partition by games order by bronze desc)) as Max_Bronze
from temp
order by games;


--Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.
with temp as
	(SELECT substring(games, 1, position(' - ' in games) - 1) as games
		, substring(games, position(' - ' in games) + 3) as country
		, coalesce(gold, 0) as gold
		, coalesce(silver, 0) as silver
		, coalesce(bronze, 0) as bronze
	FROM CROSSTAB('SELECT concat(games, '' - '', nr.region) as games
					, medal
					, count(1) as total_medals
					FROM olympics_history oh
					JOIN olympics_history_noc_regions nr ON nr.noc = oh.noc
					where medal <> ''NA''
					GROUP BY games,nr.region,medal
					order BY games,medal',
				'values (''Bronze''), (''Gold''), (''Silver'')')
				AS FINAL_RESULT(games text, bronze bigint, gold bigint, silver bigint)),
	tot_medals as
		(SELECT games, nr.region as country, count(1) as total_medals
		FROM olympics_history oh
		JOIN olympics_history_noc_regions nr ON nr.noc = oh.noc
		where medal <> 'NA'
		GROUP BY games,nr.region order BY games, nr.region)
select distinct t.games
	, concat(first_value(t.country) over(partition by t.games order by gold desc)
			, ' - '
			, first_value(t.gold) over(partition by t.games order by gold desc)) as Max_Gold
	, concat(first_value(t.country) over(partition by t.games order by silver desc)
			, ' - '
			, first_value(t.silver) over(partition by t.games order by silver desc)) as Max_Silver
	, concat(first_value(t.country) over(partition by t.games order by bronze desc)
			, ' - '
			, first_value(t.bronze) over(partition by t.games order by bronze desc)) as Max_Bronze
	, concat(first_value(tm.country) over (partition by tm.games order by total_medals desc nulls last)
			, ' - '
			, first_value(tm.total_medals) over(partition by tm.games order by total_medals desc nulls last)) as Max_Medals
from temp t
join tot_medals tm on tm.games = t.games and tm.country = t.country
order by games;

--Which countries have never won gold medal but have won silver/bronze medals?
SELECT * 
FROM (
	SELECT country, COALESCE(gold, 0) AS gold, COALESCE(silver, 0) AS silver, COALESCE(bronze, 0) AS bronze
		FROM CROSSTAB('SELECT nr.region as country
					, medal, count(1) AS total_medals
					FROM OLYMPICS_HISTORY oh
					JOIN OLYMPICS_HISTORY_NOC_REGIONS nr ON nr.noc=oh.noc
					where medal != ''NA''
					GROUP BY nr.region, medal 
					ORDER BY nr.region,medal',
				'values (''Bronze''), (''Gold''), (''Silver'')')
		AS FINAL_RESULT(country varchar,
		bronze bigint, gold bigint, silver bigint)) x
WHERE gold = 0 AND (silver > 0 or bronze > 0)
ORDER BY gold DESC NULLS LAST, silver DESC NULLS LAST, bronze DESC NULLS LAST;


-- SELECT country
-- 	, COALESCE(gold, 0) as gold
-- 	, COALESCE(silver, 0) as silver
-- 	, COALESCE(bronze, 0) as bronze
-- FROM CROSSTAB('SELECT nr.region as country, medal, count(medal) AS total_medals
-- 				FROM olympics_history oh
-- 				JOIN olympics_history_noc_regions nr 
-- 				ON nr.noc = oh.noc
-- 				WHERE medal != ''NA''
-- 				GROUP BY nr.region, medal
-- 				ORDER BY nr.region, medal',
-- 		'values (''Bronze''), (''Gold''), (''Silver'')')
-- AS FINAL_RESULT(country varchar, bronze bigint, gold bigint, silver bigint)
-- WHERE gold = 0 AND (silver > 0 or bronze > 0)
-- ORDER BY gold DESC, silver DESC, bronze DESC;

--In which Sport/event, India has won highest medals.
SELECT sport, COUNT(medal) as total_medals
		FROM olympics_history
		WHERE medal != 'NA' AND team = 'India'
		GROUP BY sport
		ORDER BY total_medals DESC
		LIMIT 1;

-- WITH t1 AS
-- 		(SELECT sport, COUNT(medal) as total_medals
-- 		FROM olympics_history
-- 		WHERE medal != 'NA' AND team = 'India'
-- 		GROUP BY sport
-- 		ORDER BY total_medals DESC),
-- 	t2 AS
-- 		(SELECT *, RANK() OVER(ORDER BY total_medals DESC) AS rnk
-- 		FROM t1)
-- SELECT sport, total_medals
-- FROM t2
-- WHERE rnk = 1;

--Break down all olympic games where india won medal for Hockey and how many medals in each olympic games.
SELECT team, sport, games, COUNT(medal) as total_medals
FROM olympics_history
WHERE team = 'India' AND sport = 'Hockey' AND medal != 'NA'
GROUP BY team, sport, games
ORDER BY total_medals DESC;


