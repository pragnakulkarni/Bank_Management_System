
  CREATE TABLE "ACCOUNT" 
   (	"ACCOUNT_ID" VARCHAR2(40), 
	"USER_ID" VARCHAR2(40), 
	"ACCOUNT_TYPE" VARCHAR2(20) NOT NULL ENABLE, 
	"IFSC_CODE" VARCHAR2(11), 
	"CURRENCY_CODE" VARCHAR2(3), 
	"BALANCE" NUMBER(15,2) DEFAULT 0.00 NOT NULL ENABLE, 
	"CREATED_AT" TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP, 
	"IS_LOCKED" CHAR(1) DEFAULT 'N', 
	"PASSWORD" VARCHAR2(100) NOT NULL ENABLE, 
	"ACTIVE_STATUS" CHAR(1) DEFAULT 'Y', 
	 CHECK (ACCOUNT_TYPE IN ('SAVINGS', 'CHECKING')) ENABLE, 
	 CHECK (IS_LOCKED IN ('Y', 'N')) ENABLE, 
	 CHECK (ACTIVE_STATUS IN ('Y', 'N')) ENABLE, 
	 PRIMARY KEY ("ACCOUNT_ID")
  USING INDEX  ENABLE
   ) ;

  ALTER TABLE "ACCOUNT" ADD FOREIGN KEY ("USER_ID")
	  REFERENCES "USERS" ("USER_ID") ENABLE;
  ALTER TABLE "ACCOUNT" ADD FOREIGN KEY ("IFSC_CODE")
	  REFERENCES "BANK" ("IFSC_CODE") ENABLE;
  ALTER TABLE "ACCOUNT" ADD FOREIGN KEY ("CURRENCY_CODE")
	  REFERENCES "EXCHANGE_CURRENCY" ("CURRENCY_CODE") ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "ACCOUNT_UPDATE_LOG" 
BEFORE UPDATE ON ACCOUNT
FOR EACH ROW
BEGIN
    IF UPDATING('ACCOUNT_TYPE') THEN
        IF :OLD.ACCOUNT_TYPE <> :NEW.ACCOUNT_TYPE THEN
            INSERT INTO ACCOUNT_LOG
            (ACCOUNT_ID, COLUMN_CHANGED, OLD_VALUE, NEW_VALUE) 
            VALUES
            (:OLD.ACCOUNT_ID ,'ACCOUNT_TYPE', :OLD.ACCOUNT_TYPE, :NEW.ACCOUNT_TYPE);
        END IF;            
    END IF;

    IF UPDATING('CURRENCY_CODE') THEN
        IF :OLD.CURRENCY_CODE <> :NEW.CURRENCY_CODE THEN
            INSERT INTO ACCOUNT_LOG
            (ACCOUNT_ID, COLUMN_CHANGED, OLD_VALUE, NEW_VALUE) 
            VALUES
            (:OLD.ACCOUNT_ID ,'CURRENCY_CODE', :OLD.CURRENCY_CODE, :NEW.CURRENCY_CODE);
        END IF;            
    END IF;

    IF UPDATING('PASSWORD') THEN
        IF :OLD.PASSWORD <> :NEW.PASSWORD THEN
            INSERT INTO ACCOUNT_LOG
            (ACCOUNT_ID, COLUMN_CHANGED, OLD_VALUE, NEW_VALUE) 
            VALUES
            (:OLD.ACCOUNT_ID ,'PASSWORD', :OLD.PASSWORD, :NEW.PASSWORD);
        END IF;            
    END IF;

    IF UPDATING('IS_LOCKED') THEN
        IF :OLD.IS_LOCKED <> :NEW.IS_LOCKED THEN
            INSERT INTO ACCOUNT_LOG
            (ACCOUNT_ID, COLUMN_CHANGED, OLD_VALUE, NEW_VALUE) 
            VALUES
            (:OLD.ACCOUNT_ID ,'IS_LOCKED', :OLD.IS_LOCKED, :NEW.IS_LOCKED);
        END IF;            
    END IF;

    IF UPDATING('ACTIVE_STATUS') THEN
        IF :OLD.ACTIVE_STATUS <> :NEW.ACTIVE_STATUS THEN
            INSERT INTO ACCOUNT_LOG
            (ACCOUNT_ID, COLUMN_CHANGED, OLD_VALUE, NEW_VALUE) 
            VALUES
            (:OLD.ACCOUNT_ID ,'ACTIVE_STATUS', :OLD.ACTIVE_STATUS, :NEW.ACTIVE_STATUS);
        END IF;            
    END IF;

    IF UPDATING('ACCOUNT_ID') THEN
        RAISE_APPLICATION_ERROR(-20250,'YOU CANNOT UPDATE ACCOUNT ID!');
    END IF;

    IF UPDATING('USER_ID') THEN
        RAISE_APPLICATION_ERROR(-20251,'YOU CANNOT UPDATE USER ID ASSOCIATED TO ACCOUNT');
    END IF;

    IF UPDATING('IFSC_CODE') THEN
        RAISE_APPLICATION_ERROR(-20252,'YOU CANNOT UPDATE IFSC CODE ASSOCIATED TO ACCOUNT');
    END IF;   

    IF UPDATING('CREATED_AT') THEN
        RAISE_APPLICATION_ERROR(-20253,'YOU CANNOT UPDATE CREATED_AT ASSOCIATED TO ACCOUNT');
    END IF;      
END;
/
ALTER TRIGGER "ACCOUNT_UPDATE_LOG" ENABLE;