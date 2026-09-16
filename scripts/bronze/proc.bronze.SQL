/* 
===========================================================================================================
STORED PROCEDURE: Load Bronze Layer (Sources -> Bronze)
============================================================================================================
Scop: 
    Aceasta procedura permite incarcarea datele in Bronze Layer din surse externe CSV file
    Va rula urmatorii pasi: 
    - goleste tabele bronze inainte de incarcarea datelor noi
    - foloseste comanda BULK INSERT pentru a prelua datele din fisierele CSV externe
Parametrii:
    Fara parametrii
    Procedura nu primeste parametrii si nu returneaza nici o valoare
Exemplu utilizare:
EXEC bronze.load_brone
=============================================================================================================
*/
    
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
  DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '*********************************************';
		PRINT 'Loading Bronze Layer';
		PRINT '*********************************************';

		PRINT '---------------------------------------------';
		PRINT 'Loading crm tables ';
		PRINT '---------------------------------------------';

		SET @start_time =GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info'
		TRUNCATE TABLE  bronze.crm_cust_info;

		PRINT '>> Inserting Data Into:bronze.crm_cust_info'
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\HP\Desktop\Portofoliu SQL\SQL Data analytics - project test\Data set\source_crm/cust_info.csv'
		WITH (
			FIRSTROW =2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time =GETDATE();
		PRINT '>> Load Duration: '+ CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '---------------------------------------------';

		SET @start_time =GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info'
		TRUNCATE TABLE  bronze.crm_prd_info;

		PRINT '>> Inserting Data Into: bronze.crm_prd_info'
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\HP\Desktop\Portofoliu SQL\SQL Data analytics - project test\Data set\source_crm/prd_info.csv'
		WITH (
			FIRSTROW =2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);
		SET @end_time =GETDATE();
		PRINT '>> Load Duration: '+ CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '---------------------------------------------';

		SET @start_time =GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details'
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>> Inserting Data Into: bronze.crm_sales_details'
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\HP\Desktop\Portofoliu SQL\SQL Data analytics - project test\Data set\source_crm/sales_details.csv'
		WITH (
			FIRSTROW =2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);
		SET @end_time =GETDATE();
		PRINT '>> Load Duration: '+ CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '---------------------------------------------';
	
		PRINT '---------------------------------------------';
		PRINT 'Loading erp tables ';
		PRINT '---------------------------------------------';

		SET @start_time =GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101'
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>> Inserting Data Into: bronze.erp_loc_a101'
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\HP\Desktop\Portofoliu SQL\SQL Data analytics - project test\Data set\source_erp/loc_a101.csv'
		WITH (
			FIRSTROW =2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);
		SET @end_time =GETDATE();
		PRINT '>> Load Duration: '+ CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '---------------------------------------------';

		SET @start_time =GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12'
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>> Inserting Data Into: bronze.erp_cust_az12'
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\HP\Desktop\Portofoliu SQL\SQL Data analytics - project test\Data set\source_erp/cust_az12.csv'
		WITH (
			FIRSTROW =2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);
		SET @end_time =GETDATE();
		PRINT '>> Load Duration: '+ CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '---------------------------------------------';

		SET @start_time =GETDATE();
		PRINT '>> Truncating Table:bronze.erp_px_cat_g1v2'
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2'
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\HP\Desktop\Portofoliu SQL\SQL Data analytics - project test\Data set\source_erp/px_cat_g1v2.csv'
		WITH (
			FIRSTROW =2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);
		SET @end_time =GETDATE();
		PRINT '>> Load Duration: '+ CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '---------------------------------------------';
		
		SET @batch_end_time = GETDATE();
		PRINT '---------------------------------------------------'
		PRINT 'Loading Bronze Layer is Completed';
		PRINT '>> Duration of Loading Bronze Layer: ' 
		PRINT ' Total Load Duration: ' + CAST(DATEDIFF(SECOND,@batch_start_time, @batch_end_time) AS NVARCHAR) +'seconds';
		PRINT '---------------------------------------------------';
	END TRY
	BEGIN CATCH
		PRINT '========================================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT '========================================================='
	END CATCH;
END;
--verificare incarcare tabele
	SELECT*FROM  bronze.crm_prd_info;
	SELECT COUNT(*)FROM  bronze.crm_prd_info;

	SELECT*FROM bronze.crm_sales_details;
	SELECT COUNT(*)FROM bronze.crm_sales_details;

	SELECT*FROM bronze.erp_loc_a101;
	SELECT COUNT(*)FROM bronze.erp_loc_a101;

	SELECT*FROM bronze.erp_cust_az12;
	SELECT COUNT(*)FROM bronze.erp_cust_az12;

	SELECT*FROM bronze.erp_px_cat_g1v2;
	SELECT COUNT(*)FROM bronze.erp_px_cat_g1v2;

	SELECT*FROM bronze.crm_cust_info;
	SELECT COUNT(*)FROM bronze.crm_cust_info;
