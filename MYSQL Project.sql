-- DROP DATABASE music_store;
CREATE DATABASE music_store;
USE music_store;
-- 1. Genre and MediaType
CREATE TABLE Genre (
genre_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(120)
);
DESC Genre;
CREATE TABLE MediaType (
media_type_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(120)
);
DESC MediaType;
 
-- 2. Employee
CREATE TABLE Employee (
employee_id INT PRIMARY KEY AUTO_INCREMENT,
last_name VARCHAR(120),
first_name VARCHAR(120),
title VARCHAR(120),
reports_to INT,
levels VARCHAR(255),
birthdate DATE,
hire_date DATE,
address VARCHAR(255),
city VARCHAR(100),
state VARCHAR(100),
country VARCHAR(100),
postal_code VARCHAR(20),
phone VARCHAR(50),
fax VARCHAR(50),
email VARCHAR(100)
);
DESC Employee;

-- 3. Customer
CREATE TABLE Customer (
customer_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(120),
last_name VARCHAR(120),
company VARCHAR(120),
address VARCHAR(255),
city VARCHAR(100),
state VARCHAR(100),
country VARCHAR(100),
postal_code VARCHAR(20),
phone VARCHAR(50),
fax VARCHAR(50),
email VARCHAR(100),
support_rep_id INT,
FOREIGN KEY (support_rep_id) REFERENCES Employee(employee_id)
); 
DESC Customer;

-- 4. Artist
CREATE TABLE Artist (
artist_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(120)
); 
DESC Artist;

-- 5. Album 
CREATE TABLE Album (
album_id INT PRIMARY KEY AUTO_INCREMENT,
title VARCHAR(160),
artist_id INT,
FOREIGN KEY (artist_id) REFERENCES Artist(artist_id)
); 
DESC Album; 

-- 6. Track 

CREATE TABLE Track (
track_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(200),
album_id INT,
media_type_id INT,
genre_id INT,
composer VARCHAR(220),
milliseconds INT,
bytes INT,
unit_price DECIMAL(10,2),
FOREIGN KEY (album_id) REFERENCES Album(album_id),
FOREIGN KEY (media_type_id) REFERENCES MediaType(media_type_id),
FOREIGN KEY (genre_id) REFERENCES Genre(genre_id)
); 
DESC Track; 



-- 7. Invoice 
CREATE TABLE Invoice (
invoice_id INT PRIMARY KEY AUTO_INCREMENT,
customer_id INT,
invoice_date DATE,
billing_address VARCHAR(255),
billing_city VARCHAR(100),
billing_state VARCHAR(100),
billing_country VARCHAR(100),
billing_postal_code VARCHAR(20),
total DECIMAL(10,2),
FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
); 
DESC Invoice; 

-- 8. InvoiceLine 
CREATE TABLE InvoiceLine (
invoice_line_id INT PRIMARY KEY AUTO_INCREMENT,
invoice_id INT,
track_id INT,
unit_price DECIMAL(10,2),
quantity INT,
FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id),
FOREIGN KEY (track_id) REFERENCES Track(track_id)
); 
DESC InvoiceLine; 

-- 9. Playlist
CREATE TABLE Playlist (
playlist_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(255)
); 
DESC Playlist;
 
-- 10. PlaylistTrack 
CREATE TABLE PlaylistTrack (
playlist_id INT,
track_id INT,
PRIMARY KEY (playlist_id, track_id),
FOREIGN KEY (playlist_id) REFERENCES Playlist(playlist_id),
FOREIGN KEY (track_id) REFERENCES Track(track_id)
); 
DESC PlaylistTrack;

SELECT  * FROM Genre;
SELECT * FROM MediaType;
INSERT INTO Employee (
    employee_id,
    last_name,
    first_name,
    title,
    reports_to,
    levels,
    birthdate,
    hire_date,
    address,
    city,
    state,
    country,
    postal_code,
    phone,
    fax,
    email
)
VALUES (
    9,
    'Madan',
    'Mohan',
    'Senior General Manager',
    NULL,
    'L7',
    '1961-01-26',
    '2016-01-14',
    '1008 Vrinda Ave MT',
    'Edmonton',
    'AB',
    'Canada',
    'T5K 2N1',
    '+1 (780) 428-9482',
    '+1 (780) 428-3457',
    'madan.mohan@chinookcorp.com'
);
SELECT * FROM Employee;
SELECT * FROM artist;
SELECT * FROM customer;
SELECT * FROM album;
SELECT * FROM track;  
SELECT * FROM Invoice;
SELECT * FROM Invoiceline;
SELECT * FROM Playlist;
SELECT * FROM PlaylistTrack; 

-- 1. Who is the senior most employee based on job title? 
-- ANS) MADAN MOHAN
SELECT *
FROM Employee
ORDER BY levels DESC
LIMIT 1;  
-- 2. Which countries have the most Invoices?
SELECT billing_country,
       COUNT(*) AS invoice_count
FROM Invoice
GROUP BY billing_country
ORDER BY invoice_count DESC;
-- 3. What are the top 3 values of total invoice?
-- ANS) 23.76, 19.80, 19.80
SELECT total
FROM Invoice
ORDER BY total DESC
LIMIT 3;
-- 4. Which city has the best customers? - We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals
-- ANS) PRAGUE 
SELECT billing_city,
       SUM(total) AS revenue
FROM Invoice
GROUP BY billing_city
ORDER BY revenue DESC
LIMIT 1;
-- 5. Who is the best customer? - The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money
-- ANS) FRANTIAIEK WICHTERLOVAI
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       SUM(i.total) AS total_spent
FROM Customer c
JOIN Invoice i
ON c.customer_id=i.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 1;
-- 6. Write a query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A
SELECT DISTINCT
    c.email,
    c.first_name,
    c.last_name,
    g.name AS genre
FROM customer c
JOIN invoice i
    ON c.customer_id = i.customer_id
JOIN invoiceline il
    ON i.invoice_id = il.invoice_id
JOIN track t
    ON il.track_id = t.track_id
JOIN genre g
    ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
ORDER BY c.email;
-- 7. Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands 
SELECT
    a.name AS artist_name,
    COUNT(*) AS total_tracks
FROM artist a
JOIN album al
    ON a.artist_id = al.artist_id
JOIN track t
    ON al.album_id = t.album_id
JOIN genre g
    ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY a.artist_id, a.name
ORDER BY total_tracks DESC
LIMIT 10;
-- 8. Return all the track names that have a song length longer than the average song length.- Return the Name and Milliseconds for each track. Order by the song length, with the longest songs listed first
SELECT
    name,
    milliseconds
FROM track
WHERE milliseconds >
(
    SELECT AVG(milliseconds)
    FROM track
)
ORDER BY milliseconds DESC;
-- 9. Find how much amount is spent by each customer on artists? Write a query to return customer name, artist name and total spent 
SELECT
    CONCAT(c.first_name,' ',c.last_name) AS customer_name,
    a.name AS artist_name,
    ROUND(SUM(il.unit_price * il.quantity),2) AS total_spent
FROM customer c
JOIN invoice i
    ON c.customer_id = i.customer_id
JOIN invoiceline il
    ON i.invoice_id = il.invoice_id
JOIN track t
    ON il.track_id = t.track_id
JOIN album al
    ON t.album_id = al.album_id
JOIN artist a
    ON al.artist_id = a.artist_id
GROUP BY customer_name, artist_name
ORDER BY total_spent DESC;
-- 10. We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared, return all Genres 
WITH genre_purchases AS
(
    SELECT
        i.billing_country AS country,
        g.name AS genre,
        COUNT(*) AS purchases
    FROM invoice i
    JOIN invoiceline il
        ON i.invoice_id = il.invoice_id
    JOIN track t
        ON il.track_id = t.track_id
    JOIN genre g
        ON t.genre_id = g.genre_id
    GROUP BY country, genre
),
ranked_genres AS
(
    SELECT *,
           DENSE_RANK() OVER
           (
               PARTITION BY country
               ORDER BY purchases DESC
           ) AS rnk
    FROM genre_purchases
)
SELECT
    country,
    genre,
    purchases
FROM ranked_genres
WHERE rnk = 1
ORDER BY country;
-- 11. Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount
WITH customer_spending AS
(
    SELECT
        c.country,
        c.customer_id,
        CONCAT(c.first_name,' ',c.last_name) AS customer_name,
        SUM(i.total) AS total_spent
    FROM customer c
    JOIN invoice i
        ON c.customer_id = i.customer_id
    GROUP BY
        c.country,
        c.customer_id,
        customer_name
),
ranked_customers AS
(
    SELECT *,
           DENSE_RANK() OVER
           (
               PARTITION BY country
               ORDER BY total_spent DESC
           ) AS rnk
    FROM customer_spending
)
SELECT
    country,
    customer_name,
    total_spent
FROM ranked_customers
WHERE rnk = 1
ORDER BY country;
 










