/*Question 1*/
SET SERVEROUTPUT ON;

DROP TABLE Detailsemprunts;
DROP TABLE Exemplaires;
DROP TABLE Ouvrages;
DROP TABLE Genres;
DROP TABLE Emprunts;
DROP TABLE Membres;

CREATE TABLE Genres (
    code CHAR(5),
    libelle VARCHAR2(80) NOT NULL,
    CONSTRAINT PK_Genres_code PRIMARY KEY (code)
);
CREATE TABLE Ouvrages (
    isbn NUMBER(10) CONSTRAINT PK_Ouvrages_isbn PRIMARY KEY,
    titre VARCHAR2(200) NOT NULL,
    auteur VARCHAR2(80),
    genre CHAR(5) NOT NULL,
    editeur VARCHAR2(80)
);
CREATE TABLE Exemplaires (
    isbn NUMBER(10),
    numero NUMBER(3),
    etat CHAR(5) CONSTRAINT check_Exemplaires_etat CHECK (etat in ('NE', 'BO', 'MO', 'MA')),
    CONSTRAINT PK_Exemplaires_isbn PRIMARY KEY (isbn,numero)
);
CREATE TABLE Membres(
     numero NUMBER(6)CONSTRAINT PK_Membres_numero PRIMARY KEY,
     nom VARCHAR2(80) NOT NULL,
     prenom VARCHAR2(80) NOT NULL,
     adresse VARCHAR2(200) NOT NULL,
     telephone CHAR(10) NOT NULL,
     adhesion DATE NOT NULL,
     duree NUMBER(2) NOT NULL CONSTRAINT check_duree CHECK (duree in (1, 3, 6, 12))
);
CREATE TABLE Emprunts(
     numero NUMBER(10) CONSTRAINT PK_Emprunts_numero PRIMARY KEY,
     membre NUMBER(6),
     creele DATE DEFAULT SYSDATE
);
CREATE TABLE Detailsemprunts(
     emprunt NUMBER(10),
     numero NUMBER(3),
     isbn NUMBER(10),
     exemplaire NUMBER(3),
     rendule DATE,
     CONSTRAINT PK_Detailsemprunts_emprunt PRIMARY KEY(emprunt, numero)
);
/*Contraintes*/
ALTER TABLE Ouvrages add constraint fk_ouvrage FOREIGN KEY (genre) REFERENCES Genres(code);
ALTER TABLE Exemplaires add constraint fk_exemplaire FOREIGN KEY (isbn) REFERENCES Ouvrages(isbn);
ALTER TABLE Emprunts add constraint fk_emprunts FOREIGN KEY(membre) REFERENCES Membres(numero);
ALTER TABLE Detailsemprunts add constraint fk_Detailsemprunts_1 FOREIGN KEY (emprunt) REFERENCES Emprunts(numero);
ALTER TABLE Detailsemprunts add constraint fk_Detailsemprunts_2 FOREIGN KEY (isbn,numero) REFERENCES Exemplaires(isbn,numero);
ALTER TABLE Detailsemprunts add constraint fk_Detailsemprunts_3 FOREIGN KEY (isbn) REFERENCES Ouvrages(isbn);
COMMIT;
-----------------------------------------------------------------------------------------------------------------------------------
/*Question2*/
/*Le séquence démarre à 1 et s'incrémente de 1*/
CREATE SEQUENCE seq_membres START WITH 1 INCREMENT BY 1;

-------------CREATTION--TRIGGER--------------------------------
CREATE OR REPLACE TRIGGER before_insert_membres
BEFORE insert ON Membres for each row
BEGIN
    /*Membres.numero prend la prochaine valeur de la séquence*/
    SELECT seq_membres.nextval INTO :new.numero from dual;
    :new.numero := :new.numero;
    EXCEPTION
        WHEN OTHERS THEN
          /*Affiche null en cas d'erreur*/
          NULL;
END;
-----------------------------------------------------------------------------------------------------------------------
/*Question3*/
/*Suppression des clés étrangères*/
ALTER TABLE DetailsEmprunts
DROP CONSTRAINT fk_Detailsemprunts_1;

ALTER TABLE DetailsEmprunts
DROP CONSTRAINT fk_Detailsemprunts_2;

ALTER TABLE DetailsEmprunts
DROP CONSTRAINT fk_Detailsemprunts_3;

/*Ajout d'une contrainte en cascade*/
ALTER TABLE DetailsEmprunts
ADD CONSTRAINT fk_detail_emprunts 
    FOREIGN KEY(emprunt)
    REFERENCES Emprunts(numero)
    ON DELETE CASCADE;
--------------------------------------------------------------------------------------------------------------------
    /*Question4*/
    /*Remplir la table Genres*/
    INSERT into Genres VALUES ('REC','Récit');
    INSERT into Genres VALUES ('POL','Policier');
    INSERT into Genres VALUES ('BD','Bande Dessinée');
    INSERT into Genres VALUES ('INF','Informatique');
    INSERT into Genres VALUES ('THE','Théâtre');
    INSERT into Genres VALUES ('ROM','Roman');
    /*Remplir la table Ouvrages*/
    INSERT into Ouvrages VALUES (2203314168,'LEFRANC-L''ultimatum','Martin, Carin','BD','Casterman');
    INSERT into Ouvrages VALUES (2746021285,'HTML entraînez-vous pour maîtriser le code source','Luc Van Lancker','INF','ENI');
    INSERT into Ouvrages VALUES (2746026090,'Oracle 12c SQL, PL/SQL,SQL*Plus ','J. Gabillaud','INF','ENI');
    INSERT into Ouvrages VALUES (2266085816,'Pantagruel','François RABELAIS','ROM','POCKET');
    INSERT into Ouvrages VALUES (2266091611,'Voyage au centre de la terre','Jules Verne','ROM','POCKET');
    INSERT into Ouvrages VALUES (2253010219,'Le crime de l''Orient Express','Agatha Christie','POL','Livre de Poche');
    INSERT into Ouvrages VALUES (2070400816,'Le Bourgeois gentilhomme','Moliere','THE','Gallimard');
    INSERT into Ouvrages VALUES (2070367177,'Le curé de Tours','Honoré de Balzac','ROM','Gallimard');
    INSERT into Ouvrages VALUES (2080720872,'Boule de suif','Guy de Maupassant','REC','Flammarion');
    INSERT into Ouvrages VALUES (2877065073,'La gloire de mon père','Marcel Pagnol','ROM','Fallois');
    INSERT into Ouvrages VALUES (2020549522,'L''aventure des manuscrits de la mer morte','NULL','REC','Seuil');
    INSERT into Ouvrages VALUES (2253006327,'Vingt mille lieues sous les mers','Jules Verne','ROM','LGF');
    INSERT into Ouvrages VALUES (2038704015,'De la terre à la lune','Jules Verne','ROM','Larousse');
  /*Remplir la table Exemplaires*/
    INSERT into Exemplaires VALUES (2203314168,1,'MO');
    INSERT into Exemplaires VALUES (2746021285,1,'BO');
    INSERT into Exemplaires VALUES (2746026090,1,'BO');
    INSERT into Exemplaires VALUES (2266085816,1,'BO');
    INSERT into Exemplaires VALUES (2266091611,1,'BO');
    INSERT into Exemplaires VALUES (2253010219,1,'BO');
    INSERT into Exemplaires VALUES (2070400816,1,'BO');
    INSERT into Exemplaires VALUES (2070367177,1,'BO');
    INSERT into Exemplaires VALUES (2080720872,1,'BO');
    INSERT into Exemplaires VALUES (2877065073,1,'BO');
    INSERT into Exemplaires VALUES (2020549522,1,'BO');
    INSERT into Exemplaires VALUES (2253006327,1,'BO');
    INSERT into Exemplaires VALUES (2038704015,1,'BO');
    INSERT into Exemplaires VALUES (2203314168,2,'BO');
    INSERT into Exemplaires VALUES (2746026090,2,'MO');
    INSERT into Exemplaires VALUES (2266085816,2,'MO');
    INSERT into Exemplaires VALUES (2266091611,2,'MO');
    INSERT into Exemplaires VALUES (2253010219,2,'MO');
    INSERT into Exemplaires VALUES (2070400816,2,'MO');
    INSERT into Exemplaires VALUES (2070367177,2,'MO');
    INSERT into Exemplaires VALUES (2080720872,2,'MO');
    INSERT into Exemplaires VALUES (2877065073,2,'MO');
    INSERT into Exemplaires VALUES (2020549522,2,'MO');
    INSERT into Exemplaires VALUES (2253006327,2,'MO');
    INSERT into Exemplaires VALUES (2038704015,2,'MO');
    INSERT into Exemplaires VALUES (2203314168,3,'NE');
/*Remplir la table Membres*/
    INSERT into Membres VALUES (1,'ALBERT','Anne','13 rue des alpes',0601020304,TO_DATE('17-01-19 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),1);
    INSERT into Membres VALUES (2,'BERNAUD','Barnabé','6 rue des bécasses',0602030105,TO_DATE('17-03-10 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),3);
    INSERT into Membres VALUES (3,'CUVARD','Camille','52 rue des cerisiers',0602010509,TO_DATE('16-12-10 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),6);
    INSERT into Membres VALUES (4,'DUPOND','Daniel','11 rue des daims',0610236515,TO_DATE('16-07-13 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),12);
    INSERT into Membres VALUES (5,'EVROUX','Eglantine','34 rue des elfes',0658963125,TO_DATE('16-10-21 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),6);
    INSERT into Membres VALUES (6,'FREGEON','Fernand','11 rue des Francs',0602036987,TO_DATE('16-02-14 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),6);
    INSERT into Membres VALUES (7,'GORIT','Gaston','96 rue de la glacerie',0684235781,TO_DATE('16-10-21 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),1);
    INSERT into Membres VALUES (8,'HEVARD','Hector','12 rue haute',0608546578,TO_DATE('16-07-13 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),12);
    INSERT into Membres VALUES (9,'INGRAND','Irène','54 rue des iris',0605020409,TO_DATE('17-01-29 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),12);
    INSERT into Membres VALUES (10,'JUSTE','Julien','5 place des Jacobins',0603069876,TO_DATE('16-12-10 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),6);
/*Remplir la table Emprunts*/
    INSERT into Emprunts VALUES (1,1,TO_DATE('16-09-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Emprunts VALUES (2,3,TO_DATE('16-09-11 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Emprunts VALUES (3,4,TO_DATE('16-09-21 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Emprunts VALUES (4,1,TO_DATE('16-10-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Emprunts VALUES (5,5,TO_DATE('16-10-11 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Emprunts VALUES (6,2,TO_DATE('16-10-21 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Emprunts VALUES (7,4,TO_DATE('16-10-31 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Emprunts VALUES (8,1,TO_DATE('16-11-10 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Emprunts VALUES (9,9,TO_DATE('16-11-20 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Emprunts VALUES (10,6,TO_DATE('16-11-30 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Emprunts VALUES (11,1,TO_DATE('16-12-10 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Emprunts VALUES (12,6,TO_DATE('16-12-20 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Emprunts VALUES (13,2,TO_DATE('16-12-30 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Emprunts VALUES (14,4,TO_DATE('17-01-09 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Emprunts VALUES (15,1,TO_DATE('17-01-19 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Emprunts VALUES (16,3,TO_DATE('17-01-29 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Emprunts VALUES (17,1,TO_DATE('17-02-08 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Emprunts VALUES (18,5,TO_DATE('17-02-18 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Emprunts VALUES (19,4,TO_DATE('17-02-28 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Emprunts VALUES (20,1,TO_DATE('17-03-10 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
/*Remplir la table Detailsemprunts*/
    INSERT into Detailsemprunts VALUES (1,1,2038704015,1,TO_DATE('16-09-06 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (1,2,2070367177,2,TO_DATE('16-09-11 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (2,1,2080720872,1,TO_DATE('16-09-21 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (2,2,2203314168,1,TO_DATE('16-09-22 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (3,1,2038704015,1,TO_DATE('16-10-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (4,1,2203314168,2,TO_DATE('16-10-16 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (4,2,2080720872,1,TO_DATE('16-10-16 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (4,3,2266085816,1,TO_DATE('16-10-12 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (5,1,2038704015,1,TO_DATE('16-10-31 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (6,1,2266085816,2,TO_DATE('16-10-30 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (6,2,2080720872,2,TO_DATE('16-11-10 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (6,3,2746021285,1,TO_DATE('16-11-07 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (7,1,2070367177,2,TO_DATE('16-12-10 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (8,1,2080720872,1,TO_DATE('16-11-24 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (9,1,2038704015,1,TO_DATE('16-12-10 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (10,1,2080720872,2,TO_DATE('16-12-03 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (10,2,2746026090,1,TO_DATE('17-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (11,1,2746021285,1,TO_DATE('16-12-29 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (12,1,2203314168,1,TO_DATE('16-09-24 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (12,2,2038704015,1,TO_DATE('17-01-19 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (13,1,2070367177,1,TO_DATE('17-01-14 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (14,1,2266091611,1,TO_DATE('17-01-13 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (15,1,2070400816,1,TO_DATE('17-01-29 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (16,1,2253010219,2,TO_DATE('17-02-07 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (16,2,2070367177,2,TO_DATE('17-02-07 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (17,1,2877065073,2,TO_DATE('17-02-12 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (18,1,2070367177,1,TO_DATE('17-03-06 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (19,1,2746026090,1,TO_DATE('17-03-08 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    INSERT into Detailsemprunts VALUES (20,1,2266091611,1,NULL);
    INSERT into Detailsemprunts VALUES (20,2,2253010219,1,NULL);
--------------------------------------------------------------------------------------------------------------------------


/*Question5*/
INSERT INTO Ouvrages VALUES(2080703234,'Cinq semaines en ballon','Jules Verne','ROM','Flammarion');
--------------------------------------------------------------------------------------------------------------------------


/*Questions 6*/
ALTER TABLE Emprunts
ADD(etat CHAR(2) DEFAULT 'EC');
--------------------------------------------------------------------------------------------------------------------------


/*Questions 7*/
ALTER TABLE Emprunts
ADD CONSTRAINT ck_emprunts_etat CHECK(etat IN ('EC','RE'));
--------------------------------------------------------------------------------------------------------------------------


/*Questions 8*/
UPDATE emprunts e
   SET e.etat = 'RE'
 WHERE EXISTS 
       (SELECT exemplaire
          FROM detailsemprunts d
         JOIN emprunts e
         on e.numero=d.numero
         WHERE d.exemplaire=0);
UPDATE emprunts e
   SET e.etat = 'EC'
 WHERE EXISTS 
       (SELECT exemplaire
          FROM detailsemprunts d
         JOIN emprunts e
         on e.numero=d.numero
         WHERE d.exemplaire <>0);
----------------------------------------------------------------------------------------------------------------------------------


/*Questions 9*/
INSERT INTO DetailsEmprunts VALUES (7,2,2038704015,1,sysdate-136);
INSERT INTO DetailsEmprunts VALUES (8,2,2038704015,1,sysdate-127);
INSERT INTO DetailsEmprunts VALUES (11,2,2038704015,1,sysdate-95);
INSERT INTO DetailsEmprunts VALUES (15,2,2038704015,1,sysdate-54);
INSERT INTO DetailsEmprunts VALUES (16,3,2038704015,1,sysdate-43);
INSERT INTO DetailsEmprunts VALUES (17,2,2038704015,1,sysdate-36);
INSERT INTO DetailsEmprunts VALUES (18,2,2038704015,1,sysdate-24);
INSERT INTO DetailsEmprunts VALUES (19,2,2038704015,1,sysdate-13);
INSERT INTO DetailsEmprunts VALUES (20,3,2038704015,1,sysdate-3);
------------------------------------------------------------------------------------------------------------------------------------


/*Question10*/
UPDATE Exemplaires
SET etat = 'NE'
WHERE numero = 1 and isbn = 2038704015;
------------------------------------------------------------------------------------------------------------------------------------


/*Question11*/
declare 
cursor exemplaire_cursor is
select D.emprunt, D.isbn, D.numero from detailsemprunts D
       JOIN exemplaires e
        on e.isbn=d.isbn and e.numero=d.numero
        order by D.emprunt;
curs_count_emprunt number;
curs_isbn detailsemprunts.isbn%type;
curs_numero detailsemprunts.numero%type;                            
begin
open exemplaire_cursor;
fetch exemplaire_cursor into curs_count_emprunt, curs_isbn, curs_numero;
while exemplaire_cursor%found loop

if (curs_count_emprunt <=10) then 
update Exemplaires
set etat ='NE'
where curs_isbn= Exemplaires.isbn and curs_numero=Exemplaires.numero;
end if;
if (curs_count_emprunt BETWEEN 11 and 25) then 
update Exemplaires
set etat ='BO'
where curs_isbn= Exemplaires.isbn and curs_numero=Exemplaires.numero;
end if;
if (curs_count_emprunt BETWEEN 26 and 40) then 
update Exemplaires
set etat ='MO'
where curs_isbn= Exemplaires.isbn and curs_numero=Exemplaires.numero;
end if;
if (curs_count_emprunt> 40) then
update Exemplaires
set etat ='MA'
where curs_isbn= Exemplaires.isbn and curs_numero=Exemplaires.numero;
end if;
fetch exemplaire_cursor into curs_count_emprunt, curs_isbn, curs_numero;
end loop;
commit;
close exemplaire_cursor;
end;
-------------------------------------------------------------------------------------------------------------------


/*Question12*/
ALTER TABLE MEMBRES ADD(finAdhesion date as (ADD_MONTHS(adhesion,duree)));
-------------------------------------------------------------------------------------------------------------------


/*Question13*/
CREATE or replace function fct_finValidite(pnumero number) return VARCHAR2 is 
resul varchar2(50);
begin
select 'numero ' || numero || ':  date limite pour emprunter : ' || finadhesion into resul from
membres WHERE numero = pnumero;
return resul;
end fct_finValidite;


-----------TESTER-MA-FONCTION--------------------
SELECT fct_finValidite(1) FROM dual;
------------------------------------------------------------------------------------------------------------------------------------
/*Question14*/

CREATE or replace function fct_mesureActivite(pDate DATE) return number is 
                                                             nbOuvrage number;
BEGIN
select max(emprunt) as NOMBRE_MEMBRE_QUI_NA_PAS_RENDU_LIVRE
                   into nbOuvrage from detailsemprunts
                   where emprunt in (
                          select numero from emprunts 
                          where membre in (
                                select numero from membres 
                                where adhesion=pDate)
                                );
                  return (nbOuvrage);
end;
---------------------------------------------------------------------------------------------------------------
                 /*Question15*/

/*creation de la sequence seq_emprunts*/
create sequence seq_emprunts start with 21 increment by 1;
------------------------------------------------------------

/*creation de la procedure*/
create or replace procedure proc_empruntExpress(
                              numMembre in membres.numero%type,
                              isbn in exemplaires.isbn%type,
                              numExemplaires in exemplaires.numero%type
                              ) as numEmprunt number;
BEGIN
select seq_emprunts.nextval into numEmprunt from dual;
insert into emprunts (numero, membre, creele) values (numEmprunt, numMembre, sysdate);
insert into detailsemprunts (emprunt, numero, isbn, exemplaire) values (numEmprunt,1, isbn, numExemplaires);
end;

-------------------------------------------------------------------------------------------------------------------------

    /*Question16*/
create or replace function  fct_nbOuvNonRendus (numMembre int) 
                            return int 
                            is nonRendu int;

BEGIN
select count(*) as LIVRES_PAS_ENCORE_RENDU 
                   into nonRendu from detailsemprunts
                   where rendule is null and emprunt in (
                          select numero from emprunts 
                          where membre in (
                                select numero from membres 
                                where numero=numMembre)
                                );
                  return (nonRendu);
end;

---------------------------------------
SELECT fct_nbOuvNonRendus(1) FROM dual;
-------------------------------------------------------------------------------------------------------

         /*Question17*/

create or replace trigger validEmprunt
before insert or update 
on emprunts for each row 
declare 
dMax date;
begin
select finadhesion into dMax from membres
                    where numero=:new.numero;
                    if (dMax >= sysdate) then
                    delete from emprunts 
                    where membre=:new.numero;
                    end if;
end;

-----------TESTER-MON-TRIGGER------------------------
EXEC proc_empruntExpress(1,3001555800,1,TO_DATE('17-01-19 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
----------------------------------------------------------------------------------------------------------

       /*Question18*/
       
create or replace trigger noModificationemprunt
before update on emprunts 
for each row 
begin
if updating ('membre') then
raise_application_error(-20010, 'Vous ne pouvez pas changer le membre');
end if;
end;

-------TESTER-MON-TRIGGER-noModificationemprunt-------
UPDATE emprunts
   SET membre = 8
   WHERE numero=1;
----------------------------------------------------------------------------------------------
      
       /*Question19*/
       
create or replace trigger nouveauExemplaire
before insert or update on exemplaires
for each row 
begin
if INSERTING  then
raise_application_error(-20010, 'Vous devez d''abord definir ETAT du nouvel exemplaire');
ELSIF updating then
raise_application_error(-20010, 'Vous devez d''abord definir ETAT du nouvel exemplaire');
end if;
end;


--------TESTER-MON-TRIGGER-nouveauExemplaire---------
INSERT into Exemplaires VALUES (2203314168,1,'');
----------------------
update exemplaires
set numero =3
where isbn=2203314168;
--------------------------------------------------------------------------------------------------------