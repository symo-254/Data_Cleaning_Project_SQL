# Data_Cleaning_Project_SQL

## Overview
This project focuses on cleaning and standardizing a dataset of company layoffs. The dataset is stored in a CSV file and loaded into a PostgreSQL database for processing. The project involves several steps to ensure the data is clean, consistent, and ready for analysis.  
[Final Project](https://github.com/symo-254/Data_Cleaning_Project_SQL)

## Steps for Data Cleaning
  1.Remove Duplicates: Identify and remove duplicate rows from the staging table.  
  2.Standardize Data: Standardize the data by trimming whitespace, removing unnecessary characters, and populating missing values.  
  3.Remove Null Values: Delete rows with null values in critical columns.  
  4.Remove Unnecessary Columns: Drop columns that are not needed for analysis.  

### Step 1: Identify and Delete Duplicates
In this section I identified duplicate records by adding a row number column where I assigned a unique row number for all first instances and a different row number for second instances using the `ROW_NUMBER()`function. I then used a CTE to Update the added row mumber with row numbers. I then deleted all the second Instances of the same row from the layoffs_staging table.  

```sql
WITH cte AS (
    SELECT ctid, 
           ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS row_num
    FROM layoffs_staging
)
UPDATE layoffs_staging
SET rnum = cte.row_num
FROM cte
WHERE layoffs_staging.ctid = cte.ctid;

DELETE
FROM layoffs_staging
WHERE rnum > 1;
```
### Step 2: Standardizing the data in layoffs staging table  
Standadizind data is a very crucial step in data cleaning. The sql script below shows all the steps carried out to ensure the data was well standardized.  
```sql
--1.Remove whitespace from company

UPDATE layoffs_staging
SET company = TRIM(company)

--2.Remove a period from country "United States."

UPDATE layoffs_staging
SET country = TRIM(TRAILING '.' FROM country)
WHERE country = 'United States.'


--set industry to NULL where industry is an empty string

UPDATE layoffs_staging
SET industry = NULL
WHERE industry = 'NULL'


--3.Populate industry column with industry from the same company and location
    --use a cte to identify the industries from the same company and location where one industry is not null and the other is null

WITH cte AS (
    SELECT t1.company, t1.location, t2.industry AS industry2
    FROM layoffs_staging t1
    JOIN layoffs_staging t2 ON t1.company = t2.company
    AND t1.location = t2.location
    WHERE t1.industry IS NULL
    AND t2.industry IS NOT NULL 
)
SELECT *
FROM cte

    --use a CTE to get the industry from the same company and location
    --update the industry column with the industry from the same company and location

WITH cte AS (
    SELECT t1.company, t1.location, t2.industry AS industry2
    FROM layoffs_staging t1
    JOIN layoffs_staging t2 ON t1.company = t2.company
    AND t1.location = t2.location
    WHERE t1.industry IS NULL
    AND t2.industry IS NOT NULL 
)
UPDATE layoffs_staging
SET industry = cte.industry2
FROM cte
WHERE layoffs_staging.company = cte.company
AND layoffs_staging.location = cte.location
AND layoffs_staging.industry IS NULL;
```

### Step 3 & 4: Deleting rows with null values and Unnecessary columns  
In this section I deleted all the rows which had null values in total_laid_off and percentage_laid_off columns. I then deleted the row column which I added earlier since it was'nt relevant to our data analysis.  
I used the script below to delete the rows and colummns  
```sql
--1.Delete all rows which have null values in total_laid_off and percentage_laid_off columns

 DELETE
 FROM layoffs_staging
 WHERE total_laid_off IS NULL
 AND percentage_laid_off IS NULL;

 --2.Remove any columns that are not needed

 ALTER TABLE layoffs_staging
 DROP COLUMN rnum;
```

## Notes  
- If using a database system that does not support `ROW_NUMBER()`, consider using an alternative method like `DISTINCT ON` for PostgreSQL.
- Consider adding indexes to frequently checked columns to improve performance.

## Compatibility
This script is compatible with most SQL-based relational databases, including:
- MySQL
- PostgreSQL
- SQL Server
- Oracle (with slight modifications)

## License
This script is open-source and free to use under the MIT License.

---

