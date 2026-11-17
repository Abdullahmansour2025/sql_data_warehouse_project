
Use Data_Warehouse 
Go ;

--- Check For Nulls Or Duplicates In Primary Key 
--- Experctation : No Result  

SELECT 
    cst_id , 
    count(*)
from bronze.crm_cust_info
group by cst_id
having count(*) > 1  


Select * ,
Row_Number()Over(Partition By Cst_Id Order By Cst_Create_Date Desc) As Flag_Last 
From Bronze.Crm_Cust_Info 
Where Cst_Id Is Not Null 


Select *
From 
(   Select * ,
    Row_Number()Over(Partition By Cst_Id Order By Cst_Create_Date Desc) As Flag_Last 
    From Bronze.Crm_Cust_Info 
    Where Cst_Id Is Not Null
) T 
Where Flag_Last != 1


---check for unwanted speaces 
--- Experctation : No Result  

Select Cst_Firstname
From Bronze.Crm_Cust_Info
Where Cst_Firstname != Trim (cst_FirstName)

SELECT cst_gndr
from bronze.crm_cust_info
where cst_gndr != trim(cst_gndr)

SELECT cst_marital_status
from bronze.crm_cust_info
where cst_marital_status != trim(cst_marital_status)

SELECT 
trim(cst_firstname) as cst_firstname ,
trim(cst_lastname) as cst_lastname 
from bronze.crm_cust_info



--data standardization & consistency
SELECT DISTINCT cst_marital_status
FROM BRONZE.crm_cust_info

SELECT DISTINCT CST_GNDR  
FROM BRONZE.crm_cust_info 






INSERT INTO Silver.crm_cust_info
(
    CST_ID ,
    CST_KEY ,
    CST_FIRSTNAME ,
    CST_LASTNAME ,
    CST_MARITAL_STATUS ,
    CST_GNDR ,
    CST_CREATE_DATE
)
SELECT 
    CST_ID ,
    CST_KEY , 
    trim(cst_firstname) as cst_firstname ,
    trim(cst_lastname) as cst_lastname ,
    case
        when UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        when UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        else 'N/A' 
    end as cst_marital_status , 
    case
        when UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male' 
        when UPPER (TRIM(cst_gndr)) = 'F' then 'Female'
        ELSE 'N/A' 
    end  as cst_gndr ,
    cst_create_date
from 
(
    SELECT *,
    ROW_NUMBER()OVER(PARTITION BY CST_ID ORDER BY Cst_Create_Date DESC ) AS FLAG_LAST
    FROM BRONZE.crm_cust_info
    WHERE cst_id IS NOT NULL 
)T 
WHERE FLAG_LAST = 1 








Select *
from silver.crm_cust_info

--- Check For Nulls Or Duplicates In Primary Key 
SELECT 
    cst_id ,
    count(*)
from silver.crm_cust_info
group by cst_id 
having count(*) >1


SELECT *,
ROW_NUMBER()OVER(PARTITION BY CST_ID ORDER BY Cst_Create_Date DESC ) AS FLAG_LAST
FROM silver.crm_cust_info
WHERE cst_id IS  NULL 

--- Experctation : No Result  

select cst_firstname 
from silver.crm_cust_info
where cst_firstname != trim(cst_firstname)
















---- CST_PRD_INFO 

--- Check For Nulls Or Duplicates In Primary Key 
--- Experctation : No Result  
SELECT 
    prd_id , 
    count(*)
from bronze.crm_prd_info
group by prd_id
having count(*) >1 or prd_id is null 
