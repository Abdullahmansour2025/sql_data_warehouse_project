

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

