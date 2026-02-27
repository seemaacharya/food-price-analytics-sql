-- Drop the table if it already exists
DROP TABLE IF EXISTS food_prices_ind;

-- Create the table with the specified schema
CREATE TABLE food_prices_ind
(
	date DATE,
	admin1 VARCHAR(25),
	admin2 VARCHAR(25),
	market VARCHAR(25),
	latitude FLOAT,
	longitude FLOAT,
	category VARCHAR(30),
	commodity VARCHAR(30),
	unit VARCHAR(15),
	priceflag VARCHAR(10),
	pricetype VARCHAR(15),
	currency VARCHAR(5),
	price NUMERIC,
	usdprice NUMERIC
);


SELECT * FROM food_prices_ind;

--Business Problems & Solutions

--Q1. Count of records
--A1. There are 172017 records

SELECT COUNT(*) FROM food_prices_ind;

--Q2. Find out from how many states data are taken
--A2. 27 states and 4 Union terrirories (Andaman nicobar, Chandigargh, Delhi, Puducheri)

SELECT COUNT (DISTINCT admin1) as state 
FROM food_prices_ind
WHERE admin1 is not null;


--Q3. How to find out the states which have had the highest prices of Rice under cereals and tubers category - Retail purchases


SELECT admin1 AS state, market, category, commodity, pricetype, MAX(price) AS mprice
FROM food_prices_ind
WHERE category = 'cereals and tubers' AND pricetype = 'Retail' AND commodity = 'Rice'
GROUP BY admin1, market, category, commodity, pricetype
ORDER BY mprice DESC;


-- Q4. Find out the states and market which have had the highest prices of Rice under cereals and tubers category- Wholesale purchases

SELECT admin1 as state,market,category,commodity,pricetype,max(price) as mprice
FROM food_prices_ind
WHERE category ='cereals and tubers' AND pricetype = 'Wholesale' AND commodity ='Rice'
group by 1,2,3,4,5 
order by mprice desc;



  
--Q5.Find out the states and market which have had the highest prices of Milk under milk and dairy category- Retail purchases only
-- A5.Only in 7 states Raw milk is sold

SELECT admin1 AS state,market,category,commodity,pricetype,MAX(price) AS mprice
FROM food_prices_ind
WHERE category = 'milk and dairy' AND pricetype = 'Retail' AND commodity = 'Milk'
GROUP BY 1,2,3,4,5
ORDER BY mprice DESC;



-- Q6.Find out the states and market which have had the highest prices of Milk (pasteurized) under milk and dairy category- Retail purchases only

SELECT admin1 AS state, market, category, commodity, pricetype, MAX(price) AS mprice
FROM food_prices_ind
WHERE category = 'milk and dairy' 
  AND pricetype = 'Retail' 
  AND commodity = 'Milk (pasteurized)'
GROUP BY admin1, market, category, commodity, pricetype
ORDER BY mprice DESC;


-- Q7. Find out the states and market which have had the highest prices of Ghee (vanaspati) under oil and fats- Retail purchases only
-- A7. Mysore(Karnataka) seems to have the highest of Ghee(vanaspathi) prices

SELECT admin1 AS state, market, category, commodity, pricetype, MAX(price) AS mprice
FROM food_prices_ind
WHERE admin1 IS NOT NULL AND category = 'oil and fats' AND commodity = 'Ghee (vanaspati)'
GROUP BY admin1, market, category, commodity, pricetype
ORDER BY mprice DESC;


-- Q8. Finding out the average price of oil and fats as whole

SELECT AVG(price) as Averageprice
FROM food_prices_ind
WHERE category ='oil and fats';


-- Q9. Find out the average prices for each type of oil under oil and fats
-- A9. Groundnut Oil has the highest average price of 148.5 INR and palm oil has the lowest average price of 100 INR

SELECT commodity, AVG(price) AS Averageprice
FROM food_prices_ind
WHERE category = 'oil and fats'
GROUP BY commodity;

-- Q10. Finding out the average prices of lentils
--A10. Urad has the highest average price of 102.13 INR and chickpeas has the lowest average price of 46.23 INR
 

SELECT AVG(price) as Averageprice
FROM food_prices_ind
WHERE category ='pulses and nuts' AND commodity = 'Lentils (moong)';

SELECT AVG(price) as Averageprice
FROM food_prices_ind
WHERE category ='pulses and nuts' AND commodity = 'Lentils (urad)';

SELECT AVG(price) as Averageprice
FROM food_prices_ind
WHERE category ='pulses and nuts' AND commodity = 'Lentils (masur)';

SELECT AVG(price) as Averageprice
FROM food_prices_ind
WHERE category ='pulses and nuts' AND commodity = 'Chickpeas';


-- Q11. Finding out the average price of Onions and tomatoes
-- A11. Average price of Onion is 28 INR and Average price of Tomato is 30.3 INR

SELECT AVG(price) as Averageprice
FROM food_prices_ind
WHERE category ='vegetables and fruits' AND commodity = 'Onions';

SELECT AVG(price) as Averageprice
FROM food_prices_ind
WHERE category ='vegetables and fruits' AND commodity = 'Tomatoes';


-- Q12 Find out which commodity has the highest price 
-- A12 Tea(black) has the highest price throughout all the years (Data for Tea available only from the year 2013)

SELECT date, admin1 as state,market,category,commodity,pricetype,max(price) as mprice
FROM food_prices_ind
WHERE pricetype = 'Retail'
group by 1,2,3,4,5,6 
order by mprice desc;


-- Q13 Find out the commodities which has the highest prices recently year 2022
-- A Tea comes first,oil comes second, lentils comes third

SELECT market,category,commodity,MAX(price) AS Highest_price
FROM food_prices_ind
WHERE date = '2022-07-15'AND pricetype = 'Retail'
GROUP BY market, category, commodity
ORDER BY Highest_price DESC;


-- Q14 Create a table for zones
-- Select city and State from food prices ind table and insert it into zones table

-- Drop the table if it exists
DROP TABLE IF EXISTS zones;

-- Create the zones table
CREATE TABLE zones (
    city VARCHAR(255),
    state VARCHAR(255),
    zone VARCHAR(255),
    PRIMARY KEY (city, state)
);

-- Insert distinct cities and states into the zones table
INSERT INTO zones (city, state, zone)
SELECT DISTINCT admin2, admin1, NULL
FROM food_prices_ind
WHERE admin2 IS NOT NULL;

-- Update the zones table with the appropriate zones
UPDATE zones SET zone = 'South' WHERE state IN ('Tamil Nadu', 'Telangana', 'Andhra Pradesh', 'Kerala', 'Karnataka');
UPDATE zones SET zone = 'North' WHERE state IN ('Himachal Pradesh', 'Punjab', 'Uttarakhand', 'Uttar Pradesh', 'Haryana');
UPDATE zones SET zone = 'East' WHERE state IN ('Bihar', 'Orissa', 'Jharkhand', 'West Bengal');
UPDATE zones SET zone = 'West' WHERE state IN ('Rajasthan', 'Gujarat', 'Goa', 'Maharashtra');
UPDATE zones SET zone = 'Central' WHERE state IN ('Madhya Pradesh', 'Chhattisgarh');
UPDATE zones SET zone = 'North East' WHERE state IN ('Assam', 'Sikkim', 'Manipur', 'Meghalaya', 'Nagaland', 'Mizoram', 'Tripura', 'Arunachal Pradesh');
UPDATE zones SET zone = 'Union Territory' WHERE state IN ('Chandigarh', 'Delhi', 'Puducherry', 'Andaman and Nicobar');

-- Select all records from the zones table
SELECT *
FROM zones;



-- Q15 JOIN zones table and food_prices_ind AND Create a view
-- Create the view commodity_prices
CREATE VIEW commodity_prices AS
SELECT 
    fo.date,
    zo.city,
    zo.state,
    fo.market,
    zo.zone,
    fo.latitude,
    fo.longitude,
    fo.category,
    fo.commodity,
    fo.unit,
    fo.priceflag,
    fo.pricetype,
    fo.currency,
    fo.price,
    fo.usdprice
FROM 
    zones zo
JOIN 
    food_prices_ind fo
ON 
    zo.state = fo.admin1;


SELECT * FROM commodity_prices;
	


-- Q16. Calculate average price of commodities zone-wise
SELECT 
    zone,
    category,
    commodity,
    AVG(price) AS average_price
FROM 
    commodity_prices
GROUP BY 
    zone, category, commodity
ORDER BY 
    zone,
    category,
    commodity,
    average_price DESC;


-- Q17. Calculate average price of commodities zone-wise for a specific date

SELECT date,zone,category,commodity,AVG(price) AS average_price
FROM commodity_prices
WHERE date = '2022-07-15'
GROUP BY date, zone, category, commodity
ORDER BY commodity,average_price DESC;



-- Q17 Find out the price differences between  2022 and 2012 

-- Drop and recreate the table for 2012 prices
DROP TABLE IF EXISTS price_differencesB;
CREATE TABLE price_differencesB (
    state VARCHAR(255),
    zone VARCHAR(255),
    category VARCHAR(255),
    commodity VARCHAR(255),
    average_price_2012 DOUBLE PRECISION
);

INSERT INTO price_differencesB
SELECT 
    state,
    zone,
    category,
    commodity,
    ROUND(AVG(price)::numeric, 2) AS average_price_2012
FROM 
    commodity_prices
WHERE 
    date = '2012-12-15' AND pricetype = 'Retail'
GROUP BY 
    state, zone, category, commodity;

-- Drop and recreate the table for 2022 prices
DROP TABLE IF EXISTS price_differencesC;
CREATE TABLE price_differencesC (
    state VARCHAR(255),
    zone VARCHAR(255),
    category VARCHAR(255),
    commodity VARCHAR(255),
    average_price_2022 DOUBLE PRECISION
);

INSERT INTO price_differencesC
SELECT 
    state,
    zone,
    category,
    commodity,
    ROUND(AVG(price)::numeric, 2) AS average_price_2022
FROM 
    commodity_prices
WHERE 
    date = '2022-07-15' AND pricetype = 'Retail'
GROUP BY 
    state, zone, category, commodity;

-- Calculate the price differences
SELECT 
    B.state,
    B.zone,
    B.category,
    B.commodity,
    B.average_price_2012,
    C.average_price_2022,
    C.average_price_2022 - B.average_price_2012 AS diff_bw_price
FROM 
    price_differencesB B
JOIN 
    price_differencesC C
ON 
    B.state = C.state AND
    B.zone = C.zone AND
    B.category = C.category AND
    B.commodity = C.commodity
ORDER BY 
    B.zone, B.category, B.commodity;





-- Q18 Find out the average prices of each category food products zone wise

-- South zone has the highest avg price for cereals and tubers(Potatoes,rice,wheat,wheat flour),North zone hasthe lowest average
-- North East zone has the highest avg price for Milk and dairy, South zone has the lowest average
-- North East zone has the highest avg price for Miscellaneous food(Sugar,salt,jaggery,Tea(black)),Union territory has the lowest average
-- Union Territory has the highest avg price for oil and fats(Ghee,Groundnut,Mustard,palm,soybean,sunflower),Central has the lowest average
-- Union Territory,North East has the highest avg price for pulses and nuts(chickpeas and other types of lentils), Central has the lowest average
-- North East zone has the highest avg price for vegetablesand fruits, South has the lowest average

SELECT zone,category,ROUND(AVG(price)::numeric, 2) AS avgprice
FROM commodity_prices
WHERE pricetype = 'Retail'AND date = '2022-07-15'
GROUP BY zone,category
ORDER BY category,avgprice DESC;


-- Q19 Find out the average prices of each commodity zone wise

--Ghee (Vanaspati):

--Union Territory has the highest average price of Ghee (Vanaspati).
--The East zone has the lowest average price of Ghee (Vanaspati).

--Lentils:

--North East has the highest average price of Lentils.
--Central has the lowest average price of Lentils.

--Milk (Pasteurized):

--North East has the highest average price of Milk (Pasteurized).
--South has the lowest average price of Milk (Pasteurized).

--Oil:

--North East has the highest average price of Oil.
--Central has the lowest average price of Oil.

--Onions:

--North East has the highest average price of Onions.
--Central has the lowest average price of Onions.

--Potatoes:

--Union Territories have the highest average price of Potatoes.
--Central has the lowest average price of Potatoes.

--Rice:

--South has the highest average price of Rice.
--North has the lowest average price of Rice.

--Salt (Iodized):

--North has the highest average price of Salt (Iodized).
--West has the lowest average price of Salt (Iodized).

--Sugar:

--North East has the highest average price of Sugar.
--South has the lowest average price of Sugar.

--Sugar (Jaggery/Gur):

--North East has the highest average price of Sugar (Jaggery/Gur).
--Central has the lowest average price of Sugar (Jaggery/Gur).

--Tea (Black):

--North East has the highest average price of Tea (Black).
--East has the lowest average price of Tea (Black).

--Tomatoes:

--North East has the highest average price of Tomatoes.
--South has the lowest average price of Tomatoes.

--Wheat:

--South has the highest average price of Wheat.
--North has the lowest average price of Wheat.

--Wheat Flour:

--South has the highest average price of Wheat Flour.
--North has the lowest average price of Wheat Flour.

SELECT zone,commodity,ROUND(AVG(price)::numeric, 2) AS avgprice
FROM commodity_prices
WHERE pricetype = 'Retail'AND date = '2022-07-15'
GROUP BY zone,commodity

ORDER BY commodity,avgprice DESC;


-- Q20 Drop unnecessary tables
DROP table FOOD_PRICES.food_pricesnew;



