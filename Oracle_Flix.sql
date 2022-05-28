--Drop view if exist
DROP VIEW title_unavail;
--Drop all tables if they exist
DROP TABLE rental_history PURGE;
DROP TABLE customers PURGE;
DROP TABLE media PURGE;
DROP TABLE star_billings PURGE;
DROP TABLE movies PURGE;
DROP TABLE actors PURGE;
--drop the sequences
DROP SEQUENCE customer_id_seq;
DROP SEQUENCE title_id_seq;
DROP SEQUENCE media_id_seq;
DROP SEQUENCE actor_id_seq;
-- drop the synonym
DROP SYNONYM  tu;



--now create tables
--1. Create tables using the attached ERD. AND 2. Creating and Managing Constraints

CREATE TABLE  actors
   ( actor_id NUMBER(10,0) CONSTRAINT atr_atr_id_pk PRIMARY KEY ,
                stage_name VARCHAR2(40) CONSTRAINT atr_ste_nae_nn NOT NULL ,
                first_name VARCHAR2(25) CONSTRAINT atr_fit_nae_nn NOT NULL ,
                last_name VARCHAR2(25) CONSTRAINT atr_lat_nae_nn NOT NULL ,
                birth_date DATE CONSTRAINT atr_bih_dae_nn NOT NULL
   );
CREATE TABLE  movies
   ( title_id NUMBER(10,0) CONSTRAINT mie_tte_id_pk PRIMARY KEY ,
                title VARCHAR2(60) CONSTRAINT mie_tte_nn NOT NULL ,
                description VARCHAR2(400) CONSTRAINT mie_dsn_nn NOT NULL ,
                --rating VARCHAR2(4) CONSTRAINT atr_rig_chk CHECK (UPPER(rating) IN ('G', 'PG', 'R', 'PG13')),
                rating VARCHAR2(4) CONSTRAINT mie_rig_chk CHECK ( rating  IN ('G', 'PG', 'R', 'PG13')),
                category VARCHAR2(20) CONSTRAINT mie_cey_chk CHECK ( category  IN ('DRAMA', 'COMEDY', 'ACTION', 'CHILD', 'SCIFI', 'DOCUMENTARY')),
                --category VARCHAR2(20) CONSTRAINT atr_cey_chk CHECK ( UPPER(category)  IN ('DRAMA', 'COMEDY', 'ACTION', 'CHILD', 'SCIFI', 'DOCUMENTARY')),
                release_date DATE CONSTRAINT mie_rle_dae_nn NOT NULL
   );

   CREATE TABLE  star_billings
   ( actor_id NUMBER(10,0) CONSTRAINT str_big_atr_id_fk REFERENCES actors(actor_id) ,
                title_id NUMBER(10,0) CONSTRAINT str_big_tte_id_fk REFERENCES movies(title_id) ,
                comments VARCHAR2(40),
                CONSTRAINT str_big_atr_id_tte_id_pk PRIMARY KEY (actor_id, title_id)
   );


 CREATE TABLE  media
   ( media_id NUMBER(10,0) CONSTRAINT mda_mda_id_pk PRIMARY KEY ,
                format VARCHAR2(3) CONSTRAINT mda_fmt_nn NOT NULL ,
                title_id NUMBER(10,0) CONSTRAINT mda_tte_id_nn NOT NULL  ,
                CONSTRAINT mda_tte_id_fk FOREIGN KEY(title_id)  REFERENCES movies(title_id)
   );

 CREATE TABLE  customers
   ( customer_id NUMBER(10,0) CONSTRAINT ctr_ctr_id_pk PRIMARY KEY ,
                last_name VARCHAR2(25) CONSTRAINT ctr_lat_nae_nn NOT NULL ,
                first_name VARCHAR2(25) CONSTRAINT ctr_fit_nae_nn NOT NULL ,
                home_phone VARCHAR2(12) CONSTRAINT ctr_hoe_phe_nn NOT NULL ,
                address VARCHAR2(100) CONSTRAINT ctr_ads_nn NOT NULL ,
                city VARCHAR2(30) CONSTRAINT ctr_cyy_nn NOT NULL ,
                state VARCHAR2(2) CONSTRAINT ctr_ste_nn NOT NULL ,
                email VARCHAR2(25),
                cell_phone VARCHAR2(12)
   );

 CREATE TABLE  rental_history
   ( media_id NUMBER(10,0) CONSTRAINT ral_hty_mda_id_fk REFERENCES media(media_id) ,
                rental_date DATE DEFAULT SYSDATE ,
                customer_id NUMBER(10,0)  CONSTRAINT ral_hty_ctr_id_nn NOT NULL ,
                return_date DATE ,
                CONSTRAINT ral_hty_ctr_id_fk FOREIGN KEY(customer_id)  REFERENCES customers(customer_id),
                CONSTRAINT ral_hty_mda_id_ral_dae_pk PRIMARY KEY (media_id, rental_date)
   );

--3. Create a view called TITLE_UNAVAIL
CREATE OR REPLACE VIEW title_unavail ("movie title", "media id") AS
SELECT movies.title,  media.media_id
FROM
rental_history  INNER JOIN  media ON rental_history.media_id = media.media_id INNER JOIN movies ON media.title_id   = movies.title_id
WHERE rental_history.return_date IS NULL
WITH READ ONLY;

--4. Create the following sequences to be used for primary key values
CREATE SEQUENCE customer_id_seq
START WITH 101;
CREATE SEQUENCE title_id_seq;
CREATE SEQUENCE media_id_seq
START WITH 92;
CREATE SEQUENCE actor_id_seq
START WITH 1001;

--5. Add the data to the tables. Be sure to use the sequences for the PKs

INSERT INTO actors(actor_id, stage_name, first_name, last_name, birth_date)
VALUES(actor_id_seq.NEXTVAL, 'Ice Cube', 'Oshea', 'Jackson', TO_DATE('15-JUN-1969','DD-MON-YYYY'));
INSERT INTO actors(actor_id, stage_name, first_name, last_name, birth_date)
VALUES(actor_id_seq.NEXTVAL, 'Tyrin Turner', 'Tyrin', 'Turner', TO_DATE('17-07-1972','DD-MM-YYYY'));
INSERT INTO actors(actor_id, stage_name, first_name, last_name, birth_date)
VALUES(actor_id_seq.NEXTVAL, 'Tupac', 'Tupac', 'Shakur', TO_DATE('13 September 1996','DD Month YYYY'));
INSERT INTO actors(actor_id, stage_name, first_name, last_name, birth_date)
VALUES(actor_id_seq.NEXTVAL, 'Adam Sandler', 'Adam', 'Sandler', TO_DATE('09/09/1966','DD/MM/YYYY'));


INSERT INTO movies(title_id, title , description ,  rating , category , release_date )
VALUES(title_id_seq.NEXTVAL, 'Friday', 'It''s Friday, and Craig and Smokey must come up with $200 they owe a local bully or there won''t be a Saturday.', 'R', 'COMEDY',
       TO_DATE('26 April 1995','DD Month YYYY'));
INSERT INTO movies(title_id, title , description ,  rating , category , release_date )
VALUES(title_id_seq.NEXTVAL, 'Boyz N The Hood', 'Once upon a time in South Central L.A.','R', 'DRAMA',
       TO_DATE('12 July 1991','DD Month YYYY'));
INSERT INTO movies(title_id, title , description ,  rating , category , release_date )
VALUES(title_id_seq.NEXTVAL, 'Menace II Society', 'A young street hustler attempts to escape the rigors and temptations of the ghetto in a quest for a better life.', 'R', 'DRAMA',
  TO_DATE('26 May 1993','DD Month YYYY'));
INSERT INTO movies(title_id, title , description ,  rating , category , release_date )
VALUES(title_id_seq.NEXTVAL, 'Juice', 'Four inner-city teenagers get caught up in the pursuit of power and happiness, which they refer to as "the juice".', 'R', 'DRAMA',
  TO_DATE('17 January 1992','DD Month YYYY'));
INSERT INTO movies(title_id, title , description ,  rating , category , release_date )
VALUES(title_id_seq.NEXTVAL, 'Click', 'A workaholic architect finds a universal remote that allows him to fast-forward and rewind to different parts of his life. Complications arise when the remote starts to overrule his choices.', 'PG13', 'COMEDY',
  TO_DATE('23 June 2006','DD Month YYYY'));
INSERT INTO movies(title_id, title , description ,  rating , category , release_date )
VALUES(title_id_seq.NEXTVAL, 'Baby Driver', 'After being coerced into working for a crime boss, a young getaway driver finds himself taking part in a heist doomed to fail.', 'R', 'ACTION',
  TO_DATE('28 June 2017','DD Month YYYY'));


INSERT INTO star_billings(actor_id, title_id , comments)
VALUES(1001,1, 'as Craig Jones');
INSERT INTO star_billings(actor_id, title_id , comments)
VALUES(1001,2, 'as Doughboy');
INSERT INTO star_billings(actor_id, title_id , comments)
VALUES(1002,3, NULL);
INSERT INTO star_billings(actor_id, title_id , comments)
VALUES(1003,4, 'as Bishop');
INSERT INTO star_billings(actor_id, title_id , comments)
VALUES(1004,5, 'as Michael Newman');


INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'DVD',1);
INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'VHS',1);
INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'DVD',2);
INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'VHS',2);
INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'DVD',3);
INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'VHS',3);
INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'DVD',4);
INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'VHS',4);
INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'DVD',5);
INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'VHS',5);
INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'DVD',6);
INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'VHS',6);

INSERT INTO customers(customer_id, last_name, first_name,  home_phone, address, city, state, email,  cell_phone)
VALUES(customer_id_seq.NEXTVAL,'Mongkhonvilay', 'Azula', '620-487-5640', '909 E. South Ave.', 'Emporia', 'KS', 'azula@gmail.com', '620-487-5643');
INSERT INTO customers(customer_id, last_name, first_name,  home_phone, address, city, state, email,  cell_phone)
VALUES(customer_id_seq.NEXTVAL,'Mongkhonvilay', 'Korra', '620-487-5883', '418 S. Sylvan St.', 'Emporia', 'KS', 'korra@gmail.com', NULL);
INSERT INTO customers(customer_id, last_name, first_name,  home_phone, address, city, state, email,  cell_phone)
VALUES(customer_id_seq.NEXTVAL,'Jones', 'John', '620-555-1234', '1226 Asian Ave.', 'Long Beach', 'CA', NULL, NULL);
INSERT INTO customers(customer_id, last_name, first_name,  home_phone, address, city, state)
VALUES(customer_id_seq.NEXTVAL,'Pravesh', 'Devon', '620-555-1859', '1234 Resident Dr.', 'Atlanta', 'GA');
INSERT INTO customers(customer_id, last_name, first_name,  home_phone, address, city, state)
VALUES(customer_id_seq.NEXTVAL,'Benson', 'Olivia', '555-911-1234', '911 SVU St.', 'New York', 'NY');
INSERT INTO customers(customer_id, last_name, first_name,  home_phone, address, city, state)
VALUES(customer_id_seq.NEXTVAL,'Saint', 'Franklin', '412-187-1234', '100 Florence St.', 'Los Angeles', 'CA');



INSERT INTO rental_history(media_id, rental_date, customer_id,  return_date)
VALUES(92, TO_DATE('26/09/2001','DD/MM/YYYY'), 103, TO_DATE('30/09/2001','DD/MM/YYYY') );
INSERT INTO rental_history(media_id, rental_date, customer_id,  return_date)
VALUES(100, TO_DATE('26/12/2019','DD/MM/YYYY'), 102, NULL );
INSERT INTO rental_history(media_id, rental_date, customer_id,  return_date)
VALUES(94, TO_DATE('01-MAY-2022','DD-MON-YYYY'), 104, TO_DATE('14-MAY-2022','DD-MON-YYYY') );
INSERT INTO rental_history(media_id, rental_date, customer_id,  return_date)
VALUES(96, TO_DATE('20-APR-2010','DD-MON-YYYY'), 106, NULL );



--6. Create an index on the last_name column of the Customers table.
CREATE INDEX ctr_lat_nae_idx
 on customers(last_name);

--7. Create a synonym called TU for the TITLE_UNAVAIL view.
CREATE  SYNONYM tu
FOR title_unavail;