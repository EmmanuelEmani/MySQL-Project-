-- Data Cleaning Process

-- 1. Preview the raw data before cleaning
Select *
from layoffs;

-- Data Cleaning Steps:
-- Step 1: Remove duplicates
-- Step 2: Standardize the data (e.g., trimming spaces)
-- Step 3: Handle null values or blanks
-- Step 4: Remove unnecessary columns

-- Create a new table (layoffs_staging) similar to the original table to store cleaned data
Create Table layoffs_staging
like layoffs;

-- Insert all data from the original table into the staging table
insert layoffs_staging
select *
from layoffs;

-- Step 1: Identify duplicates using ROW_NUMBER() based on critical columns
select *,
ROW_NUMBER() over (
    partition by company, industry, total_laid_off, percentage_laid_off, `date`
) as row_num
from layoffs_staging;

-- Create a common table expression (CTE) to find duplicate rows
with duplicate_cte as
(
    select *,
    row_number() over (
        partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
    ) as row_num
    from layoffs_staging
)
select * from duplicate_cte
where row_num > 1;  -- Keep only duplicates (row_num > 1)

-- Step 2: Deleting duplicate rows in the staging table
delete from duplicate_cte
where row_num > 1;

-- Step 3: Create a cleaned version of the table (layoffs_staging2) to hold fully cleaned data
CREATE TABLE `layoffs_staging2` (
    `company` text,
    `location` text,
    `industry` text,
    `total_laid_off` int DEFAULT NULL,
    `percentage_laid_off` text,
    `date` text,
    `stage` text,
    `country` text,
    `funds_raised_millions` int DEFAULT NULL,
    `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Step 4: Insert cleaned data into the new staging table with row numbers for duplicates
insert into layoffs_staging2
select *,
row_number() over (
    partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
) as row_num
from layoffs_staging;

-- Step 5: Delete remaining duplicates in the cleaned staging table
delete from layoffs_staging2
where row_num > 1;

-- Step 6: Review the cleaned data
select * from layoffs_staging2;

-- Step 7: Data Standardization
-- Trim whitespace from company names
select company, trim(company)
from layoffs_staging2;

-- Update the staging table to remove extra spaces in company names
update layoffs_staging2
set company = trim(company);

-- Standardize the industry names (e.g., group similar names)
select distinct industry
from layoffs_staging2;

-- Standardize entries like 'Crypto%' to 'Crypto'
update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

-- Standardize country names (e.g., remove trailing periods)
select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;

-- Update country names to remove trailing periods
update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United states';

-- Step 8: Handle date format issues
-- Check current date format
select `date`
from layoffs_staging2;

-- Convert dates to a standardized format (MM/DD/YYYY)
update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

-- Modify the date column to ensure it's stored in the correct format
alter table layoffs_staging2
modify column `date` date;

-- Step 9: Handle null or missing data
-- Review rows with missing total_laid_off or percentage_laid_off values
select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null
order by 1;

-- Set industry to NULL where the field is blank
update layoffs_staging2
set industry = null
where industry = '';

-- Identify rows where the industry is missing or empty
select *
from layoffs_staging2
where industry is null
or industry = '';

-- Cross-validate missing industry information with other companies in the dataset
select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

-- Update missing industry information based on other records of the same company
update layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

-- Step 10: Final review of cleaned data
select * from layoffs_staging2;

-- Remove rows where critical data is still missing
delete from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

-- Final review of the staging table
select * from layoffs_staging2;

-- Step 11: Remove temporary columns (e.g., row_num) used during the cleaning process
Alter Table layoffs_staging2
drop column row_num;
