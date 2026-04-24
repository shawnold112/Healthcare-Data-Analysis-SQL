-- This dataset is based on the free kaggle healthcare dataset provided by their website. It is not real information.

-- Table created for project

CREATE TABLE healthcare_data (
    name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    blood_type VARCHAR(5),
    medical_condition VARCHAR(50),
    date_of_admission DATE,
    doctor VARCHAR(50),
    hospital VARCHAR(100),
    insurance VARCHAR(100),
    billing_amount DECIMAL(10,2),
    room_number INT,
    admission_type VARCHAR(20),
    discharge_date DATE,
    medication VARCHAR(50),
    test_results VARCHAR(100)
);

-- Importing excel file into SQL

load data infile 'healthcare_dataset.csv' into table healthcare_data
fields terminated by ','
ignore 1 lines;



-- Data cleaning, trying to find out if there are any missing or inconsistent values. 

SELECT *
FROM healthcare_data
WHERE name IS NULL
   OR age IS NULL
   OR gender IS NULL
   OR blood_type IS NULL
   OR medical_condition IS NULL
   OR date_of_admission IS NULL
   OR doctor IS NULL
   OR hospital IS NULL
   OR insurance IS NULL
   OR billing_amount IS NULL
   OR room_number IS NULL
   OR admission_type IS NULL
   OR discharge_date IS NULL
   OR medication IS NULL
   OR test_results IS NULL;

-- Most expensive conditions
select medical_condition,
avg(billing_amount) as avg_cost
from healthcare_data
group by medical_condition
order by avg_cost desc;

-- Least expensive conditions
select medical_condition,
avg(billing_amount) as avg_cost
from healthcare_data
group by medical_condition
order by avg_cost asc;



-- Doctor workload

select
	doctor,
count(*) as patients_handled
from healthcare_data
group by doctor
order by patients_handled desc;

-- Admission trends

select
date_of_admission as month,
count(*) as total_admissions
from healthcare_data
group by month
order by month;

-- (Financial insights) 

-- revenue given by insurance

select 
	insurance,
    count(*) as patients,
    sum(billing_amount) as total_revenue,
    avg(billing_amount) as avg_bill
    from healthcare_data
    group by insurance
    order by total_revenue desc;

-- The top 10 high-cost patients

select * 
from healthcare_data
order by billing_amount desc
limit 10;

-- The cost per day(involves some math)

SELECT
    name,
    hospital,
    billing_amount,
    DATEDIFF(discharge_date, date_of_admission) AS stay_length,
    billing_amount / DATEDIFF(discharge_date, date_of_admission) AS cost_per_day
FROM healthcare_data
WHERE discharge_date > date_of_admission
ORDER BY cost_per_day DESC;

-- Doctor Revenue contribution

select
	doctor,
    sum(billing_amount) as total_revenue,
    avg(billing_amount) as avg_bill
from healthcare_data
group by doctor
order by total_revenue desc;

-- The top 10 hospital ranking by revenue

select
	hospital,
    sum(billing_amount) as total_revenue,
    rank() over (order by sum(billing_amount) desc) as revenue_rank
    from healthcare_data
    group by hospital
    limit 10;

-- The Monthly admissions

select
	year(date_of_admission) as year,
    month(date_of_admission) as month,
    count(*) as total_admissions
from healthcare_data
	group by year, month
    order by year, month;

-- Revenue over time

select	
	year(date_of_admission) as year,
    month(date_of_admission) as month,
    sum(billing_amount) as revenue
from healthcare_data
group by year, month
order by year, month;


-- The average cost of billing by gender

select
	gender,
    count(*) as patients,
    avg(billing_amount) as avg_cost
from healthcare_data
group by gender;

-- What is the most common blood type?

select 
	blood_type,
    count(*) as total_count
from healthcare_data
group by blood_type
order by total_count desc
limit 1;

-- What is the least common blood type

select 
	blood_type,
    count(*) as total_count
from healthcare_data
group by blood_type
order by total_count asc
limit 1;


-- What is the most expensive insurance?

select 
	insurance,
	sum(billing_amount) as total_cost
from healthcare_data
group by insurance
order by total_cost desc
limit 1;

-- What is the least expensive insurance?

select 
	insurance,
	sum(billing_amount) as total_cost
from healthcare_data
group by insurance
order by total_cost asc
limit 1;

-- What is the most expensive medication?

select 
	medication,
	sum(billing_amount) as total_cost
from healthcare_data
group by medication
order by total_cost desc
limit 1;

-- What is the least expensive medication?

select 
	medication,
	sum(billing_amount) as total_cost
from healthcare_data
group by medication
order by total_cost asc
limit 1;