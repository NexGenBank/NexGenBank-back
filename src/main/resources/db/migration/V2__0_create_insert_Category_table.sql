CREATE TABLE IF NOT EXISTS "Category" (
    id UUID DEFAULT  uuid_generate_v4() PRIMARY KEY,
    category_name VARCHAR(250) NOT NULL
);

INSERT INTO "Category" (category_name) VALUES ('Salaire'),('Ecollage'),('Nourriture'),('Habit');