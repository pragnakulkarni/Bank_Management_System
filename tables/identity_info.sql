
  CREATE TABLE "IDENTITY_INFO" 
   (	"IDENTITY_ID" VARCHAR2(20), 
	"FULL_NAME" VARCHAR2(40), 
	"AADHAR_NUMBER" VARCHAR2(12), 
	"PAN_NUMBER" VARCHAR2(10)
   ) ;

  CREATE OR REPLACE EDITIONABLE TRIGGER "UPDATE_ON_IDENTITY_INFO" 
BEFORE UPDATE OR DELETE ON IDENTITY_INFO
BEGIN
    RAISE_APPLICATION_ERROR(-20999, 'RESTRICTED UPDATE AND DELETE ON IDENTITY INFO');
END;
/
ALTER TRIGGER "UPDATE_ON_IDENTITY_INFO" ENABLE;