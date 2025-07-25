USE [GSTHSMS]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SPAccountant]
    @flag NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    IF @flag = 'FetchWorkerInformationAD'
    BEGIN
        SELECT
  st.SubTypeName AS [Role],
  wd.WorkerName,
  wd.WorkerContactNo AS [Contact],
  CONVERT(date, wd.JoiningDate) AS [Date],
  wd.BaseSalary,
  FORMAT(v.Date, 'yyyy-MM') AS AttendanceMonth,
  COUNT(*) AS DaysPresent,
  CAST(wd.BaseSalary / 30.0 AS decimal(10, 2)) AS PerdayPayment,
  CAST((wd.BaseSalary / 30.0) * COUNT(*) AS decimal(10, 2)) AS AmountToBePaid
FROM GSTtblWorkerDetails wd
INNER JOIN GSTtblBankDetails bd ON wd.WorkerCode = bd.AllCode
INNER JOIN GSTtblSubTypes st ON wd.SubTypeId = st.SubTypeId
INNER JOIN GSTtblTypes tt ON st.TypeId = tt.TypeId
INNER JOIN GSTtblVisitor v ON wd.WorkerCode = v.VisitorName
WHERE tt.TypeId = 17
  AND v.VisitorName IN ('WOR001', 'WOR004', 'WOR006')
GROUP BY
  st.SubTypeName,
  wd.WorkerName,
  wd.WorkerContactNo,
  wd.JoiningDate,
  wd.BaseSalary,
  FORMAT(v.Date, 'yyyy-MM')
ORDER BY
  wd.WorkerName,
  FORMAT(v.Date, 'yyyy-MM') DESC;
    END
END
