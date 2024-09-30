create database <db_name>;
revoke all on database <db_name> from public;
create role <db_role>;
grant connect on database <db_name> to <db_role>;
create user <db_user> with password '<secret>';
grant <db_role> to <db_user>;