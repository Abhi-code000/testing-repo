DECLARE @Amount MONEY = 500;

BEGIN TRANSACTION;

-- Step 1: Deduct money from society
UPDATE GSTtblBankDetails
SET OpeningBalance = OpeningBalance - @Amount
WHERE BankId = 88;

-- Check if error occurred
IF @@ERROR <> 0
BEGIN
    ROLLBACK TRANSACTION;	
    PRINT '❌ Error while deducting from Society. Transaction rolled back.';
    RETURN;
END

-- Step 2: Credit money to worker
UPDATE GSTtblBankDetails
SET OpeningBalance = OpeningBalance + @Amount
WHERE BankId = 89;

-- Check if error occurred
IF @@ERROR <> 0
BEGIN
    ROLLBACK TRANSACTION;
    PRINT '❌ Error while crediting to Worker. Transaction rolled back.';
    RETURN;
END

-- If both successful
COMMIT TRANSACTION;
PRINT '✅ Transaction completed successfully!';


select * from  GSTtblBankDetails