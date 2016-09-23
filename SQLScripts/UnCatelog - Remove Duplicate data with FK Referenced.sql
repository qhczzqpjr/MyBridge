/***********
Author: Thomas Zhu
Date: 2015-07-10
Comments: Used to Clean Dim.Agent duplicate data by column cappuid
Logic:   Combine the content of all duplicate row and keep only one row with the minimum AgentId, then update the reference in relative table and final remove the duplicate records.
**************/
USE DataWarehouse
GO
 
--Part1  
	--Disable Unique Index 

	ALTER INDEX UK_Agent ON Dim.Agent DISABLE
	ALTER INDEX UK_Agent_CapAlias ON Dim.Agent DISABLE

GO
	/*	Test Model
	--Dim.Agent will be replace by the formal Agent
	SELECT * INTO #Agents
	FROM Dim.Agent (NOLOCK)
	*/

--Part 2 
	--Get Mapping Information of AgentId and the one retained, this table will be used for updating the fact table
	IF Object_id('tempdb..#AgentId_dup') is not null
	DROP TABLE #AgentId_dup

	SELECT CapPuid, RN, MIN(AgentId) over (partition by CapPuid) MinAgentId, AgentId 
	INTO #AgentId_dup
	FROM ( SELECT
				ROW_NUMBER() over (Partition by CapPuid order by AgentId) RN
				,COUNT(AgentId) over (Partition by CapPuid) ct
				,AgentId
				,CapPuid
			FROM DataWarehouse.dim.Agent(NOLOCK)
			WHERE CapPuid !=-1 AND CapPuid IS NOT NULL
		) AS t
	WHERE ct >1

--Part3 
	--Prepare Dim.Agent with combined information
 BEGIN TRAN
	 BEGIN TRY

	;WITH Data(SourceKey,VendorSiteId,CapPuid,ForumsPuid,CapAlias,ForumsAlias,PartnersAlias,LmsAlias,PSAlias,FullName,Email,IsManager,ManagerId,IsTechLead,TechLeadId,IsEnabled,SourceCreatedDateTime,SourceUpdatedDateTime,CAPUserTypeID,IsSystemAccount,ChatAlias,DefaultIncidentQueueID,FirstLMSTrainingDate,FirstIncidentCallDate,user_div,Description,FirstIncidentModifiedDate,LastIncidentModifiedDate,LastIncidentCreatedDate)
	AS
	(SELECT 
		MAX(SourceKey)
		,MAX(VendorSiteId)
		,CapPuid
		,MAX(ForumsPuid)
		,MAX(CapAlias)
		,MAX(ForumsAlias)
		,MAX(PartnersAlias)
		,MAX(LmsAlias)
		,MAX(PSAlias)
		,MAX(FullName)
		,MAX(Email)
		,MAX(CASE WHEN IsManager=1 THEN 1 ELSE 0 END)
		,MAX(ManagerId)
		,MAX(CASE WHEN IsTechLead=1 THEN 1 ELSE 0 END)
		,MAX(TechLeadId)
		,MAX(CASE WHEN IsEnabled=1 THEN 1 ELSE 0 END)
		,MIN(SourceCreatedDateTime)
		,MIN(SourceUpdatedDateTime)
		,MAX(CAPUserTypeID)
		,MAX(CASE WHEN IsSystemAccount=1 THEN 1 ELSE 0 END)
		,MAX(ChatAlias)
		,MAX(DefaultIncidentQueueID)
		,MAX(FirstLMSTrainingDate)
		,MAX(FirstIncidentCallDate)
		,MAX(user_div)
		,MAX(Description)
		,MAX(FirstIncidentModifiedDate)
		,MAX(LastIncidentModifiedDate)
		,MAX(LastIncidentCreatedDate)
	FROM Dim.Agent (NOLOCK)
	WHERE Cappuid != -1 AND Cappuid IS NOT NULL
	GROUP BY CapPuid)

	Update a
	SET SourceKey=b.SourceKey
				,ForumsPuid = b.ForumsPuid
				,CapAlias = b.CapAlias
				,ForumsAlias=b.ForumsAlias
				,PartnersAlias=b.PartnersAlias
				,LmsAlias=b.LmsAlias
				,PSAlias=b.PSAlias
				,FullName=b.FullName
				,Email=b.Email
				,IsManager=b.IsManager
				,IsTechLead=b.IsTechLead
				,IsEnabled=b.IsEnabled
				,SourceCreatedDateTime=b.SourceCreatedDateTime
				,SourceUpdatedDateTime=b.SourceUpdatedDateTime
				,CAPUserTypeID=b.CAPUserTypeID
				,IsSystemAccount=b.IsSystemAccount
				,ChatAlias=b.ChatAlias
				,FirstLMSTrainingDate=b.FirstLMSTrainingDate
				,FirstIncidentCallDate=b.FirstIncidentCallDate
				,user_div=b.user_div
				,Description=b.Description
				,FirstIncidentModifiedDate=b.FirstIncidentModifiedDate
				,LastIncidentModifiedDate=b.LastIncidentModifiedDate
				,LastIncidentCreatedDate=b.LastIncidentCreatedDate
	FROM Dim.Agent a
	JOIN Data b
	  ON a.cappuid = b.cappuid
 
	 UPDATE a
		 SET AgentId = b.MinAgentId
		 FROM Fact.ChatByServiceLine (NOLOCK) a
		 JOIN #AgentId_dup (NOLOCK) b
		   ON a.AgentId = b.AgentId
	UPDATE a
		 SET AgentId = b.MinAgentId
		 FROM Fact.ASDContact (NOLOCK) a
		 JOIN #AgentId_dup (NOLOCK) b
		   ON a.AgentId = b.AgentId


-- Part 4- Remove the non referenced duplicate Agent records

	DELETE FROM Dim.Agent WHERE AgentId in (select AgentId from #AgentId_dup WHERE RN>=2)

	COMMIT
	END TRY
	BEGIN CATCH
		
		ROLLBACK

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT 
			@ErrorMessage = ERROR_MESSAGE(),
			@ErrorSeverity = ERROR_SEVERITY(),
			@ErrorState = ERROR_STATE();
		 
		RAISERROR(	@ErrorMessage, 
					@ErrorSeverity,
					@ErrorState );
	END CATCH
END




--Enable Index
ALTER INDEX ALL ON Dim.Agent REBUILD 

GO


SELECT COUNT(1)
FROM Fact.ASDContact (NOLOCK) a
JOIN #AgentId_dup (NOLOCK) b
   ON a.AgentId = b.AgentId AND RN>=2

SELECT COUNT(1)
FROM Fact.ChatByServiceLine (NOLOCK) a
JOIN #AgentId_dup (NOLOCK) b
   ON a.AgentId = b.AgentId AND RN>=2


CREATE NONCLUSTERED INDEX IX_ChatByServiceLine_AgentId ON Fact.ChatByServiceLine(AgentId)


SELECT  *
	FROM Dim.Agent (NOLOCK)
	where AgentId in (   select AgentId from #AgentId_dup)
	order by CapPuid
