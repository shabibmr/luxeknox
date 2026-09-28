CREATE TABLE idempotency_keys (
  id BIGINT GENERATED ALWAYS AS IDENTITY,
  idempotency_key varchar(128) NOT NULL,
  method varchar(16) NOT NULL,
  path varchar(255) NOT NULL,
  user_id BIGINT,
  request_hash varchar(64) NOT NULL,
  response_status int NOT NULL,
  response_body text NOT NULL,
  created_at TIMESTAMPTZ(3) NOT NULL,
  expires_at TIMESTAMPTZ(3) NOT NULL,
  CONSTRAINT idempotency_keys_id PRIMARY KEY (id)
);

ALTER TABLE idempotency_keys ADD CONSTRAINT idempotency_keys_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE no action ON UPDATE no action;

CREATE UNIQUE INDEX idempotency_keys_key_method_path_unique ON idempotency_keys (idempotency_key,method,path);

CREATE INDEX idempotency_keys_expires_at_idx ON idempotency_keys (expires_at);
