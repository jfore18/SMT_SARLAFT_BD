PROMPT CREATE OR REPLACE FUNCTION split
CREATE OR REPLACE FUNCTION split(p_string IN VARCHAR2, p_delimiter IN VARCHAR2 := ',')
RETURN tbl_array PIPELINED PARALLEL_ENABLE
AS

v_cnt NUMBER ;
idx NUMBER ;
v_string VARCHAR2(32000);
v_start NUMBER := 0;
v_end NUMBER := 0;

BEGIN

-- Get Number of occurrences
v_cnt := LENGTH(p_string) - LENGTH(REPLACE(p_string,p_delimiter,'')) ;
FOR idx IN 1..v_cnt LOOP
v_end := INSTR(p_string,p_delimiter,1, idx);
v_string := SUBSTR (p_string, v_start + 1 , v_end - v_start - 1);
v_start := v_end ;
PIPE ROW(TO_CHAR(v_string));
END LOOP;

--Last split
v_string := SUBSTR (p_string, - (LENGTH(p_string) - v_end));
PIPE ROW(TRIM(v_string));

RETURN;
END SPLIT;
/

