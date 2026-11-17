
Use data_warehouse 
Go ;
--========================================
-- DDL(Data Definition Language) : Scripts for silver Layer Tables
--========================================

-- 1. CRM Tables 

DROP Table if Exists  silver.crm_cust_info 
GO 
CREATE table silver.crm_cust_info (
    cst_id              INT,
    cst_key             NVARCHAR(50),
    cst_firstname       NVARCHAR(50),
    cst_lastname        NVARCHAR(50),
    cst_marital_status  NVARCHAR(50),
    cst_gndr            NVARCHAR(50), 
    cst_create_date     date        ,
    dwh_create_date DATETIME2 DEFAULT getdate()
);

DROP Table if Exists  silver.crm_prd_info 
GO 
CREATE table silver.crm_prd_info (
    prd_id       int , 
    prd_key      NVARCHAR(50) ,
    prd_nm       NVARCHAR(50) ,
    prd_cost     int , 
    prd_line     NVARCHAR(50),
    prd_start_dt DATETIME ,
    prd_end_dt   DATETIME ,
    dwh_create_date DATETIME2 DEFAULT getdate()

);

DROP Table if Exists  silver.crm_sales_details 
GO 
CREATE table silver.crm_sales_details (
    sls_ord_num     NVARCHAR(50),
    sls_prd_key     NVARCHAR(50),
    sls_cust_id     int ,
    sls_order_dt    int , 
    sls_ship_dt     int , 
    sls_due_dt      int , 
    sls_sales       int ,
    sls_quantity    int ,
    sls_price       int ,
    dwh_create_date DATETIME2 DEFAULT getdate()

) ;

-- 2. ERP Tables 
DROP Table if Exists  silver.erp_CUST_AZ12 
GO 
create table silver.erp_CUST_AZ12 (
    CID     NVARCHAR(50) ,
    BDATE   DATE ,
    GEN     NVARCHAR(50) ,
    dwh_create_date DATETIME2 DEFAULT getdate()

) ; 

DROP Table if Exists  silver.erp_LOC_A101 
GO 
create table silver.erp_LOC_A101 (
    CID      NVARCHAR(50) , 
    CNTRY    NVARCHAR(50) ,
    dwh_create_date DATETIME2 DEFAULT getdate()

);

DROP Table if Exists  silver.erp_PX_CAT_G1V2 
GO 
create table  silver.erp_PX_CAT_G1V2 (
    ID          NVARCHAR(50) ,
    CAT         NVARCHAR(50),
    SUBCAT      NVARCHAR(50),
    MAINTENANCE NVARCHAR(50) ,
    dwh_create_date DATETIME2 DEFAULT getdate()

) ;
GO 

