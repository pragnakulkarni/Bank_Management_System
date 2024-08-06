create or replace PACKAGE BODY UTILS_TRANSACTIONS IS

    -- Procedure to load transactions into the collection
    PROCEDURE LOADER_TRANSACTIONS IS
    BEGIN
        FOR I IN TRANSACTION_CURSOR LOOP
            V_TRANSACTIONS_COLLECTION(I.TRANSACTION_ID) := I;
        END LOOP;
    END LOADER_TRANSACTIONS;

    -- Procedure to display all transactions
    PROCEDURE DISPLAY_TRANSACTIONS IS
        V_KEY VARCHAR2(40);
    BEGIN
        LOADER_TRANSACTIONS;
        DBMS_OUTPUT.PUT_LINE(
            RPAD('TRANSACTION_ID', 25) || 
            RPAD('FROM_ACCOUNT_ID', 20) || 
            RPAD('TO_ACCOUNT_ID', 15) || 
            RPAD('AMOUNT', 15) || 
            RPAD('TRANSACTION_TIMESTAMP', 40) || 
            RPAD('TRANSACTION_TYPE', 20) || 
            RPAD('STATUS', 10)
        );
        V_KEY := V_TRANSACTIONS_COLLECTION.FIRST;

        WHILE V_KEY IS NOT NULL LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_ID, 25) || 
                RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_FROM_ACCOUNT_ID,' '), 20) ||
                RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_TO_ACCOUNT_ID, ' '), 15) ||
                RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_AMOUNT, 15) ||
                RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TIMESTAMP, 40) ||
                RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TYPE, 20) ||             
                RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_STATUS, 10)
            );
            V_KEY := V_TRANSACTIONS_COLLECTION.NEXT(V_KEY);
        END LOOP;
    END DISPLAY_TRANSACTIONS;

    -- Procedure to get details by transaction ID
    PROCEDURE GET_DETAILS_BY_TRANSACTION_ID(P_TRANSACTION_ID TRANSACTIONS.TRANSACTION_ID%TYPE) IS
    V_KEY VARCHAR2(40);
    TRANSACTION_FOUND BOOLEAN := FALSE; 
    BEGIN
        LOADER_TRANSACTIONS;
        DBMS_OUTPUT.PUT_LINE(
            RPAD('TRANSACTION_ID', 25) || 
            RPAD('FROM_ACCOUNT_ID', 20) || 
            RPAD('TO_ACCOUNT_ID', 15) || 
            RPAD('AMOUNT', 15) || 
            RPAD('TRANSACTION_TIMESTAMP', 40) || 
            RPAD('TRANSACTION_TYPE', 20) || 
            RPAD('STATUS', 10)
        );
        
        V_KEY := V_TRANSACTIONS_COLLECTION.FIRST;
        WHILE V_KEY IS NOT NULL LOOP
            IF V_KEY = P_TRANSACTION_ID THEN
                TRANSACTION_FOUND := TRUE; 
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_ID, 25) || 
                    RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_FROM_ACCOUNT_ID,' '), 20) ||
                    RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_TO_ACCOUNT_ID, ' '), 15) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_AMOUNT, 15) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TIMESTAMP, 40) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TYPE, 20) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_STATUS, 10)
                );
            END IF;
            V_KEY := V_TRANSACTIONS_COLLECTION.NEXT(V_KEY);
        END LOOP;

        IF NOT TRANSACTION_FOUND THEN
            DBMS_OUTPUT.PUT_LINE(P_TRANSACTION_ID || ' IS NOT LISTED');
        END IF;

    END GET_DETAILS_BY_TRANSACTION_ID;

    -- Procedure to get successful transactions
    PROCEDURE GET_SUCCESSFUL_TRANSACTIONS IS
    V_KEY VARCHAR2(40);
    SUCCESSFUL_FOUND BOOLEAN := FALSE; 
    BEGIN
        LOADER_TRANSACTIONS;
        DBMS_OUTPUT.PUT_LINE(
            RPAD('TRANSACTION_ID', 25) || 
            RPAD('FROM_ACCOUNT_ID', 20) || 
            RPAD('TO_ACCOUNT_ID', 15) || 
            RPAD('AMOUNT', 15) || 
            RPAD('TRANSACTION_TIMESTAMP', 40) || 
            RPAD('TRANSACTION_TYPE', 20) || 
            RPAD('STATUS', 10)
        );
        
        V_KEY := V_TRANSACTIONS_COLLECTION.FIRST;
        WHILE V_KEY IS NOT NULL LOOP
            IF V_TRANSACTIONS_COLLECTION(V_KEY).R_STATUS = 'Y' THEN
                SUCCESSFUL_FOUND := TRUE; 
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_ID, 25) || 
                    RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_FROM_ACCOUNT_ID,' '), 20) ||
                    RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_TO_ACCOUNT_ID, ' '), 15) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_AMOUNT, 15) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TIMESTAMP, 40) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TYPE, 20) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_STATUS, 10)
                );
            END IF;
            V_KEY := V_TRANSACTIONS_COLLECTION.NEXT(V_KEY);
        END LOOP;

        
        IF NOT SUCCESSFUL_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('NO SUCCESSFUL TRANSACTIONS ARE LISTED');
            
        END IF;

    END GET_SUCCESSFUL_TRANSACTIONS;

    -- Procedure to get unsuccessful transactions
    PROCEDURE GET_UNSUCCESSFUL_TRANSACTIONS IS
    V_KEY VARCHAR2(40);
    SUCCESSFUL_FOUND BOOLEAN := FALSE; 
    BEGIN
    LOADER_TRANSACTIONS;
    DBMS_OUTPUT.PUT_LINE(
        RPAD('TRANSACTION_ID', 25) || 
        RPAD('FROM_ACCOUNT_ID', 20) || 
        RPAD('TO_ACCOUNT_ID', 15) || 
        RPAD('AMOUNT', 15) || 
        RPAD('TRANSACTION_TIMESTAMP', 40) || 
        RPAD('TRANSACTION_TYPE', 20) || 
        RPAD('STATUS', 10)
    );
    
    V_KEY := V_TRANSACTIONS_COLLECTION.FIRST;
    WHILE V_KEY IS NOT NULL LOOP
        IF V_TRANSACTIONS_COLLECTION(V_KEY).R_STATUS = 'N' THEN
            SUCCESSFUL_FOUND := TRUE; 
            DBMS_OUTPUT.PUT_LINE(
                RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_ID, 25) || 
                RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_FROM_ACCOUNT_ID,' '), 20) ||
                RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_TO_ACCOUNT_ID, ' '), 15) ||
                RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_AMOUNT, 15) ||
                RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TIMESTAMP, 40) ||
                RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TYPE, 20) ||
                RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_STATUS, 10)
            );
        END IF;
        V_KEY := V_TRANSACTIONS_COLLECTION.NEXT(V_KEY);
    END LOOP;

    
    IF NOT SUCCESSFUL_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('NO SUCCESSFUL TRANSACTIONS ARE LISTED');
        
    END IF;

    END GET_UNSUCCESSFUL_TRANSACTIONS;

    --procedure to get transaction status by transaction id
    PROCEDURE GET_TRANSACTION_STATUS_BY_TRANSACTION_ID(P_TRANSACTION_ID TRANSACTIONS.TRANSACTION_ID%TYPE) IS
    V_KEY VARCHAR2(40);
    V_TRANSACTION_FOUND BOOLEAN := FALSE;
    BEGIN
        LOADER_TRANSACTIONS;
        DBMS_OUTPUT.PUT_LINE(
            RPAD('TRANSACTION_ID', 25) || 
            RPAD('FROM_ACCOUNT_ID', 20) || 
            RPAD('TO_ACCOUNT_ID', 15) || 
            RPAD('AMOUNT', 15) || 
            RPAD('TRANSACTION_TIMESTAMP', 40) || 
            RPAD('TRANSACTION_TYPE', 20) || 
            RPAD('STATUS', 10)
        );

        V_KEY := V_TRANSACTIONS_COLLECTION.FIRST;
        WHILE V_KEY IS NOT NULL LOOP
            IF V_KEY = P_TRANSACTION_ID THEN
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_ID, 25) || 
                    RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_FROM_ACCOUNT_ID,' '), 20) ||
                    RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_TO_ACCOUNT_ID, ' '), 15) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_AMOUNT, 15) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TIMESTAMP, 40) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TYPE, 20) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_STATUS, 10)
                );
                V_TRANSACTION_FOUND := TRUE;
            END IF;
            V_KEY := V_TRANSACTIONS_COLLECTION.NEXT(V_KEY);
        END LOOP;

        IF NOT V_TRANSACTION_FOUND THEN
            DBMS_OUTPUT.PUT_LINE(P_TRANSACTION_ID || ' IS NOT LISTED');
        END IF;

    END GET_TRANSACTION_STATUS_BY_TRANSACTION_ID;

    --procedure to get transaction details by date        
    PROCEDURE GET_TRANSACTIONS_BY_DATE(P_DATE VARCHAR2) IS
        V_KEY VARCHAR2(40);
        V_TRANSACTION_FOUND BOOLEAN := FALSE;
        V_DATE TIMESTAMP; 
    BEGIN
        LOADER_TRANSACTIONS;

        DBMS_OUTPUT.PUT_LINE(
            RPAD('TRANSACTION_ID', 25) || 
            RPAD('FROM_ACCOUNT_ID', 20) || 
            RPAD('TO_ACCOUNT_ID', 15) || 
            RPAD('AMOUNT', 15) || 
            RPAD('TRANSACTION_TIMESTAMP', 40) || 
            RPAD('TRANSACTION_TYPE', 20) || 
            RPAD('STATUS', 10)
        );


        V_DATE := TO_TIMESTAMP(P_DATE, 'MM-DD-YYYY');

        V_KEY := V_TRANSACTIONS_COLLECTION.FIRST;

        WHILE V_KEY IS NOT NULL LOOP

            IF TRUNC(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TIMESTAMP) = TRUNC(V_DATE) THEN
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_ID, 25) || 
                    RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_FROM_ACCOUNT_ID,' '), 20) ||
                    RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_TO_ACCOUNT_ID, ' '), 15) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_AMOUNT, 15) ||
                    RPAD(TO_CHAR(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TIMESTAMP, 'MM-DD-YYYY HH24:MI:SS.FF6'), 40) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TYPE, 20) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_STATUS, 10)
                );
                V_TRANSACTION_FOUND := TRUE;
            END IF;
            V_KEY := V_TRANSACTIONS_COLLECTION.NEXT(V_KEY);
        END LOOP;

        IF NOT V_TRANSACTION_FOUND THEN
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(V_DATE, 'YYYY-MM-DD') || ' TRANSACTIONS ARE NOT LISTED');
        END IF;
    END GET_TRANSACTIONS_BY_DATE;

    --procedure to display all transactions by account id
    PROCEDURE GET_TRANSACTION_BY_ACCOUNT_ID(P_FROM_ACCOUNT_ID TRANSACTIONS.FROM_ACCOUNT_ID%TYPE) IS
        V_KEY VARCHAR2(40);
        V_TRANSACTION_FOUND BOOLEAN := FALSE; 
    BEGIN
        LOADER_TRANSACTIONS;

        DBMS_OUTPUT.PUT_LINE(
            RPAD('TRANSACTION_ID', 25) || 
            RPAD('FROM_ACCOUNT_ID', 20) || 
            RPAD('TO_ACCOUNT_ID', 15) || 
            RPAD('AMOUNT', 15) || 
            RPAD('TRANSACTION_TIMESTAMP', 40) || 
            RPAD('TRANSACTION_TYPE', 20) || 
            RPAD('STATUS', 10)
        );

        V_KEY := V_TRANSACTIONS_COLLECTION.FIRST;

        WHILE V_KEY IS NOT NULL LOOP
            IF V_TRANSACTIONS_COLLECTION(V_KEY).R_FROM_ACCOUNT_ID = P_FROM_ACCOUNT_ID THEN
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_ID, 25) || 
                    RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_FROM_ACCOUNT_ID,' '), 20) ||
                    RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_TO_ACCOUNT_ID, ' '), 15) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_AMOUNT, 15) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TIMESTAMP, 40) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TYPE, 20) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_STATUS, 10)
                );
                V_TRANSACTION_FOUND := TRUE; 
            END IF;
            V_KEY := V_TRANSACTIONS_COLLECTION.NEXT(V_KEY);
        END LOOP;

        
        IF NOT V_TRANSACTION_FOUND THEN
            DBMS_OUTPUT.PUT_LINE(P_FROM_ACCOUNT_ID || ' TRANSACTIONS ARE NOT LISTED');
        END IF;
    END GET_TRANSACTION_BY_ACCOUNT_ID;


    --procedure to display deposits by account id
    PROCEDURE GET_DEPOSIT_BY_ACCOUNT_ID (P_TO_ACCOUNT_ID TRANSACTIONS.TO_ACCOUNT_ID%TYPE) IS
    V_KEY VARCHAR2(40);
    V_DEPOSIT_FOUND BOOLEAN := FALSE; 
    BEGIN
        LOADER_TRANSACTIONS;

        DBMS_OUTPUT.PUT_LINE(
            RPAD('TRANSACTION_ID', 25) || 
            RPAD('FROM_ACCOUNT_ID', 20) || 
            RPAD('TO_ACCOUNT_ID', 15) || 
            RPAD('AMOUNT', 15) || 
            RPAD('TRANSACTION_TIMESTAMP', 40) || 
            RPAD('TRANSACTION_TYPE', 20) || 
            RPAD('STATUS', 10)
        );

        V_KEY := V_TRANSACTIONS_COLLECTION.FIRST;

        WHILE V_KEY IS NOT NULL LOOP
            IF V_TRANSACTIONS_COLLECTION(V_KEY).R_TO_ACCOUNT_ID = P_TO_ACCOUNT_ID AND V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TYPE = 'DEPOSIT' THEN
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_ID, 25) || 
                    RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_FROM_ACCOUNT_ID,' '), 20) ||
                    RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_TO_ACCOUNT_ID, ' '), 15) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_AMOUNT, 15) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TIMESTAMP, 40) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TYPE, 20) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_STATUS, 10)
                );
                V_DEPOSIT_FOUND := TRUE; 
            END IF;
            V_KEY := V_TRANSACTIONS_COLLECTION.NEXT(V_KEY);
        END LOOP;

        IF NOT V_DEPOSIT_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No deposits found for account ' || P_TO_ACCOUNT_ID);
        END IF;
    END GET_DEPOSIT_BY_ACCOUNT_ID;

    --procedure to display withdrawals by account id
    PROCEDURE GET_WITHDRAWALS_BY_ACCOUNT_ID (P_FROM_ACCOUNT_ID TRANSACTIONS.FROM_ACCOUNT_ID%TYPE) IS
    V_KEY VARCHAR2(40);
    V_WITHDRAWALS_FOUND BOOLEAN := FALSE; 
    BEGIN
        LOADER_TRANSACTIONS;

        DBMS_OUTPUT.PUT_LINE(
            RPAD('TRANSACTION_ID', 25) || 
            RPAD('FROM_ACCOUNT_ID', 20) || 
            RPAD('TO_ACCOUNT_ID', 15) || 
            RPAD('AMOUNT', 15) || 
            RPAD('TRANSACTION_TIMESTAMP', 40) || 
            RPAD('TRANSACTION_TYPE', 20) || 
            RPAD('STATUS', 10)
        );

        V_KEY := V_TRANSACTIONS_COLLECTION.FIRST;

        WHILE V_KEY IS NOT NULL LOOP
            IF V_TRANSACTIONS_COLLECTION(V_KEY).R_FROM_ACCOUNT_ID = P_FROM_ACCOUNT_ID AND V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TYPE = 'WITHDRAWAL' THEN
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_ID, 25) || 
                    RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_FROM_ACCOUNT_ID,' '), 20) ||
                    RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_TO_ACCOUNT_ID, ' '), 15) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_AMOUNT, 15) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TIMESTAMP, 40) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TYPE, 20) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_STATUS, 10)
                );
                V_WITHDRAWALS_FOUND := TRUE; 
            END IF;
            V_KEY := V_TRANSACTIONS_COLLECTION.NEXT(V_KEY);
        END LOOP;

        
        IF NOT V_WITHDRAWALS_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No withdrawals found for account ' || P_FROM_ACCOUNT_ID);
        END IF;
    END GET_WITHDRAWALS_BY_ACCOUNT_ID;

    --procedure to get transfer details by account id
    PROCEDURE GET_TRANSFER_BY_ACCOUNT_ID (P_FROM_ACCOUNT_ID TRANSACTIONS.FROM_ACCOUNT_ID%TYPE) IS
    V_KEY VARCHAR2(40);
    V_TRANSFER_FOUND BOOLEAN := FALSE; 
    BEGIN
        LOADER_TRANSACTIONS;

        DBMS_OUTPUT.PUT_LINE(
            RPAD('TRANSACTION_ID', 25) || 
            RPAD('FROM_ACCOUNT_ID', 20) || 
            RPAD('TO_ACCOUNT_ID', 15) || 
            RPAD('AMOUNT', 15) || 
            RPAD('TRANSACTION_TIMESTAMP', 40) || 
            RPAD('TRANSACTION_TYPE', 20) || 
            RPAD('STATUS', 10)
        );

        V_KEY := V_TRANSACTIONS_COLLECTION.FIRST;

        WHILE V_KEY IS NOT NULL LOOP
            IF V_TRANSACTIONS_COLLECTION(V_KEY).R_FROM_ACCOUNT_ID = P_FROM_ACCOUNT_ID AND V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TYPE = 'TRANSFER' THEN
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_ID, 25) || 
                    RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_FROM_ACCOUNT_ID,' '), 20) ||
                    RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_TO_ACCOUNT_ID, ' '), 15) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_AMOUNT, 15) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TIMESTAMP, 40) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TYPE, 20) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_STATUS, 10)
                );
                V_TRANSFER_FOUND := TRUE; 
            END IF;
            V_KEY := V_TRANSACTIONS_COLLECTION.NEXT(V_KEY);
        END LOOP;

        
        IF NOT V_TRANSFER_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No transfers found for account ' || P_FROM_ACCOUNT_ID);
        END IF;
    END GET_TRANSFER_BY_ACCOUNT_ID;

    --procedure to display all deposits
    PROCEDURE DISPLAY_DEPOSITS IS
    V_KEY VARCHAR2(40);
    V_DEPOSIT_FOUND BOOLEAN := FALSE; 
    BEGIN
        LOADER_TRANSACTIONS;

        DBMS_OUTPUT.PUT_LINE(
            RPAD('TRANSACTION_ID', 25) || 
            RPAD('FROM_ACCOUNT_ID', 20) || 
            RPAD('TO_ACCOUNT_ID', 15) || 
            RPAD('AMOUNT', 15) || 
            RPAD('TRANSACTION_TIMESTAMP', 40) || 
            RPAD('TRANSACTION_TYPE', 20) || 
            RPAD('STATUS', 10)
        );

        V_KEY := V_TRANSACTIONS_COLLECTION.FIRST;

        WHILE V_KEY IS NOT NULL LOOP
            IF V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TYPE = 'DEPOSIT' THEN
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_ID, 25) || 
                    RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_FROM_ACCOUNT_ID,' '), 20) ||
                    RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_TO_ACCOUNT_ID, ' '), 15) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_AMOUNT, 15) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TIMESTAMP, 40) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TYPE, 20) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_STATUS, 10)
                );
                V_DEPOSIT_FOUND := TRUE; 
            END IF;
            V_KEY := V_TRANSACTIONS_COLLECTION.NEXT(V_KEY);
        END LOOP;

        
        IF NOT V_DEPOSIT_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No deposits found.');
        END IF;
    END DISPLAY_DEPOSITS;

    --procedure to display all transfers
    PROCEDURE DISPLAY_TRANSFER IS
    V_KEY VARCHAR2(40);
    V_TRANSFER_FOUND BOOLEAN := FALSE; 
    BEGIN
        LOADER_TRANSACTIONS;

        DBMS_OUTPUT.PUT_LINE(
            RPAD('TRANSACTION_ID', 25) || 
            RPAD('FROM_ACCOUNT_ID', 20) || 
            RPAD('TO_ACCOUNT_ID', 15) || 
            RPAD('AMOUNT', 15) || 
            RPAD('TRANSACTION_TIMESTAMP', 40) || 
            RPAD('TRANSACTION_TYPE', 20) || 
            RPAD('STATUS', 10)
        );

        V_KEY := V_TRANSACTIONS_COLLECTION.FIRST;

        WHILE V_KEY IS NOT NULL LOOP
            IF V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TYPE = 'TRANSFER' THEN
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_ID, 25) || 
                    RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_FROM_ACCOUNT_ID,' '), 20) ||
                    RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_TO_ACCOUNT_ID, ' '), 15) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_AMOUNT, 15) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TIMESTAMP, 40) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TYPE, 20) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_STATUS, 10)
                );
                V_TRANSFER_FOUND := TRUE; 
            END IF;
            V_KEY := V_TRANSACTIONS_COLLECTION.NEXT(V_KEY);
        END LOOP;


        IF NOT V_TRANSFER_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No transfers found.');
        END IF;
    END DISPLAY_TRANSFER;

    -- procedure to display all withdrawals
    PROCEDURE DISPLAY_WITHDRAWAL IS              
    V_KEY VARCHAR2(40);
    V_WITHDRAWAL_FOUND BOOLEAN := FALSE; 
    BEGIN
        LOADER_TRANSACTIONS;
        
        DBMS_OUTPUT.PUT_LINE(
            RPAD('TRANSACTION_ID', 25) || 
            RPAD('FROM_ACCOUNT_ID', 20) || 
            RPAD('TO_ACCOUNT_ID', 15) || 
            RPAD('AMOUNT', 15) || 
            RPAD('TRANSACTION_TIMESTAMP', 40) || 
            RPAD('TRANSACTION_TYPE', 20) || 
            RPAD('STATUS', 10)
        );

        V_KEY := V_TRANSACTIONS_COLLECTION.FIRST;

        WHILE V_KEY IS NOT NULL LOOP
            IF V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TYPE = 'WITHDRAWAL' THEN
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_ID, 25) || 
                    RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_FROM_ACCOUNT_ID,' '), 20) ||
                    RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_TO_ACCOUNT_ID, ' '), 15) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_AMOUNT, 15) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TIMESTAMP, 40) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TYPE, 20) ||
                    RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_STATUS, 10)
                );
                V_WITHDRAWAL_FOUND := TRUE; 
            END IF;
            V_KEY := V_TRANSACTIONS_COLLECTION.NEXT(V_KEY);
        END LOOP;

        
        IF NOT V_WITHDRAWAL_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No withdrawals found.');
        END IF;

    END DISPLAY_WITHDRAWAL;

    PROCEDURE GET_TRANSACTION_HISTORY_BY_ACCOUNT_ID_WITHIN_SPECIFIC_DATES(
    P_FROM_ACCOUNT_ID IN TRANSACTIONS.FROM_ACCOUNT_ID%TYPE,
    FROM_DATE IN DATE,
    TILL_DATE IN DATE
) IS
    V_KEY VARCHAR2(40);
    TILL_DATE_EXCEEDING EXCEPTION;
    NULL_FROM_DATE_EXCEPTION EXCEPTION;
    NULL_TILL_DATE_EXCEPTION EXCEPTION;
    CREATION_DATE TIMESTAMP;
    CREATION_DATE_IS_LESSER EXCEPTION;
BEGIN
    -- Retrieve creation date of the account
    SELECT CREATED_AT INTO CREATION_DATE FROM ACCOUNT WHERE ACCOUNT_ID = P_FROM_ACCOUNT_ID;

    -- Check validity of input dates
    IF TILL_DATE > SYSDATE THEN
        RAISE TILL_DATE_EXCEEDING;
    END IF;

    IF CREATION_DATE > FROM_DATE THEN
        RAISE CREATION_DATE_IS_LESSER;
    END IF;

    IF FROM_DATE IS NULL THEN 
        RAISE NULL_FROM_DATE_EXCEPTION;
    END IF;

    IF TILL_DATE IS NULL THEN 
        RAISE NULL_TILL_DATE_EXCEPTION;
    END IF;

    LOADER_TRANSACTIONS; -- Assuming this loads transactions into V_TRANSACTIONS_COLLECTION

    DBMS_OUTPUT.PUT_LINE(
        RPAD('TRANSACTION_ID', 25) || 
        RPAD('FROM_ACCOUNT_ID', 20) || 
        RPAD('TO_ACCOUNT_ID', 15) || 
        RPAD('AMOUNT', 15) || 
        RPAD('TRANSACTION_TIMESTAMP', 40) || 
        RPAD('TRANSACTION_TYPE', 20) || 
        RPAD('STATUS', 10)
    );

    V_KEY := V_TRANSACTIONS_COLLECTION.FIRST();

    WHILE V_KEY IS NOT NULL LOOP
        -- Check if transaction matches account ID and falls within truncated date range
        IF V_TRANSACTIONS_COLLECTION(V_KEY).R_FROM_ACCOUNT_ID = P_FROM_ACCOUNT_ID AND
           TRUNC(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TIMESTAMP) BETWEEN TRUNC(FROM_DATE) AND TRUNC(TILL_DATE) THEN
            DBMS_OUTPUT.PUT_LINE(
                RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_ID, 25) || 
                RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_FROM_ACCOUNT_ID, 20) ||
                RPAD(NVL(V_TRANSACTIONS_COLLECTION(V_KEY).R_TO_ACCOUNT_ID, ' '), 15) ||
                RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_AMOUNT, 15) ||
                RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TIMESTAMP, 40) ||
                RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_TRANSACTION_TYPE, 20) ||
                RPAD(V_TRANSACTIONS_COLLECTION(V_KEY).R_STATUS, 10)
            );
        END IF;
        V_KEY := V_TRANSACTIONS_COLLECTION.NEXT(V_KEY);
    END LOOP;

EXCEPTION
    WHEN TILL_DATE_EXCEEDING THEN
        DBMS_OUTPUT.PUT_LINE('The end date is exceeding.');
    WHEN NULL_FROM_DATE_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('The from date is NULL.');
    WHEN NULL_TILL_DATE_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('The till date is NULL.');
    WHEN CREATION_DATE_IS_LESSER THEN
        DBMS_OUTPUT.PUT_LINE('Provide a from date that is greater than the account creation date.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END GET_TRANSACTION_HISTORY_BY_ACCOUNT_ID_WITHIN_SPECIFIC_DATES;

END UTILS_TRANSACTIONS;
/