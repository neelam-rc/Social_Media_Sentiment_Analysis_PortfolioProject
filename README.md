# Social Media Sentiment Analysis Portfolio Project

## Project Overview

**Project Title**: Social Media Sentiment Analysis  
**Database**: `[Sentiments_Analysis]`
**Table**: `[dbo].[sa_work]`

This project analyzes public sentiment across multiple platforms using SQL Server and Power BI. It includes hashtag frequency analysis, engagement metrics, and regional sentiment trends. The project involves setting up a Sentiment_Analysis database, performing exploratory data analysis (EDA), and answering specific questions through SQL queries. The dataset is from Kaggle. 

## Tools Used
- SQL Server (data cleaning + insights)
- Power BI (interactive dashboard)
- Excel (preprocessing)

## Project Structure

### 1. Database Setup and Table Creation

- **Database Creation**: Create database named `Sentiments_Analysis`.
- **Table Creation**: The `[dbo].[sentimentdataset]` table structure includes columns like ReviewID, Text, Sentiment, Timestamp, User, Platform, Hashtags, Retweets, Likes, Country, Year, Month, Day, Hour. Later, create a stage table `[dbo].[sa_work]` and use it in this project for further analysis.

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the table.
- **Duplicate Records**: Check for duplicate records if any, in the table and delete it.
- **Trim Text**: Trim extra spaces in text in the table.

```sql
-- Script to check the rownumber [(ROW_NUMBER()) with PARTITION()] to find the duplicate records.

SELECT *
     , ROW_NUMBER() OVER(PARTITION BY text
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

-- Script to see only duplicate rows in the Table using CTE: [there are total 21 rows and 23 duplicate records in total]. 

WITH duplicaterow_CTE AS(
	SELECT *
       , ROW_NUMBER() OVER(PARTITION BY text
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

-- Delete duplicate rows and verify.

WITH duplicaterow_CTE AS(
	SELECT *
       , ROW_NUMBER() OVER(PARTITION BY text
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

-- Trim extra spaces in the text.

SELECT Text, TRIM(Text)
FROM sa_work
GO

UPDATE sa_work
SET Text = TRIM(Text)
GO
```

### 3. Data analysis and findings to answer specific business related questions:

1. **Which posts received the highest number of likes or retweets?**:
```sql
SELECT Text
     , Retweets
     , Likes
FROM sa_work
ORDER BY 1 DESC, 2 DESC
GO
```

2. **Find Top 5 Countries by Post Volume.**:
```sql
SELECT TOP 5 Country
     , COUNT(*) AS total_posts
FROM sa_work
GROUP BY Country
ORDER BY 2 DESC
GO
```

3. **Identify most active platforms that dominates the conversation.**:
```sql
SELECT Platform
     , COUNT(*) AS TotalPosts
FROM sa_work
GROUP BY Platform
ORDER BY TotalPosts DESC;
GO
```

4. **Find if there is a correlation between sentiment and engagement (likes/retweets)?**:
```sql
SELECT Sentiment 
     , AVG(Retweets) avg_retweets
     , AVG(Likes) avg_likes
FROM sa_work
GROUP BY Sentiment
ORDER BY 2 DESC, 3 DESC
GO
```

5. **Find Average Engagement by Sentiment.**:
```sql
SELECT Sentiment
     , AVG(Retweets) AS AvgRetweets
     , AVG(Likes) AS AvgLikes
FROM sa_work
GROUP BY Sentiment
GO
```

6. **Write a query to find peak posting hours.**:
```sql
SELECT Hour
     , COUNT(*) AS TotalPosts
FROM sa_work
GROUP BY Hour
ORDER BY Hour;
GO
```

7. **Identify most common hashtags across all platforms.**:
```sql
SELECT value AS Hashtag
     , COUNT(*) AS Frequency
FROM sa_work
CROSS APPLY STRING_SPLIT(Hashtags, ' ')
GROUP BY value
ORDER BY Frequency DESC;
GO
```

## Findings

- **Most posts leaned neutral, with bursts of positivity during campaigns and spikes of negativity during service issues**
- **Hashtags and emotions told a clear story—people celebrate launches, but they don’t hold back when things go wrong.**

## Reports

- **SQL Server for data storage and querying**
- **Excel for preprocessing dataset**
- **Power BI for interactive dashboarding with filters, KPIs, and sentiment visuals**

## Conclusion

Social media speaks volumes. This project shows how social media sentiment analysis can turn raw chatter into insights that help team make smarter decisions.

## Author - Neelam Chaudhari

This project is part of my SQL portfolio.

### Links

- **LinkedIn**: (https://www.linkedin.com/in/neelamrc)
- **Tableau**: (https://public.tableau.com/app/profile/neelamrc)
- **Github**: (https://github.com/neelam-rc)

Thank you!





