CREATE TYPE job_run_status AS ENUM ('success', 'failure', 'running');

CREATE TABLE job_runs (
  id BIGINT GENERATED ALWAYS AS IDENTITY,
  job_name varchar(150) NOT NULL,
  status job_run_status NOT NULL,
  started_at TIMESTAMPTZ(3) NOT NULL,
  finished_at TIMESTAMPTZ(3),
  error_message text,
  retry_count int NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ(3) NOT NULL,
  CONSTRAINT job_runs_id PRIMARY KEY (id)
);

CREATE INDEX job_runs_job_name_idx ON job_runs (job_name);

CREATE INDEX job_runs_status_finished_at_idx ON job_runs (status,finished_at);
