--
-- import from local external file:
--
\copy Auth(login, password, isAdmin) from './test_users.csv' (format csv)

INSERT INTO Auth (login, password) VALUES ('jean-paul', 'farte'), ('pedro', 'spinouza'), ('issa', 'delouze');

INSERT INTO Profile(lid, pseudo, firstName, lastName) VALUES (1, 'calvin', 'calvin', 'dadson'), (2, 'hobbes', 'hobbes', 'tiger'), (3, 'jean-paul', 'jean-paul', 'farte'), (4, 'pedro', 'pedro', 'spinouza'), (5, 'issa', 'issa', 'delouze');

INSERT INTO AppGroup(gname) VALUES ('copaing');

INSERT INTO UsersInGroup(gid, lid) VALUES (1, 1), (1, 2);

INSERT INTO Messages(lid, mtext, mtime, gid) VALUES
(1, 'Je suis grand', '1999-01-08 04:05:06', 1),
(2, 'Je suis petit', '2002-03-08 02:09:16', 1),
(1, 'Je suis moyen', '2001-01-07 04:05:06', 1);
