/* 
=========================================================
Create Database and Schemas 
=========================================================
Script purpose:
	This script checks whether a database named DataWarehouse already exists in SQL Server and, 
	if it does, sets it to single-user mode and drops it to ensure a clean reset. It then creates 
	a new DataWarehouse database and switches the context to it. After the database is created, the 
	script defines three schemas: bronze, silver, and gold. These schemas represent a layered data 
	architecture used to organize raw data, transformed data, and business-ready analytical data.

WARNING:
	The script drops the existing DataWarehouse database, deleting all stored data and objects.
	It forces the database into single-user mode and rolls back active transactions, interrupting current users or processes.
	Running this script without a proper backup in a production environment can cause irreversible data loss and downtime.
*/
use master;
GO
if exists ( select 1 from sys.databases where name = 'DataWarehouse')
BEGIN 
	ALTER Database DataWarehouse set single_user with rollback immediate;
	Drop Database DataWarehouse;
END;
GO

create database DataWarehouse;
GO
use DataWarehouse;
GO
create schema bronze;
GO
create schema silver;
GO
create schema gold;
GO
