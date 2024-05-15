use ecommerce_db;

/*Declaring some functions*/ 
/*delimiter // 
create function generate_token() returns varchar (50) 
begin  
	-- function declaration 
    return random_bytes(16);
end; //

call generate_token;*/ 


/*Enforcing explicit commitment*/
set autocommit = 0;

/*Defining the needed atributes for encryption and decription*/
set block_encryption_mode = 'aes-256-cbc';
set @key_str = unhex(sha2('housekeeper', 512));
set @init_vector = random_bytes(16);

delimiter // 
create procedure p1(passphrase varchar(120)) 
begin  
	declare exit handler for sqlexception 
    begin 
		rollback; 
	end; 
    start transaction; 
		insert into master_keys(master_key) 
        values (aes_encrypt(passphrase, @key_str, @init_vector));
    commit;
end //
delimiter ;

lock table  

/*delimiter //
create function insert_key (password varchar(30)) returns tinyint
begin   
	insert into master_keys (password)
		values (aes_encrypt( password, @key_str, @init_vector)); 
    return 1;
end // 
delimiter;*/ 

/*altering mater_keys table*/
/*alter table users 
add unique (user_name);*/

/*drop procedure if exists p1;
delimiter //
create procedure p1(user_name varchar(90))  
begin 
	declare exit handler for sqlexception  
    begin 
		rollback;  
        resignal; 
	end; 
	start transaction;  
    
        insert into users (key_id, user_name, last_name, email, telephone_number, created_at, is_active) 
        values (8, user_name, "Fill", "pf@gmail.com", 4779918562, current_date(), 1);  
        
        insert into users (key_id, user_name, last_name, email, telephone_number, created_at, is_active) 
        values (8, "Pablo", "Fill", "pf@gmail.com", 4779918562, current_date(), 1);
    commit;    
end //
delimiter ; */

/*lock table users write;
call p1("Mich");  
unlock tables;
show errors;*/

/*insert into master_keys (password)  
values (aes_encrypt("pineaple :)", @key_str, @init_vector)), (aes_encrypt("pass123", @key_str, @init_vector)), (aes_encrypt("mysqlpassword", @key_str, @init_vector)); 
-- values (aes_encrypt("pass123", unhex(sha2(@key_str, 512)))); */

select * from master_keys;

/*Decripting password*/ 
select id, cast(aes_decrypt(password, @key_str, @init_vector) as char)
from master_keys;

insert into users (key_id, user_name, last_name, email, telephone_number, created_at, is_active) 
values(1, "Michael", "Zaragoza", "michaelzaragoza@gmail.com", 1112345678, current_timestamp(), 1), (2, "John", "Doe", "johndoe@gmail.com", 1621347891, current_timestamp(), 1), (3, "Jane", "Doe", "janedoe@gmail.com", 1234578690, current_timestamp(), 1); 

select * from users; 

/*Encrypting user private information referent to his location*/ 
insert into locations (user_id, country_code, postal_code, street, street_number, selected) 
values (4, "52", aes_encrypt("06140", @key_str, @init_vector), aes_encrypt("Agustín Melgar", @key_str, @init_vector), 33, 1), (5, "52", aes_encrypt("37000", @key_str, @init_vector), aes_encrypt("Francisco I. Madero", @key_str, @init_vector), 323, 1), (6, "52", aes_encrypt("06500", @key_str, @init_vector), aes_encrypt("Río Sena", @key_str, @init_vector), 110, 1); 

/*Decrypting user's location*/ 
select id, user_id, cast(aes_decrypt(postal_code, @key_str, @init_vector) as char), cast(aes_decrypt(street, @key_str, @init_vector) as char) 
from locations;

/*Generating a new shopping for the user 1*/
-- the cart shopping will be able for at least 72 hours
select @dat:= date_add(current_timestamp(), interval 3 day); 

insert into shopping_carts (user_id, created_at, not_stucked, expires_at) 
values(1, current_timestamp(), 0, @dat);

select * from shopping_carts; 

/*Generating some views*/
create view user_locations 
(user_id, user_name, last_name, email, country_code, telephone_number, postal_code, street, street_number, selected) 
as select user_id, user_name, last_name, email, country_code, telephone_number, postal_code, street, street_number, selected 
from users join locations 
on users.id = locations.user_id; 

select * from user_locations;  


select  user_name, last_name, email, country_code, telephone_number, is_active, postal_code, street, street_number, selected 
from users u inner join locations l on u.id = l.id 
	inner join master_keys mk on u.key_id = mk.id;
