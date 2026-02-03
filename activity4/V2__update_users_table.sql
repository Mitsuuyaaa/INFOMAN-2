alter table users
add column password varchar(60) not null,
add column date_created TIMESTAMP DEFAULT now();

create table roles (
    id serial PRIMARY KEY,
    name varchar(50) UNIQUE NOT null,
    date_created TIMESTAMP DEFAULT now()
);

create table user_roles (
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE ON UPDATE CASCADE
);