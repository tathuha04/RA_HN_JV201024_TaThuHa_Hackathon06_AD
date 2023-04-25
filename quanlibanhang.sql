create table CUSTOMERS(
customer_id varchar(4) primary key ,
name varchar(100) not null,
email varchar(100) not null,
phone varchar(25) not null,
address varchar(255) not null,
unique(email,phone)
);
create table ORDERS(
order_id varchar(4) primary key,
customer_id varchar(4)not null,
foreign key(customer_id) references CUSTOMERS(customer_id) ,
order_date date not null,
total_amount double not null
);
create table PRODUCTS(
product_id varchar(4) primary key,
name varchar(255) not null,
description text,
price double not null,
status bit(1) not null
);
create table ORDERS_DETAILS(
order_id varchar(4) not null,
foreign key(order_id) references ORDERS(order_id),
product_id varchar(4) not null,
foreign key(product_id) references PRODUCTS(product_id),
price double not null,
quantity int(11) not null,
primary key(order_id,product_id)
);
drop table ORDERS_DETAILS;

-- Bài 2: Thêm dữ liệu [20 điểm]:

insert into CUSTOMERS values
('C001','Nguyễn Trung Mạnh','manhnt@gmail.com',984756322,'Cầu Giấy,Hà Nội'),
('C002','Hồ Hải Nam','namhh@gmail.com',984875926,'Ba Vì,Hà Nội'),
('C003','Tô Ngọc Vũ','vutn@gmail.com',904725784,'Mộc Châu,Sơn La'),
('C004','Phạm Ngọc Anh','anhpn@gmail.com',984635365,'Vinh,Nghệ An'),
('C005','Trương Minh Cường','cuongtm@gmail.com',989735624,'Hai Bà Trưng,Hà Nội')
;

insert into PRODUCTS values
('P001','Iphone 13 ProMax','Bản 512 GB, xanh lá',22999999,1),
('P002','Dell Vostro V3510','Core i5 RAM 8GB',14999999,1),
('P003','Macbook Pro M2','8CPU 10GPU 8BG 256GB',28999999,1),
('P004','Apple Watch Ultra ','Titanium Alpine Loop Small',18999999,1),
('P005','Airpods 2 2022','Spatial Audio',4090000,1)
;

insert into ORDERS values
('H001','C001','2023/02/22',52999997),
('H002','C001','2023/03/11',80999997),
('H003','C002','2023/01/22',54359998),
('H004','C003','2023/03/14',102999995),
('H005','C003','2022/03/12',80999997),
('H006','C004','2023/02/01',110449994),
('H007','C004','2023/03/29',70999996),
('H008','C005','2023/02/14',29999998),
('H009','C005','2023/01/10',28999999),
('H010','C005','2023/04/01',149999994)
;

insert into Orders_details values
('H001','P002',14999999,1),
('H001','P004',18999999,2),
('H002','P001',22999999,1),
('H002','P003',28999999,2),
('H003','P004',18999999,2),
('H003','P005',4900000,4),
('H004','P002',14999999,3),
('H004','P003',28999999,2),
('H005','P001',22999999,1),
('H005','P003',28999999,2),
('H006','P005',4900000,5),
('H006','P002',14999999,6),
('H007','P004',18999999,3),
('H007','P001',22999999,1),
('H008','P002',14999999,2),
('H009','P003',28999999,1),
('H010','P003',28999999,2),
('H010','P001',22999999,4)
;

-- Bài 3: Truy vấn dữ liệu [30 điểm]:
-- 1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .
-- [4 điểm]
select name , email, phone, address from CUSTOMERS;
-- 2. Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện
-- thoại và địa chỉ khách hàng). [4 điểm]
select CUSTOMERS.name , CUSTOMERS.phone, CUSTOMERS.address from CUSTOMERS 
inner join ORDERS on ORDERS.customer_id = CUSTOMERS.customer_id
where ORDERS.order_date between '2023-03-01' and '2023-03-31'
;
-- 3. Thống kê doanh thu theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm
-- tháng và tổng doanh thu ). [4 điểm]
select month(o.order_date) 'Tháng', sum(o.total_amount) as'Tổng Doanh Thu'
from orders o 
where year(o.order_date) = 2023
group by month(order_date)
order by month(order_date) asc;
-- 4. Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách
-- hàng, địa chỉ , email và số điên thoại). [4 điểm]

select CUSTOMERS.name, CUSTOMERS.address, CUSTOMERS.email, CUSTOMERS.phone from CUSTOMERS 
inner join ORDERS on ORDERS.customer_id = CUSTOMERS.customer_id
where year(ORDERS.order_date) not in(select year(order_date) from ORDERS where year(order_date) = 2022)
;
-- 5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã
-- sản phẩm, tên sản phẩm và số lượng bán ra). [4 điểm]
select Orders_details.product_id as 'mã sản phẩm', PRODUCTS.name , sum(Orders_details.quantity) from Orders_details
inner join PRODUCTS on Orders_details.product_id = PRODUCTS.product_id
inner join ORDERS on orders.order_id = Orders_details.order_id
where year(ORDERS.order_date) not in(select year(order_date) from ORDERS where year(order_date) = 2022) 
and month(ORDERS.order_date)=3
group by Orders_details.product_id
;
-- 6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi
-- tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu). [5 điểm]
select customers.customer_id as 'mã khách hàng', customers.name as 'tên khách hàng' , sum(orders.total_amount)as 'mức chi tiêu' from orders
inner join customers on customers.customer_id = orders.customer_id
where customers.customer_id  in (select orders.customer_id from orders where year(order_date)=2023)
group by customers.customer_id
order by sum(orders.total_amount) desc
;
-- 7. Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm
-- tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) . [5 điểm]
select CUSTOMERS.name as 'tên', total_amount as 'tổng tiền' , orders.order_date as 'ngày tạo hoá đơn' ,
 sum(Orders_details.quantity) as 'tổng số lượng sản phẩm' from orders_details
inner join orders on orders.order_id = orders_details.order_id
inner join customers on customers.customer_id = orders.customer_id
group by orders.order_id
having sum(Orders_details.quantity) >= 5
;

-- Bài 4: Tạo View, Procedure [30 điểm]:
-- 1. Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng
-- tiền và ngày tạo hoá đơn . [3 điểm]
create view Orders_view as select customers.name,customers.phone ,customers.address, orders.total_amount, orders.order_date from customers
inner join orders on customers.customer_id = orders.customer_id
;
-- 2. Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng
-- số đơn đã đặt. [3 điểm]
create view Orders_view2 as select Customers.name , Customers.address,Customers.phone, count(orders.customer_id) from customers
inner join orders on customers.customer_id = orders.customer_id
group by orders.customer_id;
-- 3. Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã
-- bán ra của mỗi sản phẩm.
create view Orders_view3 as select products.name , products.description , products.price , sum(orders_details.quantity) from products
inner join orders_details on orders_details.product_id = products.product_id
group by orders_details.product_id
;
-- 4. Đánh Index cho trường `phone` và `email` của bảng Customer. [3 điểm]
create unique index user_phone on customers(phone);
create unique index user_email on customers(email);
-- 5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.[3 điểm]
delimiter //
create procedure getCusById
(in cus_id varchar(4))
begin
  select * from customers where customer_id = cus_id;
end //
delimiter ;
call getCusById('C001');

-- 6. Tạo PROCEDURE lấy thông tin của tất cả sản phẩm. [3 điểm]
delimiter //
create procedure getProductById
(in Product varchar(4))
begin
  select * from products where product_id = Product;
end //
delimiter ;
call getProductById('P001');
-- 7. Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng. [3 điểm]

-- 8. Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng
-- tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo. [3 điểm]
-- 9. Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng
-- thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc. [3 điểm]
-- 10. Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự
-- giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê. [3 điểm]