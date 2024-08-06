
  CREATE TABLE "USERS" 
   (	"USER_ID" VARCHAR2(40), 
	"FIRST_NAME" VARCHAR2(50) NOT NULL ENABLE, 
	"LAST_NAME" VARCHAR2(50) NOT NULL ENABLE, 
	"PHONE_NUMBER" VARCHAR2(15) NOT NULL ENABLE, 
	"EMAIL" VARCHAR2(100) NOT NULL ENABLE, 
	"DOB" DATE NOT NULL ENABLE, 
	"GENDER" VARCHAR2(1), 
	"AADHAR_NUMBER" VARCHAR2(12) NOT NULL ENABLE, 
	"PAN_NUMBER" VARCHAR2(10) NOT NULL ENABLE, 
	"ADDRESS_ID" VARCHAR2(40), 
	 CHECK (GENDER IN ('M','F')) ENABLE, 
	 PRIMARY KEY ("USER_ID")
  USING INDEX  ENABLE, 
	 UNIQUE ("EMAIL")
  USING INDEX  ENABLE, 
	 UNIQUE ("AADHAR_NUMBER")
  USING INDEX  ENABLE, 
	 UNIQUE ("PAN_NUMBER")
  USING INDEX  ENABLE
   ) ;

  ALTER TABLE "USERS" ADD FOREIGN KEY ("ADDRESS_ID")
	  REFERENCES "USER_ADDRESS" ("ADDRESS_ID") ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "USER_UPDATE_LOG" 
BEFORE UPDATE ON USERS
FOR EACH ROW
BEGIN
IF UPDATING('FIRST_NAME') THEN
    IF :OLD.FIRST_NAME<>:NEW.FIRST_NAME THEN
        INSERT INTO USERS_LOG (USER_ID,COLUMN_CHANGED,OLD_VALUE,NEW_VALUE) VALUES(:OLD.USER_ID,'FIRST NAME',:OLD.FIRST_NAME,:NEW.FIRST_NAME);
    ELSE
        RAISE_APPLICATION_ERROR(-20500,'OLD FIRST NAME AND NEW FIRST NAME ARE SAME');
    END IF;
ELSIF UPDATING('LAST_NAME') THEN
    IF :OLD.LAST_NAME<>:NEW.LAST_NAME THEN
        INSERT INTO USERS_LOG (USER_ID,COLUMN_CHANGED,OLD_VALUE,NEW_VALUE) VALUES(:OLD.USER_ID,'LAST NAME',:OLD.LAST_NAME,:NEW.LAST_NAME);
    ELSE
        RAISE_APPLICATION_ERROR(-20501,'OLD LAST NAME AND NEW LAST NAME ARE SAME');
    END IF;
ELSIF UPDATING('PHONE_NUMBER') THEN
    IF :OLD.PHONE_NUMBER<>:NEW.PHONE_NUMBER THEN
        INSERT INTO USERS_LOG (USER_ID,COLUMN_CHANGED,OLD_VALUE,NEW_VALUE) VALUES(:OLD.USER_ID,'PHONE NUMBER',:OLD.PHONE_NUMBER,:NEW.PHONE_NUMBER);
    ELSE
        RAISE_APPLICATION_ERROR(-20502,'OLD PHONE NUMBER AND NEW PHONE NUMBER ARE SAME');
    END IF;
ELSIF UPDATING('EMAIL') THEN
    IF :OLD.EMAIL<>:NEW.EMAIL THEN
        INSERT INTO USERS_LOG (USER_ID,COLUMN_CHANGED,OLD_VALUE,NEW_VALUE) VALUES(:OLD.USER_ID,'EMAIL',:OLD.EMAIL,:NEW.EMAIL);
    ELSE
        RAISE_APPLICATION_ERROR(-20503,'OLD EMAIL AND NEW EMAIL ARE SAME');
    END IF;
ELSIF UPDATING('ADDRESS_ID') THEN
    IF :OLD.ADDRESS_ID<>:NEW.ADDRESS_ID THEN
            INSERT INTO USERS_LOG (USER_ID,COLUMN_CHANGED,OLD_VALUE,NEW_VALUE) VALUES(:OLD.USER_ID,'ADDRESS ID',:OLD.ADDRESS_ID,:NEW.ADDRESS_ID);
    ELSE
        RAISE_APPLICATION_ERROR(-20504,'OLD ADDRESS ID AND NEW ADDRESS ID ARE SAME');
    END IF;
ELSIF UPDATING('DOB') THEN
    RAISE_APPLICATION_ERROR(-20505,'DATE OF BIRTH OF A USER CANNOT BE CHANGED');
ELSIF UPDATING('GENDER') THEN
    RAISE_APPLICATION_ERROR(-20506,'GENDER OF A USER CANNOT BE CHANGED');
ELSIF UPDATING('AADHAR_NUMBER') THEN
    RAISE_APPLICATION_ERROR(20507,'AADHAR NUMBER OF A USER CANNOT BE CHANGED');
ELSIF UPDATING('PAN_NUMBER') THEN
    RAISE_APPLICATION_ERROR(-20508,'PAN NUMBER OF A USER CANNOT BE CHANGED');
END IF;
END;
/
ALTER TRIGGER "USER_UPDATE_LOG" ENABLE;