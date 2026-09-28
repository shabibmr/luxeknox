CREATE TABLE receipt_number_counters (
  id BIGINT NOT NULL,
  next_value BIGINT NOT NULL,
  CONSTRAINT receipt_number_counters_id PRIMARY KEY (id)
);

INSERT INTO receipt_number_counters (id, next_value) VALUES (1, 1) ON CONFLICT (id) DO NOTHING;
