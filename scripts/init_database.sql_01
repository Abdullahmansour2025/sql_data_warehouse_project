/*
===============================================================================
Create Database and Schemas
===============================================================================
Script Purpose:
This script creates a new database named 'DataWarehouse' after checking if it already exists.
If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
within the database: 'bronze', 'silver', and 'gold'.


WARNING:
Running this script will drop the entire 'DataWarehouse' database if it exists.
All data in the database will be permanently deleted. Proceed with caution
and ensure you have proper backups before running this script.
*/

-- Step 1: Switch to the master database to perform system operations
USE master;
GO

-- Step 2: Check if 'data_warehouse' exists, then disconnect users and delete it
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'data_warehouse')
BEGIN
    ALTER DATABASE data_warehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE data_warehouse;
END;
GO

-- Step 3: Create the main database from scratch
CREATE DATABASE data_warehouse;
GO

-- Step 4: Switch to the new 'data_warehouse' database
USE data_warehouse;
GO

-- Step 5: Create the three architecture layers (Schemas)
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
