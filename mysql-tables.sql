-- Create database: sensordata
create database sensordata;

-- Create table: sensor_types
create table sensor_types ( 
  type_id       int not null auto_increment
, type_name     char(200) not null
, primary key (type_id)
);

-- Create table: location
create table locations(
  location_id    int not null auto_increment
, location_name  char(200) not null
, primary key (location_id)
);

-- Create table: sensors
create table sensors( 
  sensor_id     int not null auto_increment
, type_id       integer not null
, location_id   integer not null
, sensor_name   char(200) not null
, primary key (sensor_id)
, constraint foreign key (type_id) references sensor_types(type_id)
, constraint foreign key (location_id) references locations(location_id)
);

-- Create table: sensor_data
create table sensor_data( 
  id            int not null auto_increment
, timestamp     timestamp not null default current_timestamp
, sensor_id     integer not null
, value         real
, primary key (id)
, constraint foreign key (sensor_id) references sensors(sensor_id)
);

-- Add locations
insert into locations(location_name) values('Bedroom');
insert into locations(location_name) values('Office');
insert into locations(location_name) values('Guestroom');
insert into locations(location_name) values('Hall');
insert into locations(location_name) values('Kitchen/Livingroom');
insert into locations(location_name) values('Storageroom');

-- Add sensor types
insert into sensor_types(type_name) values('Temperature');
insert into sensor_types(type_name) values('Humidity');

-- Add sensors
insert into sensors(type_id,sensor_name,location_id) values(1,'DS18B20',2);
insert into sensors(type_id,sensor_name,location_id) values(1,'DHT22 - Temperature',2);
insert into sensors(type_id,sensor_name,location_id) values(2,'DHT22 - Humidity',2);

-- Create user
create user 'rpi'@'localhost' identified by 'rpi';

-- Grant privileges
grant all on sensordata.* to 'rpi'@'localhost';