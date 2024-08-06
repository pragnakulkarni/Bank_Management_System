create or replace PACKAGE BODY UTILS_BANK
IS
    PROCEDURE LOADER_BANK
    IS
    BEGIN
        FOR I_BANK IN BANK_CURSOR
        LOOP
            V_BANK_COLLECTION(I_BANK.IFSC_CODE) := I_BANK;
        END LOOP;
    END LOADER_BANK;

    PROCEDURE GET_DETAILS_BY_IFSC_CODE(P_IFSC_CODE BANK.IFSC_CODE%TYPE)
    IS
        V_KEY BANK.IFSC_CODE%TYPE;
        V_BANK_NAME BANK.BANK_NAME%TYPE;
        IFSC_CODE_IS_NULL EXCEPTION;
    BEGIN
        LOADER_BANK;
        IF P_IFSC_CODE IS NULL THEN
                    RAISE IFSC_CODE_IS_NULL ;
        END IF;
        V_KEY:=V_BANK_COLLECTION.FIRST;
        WHILE V_KEY IS NOT NULL 
            LOOP
                IF V_BANK_COLLECTION(V_KEY).R_IFSC_CODE=P_IFSC_CODE THEN
                    DBMS_OUTPUT.PUT_LINE(
                    RPAD('BANK_NAME',15) || RPAD('BRANCH_NAME',20 )||RPAD('BUILDING_NUMBER',20 )||RPAD('STREET',35 ) ||
                    RPAD('CITY',15) ||RPAD('PINCODE',15) ||RPAD('DISTRICT',15) ||RPAD('STATE',15) ||
                    RPAD('COUNTRY',20)
                    );
                    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------------------------------------------------------------------------------------------');
                    DBMS_OUTPUT.PUT_LINE(
                            RPAD(V_BANK_COLLECTION(V_KEY).R_BANK_NAME,15) || RPAD(V_BANK_COLLECTION(V_KEY).R_BRANCH_NAME,20 )||RPAD(V_BANK_COLLECTION(V_KEY).R_BUILDING_NUMBER,20 )||RPAD(V_BANK_COLLECTION(V_KEY).P_STREET,35 ) ||
                            RPAD(V_BANK_COLLECTION(V_KEY).R_CITY,15) ||RPAD(V_BANK_COLLECTION(V_KEY).R_PINCODE,15) ||RPAD(V_BANK_COLLECTION(V_KEY).R_DISTRICT,15) ||RPAD(V_BANK_COLLECTION(V_KEY).R_STATE,15) ||
                            RPAD(V_BANK_COLLECTION(V_KEY).R_COUNTRY,15) 
                    );
                                         
                END IF;      
            V_KEY:=V_BANK_COLLECTION.NEXT(V_KEY);
            END LOOP;

            EXCEPTION
                WHEN IFSC_CODE_IS_NULL THEN 
                    DBMS_OUTPUT.PUT_LINE('IFSC_CODE IS NOT PRESENT');
           
    END GET_DETAILS_BY_IFSC_CODE;

END UTILS_BANK;
/