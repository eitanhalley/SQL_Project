-- JOIN מטלה 1 שאילת עם 3 

SELECT TOP 10 S.SurfBoardName, TotalRevenue = SUM(S.BasePrice + CZ.CustomizePrice) 
FROM SURFBOARDS AS S JOIN ORDERS AS O ON S.OrderID = O.OrderID 
JOIN CUSTOMIZES AS CZ ON S.SurfBoardID = CZ.SurfBoardID
GROUP BY S.SurfBoardName
HAVING SUM(S.BasePrice + CZ.CustomizePrice)>0
ORDER BY SUM(S.BasePrice + CZ.CustomizePrice) DESC

-- JOIN מטלה 1 שאילת עם 3 

SELECT  O.Country, NumberOfOrders=COUNT(o.OrderID), 
		NumberOfCustomize=COUNT(DISTINCT u.OrderID)
from CUSTOMERS as c join ORDERS as o on c.EmailAddress = o.EmailAddress 
		join CUSTOMIZES as u on o.OrderID = u.OrderID
WHERE YEAR(o.DelivaryDate)  = 2020
GROUP BY o.Country
ORDER BY COUNT(o.OrderID)

--  מטלה 1 שאילת מקוננת

select [Full Name] = c.FiratName +' '+c.LastName, c.EmailAddress, o.Weight
from ORDERS as o join CUSTOMERS as c on o.EmailAddress = c.EmailAddress
where month(o.DelivaryDate) between 9 and 12 And o.Weight > ( 
		select cast (AVG(o.Weight) as real)
		from ORDERS as o
		Where month(o.DelivaryDate) between 9 and 12 )
order by o.DelivaryDate


--מטלה 1 שאילת מקוננת 

SELECT		 o.country,S.SurfBoardName
FROM		 ORDERS AS O JOIN Customers AS C ON O.EmailAddress = C.EmailAddress
			 JOIN SURFBOARDS AS S ON S.OrderID = O.OrderID
WHERE		 o.Country  = (
							SELECT		TOP 1 Country
							FROM		ORDERS AS OO 									
							GROUP BY	Country
							ORDER BY COUNT(EmailAddress) DESC
							)
GROUP BY	o.country,S.SurfBoardName
ORDER BY	COUNT(S.SurfBoardName) DESC

--  מטלה 1 שאילת מקוננת תוך שימוש במרכיבים נוספים UPDATE

ALTER TABLE CUSTOMERS 	ADD		NumOfOrders   Int

UPDATE	CUSTOMERS
SET NumOfOrders = (
				SELECT	COUNT (*) 
				FROM 	ORDERS
				WHERE	CUSTOMERS.EmailAddress = ORDERS.EmailAddress
				)


SELECT *
FROM dbo.CUSTOMERS

--  מטלה 1 שאילת מקוננת תוך שימוש במרכיבים נוספים INTERSECT

SELECT C.EmailAddress, C.FiratName, C.LastName
FROM dbo.ORDERS AS O JOIN dbo.CUSTOMERS AS C ON C.EmailAddress = O.EmailAddress
GROUP BY C.EmailAddress, C.FiratName, C.LastName
HAVING COUNT(O.OrderID)>(
                       SELECT COUNT(OO.OrderID)/COUNT(DISTINCT OO.EmailAddress)
			  FROM ORDERS AS OO
		         )

INTERSECT
SELECT C.EmailAddress, C.FiratName, C.LastName
FROM dbo.ORDERS AS O JOIN dbo.CUSTOMERS AS C ON C.EmailAddress = O.EmailAddress
where O.Weight >= (SELECT AVG(OO.Weight) FROM dbo.ORDERS AS OO )
GROUP BY O.OrderID,C.EmailAddress, C.FiratName, C.LastName


-- VIEW מטלה 2 

CREATE VIEW CREDITCARDS_ForCustomerService AS 
SELECT C.CardNumber , C.CompanyCard , C.ExpirationYear , C.ExpirationMonth, C.OwnerID 
FROM CREDITCARDS AS C

SELECT*
FROM CREDITCARDS_WithOutCVV


-- פונקציה סקלרית מטלה 2

CREATE FUNCTION SoldSurfboardS (@BoardName VARCHAR(20)) 
RETURNS INT 
AS BEGIN 
DECLARE @Amount INT 
SELECT  @Amount=COUNT(*)
FROM dbo.SURFBOARDS
WHERE SurfBoardName=@BoardName 
RETURN  @Amount
END

-- פונקציה טבלאית מטלה 2

CREATE FUNCTION BoardsInMonth (
    @order_In_Month INT
)
RETURNS TABLE
AS
RETURN
    SELECT 
        o.OrderID,
        s.SurfBoardName,
        [Month of Sale] = MONTH(o.DelivaryDate) 
    FROM
        ORDERS as o join SURFBOARDS as s on o.OrderID = s.OrderID
    WHERE
        MONTH(o.DelivaryDate) = @order_In_Month;


-- מטלה 2 TRIGGER
CREATE TRIGGER dbo.UpdateDates
	ON dbo.ORDERS
	FOR UPDATE, INSERT
AS
	UPDATE ORDERS
	SET DelivaryDate = GETDATE(), pickup =  DATEADD(month,2, GETDATE())
	FROM  INSERTED
WHERE ORDERS.EmailAddress = INSERTED.EmailAddress


UPDATE ORDERS SET Weight = 20
	WHERE MONTH(PickUp) = 9 AND YEAR(PickUp) =  2021


-- מטלה 2 פרוצדורה שמורה 
create procedure [dbo].[Base_Price_update]
			@SurfBoardName int, @Discount real, @updtadeYtype varchar(4) 
			as
	If @updtadeYtype  = 'up' 
	BEGIN
     Update SURFBOARDS 
		set SURFBOARDS.BasePrice = SURFBOARDS.BasePrice * (1+@Discount) where SURFBOARDS.SurfBoardName = @SurfBoardName
	END
	Else If @updtadeYtype  = 'down'
	BEGIN
    Update SURFBOARDS 
		set SURFBOARDS.BasePrice = SURFBOARDS.BasePrice * (1-@Discount) where SURFBOARDS.SurfBoardName = @SurfBoardName
	END
GO

-- מטלה 3

Create VIEW TOTAL_REVENUE as
SELECT  TotalRevenue =SUM(S.basePrice) + SUM(CZ.CustomizePrice)
from ORDERS as O JOIN SURFBOARDS AS S ON O.OrderID = S.OrderID 
JOIN CUSTOMIZES AS CZ ON CZ.OrderID = O.OrderID


CREATE VIEW	BOARDSVSCUSTOM_REV1 AS
SELECT [MONTH] = MONTH(O.delivarydate),
TotalRevenue =SUM(S.basePrice) + SUM(CZ.CustomizePrice)
FROM ORDERS AS O JOIN SURFBOARDS AS S ON O.OrderID = S.OrderID 
JOIN CUSTOMIZES AS CZ ON CZ.OrderID = O.OrderID
GROUP BY MONTH(O.delivarydate)


CREATE VIEW AVARAGE_ORDER_COST AS
SELECT  TOP 5  AvarageOrderCost = AVG(S.BasePrice),[Full Name] = C.FirstName+' '+C.LastName 
from ORDERS as O JOIN SURFBOARDS AS S ON O.OrderID = S.OrderID JOIN CUSTOMERS 
AS C ON O.EmailAddress = C.EmailAddress
GROUP BY C.FirstName, C.LastName


Create VIEW COUNTRIES_REVENUE3 as
SELECT TOP 10 O.country, TotalRevenue =SUM(S.basePrice) + SUM(CZ.CustomizePrice)
from ORDERS as O JOIN SURFBOARDS AS S ON O.OrderID = S.OrderID 
JOIN CUSTOMIZES AS CZ ON CZ.OrderID = O.OrderID
group by country
ORDER BY TotalRevenue DESC


--מטלה 4 כלי מורכב (SP או Trigger) העושה שימוש בסמן (Cursor) 

ALTER TABLE Customers
ADD [Customers_Class_Type] varchar(30)
ALTER TABLE Customers
ADD CHECK ([Customers_Class_Type] LIKE 'A-Class' OR [Customers_Class_Type] LIKE 'B-Class')


CREATE FUNCTION Order_Quantity (@Email varchar(50))
RETURNS Integer
AS
BEGIN
DECLARE @Number Integer
SELECT @Number = count(*)
FROM ORDERS
Where Orders.EmailAddress = @Email
GROUP BY EmailAddress
RETURN @Number
END

CREATE TRIGGER [dbo].[Update_Customer_Class]
ON [dbo].[ORDERS]
FOR INSERT AS
DECLARE @Email varchar(30)
DECLARE c CURSOR FOR
SELECT CUSTOMERS.EmailAddress FROM Customers
BEGIN OPEN c
FETCH NEXT FROM c
Into @Email
While (@@FETCH_STATUS=0)
Begin
IF
(dbo.Order_Quantity(@Email)>6)
UPDATE Customers set [Customers_Class_Type] = 'A-Class' where @Email=Customers.EmailAddress
ELSE
UPDATE Customers set [Customers_Class_Type] = 'B-Class' where @Email=Customers.EmailAddress
FETCH NEXT FROM c
Into @Email
END
Close c
Deallocate c
END


-- מטלה 4 שאילתות עסקיות המשלבות Window Functions


-- VIEW TOTAL_COST
CREATE VIEW TOTAL_COST
AS
SELECT O.OrderID, O.DelivaryDate, [Surfboard Cost] = SUM (S.BasePrice),[Customize Cost]  = SUM(CU.CustomizePrice) ,
		 [total cost] = SUM (S.BasePrice +CU.CustomizePrice )
FROM dbo.ORDERS AS O  JOIN dbo.SURFBOARDS AS S ON S.OrderID = O.OrderID
		JOIN dbo.CUSTOMIZES AS CU ON CU.SurfBoardID = S.SurfBoardID
GROUP BY O.OrderID, O.DelivaryDate

--VIEW AVG_MONTHLY_INCOME
CREATE VIEW AVG_MONTHLY_INCOME
AS
SELECT [YEAR] = YEAR(Delivarydate),[MONTH]=MONTH(Delivarydate) ,[Monthly AVG Income Surfboard] = AVG( [Surfboard Cost]),
		[Monthly AVG Income Customize] = AVG([Customize Cost])  ,[Monthly AVG Income] = AVG([total cost])
FROM dbo.total_cost
GROUP BY YEAR(Delivarydate),MONTH(Delivarydate)

--VIEW ANALYZE_SALES
CREATE VIEW ANALYZE_SALES
AS
SELECT [YEAR], [MONTH],
	[Differnce Between AVG Mounths Surfboard] = [Monthly AVG Income Surfboard] - (LEAD([Monthly AVG Income Surfboard], 1)
	OVER (ORDER BY [YEAR],[MONTH])), [Best AVG yearly sale Surfboard] = LAST_VALUE ([Monthly AVG Income Surfboard])
	OVER (PARTITION BY [YEAR] ORDER BY [Monthly AVG Income Surfboard] ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),
	
	[Differnce Between AVG Mounths Customize] = [Monthly AVG Income Customize] - (LEAD([Monthly AVG Income Customize], 1)
	OVER (ORDER BY [YEAR],[MONTH])), [Best AVG yearly sale Customize] = LAST_VALUE ([Monthly AVG Income Customize])
	OVER (PARTITION BY [YEAR] ORDER BY [Monthly AVG Income Customize] ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),

	[Differnce Between AVG Mounths] = [Monthly AVG Income] - (LEAD([Monthly AVG Income], 1)
	OVER (ORDER BY [YEAR],[MONTH])), [Best AVG yearly sale] = LAST_VALUE ([Monthly AVG Income])
	OVER (PARTITION BY [YEAR] ORDER BY [Monthly AVG Income] ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING )

FROM AVG_MONTHLY_INCOME


-- VIEW SURFBOARD_ORDERS 
CREATE VIEW SURFBOARD_ORDERS AS
SELECT S.SurfBoardName, [YEAR]= YEAR (O.DelivaryDate), [NumOfOrders]= COUNT(*)

FROM  dbo.ORDERS AS O JOIN dbo.SURFBOARDS AS S ON S.OrderID = O.OrderID 
GROUP BY  S.SurfBoardName,YEAR (O.DelivaryDate)

--VIEW RANK_SURFBOARDS
CREATE VIEW RANK_SURFBOARDS AS
 SELECT SurfBoardName, [YEAR], [NumOfOrders],
	RANK() OVER ( PARTITION BY [YEAR] ORDER BY [NumOfOrders] DESC) AS [Rank] 

 FROM SURFBOARD_ORDERS
 GROUP BY SurfBoardName, [YEAR], [NumOfOrders]


 --VIEW RANK_SURFBOARDS_DIFF
 CREATE VIEW RANK_SURFBOARDS_DIFF AS
 SELECT SurfBoardName, [YEAR], [NumOfOrders],[RANK],
[Rank Diff] = LAG([NumOfOrders],0) OVER (PARTITION BY [YEAR] ORDER BY [Rank]) -LEAD([NumOfOrders]) OVER (PARTITION BY [YEAR] ORDER BY [Rank])

 FROM  RANK_SURFBOARDS
 GROUP BY SurfBoardName, [YEAR], [NumOfOrders],[RANK]


 -- מטלה 4 שילוב מערכתי של מספר כלים

 CREATE FUNCTION  NotActualBuyer(@EmailAddress VARCHAR(50))
RETURNS INTEGER
AS
BEGIN
DECLARE @Answer INTEGER
SELECT @Answer = COUNT(EmailAddress)
FROM dbo.CUSTOMERS
WHERE @EmailAddress= EmailAddress AND NumOfOrders = 0
RETURN @Answer
END

--CREATE TABLE WINDOWSHOPPERS
CREATE TABLE WINDOWSHOPPERS(
EmailAddress		VARCHAR(50)		NOT NULL ,
FiratName			VARCHAR	(20)	NOT NULL,
LastName			VARCHAR(20)		NOT NULL,
PhoneNumber			VARCHAR(20)		NOT NULL,
NUMOFORDERS			INT				NOT NULL,

CONSTRAINT PK_WINDOWSHOPPERS	PRIMARY KEY (EmailAddress),
CONSTRAINT CK_WINDOWSHOPPERS	CHECK (EmailAddress LIKE '%@%.%'),

--TRIGGER AddToFormerCustomers
CREATE TRIGGER AddToFormerCustomers
ON dbo.CUSTOMERS AFTER DELETE AS INSERT INTO  DBO.WINDOWSHOPPERS
SELECT *
FROM deleted


ALTER TABLE dbo.ORDERS
ALTER COLUMN EmailAddress VARCHAR(50) NULL



--PROCEDURE DownGradeCustome
CREATE PROCEDURE DownGradeCustomer(@EmailAddress VARCHAR(50) ) AS 

UPDATE dbo.ORDERS
SET EmailAddress = NULL
WHERE dbo.NotActualBuyer(@EmailAddress) = 1 AND @EmailAddress = dbo.ORDERS.EmailAddress

DELETE dbo.CUSTOMERS
WHERE dbo.NotActualBuyer(@EmailAddress) = 1 AND @EmailAddress = dbo.CUSTOMERS.EmailAddress







