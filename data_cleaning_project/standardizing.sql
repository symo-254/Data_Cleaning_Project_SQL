SELECT *
FROM layoffs_staging


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



