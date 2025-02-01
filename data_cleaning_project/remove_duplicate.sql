--Data cleaning
--STEPS
--1. remove duplicates
--2. standardize the data
--3. remove null values
--4. remove any columns that are not needed

SELECT company,
rnum
FROM layoffs_staging
ORDER BY rnum DESC
WHERE company = 'Casper';

--1.Remove duplicates

--insert new column to store row number to ID duplicates
ALTER TABLE layoffs_staging
ADD COLUMN rnum INT;

--update the new column with row number using CTE

WITH cte AS (
    SELECT ctid, 
           ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS row_num
    FROM layoffs_staging
)
UPDATE layoffs_staging
SET rnum = cte.row_num
FROM cte
WHERE layoffs_staging.ctid = cte.ctid;

--delete duplicates
DELETE
FROM layoffs_staging
WHERE rnum > 1;


--confirm duplicates are removed

SELECT *
FROM layoffs_staging
WHERE rnum > 1;




