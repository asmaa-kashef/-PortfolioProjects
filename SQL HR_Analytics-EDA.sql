
use [HR Analytical]
select * from [HR Analytical].[dbo].[jobms_consolidated_search_ds$]

--Total Number Of Jobs
select count(*) from [HR Analytical].[dbo].[jobms_consolidated_search_ds$]
--Total Number Of Company
select count(distinct ([Company]) )from [HR Analytical].[dbo].[jobms_consolidated_search_ds$]
--Total career level
select count( distinct([Career Level]) )from [HR Analytical].[dbo].[jobms_consolidated_search_ds$]
--Total analytical jobs
select count( distinct([Job Type]) )from [HR Analytical].[dbo].[jobms_consolidated_search_ds$]
--	Top 5 Comapny And total Jobs
select [Company], count(*)from [HR Analytical].[dbo].[jobms_consolidated_search_ds$]
group by Company order by count(*)desc
-- count career level depend on job type
select ([Career Level]) , count([Job Type]) as [Number of Job Type] from  [HR Analytical].[dbo].[consolidated_search_uiux$]
group by ([Career Level]) 

select[Job Title] ,count(*) as[number of jobs]  from [HR Analytical].[dbo].[jobms_consolidated_search_ds$]
group by ([Job Title] ) order by [number of jobs] desc


--number of search term for every job
select[Search Term] ,count(*) as[number of jobs]  from [HR Analytical].[dbo].[consolidated_search_uiux$]
group by ([Search Term] ) order by [number of jobs] desc

--it solutions linited is the hidhest in data science
select  [Company],count(*)as[number of jobs] 
from [HR Analytical].[dbo].[jobms_consolidated_search_ds$]
where [Search Term] ='Data Scientist'
group by [Company] 
order by [number of jobs] desc
--hongkong is thehifhrst in data analysis
select  [Company],count(*)as[number of jobs] 
from [HR Analytical].[dbo].[jobms_consolidated_search_ds$]
where [Search Term] ='Data Analyst'
group by [Company] 
order by [number of jobs] desc
---- moust industry 
select [Industry] ,count(*)as[number of jobs] 
from [HR Analytical].[dbo].[jobms_consolidated_search_ds$]
where [Search Term] ='Data Scientist'
group by [Industry] 
order by [number of jobs] desc

select [Industry] ,count(*)as[number of jobs] 
from [HR Analytical].[dbo].[jobms_consolidated_search_ds$]
where [Search Term] ='Data Analyst'
group by [Industry] 
order by [number of jobs] desc
--number of career level for search term 
select [Career Level] ,count(*)as[number of jobs] 
from [HR Analytical].[dbo].[jobms_consolidated_search_ds$]
where [Search Term] ='Data Analyst'
group by [Career Level] 
order by [number of jobs] desc

--number of career level for search term 
select [Career Level] ,count(*)as[number of jobs] 
from [HR Analytical].[dbo].[jobms_consolidated_search_ds$]
where [Search Term] ='Data Scientist'
group by [Career Level] 
order by [number of jobs] desc

select [Career Level] ,count(*)as[number of jobs] 
from [HR Analytical].[dbo].[jobms_consolidated_search_ds$]
where [Search Term] ='Data Engineer'
group by [Career Level] 
order by [number of jobs] desc

select [Career Level] ,count(*)as[number of jobs] 
from [HR Analytical].[dbo].[jobms_consolidated_search_ds$]
where [Search Term] ='Business Intelligence'
group by [Career Level] 
order by [number of jobs] desc

select [Career Level] ,count(*)as[number of jobs] 
from [HR Analytical].[dbo].[jobms_consolidated_search_ds$]
where [Search Term] ='Machine Learning Engineer'
group by [Career Level] 
order by [number of jobs] desc

