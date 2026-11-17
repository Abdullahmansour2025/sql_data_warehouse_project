
Use Data_Warehouse 
Go ;

--- Check For Nulls Or Duplicates In Primary Key 
--- Experctation : No Result  

Select 
    Cst_Id , 
    Count(*)
From Bronze.Crm_Cust_Info
Group By Cst_Id
Having Count(*) > 1  


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


---Check For Unwanted Speaces 
--- Experctation : No Result  

Select Cst_Firstname
From Bronze.Crm_Cust_Info
Where Cst_Firstname != Trim (Cst_Firstname)

Select Cst_Gndr
From Bronze.Crm_Cust_Info
Where Cst_Gndr != Trim(Cst_Gndr)

Select Cst_Marital_Status
From Bronze.Crm_Cust_Info
Where Cst_Marital_Status != Trim(Cst_Marital_Status)

Select 
Trim(Cst_Firstname) As Cst_Firstname ,
Trim(Cst_Lastname) As Cst_Lastname 
From Bronze.Crm_Cust_Info



--Data Standardization & Consistency
Select Distinct Cst_Marital_Status
From Bronze.Crm_Cust_Info

Select Distinct Cst_Gndr  
From Bronze.Crm_Cust_Info 






Insert Into Silver.Crm_Cust_Info
(
    Cst_Id ,
    Cst_Key ,
    Cst_Firstname ,
    Cst_Lastname ,
    Cst_Marital_Status ,
    Cst_Gndr ,
    Cst_Create_Date
)
Select 
    Cst_Id ,
    Cst_Key , 
    Trim(Cst_Firstname) As Cst_Firstname ,
    Trim(Cst_Lastname) As Cst_Lastname ,
    Case
        When Upper(Trim(Cst_Marital_Status)) = 'M' Then 'Married'
        When Upper(Trim(Cst_Marital_Status)) = 'S' Then 'Single'
        Else 'N/A' 
    End As Cst_Marital_Status , 
    Case
        When Upper(Trim(Cst_Gndr)) = 'M' Then 'Male' 
        When Upper (Trim(Cst_Gndr)) = 'F' Then 'Female'
        Else 'N/A' 
    End  As Cst_Gndr ,
    Cst_Create_Date
From 
(
    Select *,
    Row_Number()Over(Partition By Cst_Id Order By Cst_Create_Date Desc ) As Flag_Last
    From Bronze.Crm_Cust_Info
    Where Cst_Id Is Not Null 
)T 
Where Flag_Last = 1 








Select *
From Silver.Crm_Cust_Info

--- Check For Nulls Or Duplicates In Primary Key 
Select 
    Cst_Id ,
    Count(*)
From Silver.Crm_Cust_Info
Group By Cst_Id 
Having Count(*) >1


Select *,
Row_Number()Over(Partition By Cst_Id Order By Cst_Create_Date Desc ) As Flag_Last
From Silver.Crm_Cust_Info
Where Cst_Id Is  Null 

--- Experctation : No Result  

Select Cst_Firstname 
From Silver.Crm_Cust_Info
Where Cst_Firstname != Trim(Cst_Firstname)





---- Cst_Prd_Info 

--- Check For Nulls Or Duplicates In Primary Key 
--- Experctation : No Result  
Select 
    Prd_Id , 
    Count(*)
From Bronze.Crm_Prd_Info
Group By Prd_Id
Having Count(*) >1 Or Prd_Id Is Null 



SELECT 
    prd_id ,
    replace(SUBSTRING(prd_key,1,5),'-','_')cat_id ,
    SUBSTRING(prd_key,7,len(prd_key))prd_key,
    prd_nm ,
    prd_cost ,
    prd_line , 
    prd_start_dt ,
    prd_end_dt 
from bronze.crm_prd_info crm 
where SUBSTRING(prd_key,7,len(prd_key)) not in 
(   select 
    distinct sls_prd_key
    from bronze.crm_sales_details
)


SELECT 
    prd_id ,
    replace(SUBSTRING(prd_key,1,5),'-','_')cat_id ,
    SUBSTRING(prd_key,7,len(prd_key))prd_key,
    prd_nm ,
    prd_cost ,
    prd_line , 
    prd_start_dt ,
    prd_end_dt 
from bronze.crm_prd_info crm 


---Check For Unwanted Speaces 
--- Experctation : No Result  
SELECT 
prd_nm
from bronze.crm_prd_info 
where prd_nm !=trim(prd_nm)

---Check For nulls or negative numbers 
--- Experctation : No Result  
SELECT prd_cost
from bronze.crm_prd_info
where prd_cost is null or prd_cost <0 

Select 
    Prd_Id ,
    Replace(Substring(Prd_Key,1,5),'-','_')Cat_Id ,
    Substring(Prd_Key,7,Len(Prd_Key))Prd_Key,
    Prd_Nm ,
    Coalesce(Prd_Cost,0)Prd_Cost ,
    Case Upper(Trim(Prd_Line))  
    When 'M' Then 'Mountain'
    When 'R' Then 'Road'
    When 'S' Then 'Other Sales'
    When 'T' Then 'Touring'
    Else 'N/A'
    End  Prd_Line ,
    Prd_Start_Dt ,
    Prd_End_Dt 
From Bronze.Crm_Prd_Info Crm 


--Data Standardization & Consistency
SELECT 
 distinct prd_line
from bronze.crm_prd_info
