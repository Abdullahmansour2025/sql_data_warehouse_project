Use Data_Warehouse
Go 
/*
===============================================================================
Quality Checks - Silver Layer
===============================================================================
*/


-- ====================================================================
-- Checking 'Silver.Crm_Cust_Info'
-- ====================================================================
--- Check For Nulls Or Duplicates In Primary Key 
--- Experctation : No Result  

Select 
    Cst_Id , 
    Count(*)
From Silver.Crm_Cust_Info
Group By Cst_Id
Having Count(*) > 1  


---Check For Unwanted Speaces 
--- Experctation : No Result  

Select Cst_Firstname
From Silver.Crm_Cust_Info
Where Cst_Firstname != Trim (Cst_Firstname)


--Data Standardization & Consistency
Select Distinct Cst_Marital_Status
From Silver.Crm_Cust_Info


-- ====================================================================
-- Checking 'Silver.Crm_Prd_Info'
-- ====================================================================

-- Check For Nulls Or Duplicates In Primary Key 
--- Experctation : No Result  
Select 
    Prd_Id , 
    Count(*)
From Silver.Crm_Prd_Info
Group By Prd_Id
Having Count(*) >1 Or Prd_Id Is Null 

---Check For Unwanted Speaces 
--- Experctation : No Result  
Select 
Prd_Nm
From Silver.Crm_Prd_Info 
Where Prd_Nm !=Trim(Prd_Nm)


---Check For Nulls Or Negative Numbers 
--- Experctation : No Result  
Select Prd_Cost
From Silver.Crm_Prd_Info
Where Prd_Cost Is Null Or Prd_Cost <0 


--Data Standardization & Consistency
Select 
 Distinct Prd_Line
From Silver.Crm_Prd_Info


--- Check For Invalid Date Orders 
Select *
From Silver.Crm_Prd_Info 
Where Prd_Start_Dt > Prd_End_Dt

-- ====================================================================
-- Checking 'Silver.Crm_sls_details'
-- ====================================================================
--- Check For Invalid Date Orders 

select * 
from silver.crm_sales_details 
where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt 

-- check data consistency : between sales , quantity , and price
--> sales =  quantity * price 
--> values must not be null , zero , negative 
SELECT 
    sls_sales ,
    sls_quantity ,
    sls_price 
from silver.crm_sales_details 
where sls_sales  != sls_quantity*sls_price 
or sls_sales is null or sls_quantity is null or sls_price is null 
or sls_sales <=0 or sls_quantity <=0  or sls_price <=0 
order by sls_sales ,sls_quantity ,sls_price   


-- ====================================================================
-- Checking 'Silver.erp_CUST_AZ12 '
-- ====================================================================
---Identify out_of_range dates 
SELECT
BDATE 
from silver.erp_CUST_AZ12 
WHERE BDATE <'1930-01-01' or bdate >getdate()


--Data Standardization & Consistency
Select 
Distinct gen
From Silver.erp_CUST_AZ12

-- ====================================================================
-- Checking 'Silver.erp_LOC_A101'
-- ====================================================================
--Data Standardization & Consistency
SELECT DISTINCT 
CNTRY
FROM SILVER.erp_LOC_A101
ORDER BY CNTRY ASC