-- V116: Rename trainer_id → specialist_id in diet_plan and training_plan.
-- Idempotent: only renames if the old column still exists.

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'diet_plan' AND column_name = 'trainer_id'
    ) THEN
        ALTER TABLE diet_plan RENAME COLUMN trainer_id TO specialist_id;
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'training_plan' AND column_name = 'trainer_id'
    ) THEN
        ALTER TABLE training_plan RENAME COLUMN trainer_id TO specialist_id;
    END IF;
END $$;
