-- SQL Project - Data Cleaning

-- https://www.kaggle.com/datasets/swaptr/layoffs-2022

-- 1. Remove Dublicates
-- 2. standardize the data
-- 3. Null values and Blank values
-- 4. Remove any rows and columns

use worlds_layoffs;
select * from layoffs;

###-- first thing we want to do is create a staging table. This is the one we will work in and clean the data

create table layoffs_staging
like layoffs;

insert into layoffs_staging
select * from layoffs;

-- 1. Remove Duplicates

# First let's check for duplicates

-- it looks like these are all legitimate entries and shouldn't be deleted. We need to really look at every single row to be accurate

-- these are our real duplicates 

select *, 
row_number() over(partition by company,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num
from layoffs_staging;

with dublicate_cte as(
select *, 
row_number() over(partition by company,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num
from layoffs_staging
)
select * from
dublicate_cte 
where row_num > 1;

-- one solution, which I think is a good one. Is to create a new column and add those row numbers in. Then delete where row numbers are over 2, then delete that column
-- so let's do it!!


CREATE TABLE `layoffs_staging3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci; 



select *
from layoffs_staging3;

insert into layoffs_staging3
select *, 
row_number() over(partition by company,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num
from layoffs_staging ;

set sql_safe_updates = 0;

delete from
layoffs_staging3
where row_num > 1;

select * from layoffs_staging3;

##-- standardization of data
##-- using trim to delete extra space in the company name in the table

select company,trim(company) 
from
layoffs_staging3;

update layoffs_staging3
set company = trim(company);

select distinct industry 
from layoffs_staging3
order by 1;

select * from layoffs_staging3
where industry like 'crypto%' ; 

-- updating the industry name with correct name which match the table

update layoffs_staging3
set industry = 'crypto'
where industry like 'crypto%' ; 

select * from layoffs_staging3
where industry like 'crypto%';

select distinct industry 
from layoffs_staging3
order by 1;
 
 select distinct country 
 from layoffs_staging3
 order by 1;
 
 -- standarization of country column in layoffs_staging2
 
select distinct country, trim(trailing '.' from country)
from layoffs_staging3
order by 1;

update layoffs_staging3
set country = trim(trailing '.' from country)
where country like 'united states%';

select distinct country
from layoffs_staging3
order by 1;

-- Correcting the date column data type text to date

set sql_safe_updates = 0;

select `date` from layoffs_staging3;

update layoffs_staging3
set `date`=str_to_date(`date`,'%m/%d/%Y');

alter table layoffs_staging3
modify column  `date` date ;

-- Removing the null and blanks from our table layoffs_staging3

select * from layoffs_staging3
where total_laid_off is null and 
percentage_laid_off is null ;

-- # first we remove the blanks with null

update layoffs_staging3
set industry = null
where industry = '' ;

select * 
from layoffs_staging3 
where industry is null 
or industry= '' ;



select t1.industry,t2.industry
from layoffs_staging3 t1 
join layoffs_staging3 t2
  on t1.company=t2.company
where (t1.industry is null or t1.industry = '' )
and t2.industry is not null ;

# replacing the nulls 

update layoffs_staging3 t1
join layoffs_staging3 t2
  on t1.company=t2.company
set t1.industry = t2.industry
where t1.industry is null 
and t2.industry is not null ;
  
select * 
from layoffs_staging3
where company like 'bally%' ; 

select * from layoffs_staging3
where total_laid_off is null and 
percentage_laid_off is null ;

# deleting the the rows from layoffs_staging3 where both total_laid_off and percentage_laid_off is null 


Delete 
from layoffs_staging3
where total_laid_off is null and 
percentage_laid_off is null ;

-- Droping and Removing the column from the table layoffs_staging3 which not needed in 'EDA process'

select *
from layoffs_staging3 ;

Alter table layoffs_staging3
drop column row_num ;



 



































