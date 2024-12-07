CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    role TEXT NOT NULL
);

INSERT INTO users (username, password, role)
SELECT 'admin', '', 'admin' WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'admin');
INSERT INTO users (username, password, role)
SELECT 'user', '', 'user' WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'user');
