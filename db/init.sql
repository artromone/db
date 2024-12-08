-- public.departments definition
DROP TABLE IF EXISTS public.departments;
CREATE TABLE public.departments (
    id serial4 NOT NULL,
    CONSTRAINT departments_pk PRIMARY KEY (id)
);

-- public.emplyees definition
DROP TABLE IF EXISTS public.emplyees;
CREATE TABLE public.emplyees (
    first_name varchar(20) NULL,
    last_name varchar(20) NULL,
    fther_name varchar(20) NULL,
    "position" varchar(20) NULL,
    salary int4 NULL,
    id serial4 NOT NULL,
    CONSTRAINT emplyees_pk PRIMARY KEY (id)
);

-- public.projects definition
DROP TABLE IF EXISTS public.projects;
CREATE TABLE public.projects (
    "name" varchar(20) NULL,
    "cost" int4 NULL,
    department_id int4 NULL,
    id serial4 NOT NULL,
    beg_date timestamp NULL,
    end_date timestamp NULL,
    end_real_date timestamp NULL,
    CONSTRAINT projects_pk PRIMARY KEY (id),
    CONSTRAINT projects_departments_fk FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE CASCADE
);

-- public.department_employees definition
DROP TABLE IF EXISTS public.department_employees;
CREATE TABLE public.department_employees (
    department_id int4 NOT NULL,
    employee_id int4 NOT NULL,
    id serial4 NOT NULL,
    CONSTRAINT department_employees_pk PRIMARY KEY (id),
    CONSTRAINT department_employees_departments_fk FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE CASCADE,
    CONSTRAINT department_employees_emplyees_fk FOREIGN KEY (employee_id) REFERENCES public.emplyees(id) ON DELETE CASCADE
);

-- Table Triggers
create function prevent_duplicate_employee() returns trigger as $$
begin
    if exists(select 1 from public.department_employees where department_id = new.department_id and employee_id = new.employee_id) then
        raise exception 'Duplicate employee in the department';
    end if;
    return new;
end;
$$ language plpgsql;

create trigger trg_prevent_duplicate_employee before insert
    on public.department_employees for each row execute function prevent_duplicate_employee();

create function prevent_delete_employee_with_low_salary() returns trigger as $$
begin
    if old.salary < 1000 then
        raise exception 'Cannot delete employee with salary below 1000';
    end if;
    return old;
end;
$$ language plpgsql;

create trigger trg_prevent_delete_low_salary_employee before delete
    on public.emplyees for each row execute function prevent_delete_employee_with_low_salary();

create function prevent_invalid_project_dates() returns trigger as $$
begin
    if new.end_date < new.beg_date then
        raise exception 'End date cannot be before the start date';
    end if;
    return new;
end;
$$ language plpgsql;

create trigger trg_prevent_invalid_project_dates before update
    on public.projects for each row execute function prevent_invalid_project_dates();

create function prevent_delete_incomplete_project() returns trigger as $$
begin
    if old.end_real_date is null then
        raise exception 'Cannot delete an incomplete project';
    end if;
    return old;
end;
$$ language plpgsql;

create trigger trg_prevent_delete_incomplete_project before delete
    on public.projects for each row execute function prevent_delete_incomplete_project();

-- Initial data for departments (100 departments)
INSERT INTO public.departments (id) 
SELECT generate_series(1, 100);

-- Initial data for employees (100 employees)
INSERT INTO public.emplyees (first_name, last_name, fther_name, "position", salary) 
SELECT
    'First' || gs, 
    'Last' || gs, 
    'Father' || gs, 
    CASE 
        WHEN gs % 3 = 0 THEN 'Manager' 
        WHEN gs % 3 = 1 THEN 'Engineer' 
        ELSE 'Technician' 
    END,
    CASE 
        WHEN gs % 4 = 0 THEN 1000
        WHEN gs % 4 = 1 THEN 1500
        WHEN gs % 4 = 2 THEN 2000
        ELSE 2500
    END
FROM generate_series(1, 100) gs;

-- Initial data for projects (100 projects)
INSERT INTO public.projects ("name", "cost", department_id, beg_date, end_date, end_real_date) 
SELECT
    'Project ' || gs,
    (gs % 10 + 1) * 1000,
    (gs % 100) + 1,
    CURRENT_DATE + (gs * interval '1 day'),
    CURRENT_DATE + ((gs + 30) * interval '1 day'),
    CURRENT_DATE + ((gs + 30) * interval '1 day')
FROM generate_series(1, 100) gs;

-- Initial data for department_employees (1000 department-employee assignments)
INSERT INTO public.department_employees (department_id, employee_id)
SELECT DISTINCT
    (gs % 100) + 1 AS department_id, 
    ((gs * 17) % 100) + 1 AS employee_id
FROM generate_series(1, 1000) gs
ON CONFLICT DO NOTHING;
