-- Create the Virtual Art Gallery database
CREATE DATABASE VirtualArtGallery;
GO

-- Use the Virtual Art Gallery database
USE VirtualArtGallery;
GO

-- Create the Artists table
CREATE TABLE Artists (
    ArtistID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Biography TEXT,
    Nationality VARCHAR(100)
);
GO

-- Create the Categories table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL
);
GO

-- Create the Artworks table
CREATE TABLE Artworks (
    ArtworkID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    ArtistID INT,
    CategoryID INT,
    Year INT,
    Description TEXT,
    ImageURL VARCHAR(255),
    FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
    FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID)
);
GO

-- Create the Exhibitions table
CREATE TABLE Exhibitions (
    ExhibitionID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    Description TEXT
);
GO

-- Create a table to associate artworks with exhibitions
CREATE TABLE ExhibitionArtworks (
    ExhibitionID INT,
    ArtworkID INT,
    PRIMARY KEY (ExhibitionID, ArtworkID),
    FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
    FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID)
);
GO
-- Insert sample data into the Artists table
INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
(1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
(2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
(3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');
GO
select * from artists;


-- Insert sample data into the Categories table
INSERT INTO Categories (CategoryID, Name) VALUES
(1, 'Painting'),
(2, 'Sculpture'),
(3, 'Photography');
GO

-- Insert sample data into the Artworks table with escaped single quotes
INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
(1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
(2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
(3, 'Guernica', 1, 1, 1937, 'Pablo Picasso''s powerful anti-war mural.', 'guernica.jpg');
select * from artworks ;

-- Insert sample data into the Exhibitions table
INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES
(1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
(2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');
GO

-- Insert artworks into exhibitions
INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 2);
GO
select * from ExhibitionArtworks;

--1.Retrieve the names of all artists along with the number of artworks they have
SELECT A.Name AS ArtistName, COUNT(AR.ArtworkID) AS ArtworkCount
FROM Artists A
JOIN Artworks AR ON A.ArtistID = AR.ArtistID
GROUP BY A.Name
ORDER BY ArtworkCount DESC;
GO

--2. List the titles of artworks created by Spanish and Dutch artists, ordered by year
SELECT AR.Title AS ArtworkTitle, AR.Year
FROM Artworks AR
JOIN Artists A ON AR.ArtistID = A.ArtistID
WHERE A.Nationality IN ('Spanish', 'Dutch')
ORDER BY AR.Year ASC;
GO

--3.Find the names of all artists with artworks in the 'Painting' category and the number of artworks they have
SELECT A.Name AS ArtistName, COUNT(AR.ArtworkID) AS ArtworkCount
FROM Artists A
JOIN Artworks AR ON A.ArtistID = AR.ArtistID
JOIN Categories C ON AR.CategoryID = C.CategoryID
WHERE C.Name = 'Painting'
GROUP BY A.Name;
GO

-- 4.List the names of artworks from the 'Modern Art Masterpieces' exhibition along with their artists and categories
SELECT AR.Title AS ArtworkTitle, A.Name AS ArtistName, C.Name AS CategoryName
FROM ExhibitionArtworks EA
JOIN Artworks AR ON EA.ArtworkID = AR.ArtworkID
JOIN Artists A ON AR.ArtistID = A.ArtistID
JOIN Categories C ON AR.CategoryID = C.CategoryID
JOIN Exhibitions E ON EA.ExhibitionID = E.ExhibitionID
WHERE E.Title = 'Modern Art Masterpieces';
GO

--5. Find artists who have more than two artworks in the gallery
SELECT A.Name AS ArtistName, COUNT(AR.ArtworkID) AS ArtworkCount
FROM Artists A
JOIN Artworks AR ON A.ArtistID = AR.ArtistID
GROUP BY A.ArtistID, A.Name
HAVING COUNT(AR.ArtworkID) > 2;
GO

-- 6.Find titles of artworks exhibited in both 'Modern Art Masterpieces' and 'Renaissance Art' exhibitions
SELECT AR.Title AS ArtworkTitle
FROM ExhibitionArtworks EA
JOIN Exhibitions E ON EA.ExhibitionID = E.ExhibitionID
JOIN Artworks AR ON EA.ArtworkID = AR.ArtworkID
WHERE E.Title IN ('Modern Art Masterpieces', 'Renaissance Art')
GROUP BY AR.Title
HAVING COUNT(DISTINCT E.ExhibitionID) = 2; 
GO

--7. Find the total number of artworks in each category
SELECT C.Name AS CategoryName, COUNT(AR.ArtworkID) AS ArtworkCount
FROM Categories C
LEFT JOIN Artworks AR ON C.CategoryID = AR.CategoryID
GROUP BY C.CategoryID, C.Name
ORDER BY C.Name; 
GO

-- 8.Find artists who have more than three artworks in the gallery
SELECT A.Name AS ArtistName, COUNT(AR.ArtworkID) AS ArtworkCount
FROM Artists A
JOIN Artworks AR ON A.ArtistID = AR.ArtistID
GROUP BY A.ArtistID, A.Name
HAVING COUNT(AR.ArtworkID) > 3;
GO

--9. Find artworks created by artists from a specific nationality (e.g., Spanish)
SELECT AR.Title AS ArtworkTitle, A.Name AS ArtistName
FROM Artworks AR
JOIN Artists A ON AR.ArtistID = A.ArtistID
WHERE A.Nationality = 'Spanish';
GO

--10. List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci
SELECT E.Title AS ExhibitionTitle
FROM Exhibitions E
JOIN ExhibitionArtworks EA ON E.ExhibitionID = EA.ExhibitionID
JOIN Artworks AR ON EA.ArtworkID = AR.ArtworkID
JOIN Artists A ON AR.ArtistID = A.ArtistID
WHERE A.Name IN ('Vincent van Gogh', 'Leonardo da Vinci')
GROUP BY E.ExhibitionID, E.Title
HAVING COUNT(DISTINCT A.Name) = 2; 
GO

--11. Find all artworks that have not been included in any exhibition
SELECT AR.Title AS ArtworkTitle
FROM Artworks AR
LEFT JOIN ExhibitionArtworks EA ON AR.ArtworkID = EA.ArtworkID
WHERE EA.ExhibitionID IS NULL;  

--12. List artists who have created artworks in all available categories
SELECT A.Name AS ArtistName
FROM Artists A
JOIN Artworks AR ON A.ArtistID = AR.ArtistID
GROUP BY A.ArtistID, A.Name
HAVING COUNT(DISTINCT AR.CategoryID) = (SELECT COUNT(*) FROM Categories);

--13. List the total number of artworks in each category
SELECT C.Name AS CategoryName, COUNT(AR.ArtworkID) AS ArtworkCount
FROM Categories C
LEFT JOIN Artworks AR ON C.CategoryID = AR.CategoryID
GROUP BY C.CategoryID, C.Name
ORDER BY C.Name;  

--14. Find artists who have more than two artworks in the gallery
SELECT A.Name AS ArtistName, COUNT(AR.ArtworkID) AS ArtworkCount
FROM Artists A
JOIN Artworks AR ON A.ArtistID = AR.ArtistID
GROUP BY A.ArtistID, A.Name
HAVING COUNT(AR.ArtworkID) > 2;
GO

--15. List categories with the average year of artworks, only for categories with more than 1 artwork
SELECT C.Name AS CategoryName, AVG(AR.Year) AS AverageYear
FROM Categories C
JOIN Artworks AR ON C.CategoryID = AR.CategoryID
GROUP BY C.CategoryID, C.Name
HAVING COUNT(AR.ArtworkID) > 1;  
GO

--16. Find artworks that were exhibited in the 'Modern Art Masterpieces' exhibition
SELECT AR.Title AS ArtworkTitle, A.Name AS ArtistName, C.Name AS CategoryName
FROM ExhibitionArtworks EA
JOIN Artworks AR ON EA.ArtworkID = AR.ArtworkID
JOIN Artists A ON AR.ArtistID = A.ArtistID
JOIN Categories C ON AR.CategoryID = C.CategoryID
JOIN Exhibitions E ON EA.ExhibitionID = E.ExhibitionID
WHERE E.Title = 'Modern Art Masterpieces';
GO

-- 17.Find categories where the average year of artworks is greater than the average year of all artworks
SELECT C.Name AS CategoryName, AVG(AR.Year) AS AverageYear
FROM Categories C
JOIN Artworks AR ON C.CategoryID = AR.CategoryID
GROUP BY C.CategoryID, C.Name
HAVING AVG(AR.Year) > (SELECT AVG(Year) FROM Artworks);
GO

--18. List artworks that were not exhibited in any exhibition
SELECT AR.Title AS ArtworkTitle, A.Name AS ArtistName, C.Name AS CategoryName
FROM Artworks AR
LEFT JOIN ExhibitionArtworks EA ON AR.ArtworkID = EA.ArtworkID
JOIN Artists A ON AR.ArtistID = A.ArtistID
JOIN Categories C ON AR.CategoryID = C.CategoryID
WHERE EA.ExhibitionID IS NULL; 
GO

--19. Show artists who have artworks in the same category as "Mona Lisa"
SELECT DISTINCT A.Name AS ArtistName
FROM Artworks AR
JOIN Artists A ON AR.ArtistID = A.ArtistID
WHERE AR.CategoryID = (
    SELECT CategoryID
    FROM Artworks
    WHERE Title = 'Mona Lisa'
);
GO

--20.List the names of artists and the number of artworks they have in the gallery
SELECT A.Name AS ArtistName, COUNT(AR.ArtworkID) AS ArtworkCount
FROM Artists A
LEFT JOIN Artworks AR ON A.ArtistID = AR.ArtistID
GROUP BY A.ArtistID, A.Name
  






