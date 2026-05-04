-- V113 H2: Add patient_id FK to users table
ALTER TABLE users ADD COLUMN IF NOT EXISTS patient_id BIGINT REFERENCES patient(id);

CREATE INDEX IF NOT EXISTS idx_users_patient_id ON users(patient_id);
