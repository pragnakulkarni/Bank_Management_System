create or replace PACKAGE BODY UTILS_USERS_LOG IS  

    PROCEDURE GET_USERS_LOG_BY_USER_ID(P_USER_ID USERS_LOG.USER_ID%TYPE)
    IS
        v_user_count NUMBER := 0;
        USER_INVALID EXCEPTION;
    BEGIN
        -- Check if user exists
        IF UTILS_USERS.CHECK_USER_ID_EXISTS(P_USER_ID) = FALSE THEN
            RAISE USER_INVALID;
        END IF;
        SELECT COUNT(*) INTO v_user_count
        FROM USERS_LOG
        WHERE USER_ID = P_USER_ID;
        
        IF v_user_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('NO CHANGES HAVE MADE TO THE USER ID ' || P_USER_ID || ' TILL DATE');
            RETURN;
        END IF;

        -- Output header
        DBMS_OUTPUT.PUT_LINE
        (
            RPAD('USER_ID', 18) ||
            RPAD('COLUMN_CHANGED', 18) ||
            RPAD('OLD_VALUE', 40) ||
            RPAD('NEW_VALUE', 40) ||
            RPAD('UPDATED_TIME', 18)
        );
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 134, '-'));

        -- Fetch and output user log records
        FOR I_USER_LOG IN (SELECT * FROM USERS_LOG WHERE USER_ID = P_USER_ID)
        LOOP
            DBMS_OUTPUT.PUT_LINE
            (
                RPAD(I_USER_LOG.USER_ID, 18) ||
                RPAD(I_USER_LOG.COLUMN_CHANGED, 18) ||
                RPAD(I_USER_LOG.OLD_VALUE, 40) ||
                RPAD(I_USER_LOG.NEW_VALUE, 40) ||
                RPAD(TO_CHAR(I_USER_LOG.UPDATED_TIME, 'YYYY-MM-DD HH24:MI:SS'), 18)
            );
        END LOOP;

        EXCEPTION 
        WHEN USER_INVALID THEN 
            DBMS_OUTPUT.PUT_LINE('USER ID IS INVALID OR USER DOES NOT EXIST');
    END GET_USERS_LOG_BY_USER_ID;


        PROCEDURE  GET_USERS_LOG_BY_UPDATED_DATE(P_UPDATED_DATE DATE) 
        IS
            v_user_count NUMBER := 0;
            DATE_INVALID EXCEPTION;
        BEGIN
            
            SELECT COUNT(*) INTO v_user_count
            FROM USERS_LOG
            WHERE TRUNC(UPDATED_TIME) = P_UPDATED_DATE;
            
            IF P_UPDATED_DATE>SYSDATE THEN
                RAISE DATE_INVALID;
            END IF;

            IF v_user_count = 0 THEN
                DBMS_OUTPUT.PUT_LINE('NO CHANGES HAVE MADE TO THE USER ID ON THE DATE');
                RETURN;
            END IF;

            -- Output header
            DBMS_OUTPUT.PUT_LINE
            (
                RPAD('USER_ID', 18) ||
                RPAD('COLUMN_CHANGED', 18) ||
                RPAD('OLD_VALUE', 40) ||
                RPAD('NEW_VALUE', 40) ||
                RPAD('UPDATED_TIME', 18)
            );
            DBMS_OUTPUT.PUT_LINE(RPAD('-', 134, '-'));

            -- Fetch and output user log records
            FOR I_USER_LOG IN (SELECT * FROM USERS_LOG WHERE TRUNC(UPDATED_TIME) = P_UPDATED_DATE)
            LOOP
                DBMS_OUTPUT.PUT_LINE
                (
                    RPAD(I_USER_LOG.USER_ID, 18) ||
                    RPAD(I_USER_LOG.COLUMN_CHANGED, 18) ||
                    RPAD(I_USER_LOG.OLD_VALUE, 40) ||
                    RPAD(I_USER_LOG.NEW_VALUE, 40) ||
                    RPAD(TO_CHAR(I_USER_LOG.UPDATED_TIME, 'YYYY-MM-DD HH24:MI:SS'), 18)
                );
            END LOOP;

            EXCEPTION 
            WHEN DATE_INVALID THEN 
                DBMS_OUTPUT.PUT_LINE('SPECIFIED DATE EXCEEDS TODAY');
            END GET_USERS_LOG_BY_UPDATED_DATE;
        
        PROCEDURE  GET_USERS_LOG_BY_DATE_RANGE(P_FROM_UPDATED_DATE DATE, P_TO_UPDATED_DATE DATE)
        IS
            v_user_count NUMBER := 0;
            FROM_DATE_EXCEEDING_SYSDATE EXCEPTION;
            TO_DATE_LESSER_THAN_FROM_DATE EXCEPTION;
        BEGIN
            
            SELECT COUNT(*) INTO v_user_count
            FROM USERS_LOG
            WHERE TRUNC(UPDATED_TIME) >= P_FROM_UPDATED_DATE OR TRUNC(UPDATED_TIME) <=P_TO_UPDATED_DATE ;          
            IF P_FROM_UPDATED_DATE > SYSDATE THEN
                RAISE FROM_DATE_EXCEEDING_SYSDATE;
            END IF;
            IF P_TO_UPDATED_DATE<P_FROM_UPDATED_DATE   THEN
                RAISE TO_DATE_LESSER_THAN_FROM_DATE;
            END IF;

            IF v_user_count = 0 THEN
                DBMS_OUTPUT.PUT_LINE('NO CHANGES HAVE MADE TO THE USER ID ON THE DATE');
                RETURN;
            END IF;

            -- Output header
            DBMS_OUTPUT.PUT_LINE
            (
                RPAD('USER_ID', 18) ||
                RPAD('COLUMN_CHANGED', 18) ||
                RPAD('OLD_VALUE', 40) ||
                RPAD('NEW_VALUE', 40) ||
                RPAD('UPDATED_TIME', 18)
            );
            DBMS_OUTPUT.PUT_LINE(RPAD('-', 134, '-'));

            -- Fetch and output user log records
            FOR I_USER_LOG IN (SELECT * FROM USERS_LOG WHERE TRUNC(UPDATED_TIME) >= P_FROM_UPDATED_DATE OR TRUNC(UPDATED_TIME) <=P_TO_UPDATED_DATE )
            LOOP
                DBMS_OUTPUT.PUT_LINE
                (
                    RPAD(I_USER_LOG.USER_ID, 18) ||
                    RPAD(I_USER_LOG.COLUMN_CHANGED, 18) ||
                    RPAD(I_USER_LOG.OLD_VALUE, 40) ||
                    RPAD(I_USER_LOG.NEW_VALUE, 40) ||
                    RPAD(I_USER_LOG.UPDATED_TIME, 18)
                );
            END LOOP;

            EXCEPTION 
            WHEN FROM_DATE_EXCEEDING_SYSDATE THEN 
                DBMS_OUTPUT.PUT_LINE('SPECIFIED DATE EXCEEDS TODAY');
            WHEN TO_DATE_LESSER_THAN_FROM_DATE THEN 
                DBMS_OUTPUT.PUT_LINE('FROM_DATE EXCEEDS TO_DATE');
        END GET_USERS_LOG_BY_DATE_RANGE;

        PROCEDURE DISPLAY_USERS_LOG
        IS
            v_user_count NUMBER := 0;
            USER_INVALID EXCEPTION;
        BEGIN
           
            SELECT COUNT(*) INTO v_user_count
            FROM USERS_LOG;
            
            IF v_user_count = 0 THEN
                DBMS_OUTPUT.PUT_LINE('NO CHANGES HAVE MADE TO THE USERS');
                RETURN;
            END IF;

            DBMS_OUTPUT.PUT_LINE
            (
                RPAD('USER_ID', 18) ||
                RPAD('COLUMN_CHANGED', 18) ||
                RPAD('OLD_VALUE', 40) ||
                RPAD('NEW_VALUE', 40) ||
                RPAD('UPDATED_TIME', 18)
            );
            DBMS_OUTPUT.PUT_LINE(RPAD('-', 134, '-'));

            -- Fetch and output user log records
            FOR I_USER_LOG IN (SELECT * FROM USERS_LOG)
            LOOP
                DBMS_OUTPUT.PUT_LINE
                (
                    RPAD(I_USER_LOG.USER_ID, 18) ||
                    RPAD(I_USER_LOG.COLUMN_CHANGED, 18) ||
                    RPAD(I_USER_LOG.OLD_VALUE, 40) ||
                    RPAD(I_USER_LOG.NEW_VALUE, 40) ||
                    RPAD(I_USER_LOG.UPDATED_TIME, 18)
                );
            END LOOP;
        END DISPLAY_USERS_LOG;

END UTILS_USERS_LOG;
/