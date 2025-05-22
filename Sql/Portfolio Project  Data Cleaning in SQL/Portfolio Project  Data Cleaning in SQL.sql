select *
from [Nashville Housing]
where OwnAddress is not null
order by [UniqueID ]

----ParcelID
select ParcelID,replace(ParcelID,' ','-')
from [Nashville Housing]

update [Nashville Housing]
set ParcelID=replace(ParcelID,' ','-')

-----SaleDate
select SaleDate,convert(date,SaleDate)
from [Nashville Housing]

alter table [Nashville Housing]
add SaleDate2 date ;

update [Nashville Housing]
set SaleDate2 = convert(date,SaleDate)

alter table [Nashville Housing]
drop column SaleDate ;

use PortfolioProject
go
exec sp_rename
'Nashville Housing.SaleDate2',
'SaleDate',
'column'
go

-----SoldAsVacant
select SoldAsVacant,
case
    when SoldAsVacant='n' then 'No'
	when SoldAsVacant='y' then 'Yes'
	else SoldAsVacant
end as SoldAsVacant
from [Nashville Housing]
group by SoldAsVacant

update [Nashville Housing]
set SoldAsVacant =
case
    when SoldAsVacant='n' then 'No'
	when SoldAsVacant='y' then 'Yes'
	else SoldAsVacant
end

-----OwnerName
select OwnerName,replace(OwnerName,',',' '),replace(OwnerName,'.',' ')
from [Nashville Housing]
order by [UniqueID ]

update [Nashville Housing]
set OwnerName=replace(OwnerName,',',' ')
update [Nashville Housing]
set OwnerName=replace(OwnerName,'.',' ')

---Populate Property Address data
select a.PropertyAddress,a.ParcelID,b.PropertyAddress,b.ParcelID
,ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Nashville Housing] a
join [Nashville Housing] b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Nashville Housing] a
join [Nashville Housing] b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


----Breaking out Address into Individual Columns (Address, City, State)
select*
from [Nashville Housing]

select PropertyAddress,SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
from [Nashville Housing]

alter table [Nashville Housing]
add PropertysplitAddress nvarchar(255);
update [Nashville Housing]
set PropertysplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table [Nashville Housing]
add Propertycity nvarchar(255);
update [Nashville Housing]
set Propertycity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

alter table [Nashville Housing]
drop column PropertyAddress ;

use PortfolioProject 
go
exec sp_rename
'Nashville Housing.PropertysplitAddress',
'PropertyAddress',
'column'
go

update [Nashville Housing]
set PropertyAddress=replace(PropertyAddress,'  ','-')

---OwnerAddress
Select*
From [Nashville Housing]

Select OwnerAddress,PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From [Nashville Housing]
where OwnerAddress is not null

alter table [Nashville Housing]
add OwnAddress nvarchar(255);
update [Nashville Housing]
set OwnAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)
--
alter table [Nashville Housing]
add Ownercity nvarchar(255);
update [Nashville Housing]
set Ownercity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)
--
alter table [Nashville Housing]
add Ownerstste nvarchar(255);
update [Nashville Housing]
set Ownerstste=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

alter table [Nashville Housing]
drop column OwnerAddress 

----Remove Duplicates
with cte_num as(
select*, ROW_NUMBER() over 
(partition by ParcelID,SalePrice,PropertyAddress,OwnerAddress,LandUse  order by PropertyAddress) rownum
from [Nashville Housing]
)
select *
from cte_num
where rownum >1


      