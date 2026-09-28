CREATE TABLE IF NOT EXISTS medical_histories (
  id BIGINT GENERATED ALWAYS AS IDENTITY,
  member_id BIGINT NOT NULL,
  condition_id BIGINT,
  title varchar(255) NOT NULL,
  description text,
  diagnosed_date varchar(10),
  clearance_status varchar(64),
  document_key varchar(255),
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3),
  CONSTRAINT medical_histories_id PRIMARY KEY (id),
  CONSTRAINT medical_histories_member_id_members_id_fk FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE
);

CREATE INDEX medical_histories_member_id_idx ON medical_histories (member_id);
