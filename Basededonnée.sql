CREATE DATABASE Parking; 
CREATE TABLE Utilisateur (
  NumUtilisateur int PRIMARY KEY,
  NomClient Varchar(255), 
  PrénomClient Varchar(255),
  AdresseClient Varchar(255),
  CdClient Varchar (255), 
  MdpClient Varchar (255), 
  EmailClient Varchar (255,
);

CREATE TABLE Réservation (
  NumReservation int PRIMARY KEY, 
  StatuReser Varchar(255), 
  DateReservation int,
  HeureExpiration int,
); 

CREATE TABLE Place (
  NumPlace int PRIMARY KEY, 
  PlaceStatu Varchar (255), 

  CONSTRAINT fk_Utilisateur
    FOREIGN KEY (NumUtilisateur),
    REFERENCES Utilisateur(NumUtilisateur) 

  CONSTRAINT fk_Réservation
    FOREIGN KEY (NumReservation), 
);
