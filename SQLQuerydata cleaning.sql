/*
Cleaning Data in SQL Queries
*/

Select *
From[Portfolio Project] .dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format
Select [SaleDate]
From[Portfolio Project] .dbo.NashvilleHousing


Select [SaleDate] ,CONVERT(Date,[SaleDate])
From[Portfolio Project] .dbo.NashvilleHousing

Update [Portfolio Project] .dbo.NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)
-- If it doesn't Update properly

ALTER TABLE [Portfolio Project] .dbo.NashvilleHousing
Add SaleDateConverted Date;

Update [Portfolio Project] .dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From [Portfolio Project] .dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID


Select  a.[UniqueID ] , b.[UniqueID ], a.ParcelID  , b.ParcelID, a.PropertyAddress, b.PropertyAddress ,ISNULL(a.PropertyAddress, b.PropertyAddress)  
From  [Portfolio Project] .dbo.NashvilleHousing a
JOIN  [Portfolio Project] .dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From  [Portfolio Project] .dbo.NashvilleHousing a
JOIN  [Portfolio Project] .dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From [Portfolio Project] .dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [Portfolio Project] .dbo.NashvilleHousing


ALTER TABLE [Portfolio Project] .dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update [Portfolio Project] .dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [Portfolio Project] .dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update [Portfolio Project] .dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From [Portfolio Project] .dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out  OwnerAddress into Individual Columns (Address, City, State)

Select OwnerAddress
From [Portfolio Project] .dbo.NashvilleHousing

Select OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
 From [Portfolio Project] .dbo.NashvilleHousing

 ALTER TABLE [Portfolio Project] .dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update [Portfolio Project] .dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [Portfolio Project] .dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update [Portfolio Project] .dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [Portfolio Project] .dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update [Portfolio Project] .dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [Portfolio Project] .dbo.NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Portfolio Project] .dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

Update [Portfolio Project] .dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

	   

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates


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

From [Portfolio Project] .dbo.NashvilleHousing
--order by ParcelID
)
--DELETE
select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress
---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From[Portfolio Project] .dbo.NashvilleHousing


ALTER TABLE [Portfolio Project] .dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress,SaleDate





