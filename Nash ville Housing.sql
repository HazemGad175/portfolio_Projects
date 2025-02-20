select*
from Nashville_Housing 
------

-- Date --
select SaleDateConverted,CONVERT(date,saledate)
from Nashville_Housing 

update Nashville_Housing
set SaleDate = CONVERT(date,saledate)

Alter Table Nashville_Housing
Add SaleDateConverted Date;

update Nashville_Housing 
set SaleDateConverted = CONVERT(date,saledate)


--------------

------ property Address-----

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL( a.PropertyAddress,b.PropertyAddress)
from Nashville_Housing a
join Nashville_Housing b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null


update a
set PropertyAddress = ISNULL( a.PropertyAddress,b.PropertyAddress)
from Nashville_Housing a
join Nashville_Housing b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null


--------------------------------------------------------------
-----Breaking out Address into ( Address, city, state)----------


select PropertyAddress
from Nashville_Housing
-- where PropertyAddress is null


select 
SUBSTRING( PropertyAddress, 1, CHARINDEX( ',', PropertyAddress)-1) as Address ,
SUBSTRING( PropertyAddress, CHARINDEX( ',', PropertyAddress)+1 , len(PropertyAddress)) as City

from Nashville_Housing

Alter Table Nashville_Housing
Add PropertySplitAddress varchar(225);

update Nashville_Housing 
set PropertySplitAddress = SUBSTRING( PropertyAddress, 1, CHARINDEX( ',', PropertyAddress)-1) 

Alter Table Nashville_Housing
Add PropertySplitCity varchar(225);

update Nashville_Housing 
set PropertySplitCity = SUBSTRING( PropertyAddress, CHARINDEX( ',', PropertyAddress)+1 , len(PropertyAddress))



select
PARSENAME(replace(OwnerAddress, ',', '.'), 3),
PARSENAME(replace(OwnerAddress, ',', '.'), 2),
PARSENAME(replace(OwnerAddress, ',', '.'), 1)
from Nashville_Housing

Alter Table Nashville_Housing
Add OwnerSplitAddress varchar(225);

update Nashville_Housing 
set OwnerSplitAddress =  PARSENAME(replace(OwnerAddress, ',', '.'), 3)

Alter Table Nashville_Housing
Add OwnerSplitCity varchar(225);

update Nashville_Housing 
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.'), 2)

Alter Table Nashville_Housing
Add OwnerSplitState varchar(225);

update Nashville_Housing 
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',', '.'), 1)

-----------------------------------------
------change 0 & 1 to yes and No in slod as vacant----------

select distinct(SoldAsVacant_text), COUNT(SoldAsVacant_text)
from Nashville_Housing
group by SoldAsVacant_text

alter table Nashville_Housing
add SoldAsVacant_text varchar(50);

update Nashville_Housing
set SoldAsVacant_text =
case when SoldAsVacant = 0 then 'No'
     when SoldAsVacant = 1 then 'Yes'
	 ELSE 'Unknown'
end 


-------------------------------------
----Remove Duplicate-----

with RowNumcte as(
select *,
     ROW_NUMBER() over (
	 partition by ParcelID, 
	 PropertyAddress, 
	 SalePrice,
	 SaleDate,
	 LegalReference
order by UniqueID ) RowNum
from Nashville_Housing)
select *
from RowNumcte
-----where RowNum > 1
order by PropertyAddress
---------------------------------
-----Delete unused columns----
select *
from Nashville_Housing

Alter Table Nashville_Housing
DROP COLUMN PropertyAddress, TaxDistrict, OwnerAddress

Alter Table Nashville_Housing
DROP COLUMN SALEDATE


