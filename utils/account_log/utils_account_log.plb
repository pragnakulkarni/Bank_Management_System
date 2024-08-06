create or replace PACKAGE BODY UTILS_ACCOUNT_LOG IS  

    PROCEDURE GET_ACCOUNTS_LOG_BY_ACCOUNT_ID(P_ACCOUNT_ID ACCOUNT_LOG.ACCOUNT_ID%TYPE)
    IS
        v_ACCOUNT_count NUMBER := 0;
        ACCOUNT_INVALID EXCEPTION;
    BEGIN
        -- Check if ACCOUNT exists
        IF ACCOUNT_PKG.CHECK_ACCOUNT_ID_EXISTS(P_ACCOUNT_ID) = FALSE THEN
            RAISE ACCOUNT_INVALID;
        END IF;
        SELECT COUNT(*) INTO v_ACCOUNT_count
        FROM ACCOUNT_LOG
        WHERE ACCOUNT_ID = P_ACCOUNT_ID;
        
        IF v_ACCOUNT_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('NO CHANGES HAVE MADE TO THE ACCOUNT ID ' || P_ACCOUNT_ID || ' TILL DATE');
            RETURN;
        END IF;

        -- Output header
        DBMS_OUTPUT.PUT_LINE
        (
            RPAD('ACCOUNT_ID', 18) ||
            RPAD('COLUMN_CHANGED', 18) ||
            RPAD('OLD_VALUE', 40) ||
            RPAD('NEW_VALUE', 40) ||
            RPAD('UPDATED_TIME', 18)
        );
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 134, '-'));

        -- Fetch and output ACCOUNT log records
        FOR I_ACCOUNT_LOG IN (SELECT * FROM ACCOUNT_LOG WHERE ACCOUNT_ID = P_ACCOUNT_ID)
        LOOP
            DBMS_OUTPUT.PUT_LINE
            (
                RPAD(I_ACCOUNT_LOG.ACCOUNT_ID, 18) ||
                RPAD(I_ACCOUNT_LOG.COLUMN_CHANGED, 18) ||
                RPAD(I_ACCOUNT_LOG.OLD_VALUE, 40) ||
                RPAD(I_ACCOUNT_LOG.NEW_VALUE, 40) ||
                RPAD(TO_CHAR(I_ACCOUNT_LOG.UPDATED_TIME, 'YYYY-MM-DD HH24:MI:SS'), 18)
            );
        END LOOP;

        EXCEPTION 
        WHEN ACCOUNT_INVALID THEN 
            DBMS_OUTPUT.PUT_LINE('ACCOUNT ID IS INVALID OR ACCOUNT DOES NOT EXIST');
    END GET_ACCOUNTS_LOG_BY_ACCOUNT_ID;


        PROCEDURE  GET_ACCOUNTS_LOG_BY_UPDATED_DATE(P_UPDATED_DATE DATE) 
        IS
            v_ACCOUNT_count NUMBER := 0;
            DATE_INVALID EXCEPTION;
        BEGIN
            
            SELECT COUNT(*) INTO v_ACCOUNT_count
            FROM ACCOUNT_LOG
            WHERE TRUNC(UPDATED_TIME) = P_UPDATED_DATE;
            
            IF P_UPDATED_DATE>SYSDATE THEN
                RAISE DATE_INVALID;
            END IF;

            IF v_ACCOUNT_count = 0 THEN
                DBMS_OUTPUT.PUT_LINE('NO CHANGES HAVE MADE TO THE ACCOUNTS ON THE SPECIFIED DATE');
                RETURN;
            END IF;

            -- Output header
            DBMS_OUTPUT.PUT_LINE
            (
                RPAD('ACCOUNT_ID', 18) ||
                RPAD('COLUMN_CHANGED', 18) ||
                RPAD('OLD_VALUE', 40) ||
                RPAD('NEW_VALUE', 40) ||
                RPAD('UPDATED_TIME', 18)
            );
            DBMS_OUTPUT.PUT_LINE(RPAD('-', 134, '-'));

            -- Fetch and output ACCOUNT log records
            FOR I_ACCOUNT_LOG IN (SELECT * FROM ACCOUNT_LOG WHERE TRUNC(UPDATED_TIME) = P_UPDATED_DATE)
            LOOP
                DBMS_OUTPUT.PUT_LINE
                (
                    RPAD(I_ACCOUNT_LOG.ACCOUNT_ID, 18) ||
                    RPAD(I_ACCOUNT_LOG.COLUMN_CHANGED, 18) ||
                    RPAD(I_ACCOUNT_LOG.OLD_VALUE, 40) ||
                    RPAD(I_ACCOUNT_LOG.NEW_VALUE, 40) ||
                    RPAD(TO_CHAR(I_ACCOUNT_LOG.UPDATED_TIME, 'YYYY-MM-DD HH24:MI:SS'), 18)
                );
            END LOOP;

            EXCEPTION 
            WHEN DATE_INVALID THEN 
                DBMS_OUTPUT.PUT_LINE('SPECIFIED DATE EXCEEDS TODAY');
            END GET_ACCOUNTS_LOG_BY_UPDATED_DATE;
        
        PROCEDURE  GET_ACCOUNTS_LOG_BY_DATE_RANGE(P_FROM_UPDATED_DATE DATE, P_TO_UPDATED_DATE DATE)
        IS
            v_ACCOUNT_count NUMBER := 0;
            FROM_DATE_EXCEEDING_SYSDATE EXCEPTION;
            TO_DATE_LESSER_THAN_FROM_DATE EXCEPTION;
        BEGIN
            
            SELECT COUNT(*) INTO v_ACCOUNT_count
            FROM ACCOUNT_LOG
            WHERE TRUNC(UPDATED_TIME) >= P_FROM_UPDATED_DATE OR TRUNC(UPDATED_TIME) <=P_TO_UPDATED_DATE ;          
            IF P_FROM_UPDATED_DATE > SYSDATE THEN
                RAISE FROM_DATE_EXCEEDING_SYSDATE;
            END IF;
            IF P_TO_UPDATED_DATE<P_FROM_UPDATED_DATE   THEN
                RAISE TO_DATE_LESSER_THAN_FROM_DATE;
            END IF;

            IF v_ACCOUNT_count = 0 THEN
                DBMS_OUTPUT.PUT_LINE('NO CHANGES HAVE MADE TO THE ACCOUNT ID ON THE DATE');
                RETURN;
            END IF;

            -- Output header
            DBMS_OUTPUT.PUT_LINE
            (
                RPAD('ACCOUNT_ID', 18) ||
                RPAD('COLUMN_CHANGED', 18) ||
                RPAD('OLD_VALUE', 40) ||
                RPAD('NEW_VALUE', 40) ||
                RPAD('UPDATED_TIME', 18)
            );
            DBMS_OUTPUT.PUT_LINE(RPAD('-', 134, '-'));

            -- Fetch and output ACCOUNT log records
            FOR I_ACCOUNT_LOG IN (SELECT * FROM ACCOUNT_LOG WHERE TRUNC(UPDATED_TIME) >= P_FROM_UPDATED_DATE OR TRUNC(UPDATED_TIME) <=P_TO_UPDATED_DATE )
            LOOP
                DBMS_OUTPUT.PUT_LINE
                (
                    RPAD(I_ACCOUNT_LOG.ACCOUNT_ID, 18) ||
                    RPAD(I_ACCOUNT_LOG.COLUMN_CHANGED, 18) ||
                    RPAD(I_ACCOUNT_LOG.OLD_VALUE, 40) ||
                    RPAD(I_ACCOUNT_LOG.NEW_VALUE, 40) ||
                    RPAD(I_ACCOUNT_LOG.UPDATED_TIME, 18)
                );
            END LOOP;

            EXCEPTION 
            WHEN FROM_DATE_EXCEEDING_SYSDATE THEN 
                DBMS_OUTPUT.PUT_LINE('SPECIFIED DATE EXCEEDS TODAY');
            WHEN TO_DATE_LESSER_THAN_FROM_DATE THEN 
                DBMS_OUTPUT.PUT_LINE('FROM_DATE EXCEEDS TO_DATE');
        END GET_ACCOUNTS_LOG_BY_DATE_RANGE;

        PROCEDURE DISPLAY_ACCOUNTS_LOG
        IS
            v_ACCOUNT_count NUMBER := 0;
            ACCOUNT_INVALID EXCEPTION;
        BEGIN
           
            SELECT COUNT(*) INTO v_ACCOUNT_count
            FROM ACCOUNT_LOG;
            
            IF v_ACCOUNT_count = 0 THEN
                DBMS_OUTPUT.PUT_LINE('NO CHANGES HAVE MADE TO THE ACCOUNTS');
                RETURN;
            END IF;

            DBMS_OUTPUT.PUT_LINE
            (
                RPAD('ACCOUNT_ID', 18) ||
                RPAD('COLUMN_CHANGED', 18) ||
                RPAD('OLD_VALUE', 40) ||
                RPAD('NEW_VALUE', 40) ||
                RPAD('UPDATED_TIME', 18)
            );
            DBMS_OUTPUT.PUT_LINE(RPAD('-', 134, '-'));

            -- Fetch and output ACCOUNT log records
            FOR I_ACCOUNT_LOG IN (SELECT * FROM ACCOUNT_LOG)
            LOOP
                DBMS_OUTPUT.PUT_LINE
                (
                    RPAD(I_ACCOUNT_LOG.ACCOUNT_ID, 18) ||
                    RPAD(I_ACCOUNT_LOG.COLUMN_CHANGED, 18) ||
                    RPAD(I_ACCOUNT_LOG.OLD_VALUE, 40) ||
                    RPAD(I_ACCOUNT_LOG.NEW_VALUE, 40) ||
                    RPAD(I_ACCOUNT_LOG.UPDATED_TIME, 18)
                );
            END LOOP;
        END DISPLAY_ACCOUNTS_LOG;

END UTILS_ACCOUNT_LOG;
/