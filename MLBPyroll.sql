SELECT Club, FinalStanding, Season, PayrollPerMillion, PayrollRank
FROM MLBPayroll
WHERE FinalStanding = 'Won WS'
ORDER BY Season

SELECT AVG(PayrollRank) AS AVGPayrollRank
FROM MLBPayroll
WHERE FinalStanding = 'Won WS'


SELECT Club, FinalStanding, Season
From MLBPayroll
WHERE (FinalStanding = 'Won WS') AND (Club = 'NY Mets' OR Club = 'NY Yankees' OR Club = 'LA Dodgers' OR Club = 'LAA Angels')
ORDER By Season
