USE [GSTHSMS]
GO
/****** Object:  StoredProcedure [dbo].[SPAccountant]    Script Date: 02-07-2025 11:41:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SPAccountant]
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

    @TransactionType INT = NULL AS
BEGIN
    SET NOCOUNT ON;

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
  BD.IFSCCode            AS [IFSC Code],
  BD.UPIId               AS [Worker UPI],
  FORMAT(v.Date, 'yyyy-MM')    AS [AttendanceMonth],
  COUNT(*)               AS DaysPresent,
  CAST(wd.BaseSalary / 30.0 AS decimal(10,2))                         AS PerdayPayment,
  CAST((wd.BaseSalary / 30.0) * COUNT(*) AS decimal(10,2))            AS AmountToBePaid
FROM GSTtblWorkerDetails wd
INNER JOIN GSTtblBankDetails bd     ON wd.WorkerCode = bd.AllCode
INNER JOIN GSTtblSubTypes st        ON wd.SubTypeId   = st.SubTypeId
INNER JOIN GSTtblTypes tt           ON st.TypeId      = tt.TypeId
INNER JOIN GSTtblVisitor v          ON wd.WorkerCode = v.VisitorName
WHERE tt.TypeId = 17
  AND v.VisitorName IN ('WOR001','WOR004','WOR006')
GROUP BY
  st.SubTypeName,
    bd.AccountNo,

  wd.WorkerName,
     wd.WorkerCode,
  wd.WorkerContactNo,
  wd.JoiningDate,
  wd.BaseSalary,
  BD.IFSCCode,
  BD.UPIId,
  FORMAT(v.Date, 'yyyy-MM')
ORDER BY
  wd.WorkerName,
  FORMAT(v.Date, 'yyyy-MM') DESC;

    END


	--///////
IF @flag = 'TransactionPaymentbyAccountant'
BEGIN
    -- Step 0: Get Worker BankId using PaidTo (WorkerCode)
    DECLARE @WorkerBankId INT;

    SELECT @WorkerBankId = BankId
    FROM GSTtblBankDetails
    WHERE AllCode = @PaidTo;

    IF @WorkerBankId IS NULL
    BEGIN
        RAISERROR('❌ Worker bank account not found for the given code.', 16, 1);
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






END
