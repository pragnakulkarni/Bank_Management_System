create or replace PACKAGE BODY ACCOUNT_PKG
IS
    FUNCTION CHECK_ACCOUNT_ID_EXISTS(P_ACCOUNT_NUMBER ACCOUNT.ACCOUNT_ID%TYPE) RETURN BOOLEAN
    IS
        V_ACCOUNT_ID_COUNT NUMBER;
    BEGIN
        SELECT COUNT(ACCOUNT_ID) INTO V_ACCOUNT_ID_COUNT FROM ACCOUNT 
        WHERE ACCOUNT_ID = P_ACCOUNT_NUMBER;
        IF V_ACCOUNT_ID_COUNT = 0 THEN
            RETURN FALSE;
        ELSE
            RETURN TRUE;
        END IF;
    END CHECK_ACCOUNT_ID_EXISTS;

    FUNCTION CHECK_USER_ID_EXISTS(P_USER_ID USERS.USER_ID%TYPE) RETURN BOOLEAN
    IS
        V_USER_ID_COUNT NUMBER;
        BEGIN
            SELECT COUNT(USER_ID) INTO V_USER_ID_COUNT FROM USERS 
            WHERE USER_ID = P_USER_ID;
            IF V_USER_ID_COUNT = 0 THEN
                RETURN FALSE;
            ELSE
                RETURN TRUE;
            END IF;
    END CHECK_USER_ID_EXISTS;


    FUNCTION GET_BALANCE_BY_ACCOUNT_ID (P_ACCOUNT_ID ACCOUNT.ACCOUNT_ID%TYPE) RETURN NUMBER 
    IS
        V_BALANCE ACCOUNT.BALANCE%TYPE;
    BEGIN
        SELECT BALANCE INTO V_BALANCE FROM ACCOUNT WHERE ACCOUNT_ID = P_ACCOUNT_ID;
        RETURN V_BALANCE;
    END GET_BALANCE_BY_ACCOUNT_ID;

    FUNCTION GET_PASSWORD_BY_ACCOUNT_ID(P_ACCOUNT_ID ACCOUNT.ACCOUNT_ID%TYPE) RETURN VARCHAR2 
    IS
        V_PASSWORD ACCOUNT.PASSWORD%TYPE;
    BEGIN
        SELECT PASSWORD INTO V_PASSWORD FROM ACCOUNT WHERE ACCOUNT_ID = P_ACCOUNT_ID;
        RETURN V_PASSWORD;
    END GET_PASSWORD_BY_ACCOUNT_ID;

    FUNCTION CHECK_PASSWORD(P_PASSWORD IN VARCHAR2) RETURN NUMBER IS
    BEGIN
        -- Check if the password length is at least 8 characters
        IF LENGTH(P_PASSWORD) < 8 THEN
            RETURN 1;
        END IF;

        -- Check if the password contains at least one uppercase letter
        IF NOT REGEXP_LIKE(P_PASSWORD, '[A-Z]') THEN
            RETURN 2;
        END IF;

        -- Check if the password contains at least one lowercase letter
        IF NOT REGEXP_LIKE(P_PASSWORD, '[a-z]') THEN
            RETURN 3;
        END IF;

        -- Check if the password contains at least one digit
        IF NOT REGEXP_LIKE(P_PASSWORD, '[0-9]') THEN
            RETURN 4;
        END IF;

        -- Check if the password contains at least one special character
        IF NOT REGEXP_LIKE(P_PASSWORD, '[!@#$%^&*(),.?":{}|<>]') THEN
            RETURN 5;
        END IF;

        -- Check if all conditions 1 to 5 are satisfie

        RETURN 6;
    END CHECK_PASSWORD;

    FUNCTION CHECK_NULLS_ADD_ACCOUNT
    (
        P_USER_ID_       ACCOUNT.USER_ID%TYPE,
        P_ACCOUNT_TYPE_   ACCOUNT.ACCOUNT_TYPE%TYPE,
        P_IFSC_CODE_      ACCOUNT.IFSC_CODE%TYPE,
        P_CURRENCY_CODE_  ACCOUNT.CURRENCY_CODE%TYPE,
        P_BALANCE_        ACCOUNT.BALANCE%TYPE,
        P_PASSWORD_       ACCOUNT.PASSWORD%TYPE
    )
    RETURN BOOLEAN
    IS
    BEGIN
        IF P_USER_ID_ IS NULL THEN
            RAISE_APPLICATION_ERROR(-20101, 'USER ID IS REQUIRED!');
            RETURN FALSE;
        END IF;

        IF P_ACCOUNT_TYPE_ IS NULL THEN
            RAISE_APPLICATION_ERROR(-20102, 'ACCOUNT TYPE IS REQUIRED!');
            RETURN FALSE;
        END IF;

        IF P_IFSC_CODE_ IS NULL THEN
            RAISE_APPLICATION_ERROR(-20103, 'IPSC CODE IS REQUIRED!');
            RETURN FALSE;
        END IF;

        IF P_CURRENCY_CODE_ IS NULL THEN
            RAISE_APPLICATION_ERROR(-20104, 'CURRENCY CODE IS REQUIRED!');
            RETURN FALSE;
        END IF;

        IF P_BALANCE_ IS NULL THEN
            RAISE_APPLICATION_ERROR(-20105, 'BALANCE IS REQUIRED!');
            RETURN FALSE;
        END IF;

        IF P_PASSWORD_ IS NULL THEN
            RAISE_APPLICATION_ERROR(-20106, 'PASSWORD IS REQUIRED!');
            RETURN FALSE;
        END IF;

        RETURN TRUE;
    END;

    PROCEDURE ADD_ACCOUNT
    (
        P_USER_ID        ACCOUNT.USER_ID%TYPE,
        P_ACCOUNT_TYPE   ACCOUNT.ACCOUNT_TYPE%TYPE,
        P_IFSC_CODE      ACCOUNT.IFSC_CODE%TYPE,
        P_CURRENCY_CODE  ACCOUNT.CURRENCY_CODE%TYPE,
        P_BALANCE        ACCOUNT.BALANCE%TYPE,
        P_PASSWORD       ACCOUNT.PASSWORD%TYPE
    ) 
    IS
        v_password_check_result NUMBER;
        V_ACCONT_ID ACCOUNT.ACCOUNT_TYPE%TYPE;
        V_CURRENCY_CODE ACCOUNT.CURRENCY_CODE%TYPE;
        CHECK_USER_ID_EXISTS EXCEPTION;
    BEGIN
        IF ACCOUNT_PKG.CHECK_USER_ID_EXISTS(P_USER_ID) =FALSE THEN
            RAISE_APPLICATION_ERROR(-20020,'USER DOES NOT EXISTS');
        END IF;

        IF ACCOUNT_PKG.CHECK_NULLS_ADD_ACCOUNT
        (
            P_USER_ID_ =>  P_USER_ID ,    
            P_ACCOUNT_TYPE_ => P_ACCOUNT_TYPE,
            P_IFSC_CODE_  =>  P_IFSC_CODE ,
            P_CURRENCY_CODE_  => P_CURRENCY_CODE,
            P_BALANCE_   =>  P_BALANCE, 
            P_PASSWORD_  =>  P_PASSWORD 
        ) = TRUE THEN


            v_password_check_result := CHECK_PASSWORD(P_PASSWORD);

            IF v_password_check_result = 1 THEN
                RAISE_APPLICATION_ERROR(-20500,'LENGTH OF THE PASSWORD IS MISMATCHED');
            END IF;

            IF  v_password_check_result BETWEEN 2 AND 5 THEN
                RAISE_APPLICATION_ERROR(-20501,'ATLEAST ONE CAPITAL OR ONE SPECIAL CHAR OR ONE NUMBER IS REQUIRED');
            END IF;

            IF BANK_PKG.VALID_IFSC(P_IFSC_CODE)=FALSE  THEN
                RAISE_APPLICATION_ERROR(-20013,'INVALID IFSC FORMAT!');
            END IF;

            IF BANK_PKG.CHECK_IFSC_EXISTS(P_IFSC_CODE) = TRUE THEN
                RAISE_APPLICATION_ERROR(-20014, 'IFSC CODE NOT EXISTS!');
            END IF;
             
            IF P_ACCOUNT_TYPE NOT IN ('SAVINGS', 'CHECKING') THEN
                RAISE_APPLICATION_ERROR(-20015, ' ACCOUNT TYPE SHOULD BE EITEHR SAVINGS OR CHECKING');
            END IF;

            V_CURRENCY_CODE := UPPER(P_CURRENCY_CODE);
            IF CURRENCY_PKG.CHECK_CURRENCY_CODE_EXISTS(P_CURRENCY_CODE=>V_CURRENCY_CODE) = TRUE THEN 
                RAISE_APPLICATION_ERROR(-20016, 'CURRENCY CODE NOT EXISTS!');
            END IF;                


            INSERT INTO ACCOUNT 
            (
                ACCOUNT_ID,
                USER_ID,
                ACCOUNT_TYPE,
                IFSC_CODE,
                CURRENCY_CODE,
                BALANCE,
                PASSWORD
            ) 
            VALUES 
            (
                'ACC'||TO_CHAR(ACCOUNT_ID_SEQ.NEXTVAL),
                UPPER(P_USER_ID),
                UPPER(P_ACCOUNT_TYPE),
                UPPER(P_IFSC_CODE),
                UPPER(P_CURRENCY_CODE),
                P_BALANCE,
                P_PASSWORD
            );

        END IF;
        

    END ADD_ACCOUNT;
    
END ACCOUNT_PKG;
/