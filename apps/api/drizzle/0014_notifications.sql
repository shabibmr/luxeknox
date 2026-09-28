-- Hand-authored SQL migration: 0014_notifications.sql
-- Vertical 13 NOTIF: notification_types, notifications, user_devices, notification_deliveries.
-- Depends on 0001_platform.sql (roles) and 0004_people.sql (users).
-- Engine: PostgreSQL 17

CREATE TABLE IF NOT EXISTS notification_types (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  type_code VARCHAR(64) NOT NULL,
  template_text TEXT NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL
);

CREATE UNIQUE INDEX notification_types_type_code_unique ON notification_types (type_code);

CREATE TYPE notification_broadcast_audience AS ENUM ('all_members', 'assigned_clients', 'role');

CREATE TABLE IF NOT EXISTS notifications (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  notification_type_id BIGINT NULL,
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  data_payload JSONB NULL,
  sender_user_id BIGINT NULL,
  is_broadcast BOOLEAN NOT NULL DEFAULT FALSE,
  broadcast_audience notification_broadcast_audience NULL,
  created_at TIMESTAMPTZ(3) NOT NULL,
  CONSTRAINT notifications_notification_type_id_fk FOREIGN KEY (notification_type_id) REFERENCES notification_types (id),
  CONSTRAINT notifications_sender_user_id_fk FOREIGN KEY (sender_user_id) REFERENCES users (id)
);

CREATE INDEX notifications_sender_user_id_idx ON notifications (sender_user_id);

CREATE INDEX notifications_notification_type_id_idx ON notifications (notification_type_id);

CREATE INDEX notifications_is_broadcast_created_at_idx ON notifications (is_broadcast, created_at);

CREATE TYPE device_platform AS ENUM ('ios', 'android', 'web');

CREATE TABLE IF NOT EXISTS user_devices (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id BIGINT NOT NULL,
  device_token VARCHAR(512) NOT NULL,
  device_platform device_platform NOT NULL,
  last_active_at TIMESTAMPTZ(3) NOT NULL,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL,
  CONSTRAINT user_devices_user_id_fk FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE UNIQUE INDEX user_devices_token_unique ON user_devices (device_token);

CREATE INDEX user_devices_user_id_idx ON user_devices (user_id);

CREATE TYPE notification_delivery_status AS ENUM ('pending', 'sent', 'failed');

CREATE TABLE IF NOT EXISTS notification_deliveries (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  notification_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  status notification_delivery_status NOT NULL DEFAULT 'pending',
  failure_reason TEXT NULL,
  retry_count BIGINT NOT NULL DEFAULT 0,
  is_read BOOLEAN NOT NULL DEFAULT FALSE,
  read_at TIMESTAMPTZ(3) NULL,
  delivered_at TIMESTAMPTZ(3) NULL,
  created_at TIMESTAMPTZ(3) NOT NULL,
  CONSTRAINT notification_deliveries_notification_id_fk FOREIGN KEY (notification_id) REFERENCES notifications (id),
  CONSTRAINT notification_deliveries_user_id_fk FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE UNIQUE INDEX notification_deliveries_notif_user_unique ON notification_deliveries (notification_id, user_id);

CREATE INDEX notification_deliveries_user_read_created_idx ON notification_deliveries (user_id, is_read, created_at);

CREATE INDEX notification_deliveries_status_retry_idx ON notification_deliveries (status, retry_count);
