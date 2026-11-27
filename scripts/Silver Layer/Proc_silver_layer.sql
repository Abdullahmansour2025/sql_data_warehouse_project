/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC silver.load_silver;
===============================================================================
*/
CREATE OR ALTER PROCEDURE Silver.load_silver
AS
BEGIN
    DECLARE @BATCH_START_TIME AS DATETIME, @BATCH_END_TIME AS DATETIME, @START_TIME AS DATETIME, @END_TIME AS DATETIME;
    BEGIN TRY
        SET @BATCH_START_TIME = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';
        PRINT '------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '------------------------------------------------';
        SET @START_TIME = GETDATE();
        PRINT '>>Truncating Table : silver.Crm_Cust_Info';
        TRUNCATE TABLE silver.crm_cust_info;
        PRINT '>>Inserting Data Into : silver.Crm_Cust_Info';
        INSERT INTO Silver.Crm_Cust_Info (
            Cst_Id,
            Cst_Key,
            Cst_Firstname,
            Cst_Lastname,
            Cst_Marital_Status,
            Cst_Gndr,
            Cst_Create_Date
        )
        SELECT Cst_Id,
               Cst_Key,
               Trim(Cst_Firstname) AS Cst_Firstname,
               Trim(Cst_Lastname) AS Cst_Lastname,
               CASE WHEN Upper(Trim(Cst_Marital_Status)) = 'M' THEN 'Married' WHEN Upper(Trim(Cst_Marital_Status)) = 'S' THEN 'Single' ELSE 'N/A' END AS Cst_Marital_Status,
               CASE WHEN Upper(Trim(Cst_Gndr)) = 'M' THEN 'Male' WHEN Upper(Trim(Cst_Gndr)) = 'F' THEN 'Female' ELSE 'N/A' END AS Cst_Gndr,
               Cst_Create_Date
        FROM   (SELECT *,
                       Row_Number() OVER (PARTITION BY Cst_Id ORDER BY Cst_Create_Date DESC) AS Flag_Last
                FROM   Bronze.Crm_Cust_Info
                WHERE  Cst_Id IS NOT NULL) AS T
        WHERE  Flag_Last = 1;
        SET @END_TIME = GETDATE();
        PRINT '>> Load Duration: ' + CAST (DATEDIFF(SECOND, @START_TIME, @END_TIME) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
        SET @START_TIME = GETDATE();
        PRINT '>>Truncating Table : silver.crm_prd_info';
        TRUNCATE TABLE silver.crm_prd_info;
        PRINT '>>Inserting Data Into : silver.crm_prd_info';
        INSERT INTO Silver.crm_prd_info (
            prd_id,
            cat_id,
            prd_key,
            prd_nm,
            prd_cost,
            prd_line,
            prd_start_dt,
            prd_end_dt
        )
        SELECT Prd_Id,
               Replace(Substring(Prd_Key, 1, 5), '-', '_') AS Cat_Id, -- extract category id  
               Substring(Prd_Key, 7, Len(Prd_Key)) AS Prd_Key, -- extract product id 
               Prd_Nm,
               COALESCE (Prd_Cost, 0) AS Prd_Cost,
               CASE Upper(Trim(Prd_Line)) WHEN 'M' THEN 'Mountain' WHEN 'R' THEN 'Road' WHEN 'S' THEN 'Other Sales' WHEN 'T' THEN 'Touring' ELSE 'N/A' END AS Prd_Line, -- map product line codes to descriptive values 
               CAST (Prd_Start_Dt AS DATE) AS Prd_Start_Dt,
               CAST (Lead(Prd_Start_Dt) OVER (PARTITION BY Prd_Key ORDER BY Prd_Start_Dt ASC) - 1 AS DATE) AS Prd_End_Dt -- calculate end date as one day before the next star date 
        FROM   Bronze.Crm_Prd_Info;
        SET @END_TIME = GETDATE();
        PRINT '>> Load Duration: ' + CAST (DATEDIFF(SECOND, @START_TIME, @END_TIME) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
        SET @START_TIME = GETDATE();
        PRINT '>>Truncating Table : silver.crm_Sales_Details';
        TRUNCATE TABLE silver.crm_Sales_Details;
        PRINT '>>Inserting Data Into : silver.crm_sales_details';
        INSERT INTO silver.crm_sales_details (
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            sls_order_dt,
            sls_ship_dt,
            sls_due_dt,
            sls_sales,
            sls_quantity,
            sls_price
        )
        SELECT sls_ord_num,
               sls_prd_key,
               sls_cust_id,
               CASE WHEN sls_order_dt <= 0
                         OR len(sls_order_dt) != 8 THEN NULL ELSE CAST (CAST (sls_order_dt AS NVARCHAR) AS DATE) END AS sls_order_dt,
               CASE WHEN sls_ship_dt <= 0
                         OR len(sls_ship_dt) != 8 THEN NULL ELSE CAST (CAST (sls_ship_dt AS NVARCHAR) AS DATE) END AS sls_ship_dt,
               CASE WHEN sls_due_dt <= 0
                         OR len(sls_due_dt) != 8 THEN NULL ELSE CAST (CAST (sls_due_dt AS NVARCHAR) AS DATE) END AS sls_due_dt,
               CASE WHEN sls_sales IS NULL
                         OR sls_sales <= 0
                         OR sls_sales != sls_quantity * abs(sls_price) THEN sls_quantity * abs(sls_price) ELSE sls_sales END AS sls_sales,
               sls_quantity,
               CASE WHEN sls_price IS NULL
                         OR sls_price <= 0 THEN sls_sales / NULLIF (sls_quantity, 0) ELSE sls_price END AS sls_price
        FROM   bronze.crm_sales_details;
        SET @END_TIME = GETDATE();
        PRINT '>> Load Duration: ' + CAST (DATEDIFF(SECOND, @START_TIME, @END_TIME) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
        PRINT '------------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '------------------------------------------------';
        SET @START_TIME = GETDATE();
        PRINT '>>Truncating Table : Silver.erp_CUST_AZ12';
        TRUNCATE TABLE Silver.erp_CUST_AZ12;
        PRINT '>>Inserting Data Into : SILVER.erp_CUST_AZ12';
        INSERT INTO SILVER.erp_CUST_AZ12 (
            cid,
            bdate,
            gen
        )
        SELECT CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(CID, 4, LEN(CID)) ELSE CID END AS CID,
               CASE WHEN bdate > getdate() THEN NULL ELSE bdate END AS bdate,
               CASE WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') THEN 'Male' WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female' ELSE 'N/A' END AS GEN
        FROM   bronze.erp_CUST_AZ12;
        SET @END_TIME = GETDATE();
        PRINT '>> Load Duration: ' + CAST (DATEDIFF(SECOND, @START_TIME, @END_TIME) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
        SET @START_TIME = GETDATE();
        PRINT '>>Truncating Table : SILVER.erp_LOC_A101';
        TRUNCATE TABLE SILVER.erp_LOC_A101;
        PRINT '>>Inserting Data Into : SILVER.erp_LOC_A101';
        INSERT INTO SILVER.erp_LOC_A101 (
            CID,
            CNTRY
        )
        SELECT Replace(cid, '-', '') AS cid,
               CASE WHEN Trim(Cntry) = 'DE' THEN 'Germany' WHEN Trim(Cntry) IN ('US', 'USA') THEN 'United States' WHEN Trim(Cntry) = ''
                                                                                                                       OR Trim(Cntry) IS NULL THEN 'N/A' ELSE Trim(Cntry) END AS Cntry
        FROM   Bronze.Erp_Loc_A101;
        SET @END_TIME = GETDATE();
        PRINT '>> Load Duration: ' + CAST (DATEDIFF(SECOND, @START_TIME, @END_TIME) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
        SET @START_TIME = GETDATE();
        PRINT '>>Truncating Table : silver.Erp_Px_Cat_G1v2';
        TRUNCATE TABLE silver.Erp_Px_Cat_G1v2;
        PRINT '>>Inserting Data Into : silver.erp_PX_CAT_G1V2';
        INSERT INTO silver.erp_PX_CAT_G1V2 (
            id,
            cat,
            subcat,
            maintenance
        )
        SELECT id,
               cat,
               subcat,
               maintenance
        FROM   Bronze.Erp_Px_Cat_G1v2;
        SET @END_TIME = GETDATE();
        PRINT '>> Load Duration: ' + CAST (DATEDIFF(SECOND, @START_TIME, @END_TIME) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
        SET @BATCH_END_TIME = GETDATE();
        PRINT '=====================================';
        PRINT 'Loading Silver Layer Is Completed';
        PRINT 'Load Duration' + ' ' + CAST (DATEDIFF(SECOND, @BATCH_START_TIME, @BATCH_END_TIME) AS NVARCHAR) + 'seconds';
        PRINT '=====================================';
    END TRY
    BEGIN CATCH
        PRINT '=====================================';
        PRINT 'ERROR OCCURRED DURING LOADING SILVER LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST (ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST (ERROR_STATE() AS NVARCHAR);
        PRINT '=====================================';
    END CATCH
END
EXECUTE silver.load_silver ;
