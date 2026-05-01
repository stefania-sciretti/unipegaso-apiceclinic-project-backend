-- V7: Create diet_plan table (client_id references patient)
CREATE TABLE diet_plan (
    id             BIGSERIAL    PRIMARY KEY,
    client_id      BIGINT       NOT NULL REFERENCES patient(id),
    trainer_id     BIGINT       NOT NULL REFERENCES staff(id),
    title          VARCHAR(255) NOT NULL,
    description    TEXT,
    calories       INT,
    duration_weeks INT,
    active         BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_diet_plan_client_id  ON diet_plan(client_id);
CREATE INDEX idx_diet_plan_trainer_id ON diet_plan(trainer_id);
CREATE INDEX idx_diet_plan_active     ON diet_plan(active);
