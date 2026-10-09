-- =========================
-- TABLE CREATION
-- =========================

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR2(100),
    dob DATE,
    email VARCHAR2(100) UNIQUE,
    phone VARCHAR2(15)
);

CREATE TABLE Faculty (
    faculty_id INT PRIMARY KEY,
    name VARCHAR2(100),
    department VARCHAR2(50),
    email VARCHAR2(100) UNIQUE
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR2(100),
    credits INT CHECK (credits > 0),
    faculty_id INT,
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id)
);

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    grade CHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    UNIQUE (student_id, course_id)  -- prevents duplicate enrollment
);

-- =========================
-- SEQUENCE FOR ENROLLMENT
-- =========================

CREATE SEQUENCE SEQ_ENROLL
START WITH 1
INCREMENT BY 1;

-- =========================
-- PROCEDURE: ENROLL STUDENT
-- =========================

CREATE OR REPLACE PROCEDURE enroll_student (
    p_student_id IN INT,
    p_course_id  IN INT
) AS
BEGIN
    INSERT INTO Enrollments (enrollment_id, student_id, course_id)
    VALUES (SEQ_ENROLL.NEXTVAL, p_student_id, p_course_id);

    DBMS_OUTPUT.PUT_LINE('Student enrolled successfully.');

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Student already enrolled in this course.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- =========================
-- TRIGGER: GRADE VALIDATION
-- =========================

CREATE OR REPLACE TRIGGER grade_check
BEFORE INSERT OR UPDATE ON Enrollments
FOR EACH ROW
BEGIN
    IF :NEW.grade IS NOT NULL AND :NEW.grade NOT IN ('A','B','C','D','F') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid grade entered.');
    END IF;
END;
/

-- =========================
-- FUNCTION: CALCULATE GPA
-- =========================

CREATE OR REPLACE FUNCTION calculate_gpa (
    p_student_id INT
) RETURN NUMBER IS
    v_gpa NUMBER;
BEGIN
    SELECT AVG(
        CASE grade
            WHEN 'A' THEN 4
            WHEN 'B' THEN 3
            WHEN 'C' THEN 2
            WHEN 'D' THEN 1
            WHEN 'F' THEN 0
        END
    )
    INTO v_gpa
    FROM Enrollments
    WHERE student_id = p_student_id;

    RETURN v_gpa;
END;
/

-- =========================
-- INDEXES (OPTIMIZATION)
-- =========================

CREATE INDEX idx_enroll_student
ON Enrollments(student_id);

CREATE INDEX idx_enroll_course
ON Enrollments(course_id);

-- =========================
-- ROLES & PRIVILEGES
-- =========================

-- Create roles
CREATE ROLE ROLE_ADMIN;
CREATE ROLE ROLE_FACULTY;
CREATE ROLE ROLE_STUDENT;

-- Grant privileges
GRANT ALL PRIVILEGES TO ROLE_ADMIN;

GRANT SELECT, INSERT, UPDATE ON Courses TO ROLE_FACULTY;
GRANT SELECT, UPDATE ON Enrollments TO ROLE_FACULTY;

GRANT SELECT ON Enrollments TO ROLE_STUDENT;

-- =========================
-- SAMPLE USAGE
-- =========================

-- Enroll a student
BEGIN
    enroll_student(1, 101);
END;
/

-- Calculate GPA
SELECT calculate_gpa(1) FROM dual;