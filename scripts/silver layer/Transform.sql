insert into silver.crm_cust_info (
cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, 
cst_gndr, cst_create_date)

select cst_id, cst_key, 
trim(cst_firstname) as cst_firstname,
trim(cst_lastname) as cst_lastname, 
case	when cst_marital_status = 'S' then 'Single'
		when cst_marital_status = 'M' then 'Married'
		else 'n/a'
end as cst_marital_status, 
case	when cst_gndr = 'F' then 'Female'
		when cst_gndr = 'M' then 'Male'
		else 'n/a'
end as cst_gndr,
cst_create_date
from (
select *, 
row_number() over (partition by cst_id order by cst_create_date desc) as flag_last
from bronze.crm_cust_info) t
where flag_last=1

print '================================================='
insert into silver.crm_prd_info(
prd_id,
cat_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)

select 
prd_id,
replace(substring(prd_key, 1,5), '-', '_') as cat_id,
substring(prd_key, 7, len(prd_key)) as prd_key,
prd_nm,
isnull(prd_cost, 0) as prd_cost,
prd_line,
cast(prd_start_dt as date) as prd_start_dt,
cast(lead(prd_start_dt) over ( partition by prd_key order by prd_start_dt)-1 as DATE) as prd_end_dt
from bronze.crm_prd_info
--where replace(substring(prd_key, 1,5), '-', '_') not in 
--(select distinct id from bronze.erp_px_cat_g1v2)
---select * from bronze.crm_sales_details
