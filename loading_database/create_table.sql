-- Creates the staging table with the date as VARCHAR
CREATE TABLE layoffs_staging (
    company VARCHAR(255),
    location VARCHAR(255),
    industry VARCHAR(255),
    total_laid_off INT,
    percentage_laid_off DECIMAL(5,2),
    date VARCHAR(10),
    stage VARCHAR(255),
    country VARCHAR(255),
    funds_raised_millions DECIMAL(15,2)
);

-- Load data to the staging table using PostgreSQL COPY command
COPY layoffs_staging (company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions)
FROM 'C:/Users/mwaur/OneDrive/Desktop/Excell_Project_For_Data_Analysis/Data_Cleaning_Project/layoffs.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

--If the above command does not work, use the following command to load the data using PSQl command line
\copy layoffs_staging FROM 'C:\Users\mwaur\OneDrive\Desktop\Excell_Project_For_Data_Analysis\Data_Cleaning_Project\layoffs.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8', NULL 'NULL');

-- Create the final table with the appropriate columns
DROP TABLE IF EXISTS layoffs;
CREATE TABLE layoffs (
    company VARCHAR(255),
    location VARCHAR(255),
    industry VARCHAR(255),
    total_laid_off INT,
    percentage_laid_off DECIMAL(5,2),
    date DATE,
    stage VARCHAR(255),
    country VARCHAR(255),
    funds_raised_millions DECIMAL(15,2)
);

-- Insert data from the staging table to the final table with date conversion
INSERT INTO layoffs (company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions)
SELECT company, location, industry, total_laid_off, percentage_laid_off, TO_DATE(date, 'MM/DD/YYYY'), stage, country, funds_raised_millions
FROM layoffs_staging;

-- Set ownership of the table to the postgres user
ALTER TABLE public.layoffs OWNER to postgres;

-- Drop the staging table
DROP TABLE layoffs_staging;
