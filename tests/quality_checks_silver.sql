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