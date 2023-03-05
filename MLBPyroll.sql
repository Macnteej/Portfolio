--Every World Series winner with payroll
SELECT Club, FinalStanding, Season, PayrollPerMillion, PayrollRank
FROM MLBPayroll
WHERE FinalStanding = 'Won WS'

--Average payroll of WS winner
SELECT AVG(PayrollRank) AS AVGPayrollRank
FROM MLBPayroll
WHERE FinalStanding = 'Won WS'

--Years a NYC or LA team won the World Series
SELECT Club, FinalStanding, Season
From MLBPayroll
WHERE (FinalStanding = 'Won WS') AND (Club = 'NY Mets' OR Club = 'NY Yankees' OR Club = 'LA Dodgers' OR Club = 'LAA Angels')
ORDER By Season


CREATE VIEW NYLAWinners AS
SELECT Club, FinalStanding, Season
From MLBPayroll
WHERE (FinalStanding = 'Won WS') AND (Club = 'NY Mets' OR Club = 'NY Yankees' OR Club = 'LA Dodgers' OR Club = 'LAA Angels')

