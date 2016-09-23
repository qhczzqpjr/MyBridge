/***********
Author: Thomas Zhu
Date: 2015-07-10
Comments: Add logic for StoreProcedures
*/

DECLARE @ProcName nvarchar(128) = OBJECT_NAME(@@PROCID);

BEGIN TRAN
	BEGIN TRY


 
	COMMIT

	END TRY
	BEGIN CATCH
		
		

		DECLARE @ErrorNumber INT = ERROR_NUMBER();
		DECLARE @ErrorLine INT = ERROR_LINE();
		DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
		DECLARE @ErrorState INT = ERROR_STATE();

		PRINT 'Actual error number: ' + CAST(@ErrorNumber AS VARCHAR(10));
		PRINT 'Actual line number: ' + CAST(@ErrorLine AS VARCHAR(10));
		 
		RAISERROR(	@ErrorMessage, 
					@ErrorSeverity,
					@ErrorState );
	ROLLBACK

	END CATCH