-- 1. Create a database with the name of your choice
CREATE DATABASE Cinema;
USE Cinema;

-- 2. Create a table called Director with following columns: FirstName, LastName, Nationality and Birth date. Insert 5 rows into it.
CREATE TABLE Director(
DirectorID int NOT NULL identity,
FirstName varchar(20) NOT NULL,
LastName varchar(20) NOT NULL,
Nationality varchar(20) NOT NULL,
Birthdate datetime NOT NULL,
PRIMARY KEY(DirectorID)
);


INSERT INTO Director VALUES ('John', 'Lennon', 'American' , '10/01/1955');
INSERT INTO Director VALUES ('Mary', 'Poppins', 'American' , '09/09/1947');
INSERT INTO Director VALUES ('Charles', 'Aznavour', 'French' , '12/05/1949');
INSERT INTO Director VALUES ('Nikolay', 'Vasiliev', 'Russian' , '10/08/1977');
INSERT INTO Director VALUES ('Pedro', 'Almovadar', 'Spanish' , '08/04/1965');

SELECT * FROM Director;

-- 3. Delete the director with id = 3
DELETE FROM Director WHERE DirectorID = 3;

SELECT * FROM Director;

-- 4. Create a table called Movie with following columns: DirectorId, Title, ReleaseDate, Rating and Duration. Each movie has a director. 
-- Insert some rows into it

CREATE TABLE Movie(
MovieID int NOT NULL identity,
DirectorID int NOT NULL,
Title varchar(40) NOT NULL,
ReleaseDate datetime NOT NULL,
Rating int NOT NULL,
Duration int NOT NULL,
Comment varchar(40),
PRIMARY KEY(MovieID)
);

--DROP TABLE Movie; 


INSERT INTO Movie VALUES (1, 'Star Wars', '10/15/1985', 7, 2, '');
INSERT INTO Movie VALUES (1, 'Stellar', '09/14/1990', 9, 3, '');
INSERT INTO Movie VALUES (2, 'Bananarama', '09/09/2000', 10, 2, '');
INSERT INTO Movie VALUES (2, 'The mountain', '02/15/2010', 6, 2, '');
INSERT INTO Movie VALUES (4, 'The russian', '05/25/2015', 9, 3, '');
INSERT INTO Movie VALUES (4, 'The piano', '04/29/2018', 10, 2, '');
INSERT INTO Movie VALUES (5, 'Sand', '06/12/1992', 9, 2, '');
INSERT INTO Movie VALUES (5, 'Pessos', '08/19/1995', 10, 1, '');
INSERT INTO Movie VALUES (5, 'Dog', '08/19/1998', 9, 2, '');

SELECT * FROM Movie;

-- 5. Update all movies that have a rating lower than 10.
UPDATE Movie
SET Comment = 'Marked'
WHERE Rating < 10

SELECT * FROM Movie;

-- 6. Create a table called Actor with following columns: FirstName, LastName, Nationality, Birth date and PopularityRating. Insert some rows into it.
CREATE TABLE Actor(
ActorID int NOT NULL identity,
FirstName varchar(20) NOT NULL,
LastName varchar(20) NOT NULL,
Nationality varchar(20) NOT NULL,
Birthdate datetime NOT NULL,
PopularityRating int NOT NULL,
PRIMARY KEY(ActorID)
);

INSERT INTO Actor VALUES ('John', 'Lennon', 'British', '10/15/1985', 8);
INSERT INTO Actor VALUES ('Marcel', 'Iures', 'Romanian', '07/18/1954', 10);
INSERT INTO Actor VALUES ('Denzel', 'Washington', 'American', '08/14/1953', 10);
INSERT INTO Actor VALUES ('Dan', 'Ionescu', 'Romanian', '10/12/1980', 6);
INSERT INTO Actor VALUES ('Kiran', 'Fulch', 'Czech', '02/18/1974', 9);

SELECT * FROM Actor;


-- 7. Which is the movie with the lowest rating?
SELECT Title
FROM Movie
WHERE Rating = 
	(SELECT MIN(Rating) FROM Movie);


-- 8. Which director has the most movies directed?
-- SELECT d.DirectorID, d.FirstName, d.LastName, m.MovieID, m.DirectorID
-- FROM Director d
-- INNER JOIN Movie m ON d.DirectorID = m.DirectorID


SELECT TOP 1 DirectorID, COUNT(*) AS Cnt
FROM Movie
GROUP BY DirectorID
ORDER BY COUNT(*) DESC


-- 9. Display all movies ordered by director's LastName in ascending order, then by birth date descending.
SELECT m.Title, d.DirectorID, d.LastName, d.FirstName, d.Birthdate
FROM Director d
INNER JOIN Movie m ON d.DirectorID = m.DirectorID
ORDER BY d.LastName ASC

SELECT m.Title, d.DirectorID, d.LastName, d.FirstName, d.Birthdate
FROM Director d
INNER JOIN Movie m ON d.DirectorID = m.DirectorID
ORDER BY d.Birthdate DESC


-- 10. Create a function that will calculate and return the average rating of movies for a given director id
SELECT  d.DirectorID, AVG(m.Rating) AS Avg
FROM Director d
INNER JOIN Movie m ON d.DirectorID = m.DirectorID
GROUP BY d.DirectorID


-- 11. Create a view that will display all the movie titles with the directors' first names and last names.
CREATE VIEW Movies_and_directors AS
SELECT Movie.Title, Director.FirstName, Director.LastName
FROM Movie, Director
WHERE Movie.DirectorID = Director.DirectorID;

SELECT * FROM Movies_and_directors;


-- 12. Create a stored procedure that will increment the rating by 1 for a given movie id.
-- Creating the procedure
CREATE PROCEDURE incrementRating AS
Begin
UPDATE Movie
SET Rating = Rating + 1 WHERE MovieID = 1
End
GO

-- Executing the procedure
EXEC incrementRating

-- Visualizing the update
SELECT MovieID, Rating
FROM Movie
WHERE MovieID = 1


-- 13. Create a table called MovieHistory with a column for Id and a column for Message. Create a trigger that will add a new entry in the 
-- MovieHistory table when a row from Movie's table is updated.
CREATE TABLE MovieHistory 
(
ModificationID int NOT NULL identity,
Message varchar(30) NOT NULL,
UpdateDate Datetime NOT NULL,
PRIMARY KEY(ModificationID)
);

SELECT * FROM  MovieHistory;

CREATE TRIGGER displayMovieUpdates
ON Movie
AFTER UPDATE

AS
BEGIN
	INSERT INTO MovieHistory VALUES ('The rating was updated!', GETDATE())	
END;

-- Visualizing the updates made in MovieHistory by the trigger displayMovieUpdates
SELECT * FROM  MovieHistory;


-- 14. Create a cursor that will print on the screen all movies with a title shorter than 10 characters
SELECT * FROM Movie

DECLARE
@Title varchar(40);

DECLARE cursor_movies CURSOR
FOR SELECT Title 
	FROM Movie
	WHERE LEN(Title) < 10;

OPEN cursor_movies;

FETCH NEXT FROM cursor_movies INTO
		@Title;

WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT @Title;
		FETCH NEXT FROM cursor_movies INTO
			@Title;
	END;

CLOSE cursor_movies;

DEALLOCATE cursor_movies;


-- 15. Implement many to many relationship between Movie and Actor
CREATE TABLE MovieActorRelation
(
MovieID int,
ActorID int,
CONSTRAINT mov_act_pk PRIMARY KEY (MovieID, ActorID),
CONSTRAINT FK_Mv FOREIGN KEY (MovieID) REFERENCES Movie (MovieID),
CONSTRAINT FK_Act FOREIGN KEY (ActorID) REFERENCES Actor (ActorID),
);

SELECT * FROM MovieActorRelation;

INSERT INTO MovieActorRelation VALUES (1,1), (1,2), (1,3), (2,3), (2,4), (3,3), (3,5), (4,4), (5,4), (5,5), (6,2), (7,4), (7,5), (8,2), (8,3), (9,1), (9,3);

-- 16. Implement many to many relationship between Movie and Genre
CREATE TABLE Genre
(
GenreID int NOT NULL identity,
GenreName varchar(20) NOT NULL,
PRIMARY KEY(GenreID)
);

--DROP TABLE Genre;

INSERT INTO Genre VALUES ('Action');
INSERT INTO Genre VALUES ('SF');
INSERT INTO Genre VALUES ('Drama');

SELECT * FROM Genre;

CREATE TABLE MovieGenreRelation
(
MovieID int,
GenreID int,
CONSTRAINT mov_gen_pk PRIMARY KEY (MovieID, GenreID),
CONSTRAINT FK_Mov FOREIGN KEY (MovieID) REFERENCES Movie (MovieID),
CONSTRAINT FK_Gen FOREIGN KEY (GenreID) REFERENCES Genre (GenreID),
);

SELECT * FROM MovieGenreRelation;

INSERT INTO MovieGenreRelation VALUES (1,2), (1,1), (2,2), (3,3), (4,1), (4,3), (5,1), (5,2), (6,3), (7,2), (8,1), (8,3), (9,1);


-- 17. Which actor has worked with the most distinct movie directors?

-- will come back, it doesn't work!
--SELECT TOP 1 r.ActorID
--FROM MovieActorRelation r
--INNER JOIN Movie m ON r.MovieID = m.MovieID
--ORDER BY COUNT(m.DirectorID) DESC

-- 18. Which is the preferred genre of each actor?

--will come back, I have no idea!
--SELECT a.ActorID, g.GenreID
--FROM MovieActorRelation a
--INNER JOIN MovieGenreRelation g ON a.MovieID = g.MovieID
--GROUP BY g.GenreID





