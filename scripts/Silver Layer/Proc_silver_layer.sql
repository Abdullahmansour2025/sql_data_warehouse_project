
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




print'>>Truncating Table : silver.Crm_Cust_Info';
TRUNCATE table silver.crm_cust_info
print'>>Inserting Data Into : silver.Crm_Cust_Info';
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


--- Check For Invalid Date Orders 
--- الداتا بايظه معكوسة ---
SELECT 
prd_key ,
prd_cost ,
prd_start_dt  ,
LEAD(prd_start_dt )OVER(PARTITION BY Prd_Key ORDER BY Prd_Start_Dt ASC )- 1 Prd_End_Dt
FROM BRONZE.crm_prd_info
where prd_key in ('AC-HE-HL-U509-R','AC-HE-HL-U509')



print'>>Truncating Table : silver.crm_prd_info';
TRUNCATE table silver.crm_prd_info
print'>>Inserting Data Into : silver.crm_prd_info';
INSERT into Silver.crm_prd_info 
(
    prd_id        , 
    cat_id        ,
    prd_key       ,
    prd_nm        ,
    prd_cost      , 
    prd_line      ,
    prd_start_dt  ,
    prd_end_dt     
)
Select 
    Prd_Id ,
    Replace(Substring(Prd_Key,1,5),'-','_')Cat_Id ,  -- extract category id  
    Substring(Prd_Key,7,Len(Prd_Key))Prd_Key ,  -- extract product id 
    Prd_Nm ,
    Coalesce(Prd_Cost,0)Prd_Cost ,
    Case Upper(Trim(Prd_Line))  
    When 'M' Then 'Mountain'
    When 'R' Then 'Road'
    When 'S' Then 'Other Sales'
    When 'T' Then 'Touring'
    Else 'N/A'
    End  Prd_Line , -- map product line codes to descriptive values 
    Cast(Prd_Start_Dt As Date )Prd_Start_Dt,
    Cast(Lead(Prd_Start_Dt )Over(Partition By Prd_Key Order By Prd_Start_Dt Asc )- 1 As Date) Prd_End_Dt -- calculate end date as one day before the next star date 
From Bronze.Crm_Prd_Info  

--- Check For Nulls Or Duplicates In Primary Key 
--- Experctation : No Result  
SELECT 
prd_id,
count(*)
from silver.crm_prd_info
group by prd_id 
having count(*) >1 or prd_id is null 




---Check For Unwanted Speaces 
--- Experctation : No Result  
select 
prd_nm
from silver.crm_prd_info
where prd_nm != trim(prd_nm)



---Check For nulls or negative numbers 
--- Experctation : No Result  
select 
prd_cost 
from silver.crm_prd_info
where  prd_cost < 0 or prd_cost is null 


--Data Standardization & Consistency
SELECT distinct  prd_line 
from silver.crm_prd_info


--- Check For Invalid Date Orders 
select *
from silver.crm_prd_info 
where prd_start_dt > prd_end_dt


--- crm_sales_details 
SELECT 
sls_ord_num , 
sls_prd_key , 
sls_cust_id , 
case
    when sls_order_dt <= 0 or len(sls_order_dt) != 8 then null
    else sls_order_dt
end 
sls_order_dt ,
sls_ship_dt , 
sls_due_dt ,
sls_sales ,
sls_quantity ,
sls_price  
from bronze.crm_sales_details 


SELECT 
sls_ord_num 
from bronze.crm_sales_details 
where sls_ord_num != trim (sls_ord_num)


SELECT 
sls_prd_key
from bronze.crm_sales_details 
where sls_prd_key not in (select prd_key from silver.crm_prd_info )

SELECT 
sls_cust_id
from bronze.crm_sales_details 
where sls_cust_id not in (select cst_id from silver.crm_cust_info )


--- Check For Invalid Date Orders 
Select 
Nullif(Sls_Order_Dt ,0)  As Sls_Order_Dt
From Bronze.Crm_Sales_Details
Where Sls_Order_Dt <= 0 
Or Len (Sls_Order_Dt ) != 8
Or Sls_Order_Dt > 20500101 
Or Sls_Order_Dt < 19500101


SELECT 
sls_due_dt
from bronze.crm_sales_details
where  len (sls_due_dt) != 8 or sls_due_dt <=0 or sls_due_dt >'20500101' or sls_due_dt <'19000101' or sls_due_dt is null


SELECT *
from bronze.crm_sales_details
where sls_order_dt > sls_ship_dt  or sls_ship_dt > sls_due_dt


SELECT 
sls_ord_num , 
sls_prd_key , 
sls_cust_id , 
case
    when sls_order_dt <= 0 or len(sls_order_dt) != 8 then null
    else cast(cast(sls_order_dt as nvarchar ) as date)
end sls_order_dt ,
case
    when sls_ship_dt <= 0 or len(sls_ship_dt) != 8 then null
    else cast(cast(sls_ship_dt as nvarchar ) as date)
end sls_ship_dt ,
case
    when sls_due_dt <= 0 or len(sls_due_dt) != 8 then null
    else cast(cast(sls_due_dt as nvarchar ) as date)
end sls_due_dt  ,
sls_sales ,
sls_quantity ,
sls_price  
from bronze.crm_sales_details 


select distinct 
sls_sales as old_sls_sales,
case
    when sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * abs(sls_price) then sls_quantity * abs(sls_price) 
    else sls_sales
end sls_sales ,
sls_quantity ,
sls_price as old_sls_price ,
case
    when sls_price is null or sls_price <= 0 then sls_sales / nullif(sls_quantity ,0 )
    else sls_price
end sls_price  
from bronze.crm_sales_details 
where sls_sales  != sls_quantity*sls_price 
or sls_sales is null or sls_quantity is null or sls_price is null 
or sls_sales <=0 or sls_quantity <=0  or sls_price <=0 
order by sls_sales ,sls_quantity ,sls_price   



print'>>Truncating Table : silver.crm_Sales_Details';
TRUNCATE table silver.crm_Sales_Details
print'>>Inserting Data Into : silver.crm_sales_details';
insert into  silver.crm_sales_details
(
    sls_ord_num ,
    sls_prd_key,
    sls_cust_id ,
    sls_order_dt ,
    sls_ship_dt , 
    sls_due_dt ,
    sls_sales ,
    sls_quantity , 
    sls_price
)
SELECT 
sls_ord_num , 
sls_prd_key , 
sls_cust_id , 
case
    when sls_order_dt <= 0 or len(sls_order_dt) != 8 then null
    else cast(cast(sls_order_dt as nvarchar ) as date)
end sls_order_dt ,
case
    when sls_ship_dt <= 0 or len(sls_ship_dt) != 8 then null
    else cast(cast(sls_ship_dt as nvarchar ) as date)
end sls_ship_dt ,
case
    when sls_due_dt <= 0 or len(sls_due_dt) != 8 then null
    else cast(cast(sls_due_dt as nvarchar ) as date)
end sls_due_dt  ,
case
    when sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * abs(sls_price) then sls_quantity * abs(sls_price) 
    else sls_sales
end sls_sales ,
sls_quantity ,
case
    when sls_price is null or sls_price <= 0 then sls_sales / nullif(sls_quantity ,0 )
    else sls_price
end sls_price  
from bronze.crm_sales_details 



select *
from silver.crm_sales_details



----- erp_CUST_AZ12 

select *
from bronze.erp_CUST_AZ12 
where cid like '%AW00011000%'

select *
from silver.crm_cust_info 
where cst_key like '%AW00011000%'



SELECT
case
    when cid like 'NAS%' THEN SUBSTRING(CID , 4 , LEN(CID)) 
    ELSE CID 
end CID ,
BDATE ,
GEN 
from bronze.erp_CUST_AZ12 
WHERE 
    case
        when cid like 'NAS%' THEN SUBSTRING(CID , 4 , LEN(CID)) 
        ELSE CID 
    end NOT IN (SELECT DISTINCT CST_KEY FROM SILVER.crm_cust_info )


---Identify out_of_range dates 

SELECT
BDATE 
from bronze.erp_CUST_AZ12 
WHERE BDATE <'1930-01-01' or bdate >getdate()



SELECT
    case
        when cid like 'NAS%' THEN SUBSTRING(CID , 4 , LEN(CID)) 
        ELSE CID 
    end CID ,
    case    
        when bdate > getdate() then null 
        else bdate 
    end bdate ,
    case
        when GEN = 'M' THEN 'Male' 
        when GEN = 'F' THEN 'Female' 
        when gen = ''  THEN  NULL 
        ELSE GEN 
    end GEN 
from bronze.erp_CUST_AZ12 


--Data Standardization & Consistency
SELECT distinct 
GEN 
from bronze.erp_CUST_AZ12 


SELECT DISTINCT 
GEN ,
  case 
        when  UPPER(TRIM (GEN)) IN  ('M','MALE')  THEN 'Male' 
        when UPPER(TRIM (GEN)) IN  ('F','FEMALE')  THEN 'Female'  
        ELSE 'N/A' 
    end GEN 
from bronze.erp_CUST_AZ12 



print'>>Truncating Table : Silver.erp_CUST_AZ12';
TRUNCATE TABLE  Silver.erp_CUST_AZ12 
print'>>Inserting Data Into : SILVER.erp_CUST_AZ12';
INSERT INTO SILVER.erp_CUST_AZ12 
(
    cid , 
    bdate ,
    gen 
)
SELECT
    case
        when cid like 'NAS%' THEN SUBSTRING(CID , 4 , LEN(CID)) 
        ELSE CID 
    end CID ,
    case    
        when bdate > getdate() then null 
        else bdate 
    end bdate ,
    case 
        when  UPPER(TRIM (GEN)) IN  ('M','MALE')  THEN 'Male' 
        when UPPER(TRIM (GEN)) IN  ('F','FEMALE')  THEN 'Female'  
        ELSE 'N/A' 
    end GEN 
from bronze.erp_CUST_AZ12 


SELECT *
from silver.erp_CUST_AZ12



--- erp_loc_a101 

SELECT 
cid , 
case
    when cid  like 'AW-%' then REPLACE(cid ,'-','')
    else cid 
end 
CNTRY 
from bronze.erp_LOC_A101 
where
case
    when cid  like 'AW-%' then REPLACE(cid ,'-','')
    else cid 
end not in (select cst_key from silver.crm_cust_info)


SELECT 
cid , 
case
    when cid  like 'AW-%' then REPLACE(cid ,'-','')
    else cid 
end ,
CNTRY 
from bronze.erp_LOC_A101 


SELECT 
cid
from bronze.erp_LOC_A101 
where cid is null 



print'>>Truncating Table : SILVER.erp_LOC_A101';
TRUNCATE TABLE SILVER.erp_LOC_A101 
print'>>Inserting Data Into : SILVER.erp_LOC_A101';
INSERT INTO SILVER.erp_LOC_A101  
(
    CID ,
    CNTRY
)
Select 
    Replace(cid,'-','') As cid  , 
    Case 
        When Trim(Cntry) ='DE' Then 'Germany' 
        When Trim(Cntry) In('US' ,'USA') Then 'United States'
        When Trim(Cntry) = '' Or Trim(Cntry) Is Null Then 'N/A'
        Else Trim(Cntry)
    End Cntry 
From Bronze.Erp_Loc_A101

SELECT *
FROM SILVER.erp_LOC_A101



--- erp_PX_CAT_G1V2

SELECT distinct id
from bronze.erp_PX_CAT_G1V2
where id not in (select cat_id from silver.crm_prd_info) 

SELECT *
from bronze.erp_PX_CAT_G1V2 
where cat !=trim(cat) or SUBCAT != trim(SUBCAT) or MAINTENANCE !=trim(MAINTENANCE)


print'>>Truncating Table : silver.Erp_Px_Cat_G1v2';
TRUNCATE table silver.Erp_Px_Cat_G1v2 
print'>>Inserting Data Into : silver.erp_PX_CAT_G1V2';
insert into silver.erp_PX_CAT_G1V2 (
    id , 
    cat ,
    subcat ,
    maintenance
)
Select 
    id , 
    cat ,
    subcat ,
    maintenance
From Bronze.Erp_Px_Cat_G1v2 


select *
from silver.erp_PX_CAT_G1V2
