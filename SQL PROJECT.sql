create database projects;
use projects;

# Retrive all the data from table
select*from amazon_sales;

#TOTAL ROWS
SELECT COUNT(*) FROM amazon_sales;

#TOTAL SALES
SELECT SUM(Total_Sales) AS Total_Sales FROM  amazon_sales;

# UNIQUE PRODUCT
SELECT  DISTINCT Product FROM amazon_sales;

# UNIQUE PRODUCT COUNT
SELECT COUNT( DISTINCT Product) AS Products FROM amazon_sales;

# TOP 5 PRODUCTS TOTAL SALES
select Product, sum(Total_Sales) AS Total_sales_by_Product
from amazon_sales
GROUP BY Product
ORDER BY Total_sales_by_Product DESC
LIMIT 5;

# TOP 10 CUSTOMER WHO PURCHASED MORE NUMBER OF PRODUCTS
SELECT Customer_Name, COUNT(Product) AS Customer_buy_More_Product
FROM amazon_sales
GROUP BY Customer_Name
ORDER BY Customer_buy_More_Product DESC
LIMIT 10;

# LOCATION WISE TOP SALE 
SELECT Customer_Location,SUM(Total_Sales) AS Highest_Sale
FROM amazon_sales
GROUP BY Customer_Location
ORDER BY Highest_Sale DESC;

select*from amazon_sales;

# Highest Sale Customer Location
SELECT Customer_Location, MAX(Total_Sales) AS Highest_Sale_Customer_Location
FROM amazon_sales
GROUP BY Customer_Location
ORDER BY Highest_Sale_Customer_Location DESC
LIMIT 5;

# TOTAL NUMBER OF STOCKS BY CATEGORY
SELECT Category,COUNT(Quantity) AS Category_of_Stock
FROM amazon_sales
GROUP BY Category
ORDER BY Category_of_stock DESC;

# HIGHEST SALES BY MONTH
SELECT DATE_FORMAT(ORDER_Date,'%M') AS MONTHS, SUM(Total_Sales) AS SALES
FROM amazon_sales
GROUP BY MONTHS
ORDER BY SALES DESC;

# A DAY HAS MOST SALE
SELECT DATE_FORMAT(ORDER_Date,'%e %W %M') AS DAY_OF_WEEK, SUM(Total_Sales) AS SALES
FROM amazon_sales
GROUP BY DAY_OF_WEEK
ORDER BY SALES DESC;

# A DAY HAS MINIMUN SALES
SELECT DATE_FORMAT(ORDER_Date,'%e %W %M') AS DAY_OF_WEEK, MIN(Total_Sales) AS SALES
FROM amazon_sales
GROUP BY DAY_OF_WEEK
ORDER BY SALES ASC;

# MAXIMUM PRICE BY  CATEGORY
SELECT Category,MAX(Price) AS PRICE
FROM amazon_sales
GROUP BY Category
ORDER BY PRICE DESC;

# CUSTOMER WHO BUY PRODUCTS MULTIPLE TIMES
SELECT Customer_Name,Customer_Location,COUNT(Total_Sales) AS CUSTOMER_PURCHASED
from amazon_sales
GROUP BY Customer_Name,Customer_Location
ORDER BY CUSTOMER_PURCHASED DESC;

select*from amazon_sales;

# DISTINCT PAYMENT METHODD
SELECT DISTINCT Payment_Method from amazon_sales;

# PRODUCTS BELONG TO EACH CATEGORY
SELECT Category, Product,COUNT(Product) AS No_of_Products
FROM amazon_sales
GROUP BY Category, Product
ORDER BY No_of_Products DESC;
