create or replace PACKAGE BODY UTILS_USERS IS

    PROCEDURE LOADER_USERS IS
    BEGIN
        FOR I_USERS IN USERS_CURSOR LOOP
            V_USERS(I_USERS.USER_ID) := USERS_RECORD_TYPE(
                I_USERS.USER_ID,
                I_USERS.FIRST_NAME,
                I_USERS.LAST_NAME,
                I_USERS.PHONE_NUMBER,
                I_USERS.EMAIL,
                I_USERS.DOB,
                I_USERS.GENDER,
                I_USERS.AADHAR_NUMBER,
                I_USERS.PAN_NUMBER,
                I_USERS.ADDRESS_ID
            );
        END LOOP;
    END LOADER_USERS;

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


    PROCEDURE GET_USERS_DETAILS_BY_USER_ID(P_USER_ID USERS.USER_ID%TYPE) IS
        BOOL BOOLEAN := FALSE;
        V_KEY VARCHAR2(40);
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            RPAD('USER_ID', 15) || ' ' ||
            RPAD('FIRST_NAME', 15) || ' ' ||
            RPAD('LAST_NAME', 15) || ' ' ||
            RPAD('PHONE_NUMBER', 15) || ' ' ||
            RPAD('EMAIL', 35) || ' ' ||
            RPAD('DOB', 12) || ' ' ||
            RPAD('GENDER', 7) || ' ' ||
            RPAD('AADHAR_NUMBER', 15) || ' ' ||
            RPAD('PAN_NUMBER', 12) || ' ' ||
            RPAD('ADDRESS_ID', 10)
        );

        DBMS_OUTPUT.PUT_LINE(RPAD('-',160,'-'));

        LOADER_USERS;
        V_KEY := V_USERS.FIRST;
        WHILE V_KEY IS NOT NULL LOOP
            IF V_KEY = P_USER_ID THEN
                BOOL := TRUE;
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(V_USERS(V_KEY).R_USER_ID, 15) || ' ' ||
                    RPAD(V_USERS(V_KEY).R_FIRST_NAME, 15) || ' ' ||
                    RPAD(V_USERS(V_KEY).R_LAST_NAME, 15) || ' ' ||
                    RPAD(V_USERS(V_KEY).R_PHONE_NUMBER, 15) || ' ' ||
                    RPAD(V_USERS(V_KEY).R_EMAIL, 35) || ' ' ||
                    RPAD(TO_CHAR(V_USERS(V_KEY).R_DOB, 'DD-MM-YYYY'), 12) || ' ' ||
                    RPAD(V_USERS(V_KEY).R_GENDER, 7) || ' ' ||
                    RPAD(V_USERS(V_KEY).R_AADHAR_NUMBER, 15) || ' ' ||
                    RPAD(V_USERS(V_KEY).R_PAN_NUMBER, 12) || ' ' ||
                    RPAD(V_USERS(V_KEY).R_ADDRESS_ID, 10)
                );
            END IF;

            V_KEY := V_USERS.NEXT(V_KEY);
        END LOOP;

        IF BOOL = FALSE THEN
            RAISE_APPLICATION_ERROR(-20021, 'DATA NOT FOUND');
        END IF;

    
    END GET_USERS_DETAILS_BY_USER_ID;

    PROCEDURE GET_USER_DETAILS_BY_PAN_NUMBER(P_PAN_NUMBER USERS.PAN_NUMBER%TYPE) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            RPAD('USER_ID', 15) || ' ' ||
            RPAD('FIRST_NAME', 15) || ' ' ||
            RPAD('LAST_NAME', 15) || ' ' ||
            RPAD('PHONE_NUMBER', 15) || ' ' ||
            RPAD('EMAIL', 35) || ' ' ||
            RPAD('DOB', 12) || ' ' ||
            RPAD('GENDER', 7) || ' ' ||
            RPAD('AADHAR_NUMBER', 15) || ' ' ||
            RPAD('PAN_NUMBER', 12) || ' ' ||
            RPAD('ADDRESS_ID', 10)
        );

        DBMS_OUTPUT.PUT_LINE(RPAD('-',160,'-'));

        FOR I_USERS IN USERS_CURSOR LOOP
            IF I_USERS.PAN_NUMBER = P_PAN_NUMBER THEN
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(I_USERS.USER_ID, 15) || ' ' ||
                    RPAD(I_USERS.FIRST_NAME, 15) || ' ' ||
                    RPAD(I_USERS.LAST_NAME, 15) || ' ' ||
                    RPAD(I_USERS.PHONE_NUMBER, 15) || ' ' ||
                    RPAD(I_USERS.EMAIL, 35) || ' ' ||
                    RPAD(TO_CHAR(I_USERS.DOB, 'DD-MM-YYYY'), 12) || ' ' ||
                    RPAD(I_USERS.GENDER, 7) || ' ' ||
                    RPAD(I_USERS.AADHAR_NUMBER, 15) || ' ' ||
                    RPAD(I_USERS.PAN_NUMBER, 12) || ' ' ||
                    RPAD(I_USERS.ADDRESS_ID, 10)
                );
                RETURN;
            END IF;
        END LOOP;

        RAISE_APPLICATION_ERROR(-20022, 'PAN_NUMBER IS NOT LISTED');

    
    END GET_USER_DETAILS_BY_PAN_NUMBER;

    PROCEDURE GET_USER_DETAILS_BY_PHONE_NUMBER(P_PHONE_NUMBER USERS.PHONE_NUMBER%TYPE) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            RPAD('USER_ID', 15) || ' ' ||
            RPAD('FIRST_NAME', 15) || ' ' ||
            RPAD('LAST_NAME', 15) || ' ' ||
            RPAD('PHONE_NUMBER', 15) || ' ' ||
            RPAD('EMAIL', 35) || ' ' ||
            RPAD('DOB', 12) || ' ' ||
            RPAD('GENDER', 7) || ' ' ||
            RPAD('AADHAR_NUMBER', 15) || ' ' ||
            RPAD('PAN_NUMBER', 12) || ' ' ||
            RPAD('ADDRESS_ID', 10)
        );

        DBMS_OUTPUT.PUT_LINE(RPAD('-',160,'-'));

        FOR I_USERS IN USERS_CURSOR LOOP
            IF I_USERS.PHONE_NUMBER = P_PHONE_NUMBER THEN
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(I_USERS.USER_ID, 15) || ' ' ||
                    RPAD(I_USERS.FIRST_NAME, 15) || ' ' ||
                    RPAD(I_USERS.LAST_NAME, 15) || ' ' ||
                    RPAD(I_USERS.PHONE_NUMBER, 15) || ' ' ||
                    RPAD(I_USERS.EMAIL, 35) || ' ' ||
                    RPAD(TO_CHAR(I_USERS.DOB, 'DD-MM-YYYY'), 12) || ' ' ||
                    RPAD(I_USERS.GENDER, 7) || ' ' ||
                    RPAD(I_USERS.AADHAR_NUMBER, 15) || ' ' ||
                    RPAD(I_USERS.PAN_NUMBER, 12) || ' ' ||
                    RPAD(I_USERS.ADDRESS_ID, 10)
                );
                RETURN;
            END IF;
        END LOOP;

        RAISE_APPLICATION_ERROR(-20023, 'PHONE_NUMBER IS NOT LISTED');

    
    END GET_USER_DETAILS_BY_PHONE_NUMBER;

    PROCEDURE GET_USER_DETAILS_BY_AADHAR_NUMBER(P_AADHAR_NUMBER USERS.AADHAR_NUMBER%TYPE) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            RPAD('USER_ID', 15) || ' ' ||
            RPAD('FIRST_NAME', 15) || ' ' ||
            RPAD('LAST_NAME', 15) || ' ' ||
            RPAD('PHONE_NUMBER', 15) || ' ' ||
            RPAD('EMAIL', 35) || ' ' ||
            RPAD('DOB', 12) || ' ' ||
            RPAD('GENDER', 7) || ' ' ||
            RPAD('AADHAR_NUMBER', 15) || ' ' ||
            RPAD('PAN_NUMBER', 12) || ' ' ||
            RPAD('ADDRESS_ID', 10)
        );

        DBMS_OUTPUT.PUT_LINE(RPAD('-',160,'-'));

        FOR I_USERS IN USERS_CURSOR LOOP
            IF I_USERS.AADHAR_NUMBER = P_AADHAR_NUMBER THEN
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(I_USERS.USER_ID, 15) || ' ' ||
                    RPAD(I_USERS.FIRST_NAME, 15) || ' ' ||
                    RPAD(I_USERS.LAST_NAME, 15) || ' ' ||
                    RPAD(I_USERS.PHONE_NUMBER, 15) || ' ' ||
                    RPAD(I_USERS.EMAIL, 35) || ' ' ||
                    RPAD(TO_CHAR(I_USERS.DOB, 'DD-MM-YYYY'), 12) || ' ' ||
                    RPAD(I_USERS.GENDER, 7) || ' ' ||
                    RPAD(I_USERS.AADHAR_NUMBER, 15) || ' ' ||
                    RPAD(I_USERS.PAN_NUMBER, 12) || ' ' ||
                    RPAD(I_USERS.ADDRESS_ID, 10)
                );
                RETURN;
            END IF;
        END LOOP;

        RAISE_APPLICATION_ERROR(-20024, 'AADHAR_NUMBER IS NOT LISTED');

    
    END GET_USER_DETAILS_BY_AADHAR_NUMBER;

    PROCEDURE GET_USERS_BY_GENDER(P_GENDER USERS.GENDER%TYPE) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            RPAD('USER_ID', 15) || ' ' ||
            RPAD('FIRST_NAME', 15) || ' ' ||
            RPAD('LAST_NAME',             15) || ' ' ||
            RPAD('PHONE_NUMBER', 15) || ' ' ||
            RPAD('EMAIL', 35) || ' ' ||
            RPAD('DOB', 12) || ' ' ||
            RPAD('GENDER', 7) || ' ' ||
            RPAD('AADHAR_NUMBER', 15) || ' ' ||
            RPAD('PAN_NUMBER', 12) || ' ' ||
            RPAD('ADDRESS_ID', 10)
        );

        DBMS_OUTPUT.PUT_LINE(RPAD('-',160,'-'));

        FOR I_USERS IN USERS_CURSOR LOOP
            IF I_USERS.GENDER = P_GENDER THEN
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(I_USERS.USER_ID, 15) || ' ' ||
                    RPAD(I_USERS.FIRST_NAME, 15) || ' ' ||
                    RPAD(I_USERS.LAST_NAME, 15) || ' ' ||
                    RPAD(I_USERS.PHONE_NUMBER, 15) || ' ' ||
                    RPAD(I_USERS.EMAIL, 35) || ' ' ||
                    RPAD(TO_CHAR(I_USERS.DOB, 'DD-MM-YYYY'), 12) || ' ' ||
                    RPAD(I_USERS.GENDER, 7) || ' ' ||
                    RPAD(I_USERS.AADHAR_NUMBER, 15) || ' ' ||
                    RPAD(I_USERS.PAN_NUMBER, 12) || ' ' ||
                    RPAD(I_USERS.ADDRESS_ID, 10)
                );
            END IF;
        END LOOP;
    END GET_USERS_BY_GENDER;

    PROCEDURE GET_USER_DETAILS_BY_ADDRESS_ID(P_ADDRESS_ID USERS.ADDRESS_ID%TYPE) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            RPAD('USER_ID', 15) || ' ' ||
            RPAD('FIRST_NAME', 15) || ' ' ||
            RPAD('LAST_NAME', 15) || ' ' ||
            RPAD('PHONE_NUMBER', 15) || ' ' ||
            RPAD('EMAIL', 35) || ' ' ||
            RPAD('DOB', 12) || ' ' ||
            RPAD('GENDER', 7) || ' ' ||
            RPAD('AADHAR_NUMBER', 15) || ' ' ||
            RPAD('PAN_NUMBER', 12) || ' ' ||
            RPAD('ADDRESS_ID', 10)
        );
        
        DBMS_OUTPUT.PUT_LINE(RPAD('-',160,'-'));

        FOR I_USERS IN (SELECT * FROM USERS WHERE ADDRESS_ID = P_ADDRESS_ID) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(I_USERS.USER_ID, 15) || ' ' ||
                RPAD(I_USERS.FIRST_NAME, 15) || ' ' ||
                RPAD(I_USERS.LAST_NAME, 15) || ' ' ||
                RPAD(I_USERS.PHONE_NUMBER, 15) || ' ' ||
                RPAD(I_USERS.EMAIL, 35) || ' ' ||
                RPAD(TO_CHAR(I_USERS.DOB, 'DD-MM-YYYY'), 12) || ' ' ||
                RPAD(I_USERS.GENDER, 7) || ' ' ||
                RPAD(I_USERS.AADHAR_NUMBER, 15) || ' ' ||
                RPAD(I_USERS.PAN_NUMBER, 12) || ' ' ||
                RPAD(I_USERS.ADDRESS_ID, 10)
            );
        END LOOP;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20025, 'ADDRESS_ID IS NOT LISTED');
        END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20026, 'ADDRESS_ID IS NOT LISTED');
        
    END GET_USER_DETAILS_BY_ADDRESS_ID;

    PROCEDURE GET_ADDRESS_BY_USER_ID(P_USER_ID USERS.USER_ID%TYPE) IS
        V_ADDRESS_ID USERS.ADDRESS_ID%TYPE;
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            RPAD('H_NO', 10) || ' ' ||
            RPAD('STREET', 20) || ' ' ||
            RPAD('CITY', 15) || ' ' ||
            RPAD('PINCODE', 10) || ' ' ||
            RPAD('DISTRICT', 15) || ' ' ||
            RPAD('STATE', 15) || ' ' ||
            RPAD('COUNTRY', 15)
        );

        DBMS_OUTPUT.PUT_LINE(RPAD('-',150,'-'));


        SELECT ADDRESS_ID INTO V_ADDRESS_ID FROM USERS WHERE USER_ID = P_USER_ID;

        IF V_ADDRESS_ID IS NULL THEN
            RAISE_APPLICATION_ERROR(-20027, 'ADDRESS IS NOT LISTED IN ADDRESS TABLE');
        ELSE
            FOR I_ADDRESS_ID IN (SELECT * FROM USER_ADDRESS WHERE ADDRESS_ID = V_ADDRESS_ID) LOOP
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(I_ADDRESS_ID.H_NO, 10) || ' ' ||
                    RPAD(I_ADDRESS_ID.STREET, 20) || ' ' ||
                    RPAD(I_ADDRESS_ID.CITY, 15) || ' ' ||
                    RPAD(I_ADDRESS_ID.PINCODE, 10) || ' ' ||
                    RPAD(I_ADDRESS_ID.DISTRICT, 15) || ' ' ||
                    RPAD(I_ADDRESS_ID.STATE, 15) || ' ' ||
                    RPAD(I_ADDRESS_ID.COUNTRY, 15)
                );
            END LOOP;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20028, 'USER ID IS NOT LISTED');
        
    END GET_ADDRESS_BY_USER_ID;

    PROCEDURE UPDATE_EMAIL_BY_USER_ID(P_USER_ID USERS.USER_ID%TYPE, P_EMAIL USERS.EMAIL%TYPE) IS
    BEGIN
        IF NOT USER_PKG.validate_email(P_EMAIL) THEN
                RAISE_APPLICATION_ERROR(-20029, 'INVALID EMAIL FORMAT, ENTER PROPER EMAIL ADDRESS!');
        ELSE
            UPDATE USERS SET EMAIL =  UPPER(P_EMAIL) WHERE USER_ID = P_USER_ID;
        END IF;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20030, 'USER_ID IS NOT LISTED IN USERS TABLE');
        ELSE
            DBMS_OUTPUT.PUT_LINE('EMAIL IS UPDATED SUCCESSFULLY');
        END IF;
    
    END UPDATE_EMAIL_BY_USER_ID;

    PROCEDURE UPDATE_PHONE_NUMBER_BY_USER_ID(P_USER_ID USERS.USER_ID%TYPE, P_PHONE_NUMBER USERS.PHONE_NUMBER%TYPE) IS
    BEGIN
        IF NOT USER_PKG.VALIDATE_PHONE_NUMBER(P_PHONE_NUMBER) THEN
            RAISE_APPLICATION_ERROR(-20031, 'INVALID PHONE NUMBER, USE NUMBERS OR 10 LENGTH!, ENTER PROPER PHONE NUMBER!');
        ELSE 
            UPDATE  USERS SET PHONE_NUMBER = P_PHONE_NUMBER WHERE USER_ID = P_USER_ID;
        END IF;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20032, 'USER_ID IS NOT LISTED IN USERS TABLE');
        ELSE
            DBMS_OUTPUT.PUT_LINE('PHONE NUMBER IS UPDATED SUCCESSFULLY');
        END IF;
    
    END UPDATE_PHONE_NUMBER_BY_USER_ID;

    PROCEDURE UPDATE_ADDRESS_BY_USER_ID(P_USER_ID USERS.USER_ID%TYPE, P_ADDRESS_ID USERS.ADDRESS_ID%TYPE) IS
        V_ADDRESS_ID USERS.ADDRESS_ID%TYPE;
    BEGIN
        BEGIN
            SELECT ADDRESS_ID INTO V_ADDRESS_ID 
            FROM USER_ADDRESS 
            WHERE ADDRESS_ID = P_ADDRESS_ID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20033, 'ADDRESS ID IS NOT LISTED IN THE ADDRESS TABLE');
        END;

        UPDATE USERS 
        SET ADDRESS_ID = P_ADDRESS_ID 
        WHERE USER_ID = P_USER_ID;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20034, 'USER ID IS NOT LISTED IN THE USERS TABLE');
        ELSE
            DBMS_OUTPUT.PUT_LINE('ADDRESS ID IS UPDATED SUCCESSFULLY');
        END IF;
    
    END UPDATE_ADDRESS_BY_USER_ID;

    PROCEDURE GET_USER_DETAILS_BY_CITY(P_CITY USER_ADDRESS.CITY%TYPE) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            RPAD('USER_ID', 15) || ' ' ||
            RPAD('FIRST_NAME', 15) || ' ' ||
            RPAD('LAST_NAME', 15) || ' ' ||
            RPAD('PHONE_NUMBER', 15) || ' ' ||
            RPAD('EMAIL', 35) || ' ' ||
            RPAD('DOB', 12) || ' ' ||
            RPAD('GENDER', 7) || ' ' ||
            RPAD('AADHAR_NUMBER', 15) || ' ' ||
            RPAD('PAN_NUMBER', 12) || ' ' ||
            RPAD('ADDRESS_ID', 10)
        );

        DBMS_OUTPUT.PUT_LINE(RPAD('-',160,'-'));

        DECLARE
            V_USER_FOUND BOOLEAN := FALSE;
        BEGIN
            FOR I_ADDRESS_ID IN (SELECT ADDRESS_ID FROM USER_ADDRESS WHERE CITY = P_CITY) LOOP
                FOR I_USER_DETAILS IN (SELECT * FROM USERS WHERE ADDRESS_ID = I_ADDRESS_ID.ADDRESS_ID) LOOP
                    V_USER_FOUND := TRUE;
                    DBMS_OUTPUT.PUT_LINE(
                        RPAD(I_USER_DETAILS.USER_ID, 15) || ' ' ||
                        RPAD(I_USER_DETAILS.FIRST_NAME, 15) || ' ' ||
                        RPAD(I_USER_DETAILS.LAST_NAME, 15) || ' ' ||
                        RPAD(I_USER_DETAILS.PHONE_NUMBER, 15) || ' ' ||
                        RPAD(I_USER_DETAILS.EMAIL, 35) || ' ' ||
                        RPAD(TO_CHAR(I_USER_DETAILS.DOB, 'DD-MM-YYYY'), 12) || ' ' ||
                        RPAD(I_USER_DETAILS.GENDER, 7) || ' ' ||
                        RPAD(I_USER_DETAILS.AADHAR_NUMBER, 15) || ' ' ||
                        RPAD(I_USER_DETAILS.PAN_NUMBER, 12) || ' ' ||
                        RPAD(I_USER_DETAILS.ADDRESS_ID, 10)
                    );
                END LOOP;
            END LOOP;

            IF NOT V_USER_FOUND THEN
                RAISE_APPLICATION_ERROR(-20035, 'No users found for the specified city.');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20036, 'No address found for the specified city.');
            
        END;
    END GET_USER_DETAILS_BY_CITY;

    PROCEDURE GET_USER_DETAILS_BY_DISTRICT(P_DISTRICT USER_ADDRESS.DISTRICT%TYPE) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            RPAD('USER_ID', 15) || ' ' ||
            RPAD('FIRST_NAME', 15) || ' ' ||
            RPAD('LAST_NAME', 15) || ' ' ||
            RPAD('PHONE_NUMBER', 15) || ' ' ||
            RPAD('EMAIL', 35) || ' ' ||
            RPAD('DOB', 12) || ' ' ||
            RPAD('GENDER', 7) || ' ' ||
            RPAD('AADHAR_NUMBER', 15) || ' ' ||
            RPAD('PAN_NUMBER', 12) || ' ' ||
            RPAD('ADDRESS_ID', 10)
        );

        DBMS_OUTPUT.PUT_LINE(RPAD('-',160,'-'));

        DECLARE
            V_USER_FOUND BOOLEAN := FALSE;
        BEGIN
            FOR I_ADDRESS_ID IN (SELECT ADDRESS_ID FROM USER_ADDRESS WHERE DISTRICT = P_DISTRICT) LOOP
                FOR I_USER_DETAILS IN (SELECT * FROM USERS WHERE ADDRESS_ID = I_ADDRESS_ID.ADDRESS_ID) LOOP
                    V_USER_FOUND := TRUE;
                    DBMS_OUTPUT.PUT_LINE(
                        RPAD(I_USER_DETAILS.USER_ID, 15) || ' ' ||
                        RPAD(I_USER_DETAILS.FIRST_NAME, 15) || ' ' ||
                        RPAD(I_USER_DETAILS.LAST_NAME, 15) || ' ' ||
                        RPAD(I_USER_DETAILS.PHONE_NUMBER, 15) || ' ' ||
                        RPAD(I_USER_DETAILS.EMAIL, 35) || ' ' ||
                        RPAD(TO_CHAR(I_USER_DETAILS.DOB, 'DD-MM-YYYY'), 12) || ' ' ||
                        RPAD(I_USER_DETAILS.GENDER, 7) || ' ' ||
                        RPAD(I_USER_DETAILS.AADHAR_NUMBER, 15) || ' ' ||
                        RPAD(I_USER_DETAILS.PAN_NUMBER, 12) || ' ' ||
                        RPAD(I_USER_DETAILS.ADDRESS_ID, 10)
                    );
                END LOOP;
            END LOOP;

            IF NOT V_USER_FOUND THEN
                RAISE_APPLICATION_ERROR(-20037, 'No users found for the specified district.');
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20038, 'No address found for the specified district.');
            
        END;
    END GET_USER_DETAILS_BY_DISTRICT;

    PROCEDURE UPDATE_FIRST_NAME_BY_USER_ID(P_USER_ID USERS.USER_ID%TYPE, P_FIRST_NAME USERS.FIRST_NAME%TYPE) IS
    BEGIN
        BEGIN
            UPDATE USERS 
            SET FIRST_NAME = P_FIRST_NAME 
            WHERE USER_ID = P_USER_ID;

            IF SQL%ROWCOUNT = 0 THEN
                RAISE_APPLICATION_ERROR(-20039, 'USER_ID IS NOT LISTED IN USERS TABLE');
            END IF;
       
        END;
    END UPDATE_FIRST_NAME_BY_USER_ID;

    
    PROCEDURE UPDATE_LAST_NAME_BY_USER_ID(P_USER_ID USERS.USER_ID%TYPE, P_LAST_NAME USERS.LAST_NAME%TYPE) IS
    BEGIN
        UPDATE USERS 
        SET LAST_NAME = P_LAST_NAME 
        WHERE USER_ID = P_USER_ID;
    
    END UPDATE_LAST_NAME_BY_USER_ID;


    PROCEDURE DISPLAY_USERS IS
        
        V_KEY VARCHAR2(40);
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            RPAD('USER_ID', 15) || ' ' ||
            RPAD('FIRST_NAME', 15) || ' ' ||
            RPAD('LAST_NAME', 15) || ' ' ||
            RPAD('PHONE_NUMBER', 15) || ' ' ||
            RPAD('EMAIL', 35) || ' ' ||
            RPAD('DOB', 12) || ' ' ||
            RPAD('GENDER', 7) || ' ' ||
            RPAD('AADHAR_NUMBER', 15) || ' ' ||
            RPAD('PAN_NUMBER', 12) || ' ' ||
            RPAD('ADDRESS_ID', 10)
        );

        DBMS_OUTPUT.PUT_LINE(RPAD('-',160,'-'));

        LOADER_USERS;
        V_KEY := V_USERS.FIRST;
        WHILE V_KEY IS NOT NULL LOOP
        
            DBMS_OUTPUT.PUT_LINE(
                RPAD(V_USERS(V_KEY).R_USER_ID, 15) || ' ' ||
                RPAD(V_USERS(V_KEY).R_FIRST_NAME, 15) || ' ' ||
                RPAD(V_USERS(V_KEY).R_LAST_NAME, 15) || ' ' ||
                RPAD(V_USERS(V_KEY).R_PHONE_NUMBER, 15) || ' ' ||
                RPAD(V_USERS(V_KEY).R_EMAIL, 35) || ' ' ||
                RPAD(TO_CHAR(V_USERS(V_KEY).R_DOB, 'DD-MM-YYYY'), 12) || ' ' ||
                RPAD(V_USERS(V_KEY).R_GENDER, 7) || ' ' ||
                RPAD(V_USERS(V_KEY).R_AADHAR_NUMBER, 15) || ' ' ||
                RPAD(V_USERS(V_KEY).R_PAN_NUMBER, 12) || ' ' ||
                RPAD(V_USERS(V_KEY).R_ADDRESS_ID, 10)
            );
            V_KEY := V_USERS.NEXT(V_KEY);
        END LOOP;

    END DISPLAY_USERS;


END UTILS_USERS;
/