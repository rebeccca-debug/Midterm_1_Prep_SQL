CREATE TABLE IF NOT EXISTS States
             (abbrev char(2) PRIMARY KEY,
              statename char(20),  -- May include territories
              population integer);

CREATE TABLE IF NOT EXISTS Politicians
             (bioid char(20),
              firstname char(20),
              lastname char(20),
              birthday date, -- YYYY-MM-DD format string
              gender char(1),
              PRIMARY KEY(bioid));
              
CREATE TABLE IF NOT EXISTS Terms
             (termid INTEGER PRIMARY KEY AUTO_INCREMENT,
              termtype char(20), -- Type of term elected; rep, sen, prez, viceprez
              startdate date,
              enddate date,
              party char(20), -- Political party affiliation
              how char(20),  -- Different ways to get into an office
              bioid char(20),
              -- President & vice president aren't elected from districts or states
              -- Senators aren't elected from districts
              district integer,  -- Null of prez, viceprez, or sen
              state char(2),    -- Null for prez and viceprez
              FOREIGN KEY(bioid) REFERENCES Politicians(bioid));
              
/*Average: What is the average population of all the states?*/
SELECT AVG(population) FROM States S;

/*Above.Average: Which states have a population greater than the average of all the states?*/
SELECT S.statename from States S where S.population > (SELECT AVG(population) from States);

/*How.Many.States: How many states are there?*/
SELECT count(*) from States;

/*Total.Population: What is the total population of the United States (according to this database)?*/
SELECT SUM(population) FROM States;

/*Below.Average: List each state that is below the average state population and give that state's amount below the average.*/
SELECT S1.statename, S3.average-S1.population FROM States S1, (SELECT AVG(S3.population) AS average FROM States S3) AS S3 WHERE S1.population<S3.average;

/*First.Politician: What is the alphabetically first politician by their last name?*/
SELECT DISTINCT P.lastname from Politicians P
ORDER BY P.lastname limit 1;

/*Last.Politician: What is the alphabetically last politician by their last name?*/
SELECT max(P.lastname) from Politicians P limit 1;

/*First.And.Last: What is the last names of politicians who are alphabetically first and last?*/
SELECT P.lastname from Politicians P
	WHERE P.lastname=(SELECT MIN(P1.lastname) FROM Politicians P1) or P.lastname=(SELECT MAX(P2.lastname) FROM Politicians P2);
    
/*Last.And.First: What is the last names of the politicians who are alphabetically first and last?
NOTE: This time, please sort the names in reverse alphabetical order.*/
SELECT P.lastname FROM Politicians P WHERE P.lastname=(SELECT MIN(P1.lastname) FROM Politicians P1) or P.lastname=(SELECT MAX(P2.lastname) FROM Politicians P2);

/*Second.Through.Ten: What is the last name of the alphabetically second through tenth politician?*/
SELECT DISTINCT P.lastname FROM Politicians P WHERE P.lastname != (SELECT MIN(P1.lastname) FROM Politicians P1) order by P.lastname limit 9;


CREATE TABLE Sailors
      (sid integer primary key,
       sname text,
       rating integer,
       age integer);

CREATE TABLE Boats
      (bid integer primary key,
       bname text,
       color text);

CREATE TABLE Reserves
      (sid integer,
       bid integer,
       day text,
       primary key (sid, day),
       foreign key (sid) references Sailors(sid),
       foreign key (bid) references Boats(bid));
       
/*Reserved.All: Find the name of sailors who have reserved all boats.*/
SELECT S.sname from Sailors S WHERE NOT EXISTS (SELECT * from Boats B WHERE NOT EXISTS (SELECT * from Reserves R WHERE R.sid=S.sid and R.bid=B.bid));


/*Lake.Sailors: Find the names of sailors who have reserved all boats whose name have 'lake' in it.*/
SELECT S.sname from Sailors S WHERE NOT EXISTS (SELECT * from Boats B WHERE B.bname LIKE '%lake%' AND NOT EXISTS (SELECT * FROM Reserves R WHERE R.sid=S.sid AND R.bid=B.bid));

/*Better.Than.Bart: Find the sailor id's of sailors whose rating is better than a sailor named Bart.*/
SELECT S.sid from Sailors S WHERE S.rating > (SELECT S.rating from Sailors S WHERE S.sname='Bart');

/*Older.Is.Better: Find the name and age of the oldest sailor.*/
SELECT S.sname,max(S.age) from Sailors S;