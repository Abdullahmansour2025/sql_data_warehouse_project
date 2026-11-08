
/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
CREATE OR ALTER PROCEDURE BRONZE.LOAD_BRONZE AS 
 BEGIN 
    DECLARE @START_TIME DATETIME ,@END_TIME DATETIME , @BATCH_START_TIME DATETIME , @BATCH_END_TIME DATETIME 
    BEGIN TRY
    SET @BATCH_START_TIME =GETDATE() ;
        PRINT'--================================================='
        PRINT ' LOADING BRONZE LAYER'
        PRINT'--================================================='

        PRINT'---------------------------------------------------'
        PRINT ' LOADING CRM TABLES'
        PRINT'---------------------------------------------------'

        SET @START_TIME = GETDATE();
        PRINT '>> TRUNCATING TABLE : bronze.crm_cust_info'
        TRUNCATE TABLE bronze.crm_cust_info

        PRINT '>> INSERTING DATA INTO : bronze.crm_cust_info'
        Bulk Insert bronze.crm_cust_info
        from 'E:\Date Analyst\backup_sql\sql_material\datasets\source_crm\cust_info.csv'
        with (
            firstrow = 2 ,
            fieldterminator = ',' ,
            tablock 
        ) ;
        SET @END_TIME =GETDATE() ;
        PRINT '>>LOAD DURATION : ' + CAST(DATEDIFF(SECOND , @START_TIME ,@END_TIME) AS VARCHAR) +'SECONDS' ;
        PRINT '--------------------' ;

        SET @START_TIME = GETDATE();
        PRINT '>> TRUNCATING TABLE : bronze.crm_prd_info'
        TRUNCATE TABLE bronze.crm_prd_info

        PRINT '>> INSERTING DATA INTO : bronze.crm_prd_info'
        Bulk Insert bronze.crm_prd_info
        from 'E:\Date Analyst\backup_sql\sql_material\datasets\source_crm\prd_info.csv'
        with (
            firstrow = 2 ,
            fieldterminator = ',' ,
            tablock 
        ) ;
        SET @END_TIME =GETDATE() ;
        PRINT '>>LOAD DURATION : ' + CAST(DATEDIFF(SECOND , @START_TIME ,@END_TIME) AS VARCHAR) +'SECONDS' ;


        SET @START_TIME = GETDATE();
        PRINT '>> TRUNCATING TABLE : bronze.crm_sales_details'
        TRUNCATE TABLE bronze.crm_sales_details

        PRINT '>> INSERTING DATA INTO : bronze.crm_sales_details'
        Bulk Insert bronze.crm_sales_details
        from 'E:\Date Analyst\backup_sql\sql_material\datasets\source_crm\sales_details.csv'
        with (
            firstrow = 2 ,
            fieldterminator = ',' ,
            tablock 
        ) ;
        SET @END_TIME =GETDATE() ;
        PRINT '>>LOAD DURATION : ' + CAST(DATEDIFF(SECOND , @START_TIME ,@END_TIME) AS VARCHAR) +'SECONDS' ;

        PRINT'---------------------------------------------------'
        PRINT ' LOADING ERP TABLES'
        PRINT'---------------------------------------------------'

        SET @START_TIME = GETDATE();
        PRINT '>> TRUNCATING TABLE : ERP.CUST_AZ12'
        TRUNCATE TABLE bronze.erp_CUST_AZ12

        PRINT '>> INSERTING DATA INTO : bronze.erp_CUST_AZ12'
        Bulk Insert bronze.erp_CUST_AZ12
        from 'E:\Date Analyst\backup_sql\sql_material\datasets\source_erp\CUST_AZ12.csv'
        with (
            firstrow = 2 ,
            fieldterminator = ',' ,
            tablock 
        ) ;
        SET @END_TIME =GETDATE() ;
        PRINT '>>LOAD DURATION : ' + CAST(DATEDIFF(SECOND , @START_TIME ,@END_TIME) AS VARCHAR) +'SECONDS' ;


        SET @START_TIME = GETDATE();
        PRINT '>> TRUNCATING TABLE : bronze.erp_LOC_A101' 
        TRUNCATE TABLE bronze.erp_LOC_A101

        PRINT '>> INSERTING DATA INTO : bronze.erp_LOC_A101'
        Bulk Insert bronze.erp_LOC_A101
        from 'E:\Date Analyst\backup_sql\sql_material\datasets\source_erp\LOC_A101.csv'
        with (
            firstrow = 2 ,
            fieldterminator = ',' ,
            tablock 
        ) ;
        SET @END_TIME =GETDATE() ;
        PRINT '>>LOAD DURATION : ' + CAST(DATEDIFF(SECOND , @START_TIME ,@END_TIME) AS VARCHAR) +'SECONDS' ;

         SET @START_TIME = GETDATE();
        PRINT '>> TRUNCATING TABLE : bronze.erp_PX_CAT_G1V2' 
        TRUNCATE TABLE bronze.erp_PX_CAT_G1V2

        PRINT '>> INSERTING DATA INTO : bronze.erp_PX_CAT_G1V2'
        Bulk Insert bronze.erp_PX_CAT_G1V2
        from 'E:\Date Analyst\backup_sql\sql_material\datasets\source_ERP\PX_CAT_G1V2.csv'
        with (
            firstrow = 2 ,
            fieldterminator = ',' ,
            tablock 
        ) ;
        SET @END_TIME =GETDATE() ;
        PRINT '>>LOAD DURATION : ' + CAST(DATEDIFF(SECOND , @START_TIME ,@END_TIME) AS VARCHAR) + 'SECONDS' ;

    END TRY 
    BEGIN CATCH
        PRINT '==================================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '=================================================='
    END CATCH
    SET @BATCH_END_TIME = GETDATE() ;
    PRINT '============================================================'
    PRINT 'LOADING BRONZE LAYER IS COMPLETED';
    PRINT '>>LOAD DURATION : ' + CAST(DATEDIFF(SECOND , @BATCH_START_TIME ,@BATCH_END_TIME) AS VARCHAR) + 'SECONDS' ;
    PRINT '============================================================'
END 


EXEC BRONZE.LOAD_BRONZE
