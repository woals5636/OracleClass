-- HR
SELECT employee_id, first_name, last_name, manager_id, department_id
FROM employees
WHERE department_id NOT IN(
                            SELECT  department_id
                            FROM departments
                            WHERE location_id = 1700
);
--SEMI JOIN : EXISTS ������ ����� ���
SELECT *
FROM departments d
WHERE EXISTS(
                SELECT *
                FROM employees e
                WHERE d.department_id = e.department_id
                                    AND e.salary > 2500
);

