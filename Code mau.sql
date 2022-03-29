--Module 3. View
--1) Tạo view dbo.vw_Products hiển thị danh sách các sản phẩm từ bảng
--Production.Product và bảng Production.ProductCostHistory. Thông tin bao gồm
--ProductID, Name, Color, Size, Style, StandardCost, EndDate, StartDate
create view vw_Products
as
SELECT Production.Product.ProductID, Production.Product.Name, Production.Product.Color, Production.Product.Size, Production.Product.Style, Production.ProductCostHistory.EndDate, 
       Production.ProductCostHistory.StartDate, Production.ProductCostHistory.StandardCost
FROM   Production.Product INNER JOIN
       Production.ProductCostHistory ON Production.Product.ProductID = Production.ProductCostHistory.ProductID

select * from vw_Products

sp_helptext vw_Products
--2) Tạo view List_Product_View chứa danh sách các sản phẩm có trên 500 đơn đặt
--hàng trong quí 1 năm 2008 và có tổng trị giá >10000, thông tin gồm ProductID,
--Product_Name, CountOfOrderID và SubTotal.
create vw_List_Product

SELECT Sales.SalesOrderHeader.SubTotal, Production.Product.Name, Production.Product.ProductID, Sales.SalesOrderDetail.SalesOrderID AS Expr1
FROM   Production.Product INNER JOIN
       Sales.SalesOrderDetail ON Production.Product.ProductID = Sales.SalesOrderDetail.ProductID INNER JOIN
       Sales.SalesOrderHeader ON Sales.SalesOrderDetail.SalesOrderID = Sales.SalesOrderHeader.SalesOrderID
--3) Tạo view dbo.vw_CustomerTotals hiển thị tổng tiền bán được (total sales) từ cột
--TotalDue của mỗi khách hàng (customer) theo tháng và theo năm. Thông tin gồm
--CustomerID, YEAR(OrderDate) AS OrderYear, MONTH(OrderDate) AS
--OrderMonth, SUM(TotalDue).

--4) Tạo view trả về tổng số lượng sản phẩm (Total Quantity) bán được của mỗi nhân
--viên theo từng năm. Thông tin gồm SalesPersonID, OrderYear, sumOfOrderQty

--5) Tạo view ListCustomer_view chứa danh sách các khách hàng có trên 25 hóa đơn
--đặt hàng từ năm 2007 đến 2008, thông tin gồm mã khách (PersonID) , họ tên
--(FirstName +' '+ LastName as FullName), Số hóa đơn (CountOfOrders).

--6) Tạo view ListProduct_view chứa danh sách những sản phẩm có tên bắt đầu với
--‘Bike’ và ‘Sport’ có tổng số lượng bán trong mỗi năm trên 50 sản phẩm, thông
--tin gồm ProductID, Name, SumOfOrderQty, Year. (dữ liệu lấy từ các bảng
--Sales.SalesOrderHeader, Sales.SalesOrderDetail, và
--Production.Product)

--7) Tạo view List_department_View chứa danh sách các phòng ban có lương (Rate:
--lương theo giờ) trung bình >30, thông tin gồm Mã phòng ban (DepartmentID),
--tên phòng ban (Name), Lương trung bình (AvgOfRate). Dữ liệu từ các bảng
--[HumanResources].[Department],
--[HumanResources].[EmployeeDepartmentHistory],
--[HumanResources].[EmployeePayHistory].

--8) Tạo view Sales.vw_OrderSummary với từ khóa WITH ENCRYPTION gồm
--OrderYear (năm của ngày lập), OrderMonth (tháng của ngày lập), OrderTotal
--(tổng tiền). Sau đó xem thông tin và trợ giúp về mã lệnh của view này

--9) Tạo view Production.vwProducts với từ khóa WITH SCHEMABINDING
--gồm ProductID, Name, StartDate,EndDate,ListPrice của bảng Product và bảng
--ProductCostHistory. Xem thông tin của View. Xóa cột ListPrice của bảng
--Product. Có xóa được không? Vì sao?

--10) Tạo view view_Department với từ khóa WITH CHECK OPTION chỉ chứa các
--phòng thuộc nhóm có tên (GroupName) là “Manufacturing” và “Quality
--Assurance”, thông tin gồm: DepartmentID, Name, GroupName.
--a.Chèn thêm một phòng ban mới thuộc nhóm không thuộc hai nhóm
--“Manufacturing” và “Quality Assurance” thông qua view vừa tạo. Có
--chèn được không? Giải thích.
--b.Chèn thêm một phòng mới thuộc nhóm “Manufacturing” và một
--phòng thuộc nhóm “Quality Assurance”.
--c.Dùng câu lệnh Select xem kết quả trong bảng Department

--I)Batch

--1)Viết một batch khai báo biến @tongsoHD chứa tổng số hóa đơn của sản phẩm
--có ProductID=’778’; nếu @tongsoHD>500 thì in ra chuỗi “Sản phẩm 778 có
--trên 500 đơn hàng”, ngược lại thì in ra chuỗi “Sản phẩm 778 có ít đơn đặt
--hàng”
declare @tongsoHD int
SELECT  @tongsoHD=count(SalesOrderID)
FROM    Sales.SalesOrderDetail
where ProductID=778
if @tongsoHD>500
	print 'San pham 778 co tren 500 don hang'
else
	print 'Sanpham 778 có it hon 500 don hang'

--2)Viết một đoạn Batch với tham số @makh và @n chứa số hóa đơn của khách
--hàng @makh, tham số @nam chứa năm lập hóa đơn (ví dụ @nam=2008), nếu
--@n>0 thì in ra chuỗi: “Khách hàng @makh có @n hóa đơn trong năm 2008”
--ngược lại nếu @n=0 thì in ra chuỗi “Khách hàng @makh không có hóa đơn nào
--trong năm 2008”
declare @makh int, @n int, @nam datetime
set @makh=98643
set @nam=2008
select @n=count(SalesOrderID)
from Sales.SalesOrderHeader
where CustomerID=@makh and year(OrderDate)=@nam
if @n>0
	print 'Khach hang '+convert(char(5),@makh)+' co '+convert(char(3),@n)+' hoa don trong nam 2008'
else
	print 'Khach hang '+convert(char(5),@makh)+' khong co hoa don trong nam 2008'

--3)Viết một batch tính số tiền giảm cho những hóa đơn (SalesOrderID) có tổng
--tiền>100000, thông tin gồm [SalesOrderID], SubTotal=SUM([LineTotal]),
--Discount (tiền giảm), với Discount được tính như sau:
--Những hóa đơn có SubTotal<100000 thì không giảm,
--SubTotal từ 100000 đến <120000 thì giảm 5% của SubTotal
--SubTotal từ 120000 đến <150000 thì giảm 10% của SubTotal
--SubTotal từ 150000 trở lên thì giảm 15% của SubTotal
--(Gợi ý: Dùng cấu trúc Case… When …Then …)
SELECT SalesOrderID, SubTotal=sum(LineTotal),
       Discount=case
		when sum(LineTotal)<10000 then 0
		when sum(LineTotal)>=10000 and sum(LineTotal)<12000 then 0.05*sum(LineTotal)
		when sum(LineTotal)>=12000 and sum(LineTotal)<15000 then 0.1*sum(LineTotal)
		when sum(LineTotal)>=15000 then 0.15*sum(LineTotal)
		end
FROM   Sales.SalesOrderDetail
group by SalesOrderID

--4)Viết một Batch với 3 tham số: @mancc, @masp, @soluongcc, chứa giá trị của
--các field [ProductID],[BusinessEntityID],[OnOrderQty], với giá trị truyền cho
--các biến @mancc, @masp (vd: @mancc=1650, @masp=4), thì chương trình sẽ
--gán giá trị tương ứng của field [OnOrderQty] cho biến @soluongcc, nếu
--@soluongcc trả về giá trị là null thì in ra chuỗi “Nhà cung cấp 1650 không cung
--cấp sản phẩm 4”, ngược lại (vd: @soluongcc=5) thì in chuỗi “Nhà cung cấp 1650
--cung cấp sản phẩm 4 với số lượng là 5”
--(Gợi ý: Dữ liệu lấy từ [Purchasing].[ProductVendor])
declare @mancc int, @masp int, @soluongcc int
set @mancc=1670
set @masp=1
SELECT @soluongcc=OnOrderQty
FROM   Purchasing.ProductVendor
where ProductID=@masp and BusinessEntityID=@mancc
if @soluongcc is null
	print 'Nha cung cap '+convert(char(4),@mancc)+' khong cung cap san pham '+convert(char(2),@masp)
else
	print 'Nha cung cap '+convert(char(4),@mancc)+' cung cap san pham '+convert(char(2),@masp)+' voi so luong la '+convert(char(2),@soluongcc)

select * from Purchasing.ProductVendor
--5)Viết một batch thực hiện tăng lương giờ (Rate) của nhân viên trong
--[HumanResources].[EmployeePayHistory] theo điều kiện sau: Khi tổng lương
--giờ của tất cả nhân viên Sum(Rate)<6000 thì cập nhật tăng lương giờ lên 10%,
--nếu sau khi cập nhật mà lương giờ cao nhất của nhân viên >150 thì dừng
while (select sum(Rate) from HumanResources.EmployeePayHistory)<6000
begin
update HumanResources.EmployeePayHistory
set Rate=Rate+Rate*0.1
if (select max(Rate) from HumanResources.EmployeePayHistory)>150
	break
else
	continue
end

select * from HumanResources.EmployeePayHistory

--II)Stored Procedure

--1)Viết một thủ tục tính tổng tiền thu (TotalDue) của mỗi khách hàng trong một
--tháng bất kỳ của một năm bất kỳ (tham số tháng và năm) được nhập từ bàn phím,
--thông tin gồm: CustomerID, SumOfTotalDue =Sum(TotalDue)
--create
go
create proc TotalDue @thang datetime, @nam datetime
as
begin
select CustomerID, SumOfTotalDue=sum(TotalDue)
from Sales.SalesOrderHeader
where @thang=MONTH(OrderDate) and @nam=YEAR(OrderDate)
group by CustomerID
end

--execute
exec TotalDue 7 ,2005

select * from Sales.SalesOrderHeader
--2)Viết một thủ tục dùng để xem doanh thu từ đầu năm cho đến ngày hiện tại của
--một nhân viên bất kỳ, với một tham số đầu vào và một tham số đầu ra. Tham số
--@SalesPerson nhận giá trị đầu vào theo chỉ định khi gọi thủ tục, tham số
--@SalesYTD được sử dụng để chứa giá trị trả về của thủ tục.
--create
go
create proc Doanhthu @SalesPerson int, @SalesYTD money output
as
begin
SELECT @SalesYTD=sum(Sales.SalesPerson.SalesYTD)
FROM   Sales.SalesOrderHeader INNER JOIN
       Sales.SalesPerson ON Sales.SalesOrderHeader.SalesPersonID = Sales.SalesPerson.BusinessEntityID
where Sales.SalesPerson.BusinessEntityID=@SalesPerson and OrderDate<=GETDATE()
end

drop proc Doanhthu
--execute
go
declare @SalesPerson int, @SalesYTD money
set @SalesPerson=275
exec Doanhthu @SalesPerson, @SalesYTD output
print convert(char(3),@SalesPerson)+convert(char(15),@SalesYTD)

select * from Sales.SalesPerson
--3)Viết một thủ tục trả về một danh sách ProductID, ListPrice của các sản phẩm có
--giá bán không vượt quá một giá trị chỉ định (tham số input @MaxPrice).

--4)Viết thủ tục tên NewBonus cập nhật lại tiền thưởng (Bonus) cho 1 nhân viên bán
--hàng (SalesPerson), dựa trên tổng doanh thu của nhân viên đó. Mức thưởng mới
--bằng mức thưởng hiện tại cộng thêm 1% tổng doanh thu. Thông tin bao gồm
--[SalesPersonID], NewBonus (thưởng mới), SumOfSubTotal. Trong đó:
--SumOfSubTotal =sum(SubTotal)
--NewBonus = Bonus+ sum(SubTotal)*0.01

--5)Viết một thủ tục dùng để xem thông tin của nhóm sản phẩm (ProductCategory)
--có tổng số lượng (OrderQty) đặt hàng cao nhất trong một năm tùy ý (tham số
--input), thông tin gồm: ProductCategoryID, Name, SumOfQty. Dữ liệu từ bảng
--ProductCategory, ProductSubCategory, Product và SalesOrderDetail.
--(Lưu ý: dùng Sub Query)

--6)Tạo thủ tục đặt tên là TongThu có tham số vào là mã nhân viên, tham số đầu ra
--là tổng trị giá các hóa đơn nhân viên đó bán được. Sử dụng lệnh RETURN để trả
--về trạng thái thành công hay thất bại của thủ tục.
--create
go
create proc TongThu @manv int, @tonghd money output
as
begin
SELECT @tonghd=sum(SubTotal)
FROM   Sales.SalesOrderHeader
where SalesPersonID=@manv
return 1
if @tonghd>0 return 1
else return 0
end

--exec
declare @tong money
exec TongThu 282,@tong output
print convert(char(10),@tong)


--7)Tạo thủ tục hiển thị tên và số tiền mua của cửa hàng mua nhiều hàng nhất theo
--năm đã cho.

--8)Viết thủ tục Sp_InsertProduct có tham số dạng input dùng để chèn một mẫu tin
--vào bảng Production.Product. Yêu cầu: chỉ thêm vào các trường có giá trị not
--null và các field là khóa ngoại.

--9)Viết thủ tục XoaHD, dùng để xóa 1 hóa đơn trong bảng Sales.SalesOrderHeader
--khi biết SalesOrderID. Lưu ý : trước khi xóa mẫu tin trong
--Sales.SalesOrderHeader thì phải xóa các mẫu tin của hoá đơn đó trong
--Sales.SalesOrderDetail.

--10)Viết thủ tục Sp_Update_Product có tham số ProductId dùng để tăng listprice
--lên 10% nếu sản phẩm này tồn tại, ngược lại hiện thông báo không có sản phẩm
--này

--III)Function

--Scalar Function

--1)Viết hàm tên CountOfEmployees (dạng scalar function) với tham số @mapb,
--giá trị truyền vào lấy từ field [DepartmentID], hàm trả về số nhân viên trong
--phòng ban tương ứng. Áp dụng hàm đã viết vào câu truy vấn liệt kê danh sách các
--phòng ban với số nhân viên của mỗi phòng ban, thông tin gồm: [DepartmentID],
--Name, countOfEmp với countOfEmp= CountOfEmployees([DepartmentID]).
--(Dữ liệu lấy từ bảng
--[HumanResources].[EmployeeDepartmentHistory] và
--[HumanResources].[Department])
go
create function CountOfEmployees(@mapb int)
returns int
as
begin
declare @tong int
SELECT  @tong=count(HumanResources.EmployeeDepartmentHistory.BusinessEntityID)
FROM    HumanResources.Department INNER JOIN
        HumanResources.EmployeeDepartmentHistory ON HumanResources.Department.DepartmentID = HumanResources.EmployeeDepartmentHistory.DepartmentID
where HumanResources.Department.DepartmentID=@mapb
return @tong
end

declare @mapb int
set @mapb=01
if exists(select * from HumanResources.Department where DepartmentID=@mapb)
print 'Ma phong ban '+convert(char(2),@mapb)+'co tong so nhan vien la '+convert(char(2),dbo.CountOfEmployees(@mapb))
else
print ('Ma phong ban khong ton tai')

--2)Viết hàm tên là InventoryProd (dạng scalar function) với tham số vào là
--@ProductID và @LocationID trả về số lượng tồn kho của sản phẩm trong khu
--vực tương ứng với giá trị của tham số
--(Dữ liệu lấy từ bảng[Production].[ProductInventory])
go
create function InventoryProd(@ProductID int, @LocationID int)
returns table
as

return
	SELECT   ProductID, LocationID, Total=sum(Quantity)
	FROM     Production.ProductInventory
	where ProductID=@ProductID and LocationID=@LocationID
	group by ProductID, LocationID

declare @ProductID int, @LocationID int
set @ProductID=1
set @LocationID=2
if exists (select * from Production.ProductInventory where ProductID=@ProductID and LocationID=@LocationID)
select * from InventoryProd(@ProductID,@LocationID)
else
print('Kiem tra lai thong tin nhap vao!!!')

--3)Viết hàm tên SubTotalOfEmp (dạng scalar function) trả về tổng doanh thu của
--một nhân viên trong một tháng tùy ý trong một năm tùy ý, với tham số vào
--@EmplID, @MonthOrder, @YearOrder
--(Thông tin lấy từ bảng [Sales].[SalesOrderHeader])