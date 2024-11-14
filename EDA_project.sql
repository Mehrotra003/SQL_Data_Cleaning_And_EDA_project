-- SQL Project - EDA

-- https://www.kaggle.com/datasets/swaptr/layoffs-2022

##-- Here we are jsut going to explore the data and find trends or patterns 

use  worlds_layoffs;

select * 
from layoffs_staging3;

# let's know which companies have max total_laid_off and percentage_laid_off 
select max(total_laid_off),max(percentage_laid_off)
from layoffs_staging3;

# finding which companies have 100% percentage_laid_off 

select * 
from layoffs_staging3
where percentage_laid_off=1
order by total_laid_off desc;

# finding which companies have 100 % laid_off and also raised highest funds 

select * 
from layoffs_staging3
where percentage_laid_off=1
order by funds_raised_millions desc;

-- let's know which companies have highest total(laid_off) 
-- this it total in the past 3 years or in the dataset

select company, sum(total_laid_off) 
from layoffs_staging3
group by company
order by 2 desc;

select min(date),max(date)
from layoffs_staging3;

## let's know which industry have highest laid_off

select industry, sum(total_laid_off) 
from layoffs_staging3
group by industry
order by 2 desc;

## let's find which countries have highest laid_off

select country, sum(total_laid_off) 
from layoffs_staging3
group by country
order by 2 desc;

-- let's find which year have highest laid_off

select year(date), sum(total_laid_off) 
from layoffs_staging3
group by year(date)
order by 1 desc;

-- finding which stage of companies have highest laid_off

select stage, sum(total_laid_off) 
from layoffs_staging3
group by stage
order by 2 desc;

-- finding average percentage_laid_off

select company, avg(percentage_laid_off) 
from layoffs_staging3
group by company
order by 2 desc;

# finding which month of given period have maximum total_laid_off

select substring(`date`,1,7) as `month`, sum(total_laid_off)
from layoffs_staging3
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc ;


## let's find Rolling_total of total_laid_off month vise

with Rolling_total as(
select substring(`date`,1,7) as `month`, sum(total_laid_off) as total_off
from layoffs_staging3
where substring(`date`,1,7) is not null
group by `month`
order by 1 Asc )
 select month ,total_off, sum(total_off) over(order by `month`) AS Rolling_laid_off 
 from Rolling_total ;












