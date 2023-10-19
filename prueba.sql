WITH EmployeeCounts AS (
    SELECT
        C.company_code,
        C.founder,
        COUNT(DISTINCT LM.lead_manager_code) AS lead_manager,
        COUNT(DISTINCT SM.senior_manager_code) AS senior_manager,
        COUNT(DISTINCT M.manager_code) AS managers,
        COUNT(DISTINCT E.employee_code) AS employee
    FROM Company AS C
    LEFT JOIN Lead_Manager AS LM ON C.company_code = LM.company_code
    LEFT JOIN Senior_Manager AS SM ON LM.lead_manager_code = SM.lead_manager_code
    LEFT JOIN Manager AS M ON SM.senior_manager_code = M.senior_manager_code
    LEFT JOIN Employee AS E ON M.manager_code = E.manager_code
    GROUP BY C.company_code, C.founder
)
SELECT
    EC.company_code,
    EC.founder,
    COALESCE(lead_manager, 0) AS lead_manager,
    COALESCE(senior_manager, 0) AS senior_manager,
    COALESCE(managers, 0) AS managers,
    COALESCE(employee, 0) AS employee
FROM (
    SELECT
        company_code,
        founder
    FROM Company
    UNION
    SELECT
        company_code,
        NULL AS founder
    FROM Employee
) AS C
LEFT JOIN EmployeeCounts AS EC ON C.company_code = EC.company_code
ORDER BY C.company_code;
