CREATE DATABASE gestione_corsi;
GO
USE gestione_corsi;
CREATE TABLE persone (
    id INT IDENTITY, 
    name NVARCHAR(50) NOT NULL,
    surname NVARCHAR(50) NOT NULL,
    data_di_nascita DATE NOT NULL,
    cf CHAR(16) NOT NULL,
    sesso CHAR(1) NOT NULL,
    citta_residenza NVARCHAR(50) NOT NULL,
    email NVARCHAR(60) NOT NULL,
    telefono BIGINT NOT NULL,
    partita_iva NVARCHAR(11),
    id_azienda INT,
    ruolo INT NOT NULL,
    CONSTRAINT chk_ruolo CHECK (ruolo IN ('Studente', 'Insegnante')),
    CONSTRAINT chk_sesso CHECK (sesso IN ('M', 'F')),
    PRIMARY KEY(id)
);
CREATE TABLE livelli (
    id INT IDENTITY,
    descrizione NVARCHAR(255),
    tipo NVARCHAR(30) NOT NULL,
    PRIMARY KEY(id)
);
CREATE TABLE aziende (
    id INT IDENTITY,
    nome NVARCHAR(50) NOT NULL,
    citta NVARCHAR(30) NOT NULL,
    indirizzo NVARCHAR(50) NOT NULL,
    cp NVARCHAR(7) NOT NULL,
    telefono NVARCHAR(10) NOT NULL,
    email NVARCHAR(30) NOT NULL,
    partita_iva NVARCHAR(11) NOT NULL,
    PRIMARY KEY(id)
);
CREATE TABLE progetti (
    id INT IDENTITY,
    titolo NVARCHAR(30) NOT NULL,
    descrizione NVARCHAR(255) NOT NULL,
    id_azienda INT,
    PRIMARY KEY(id),
    FOREIGN KEY(id_azienda) REFERENCES aziende(id)
);
CREATE TABLE categorie (
    id INT IDENTITY,
    tipo NVARCHAR(20) NOT NULL,
    descrizione NVARCHAR(255),
    CONSTRAINT chk_tipo CHECK (tipo IN ('Introduttivo', 'Intermedio', 'Avanzato', 'Guru')),
    PRIMARY KEY(id)
);
CREATE TABLE corsi (
    id INT IDENTITY,
    titolo NVARCHAR(50) NOT NULL,
    descrizione NVARCHAR(255) NOT NULL,
    ammontare_ore INT NOT NULL,
    costo_di_riferimento MONEY NOT NULL,
    id_livello INT,
    id_progetto INT,
    id_categoria INT,
    PRIMARY KEY(id),
    FOREIGN KEY(id_livello) REFERENCES livelli(id),
    FOREIGN KEY(id_progetto) REFERENCES progetti(id),
    FOREIGN KEY(id_categoria) REFERENCES categorie(id),
);
CREATE TABLE aule (
    id INT IDENTITY,
    nome NVARCHAR(50) NOT NULL,
    capacita_max INT NOT NULL,
    fisica_virtuale BIT NOT NULL,
    computerizzata BIT,
    proiettore BIT,
    PRIMARY KEY(id)
);
CREATE TABLE enti_finanziatori (
    id INT IDENTITY,
    titolo NVARCHAR(50) NOT NULL,
    descrizione NVARCHAR(255),
    PRIMARY KEY(id)
);
CREATE TABLE edizioni (
    id INT IDENTITY,
    codice_edizione NVARCHAR(20) NOT NULL,
    data_inizio DATE NOT NULL,
    data_fine DATE NOT NULL,
    prezzo_finale MONEY NOT NULL,
    numero_max_studenti INT NOT NULL,
    in_presenza BIT NOT NULL,
    id_aula INT,
    id_corso INT,
    id_finanziatore INT,
    PRIMARY KEY(id),
    FOREIGN KEY(id_aula) REFERENCES aule(id),
    FOREIGN KEY(id_corso) REFERENCES Corsi(id),
    FOREIGN KEY(id_finanziatore) REFERENCES enti_finanziatori(id)
);
CREATE TABLE moduli (
    id INT IDENTITY,
    nome NVARCHAR(50) NOT NULL,
    ammontare_ore INT NOT NULL,
    descrizione NVARCHAR(255),
    id_docente INT,
    id_edizione INT,
    FOREIGN KEY (id_docente) REFERENCES persone(id),
    FOREIGN KEY (id_edizione) REFERENCES edizioni(id),
    PRIMARY KEY(id)
);
CREATE TABLE lezioni (
    id INT IDENTITY,
    ora_inizio TIME NOT NULL,
    ora_fine TIME NOT NULL,
    id_aula INT,
    id_docente INT,
    id_modulo INT,
    descrizione NVARCHAR(255),
    FOREIGN KEY(id_aula) REFERENCES aule(id),
    FOREIGN KEY(id_docente) REFERENCES persone(id),
    FOREIGN KEY(id_modulo) REFERENCES moduli(id),
    PRIMARY KEY(id)
);
CREATE TABLE iscrizioni (
    id INT IDENTITY,
    data_iscrizione DATE NOT NULL,
    valutazione_corso NVARCHAR(255),
    voto_corso INT NOT NULL,
    valutazione_studente INT NOT NULL,
    pagata BIT NOT NULL,
    id_studente INT,
    id_edizione INT,
    CONSTRAINT chk_voto CHECK (voto_corso >=0 AND voto_corso <=10),
    CONSTRAINT chk_valutazione_studente CHECK (valutazione_studente >=0 AND valutazione_studente <=10),
    PRIMARY KEY(id),
    FOREIGN KEY(id_studente) REFERENCES persone(id),
    FOREIGN KEY(id_edizione) REFERENCES edizioni(id),
);
CREATE TABLE skills (
    id INT IDENTITY,
    nome NVARCHAR(50) NOT NULL,
    descrizione NVARCHAR(255),
    id_categoria INT,
    PRIMARY KEY(id),
    FOREIGN KEY(id_categoria) REFERENCES categorie(id),
);
CREATE TABLE competenze (
    id INT IDENTITY,
    note NVARCHAR(255),
    id_persona INT,
    id_skill INT,
    id_livello INT,
    FOREIGN KEY(id_persona) REFERENCES persone(id),
    FOREIGN KEY(id_skill) REFERENCES skills(id),
    FOREIGN KEY(id_livello) REFERENCES livelli(id),
    PRIMARY KEY(id)
);
CREATE TABLE presenze (
    id INT IDENTITY,
    ora_inizio TIME NOT NULL,
    ora_fine TIME NOT NULL,
    id_studente INT,
    id_lezione INT,
    nota NVARCHAR(255),
    PRIMARY KEY(id),
    FOREIGN KEY(id_lezione) REFERENCES lezioni(id),
    FOREIGN KEY(id_studente) REFERENCES persone(id),
);



