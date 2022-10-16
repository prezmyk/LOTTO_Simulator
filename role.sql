
SET SERVEROUTPUT ON;
-- ROLE
CREATE ROLE GUEST_USER; 
-- SESSION
GRANT CREATE SESSION TO GUEST_USER;

-- GRANT SELECT on tables and views
-- CREATE PUBLIC SYNONYM on tables and views
DECLARE      
    v_table_name_cur SYS_REFCURSOR;
 
    v_table_name    VARCHAR2(30 CHAR); 
    v_owner         VARCHAR2(30 CHAR);

BEGIN  
    v_owner  := 'LOTTO'; 
    
    DBMS_OUTPUT.PUT_LINE('-- TABLES---');
    OPEN v_table_name_cur FOR
    SELECT table_name FROM all_tables
    WHERE UPPER(owner) = UPPER(v_owner);    
   
    LOOP      
        FETCH v_table_name_cur INTO v_table_name;
        EXIT WHEN v_table_name_cur%NOTFOUND;
        EXECUTE IMMEDIATE 'GRANT SELECT ON ' || v_owner||'.'||v_table_name || ' TO GUEST_USER'; 
        EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM ' ||v_table_name || ' FOR ' || v_owner||'.'||v_table_name; 
        DBMS_OUTPUT.PUT_LINE(v_owner||'.'||v_table_name );
    
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('-- VIEWS---');    
    OPEN v_table_name_cur FOR
    SELECT view_name FROM all_views
    WHERE UPPER(owner) = UPPER(v_owner);   
    
    LOOP      
        FETCH v_table_name_cur INTO v_table_name;
        EXIT WHEN v_table_name_cur%NOTFOUND;      
        EXECUTE IMMEDIATE 'GRANT SELECT ON ' || v_owner||'.'||v_table_name || ' TO GUEST_USER'; 
        EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM ' ||v_table_name || ' FOR ' || v_owner||'.'||v_table_name; 
        DBMS_OUTPUT.PUT_LINE(v_owner||'.'||v_table_name );    
    END LOOP;  

    CLOSE v_table_name_cur;
        
END;
/

-- Procedure
GRANT EXECUTE ON LOTTO.coupons_numbers_pkg 	TO GUEST_USER;
CREATE PUBLIC SYNONYM coupons_numbers_pkg 	FOR LOTTO.coupons_numbers_pkg;









