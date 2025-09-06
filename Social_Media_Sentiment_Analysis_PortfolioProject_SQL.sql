
-- Social Media Sentiment Analysis SQL Portfolio Project --

/*

Database Setup and table creation.

1) Database Creation: Create database named `Sentiments_Analysis`.

2) The `[dbo].[sentimentdataset]` table structure includes columns for ReviewID, Text, Sentiment, Timestamp, User, Platform, Hashtags,
Retweets, Likes, Country, Year, Month, Day, Hour.
   
3) Later, create a stage table [dbo].[sa_work] and use it in this project for further analysis.

**Database**: [Sentiments_Analysis]
**Tables Used**: [dbo].[sa_work]

*/

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

-- Database Creation

CREATE DATABASE [Sentiments_Analysis]
GO

-- Script to create new Table (structure minus data) from existing Table.

SELECT *
INTO sa_work
FROM sentimentdataset
WHERE 1=2


-- Insert data from one Table to newly created Table.

INSERT INTO sa_work
SELECT *
FROM sentimentdataset
GO

SELECT * 
FROM sa_work

----------------------------------------------------------------------------
----------------------------------------------------------------------------

-- Data Exploration & Cleaning

-- Script to check the rownumber [(ROW_NUMBER()) with PARTITION()] to find the duplicates.

SELECT *,
	ROW_NUMBER() OVER(PARTITION BY text
								  , Sentiment
								  , Timestamp
								  , User
								  , Platform
								  , Hashtags
								  , Retweets
								  , Likes
								  , Country
								  , Year
								  , Month
								  , Day
								  , Hour
				ORDER BY reviewid asc ) AS RowNumber 
FROM sa_work
GO

-- Script to see only Duplicate Rows in the Table using CTE: [there are total 21 rows and 23 duplicate records in total] 

WITH duplicaterow_CTE AS(

	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY text
									  , Sentiment
									  , Timestamp
									  , User
									  , Platform
									  , Hashtags
									  , Retweets
									  , Likes
									  , Country
									  , Year
									  , Month
									  , Day
									  , Hour
					ORDER BY text asc ) AS RowNumber 
	FROM sa_work
)
SELECT * 
FROM duplicaterow_CTE
WHERE RowNumber >= 2
GO


-- Delete duplicate rows and verify for duplicate rows again:

WITH duplicaterow_CTE AS(
	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY text
									  , Sentiment
									  , Timestamp
									  , User
									  , Platform
									  , Hashtags
									  , Retweets
									  , Likes
									  , Country
									  , Year
									  , Month
									  , Day
									  , Hour
					ORDER BY text asc ) AS RowNumber 
	FROM sa_work
)
DELETE  
FROM duplicaterow_CTE
WHERE RowNumber > 1
GO

-- Trim the columns

SELECT Text, TRIM(Text)
FROM sa_work
GO

UPDATE sa_work
SET Text = TRIM(Text)
GO

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--  Data analysis and findings to answer specific business related questions:

--Q1) Which posts received the highest number of likes or retweets?

SELECT Text
     , Retweets
	 , Likes
FROM sa_work
ORDER BY 1 DESC, 2 DESC
GO

--Q2) Find Top 5 Countries by Post Volume.

SELECT TOP 5 Country
     , COUNT(*) AS total_posts
FROM sa_work
GROUP BY Country
ORDER BY 2 DESC
GO

--Q3) Identify most active platforms that dominates the conversation.

SELECT Platform
     , COUNT(*) AS TotalPosts
FROM sa_work
GROUP BY Platform
ORDER BY TotalPosts DESC;
GO

--Q4) Find if there is a correlation between sentiment and engagement (likes/retweets)? Yes.

SELECT Sentiment 
     , AVG(Retweets) avg_retweets
     , AVG(Likes) avg_likes
FROM sa_work
GROUP BY Sentiment
ORDER BY 2 DESC, 3 DESC
GO

--Q5) Find Average Engagement by Sentiment.

SELECT Sentiment
     , AVG(Retweets) AS AvgRetweets
	 , AVG(Likes) AS AvgLikes
FROM sa_work
GROUP BY Sentiment
GO

--Q6)  Write a query to find peak posting hours.

SELECT Hour
     , COUNT(*) AS TotalPosts
FROM sa_work
GROUP BY Hour
ORDER BY Hour;
GO

--Q7) Identify most common hashtags across all platforms.

SELECT value AS Hashtag
     , COUNT(*) AS Frequency
FROM sa_work
CROSS APPLY STRING_SPLIT(Hashtags, ' ')
GROUP BY value
ORDER BY Frequency DESC;
GO



-- Github Link: https://github.com/neelam-rc

-- Thank You!
-- The End--
