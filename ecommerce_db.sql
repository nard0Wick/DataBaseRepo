show engines; -- be sure that InnoDB is the default storage engine 

use ecommerce_db; 

/*Keys table*/ 
drop table if exists master_keys; 
create table master_keys( 
	master_key_id bigint auto_increment, 
    master_key blob, 
    token varchar(50),
    token_is_active tinyint, 
    token_expires_at timestamp, 
    primary key (master_key_id)
); 
/*Checking for information related with the table: master_keys*/
-- show table status where name = "master_keys";

/*Users table*/ 
drop table if exists users; 
create table users( 
	id bigint auto_increment, 
	key_id bigint, 
	user_name varchar(90), 
	last_name varchar(90), 
	email varchar(90), 
	telephone_number bigint, 
	created_at timestamp, 
	is_active tinyint(1), 
	primary key (id), 
	foreign key (key_id) references master_keys (master_key_id)
);

/*Details table*/ 
drop table if exists details; 
create table details( 
	details_id bigint auto_increment, 
    user_id bigint, 
    start_interaction timestamp, 
    last_interaction timestamp,
    referrer_url varchar (255),
    primary key (details_id), 
    foreign key (user_id) references users (id)
); 

/*Locations table*/
drop table if exists locations;
create table locations(
	location_id bigint auto_increment,
    user_id bigint,
    country_code varchar (50),
    postal_code varbinary (50),
    street varbinary (150),
    street_number int,
    selected tinyint, 
    primary key (location_id),
    foreign key (user_id) references users (id)
);  

/*Categories table*/
drop table if exists categories;
create table categories(
	category_id bigint auto_increment,
    category_name varchar(90),
    category_description varchar(255),
    primary key (category_id)
); 

/*Favorite_categories table wich represents many to many relationship*/
drop table if exists favorite_categories; 
create table favorite_categories(
	user_id bigint not null,
    category_id bigint not null,
    foreign key (user_id) references users (id),
    foreign key (category_id) references categories (category_id)
);  

/*Shopping_carts table*/
drop table if exists shopping_carts;
create table shopping_carts(
	cart_id bigint auto_increment,
    user_id bigint,
    created_at timestamp,
    is_stucked tinyint(1),
    expires_at timestamp,
    primary key (cart_id),
    foreign key (user_id) references users (id)
); 

/*Order_products table*/
drop table if exists ordered_products; 
create table ordered_products(
	ordered_product_id bigint auto_increment,
    shopping_id bigint,
    product_id bigint,
    price_per_unit decimal (15, 2),
    discount decimal (15, 2),
    quantity int,
    primary key(ordered_product_id),
    foreign key (shopping_id) references shopping_carts (cart_id)
);

/*Orders table*/
drop table if exists orders;
create table orders(
	order_id bigint auto_increment, 
    user_id bigint,
    shopping_id bigint,
    created_at timestamp, 
    cost decimal(15, 2),
    tax decimal(15, 2),
    total decimal(15, 2),
    currency varchar(50),
    current_status varchar(50),
    primary key (order_id),
    foreign key (user_id) references users (id),
    foreign key (shopping_id) references shopping_carts (cart_id)
);

/*Payments table*/
drop table if exists payments; 
create table payments(
	payment_id bigint auto_increment, 
    order_id bigint,
    pay_method varchar(50),
    token varchar(50),
    token_is_active tinyint,
    token_expires_at timestamp,
    primary key (payment_id),
    foreign key (order_id) references orders (order_id)
);

/*Shipping table*/
drop table if exists shipping;
create table shipping(
	shipping_id bigint auto_increment,
    user_location_id bigint,
    order_id bigint,
    current_status varchar(50),
    primary key (shipping_id),
    foreign key (user_location_id) references locations (location_id),
    foreign key (order_id) references orders (order_id)
);
