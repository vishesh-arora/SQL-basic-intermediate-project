-- First look at Account Information table
SELECT TOP 10 * FROM SQLTutorial.dbo.AccInfo

-- First look at Bank Transactions table
SELECT TOP 10 * FROM SQLTutorial.dbo.BankTransactions

-- AccountNo column in both tables has an additional ' at the end
--UPDATE SQLTutorial.dbo.AccInfo
--SET 
--	AccountNo = LEFT(AccountNo, LEN(AccountNo)-1)

--UPDATE SQLTutorial.dbo.BankTransactions
--SET
--	AccountNo = LEFT(AccountNo, LEN(AccountNo)-1)

-- Number of transactions for each account
SELECT AccountNo, COUNT(*) AS NumberOfTransactions, COUNT(WithdrawalAmt) AS NumberOfWithdrawals, COUNT(DepositAmt) AS NumberOfDeposits
FROM SQLTutorial.dbo.BankTransactions
GROUP BY AccountNo
ORDER BY NumberOfTransactions DESC, NumberOfDeposits DESC

-- Total amount withdrwan and deposited by each customer
SELECT AccountNo, SUM(WithdrawalAmt) AS TotalWithdrawnAmt, SUM(DepositAmt) AS TotalDepositAmt
FROM SQLTutorial.dbo.BankTransactions
GROUP BY AccountNo
ORDER BY TotalDepositAmt DESC

-- Total amount withdrwan and deposited by each customer month-wise
SELECT AccountNo, LEFT(ValueDate, 7) AS YearMonth, SUM(WithdrawalAmt) AS TotalWithdrawnAmt, SUM(DepositAmt) AS TotalDepositAmt
FROM SQLTutorial.dbo.BankTransactions 
GROUP BY AccountNo, LEFT(ValueDate, 7)
ORDER BY AccountNo, LEFT(ValueDate, 7)

-- First and last withdrawal date for each account
SELECT AccountNo, CAST(MIN(ValueDate) AS DATE) AS FirstWithdrawalDate, CAST(MAX(ValueDate) AS DATE) AS LastWithdrawalDate
FROM SQLTutorial.dbo.BankTransactions
WHERE WithdrawalAmt IS NOT NULL
GROUP BY AccountNo
ORDER BY LastWithdrawalDate DESC, AccountNo

-- Looking at which customers have more deposits than withdrawal
SELECT AccountNo, SUM(WithdrawalAmt) AS TotalWithdrawnAmt, SUM(DepositAmt) AS TotalDepositAmt,
CASE
	WHEN SUM(WithdrawalAmt) - SUM(DepositAmt) > 0 THEN 'Negative Account'
	WHEN SUM(WithdrawalAmt) - SUM(DepositAmt) < 0 THEN 'Positive Account'
	ELSE 'Zero account'
END AS AccountStatus
FROM SQLTutorial.dbo.BankTransactions
GROUP BY AccountNo
ORDER BY AccountStatus DESC

-- Total amount deposited and withdrawn by Delhi and Mumbai customers
SELECT T1.AccountNo, MAX(T1.City) AS City, SUM(T2.DepositAmt) AS TotalDepositAmt, SUM(T2.WithdrawalAmt) AS TotalWithdrawnAmt
FROM SQLTutorial.dbo.AccInfo AS T1
INNER JOIN SQLTutorial.dbo.BankTransactions AS T2
ON T1.AccountNo = T2.AccountNo
WHERE T1.City IN ('Delhi', 'Mumbai')
GROUP BY T1.AccountNo
ORDER BY City, T1.AccountNo

-- END OF CODE