create or replace PACKAGE BODY UTILS_ACCOUNT
IS
    PROCEDURE LOAD_ACCOUNTS
    IS
    BEGIN
        SELECT * BULK COLLECT INTO V_ACCOUNTS FROM ACCOUNT;
        -- DBMS_OUTPUT.PUT_LINE(V_ACCOUNTS.COUNT);
    END LOAD_ACCOUNTS;

    -----------------------------------------------------------------------

    PROCEDURE GET_ACCOUNTS
    IS
    BEGIN
        UTILS_ACCOUNT.LOAD_ACCOUNTS;
        DBMS_OUTPUT.PUT_LINE(
            RPAD('ACCOUNT_ID',15) || RPAD('USER_ID',15 )||RPAD('ACCOUNT_TYPE',15 )||RPAD('IFSC_CODE',15 ) ||
            RPAD('CURRENCY_CODE',15) ||RPAD('BALANCE',15) ||RPAD('CREATED_AT',35) ||RPAD('IS_LOCKED',15) ||
            RPAD('PASSWORD',15) ||RPAD('ACTIVE_STATUS',15)
        );
        DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------------------------------------------------------------------------------------------');
        FOR I IN 1 .. UTILS_ACCOUNT.V_ACCOUNTS.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(V_ACCOUNTS(I).ACCOUNT_ID,15) || RPAD(V_ACCOUNTS(I).USER_ID,15 )||RPAD(V_ACCOUNTS(I).ACCOUNT_TYPE,15 )||RPAD(V_ACCOUNTS(I).IFSC_CODE,15 ) ||
                RPAD(V_ACCOUNTS(I).CURRENCY_CODE,15) ||RPAD(V_ACCOUNTS(I).BALANCE,15) ||RPAD(V_ACCOUNTS(I).CREATED_AT,40) ||RPAD(V_ACCOUNTS(I).IS_LOCKED,10) ||
                RPAD(V_ACCOUNTS(I).PASSWORD,15) ||RPAD(V_ACCOUNTS(I).ACTIVE_STATUS,15)
                );
        END LOOP;
    END;        

    PROCEDURE UPDATE_CURRENCY_CODE_BY_ACCOUNT_ID
    (
        P_ACCOUNT_ID ACCOUNT.ACCOUNT_ID%TYPE,
        P_CURRENCY_CODE ACCOUNT.CURRENCY_CODE%TYPE
    )
    IS
        NULL_ACCOUNT_ID EXCEPTION;
        NULL_CURRENCY_CODE EXCEPTION;
        NO_ACCOUNT_EXISTS EXCEPTION;
        NO_CURRENCY_EXISTS EXCEPTION;
        V_CURRENCY_CODE ACCOUNT.CURRENCY_CODE%TYPE;
        V_EXCHANGE_RATE EXCHANGE_CURRENCY.EXCHANGE_RATE%TYPE;
        V_CURRENCY_CODE_FROM  ACCOUNT.CURRENCY_CODE%TYPE;
        V_BALANCE ACCOUNT.BALANCE%TYPE;
        V_UPDATE_BALANCE ACCOUNT.BALANCE%TYPE;
    BEGIN
        IF P_ACCOUNT_ID IS NULL THEN
            RAISE NULL_ACCOUNT_ID;
        END IF;

        IF P_CURRENCY_CODE IS NULL THEN
            RAISE NULL_CURRENCY_CODE;
        END IF;

        V_CURRENCY_CODE := UPPER(P_CURRENCY_CODE);
        
        IF ACCOUNT_PKG.CHECK_ACCOUNT_ID_EXISTS(P_ACCOUNT_ID) = FALSE THEN
            RAISE NO_ACCOUNT_EXISTS;
        END IF;        

        IF CURRENCY_PKG.CHECK_CURRENCY_CODE_EXISTS(V_CURRENCY_CODE) = TRUE THEN
            RAISE NO_CURRENCY_EXISTS;
        END IF;        
        SELECT CURRENCY_CODE INTO V_CURRENCY_CODE_FROM FROM ACCOUNT WHERE ACCOUNT_ID = P_ACCOUNT_ID;
        UPDATE ACCOUNT
        SET CURRENCY_CODE = V_CURRENCY_CODE
        WHERE ACCOUNT_ID = P_ACCOUNT_ID;

        IF SQL%ROWCOUNT>0 THEN
            DBMS_OUTPUT.PUT_LINE('CURRENCY CODE CHANAGED SUCCESFULLY');
            SELECT BALANCE INTO V_BALANCE FROM ACCOUNT WHERE ACCOUNT_ID = P_ACCOUNT_ID;
       
            V_UPDATE_BALANCE := CURRENCY_CONVERTER_FUNC
            (
                FROM_CURRENCY_CODE => V_CURRENCY_CODE_FROM,
                TO_CURRENCY_CODE => V_CURRENCY_CODE,
                FROM_CURRENCY_VALUE => V_BALANCE
            );
            SELECT EXCHANGE_RATE INTO V_EXCHANGE_RATE FROM EXCHANGE_CURRENCY WHERE CURRENCY_CODE = V_CURRENCY_CODE;
            UPDATE ACCOUNT
            SET BALANCE = V_UPDATE_BALANCE
            WHERE ACCOUNT_ID = UPPER(P_ACCOUNT_ID);
        ELSE
            DBMS_OUTPUT.PUT_LINE('CURRENCY CODE CHANGED FAILED');
        END IF;       

        EXCEPTION
            WHEN NULL_ACCOUNT_ID THEN
                DBMS_OUTPUT.PUT_LINE('ENTER PROPER ACCOUNT ID, NO NULL VALUES');
            WHEN NULL_CURRENCY_CODE THEN
                DBMS_OUTPUT.PUT_LINE('ENTER PROPER CURRENCY CODE, NO NULL VALUES!');
            WHEN NO_ACCOUNT_EXISTS THEN
                DBMS_OUTPUT.PUT_LINE(q'('PROVIDED BANK ACCOUNT DOES'T EXIST)' || P_ACCOUNT_ID);
            WHEN NO_CURRENCY_EXISTS THEN
                DBMS_OUTPUT.PUT_LINE(q'('PROVIDED CURRENCY CODE DOES'T EXIST)' || V_CURRENCY_CODE);
      
    END;

    PROCEDURE CURRENCY_CONVERTER
    (
        FROM_CURRENCY_CODE EXCHANGE_CURRENCY.CURRENCY_CODE%TYPE,
        TO_CURRENCY_CODE EXCHANGE_CURRENCY.CURRENCY_CODE%TYPE,
        FROM_CURRENCY_VALUE ACCOUNT.BALANCE%TYPE
    )
    IS
        FROM_EXCHANGE_RATE EXCHANGE_CURRENCY.EXCHANGE_RATE%TYPE;
        TO_EXCHANGE_RATE EXCHANGE_CURRENCY.EXCHANGE_RATE%TYPE;
        TO_CURRENCY_VALUE ACCOUNT.BALANCE%TYPE;
    BEGIN
        SELECT EXCHANGE_RATE INTO TO_EXCHANGE_RATE FROM EXCHANGE_CURRENCY WHERE CURRENCY_CODE = TO_CURRENCY_CODE;
        SELECT EXCHANGE_RATE INTO FROM_EXCHANGE_RATE FROM EXCHANGE_CURRENCY WHERE CURRENCY_CODE = FROM_CURRENCY_CODE;
        TO_CURRENCY_VALUE := (TO_EXCHANGE_RATE / FROM_EXCHANGE_RATE) * FROM_CURRENCY_VALUE;
        DBMS_OUTPUT.PUT_LINE(FROM_CURRENCY_VALUE || ' ' || FROM_CURRENCY_CODE || ' IS EQUIVALENT TO '|| TO_CURRENCY_VALUE || ' ' || TO_CURRENCY_CODE);
    END CURRENCY_CONVERTER;

    FUNCTION CURRENCY_CONVERTER_FUNC
    (
        FROM_CURRENCY_CODE EXCHANGE_CURRENCY.CURRENCY_CODE%TYPE,
        TO_CURRENCY_CODE EXCHANGE_CURRENCY.CURRENCY_CODE%TYPE,
        FROM_CURRENCY_VALUE ACCOUNT.BALANCE%TYPE
    ) RETURN NUMBER
    IS
        FROM_EXCHANGE_RATE EXCHANGE_CURRENCY.EXCHANGE_RATE%TYPE;
        TO_EXCHANGE_RATE EXCHANGE_CURRENCY.EXCHANGE_RATE%TYPE;
        TO_CURRENCY_VALUE ACCOUNT.BALANCE%TYPE;
    BEGIN
        SELECT EXCHANGE_RATE INTO TO_EXCHANGE_RATE FROM EXCHANGE_CURRENCY WHERE CURRENCY_CODE = TO_CURRENCY_CODE;
        SELECT EXCHANGE_RATE INTO FROM_EXCHANGE_RATE FROM EXCHANGE_CURRENCY WHERE CURRENCY_CODE = FROM_CURRENCY_CODE;
        TO_CURRENCY_VALUE := (TO_EXCHANGE_RATE / FROM_EXCHANGE_RATE) * FROM_CURRENCY_VALUE;
        -- DBMS_OUTPUT.PUT_LINE(FROM_CURRENCY_VALUE || ' ' || FROM_CURRENCY_CODE || ' IS EQUIVALENT TO '|| TO_CURRENCY_VALUE || ' ' || TO_CURRENCY_CODE);
        RETURN TO_CURRENCY_VALUE;
    END CURRENCY_CONVERTER_FUNC;

    PROCEDURE UPDATE_ACCOUNT_TYPE
    (
        P_ACCOUNT_ID ACCOUNT.ACCOUNT_ID%TYPE,
        P_ACCOUNT_TYPE ACCOUNT.ACCOUNT_TYPE%TYPE
    )
    IS
        NULL_ACCOUNT_ID EXCEPTION;
        NULL_ACCOUNT_TYPE EXCEPTION;
        NO_ACCOUNT_EXISTS EXCEPTION;
        NO_ACCOUNT_TYPE EXCEPTION;
        SAME_OLD_NEW_VALUE EXCEPTION;
        BEFORE_ACCOUNT_TYPE ACCOUNT.ACCOUNT_TYPE%TYPE;
    BEGIN    

        IF P_ACCOUNT_ID IS NULL THEN
            RAISE NULL_ACCOUNT_ID;
        END IF;

        IF P_ACCOUNT_TYPE IS NULL THEN
            RAISE  NULL_ACCOUNT_TYPE;
        END IF;

        IF ACCOUNT_PKG.CHECK_ACCOUNT_ID_EXISTS(P_ACCOUNT_ID) = FALSE THEN
            RAISE NO_ACCOUNT_EXISTS;
        END IF; 

        IF P_ACCOUNT_TYPE NOT IN ('SAVINGS', 'CHECKING') THEN
            RAISE NO_ACCOUNT_TYPE;
        END IF;        

        SELECT ACCOUNT_TYPE INTO BEFORE_ACCOUNT_TYPE FROM ACCOUNT WHERE ACCOUNT_ID = P_ACCOUNT_ID;

        IF BEFORE_ACCOUNT_TYPE = UPPER(P_ACCOUNT_TYPE) THEN
            RAISE SAME_OLD_NEW_VALUE;
        END IF;

        UPDATE ACCOUNT
        SET ACCOUNT_TYPE = P_ACCOUNT_TYPE
        WHERE ACCOUNT_ID = P_ACCOUNT_ID;

        IF SQL%ROWCOUNT>0 THEN
            DBMS_OUTPUT.PUT_LINE('ACCOUNT TYPE CHANGED');
            DBMS_OUTPUT.PUT_LINE(RPAD('BEFORE ',10)  || ' : ' ||BEFORE_ACCOUNT_TYPE );
            DBMS_OUTPUT.PUT_LINE(RPAD('AFTER ',10 ) || ' : ' ||P_ACCOUNT_TYPE);
        END IF ;   

        EXCEPTION 
            WHEN  NULL_ACCOUNT_ID THEN
                DBMS_OUTPUT.PUT_LINE('ENTER PROPER ACCOUNT ID, NULL VALUES NOT ALLOWED');
            WHEN  NULL_ACCOUNT_TYPE THEN
                DBMS_OUTPUT.PUT_LINE('ENTER PROPER ACCOUNT TYPE, NULL VALUES NOT ALLOWED')               ;
            WHEN  NO_ACCOUNT_EXISTS THEN
                DBMS_OUTPUT.PUT_LINE('ACCOUNT DOES NOT EXISTS');
            WHEN   NO_ACCOUNT_TYPE THEN
                DBMS_OUTPUT.PUT_LINE('ACCOUNT TPYE IS WRONG. SELECT EITHER SAVINGS OR CHECKING');
            WHEN SAME_OLD_NEW_VALUE THEN
                DBMS_OUTPUT.PUT_LINE('OLD VALUE AND PROVIDED VALUE ARE SAME');
    END;

    PROCEDURE UPDATE_IS_LOCKED
    (
        P_ACCOUNT_ID ACCOUNT.ACCOUNT_ID%TYPE,
        P_IS_LOCKED ACCOUNT.IS_LOCKED%TYPE
    )
    IS
        NULL_ACCOUNT_ID EXCEPTION;
        NULL_IS_LOCKED EXCEPTION;
        NO_ACCOUNT_EXISTS EXCEPTION;
        NO_IS_LOCKED EXCEPTION;
        SAME_OLD_NEW_VALUE EXCEPTION;
        V_IS_LOCKED ACCOUNT.IS_LOCKED%TYPE;
        BEFORE_IS_LOCKED ACCOUNT.IS_LOCKED%TYPE;
    BEGIN    

        IF P_ACCOUNT_ID IS NULL THEN
            RAISE NULL_ACCOUNT_ID;
        END IF;

        IF P_IS_LOCKED IS NULL THEN
            RAISE  NULL_IS_LOCKED;
        END IF;

        IF ACCOUNT_PKG.CHECK_ACCOUNT_ID_EXISTS(P_ACCOUNT_ID) = FALSE THEN
            RAISE NO_ACCOUNT_EXISTS;
        END IF; 

        V_IS_LOCKED := UPPER(P_IS_LOCKED);

        IF V_IS_LOCKED NOT IN ('Y', 'N') THEN
            RAISE NO_IS_LOCKED;
        END IF;        

        SELECT IS_LOCKED INTO BEFORE_IS_LOCKED FROM ACCOUNT WHERE ACCOUNT_ID = P_ACCOUNT_ID;

        IF BEFORE_IS_LOCKED = V_IS_LOCKED THEN
            RAISE SAME_OLD_NEW_VALUE;
        END IF;

        UPDATE ACCOUNT
        SET IS_LOCKED = V_IS_LOCKED
        WHERE ACCOUNT_ID = P_ACCOUNT_ID;

        IF SQL%ROWCOUNT>0 THEN
            DBMS_OUTPUT.PUT_LINE('IS LOCKED CHANGED FOR ACCOUNT : ' || P_ACCOUNT_ID);
            DBMS_OUTPUT.PUT_LINE(RPAD('BEFORE ',10)  || ' : ' || BEFORE_IS_LOCKED );
            DBMS_OUTPUT.PUT_LINE(RPAD('AFTER ',10 ) || ' : ' || V_IS_LOCKED);
        END IF ;       

        EXCEPTION 
            WHEN  NULL_ACCOUNT_ID THEN
                DBMS_OUTPUT.PUT_LINE('ENTER PROPER ACCOUNT ID, NULL VALUES NOT ALLOWED');
            WHEN  NULL_IS_LOCKED THEN
                DBMS_OUTPUT.PUT_LINE('ENTER PROPER LOCKED TYPE, NULL VALUES NOT ALLOWED')               ;
            WHEN  NO_ACCOUNT_EXISTS THEN
                DBMS_OUTPUT.PUT_LINE('ACCOUNT DOES NOT EXISTS');
            WHEN  NO_IS_LOCKED THEN
                DBMS_OUTPUT.PUT_LINE('LOCKED SHOULD BE EITHER Y OR N. YES OR NO RESPECTIVELY');
            WHEN SAME_OLD_NEW_VALUE THEN
                DBMS_OUTPUT.PUT_LINE('OLD LOCKED TYPE AND PROVIDED LOCKED TYPE ARE SAME');
    END UPDATE_IS_LOCKED;



    PROCEDURE UPDATE_ACTIVE_STATUS
    (
        P_ACCOUNT_ID ACCOUNT.ACCOUNT_ID%TYPE,
        P_ACTIVE_STATUS ACCOUNT.ACTIVE_STATUS%TYPE
    )
    IS
        NULL_ACCOUNT_ID EXCEPTION;
        NULL_ACTIVE_STATUS EXCEPTION;
        NO_ACCOUNT_EXISTS EXCEPTION;
        NO_ACTIVE_STATUS EXCEPTION;
        SAME_OLD_NEW_VALUE EXCEPTION;
        V_ACTIVE_STATUS ACCOUNT.ACTIVE_STATUS%TYPE;
        BEFORE_ACTIVE_STATUS ACCOUNT.ACTIVE_STATUS%TYPE;
    BEGIN    

        IF P_ACCOUNT_ID IS NULL THEN
            RAISE NULL_ACCOUNT_ID;
        END IF;

        IF P_ACTIVE_STATUS IS NULL THEN
            RAISE  NULL_ACTIVE_STATUS;
        END IF;

        IF ACCOUNT_PKG.CHECK_ACCOUNT_ID_EXISTS(P_ACCOUNT_ID) = FALSE THEN
            RAISE NO_ACCOUNT_EXISTS;
        END IF; 

        V_ACTIVE_STATUS := UPPER(P_ACTIVE_STATUS);

        IF V_ACTIVE_STATUS NOT IN ('Y', 'N') THEN
            RAISE NO_ACTIVE_STATUS;
        END IF;        

        SELECT ACTIVE_STATUS INTO BEFORE_ACTIVE_STATUS FROM ACCOUNT WHERE ACCOUNT_ID = P_ACCOUNT_ID;

        IF BEFORE_ACTIVE_STATUS = V_ACTIVE_STATUS THEN
            RAISE SAME_OLD_NEW_VALUE;
        END IF;            

        UPDATE ACCOUNT
        SET ACTIVE_STATUS = V_ACTIVE_STATUS
        WHERE ACCOUNT_ID = P_ACCOUNT_ID;

        IF SQL%ROWCOUNT>0 THEN
            DBMS_OUTPUT.PUT_LINE('ACTIVE STATUS CHANGED!');
            DBMS_OUTPUT.PUT_LINE(RPAD('BEFORE ',10)  || ' : ' || BEFORE_ACTIVE_STATUS );
            DBMS_OUTPUT.PUT_LINE(RPAD('AFTER ',10 ) || ' : ' || V_ACTIVE_STATUS);
        END IF ;       

        EXCEPTION 
            WHEN  NULL_ACCOUNT_ID THEN
                DBMS_OUTPUT.PUT_LINE('ENTER PROPER ACCOUNT ID, NULL VALUES NOT ALLOWED');
            WHEN  NULL_ACTIVE_STATUS THEN
                DBMS_OUTPUT.PUT_LINE('ENTER PROPER ACTIVE STATUS, NULL VALUES NOT ALLOWED')               ;
            WHEN  NO_ACCOUNT_EXISTS THEN
                DBMS_OUTPUT.PUT_LINE('ACCOUNT DOES NOT EXISTS');
            WHEN  NO_ACTIVE_STATUS THEN
                DBMS_OUTPUT.PUT_LINE('ACTIVE STATUS SHOULD BE EITHER Y OR N. YES OR NO RESPECTIVELY');
            WHEN SAME_OLD_NEW_VALUE THEN
                DBMS_OUTPUT.PUT_LINE('OLD ACTIVE STATUS AND PROVIDED VALUE ARE SAME');
    END UPDATE_ACTIVE_STATUS;

    PROCEDURE UPDATE_PASSWORD
    (
        P_ACCOUNT_ID ACCOUNT.ACCOUNT_ID%TYPE,
        P_CURRENT_PASSWORD ACCOUNT.PASSWORD%TYPE,
        P_NEW_PASSWORD ACCOUNT.PASSWORD%TYPE
    )
    IS
        NULL_ACCOUNT_ID EXCEPTION;
        NULL_PASSWORD EXCEPTION;
        NO_ACCOUNT_EXISTS EXCEPTION;
        NO_PASSWORD EXCEPTION;
        AUTHENTICATION_FAILED EXCEPTION;
        INCORRECT_PASSWORD EXCEPTION;
        SAME_OLD_NEW_VALUE EXCEPTION;
        V_PASSWORD ACCOUNT.PASSWORD%TYPE;

    BEGIN    

        IF P_ACCOUNT_ID IS NULL THEN
            RAISE NULL_ACCOUNT_ID;
        END IF;

        IF P_CURRENT_PASSWORD IS NULL THEN
            RAISE  NULL_PASSWORD;
        END IF;

         IF P_NEW_PASSWORD IS NULL THEN
            RAISE  NULL_PASSWORD;
        END IF;

        IF ACCOUNT_PKG.CHECK_ACCOUNT_ID_EXISTS(P_ACCOUNT_ID) = FALSE THEN
            RAISE NO_ACCOUNT_EXISTS;
        END IF; 

        SELECT PASSWORD INTO V_PASSWORD FROM ACCOUNT WHERE ACCOUNT_ID = P_ACCOUNT_ID;

        IF V_PASSWORD <> P_CURRENT_PASSWORD THEN
            RAISE AUTHENTICATION_FAILED;
        END IF;  

        IF V_PASSWORD =  P_NEW_PASSWORD THEN
            RAISE  SAME_OLD_NEW_VALUE;
        END IF;    

        IF CHECK_PASSWORD(P_NEW_PASSWORD) <> 6  THEN 
            RAISE INCORRECT_PASSWORD;
        END IF;        


        UPDATE ACCOUNT
        SET PASSWORD = P_NEW_PASSWORD
        WHERE ACCOUNT_ID = P_ACCOUNT_ID;

        IF SQL%ROWCOUNT>0 THEN
            DBMS_OUTPUT.PUT_LINE('PASSWORD CHANGED!');
            DBMS_OUTPUT.PUT_LINE(RPAD('BEFORE ',10)  || ' : ' || P_CURRENT_PASSWORD );
            DBMS_OUTPUT.PUT_LINE(RPAD('AFTER ',10 ) || ' : ' || P_NEW_PASSWORD);
        END IF ;       

        EXCEPTION 
            WHEN  NULL_ACCOUNT_ID THEN
                DBMS_OUTPUT.PUT_LINE('ENTER PROPER ACCOUNT ID, NULL VALUES NOT ALLOWED');
            WHEN  NULL_PASSWORD THEN
                DBMS_OUTPUT.PUT_LINE('ENTER PASSWORD, NULL VALUES NOT ALLOWED');
            WHEN  NO_ACCOUNT_EXISTS THEN
                DBMS_OUTPUT.PUT_LINE('ACCOUNT DOES NOT EXISTS');
            WHEN INCORRECT_PASSWORD THEN
                DBMS_OUTPUT.PUT_LINE('NEW PASSWORD IS WEAK!');
            WHEN AUTHENTICATION_FAILED THEN
                DBMS_OUTPUT.PUT_LINE('ENTERED CURRENT PASSWORD IS WRONG! AUTHENTICATION FAILED');
            WHEN SAME_OLD_NEW_VALUE THEN
                DBMS_OUTPUT.PUT_LINE('OLD PASSWORD AND PROVIDED PASSWORD ARE SAME!');
    END UPDATE_PASSWORD;
        
END UTILS_ACCOUNT;
/