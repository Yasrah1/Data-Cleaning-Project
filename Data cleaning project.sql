SELECT *
FROM amazon_sales_raw;

CREATE TABLE amazon_sales
LIKE amazon_sales_raw;

INSERT INTO amazon_sales
SELECT *
FROM amazon_sales_raw;

SELECT *
FROM amazamazon_saleson_sales;

ALTER TABLE amazon_sales
RENAME COLUMN `ï»¿Ship Mode` TO Ship_Mode; 

ALTER TABLE amazon_sales
RENAME COLUMN `Postal Code` TO Postal_Code; 

ALTER TABLE amazon_sales
RENAME COLUMN `Sub-Category` TO Sub_Category; 

-- First I tried to give the rows a number each....but soon realised it didn't work --

SELECT *,
ROW_NUMBER () 
OVER(PARTITION BY Ship_Mode, Segment, City, Postal_Code, Region, Category, Sub_Category, Sales, Quantity, Discount, Profit, Notes, Purchase_date) AS Row_Num
FROM amazon_sales;

WITH CTE AS 
(
    SELECT *,
           ROW_NUMBER() OVER (
		   PARTITION BY Ship_Mode, Segment, City, Postal_Code, Region, Category, Sub_Category, Sales, Quantity, Discount, Profit, Notes, Purchase_date
		   ORDER BY Category) AS row_num
FROM amazon_sales
)
SELECT *
FROM CTE
WHERE row_num > 1;

-- So, I tried again with a Aggregate Function ... this confirms there are duplicates --

SELECT *
FROM amazon_sales;

SELECT Ship_Mode, Segment, City, State, Postal_Code, Region, Category, Sub_Category, Sales, Quantity, Discount, Profit, Notes, 
COUNT(*)  AS Duplicates
FROM amazon_sales
GROUP BY Category, Ship_Mode, Segment, City, State, Postal_Code, Region, Sub_Category, Sales, Quantity, Discount, Profit, Notes
HAVING COUNT(*) > 1;

ALTER TABLE amazon_sales DROP COLUMN Notes;

SELECT * 
FROM amazon_sales
WHERE Sales = 102.36 AND Sub_Category = 'Furnishings';
 
 SELECT *
 FROM amazon_sales
 WHERE purchase_date = 'not_a_date';
 
 UPDATE amazon_sales
 SET purchase_date = NULL
 WHERE purchase_date LIKE 'NULL';

ALTER TABLE amazon_sales
ADD COLUMN cleaned_purchase_date DATE;

SELECT Ship_Mode, Segment, City, State, Postal_Code, Region, Category, Sub_Category, Sales, Quantity, Discount, Profit, 
COUNT(*)  AS Duplicates
FROM amazon_sales
GROUP BY Category, Ship_Mode, Segment, City, State, Postal_Code, Region, Sub_Category, Sales, Quantity, Discount, Profit
HAVING COUNT(*) > 1;

SELECT * 
FROM amazon_sales
WHERE Sales = 102.36 AND Sub_Category = 'Furnishings'; 

DELETE FROM amazon_sales
WHERE ID = 916;

SELECT * 
FROM amazon_sales
WHERE Sales = 3059.98 AND Sub_Category = 'Machines' AND State = 'Texas';

DELETE FROM amazon_sales
WHERE ID = 922;

SELECT * 
FROM amazon_sales
WHERE Sales = 8.79 AND Sub_Category = 'Furnishings' AND State = 'Illinois';

DELETE FROM amazon_sales
WHERE ID = 893;

SELECT *
FROM amazon_sales
WHERE Postal_Code = 92627 AND Sub_Category = 'Binders' AND Discount = 20;

DELETE FROM amazon_sales
WHERE ID = 457;

SELECT *
FROM amazon_sales
WHERE Postal_Code = '47150' AND Sub_Category = 'Binders' AND Discount = 0;

DELETE FROM amazon_sales
WHERE ID = 105;

SELECT *
FROM amazon_sales
WHERE Postal_Code = '10024' AND Sub_Category = 'Machines' AND Discount = 0;

DELETE FROM amazon_sales
WHERE ID = 294;

SELECT *
FROM amazon_sales
WHERE Postal_Code = '60610' AND Sub_Category = 'Furnishings' AND Discount = 60;

DELETE FROM amazon_sales
WHERE ID = 297;

SELECT *
FROM amazon_sales
WHERE Postal_Code = '30318' AND Sub_Category = 'Art' AND Discount = 0;

DELETE FROM amazon_sales
WHERE ID = 477;

SELECT *
FROM amazon_sales
WHERE Postal_Code = '47201' AND Sub_Category = 'Furnishings' AND Discount = 0;

DELETE FROM amazon_sales
WHERE ID = 490;

SELECT *
FROM amazon_sales
WHERE Postal_Code = '22153' AND Sub_Category = 'Appliances' AND Discount = 0;

DELETE FROM amazon_sales
WHERE ID = 915;

SELECT *
FROM amazon_sales
WHERE Postal_Code = '19120' AND Sub_Category = 'Phones' AND Discount = 40;

DELETE FROM amazon_sales
WHERE ID = 936;

-- Case 3's trial & error --

SELECT Purchase_Date,
	CASE 
		WHEN purchase_date LIKE '___-__'
		THEN STR_TO_DATE(purchase_date, '%b-%y') 
	END Case3
FROM amazon_sales;

SELECT purchase_date,
STR_TO_DATE(TRIM(purchase_date), '%b-%y')
FROM amazon_sales
WHERE purchase_date LIKE '___-__';

SELECT purchase_date,
STR_TO_DATE(CONCAT('01-', purchase_date), '%d-%b-%y') AS Case3
FROM amazon_sales;

SELECT Purchase_Date,
	CASE 
		-- Case 1: DD/MM/YYYY
        WHEN purchase_date LIKE '__/__/____'
        THEN STR_TO_DATE(purchase_date, '%d/%m/%Y')
       
       -- Case 2: YYYY/MM/DD
       WHEN purchase_date LIKE '____/__/__'
	   THEN CAST(purchase_date AS DATE)
       
       -- Case 3: MMM-YY
       WHEN purchase_date LIKE '___-__'
       THEN STR_TO_DATE(CONCAT('01-', purchase_date), '%d-%b-%y')
       
       -- Case 4: YYYY-MM-DD
       WHEN purchase_date LIKE '____-__-__'
	   THEN CAST(purchase_date AS DATE)
       
       -- Case 5: MM-DD-YY
       WHEN purchase_date LIKE '__-__-__'
       THEN STR_TO_DATE(purchase_date, '%m-%d-%y')
       
       -- Case 6: DD MMM YYYY
       WHEN purchase_date LIKE '__ ___ ____'
       THEN STR_TO_DATE(purchase_date, '%d %b %Y')
END AS cleaned_purchase_date2
FROM amazon_sales;

UPDATE amazon_sales
SET cleaned_purchase_date =
	CASE
        WHEN purchase_date LIKE '__/__/____'
        THEN STR_TO_DATE(purchase_date, '%d/%m/%Y')
       
       WHEN purchase_date LIKE '____/__/__'
	   THEN CAST(purchase_date AS DATE)
       
       WHEN purchase_date LIKE '___-__'
       THEN STR_TO_DATE(CONCAT('01-', purchase_date), '%d-%b-%y')
	
       WHEN purchase_date LIKE '____-__-__'
	   THEN CAST(purchase_date AS DATE)
       
       WHEN purchase_date LIKE '__-__-__'
       THEN STR_TO_DATE(purchase_date, '%m-%d-%y')
       
       WHEN purchase_date LIKE '__ ___ ____'
       THEN STR_TO_DATE(purchase_date, '%d %b %Y')
END;

SELECT purchase_date, cleaned_purchase_date
FROM amazon_sales;

ALTER TABLE amazon_sales DROP COLUMN purchase_date;

ALTER TABLE amazon_sales CHANGE COLUMN cleaned_purchase_date purchase_date DATE;

-- Now I can give row numbers --

-- Trial 1: 
SELECT *,
ROW_NUMBER () 
OVER(PARTITION BY Ship_Mode, Segment, City, Postal_Code, Region, Category, Sub_Category, Sales, Quantity, Discount, Profit, Purchase_date) AS Row_Num
FROM amazon_sales;

-- Trial 2:
SELECT *,
ROW_NUMBER () 
OVER(ORDER BY purchase_date) AS Row_Num
FROM amazon_sales;

-- Trial 3:
SELECT *,
CASE
	WHEN ROW_NUMBER() OVER(
    PARTITION BY Ship_Mode, Segment, City, Postal_Code, Region, Category, 
    Sub_Category, Sales, Quantity, Discount, Profit
	ORDER BY Purchase_Date) = 1
    THEN 1 ELSE 2
END AS row_num
FROM amazon_sales;

ALTER TABLE amazon_sales
ADD COLUMN ID INT PRIMARY KEY;

SELECT Ship_Mode, Segment, City, State, Postal_Code, Region, Category, Sub_Category, Sales, Quantity, Discount, Profit, 
COUNT(*)  AS Duplicates
FROM amazon_sales
GROUP BY Category, Ship_Mode, Segment, City, State, Postal_Code, Region, Sub_Category, Sales, Quantity, Discount, Profit
HAVING COUNT(*) > 1;

-- Standardise Data --
SELECT DISTINCT Ship_Mode
FROM amazon_sales;

UPDATE amazon_sales
SET Ship_Mode = REPLACE(Ship_Mode, '2nd Class', 'Second Class');

UPDATE amazon_sales
SET Ship_Mode = REPLACE(Ship_Mode, '1st Class', 'First Class');

UPDATE amazon_sales
SET Ship_Mode = REPLACE(Ship_Mode, 'Standard Classs', 'Standard Class');

SELECT DISTINCT Category
FROM amazon_sales
ORDER BY Category ASC;

UPDATE amazon_sales
SET Category = REPLACE(Category, 'Technlogy', 'Technology');

UPDATE amazon_sales
SET Category = REPLACE(Category, 'Offfice supplies', 'Office Supplies');

UPDATE amazon_sales
SET Category = REPLACE(Category, 'Furnture', 'Furniture');

UPDATE amazon_sales
SET Category = REPLACE(Category, 'Eletronics', 'Electronics');

SELECT TRIM(Category) AS Category
FROM amazon_sales; 

UPDATE amazon_sales
SET Category = TRIM(Category); 

SELECT DISTINCT Category 
FROM amazon_sales;

SELECT *
FROM amazon_sales
WHERE Category = 'CLOTHS'
ORDER BY Category ASC;

UPDATE amazon_sales
SET Category = 'Technology'
WHERE ID = 381 AND Category = 'CLOTHS';

UPDATE amazon_sales
SET Category = 'Office Supplies'
WHERE ID = 188 AND Category = 'CLOTHS';

SELECT DISTINCT Sales 
FROM amazon_sales;

SELECT * FROM amazon_sales;

SELECT TRIM(City) AS City
FROM amazon_sales; 

UPDATE amazon_sales
SET City = TRIM(City); 

SELECT City, State, ID, Postal_Code
FROM amazon_sales
WHERE City = 'nan';

SELECT *
FROM amazon_sales
WHERE State = 'New York';

UPDATE amazon_sales
SET City = REPLACE(City, 'nam', NULL)
WHERE State = 'New York';

UPDATE amazon_sales
SET City = 'New York City'
WHERE State = 'New York' AND City IS NULL;

SELECT *
FROM amazon_sales
WHERE State = 'Texas' AND Postal_Code = 75220;

UPDATE amazon_sales
SET City = 'Dallas'
WHERE State = 'Texas' AND Postal_Code = 75220;

UPDATE amazon_sales
SET City = 'Tyler'
WHERE State = 'Texas' AND Postal_Code = 75701;

SELECT *
FROM amazon_sales
WHERE State = 'New Jersey' AND Postal_Code = 8701;

UPDATE amazon_sales
SET City = 'Lakewood'
WHERE State = 'New Jersey' AND Postal_Code = 8701;

SELECT *
FROM amazon_sales
WHERE State = 'California' AND Postal_Code = 90045;

UPDATE amazon_sales
SET City = 'Los Angeles'
WHERE State = 'California' AND Postal_Code = 90045;

SELECT *
FROM amazon_sales
WHERE State = 'Indiana' AND Postal_Code = 47201;

UPDATE amazon_sales
SET City = 'Columbus'
WHERE State = 'Indiana' AND Postal_Code = 47201;

SELECT *
FROM amazon_sales
WHERE State = 'Tennessee' AND Postal_Code = 38401;

UPDATE amazon_sales
SET City = 'Columbia'
WHERE State = 'Tennessee' AND Postal_Code = 38401;

SELECT *
FROM amazon_sales
WHERE State = 'Pennsylvania' AND Postal_Code = 19143;

UPDATE amazon_sales
SET City = 'Philadelphia'
WHERE State = 'Pennsylvania' AND Postal_Code = 19143;

SELECT *
FROM amazon_sales
WHERE State = 'Colorado' AND Postal_Code = 80013;

UPDATE amazon_sales
SET City = 'Aurora'
WHERE State = 'Colorado' AND Postal_Code = 80013;

SELECT *, ROUND(Sales, 2) AS Sales_Total
FROM amazon_sales;

SELECT Sales
FROM amazon_sales
ORDER BY Sales DESC;

ALTER TABLE amazon_sales
ADD COLUMN Sales_Total DECIMAL(8,2);

UPDATE amazon_sales
SET Sales_Total = ROUND(Sales,2);

ALTER TABLE amazon_sales DROP COLUMN Sales;

ALTER TABLE amazon_sales CHANGE COLUMN Sales_Total Sales DECIMAL(8,2);

SELECT (Discount * 100) AS Discount_Percentage
FROM amazon_sales
ORDER BY Discount_Percentage DESC;

ALTER TABLE amazon_sales
ADD COLUMN Discount_Percentage INT;

UPDATE amazon_sales
SET Discount_Percentage = (Discount * 100);

ALTER TABLE amazon_sales DROP COLUMN Discount;

ALTER TABLE amazon_sales CHANGE COLUMN Discount_Percentage Discount INT;

SELECT * 
FROM amazon_sales
WHERE Quantity < 0;

UPDATE amazon_sales
SET Quantity = 3
WHERE ID = 427;

SELECT * 
FROM amazon_sales
WHERE Quantity > 0
ORDER BY Quantity DESC;

DELETE FROM amazon_sales
WHERE ID = 775;

DELETE FROM amazon_sales
WHERE ID = 467;

DELETE FROM amazon_sales
WHERE ID = 453;

SELECT *
FROM amazon_sales
ORDER BY Sales DESC;

DELETE FROM amazon_sales
WHERE ID = 546;

SELECT *
FROM amazon_sales
ORDER BY Profit;

SELECT Quantity, Sales, Profit, Discount, ID
FROM amazon_sales
WHERE Quantity = 0;

DELETE FROM amazon_sales
WHERE ID = 16;

-- NULL & Blank values --
SELECT DISTINCT City
FROM amazon_sales
ORDER BY City ASC;

SELECT *
FROM amazon_sales 
WHERE Postal_Code = 95123;

UPDATE amazon_sales
SET City = 'San Jose'
WHERE ID = 117;

SELECT *
FROM amazon_sales
WHERE City = '';

SELECT City, State, Postal_Code
FROM amazon_sales
WHERE Postal_Code = '98103';

UPDATE amazon_sales
SET City = 'Seattle'
WHERE ID = 652;

SELECT City, State, Postal_Code
FROM amazon_sales
WHERE Postal_Code = '3301';

UPDATE amazon_sales
SET City = 'Concord'
WHERE ID = 780;

SELECT City, State, Postal_Code
FROM amazon_sales
WHERE Postal_Code = '19134';

UPDATE amazon_sales
SET City = 'Philadelphia'
WHERE ID = '911';

SELECT City, State, Postal_Code
FROM amazon_sales
WHERE Postal_Code = '55407';

UPDATE amazon_sales
SET City = 'Minneapolis'
WHERE ID = '976';

SELECT *
FROM amazon_sales
WHERE Category = '';

SELECT DISTINCT Sub_Category, Category
FROM amazon_sales
ORDER BY Sub_Category ASC;

SELECT Sub_Category, Category, ID
FROM amazon_sales
WHERE Sub_Category = 'Paper'
ORDER BY Sub_Category ASC;

UPDATE amazon_sales
SET Category = 'Office Supplies'
WHERE Sub_Category = 'Paper' AND ID = '16';

UPDATE amazon_sales
SET Category = 'Office Supplies'
WHERE Category = 'Furniture' AND Sub_Category = 'Paper' AND ID = '949';

UPDATE amazon_sales
SET Category = 'Technology'
WHERE Sub_Category IN ('Phones', 'Accessories')
	AND ID IN ('92', '427', '968', '611');

UPDATE amazon_sales
SET Category = 'Furniture'
WHERE Sub_Category = 'Furnishings' AND ID = '194';

UPDATE amazon_sales
SET Category = 'Office Supplies'
WHERE Sub_Category IN ('Storage', 'Binders', 'Supplies', 'Appliances')
	AND ID IN ('320', '360', '343', '453', '469', '587', '717');

UPDATE amazon_sales
SET Category = 'Furniture'
WHERE Sub_Category = 'Chairs' 
	AND ID IN ('467', '775');

UPDATE amazon_sales
SET Category = 'Office Supplies'
WHERE Category = 'Furniture' AND Sub_Category = 'Supplies' AND ID = '407';

SELECT *
FROM amazon_sales
WHERE Sales = 102.36 AND Sub_Category = 'Furnishings' AND purchase_date IS NULL;

DELETE FROM amazon_sales
WHERE Sales = 102.36 AND Sub_Category = 'Furnishings' AND purchase_date IS NULL;

DELETE 
FROM amazon_sales
WHERE purchase_date IS NULL;

SELECT * FROM amazon_sales;
