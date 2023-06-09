				/** E-COMMERCE MARKET DATABASE **/

--Q1.
/** ON SALEORDERS TABLE
HOW MANY SALES ARE MADE IN WHICH CITY
GET INFORMATION. **/
SELECT CITY, SUM(LINETOTAL) AS TOTALSALE FROM SALEORDERS
GROUP BY CITY
ORDER BY CITY

--Q2.
/** SALEORDERS TABLE BY CITIES
HOW MANY SALES ARE MADE IN WHICH MONTH
WRITE THE QUESTION TO REQUEST INFORMATION. **/
SELECT 
CITY,MONTH_,SUM(LINETOTAL) AS TOTALSALE
FROM SALEORDERS
GROUP BY CITY,MONTH_
ORDER BY CITY,MONTH_

--Q3.
/** LEARN ON WHICH DAY OF THE WEEK EACH CITY HAS THE MOST SALES
WE WANT TO MAKE SPECIAL CAMPAIGN FOR THE CITY AND DAYS ACCORDING TO HIM.
WRITE HOW MUCH SALES THE CITIES MADE ACCORDING TO THE DAYS OF THE WEEK. **/

SELECT CITY,DAYOFWEEK_,SUM(LINETOTAL) AS TOTALSALE

FROM SALEORDERS
GROUP BY CITY,DAYOFWEEK_

ORDER BY  CITY,DAYOFWEEK_

-- UPDATE SALEORDERS SET DAYOFWEEK_='01.PZT' WHERE DAYOFWEEK_='PAZARTESÝ'

--Q4.
/** LEARN ON WHICH DAY OF THE WEEK EACH CITY HAS THE MOST SALES
WE WANT TO MAKE SPECIAL CAMPAIGN FOR THE CITY AND DAYS ACCORDING TO HIM.
CITIES ACCORDING TO THE DAYS OF THE WEEK
WRITE THE QUESTION THAT BRINGS THE INFORMATION ON HOW MUCH SALES IT MADE. **/

SELECT 
DISTINCT CITY,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE CITY=S.CITY AND DAYOFWEEK_ = '01.PZT') AS PAZARTESI,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE CITY=S.CITY AND DAYOFWEEK_ = '02.SAL') AS SALI,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE CITY=S.CITY AND DAYOFWEEK_ = '03.ÇAR') AS CARSAMBA,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE CITY=S.CITY AND DAYOFWEEK_ = '04.PER') AS PERSEMBE,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE CITY=S.CITY AND DAYOFWEEK_ = '05.CUM') AS CUMA,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE CITY=S.CITY AND DAYOFWEEK_ = '06.CMT') AS CUMARTESI,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE CITY=S.CITY AND DAYOFWEEK_ = '07.PAZ') AS PAZAR
FROM SALEORDERS S
ORDER BY 1

--Q5.
/** TOP 5 BEST SELLING CATEGORIES OF EACH CITY
WRITE THE INQUIRY SUPPLIED.**/

SELECT
S.CITY,S1.CATEGORY1,SUM(S1.TOTALSALE) AS TOTALSALE
FROM SALEORDERS S
CROSS APPLY (SELECT TOP 5 CATEGORY1,SUM(LINETOTAL) AS TOTALSALE FROM SALEORDERS WHERE CITY =S.CITY GROUP BY CATEGORY1 ORDER BY 2 DESC) S1
GROUP BY S.CITY,S1.CATEGORY1
ORDER BY S.CITY,SUM(LINETOTAL) DESC

--Q6.
/** THE 3 BEST SELLING CATEGORIES IN EVERY CITY
AND THE 3 BEST SELLING SUB-CATEGORIES BELOW
WRITE THE INQUIRY SUPPLIED.**/

SELECT S.CITY, S1.CATEGORY1,S2.CATEGORY2,SUM(S2.TOTALSALE)
FROM SALEORDERS S
CROSS APPLY (SELECT TOP 3 CATEGORY1, SUM(LINETOTAL) AS TOTALSALE FROM SALEORDERS WHERE CITY=S.CITY GROUP BY CATEGORY1 ORDER BY 2 DESC) S1
CROSS APPLY (SELECT TOP 3 CATEGORY2, SUM(LINETOTAL) AS TOTALSALE FROM SALEORDERS WHERE CITY=S.CITY AND CATEGORY1=S1.CATEGORY1 GROUP BY CATEGORY2 ORDER BY 2 DESC) S2
GROUP BY CITY,S1.CATEGORY1,S2.CATEGORY2
ORDER BY 1,2,4 DESC

--Q7.
/** JOIN TABLES WITH JOIN
FILL THE SALEORDERS TABLE. **/

--TRUNCATE TABLE SALEORDERS

SELECT * FROM SALEORDERS

SET LANGUAGE Turkish
INSERT INTO SALEORDERS
(ID, USERNAME_, NAMESURNAME, TELNR1, TELNR2, COUNTRY, CITY, TOWN, ADDRESSTEXT, ORDERID, ITEMCODE, ITEMNAME, BRAND, CATEGORY1, CATEGORY2, CATEGORY3, CATEGORY4, AMOUNT, UNITPRICE, LINETOTAL, ORDERDATE, ORDERTIME, YEAR_, MONTH_, DAYOFWEEK_)
SELECT 
OD.ID,
U.USERNAME_,U.NAMESURNAME,U.TELNR1,U.TELNR2,
C.COUNTRY,CT.CITY,T.TOWN,ADR.ADDRESSTEXT,
O.ID,ITM.ITEMCODE,ITM.ITEMNAME,ITM.BRAND,ITM.CATEGORY1,ITM.CATEGORY2,ITM.CATEGORY3,ITM.CATEGORY4,
OD.AMOUNT,OD.UNITPRICE,OD.LINETOTAL, CONVERT(DATE,O.DATE_) AS ORDERDATE, CONVERT(time,O.DATE_) ORDERTIME,
YEAR(O.DATE_) AS YEAR_,DATENAME(MONTH,O.DATE_) AS MONTH_,DATENAME(DW,O.DATE_) AS DAYOFWEEK_

FROM ORDERS O
INNER JOIN ORDERDETAILS OD ON OD.ORDERID=O.ID
INNER JOIN ITEMS ITM ON ITM.ID=OD.ITEMID
INNER JOIN USERS U ON O.USERID=U.ID
INNER JOIN ADDRESS ADR ON ADR.ID=O.ADDRESSID
INNER JOIN COUNTRIES C ON C.ID=ADR.COUNTRYID
INNER JOIN CITIES CT ON CT.ID=ADR.CITYID
INNER JOIN TOWNS T ON T.ID=ADR.TOWNID

SELECT * FROM SALEORDERS

--Q8.
/** USING RELATED TABLES
HOW MANY SALES ARE MADE IN WHICH CITY
WRITE THE INQUIRY BRINGING INFORMATION **/

--1.
SET STATISTICS IO ON 
SELECT CT.CITY,SUM(O.TOTALPRICE) AS TOTALPRICE
FROM ORDERS O
INNER JOIN ADDRESS ADR ON ADR.ID = O.ADDRESSID
INNER JOIN CITIES CT ON CT.ID = ADR.CITYID
GROUP BY CT.CITY

--2.(SUBQUERY)
SET STATISTICS IO ON --PAGE(SQL 'ÝN EN KÜÇÜK YAPITAÞINA BAKAR 1 PAGE 8KB'DIR.)
SELECT * ,
(SELECT SUM(TOTALPRICE) FROM ORDERS WHERE ADDRESSID IN
	(
	SELECT ID FROM ADDRESS WHERE CITYID = C.ID
	)
)
FROM CITIES C

--Q9
/** EACH BRAND BY MAIN CATEGORY
WRITE THE QUESTION THAT BRINGS THE BEST SELLING CATEGORY1 FIELD. **/

--1.
SELECT 
ITM.BRAND, ITM.CATEGORY1,SUM(OD.LINETOTAL) AS TOTALPRICE
FROM 
ORDERDETAILS OD
INNER JOIN ITEMS ITM ON ITM.ID = OD.ITEMID
GROUP BY ITM.BRAND,ITM.CATEGORY1

--2.(SUBQUERY)

SELECT DISTINCT BRAND,CATEGORY1,
(SELECT SUM(LINETOTAL) FROM ORDERDETAILS WHERE ITEMID IN
	(
	SELECT ID FROM ITEMS WHERE BRAND = ITM.BRAND AND CATEGORY1 = ITM.CATEGORY1
	) 
)AS TOTALPRICE
FROM ITEMS ITM
ORDER BY BRAND,TOTALPRICE DESC

--Q10
/** INSIDE EACH CATEGORY
WRITE THE QUESTION THAT BRINGS THE BEST SELLING BRAND. **/

SELECT 
ITM.CATEGORY1,ITM.CATEGORY2,ITM.BRAND,SUM(OD.LINETOTAL) AS TOTALPRICE
FROM 
ORDERDETAILS OD
INNER JOIN ITEMS ITM ON ITM.ID = OD.ITEMID

GROUP BY ITM.CATEGORY1,ITM.CATEGORY2,ITM.BRAND

ORDER BY ITM.CATEGORY1,ITM.CATEGORY2,SUM(OD.LINETOTAL) DESC

--Q11
/** EACH PRODUCT IS SOLD WITH DIFFERENT PRICES OVER TIME.
WITH INFORMATION HOW MUCH EVERY PRODUCT IS SOLD AT MIN, MAX AND AVG
WRITE THE QUESTION THAT BRINGS THE INFORMATION HOW MANY TIMES AND HOW MANY SOLD IT WAS SOLD. **/

SELECT 
ITM.BRAND,ITM.CATEGORY1,ITM.ITEMCODE,ITM.ITEMNAME,
COUNT(OD.ID) AS SALECOUNT, SUM(OD.AMOUNT) AS TOTALAMOUNT,
MIN(OD.UNITPRICE) AS MINPRICE, MAX(OD.UNITPRICE) AS MAXPRICE,
AVG(OD.UNITPRICE) AS AVGPRICE
FROM ITEMS ITM
INNER JOIN ORDERDETAILS OD ON OD.ITEMID = ITM.ID
GROUP BY ITM.BRAND,ITM.CATEGORY1,ITM.ITEMCODE,ITM.ITEMNAME

--Q12
/** NUMBER OF ADDRESSES REGISTERED IN THE SYSTEM OF CUSTOMERS AND
WRITE THE INQUIRY BRINGING THE ADDRESS INFORMATION WHERE THE LAST SHOPPING MADE. **/

SELECT U.ID,U.NAMESURNAME,
(SELECT COUNT(*) FROM ADDRESS WHERE USERID=U.ID) AS ADDRESSCOUNT,
(
SELECT ADDRESSTEXT FROM ADDRESS WHERE ID IN 
	(
	SELECT TOP 1 ADDRESSID FROM ORDERS WHERE USERID = U.ID ORDER BY DATE_ DESC
	) 
)LASTSHOPPINGADDRESS
FROM USERS U

--Q13
/** NUMBER OF ADDRESSES REGISTERED IN THE SYSTEM OF CUSTOMERS AND
LAST SHOPPING ADDRESS INFORMATION CITY, DISTRICT AND NEIGHBORHOOD
WRITE THE QUESTION THAT BRINGS IT TOGETHER. **/


SELECT TMP.NAMESURNAME,TMP.ADDRESSCOUNT,C.CITY,T.TOWN,D.DISTRICT,A.POSTALCODE,A.ADDRESSTEXT FROM
(
SELECT U.ID,U.NAMESURNAME,
(SELECT COUNT(*) FROM ADDRESS WHERE USERID=U.ID) AS ADDRESSCOUNT,
(SELECT TOP 1 ADDRESSID FROM ORDERS WHERE USERID = U.ID ORDER BY DATE_ DESC)LASTADDRESSID
FROM USERS U
)TMP
INNER JOIN ADDRESS A ON A.ID = TMP.LASTADDRESSID
INNER JOIN CITIES C ON C.ID = A.CITYID
INNER JOIN TOWNS T ON T.ID = A.TOWNID
INNER JOIN DISTRICTS D ON D.ID = A.DISTRICTID

--Q14
/** FOR AT LEAST 10 DAYS IN JANUARY
ORDERING 500 TL AND UNDER DAILY
WRITE THE QUESTION LISTING CITIES.**/

SELECT CITY,COUNT(*) AS CITYCOUNT FROM
(
SELECT 
C.CITY,CONVERT(DATE,O.DATE_) AS DATE_,
SUM(O.TOTALPRICE) AS TOTALPRICE 
FROM ORDERS O
INNER JOIN ADDRESS A ON A.ID = O.ADDRESSID
INNER JOIN CITIES C ON C.ID = A.CITYID
WHERE O.DATE_ BETWEEN '20190101' AND '2019-01-31 23:59:59'
GROUP BY C.CITY,CONVERT(DATE,O.DATE_)
HAVING SUM(O.TOTALPRICE)<=500
) TMP
GROUP BY CITY
HAVING COUNT(CITY)>=10
ORDER BY CITY
