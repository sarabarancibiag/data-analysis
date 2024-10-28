
WHEN WAS THE GOLDEN ERA OF VIDEO GAMES?

-- best_selling_games

SELECT * 
FROM public.game_sales AS best_selling_games
ORDER BY best_selling_games.games_sold DESC
LIMIT 10


-- critics_top_ten_years
SELECT *
FROM (
	SELECT u.year, u.num_games, ROUND(c.avg_critic_score, 2) AS avg_critic_score
	FROM public.users_avg_year_rating AS u
	JOIN public.critics_avg_year_rating AS c ON c.year = u.year
	WHERE u.num_games > 4
	ORDER BY c.avg_critic_score DESC
	LIMIT 10
) AS critics_top_ten_years;


-- golden_years

SELECT *
FROM (
	SELECT 
		a.year,
		a.num_games, 
		b.avg_critic_score, 
		a.avg_user_score, 
		ROUND(b.avg_critic_score - a.avg_user_score, 2) AS diff
	FROM public.users_avg_year_rating AS a
	JOIN public.critics_avg_year_rating AS b ON b.year = a.year
	WHERE b.avg_critic_score > 9 OR a.avg_user_score > 9
	ORDER BY a.year
) AS golden_years;
