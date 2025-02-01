--1.Delete all rows which have null values in total_laid_off and percentage_laid_off columns

 DELETE
 FROM layoffs_staging
 WHERE total_laid_off IS NULL
 AND percentage_laid_off IS NULL;

 --2.Remove any columns that are not needed

 ALTER TABLE layoffs_staging
 DROP COLUMN rnum;
