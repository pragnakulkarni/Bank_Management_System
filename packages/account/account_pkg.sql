create or replace PACKAGE ACCOUNT_PKG IS 

    FUNCTION CHECK_ACCOUNT_ID_EXISTS(P_ACCOUNT_NUMBER ACCOUNT.ACCOUNT_ID%TYPE) RETURN BOOLEAN;
    FUNCTION CHECK_USER_ID_EXISTS(P_USER_ID USERS.USER_ID%TYPE) RETURN BOOLEAN;
    FUNCTION GET_BALANCE_BY_ACCOUNT_ID(P_ACCOUNT_ID ACCOUNT.ACCOUNT_ID%TYPE) RETURN NUMBER;
    FUNCTION GET_PASSWORD_BY_ACCOUNT_ID(P_ACCOUNT_ID ACCOUNT.ACCOUNT_ID%TYPE) RETURN VARCHAR2;
    FUNCTION CHECK_PASSWORD(P_PASSWORD IN VARCHAR2) RETURN NUMBER;
    FUNCTION CHECK_NULLS_ADD_ACCOUNT
        (
            P_USER_ID_       ACCOUNT.USER_ID%TYPE,
            P_ACCOUNT_TYPE_   ACCOUNT.ACCOUNT_TYPE%TYPE,
            P_IFSC_CODE_      ACCOUNT.IFSC_CODE%TYPE,
            P_CURRENCY_CODE_  ACCOUNT.CURRENCY_CODE%TYPE,
            P_BALANCE_        ACCOUNT.BALANCE%TYPE,
            P_PASSWORD_       ACCOUNT.PASSWORD%TYPE
        )
        RETURN BOOLEAN;
    PROCEDURE ADD_ACCOUNT
        (
            P_USER_ID        ACCOUNT.USER_ID%TYPE,
            P_ACCOUNT_TYPE   ACCOUNT.ACCOUNT_TYPE%TYPE,
            P_IFSC_CODE      ACCOUNT.IFSC_CODE%TYPE,
            P_CURRENCY_CODE  ACCOUNT.CURRENCY_CODE%TYPE,
            P_BALANCE        ACCOUNT.BALANCE%TYPE,
            P_PASSWORD       ACCOUNT.PASSWORD%TYPE
        );
END ACCOUNT_PKG;
/