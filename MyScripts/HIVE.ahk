#SingleInstance Force

ssh dsccmaster02i1d
kinit -k -t /opt/Cloudera/keytabs/hive.dsccmaster02i1d.keytab hive/dsccmaster02i1d.eur.nsroot.net@EURUXDEV.DYN.NSROOT.NET
!connect jdbc:hive2://dsccmaster02i1d.eur.nsroot.net:10000/default;principal=hive/dsccmaster02i1d.eur.nsroot.net@EURUXDEV.DYN.NSROOT.NET

kinit -k -t /opt/Cloudera/keytabs/gsmspark.dsccmaster02i1d.keytab gsmspark/dsccmaster02i1d.eur.nsroot.net@EURUXDEV.DYN.NSROOT.NET
beeline -u "jdbc:hive2://dsccmaster02i1d.eur.nsroot.net:10000/default;principal=hive/dsccmaster02i1d.eur.nsroot.net@EURUXDEV.DYN.NSROOT.NET"
;~ Beeline Usage
;show databases 
; CREATE ROLE <role>
; GRANT ALL ON database <> to <role>
; GRANT role <role> to group <group>

;CREATE DATABASE

; SHOW CURRENT ROLES
; SHOW ROLE 

; SHOW ROLE GRANT (USER|ROLE) principal_name;
;~[principal_specification]: USER user | ROLE role
; REVOKE [ADMIN OPTION FOR] role_name [, role_name] ... FROM principal_specification [, principal_specification] ... 

; Keytab(password file) & Password


::/hct::create database if not exists
::/hudb::use
;SET hive.exec.dynamic.partition=true;  
;SET hive.exec.dynamic.partition.mode=nonstrict; 


; spark.catalog.listDatabases.show(false)
; spark.catalog.listTables.show(false)