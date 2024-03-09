--CREATE TABLE

DROP TABLE housingdata
CREATE TABLE housingdata(
	UniqueID numeric,	
	ParcelID varchar(50),	
	LandUse	varchar(50),
	PropertyAddress	varchar(150),
	SaleDate date,	
	SalePrice varchar(50),
	LegalReference varchar(150),	
	SoldAsVacant varchar(150),
	OwnerName	varchar(150),
	OwnerAddress varchar(150),	
	Acreage	numeric,
	TaxDistrict	varchar(100),
	LandValue	numeric,
	BuildingValue numeric,	
	TotalValue	numeric,
	YearBuilt numeric,	
	Bedrooms numeric,	
	FullBath numeric,	
	HalfBath numeric
)

--COPY DATA FROM CSV TO TABLE

COPY housingdata FROM 'C:\Repos\DataAnalysis\portfolioprojects\HousingData.csv' DELIMITER ',' CSV HEADER;

----------------------------------CLEANING THE DATA-----------------------------------------------
------------------------------------------------------------------------------------------------

SELECT *FROM housingdata


-----------------------CAST SALEDATE DATYPE TO DATE AND UPDATE IT IN TABLE-----------------------------

SELECT saledate FROM housingdata

SELECT  saledate::date FROM housingdata
--SELECT  CAST(saledate AS date) FROM housingdata

UPDATE housingdata
SET SaleDate = saledate::date

 
 -------------------------------POPULATE PROPERTY ADDRESS DATA--------------------------------

SELECT ParcelID,propertyaddress FROM housingdata WHERE propertyaddress IS NULL
SELECT  *FROM housingdata WHERE propertyaddress IS NULL
SELECT  *FROM housingdata WHERE parcelid='025 07 0 031.00'

--populate address if address field is null and address is there for same personal id


SELECT 
    a.uniqueid,
    a.parcelid,
    a.propertyaddress,
    IF NULL(a.PropertyAddress, b.PropertyAddress) AS PropertyAddress,
    b.uniqueid AS b_uniqueid,
    b.parcelid AS b_parcelid,
    b.propertyaddress AS b_propertyaddress
FROM 
    housingdata a 
JOIN 
    housingdata b ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID 
WHERE 
    a.PropertyAddress IS NULL;

--error
UPDATE a
SET PropertyAddress = COALESCE(a.PropertyAddress, b.PropertyAddress)
FROM 
    housingdata a 
JOIN 
    housingdata b ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID 
WHERE 
    a.PropertyAddress IS NULL;
	
	
UPDATE housingdata AS a
SET PropertyAddress = b.PropertyAddress
FROM housingdata AS b
WHERE a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
AND a.PropertyAddress IS NULL
AND b.PropertyAddress IS NOT NULL;	

-------------------------ADDRESS SPLITTING-----------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)

--property address

SELECT  propertyaddress FROM housingdata 

SELECT
  SUBSTRING(PropertyAddress, 1, POSITION(',' IN PropertyAddress) - 1) AS Address1,
  SUBSTRING(PropertyAddress FROM POSITION(',' IN PropertyAddress) + 1) AS Address2
FROM housingdata;



ALTER TABLE housingdata
ADD COLUMN houseaddress varchar(255);

UPDATE housingdata
SET houseaddress = SUBSTRING(PropertyAddress, 1, POSITION(',' IN PropertyAddress) - 1)


ALTER TABLE housingdata
ADD COLUMN City varchar(255);

UPDATE housingdata
SET City = SUBSTRING(PropertyAddress FROM POSITION(',' IN PropertyAddress) + 1)

SELECT  *FROM housingdata


--owners address

SELECT  owneraddress FROM housingdata 

SELECT
  SPLIT_PART(OwnerAddress, ',', 1) AS Part1,
  SPLIT_PART(OwnerAddress, ',', 2) AS Part2,
  SPLIT_PART(OwnerAddress, ',', 3) AS Part3
FROM housingdata;


ALTER TABLE housingdata
ADD COLUMN Ownerhouseaddress varchar(255);

UPDATE housingdata
SET Ownerhouseaddress = SPLIT_PART(OwnerAddress, ',', 1)


ALTER TABLE housingdata
ADD COLUMN Ownercity varchar(255);


UPDATE housingdata
SET Ownercity = SPLIT_PART(OwnerAddress, ',', 2)

ALTER TABLE housingdata
ADD COLUMN Ownerstate varchar(255);


UPDATE housingdata
SET Ownerstate = SPLIT_PART(OwnerAddress, ',', 3)

SELECT  *FROM housingdata


------------------- Change Y anFROM housingdatata N to Yes and No in "Sold as Vacant" field-------------------


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
 FROM housingdata
GROUP BY SoldAsVacant


SELECT SoldAsVacant, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	                      When SoldAsVacant = 'N' THEN 'No'
	           ELSE SoldAsVacant
	   END
FROM housingdata

UPDATE housingdata
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


------------------------------------ REMOVE DUPLICATES---------------------

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From housingdata
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


--row_num>1 are duplicate rows
--delete those rows
--in postegresql cannot directly delete from CTE
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From housingdata
)
DELETE 
From RowNumCTE
Where row_num > 1

--solution

WITH RowNumCTE AS (
    SELECT
        UniqueID,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
            ORDER BY UniqueID
        ) AS row_num
    FROM housingdata
)
DELETE FROM housingdata
WHERE UniqueID IN (
    SELECT UniqueID
    FROM RowNumCTE
    WHERE row_num > 1
);


---------------------------------- DELETE UNUSED COLUMNS-------------------------------------------------


ALTER TABLE housingdata
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

ALTER TABLE housingdata
DROP COLUMN OwnerAddress,
DROP COLUMN TaxDistrict,
DROP COLUMN PropertyAddress,
DROP COLUMN SaleDate