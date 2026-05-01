-- V1: Create patient table
CREATE TABLE patient (
    id            BIGSERIAL PRIMARY KEY,
    first_name    VARCHAR(100) NOT NULL,
    last_name     VARCHAR(100) NOT NULL,
    fiscal_code   VARCHAR(16)  NOT NULL UNIQUE,
    birth_date    DATE         NOT NULL,
    email         VARCHAR(255) NOT NULL,
    phone         VARCHAR(50),
    updated_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_patient_fiscal_code ON patient(fiscal_code);
CREATE INDEX idx_patient_email        ON patient(email);
