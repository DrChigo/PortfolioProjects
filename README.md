---selecting table CPAI
SELECT * FROM Projectwin..CPAI
---selecting table Demo
SELECT * FROM Projectwin..Demo
---selecting table EFC
SELECT * FROM Projectwin..EFC
---selecting table PF
SELECT * FROM Projectwin..PF
---selecting table REN
SELECT * FROM Projectwin..REN
---selecting table TMP
SELECT * FROM Projectwin..TMP

---full outer join of the tables
SELECT * FROM Projectwin..CPAI As CPAI
FULL OUTER JOIN Projectwin..Demo AS Demo ON CPAI.[Country ] = Demo.[Country ]
FULL OUTER JOIN Projectwin..EFC AS EFC ON CPAI.[Country ]= EFC.[Country ]
FULL OUTER JOIN Projectwin..PF AS PF ON CPAI.[Country ] = PF.[Country ]
FULL OUTER JOIN Projectwin..REN AS REN ON CPAI.[Country ] = REN.[Country ]
FULL OUTER JOIN Projectwin..TMP AS TMP ON CPAI.[Country ] = TMP.[Country ]

---Left outer join of the tables 
SELECT *
FROM Projectwin..CPAI AS CPAI
LEFT OUTER JOIN Projectwin..Demo AS Demo ON CPAI.Country = Demo.Country AND CPAI.Year = Demo.Year
LEFT OUTER JOIN Projectwin..EFC AS EFC ON CPAI.Country = EFC.Country AND CPAI.Year = EFC.Year
LEFT OUTER JOIN Projectwin..PF AS PF ON CPAI.Country = PF.Country AND CPAI.Year = PF.Year
LEFT OUTER JOIN Projectwin..REN AS REN ON CPAI.Country = REN.Country AND CPAI.Year = REN.Year
LEFT OUTER JOIN Projectwin..TMP AS TMP ON CPAI.Country = TMP.Country AND CPAI.Year = TMP.Year;

----Inner join of the tables 
SELECT *
FROM Projectwin..CPAI AS CPAI
INNER JOIN Projectwin..Demo AS Demo ON CPAI.Country = Demo.Country AND CPAI.Year = Demo.Year
INNER JOIN Projectwin..EFC AS EFC ON CPAI.Country = EFC.Country AND CPAI.Year = EFC.Year
INNER JOIN Projectwin..PF AS PF ON CPAI.Country = PF.Country AND CPAI.Year = PF.Year
INNER JOIN Projectwin..REN AS REN ON CPAI.Country = REN.Country AND CPAI.Year = REN.Year
INNER JOIN Projectwin..TMP AS TMP ON CPAI.Country = TMP.Country AND CPAI.Year = TMP.Year;

SELECT 
    COALESCE(CPAI.Country, Demo.Country, EFC.Country, PF.Country, REN.Country, TMP.Country) AS Country,
    COALESCE(CPAI.Year, Demo.Year, EFC.Year, PF.Year, REN.Year, TMP.Year) AS Year,
    CPAI.CPIA AS CPIA,
    Demo.Dem AS Dem,
    EFC.EDB AS EDB,
EFC.FDI AS FDI,
    PF.Pop AS Pop,
PF.FSK AS FSK,
PF.FSP AS FSP,
PF.FSF AS FSF,
    REN.Renewables AS Renewables,
    TMP.Temperature AS TMP_Columns
FROM 
    Projectwin..CPAI
INNER JOIN 
    Projectwin..Demo ON CPAI.Country = Demo.Country AND CPAI.Year = Demo.Year
INNER JOIN 
    Projectwin..EFC ON CPAI.Country = EFC.Country AND CPAI.Year = EFC.Year
INNER JOIN 
    Projectwin..PF ON CPAI.Country = PF.Country AND CPAI.Year = PF.Year
INNER JOIN 
    Projectwin..REN ON CPAI.Country = REN.Country AND CPAI.Year = REN.Year
INNER JOIN 
    Projectwin..TMP ON CPAI.Country = TMP.Country AND CPAI.Year = TMP.Year


---natural join of the tables

SELECT *
FROM Projectwin..CPAI
JOIN Projectwin..Demo ON CPAI.Country = Demo.Country AND CPAI.Year = Demo.Year
JOIN Projectwin..EFC ON CPAI.Country = EFC.Country AND CPAI.Year = EFC.Year
JOIN Projectwin..PF ON CPAI.Country = PF.Country AND CPAI.Year = PF.Year
JOIN Projectwin..REN ON CPAI.Country = REN.Country AND CPAI.Year = REN.Year
JOIN Projectwin..TMP ON CPAI.Country = TMP.Country AND CPAI.Year = TMP.Year;
