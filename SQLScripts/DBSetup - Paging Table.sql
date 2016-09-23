
CREATE TABLE dbo.Orders
    (
      orderid INT ,
      orderdate INT ,
      custid INT ,
      empid INT
    )
DECLARE @pagenum AS INT = 3 ,
    @pagesize AS INT = 25;
WITH    C AS ( SELECT   ROW_NUMBER() OVER ( ORDER BY orderdate, orderid ) AS rownum ,
                        orderid ,
                        orderdate ,
                        custid ,
                        empid
               FROM     dbo.Orders
             )
    SELECT  orderid ,
            orderdate ,
            custid ,
            empid
    FROM    C
    WHERE   rownum BETWEEN ( @pagenum - 1 ) * @pagesize + 1
                   AND     @pagenum * @pagesize
    ORDER BY rownum;
 
SELECT  orderid ,
        orderdate ,
        custid ,
        empid
FROM    dbo.Orders
ORDER BY orderdate ,
        orderid
        OFFSET ( @pagenum - 1 ) * @pagesize ROWS FETCH NEXT @pagesize ROWS
        ONLY;