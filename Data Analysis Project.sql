-- Exploratory Data Analyizing

select *
from layoffs_staging2;

select max(total_laid_off), max(percentage_laid_off), min(total_laid_off), min(percentage_laid_off)
from layoffs_staging2;

select *
from layoffs_staging2
where percentage_laid_off = 1 
order by funds_raised_millions desc;

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

select country , industry, sum(total_laid_off)
from layoffs_staging2
group by country ,industry
order by 2 desc;

select substring(`date`,1,7) as `month` , sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month` 
order by 1 asc;

with Recurring_total as 
(select substring(`date`,1,7) as `month` , sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month` 
order by 1 asc)


select `month`, sum(total_off) over(order by `month`) as recurring_total
from Recurring_total;

select company, year (`date`), sum(total_laid_off)
from layoffs_staging2
group by company , year(`date`)
order by 3 desc ;


with Company_year as 
(select company, year (`date`), sum(total_laid_off)
from layoffs_staging2
group by company , year(`date`)
)
select *
from Company_year;

