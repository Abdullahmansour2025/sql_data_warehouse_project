/*
===============================================================================
DDL Script: Create Bronze Layer Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist. Run this script to redefine the DDL structure of 
    bronze tables.
===============================================================================
*/

Use data_warehouse 
Go ;
--========================================
-- DDL(Data Definition Language) : Scripts for Bronze Layer Tables
--========================================

-- 1. CRM Tables 

DROP Table if Exists  bronze.crm_cust_info 
GO 
CREATE table bronze.crm_cust_info (
    cst_id              INT,
    cst_key             NVARCHAR(50),
    cst_firstname       NVARCHAR(50),
    cst_lastname        NVARCHAR(50),
    cst_marital_status  NVARCHAR(50),
    cst_gndr            NVARCHAR(50), 
    cst_create_date     date
);

DROP Table if Exists  bronze.crm_prd_info 
GO 
CREATE table bronze.crm_prd_info (
    prd_id       int , 
    prd_key      NVARCHAR(50) ,
    prd_nm       NVARCHAR(50) ,
    prd_cost     int , 
    prd_line     NVARCHAR(50),
    prd_start_dt DATETIME ,
    prd_end_dt   DATETIME
);

DROP Table if Exists  bronze.crm_sales_details 
GO 
CREATE table bronze.crm_sales_details (
    sls_ord_num     NVARCHAR(50),
    sls_prd_key     NVARCHAR(50),
    sls_cust_id     int ,
    sls_order_dt    int , 
    sls_ship_dt     int , 
    sls_due_dt      int , 
    sls_sales       int ,
    sls_quantity    int ,
    sls_price       int 
) ;

-- 2. ERP Tables 
DROP Table if Exists  bronze.erp_CUST_AZ12 
GO 
create table bronze.erp_CUST_AZ12 (
    CID     NVARCHAR(50) ,
    BDATE   DATE ,
    GEN     NVARCHAR(50)
) ; 

DROP Table if Exists  bronze.erp_LOC_A101 
GO 
create table bronze.erp_LOC_A101 (
    CID      NVARCHAR(50) , 
    CNTRY    NVARCHAR(50) 
);

DROP Table if Exists  bronze.erp_PX_CAT_G1V2 
GO 
create table  bronze.erp_PX_CAT_G1V2 (
    ID          NVARCHAR(50) ,
    CAT         NVARCHAR(50),
    SUBCAT      NVARCHAR(50),
    MAINTENANCE NVARCHAR(50)
) ;
GO 
