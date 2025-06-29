------------SELECT
------------  st.SubTypeName AS [Role],
------------  wd.WorkerName AS [Name],
------------  wd.WorkerContactNo AS [Contact],
------------  wd.JoiningDate AS [Date],
------------  wd.RegisterBy,
------------  wd.ShiftTiming,
------------  wd.Address,
------------  wd.BaseSalary,
------------  wd.Status,
------------  bd.BankId,
------------  bd.BankCode,
------------  bd.AllCode,
------------  bd.AccountTypeId,
------------  bd.AddedDate,
------------  bd.OpeningBalance,
------------  bd.IFSCCode,
------------  bd.UPIId,
------------  bd.AccountNo,
------------  bd.ISActive,
------------  tt.TypeName AS [WorkType]
------------FROM GSTtblWorkerDetails wd
------------INNER JOIN GSTtblBankDetails bd ON wd.WorkerCode = bd.AllCode
------------INNER JOIN GSTtblSubTypes st ON wd.SubTypeId = st.SubTypeId
------------INNER JOIN GSTtblTypes tt ON st.TypeId = tt.TypeId
------------WHERE tt.TypeId = 17;

----------SELECT
----------  wd.WorkerCode,
----------  wd.WorkerName,
----------  st.SubTypeName AS [Role],
----------  wd.WorkerContactNo AS [Contact],
----------  wd.JoiningDate AS [Date],
----------  wd.RegisterBy,
----------  wd.ShiftTiming,
----------  wd.Address,
----------  wd.BaseSalary,
----------  wd.Status,
----------  bd.BankId,
----------  bd.BankCode,
----------  bd.AccountNo,
----------  bd.IFSCCode,
----------  bd.UPIId,
----------  tt.TypeName AS [WorkType],
----------  FORMAT(v.Date, 'yyyy-MM') AS AttendanceMonth,
----------  COUNT(*) AS DaysPresent
----------FROM GSTtblWorkerDetails wd
----------INNER JOIN GSTtblBankDetails bd ON wd.WorkerCode = bd.AllCode
----------INNER JOIN GSTtblSubTypes st ON wd.SubTypeId = st.SubTypeId
----------INNER JOIN GSTtblTypes tt ON st.TypeId = tt.TypeId
----------INNER JOIN GSTtblVisitor v ON wd.WorkerCode = v.VisitorName
----------WHERE tt.TypeId = 17 -- Permanent workers only
----------  AND v.VisitorName = 'WOR001' -- You can remove this if you want all permanent workers
----------GROUP BY
----------  wd.WorkerCode,
----------  wd.WorkerName,
----------  st.SubTypeName,
----------  wd.WorkerContactNo,
----------  wd.JoiningDate,
----------  wd.RegisterBy,
----------  wd.ShiftTiming,
----------  wd.Address,
----------  wd.BaseSalary,
----------  wd.Status,
----------  bd.BankId,
----------  bd.BankCode,
----------  bd.AccountNo,
----------  bd.IFSCCode,
----------  bd.UPIId,
----------  tt.TypeName,
----------  FORMAT(v.Date, 'yyyy-MM')
----------ORDER BY AttendanceMonth;


----------SELECT
----------  wd.WorkerCode,
----------  wd.WorkerName,
----------  FORMAT(v.Date, 'yyyy-MM') AS AttendanceMonth,
----------  COUNT(*) AS AttendanceDays,
----------  wd.BaseSalary,
----------  (wd.BaseSalary / 30.0) AS DailyRate,
----------  ROUND((wd.BaseSalary / 30.0) * COUNT(*), 2) AS EarnedIncome
----------FROM GSTtblWorkerDetails wd
----------JOIN GSTtblVisitor v ON wd.WorkerCode = v.VisitorName
----------JOIN GSTtblSubTypes st ON wd.SubTypeId = st.SubTypeId
----------JOIN GSTtblTypes tt ON st.TypeId = tt.TypeId
----------WHERE tt.TypeId = 17
----------  AND v.VisitorName IN ('WOR001', 'WOR004', 'WOR006')
----------GROUP BY
----------  wd.WorkerCode,
----------  wd.WorkerName,
----------  wd.BaseSalary,
----------  FORMAT(v.Date, 'yyyy-MM')
----------ORDER BY AttendanceMonth;
----------abhi

----------19:30
--------SELECT
--------  wd.WorkerCode,
--------  wd.WorkerName,
--------  st.SubTypeName AS [Role],
--------  wd.WorkerContactNo AS [Contact],
--------  wd.JoiningDate AS [Date],
--------  --wd.RegisterBy,
--------  wd.ShiftTiming,
--------  wd.Address,
--------  wd.BaseSalary,
--------  wd.Status,
--------  bd.BankId,
--------  bd.BankCode,
--------  bd.AccountNo,
--------  bd.IFSCCode,
--------  bd.UPIId,
--------  tt.TypeName AS [WorkType],
--------  FORMAT(v.Date, 'yyyy-MM') AS AttendanceMonth,
--------  COUNT(*) AS DaysPresent,
--------  ROUND(wd.BaseSalary / 30.0, 2) AS DailyRate,
--------  ROUND((wd.BaseSalary / 30.0) * COUNT(*), 2) AS EarnedIncome
--------FROM GSTtblWorkerDetails wd
--------INNER JOIN GSTtblBankDetails bd ON wd.WorkerCode = bd.AllCode
--------INNER JOIN GSTtblSubTypes st ON wd.SubTypeId = st.SubTypeId
--------INNER JOIN GSTtblTypes tt ON st.TypeId = tt.TypeId
--------INNER JOIN GSTtblVisitor v ON wd.WorkerCode = v.VisitorName
--------WHERE tt.TypeId = 17  -- Only Permanent Workers
--------  AND v.VisitorName IN ('WOR001', 'WOR004', 'WOR006')  -- Include specific workers
--------GROUP BY
--------  wd.WorkerCode,
--------  wd.WorkerName,
--------  st.SubTypeName,
--------  wd.WorkerContactNo,
--------  wd.JoiningDate,
--------  wd.RegisterBy,
--------  wd.ShiftTiming,
--------  wd.Address,
--------  wd.BaseSalary,
--------  wd.Status,
--------  bd.BankId,
--------  bd.BankCode,
--------  bd.AccountNo,
--------  bd.IFSCCode,
--------  bd.UPIId,
--------  tt.TypeName,
--------  FORMAT(v.Date, 'yyyy-MM')
--------ORDER BY wd.WorkerName, AttendanceMonth;


------SELECT
------  st.SubTypeName AS [Role],
------  wd.WorkerName,
------  wd.WorkerContactNo AS [Contact],
------  CONVERT(date, wd.JoiningDate) AS [Date],
------  wd.BaseSalary,
------  FORMAT(v.Date, 'yyyy-MM') AS AttendanceMonth,
------  COUNT(*) AS DaysPresent,
------  ROUND(wd.BaseSalary / 30.0, 2) AS DailyRate,
------  ROUND((wd.BaseSalary / 30.0) * COUNT(*), 2) AS EarnedIncome
------FROM GSTtblWorkerDetails wd
------INNER JOIN GSTtblBankDetails bd ON wd.WorkerCode = bd.AllCode
------INNER JOIN GSTtblSubTypes st ON wd.SubTypeId = st.SubTypeId
------INNER JOIN GSTtblTypes tt ON st.TypeId = tt.TypeId
------INNER JOIN GSTtblVisitor v ON wd.WorkerCode = v.VisitorName
------WHERE tt.TypeId = 17
------  AND v.VisitorName IN ('WOR001', 'WOR004', 'WOR006')
------GROUP BY
------  st.SubTypeName,
------  wd.WorkerName,
------  wd.WorkerContactNo,
------  wd.JoiningDate,
------  wd.BaseSalary,
------  FORMAT(v.Date, 'yyyy-MM')
------ORDER BY
------  wd.WorkerName,
------  FORMAT(v.Date, 'yyyy-MM') DESC;



--------nice query 

--SELECT
--  st.SubTypeName AS [Role],
--  wd.WorkerName,
--  wd.WorkerContactNo AS [Contact],
--  CONVERT(date, wd.JoiningDate) AS [Date],
--  wd.BaseSalary,
--  FORMAT(v.Date, 'yyyy-MM') AS AttendanceMonth,
--  COUNT(*) AS DaysPresent,
--  CAST(wd.BaseSalary / 30.0 AS decimal(10, 2)) AS DailyRate,
--  CAST((wd.BaseSalary / 30.0) * COUNT(*) AS decimal(10, 2)) AS EarnedIncome
--FROM GSTtblWorkerDetails wd
--INNER JOIN GSTtblBankDetails bd ON wd.WorkerCode = bd.AllCode
--INNER JOIN GSTtblSubTypes st ON wd.SubTypeId = st.SubTypeId
--INNER JOIN GSTtblTypes tt ON st.TypeId = tt.TypeId
--INNER JOIN GSTtblVisitor v ON wd.WorkerCode = v.VisitorName
--WHERE tt.TypeId = 17
--  AND v.VisitorName IN ('WOR001', 'WOR004', 'WOR006')
--GROUP BY
--  st.SubTypeName,
--  wd.WorkerName,
--  wd.WorkerContactNo,
--  wd.JoiningDate,
--  wd.BaseSalary,
--  FORMAT(v.Date, 'yyyy-MM')
--ORDER BY
--  wd.WorkerName,
--  FORMAT(v.Date, 'yyyy-MM') DESC;

---todays finall 

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
