/*Best selling food, and flavor*/
--SAVE FOR VISUALIZATION
SELECT Food, COUNT(Food) AS [Most Popular Items]
FROM goods
GROUP BY Food
ORDER BY COUNT(Food) DESC
--As we can see the most popular food is the tart, followed by cake and tart

--SAVE FOR VISUALIZATION
SELECT TOP(10) Flavor, COUNT(Flavor) AS [Most Popular Flavores]
FROM goods
GROUP BY Flavor 
ORDER BY COUNT(Flavor) DESC
--No surprise that chocolate, followed by almond are the most popular flavors



/*Biggest order*/
--Number of items per receipt
SELECT Reciept, COUNT(Reciept) AS NumberOfItemsPerReceipt
FROM items
JOIN goods
ON items.Item = goods.Id
GROUP BY Reciept
ORDER BY NumberOfItemsPerReceipt DESC

--Biggest Orders 
SELECT Reciept, ROUND(SUM(Price),2) AS [Receipt Total]
FROM items
JOIN goods
ON goods.Id = items.Item
GROUP BY Reciept
ORDER BY [Receipt Total] DESC
--receipt number 83085 has the largest order with an amound due of $48.25



/*Best customer, in terms of money spent per order*/
SELECT 
	items.Reciept, 
	receipts.CustomerId, 
	customers.FirstName + '  ' + customers.LastName AS FullName, 
	ROUND(SUM(goods.Price),2) AS [Total Price Per Receipt]
FROM goods
JOIN items
	ON goods.Id = items.Item
JOIN receipts
	ON items.Reciept = receipts.RecieptNumber
JOIN customers
	ON receipts.CustomerId = customers.Id
GROUP BY CustomerId, Reciept, FirstName, LastName
ORDER BY [Total Price Per Receipt] DESC
--We can see that Sharron Toussand has the biggest order overall, in terms of order price per receipt



/*Best customer in terms of money spent overall*/
--SAVE FOR VISUALIZATION
DROP TABLE IF EXISTS #BestCustomers
CREATE TABLE #BestCustomers (
ReceiptNumber int,
CustomerID int,
FullName varchar(50),
TotalPricePerReceipt float(10)
)

INSERT INTO #BestCustomers
SELECT 
	items.Reciept, 
	receipts.CustomerId, 
	customers.FirstName + '  ' + customers.LastName AS FullName, 
	SUM(goods.Price) AS TotalPricePerReceipt
FROM goods
JOIN items
	ON goods.Id = items.Item
JOIN receipts
	ON items.Reciept = receipts.RecieptNumber
JOIN customers
	ON receipts.CustomerId = customers.Id
GROUP BY CustomerId, Reciept, FirstName, LastName
ORDER BY TotalPricePerReceipt DESC

SELECT FullName, ROUND(SUM(TotalPricePerReceipt), 2) AS [Total Spent per Customer]
FROM #BestCustomers
GROUP BY FullName
ORDER BY [Total Spent per Customer] DESC
--The top customer for this bakery is Rupert Heling who spent of $206.61 for the month of October, 2007



/*How much profit was made*/
--SAVE FOR VISUALIZATION
SELECT ROUND(SUM(TotalPricePerReceipt),2) AS [Total Sales for October] from #BestCustomers
--We see that the total sales for October, 2007 were $2197.86



/*Sales for each day*/
--SAVE FOR VISUALIZATION
SELECT receipts.[Date], ROUND(SUM(goods.Price),2) AS [Sales per Day]
FROM receipts
JOIN items
	ON receipts.RecieptNumber = items.Reciept
JOIN goods
	ON goods.Id = items.Item
GROUP BY receipts.[Date]
--Total sales for each day in October, 2007


/*Most Sales in one day*/
WITH SalesEachDay AS 
(SELECT receipts.Date, ROUND(SUM(goods.Price),2) AS SalesPerDay
FROM receipts
JOIN items
	ON receipts.RecieptNumber = items.Reciept
JOIN goods
	ON goods.Id = items.Item
GROUP BY receipts.Date)
SELECT MAX(SalesPerDay) AS [Highest Grossing Day] FROM SalesEachDay
--We can see that the most sold in one day was $169.87



/*Best day for sales*/
DROP TABLE IF EXISTS #SalesEachDay
CREATE TABLE #SalesEachDay (
[Date] date,
SalesPerDay float(10)
)

INSERT INTO #SalesEachDay
SELECT receipts.Date, SUM(goods.Price) AS SalesPerDay
FROM receipts
JOIN items
	ON receipts.RecieptNumber = items.Reciept
JOIN goods
	ON goods.Id = items.Item
GROUP BY receipts.Date

SELECT [Date], SalesPerDay AS [Most Sales in a Day]
FROM #SalesEachDay
WHERE SalesPerDay = (SELECT MAX(SalesPerDay) FROM #SalesEachDay)
--We can see the the highest grossing day was 12 of October, 2007 with $169.87



/*Average sales per day for the month of October*/
SELECT ROUND(AVG(SalesPerDay),2) AS [Average Sales Per Day] 
FROM #SalesEachDay
--The average sales each day was $70.90