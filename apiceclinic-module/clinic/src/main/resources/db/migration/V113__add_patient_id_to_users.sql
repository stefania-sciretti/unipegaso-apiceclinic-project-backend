-- V113: Add patient_id FK to users table
-- Links a user account to a patient record (nullable: admin users have no patient)
ALTER TABLE users ADD COLUMN IF NOT EXISTS patient_id BIGINT REFERENCES patient(id);

CREATE INDEX IF NOT EXISTS idx_users_patient_id ON users(patient_id);
