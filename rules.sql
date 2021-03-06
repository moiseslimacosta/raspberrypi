-- Rule: Temperature Difference
insert into rules (rule_desc, rule_query, rule_message, rule_active) values( 'Temperature Difference','select abs(r.current - r.previous) as diff, r.current, r.previous from (select substring_index( group_concat( x.value order by x.timestamp desc ),\',\',1)+0 as current, substring_index( group_concat( x.value order by x.timestamp ),\',\',1)+0 as previous from (select sd.* from sensor_data sd where sd.sensor_id = 1 order by sd.timestamp desc limit 2) x) r where abs(r.current - r.previous) > 1;','Difference of %.2f°C between two readings (%.2f°C - %.2f°C)','Y');

-- Rule: New Record
insert into rules(rule_desc,rule_query,rule_message,rule_preproc,rule_postproc,rule_active) values('New Record','select sen.sensor_name, least(new.min_value, old.min_value), greatest(new.max_value, old.max_value) from sensor_high_low old, tmp_high_low new, sensors sen where old.sensor_id = new.sensor_id and old.sensor_id = sen.sensor_id and ( old.min_value > new.min_value or old.max_value < new.max_value );','New record for %s, Low = %.2f / High = %.2f', 'call new_high_low()','call update_high_low()','Y');

-- Rule: No Data Logged
insert into rules (rule_desc, rule_query, rule_message, rule_shellcmd, rule_run_shell, rule_active) values('No Data Logged', 'select date_format( x.ts, \'%M %d, %Y at %H:%i:%s\' ) from ( select max(timestamp) as ts from sensor_data ) x where timestampdiff( MINUTE, x.ts, now() ) > 5;', 'No data has been logged for at least 5 minutes. Last entry was on %s. The Raspberry Pi will be rebooted...', 'sudo reboot', 'results', 'Y');

-- Rule: Unhealthy Humidity
insert into rules (rule_desc, rule_query, rule_message, rule_active) values('Unhealthy Humidity', 'select d.value from sensor_data d, (select max(id) as id from sensor_data where sensor_id = 3) c where d.id = c.id and ( d.value < 30 or d.value > 60 );', 'Humidity is outside the healthy range (30-60%%). Humidity is %.2f%%', 'Y');

-- Rule: Remove Outlier Records
insert into rules(rule_desc,rule_query,rule_message,rule_preproc,rule_postproc,rule_active) values('Invalid Data Removed','select x.ct from (select count(*) as ct from sensor_data where valid = \'N\') x where x.ct > 0;','%d records with suspect data have been removed.', 'call mark_invalid()','call delete_invalid()','Y');

-- Save changes
commit;