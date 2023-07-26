/*

Cleaning Data in SQL Queries

*/

Select * 
From PortfolioData..NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SalesDateConverted, CONVERT(Date, SaleDate)
From PortfolioData..NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
ADD SalesDateConverted Date

UPDATE NashvilleHousing
SET SalesDateConverted = CONVERT(Date, SaleDate)



ALTER TABLE PortfolioData..NashvilleHousing
ADD PropertySplitAddress nvarchar(255)
UPDATE PortfolioData..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE PortfolioData..NashvilleHousing
ADD PropertySplitCity nvarchar(255)
UPDATE PortfolioData..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress))

-- If it doesn't Update properly




 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From PortfolioData..NashvilleHousing

ORDER BY ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioData..NashvilleHousing a
JOIN PortfolioData..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)

From PortfolioData..NashvilleHousing a
JOIN PortfolioData..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL



--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioData..NashvilleHousing 

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress)) as Address
From PortfolioData..NashvilleHousing

Select *
From PortfolioData..NashvilleHousing 



Select 
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)
From PortfolioData..NashvilleHousing


ALTER TABLE PortfolioData..NashvilleHousing
ADD OwnerSplitAddress nvarchar(255)
UPDATE PortfolioData..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3)

ALTER TABLE PortfolioData..NashvilleHousing
ADD OwnerSplitCity nvarchar(255)
UPDATE PortfolioData..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2)

ALTER TABLE PortfolioData..NashvilleHousing
ADD OwnerSplitState nvarchar(255)
UPDATE PortfolioData..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)


Select *
From PortfolioData..NashvilleHousing


--ORDER BY ParcelID

--Where PropertyAddress is null
--order by ParcelID







--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field



Select SoldAsVacant,
	CASE WHEN  SoldAsVacant = 'Y' THEN 'YES'
		WHEN SoldAsVacant = 'N' THEN 'NO'
		ELSE SoldAsVacant
	END

From PortfolioData..NashvilleHousing


Update PortfolioData..NashvilleHousing
SET SoldAsVacant = CASE WHEN  SoldAsVacant = 'Y' THEN 'YES'
					WHEN SoldAsVacant = 'N' THEN 'NO'
					ELSE SoldAsVacant
					END



-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
				  UniqueID
				) row_num
From PortfolioData..NashvilleHousing
--ORDER by ParcelID
)
SELECT *
From RowNumCTE
WHERE row_NUM > 1
Order by PropertyAddress

SELECT *
From PortfolioData..NashvilleHousing





--order by ParcelID
)




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT *
FROM PortfolioData..NashvilleHousing


ALTER TABLE PortfolioData..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioData..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress












-











