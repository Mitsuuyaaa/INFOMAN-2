
CREATE TABLE authors (
    id SERIAL PRIMARY KEY,  
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    birthdate DATE NOT NULL,
    added TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE posts (
    id SERIAL PRIMARY KEY,  
    author_id INT NOT NULL REFERENCES authors(id),  
    title VARCHAR(255) NOT NULL,
    description VARCHAR(500) NOT NULL,
    content TEXT NOT NULL,
    date DATE NOT NULL
);
