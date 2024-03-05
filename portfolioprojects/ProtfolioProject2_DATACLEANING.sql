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
    COALESCE(a.PropertyAddress, b.PropertyAddress) AS PropertyAddress,
    b.uniqueid AS b_uniqueid,
    b.parcelid AS b_parcelid,
    b.propertyaddress AS b_propertyaddress
FROM 
    housingdata a 
JOIN 
    housingdata b ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID 
WHERE 
    a.PropertyAddress IS NULL;


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


