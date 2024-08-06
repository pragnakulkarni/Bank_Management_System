create or replace PACKAGE SERVICE_PKG 
IS
    PROCEDURE DEPOSIT_MONEY_BY_ACCOUNT_ID
    (
        P_ACCOUNT_ID ACCOUNT.ACCOUNT_ID%TYPE,
        P_DEPOSIT_AMOUNT ACCOUNT.BALANCE%TYPE,
        P_PASSWORD  ACCOUNT.PASSWORD%TYPE
    );

    PROCEDURE WITHDRAWAL_MONEY_BY_ACCOUNT_ID
    (
        P_ACCOUNT_ID ACCOUNT.ACCOUNT_ID%TYPE,
        P_WITHDRAW_AMOUNT ACCOUNT.BALANCE%TYPE,
        P_PASSWORD  ACCOUNT.PASSWORD%TYPE
    );
    PROCEDURE MONEY_TRANSFER
    (
        P_FROM_ACCOUNT_ID ACCOUNT.ACCOUNT_ID%TYPE,
        P_TO_ACCOUNT_ID  ACCOUNT.ACCOUNT_ID%TYPE,
        P_AMOUNT ACCOUNT.BALANCE%TYPE,
        P_PASSWORD  ACCOUNT.PASSWORD%TYPE
    );
    PROCEDURE SCHEDULED_MONEY_TRANSFER;
    PROCEDURE RECURRING_MONEY_TRANSFER;
END SERVICE_PKG;
/