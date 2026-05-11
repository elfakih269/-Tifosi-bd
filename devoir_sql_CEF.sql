CREATE DATABASE  Tifosi DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
USE  Tifosi;


CREATE TABLE Ingredient (
    id_ingredient INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL
);

CREATE TABLE Marque (
    id_marque INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL 
);

CREATE TABLE Boisson (
    id_boisson INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL, 
    id_marque INT NOT NULL, 
    CONSTRAINT fk_boisson_marque FOREIGN KEY (id_marque)
    REFERENCES Marque(id_marque)
);

CREATE TABLE Focaccia (
    id_focaccia INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prix DECIMAL(5,2) NOT NULL 
);

CREATE TABLE Menu (
    id_menu INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL ,
    prix DECIMAL(5,2) NOT NULL 
);

CREATE TABLE Client (
    id_client INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    code_postal INT NOT NULL
);

CREATE TABLE Comprend (
    id_focaccia INT,
    id_ingredient INT,
    quantite INT, 
    PRIMARY KEY (id_focaccia, id_ingredient),
    CONSTRAINT fk_comprend_focaccia FOREIGN KEY (id_focaccia) 
    REFERENCES Focaccia(id_focaccia),
    CONSTRAINT fk_comprend_ingredient FOREIGN KEY (id_ingredient) 
    REFERENCES Ingredient(id_ingredient)
);

CREATE TABLE Contient (
    id_menu INT,
    id_boisson INT,
    PRIMARY KEY (id_menu, id_boisson), 
    CONSTRAINT fk_contient_menu FOREIGN KEY (id_menu) 
    REFERENCES Menu(id_menu),
    CONSTRAINT fk_contient_boisson FOREIGN KEY (id_boisson) 
    REFERENCES Boisson(id_boisson)
);

CREATE TABLE est_constitue (
    id_menu INT,
    id_focaccia INT,
    PRIMARY KEY (id_menu, id_focaccia), 
    CONSTRAINT fk_constitue_menu FOREIGN KEY (id_menu) 
    REFERENCES Menu(id_menu),
    CONSTRAINT fk_constitue_focaccia FOREIGN KEY (id_focaccia) 
    REFERENCES Focaccia(id_focaccia)
);

CREATE TABLE Achete (
    id_client INT,
    id_menu INT,
    date_achat DATE DEFAULT (CURRENT_DATE), 
    PRIMARY KEY (id_client, id_menu, date_achat),
    CONSTRAINT fk_achete_client FOREIGN KEY (id_client) 
    REFERENCES Client(id_client),
    CONSTRAINT fk_achete_menu FOREIGN KEY (id_menu) 
    REFERENCES Menu(id_menu)
);

INSERT INTO marque (id_marque, nom) VALUES
(1, 'Coca-cola'),
(2, 'Cristaline'),
(3, 'Monster'),
(4, 'Pepsi');

INSERT INTO boisson (id_boisson, nom, id_marque) VALUES
(1, 'Coca-cola zéro', 1),
(2, 'Coca-cola original', 1),
(3, 'Fanta orange', 1),
(4, 'Fanta citron', 1),
(5, 'Sprite', 1),
(6, 'Monster energy ultra white', 3),
(7, 'Monster energy original', 3),
(8, 'Eau de source', 2),
(9, 'Eau gazeuse', 2),
(10, 'Pepsi', 4),
(11, 'Pepsi Max', 4);

INSERT INTO ingredient (id_ingredient, nom) VALUES
(1, 'Ail'), (2, 'Ananas'), (3, 'Artichaut'), (4, 'Bacon'), (5, 'Base Tomate'), 
(6, 'Base crème'), (7, 'Champignon'), (8, 'Chèvre'), (9, 'Cresson'), (10, 'Emmental'), 
(11, 'Gorgonzola'), (12, 'Jambon cuit'), (13, 'Jambon fumé'), (14, 'Oeuf'), (15, 'Oignon'), 
(16, 'Olive noire'), (17, 'Olive verte'), (18, 'Parmesan'), (19, 'Piment'), (20, 'Poivre'), 
(21, 'Pomme de terre'), (22, 'Raclette'), (23, 'Salami'), (24, 'Tomate cerise'), (25, 'Mozzarella');

INSERT INTO focaccia (id_focaccia, nom, prix) VALUES
(1, 'Mozzaccia', 9.80),
(2, 'Baconaccia', 9.30),
(3, 'Pancettaccia', 10.00),
(4, 'Emmentalaccia', 8.60),
(5, 'Trifolaccia', 8.90),
(6, 'Base Tomate', 7.00),
(7, 'Raclanaccia', 8.90),
(8, 'Bauguaccia', 9.20);

INSERT INTO comprend (id_focaccia, id_ingredient) VALUES
(1, 5), (1, 25), (1, 9), (1, 18), (1, 24), (1, 16),
(2, 5), (2, 25), (2, 4), (2, 15), (2, 20), (2, 16),
(3, 5), (3, 25), (3, 13), (3, 3), (3, 16), (3, 15),
(4, 6), (4, 25), (4, 10), (4, 7),
(5, 5), (5, 25), (5, 7), (5, 12), (5, 16), (5, 17), (5, 1),
(6, 5), (6, 25), (6, 16), (6, 17),
(7, 5), (7, 25), (7, 22), (7, 21), (7, 15),
(8, 6), (8, 25), (8, 8), (8, 12), (8, 15);


SELECT nom 
FROM focaccia 
ORDER BY nom ASC;

SELECT COUNT(*) AS total_ingredients 
FROM ingredient;

SELECT AVG(prix) AS prix_moyen 
FROM focaccia;

SELECT b.nom AS boisson, m.nom AS marque
FROM boisson b
JOIN marque m ON b.id_marque = m.id_marque
ORDER BY b.nom;

SELECT i.nom
FROM ingredient i
JOIN comprend c ON i.id_ingredient = c.id_ingredient
JOIN focaccia f ON c.id_focaccia = f.id_focaccia
WHERE f.nom = 'Raclanaccia';

SELECT f.nom, COUNT(c.id_ingredient) AS nombre_ingredients
FROM focaccia f
JOIN comprend c ON f.id_focaccia = c.id_focaccia
GROUP BY f.nom;

SELECT f.nom
FROM focaccia f
JOIN comprend c ON f.id_focaccia = c.id_focaccia
GROUP BY f.id_focaccia
ORDER BY COUNT(c.id_ingredient) DESC
LIMIT 1;

SELECT f.nom
FROM focaccia f
JOIN comprend c ON f.id_focaccia = c.id_focaccia
JOIN ingredient i ON c.id_ingredient = i.id_ingredient
WHERE i.nom = 'Ail';

SELECT nom
FROM ingredient
WHERE id_ingredient NOT IN (SELECT id_ingredient FROM comprend);

SELECT nom
FROM focaccia
WHERE id_focaccia NOT IN (
    SELECT id_focaccia 
    FROM comprend c 
    JOIN ingredient i ON c.id_ingredient = i.id_ingredient 
    WHERE i.nom = 'Champignon'
);