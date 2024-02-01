

select *
from PortifolioCovidProject..NashvilleHousing

-- Fixing the DATE Format

select SaleDateConverted ,CONVERT(Date,SaleDate)
from PortifolioCovidProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;


Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)



-- Populate Property Address data
-- fixing the property adress is null situation

select *
from PortifolioCovidProject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress , ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortifolioCovidProject..NashvilleHousing a
JOIN PortifolioCovidProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null


update a
set propertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortifolioCovidProject..NashvilleHousing a
JOIN PortifolioCovidProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null




-------------------
--breaking out the adress into individual parts 


select PropertyAddress
from PortifolioCovidProject..NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING(PropertyAddress, 1 , charindex(',', PropertyAddress)-1) as adress
, SUBSTRING(PropertyAddress, charindex(',', PropertyAddress) +1, LEN(PropertyAddress)) as adress
from PortifolioCovidProject..NashvilleHousing



ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255);


Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1 , charindex(',', PropertyAddress)-1)


ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255);


Update NashvilleHousing
SET PropertySplitCity =  SUBSTRING(PropertyAddress, charindex(',', PropertyAddress) +1, LEN(PropertyAddress))



select*
from PortifolioCovidProject..NashvilleHousing






-- instead of substring for owneraddress

select OwnerAddress
from PortifolioCovidProject..NashvilleHousing

select
PARSENAME(Replace(OwnerAddress,',','.' ), 3)
,PARSENAME(Replace(OwnerAddress,',','.' ), 2)
,PARSENAME(Replace(OwnerAddress,',','.' ), 1)
from PortifolioCovidProject..NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.' ), 3)



ALTER TABLE NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.' ), 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState =  PARSENAME(Replace(OwnerAddress,',','.' ), 1)



select*
from PortifolioCovidProject..NashvilleHousing




-- sold as vacant field changing the Y and N to Yes and No

select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from PortifolioCovidProject..NashvilleHousing
group by SoldAsVacant
order by 2



select SoldAsVacant,
CASE when SoldAsVacant = 'Y' then 'Yes' 
	 when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 End
from PortifolioCovidProject..NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes' 
	 when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 End
from PortifolioCovidProject..NashvilleHousing



------------

-- removing duplicates

with RowNumCTE AS(
select *,
row_number() over(
partition by parcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			order by 
			UniqueID
			) row_num
from PortifolioCovidProject..NashvilleHousing
--order by parcelID
) 
Delete
from RowNumCTE
Where row_num >1 
--order by PropertyAddress








--deleting unused columns

select * 
from PortifolioCovidProject..NashvilleHousing


alter table PortifolioCovidProject..NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress



alter table PortifolioCovidProject..NashvilleHousing
drop column SaleDate