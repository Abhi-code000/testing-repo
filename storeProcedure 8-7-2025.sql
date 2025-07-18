USE [GSTHSMS]
GO
/****** Object:  StoredProcedure [dbo].[sp_SMS]    Script Date: 08-07-2025 15:51:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_SMS]
    --@flag NVARCHAR(50),
    @Email NVARCHAR(100)=NULL,
    @Password NVARCHAR(100)=NULL,
	--@Email NVARCHAR(100)=NULL,
 --   @Password NVARCHAR(100)=NULL,

    @BankName_Code NVARCHAR(20) = NULL,
    @TransactionCode NVARCHAR(20) = NULL,
	
@WorkerCode NVARCHAR(20) = NULL,
@AttendanceMonth NVARCHAR(7) = NULL,

    @EntityCode NVARCHAR(20) = NULL,
    @PaymentBy NVARCHAR(20) = NULL,
	@UPIId NVARCHAR(100) = NULL,

    @PaidTo NVARCHAR(20) = NULL,
    @Amount DECIMAL(18,2) = NULL,
    @PaymentMode int = NULL,
    @PaymentPurpose NVARCHAR(100) = NULL,
    @TransactionId_ChequeId NVARCHAR(100) = NULL,
    @PaidDate DATETIME = NULL,
	 @flag NVARCHAR(50) = NULL,
	     @TransactionType INT = NULL 

AS
BEGIN
    SET NOCOUNT ON;
 ----------------------For LOGIN By Accountant ---------------------------------------------------------------------------------------------------------------------------------------------
	IF @flag = 'LoginRK'
BEGIN
    SELECT 
    S.StaffId,
    S.Email,
    S.Password,
    S.RoleId,
    R.RoleName  
FROM 
    GSTtblStaff S
INNER JOIN 
    GSTtblRole R ON S.RoleId = R.RoleId
WHERE 
    S.Email = @Email AND S.Password = @Password AND S.RoleId = 2
END


-----------------------For Count Total Members in Society-----------------------------------------------------------------------------------------------
 IF @Flag = 'CountMembersNK'
    BEGIN
        SELECT COUNT(*) AS TotalMembers FROM GSTtblRegistrationMember;
    END

----------------------Fetch  all member information for show in list---------------------------------------
IF @Flag = 'FetchAllMemberDetailsNK'
BEGIN
   Select FlatCode,FullName,Email,PhoneNumber,PossessionDate,Gender,FamilyMemberCount,NoofVehicle,RegisterationDate from GSTtblRegistrationMember
END

--------------------------------------------------Abhi Start Here---------------------------------


--IF @flag = 'FetchWorkerInformationAD'
--BEGIN
--    SELECT
--        st.SubTypeName         AS [Role],
--        wd.WorkerName,
--        wd.WorkerCode,
--        bd.AccountNo,
--        wd.WorkerContactNo     AS [Contact],
--        CONVERT(date, wd.JoiningDate) AS [Date],
--        wd.BaseSalary,
--        bd.IFSCCode            AS [IFSC Code],
--        bd.UPIId               AS [Worker UPI],
--        FORMAT(v.Date, 'yyyy-MM') AS [AttendanceMonth],

--        COUNT(*) AS DaysPresent,

--        -- ✅ Round Per Day Payment
--        CAST(ROUND(wd.BaseSalary / 30.0, 2) AS decimal(10,2)) AS PerdayPayment,

--        -- ✅ Multiply Rounded Per Day * Days
--        CAST(
--            ROUND((ROUND(wd.BaseSalary / 30.0, 2) * COUNT(*)), 2) 
--            AS decimal(10,2)
--        ) AS AmountToBePaid,

--        -- ✅ Payment Status
--        CASE 
--            WHEN EXISTS (
--                SELECT 1 
--                FROM GSTtblTransaction t
--                WHERE t.PaidTo = wd.WorkerCode
--                  AND FORMAT(t.PaidDate, 'yyyy-MM') = FORMAT(v.Date, 'yyyy-MM')
--                  AND t.TransactionType = 27
--            )
--            THEN 'Paid'
--            ELSE 'Pay'
--        END AS [PaymentStatus],

--        -- ✅ Transaction Reference if Paid
--        ISNULL((
--            SELECT TOP 1 t.TransactionId_ChequeId
--            FROM GSTtblTransaction t
--            WHERE t.PaidTo = wd.WorkerCode
--              AND FORMAT(t.PaidDate, 'yyyy-MM') = FORMAT(v.Date, 'yyyy-MM')
--              AND t.TransactionType = 27
--            ORDER BY t.PaidDate DESC
--        ), '') AS [TransactionRef],

--        MAX(CONVERT(date, FORMAT(v.Date, 'yyyy-MM-01'))) AS MonthDate

--    FROM GSTtblWorkerDetails wd
--    INNER JOIN GSTtblBankDetails bd ON wd.WorkerCode = bd.AllCode
--    INNER JOIN GSTtblSubTypes st ON wd.SubTypeId = st.SubTypeId
--    INNER JOIN GSTtblTypes tt ON st.TypeId = tt.TypeId
--    INNER JOIN GSTtblVisitor v ON wd.WorkerCode = v.VisitorName

--    WHERE tt.TypeId = 17
--      AND v.VisitorName IN ('WOR001','WOR004','WOR006')

--    GROUP BY
--        st.SubTypeName,
--        wd.WorkerName,
--        wd.WorkerCode,
--        bd.AccountNo,
--        wd.WorkerContactNo,
--        wd.JoiningDate,
--        wd.BaseSalary,
--        bd.IFSCCode,
--        bd.UPIId,
--        FORMAT(v.Date, 'yyyy-MM')

--    ORDER BY
--        MonthDate DESC, wd.WorkerName
--END

IF @flag = 'FetchWorkerInformationAD'
BEGIN
    SELECT
        st.SubTypeName         AS [Role],
        wd.WorkerName,
        wd.WorkerCode,
        bd.AccountNo,
        wd.WorkerContactNo     AS [Contact],
        CONVERT(date, wd.JoiningDate) AS [Date],
        wd.BaseSalary,
        bd.IFSCCode            AS [IFSC Code],
        bd.UPIId               AS [Worker UPI],
        FORMAT(v.Date, 'yyyy-MM') AS [AttendanceMonth],

        COUNT(*) AS DaysPresent,

        -- ✅ Round Per Day Payment
        CAST(ROUND(wd.BaseSalary / 30.0, 2) AS decimal(10,2)) AS PerdayPayment,

        -- ✅ Multiply Rounded Per Day * Days
        CAST(
            ROUND((ROUND(wd.BaseSalary / 30.0, 2) * COUNT(*)), 2) 
            AS decimal(10,2)
        ) AS AmountToBePaid,

        -- ✅ Payment Status
        CASE 
            WHEN EXISTS (
                SELECT 1 
                FROM GSTtblTransaction t
                WHERE t.PaidTo = wd.WorkerCode
                  AND FORMAT(t.PaidDate, 'yyyy-MM') = FORMAT(v.Date, 'yyyy-MM')
                  AND t.TransactionType = 27
            )
            THEN 'Paid'
            ELSE 'Pay'
        END AS [PaymentStatus],

        -- ✅ Transaction Reference if Paid
        ISNULL((
            SELECT TOP 1 t.TransactionId_ChequeId
            FROM GSTtblTransaction t
            WHERE t.PaidTo = wd.WorkerCode
              AND FORMAT(t.PaidDate, 'yyyy-MM') = FORMAT(v.Date, 'yyyy-MM')
              AND t.TransactionType = 27
            ORDER BY t.PaidDate DESC
        ), '') AS [TransactionRef],

        MAX(CONVERT(date, FORMAT(v.Date, 'yyyy-MM-01'))) AS MonthDate

    FROM GSTtblWorkerDetails wd
    INNER JOIN GSTtblBankDetails bd ON wd.WorkerCode = bd.AllCode
    INNER JOIN GSTtblSubTypes st ON wd.SubTypeId = st.SubTypeId
    INNER JOIN GSTtblTypes tt ON st.TypeId = tt.TypeId
    INNER JOIN GSTtblVisitor v ON wd.WorkerCode = v.VisitorName

    WHERE tt.TypeId = 17
      AND v.VisitorName IN ('WOR001','WOR002','WOR003','WOR005','WOR006','WOR007','WOR008')

    GROUP BY
        st.SubTypeName,
        wd.WorkerName,
        wd.WorkerCode,
        bd.AccountNo,
        wd.WorkerContactNo,
        wd.JoiningDate,
        wd.BaseSalary,
        bd.IFSCCode,
        bd.UPIId,
        FORMAT(v.Date, 'yyyy-MM')

    ORDER BY
        MonthDate DESC, wd.WorkerName
END
-----------------------------------------------------Payment for the worker by the Accountant --------------------------------------------------





IF @flag = 'TransactionPaymentbyAccountant'
BEGIN
    DECLARE @WorkerBankId INT;
    DECLARE @SocietyBalance DECIMAL(18,2);

    -- Step 0: Get Worker BankId
    SELECT @WorkerBankId = BankId
    FROM GSTtblBankDetails
    WHERE AllCode = @PaidTo;

    IF @WorkerBankId IS NULL
    BEGIN
        RAISERROR('❌ Worker bank account not found for the given code.', 16, 1);
        RETURN;
    END

    -- Step 0.1: Check society balance
    SELECT @SocietyBalance = OpeningBalance
    FROM GSTtblBankDetails
    WHERE BankId = 86;

    IF @SocietyBalance IS NULL
    BEGIN
        RAISERROR('❌ Society account not found.', 16, 1);
        RETURN;
    END

    IF @SocietyBalance < @Amount
    BEGIN
        RAISERROR('❌ Insufficient balance in Society Account. Payment cannot proceed.', 16, 1);
        RETURN;
    END

    -- Step 1: Generate TransactionCode
    IF @PaymentMode IN (33, 35)
    BEGIN
        DECLARE @LastTRX INT;

        SELECT @LastTRX = ISNULL(
            MAX(CAST(SUBSTRING(TransactionCode, 4, LEN(TransactionCode)) AS INT)), 0)
        FROM GSTtblTransaction
        WHERE TransactionCode LIKE 'TRX%';

        SET @TransactionCode = 'TRX' + RIGHT('000' + CAST(@LastTRX + 1 AS VARCHAR), 3);
    END
    ELSE
    BEGIN
        DECLARE @LastCAS INT;

        SELECT @LastCAS = ISNULL(
            MAX(CAST(SUBSTRING(TransactionCode, 4, LEN(TransactionCode)) AS INT)), 0)
        FROM GSTtblTransaction
        WHERE TransactionCode LIKE 'CAS%';

        SET @TransactionCode = 'CAS' + RIGHT('000' + CAST(@LastCAS + 1 AS VARCHAR), 3);
    END

    -- Step 2: Begin Transaction block
    BEGIN TRANSACTION;

    -- Step 3: Deduct from society
    UPDATE GSTtblBankDetails
    SET OpeningBalance = OpeningBalance - @Amount
    WHERE BankId = 86;

    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR('❌ Error deducting from society.', 16, 1);
        RETURN;
    END

    -- Step 4: Credit to worker
    UPDATE GSTtblBankDetails
    SET OpeningBalance = OpeningBalance + @Amount
    WHERE BankId = @WorkerBankId;

    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR('❌ Error crediting to worker.', 16, 1);
        RETURN;
    END

    -- Step 5: Insert into GSTtblTransaction
    INSERT INTO GSTtblTransaction (
        BankName_Code, TransactionCode, EntityCode, PaymentBy,
        PaidTo, Amount, PaymentMode, PaymentPurpose,
        TransactionId_ChequeId, PaidDate, TransactionType
    )
    VALUES (
        @BankName_Code, @TransactionCode, @EntityCode, @PaymentBy,
        @PaidTo, @Amount, @PaymentMode, @PaymentPurpose,
        @TransactionId_ChequeId, @PaidDate, @TransactionType
    );

    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR('❌ Transaction insert failed.', 16, 1);
        RETURN;
    END

    COMMIT TRANSACTION;
    PRINT '✅ Payment + Fund transfer successful!';
END






--///////payment checking if its done then only view
-- SPAccountant procedure मधे हे flag case टाक
IF @flag = 'CheckPaymentExists'
BEGIN
    SELECT COUNT(*) AS PaymentCount
    FROM GSTtblTransaction
    WHERE PaidTo = @PaidTo
      AND FORMAT(PaidDate, 'yyyy-MM') = FORMAT(@PaidDate, 'yyyy-MM')
END
--IF @flag = 'FetchWorkerPaymentWithTxn'
--BEGIN
--  SELECT
--    st.SubTypeName          AS [Role],
--    wd.WorkerName,
--    wd.WorkerCode,
--    bd.AccountNo,
--    wd.WorkerContactNo      AS [Contact],
--    CONVERT(date, wd.JoiningDate) AS [Date],
--    wd.BaseSalary,
--    bd.IFSCCode             AS [IFSC Code],
--    bd.UPIId                AS [Worker UPI],
--    FORMAT(v.Date, 'yyyy-MM') AS [AttendanceMonth],
--    COUNT(*)                AS [DaysPresent],
--    CAST(wd.BaseSalary / 30.0 AS decimal(10,2))              AS [PerdayPayment],
--    CAST((wd.BaseSalary / 30.0) * COUNT(*) AS decimal(10,2)) AS [AmountToBePaid],
--    MAX(tx.TransactionId_ChequeId)                           AS [TransactionRef]
--  FROM GSTtblWorkerDetails wd
--  INNER JOIN GSTtblBankDetails bd ON wd.WorkerCode = bd.AllCode
--  INNER JOIN GSTtblSubTypes st    ON wd.SubTypeId = st.SubTypeId
--  INNER JOIN GSTtblTypes tt       ON st.TypeId = tt.TypeId
--  INNER JOIN GSTtblVisitor v      ON wd.WorkerCode = v.VisitorName
--  LEFT JOIN GSTtblTransaction tx  ON tx.PaidTo = wd.WorkerCode
--      AND FORMAT(tx.PaidDate, 'yyyy-MM') = FORMAT(v.Date, 'yyyy-MM')
--  WHERE tt.TypeId = 17
--    AND wd.WorkerCode = @WorkerCode
--    AND FORMAT(v.Date, 'yyyy-MM') = @AttendanceMonth
--  GROUP BY
--    st.SubTypeName,
--    wd.WorkerName,
--    wd.WorkerCode,
--    bd.AccountNo,
--    wd.WorkerContactNo,
--    wd.JoiningDate,
--    wd.BaseSalary,
--    bd.IFSCCode,
--    bd.UPIId,
--    FORMAT(v.Date, 'yyyy-MM')
--  ORDER BY
--    wd.WorkerName,
--    FORMAT(v.Date, 'yyyy-MM') DESC;
--END

IF @flag = 'FetchWorkerPaymentWithTxn'
BEGIN
  SELECT
    st.SubTypeName          AS [Role],
    wd.WorkerName,
    wd.WorkerCode,
    bd.AccountNo,
    wd.WorkerContactNo      AS [Contact],
    CONVERT(date, wd.JoiningDate) AS [Date],
    wd.BaseSalary,
    bd.IFSCCode             AS [IFSC Code],
    bd.UPIId                AS [Worker UPI],
    FORMAT(v.Date, 'yyyy-MM') AS [AttendanceMonth],
    COUNT(*)                AS [DaysPresent],
    CAST(wd.BaseSalary / 30.0 AS decimal(10,2))              AS [PerdayPayment],
    CAST((wd.BaseSalary / 30.0) * COUNT(*) AS decimal(10,2)) AS [AmountToBePaid],
    MAX(tx.TransactionId_ChequeId)                           AS [TransactionRef],
    pm.SubTypeName          AS [PaymentModeName] -- ✅ New Line
  FROM GSTtblWorkerDetails wd
  INNER JOIN GSTtblBankDetails bd ON wd.WorkerCode = bd.AllCode
  INNER JOIN GSTtblSubTypes st    ON wd.SubTypeId = st.SubTypeId
  INNER JOIN GSTtblTypes tt       ON st.TypeId = tt.TypeId
  INNER JOIN GSTtblVisitor v      ON wd.WorkerCode = v.VisitorName
  LEFT JOIN GSTtblTransaction tx  ON tx.PaidTo = wd.WorkerCode
      AND FORMAT(tx.PaidDate, 'yyyy-MM') = FORMAT(v.Date, 'yyyy-MM')
  LEFT JOIN GSTtblSubTypes pm     ON tx.PaymentMode = pm.SubTypeId -- ✅ Join for Payment Mode
  WHERE tt.TypeId = 17
    AND wd.WorkerCode = @WorkerCode
    AND FORMAT(v.Date, 'yyyy-MM') =  @AttendanceMonth
  GROUP BY
    st.SubTypeName,
    wd.WorkerName,
    wd.WorkerCode,
    bd.AccountNo,
    wd.WorkerContactNo,
    wd.JoiningDate,
    wd.BaseSalary,
    bd.IFSCCode,
    bd.UPIId,
    FORMAT(v.Date, 'yyyy-MM'),
    pm.SubTypeName -- ✅ Add in GROUP BY
  ORDER BY
    wd.WorkerName,
    FORMAT(v.Date, 'yyyy-MM') DESC;
END



--------------------checking society balance for validation -----------------------------------------------------------------------------------------

IF @flag = 'GetSocietyBalance'
BEGIN
    SELECT OpeningBalance FROM GSTtblBankDetails WHERE BankId = 86
END








END