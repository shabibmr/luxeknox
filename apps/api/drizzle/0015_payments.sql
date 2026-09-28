CREATE TABLE invoice_number_counters (
  id BIGINT NOT NULL,
  next_value BIGINT NOT NULL,
  CONSTRAINT invoice_number_counters_id PRIMARY KEY (id)
);

CREATE TABLE payment_methods (
  id BIGINT GENERATED ALWAYS AS IDENTITY,
  method_name varchar(100) NOT NULL,
  is_digital boolean NOT NULL DEFAULT false,
  is_active boolean NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3),
  CONSTRAINT payment_methods_id PRIMARY KEY (id),
  CONSTRAINT payment_methods_method_name_unique UNIQUE (method_name)
);

CREATE TABLE payments (
  id BIGINT GENERATED ALWAYS AS IDENTITY,
  invoice_number varchar(32) NOT NULL,
  member_id BIGINT NOT NULL,
  membership_id BIGINT,
  payment_method_id BIGINT,
  subtotal NUMERIC(12,2) NOT NULL,
  tax_amount NUMERIC(12,2) NOT NULL DEFAULT '0.00',
  discount_amount NUMERIC(12,2) NOT NULL DEFAULT '0.00',
  total_amount NUMERIC(12,2) NOT NULL,
  amount_paid NUMERIC(12,2) NOT NULL DEFAULT '0.00',
  status varchar(16) NOT NULL DEFAULT 'pending',
  transaction_reference varchar(150),
  cashier_user_id BIGINT,
  payment_date TIMESTAMPTZ(3) NOT NULL,
  row_version int NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3),
  CONSTRAINT payments_id PRIMARY KEY (id),
  CONSTRAINT payments_invoice_number_unique UNIQUE (invoice_number)
);

CREATE TABLE payment_histories (
  id BIGINT GENERATED ALWAYS AS IDENTITY,
  payment_id BIGINT NOT NULL,
  payment_method_id BIGINT,
  action varchar(32) NOT NULL,
  amount NUMERIC(12,2) NOT NULL,
  notes text,
  timestamp TIMESTAMPTZ(3) NOT NULL,
  CONSTRAINT payment_histories_id PRIMARY KEY (id)
);

CREATE TABLE payment_receipts (
  id BIGINT GENERATED ALWAYS AS IDENTITY,
  payment_id BIGINT NOT NULL,
  receipt_number varchar(32) NOT NULL,
  receipt_pdf_url varchar(512),
  generated_at TIMESTAMPTZ(3) NOT NULL,
  CONSTRAINT payment_receipts_id PRIMARY KEY (id),
  CONSTRAINT payment_receipts_payment_id_unique UNIQUE (payment_id),
  CONSTRAINT payment_receipts_receipt_number_unique UNIQUE (receipt_number)
);

ALTER TABLE payments ADD CONSTRAINT payments_member_id_members_id_fk FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE no action ON UPDATE no action;

ALTER TABLE payments ADD CONSTRAINT payments_membership_id_memberships_id_fk FOREIGN KEY (membership_id) REFERENCES memberships(id) ON DELETE no action ON UPDATE no action;

ALTER TABLE payments ADD CONSTRAINT payments_payment_method_id_payment_methods_id_fk FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id) ON DELETE no action ON UPDATE no action;

ALTER TABLE payments ADD CONSTRAINT payments_cashier_user_id_users_id_fk FOREIGN KEY (cashier_user_id) REFERENCES users(id) ON DELETE no action ON UPDATE no action;

ALTER TABLE payment_histories ADD CONSTRAINT payment_histories_payment_id_payments_id_fk FOREIGN KEY (payment_id) REFERENCES payments(id) ON DELETE no action ON UPDATE no action;

ALTER TABLE payment_histories ADD CONSTRAINT payment_histories_payment_method_id_payment_methods_id_fk FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id) ON DELETE no action ON UPDATE no action;

ALTER TABLE payment_receipts ADD CONSTRAINT payment_receipts_payment_id_payments_id_fk FOREIGN KEY (payment_id) REFERENCES payments(id) ON DELETE no action ON UPDATE no action;

CREATE INDEX payment_methods_is_active_idx ON payment_methods (is_active);

CREATE INDEX payments_member_id_idx ON payments (member_id);

CREATE INDEX payments_status_idx ON payments (status);

CREATE INDEX payments_payment_date_idx ON payments (payment_date);

CREATE INDEX payment_histories_payment_id_idx ON payment_histories (payment_id);

INSERT INTO invoice_number_counters (id, next_value) VALUES (1, 1) ON CONFLICT (id) DO NOTHING;
