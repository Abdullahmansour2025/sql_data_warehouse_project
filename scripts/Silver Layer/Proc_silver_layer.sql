
Use Data_Warehouse 
Go ;

--- Check For Nulls Or Duplicates In Primary Key 
--- Experctation : No Result  

SELECT 
cst_id ,
COUNT(*) 
from bronze.crm_cust_info
group by cst_id 
having count(*) > 1

SELECT *
from 
(   SELECT *,
    ROW_NUMBER() over(partition by cst_id order by cst_create_date desc)flag_last
    from Bronze.crm_cust_info
    where cst_id is not null
)t  where flag_last !=1

---check for unwanted speaces 
--- Experctation : No Result  

SELECT cst_firstname
from bronze.crm_cust_info
where cst_firstname != trim (cst_firstname)

SELECT cst_lastname
from bronze.crm_cust_info
where cst_lastname != trim (cst_lastname)

SELECT cst_gndr
from bronze.crm_cust_info
where cst_gndr != trim (cst_gndr)


SELECT cst_marital_status
from bronze.crm_cust_info
where cst_marital_status != trim (cst_marital_status)




Select 
Cst_Id ,
Cst_Key,
Trim(Cst_Firstname) As Cst_Firstname ,
Trim(Cst_Lastname) As Cst_Lastname, 
Case
    When Upper(Trim(cst_marital_status)) = 'S' Then 'Single' 
    When Upper(Trim(cst_marital_status))= 'M' Then 'Married' 
    Else 'N/A'
End cst_marital_status,

Case
    When Upper(Trim(Cst_Gndr)) = 'M' Then 'Male' 
    When Upper(Trim(Cst_Gndr))= 'F' Then 'Female' 
    Else 'N/A'
End Cst_Gndr,
Cst_Create_Date
From 
(   Select *,
    Row_Number() Over(Partition By Cst_Id Order By Cst_Create_Date Desc)Flag_Last
    From Bronze.Crm_Cust_Info
    Where Cst_Id Is Not Null
)T  Where Flag_Last =1

--data standardization & consistency

SELECT distinct cst_marital_status
from Bronze.crm_cust_info


SELECT distinct cst_gndr
from Bronze.crm_cust_info


insert into silver.crm_cust_info 
(
    cst_id ,
    cst_key,
    cst_firstname ,
    cst_lastname,
    cst_marital_status ,
    cst_gndr,
    cst_create_date
)
Select 
Cst_Id ,
Cst_Key,
Trim(Cst_Firstname) As Cst_Firstname ,
Trim(Cst_Lastname) As Cst_Lastname, 
Case
    When Upper(Trim(cst_marital_status)) = 'S' Then 'Single' 
    When Upper(Trim(cst_marital_status))= 'M' Then 'Married' 
    Else 'N/A'
End cst_marital_status,

Case
    When Upper(Trim(Cst_Gndr)) = 'M' Then 'Male' 
    When Upper(Trim(Cst_Gndr))= 'F' Then 'Female' 
    Else 'N/A'
End Cst_Gndr,
Cst_Create_Date
From 
(   Select *,
    Row_Number() Over(Partition By Cst_Id Order By Cst_Create_Date Desc)Flag_Last
    From Bronze.Crm_Cust_Info
    Where Cst_Id Is Not Null
)T  Where Flag_Last =1


SELECT *
from silver.crm_cust_info




--- Check For Nulls Or Duplicates In Primary Key 
--- Experctation : No Result  

SELECT 
cst_id ,
COUNT(*) 
from silver.crm_cust_info
group by cst_id 
having count(*) > 1

---check for unwanted speaces 
--- Experctation : No Result  

SELECT cst_firstname
from silver.crm_cust_info
where cst_firstname != trim (cst_firstname)



--data standardization & consistency

SELECT distinct cst_marital_status
from silver.crm_cust_info

SELECT *
from silver.crm_cust_info



---- CST_PRD_INFO 

--- Check For Nulls Or Duplicates In Primary Key 
--- Experctation : No Result  
Select 
prd_id , 
count(*) 
from bronze.crm_prd_info
group by prd_id
having count(*) > 1 or prd_id is null 

Select 
prd_key, 
count(*) 
from bronze.crm_prd_info
group by prd_key
having count(*) > 1 or prd_key is null 



SELECT 
prd_id ,
SUBSTRING(prd_key , 1 , 5) cat_id  ,
substring (prd_key , 7)prd_key ,
prd_nm ,
prd_cost ,
prd_line ,
prd_start_dt ,
prd_end_dt
from bronze.crm_prd_info
