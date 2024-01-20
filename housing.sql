-- Add a new column for surname
Select *
From [Portfolio Project]..nationalhousing
---standardize date 
SELECT saledate, CONVERT(DATE, saledate) AS StandardSaleDate
FROM [Portfolio Project]..nationalhousing;

---populate property addrss
SELECT PropertyAddress
FROM [Portfolio Project]..nationalhousing;

SELECT PropertyAddress
FROM [Portfolio Project]..nationalhousing
where PropertyAddress is null

SELECT *
FROM [Portfolio Project]..nationalhousing
where PropertyAddress is null

SELECT *
FROM [Portfolio Project]..nationalhousing
---where PropertyAddress is null
order by ParcelID

SELECT a.PropertyAddress AS AddressA, a.ParcelID AS ParcelIDA, b.PropertyAddress AS AddressB, b.ParcelID AS ParcelIDB
FROM [Portfolio Project]..nationalhousing a
JOIN [Portfolio Project]..nationalhousing b
ON a.ParcelID = b.ParcelID
      AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL;

SELECT a.PropertyAddress AS AddressA, a.ParcelID AS ParcelIDA, b.PropertyAddress AS AddressB, b.ParcelID AS ParcelIDB, ISNULL (a.PropertyAddress,b.PropertyAddress)
FROM [Portfolio Project]..nationalhousing a
JOIN [Portfolio Project]..nationalhousing b
ON a.ParcelID = b.ParcelID
      AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL;

UPDATE a
SET PropertyAddress =ISNULL (a.PropertyAddress,b.PropertyAddress)
FROM [Portfolio Project]..nationalhousing a
JOIN [Portfolio Project]..nationalhousing b
ON a.ParcelID = b.ParcelID
      AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL;

---Breaking address out into individual columns

SELECT PropertyAddress
FROM [Portfolio Project]..nationalhousing
---where PropertyAddress is null
---order by ParcelID


SELECT 
    PropertyAddress,
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) AS Address
FROM 
    [Portfolio Project]..nationalhousing;

	SELECT 
    PropertyAddress,
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address
FROM 
    [Portfolio Project]..nationalhousing;

SELECT 
    PropertyAddress,
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
    -- Adjusted the starting position in the second SUBSTRING function
    SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City
FROM 
    [Portfolio Project]..nationalhousing;

	SELECT *
FROM [Portfolio Project]..nationalhousing

-- Add new columns to the existing table
ALTER TABLE [Portfolio Project]..nationalhousing
ADD Address NVARCHAR(MAX),
    City NVARCHAR(MAX);

-- Update the new columns based on the existing PropertyAddress column
UPDATE [Portfolio Project]..nationalhousing
SET 
    Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1),
    City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress));
-- Add new columns to the existing table
ALTER TABLE [Portfolio Project]..nationalhousing
ADD GivenName NVARCHAR(MAX),
    SurName NVARCHAR(MAX);

-- Update the new columns based on the existing OwnerName column

	UPDATE [Portfolio Project]..nationalhousing
SET 
    SurName = CASE 
                 WHEN CHARINDEX(',', OwnerName) > 0 
                 THEN SUBSTRING(OwnerName, 1, CHARINDEX(',', OwnerName) - 1)
                 ELSE OwnerName
              END,
    GivenName = CASE 
                   WHEN CHARINDEX(',', OwnerName) > 0 
                   THEN SUBSTRING(OwnerName, CHARINDEX(',', OwnerName) + 1, LEN(OwnerName))
                   ELSE NULL -- You can use NULL or an empty string based on your requirement
                END;

-- Display the updated table
	SELECT *
FROM [Portfolio Project]..nationalhousing

---spliting the ownser address
SELECT OwnerAddress
FROM [Portfolio Project]..nationalhousing

SELECT PARSENAME (OwnerAddress,1)
FROM [Portfolio Project]..nationalhousing

SELECT PARSENAME (replace (OwnerAddress,1, ',','.'),1)
FROM [Portfolio Project]..nationalhousing

SELECT 
    SUBSTRING(REPLACE(OwnerAddress, ',', '.'), 1, CHARINDEX('.', REPLACE(OwnerAddress, ',', '.')) - 1) AS OwnerAddress1,
    SUBSTRING(REPLACE(OwnerAddress, ',', '.'), CHARINDEX('.', REPLACE(OwnerAddress, ',', '.')) + 1, LEN(OwnerAddress)) AS OwnerCity,
    SUBSTRING(REPLACE(OwnerAddress, ',', '.'), CHARINDEX('.', REPLACE(OwnerAddress, ',', '.')) + 2, LEN(OwnerAddress)) AS OwnCitytag
FROM [Portfolio Project]..nationalhousing;

-- Add new columns to the existing table
ALTER TABLE [Portfolio Project]..nationalhousing
ADD OwnerAddress1 NVARCHAR(MAX),
    OwnerCity NVARCHAR(MAX),
    OwnCitytag NVARCHAR(MAX);

-- Update the new columns based on the existing OwnerAddress column
UPDATE [Portfolio Project]..nationalhousing
SET 
    OwnerAddress1 = SUBSTRING(REPLACE(OwnerAddress, ',', '.'), 1, CHARINDEX('.', REPLACE(OwnerAddress, ',', '.')) - 1),
    OwnerCity = SUBSTRING(REPLACE(OwnerAddress, ',', '.'), CHARINDEX('.', REPLACE(OwnerAddress, ',', '.')) + 1, LEN(OwnerAddress)),
    OwnCitytag = SUBSTRING(REPLACE(OwnerAddress, ',', '.'), CHARINDEX('.', REPLACE(OwnerAddress, ',', '.')) + 2, LEN(OwnerAddress));

-- Display the updated table
SELECT* 
 FROM 
    [Portfolio Project]..nationalhousing;

	----change Y and N to yes and No
	Select distinct (SoldAsVacant), count (SoldAsVacant) 
	from [Portfolio Project]..nationalhousing
	group by SoldAsVacant
	order by 2

	UPDATE [Portfolio Project]..nationalhousing -- Replace YourTableName with the actual name of your table
SET SoldAsVacant = CASE 
                      WHEN SoldAsVacant = 'Y' THEN 'Yes'
                      WHEN SoldAsVacant = 'N' THEN 'No'
                      ELSE SoldAsVacant
                   END;
	Select distinct (SoldAsVacant), count (SoldAsVacant) 
	from [Portfolio Project]..nationalhousing
	group by SoldAsVacant
	order by 2
---Remove Duplicates

SELECT *, 
	  ROW_NUMBER() OVER (
           PARTITION BY ParcelID,
                        PropertyAddress,
                        SalePrice,
                        SaleDate,
                        LegalReference
           ORDER BY UniqueID
       ) AS RowNumber
FROM [Portfolio Project]..nationalhousing
ORDER BY ParcelID


WITH ROWNUMCTE AS (
    SELECT *, 
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID,
                         PropertyAddress,
                         SalePrice,
                         SaleDate,
                         LegalReference
            ORDER BY UniqueID
        ) AS RowNumber
    FROM [Portfolio Project]..nationalhousing
    -- ORDER BY ParcelID -- You can uncomment this line if you want to order the final result
)
SELECT *
FROM ROWNUMCTE
WHERE RowNumber > 1
ORDER BY PropertyAddress;

WITH ROWNUMCTE AS (
    SELECT *, 
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID,
                         PropertyAddress,
                         SalePrice,
                         SaleDate,
                         LegalReference
            ORDER BY UniqueID
        ) AS RowNumber
    FROM [Portfolio Project]..nationalhousing
    -- ORDER BY ParcelID -- You can uncomment this line if you want to order the final result
)
DELETE
FROM ROWNUMCTE
WHERE RowNumber > 1
--ORDER BY PropertyAddress;

SELECT *
FROM [Portfolio Project]..nationalhousing

---DELETE UNUSED COLUMNS
SELECT *
FROM [Portfolio Project]..nationalhousing

-- Drop the specified columns
ALTER TABLE [Portfolio Project]..nationalhousing
DROP COLUMN PropertyAddress, OwnerAddress,TaxDistrict;
ALTER TABLE [Portfolio Project]..nationalhousing
DROP COLUMN LegalReference,Address
ALTER TABLE [Portfolio Project]..nationalhousing
DROP COLUMN First, LastName