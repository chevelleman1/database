CREATE TABLE customer_emails (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    message TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);