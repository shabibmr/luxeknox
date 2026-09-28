CREATE TABLE password_reset_tokens (
  id BIGINT GENERATED ALWAYS AS IDENTITY,
  user_id BIGINT NOT NULL,
  token_hash varchar(64) NOT NULL,
  expires_at TIMESTAMPTZ(3) NOT NULL,
  used_at TIMESTAMPTZ(3),
  created_at TIMESTAMPTZ(3) NOT NULL,
  CONSTRAINT password_reset_tokens_id PRIMARY KEY (id),
  CONSTRAINT password_reset_tokens_token_hash_unique UNIQUE (token_hash)
);

ALTER TABLE password_reset_tokens ADD CONSTRAINT password_reset_tokens_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE no action ON UPDATE no action;

CREATE INDEX password_reset_tokens_user_id_idx ON password_reset_tokens (user_id);
