#SingleInstance Force
#Include Registers.ahk

;;;;;;;;;;;;;;;bash setting
;export PS1="[\u@\h \W \t]\\$\[$(tput sgr0)\]"
;vim ~/.bashrc
;source ~/.bashrc

;;;;;;;;;;;;;;;common used scripts
;find . -mmin -10
::/dht::describe '

;/usr/java/latest/bin
::/pb::pbrun gsmspark

; switch part
::/2cdh::cd /opt/cloudera/parcels/CDH/
::/2hbs::cd /opt/cloudera/parcels/CDH/lib/hbase
::/2ph::cd /opt/cloudera/parcels/CLABS_PHOENIX/lib/phoenix
::/2hv::cd /opt/cloudera/parcels/CDH/lib/hive
::/2ky::cd /home/gsmspark/opt/gsmspark/kylin
::/2kb::cd /opt/Cloudera/keytabs/
::/2kfk::cd /opt/cloudera/parcels/KAFKA
::/2lib::cd /home/gsmspark/lib
::/2ktb::cd /opt/Cloudera/keytabs/
::/2spk::cd /opt/cloudera/parcels/CDH/lib/spark
::/2spk2::cd /opt/cloudera/parcels/SPARK2/lib/spark2
::/2ze::cd /opt/gsmspark/zeppelin
::/2zeld::cd /opt/gsmspark/tmp/logs
::2/hdp::cd /opt/cloudera/parcels/CDH-5.9.1-1.cdh5.9.1.p2282.2481/lib/hadoop

; ls part
::/lscdh::less /opt/cloudera/parcels/CDH/
::/lshbs::less /opt/cloudera/parcels/CDH/lib/hbase
::/lsph::less /opt/cloudera/parcels/CLABS_PHOENIX/lib/phoenix
::/lshv::less /opt/cloudera/parcels/CDH/lib/hive
::/lsky::less /home/gsmspark/opt/gsmspark/kylin
::/lskb::less /opt/Cloudera/keytabs/
::/lskfk::less /opt/cloudera/parcels/KAFKA
::/lslib::less /home/gsmspark/lib
::/lsktb::less /opt/Cloudera/keytabs/
::/lsspk::less /opt/cloudera/parcels/CDH/lib/spark
::/lsspkls::less /opt/cloudera/parcels/SPARKls/lib/sparkls
::/lsze::less /opt/gsmspark/zeppelin
::/lszeld::less /opt/gsmspark/tmp/logs


::/chdf::alternatives --display hadoop-conf
::/scp::scp -c aes128-ctr init.sh qz55554@169.171.172.192:/opt/citimkts/qz55554/init.sh

; server lifecycle
;~ ::/stze::./opt/gsmspark/zeppelin/bin/zeppelin-daemon.sh start
;~ ::/stky::./opt/gsmspark/kylin/bin/kylin.sh start

;kafka http://blog.csdn.net/gk_kk/article/details/69396400
; ln -s /spark1.6 /spark
::/lg2::ssh dsccmaster02i1d
::/sp1::dsccproxy01i1d
::/sm1::dsccmaster01i1d
; klist -kt 


;configuration section
::/zkp::dsccmaster01i1d.eur.nsroot.net:2181;dsccmaster02i1d.eur.nsroot.net:2181;dsccmaster03i1d.eur.nsroot.net:2181
::/hdfs::hdfs://icg-e-dev:8020
::/yarn::http://dsccmaster03i1d.eur.nsroot.net:8088/cluster
;hbase UI
::/ckhbs::http://dsccmaster01i1d.eur.nsroot.net:60015/master-status



;Tool section

!#z::
	Run, explorer.exe http://dsccproxy01i1d:11900/#/
return

!#k::
	Run, explorer.exe http://dsccproxy01i1d:7070/kylin/
return

!#d:: ;login to tectia 
	Run, "C:\Program Files (x86)\SSH Communications Security\SSH Tectia\SSH Tectia Client\ssh-client-g3.exe" "SparkDev"
return

; https://github.com/apache/hbase

!#u:: ;login to tectia with profile
	Run, "C:\Program Files (x86)\SSH Communications Security\SSH Tectia\SSH Tectia Client\ssh-client-g3.exe" "SparkUAT"
return

::/st0::pbrun gsmspark

;init token hbase
::/st1::kinit -k -t /opt/Cloudera/keytabs/hbase.``hostname``.keytab hbase/``hostname -f``

;connect phoenix
::/st2::/usr/bin/phoenix-sqlline.py dsccmaster01i1d.eur.nsroot.net,dsccmaster02i1d.eur.nsroot.net,dsccmaster03i1d.eur.nsroot.net:2181:/hbase-gsmspark

;connect hbase
::/st3::hbase --config "/etc/hbase/conf.cloudera.hbase5" shell

;init token gsmspark
::/st4::kinit -k -t /opt/Cloudera/keytabs/gsmspark.dsccmaster02i1d.keytab gsmspark/dsccmaster02i1d.eur.nsroot.net@EURUXDEV.DYN.NSROOT.NET

/*
	Debug Section In case of server has any issue
*/
;show process
::/ps::ps -ef|grep
::/psk::ps aux|grep zeppelin|awk '{print $2}'|xargs kill -9