/*
====================================================================================
Stored Procedure: Load Bronze Layer (source -> Bronze)
====================================================================================
Script purpose: 
  This stored procedure loads data into the 'bronze' schema from external CSV files.
  It performs the following actions: 
    - Truncate the bronze tables before loading data
    - Uses the 'Bulk Insert' command to load data from CSV files to bronze tables.

parameters: 
  none. 
  This storage procedure does not accept any parameters or return any values.

Usage example: 
  Exec bronze.load_bronze;
====================================================================================
*/

create or alter procedure bronze.load_bronze as 
begin
Declare @batch_start_time DATETIME, @batch_end_time DATETIME;
begin try
set @batch_start_time = getdate();
print '=============================';
print 'loading Bronze Layer';
print '=============================';

print '-----------------------------';
print 'Loading CRM Tables';
print '-----------------------------';

print '>> Truncating Table: bronze.crm_cust_info';
truncate table bronze.crm_cust_info;

print '>> Inserting data into Table: bronze.crm_cust_info';
BULK INSERT bronze.crm_cust_info
from 'C:\Users\venka\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
with(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
);
print '>> Truncating Table: bronze.crm_sales_details';
truncate table bronze.crm_sales_details;

BULK INSERT bronze.crm_sales_details
from 'C:\Users\venka\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
with(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
);

print '>> Truncating Table: bronze.crm_prd_info';
truncate table bronze.crm_prd_info;

BULK INSERT bronze.crm_prd_info
from 'C:\Users\venka\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
with(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
);

print '>> Truncating Table: bronze.crm_prd_info';
truncate table bronze.crm_prd_info;
BULK INSERT bronze.crm_prd_info
from 'C:\Users\venka\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
with(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
);

print '----------------------------------';
print 'Loading ERP Tables';
print '----------------------------------';
truncate table bronze.erp_cust_az12;
BULK INSERT bronze.erp_cust_az12
from 'C:\Users\venka\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
with(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
);

truncate table bronze.erp_loc_a101;
BULK INSERT bronze.erp_loc_a101
from 'C:\Users\venka\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
with(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
);

truncate table bronze.erp_px_cat_g1v2;
BULK INSERT bronze.erp_px_cat_g1v2
from 'C:\Users\venka\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
with(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
);
set @batch_end_time = getdate();
print 'Total load Duration: '+ cast(datediff(second, @batch_start_time, @batch_end_time) as NVARCHAR) + 'seconds';
print 'successfully insertion completed'
end try
begin catch
print 'Error Occured during Bronze Layer';
print 'Error Message: ' + Error_message();
print 'Error Message: ' + cast(Error_number() as NVARCHAR);
print 'Error Message: ' + cast(Error_state() as NVARCHAR);
end catch
end
