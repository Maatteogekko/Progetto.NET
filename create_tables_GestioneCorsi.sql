CREATE DATABASE GestioneCorsi;
GO
USE GestioneCorsi;
CREATE TABLE Persone (
    ID INT IDENTITY, 
    NOME NVARCHAR(50) NOT NULL,
    COGNOME NVARCHAR(50) NOT NULL,
    DATA_DI_NASCITA DATE NOT NULL,
    CF CHAR(16) NOT NULL,
    SESSO CHAR(1) NOT NULL,
    CITTA_RESIDENZA NVARCHAR(50) NOT NULL,
    EMAIL NVARCHAR(60) NOT NULL,
    TELEFONO BIGINT NOT NULL,
    PARTITA_IVA NVARCHAR(11),
    ID_AZIENDA INT,
    RUOLO INT NOT NULL,
    CONSTRAINT chk_ruolo CHECK (RUOLO IN ('Studente', 'Insegnante')),
    CONSTRAINT chk_sesso CHECK (SESSO IN ('M', 'F')),
    PRIMARY KEY(ID)
);
CREATE TABLE Livelli (
    ID INT IDENTITY,
    DESCRIZIONE NVARCHAR(255),
    TIPO NVARCHAR(30) NOT NULL,
    PRIMARY KEY(ID)
);
CREATE TABLE Aziende (
    ID INT IDENTITY,
    NOME NVARCHAR(50) NOT NULL,
    CITTA NVARCHAR(30) NOT NULL,
    INDIRIZZO NVARCHAR(50) NOT NULL,
    CP NVARCHAR(7) NOT NULL,
    TELEFONO NVARCHAR(10) NOT NULL,
    EMAIL NVARCHAR(30) NOT NULL,
    PARTITA_IVA NVARCHAR(11) NOT NULL,
    PRIMARY KEY(ID)
);
CREATE TABLE Progetti (
    ID INT IDENTITY,
    TITOLO NVARCHAR(30) NOT NULL,
    DESCRIZIONE NVARCHAR(255) NOT NULL,
    ID_AZIENDA INT,
    PRIMARY KEY(ID),
    FOREIGN KEY(ID_AZIENDA) REFERENCES Aziende(ID)
);
CREATE TABLE Categorie (
    ID INT IDENTITY,
    TIPO NVARCHAR(20) NOT NULL,
    DESCRIZIONE NVARCHAR(255),
    CONSTRAINT chk_tipo CHECK (TIPO IN ('Introduttivo', 'Intermedio', 'Avanzato', 'Guru')),
    PRIMARY KEY(ID)
);
CREATE TABLE Corsi (
    ID INT IDENTITY,
    TITOLO NVARCHAR(50) NOT NULL,
    DESCRIZIONE NVARCHAR(255) NOT NULL,
    AMMONTARE_ORE INT NOT NULL,
    COSTO_DI_RIFERIMENTO MONEY NOT NULL,
    ID_LIVELLO INT,
    ID_PROGETTO INT,
    ID_CATEGORIA INT,
    PRIMARY KEY(ID),
    FOREIGN KEY(ID_LIVELLO) REFERENCES Livelli(ID),
    FOREIGN KEY(ID_PROGETTO) REFERENCES Progetti(ID),
    FOREIGN KEY(ID_CATEGORIA) REFERENCES Categorie(ID),
);
CREATE TABLE Aule (
    ID INT IDENTITY,
    NOME NVARCHAR(50) NOT NULL,
    CAPACITA_MAX INT NOT NULL,
    FISICA_VIRTUALE BIT NOT NULL,
    COMPUTERIZZATA BIT,
    PROIETTORE BIT,
    PRIMARY KEY(ID)
);
CREATE TABLE Enti_Finanziatori (
    ID INT IDENTITY,
    TITOLO NVARCHAR(50) NOT NULL,
    DESCRIZIONE NVARCHAR(255),
    PRIMARY KEY(ID)
);
CREATE TABLE Edizioni (
    ID INT IDENTITY,
    CODICE_EDIZIONE NVARCHAR(20) NOT NULL,
    DATA_INIZIO DATE NOT NULL,
    DATA_FINE DATE NOT NULL,
    PREZZO_FINALE MONEY NOT NULL,
    NUMERO_MAX_STUDENTI INT NOT NULL,
    IN_PRESENZA BIT NOT NULL,
    ID_AULA INT,
    ID_CORSO INT,
    ID_FINANZIATORE INT,
    PRIMARY KEY(ID),
    FOREIGN KEY(ID_AULA) REFERENCES Aule(ID),
    FOREIGN KEY(ID_CORSO) REFERENCES Corsi(ID),
    FOREIGN KEY(ID_FINANZIATORE) REFERENCES Enti_Finanziatori(ID)
);
CREATE TABLE Moduli (
    ID INT IDENTITY,
    NOME NVARCHAR(50) NOT NULL,
    AMMONTARE_ORE INT NOT NULL,
    DESCRIZIONE NVARCHAR(255),
    ID_DOCENTE INT,
    ID_EDIZIONE INT,
    FOREIGN KEY (ID_DOCENTE) REFERENCES Persone(ID),
    FOREIGN KEY (ID_EDIZIONE) REFERENCES Edizioni(ID),
    PRIMARY KEY(ID)
);
CREATE TABLE Lezioni (
    ID INT IDENTITY,
    ORA_INIZIO TIME NOT NULL,
    ORA_FINE TIME NOT NULL,
    ID_AULA INT,
    ID_DOCENTE INT,
    ID_MODULO INT,
    DESCRIZIONE NVARCHAR(255),
    FOREIGN KEY(ID_AULA) REFERENCES Aule(ID),
    FOREIGN KEY(ID_DOCENTE) REFERENCES Persone(ID),
    FOREIGN KEY(ID_MODULO) REFERENCES Moduli(ID),
    PRIMARY KEY(ID)
);
CREATE TABLE Iscrizioni (
    ID INT IDENTITY,
    DATA_ISCRIZIONE DATE NOT NULL,
    VALUTAZIONE_CORSO NVARCHAR(255),
    VOTO_CORSO INT NOT NULL,
    VALUTAZIONE_STUDENTE INT NOT NULL,
    PAGATA BIT NOT NULL,
    ID_STUDENTE INT,
    ID_EDIZIONE INT,
    CONSTRAINT chk_voto CHECK (VOTO_CORSO >=0 AND VOTO_CORSO <=10),
    CONSTRAINT chk_valutazione_studente CHECK (VALUTAZIONE_STUDENTE >=0 AND VALUTAZIONE_STUDENTE <=10),
    PRIMARY KEY(ID),
    FOREIGN KEY(ID_STUDENTE) REFERENCES Persone(ID),
    FOREIGN KEY(ID_EDIZIONE) REFERENCES Edizioni(ID),
);
CREATE TABLE Skills (
    ID INT IDENTITY,
    NOME NVARCHAR(50) NOT NULL,
    DESCRIZIONE NVARCHAR(255),
    ID_CATEGORIA INT,
    PRIMARY KEY(ID),
    FOREIGN KEY(ID_CATEGORIA) REFERENCES Categorie(ID),
);
CREATE TABLE Competenze (
    ID INT IDENTITY,
    NOTE NVARCHAR(255),
    ID_PERSONA INT,
    ID_SKILL INT,
    ID_LIVELLO INT,
    FOREIGN KEY(ID_PERSONA) REFERENCES Persone(ID),
    FOREIGN KEY(ID_SKILL) REFERENCES Skills(ID),
    FOREIGN KEY(ID_LIVELLO) REFERENCES Livelli(ID),
    PRIMARY KEY(ID)
);
CREATE TABLE Presenze (
    ID INT IDENTITY,
    ORA_INIZIO TIME NOT NULL,
    ORA_FINE TIME NOT NULL,
    ID_STUDENTE INT,
    ID_LEZIONE INT,
    NOTA NVARCHAR(255),
    PRIMARY KEY(ID),
    FOREIGN KEY(ID_LEZIONE) REFERENCES Lezioni(ID),
    FOREIGN KEY(ID_STUDENTE) REFERENCES Persone(ID),
);



