create table E_service(
    Nom varchar2(100) not null,
    code NUMBER,
    N_tel varchar2(40),
    primary key(code)
);


create table E_personnel
(   
    poste     VARCHAR(50)         not null,
    num_INSEE   INT           not null,
    nom       VARCHAR(40)        not null,
    prénom    VARCHAR(40)        not null,
    N_tel   VARCHAR(30)              not null,
    adresse  VARCHAR(100)         not null,
    supérieur INT    ,
    primary key(num_INSEE),
    FOREIGN KEY(supérieur)  REFERENCES E_personnel(num_INSEE)
);

create table E_pathologie
(
    pathologie_code int,
    pathologie_nom VARCHAR(100),
    primary key(pathologie_code)
);



create table E_patients
(
    num_INSEE int          not null,
    nom VARCHAR(40) not null,
    prénom VARCHAR(40) not null,
    N_tel VARCHAR(30)   not null,
    adresse VARCHAR(100) not null,
    code_service NUMBER not null,
    date_arrivee DATE NOT null, 
    date_sortie DATE NOT NULL,
    per_INSEE INT ,
    primary key (num_INSEE),
    FOREIGN KEY(code_service) REFERENCES E_SERVICE(code)
);
CREATE TABLE E_souffrir
( 
    num_INSEE   INT           not null,
    path_code int not null,   
    FOREIGN KEY(path_code) REFERENCES E_pathologie(pathologie_code),
    FOREIGN KEY(num_INSEE) REFERENCES E_patients(num_INSEE),
    CONSTRAINT pk_souffrir PRIMARY KEY(num_INSEE,path_code)
);

create table E_SALLE
(
    numero_salle   INT,      
    volume_salle    real      not null,
    taux_occupation real       not null,
    code NUMBER ,
    FOREIGN KEY(code) REFERENCES E_SERVICE(code),
    CONSTRAINT pk_salle PRIMARY KEY(numero_salle,code)
);

CREATE TABLE E_soins
(
    nom VARCHAR(40) NOT NULL,
    code INT NOT NULL,
    FOREIGN KEY(code) REFERENCES E_pathologie(pathologie_code),
    primary key (nom)
);

create table E_affecter
(
    i_insee int not null,
    code NUMBER not null,
    FOREIGN KEY(i_insee) REFERENCES E_personnel(num_INSEE),
    FOREIGN KEY(code) REFERENCES E_service(code),
    CONSTRAINT pk_aff PRIMARY KEY(i_insee,code)
);

create table E_intervention
(
    num_INSEE   INT       not null,
    nom VARCHAR(40) NOT NULL,
    numero_salle int,
    code NUMBER,
    date_intervention DATE,
    
    resultat VARCHAR(5) CHECK (resultat in ('oui','non')),
    patient_INSEE int not null,
    cout REAL,
    FOREIGN KEY (num_INSEE)  REFERENCES  E_personnel(num_INSEE),
    FOREIGN KEY (nom)  REFERENCES E_soins(nom),
    FOREIGN KEY(patient_INSEE) REFERENCES E_patients(num_INSEE),
    CONSTRAINT  Fk_pro1 FOREIGN KEY (numero_salle,code)  REFERENCES E_SALLE(numero_salle,code),
    CONSTRAINT PK_inter1 PRIMARY KEY (num_INSEE,nom,numero_salle,code)
);

