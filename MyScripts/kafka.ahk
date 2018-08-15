::/kst1::/usr/bin/kafka-topics --list --zookeeper dsccmaster02i1d.eur.nsroot.net:2181
::/kst2::/usr/bin/kafka-topics --zookeeper dsccmaster02i1d.eur.nsroot.net:2181 --describe --topic 
::/kst3::/usr/bin/kafka-topics --zookeeper dsccmaster02i1d.eur.nsroot.net:2181 --create --topic MyFirstTopic1 --partition 2 --replication-factor 1
::/kst4::/usr/bin/kafka-console-producer --broker-list dsccr001d01i1d.eur.nsroot.net:9092 --topic MyFirstTopic1
::/kst5::/usr/bin/kafka-console-consumer --zookeeper dsccmaster02i1d.eur.nsroot.net:2181 --bootstrap-server dsccr001d01i1d.eur.nsroot.net:9092 --topic MyFirstTopic1

/*
kafka-consumer-offset-checker --topic SupplierTopic --group SupplierTopicGroup --zookeeper dsccmaster02i1d.eur.nsroot.net:2181 --broker-info 
/usr/bin/kafka-topics --zookeeper dsccmaster02i1d.eur.nsroot.net:2181 --delete --topic 

/usr/bin/kafka-topics --zookeeper dsccmaster02i1d.eur.nsroot.net:2181 --create --topic MyFirstTopic1 --partition 2 --replication-factor 1
usr/bin/kafka-console-producer --broker-list dsccr001d01i1d.eur.nsroot.net:9092 --topic MyFirstTopic1
/usr/bin/kafka-console-consumer --zookeeper dsccmaster02i1d.eur.nsroot.net:2181 --bootstrap-server dsccr001d01i1d.eur.nsroot.net:9092 --topic MyFirstTopic1

; bin/kafka-topics --list --zookeeper dsccmaster03i1d:2181
; bin/kafka-topics --create --zookeeper dsccmaster03i1d:2181 --replication-factor 1 --partitions 1 --topic kylin_streaming_topic
; bin/kafka-console-producer.sh --broker-list dsccmaster03i1d:9092 --topic kylin_streaming_topic
; bin/kafka-console-consumer.sh --bootstrap-server dsccmaster03i1d:9092 --from-beginning --topic kylin_streaming_topic

*/
;dsccr001d01i1d
;/data/3/kafka/log/kafka/kafka-broker-dsccr001d01i1d.eur.nsroot.net.log
;dsccr001d01i1d.eur.nsroot.net:9092,dsccr001d02i1d.eur.nsroot.net:9092,dsccr001d03i1d.eur.nsroot.net:9092
/*
;broker identification
broker.id
Port
log.dirs
zookeeper.connect   ;hostname:port


;autocreation topic
delete.topic.enable  ;allow detele topic Prod:false Dev:true
auto.create.topics.enable             ;stop auto created Prod:false Dev:true
default.replication.factor =1
num.partitions = 1
;retention
log.retention.ms
log.retention.bytes



Producer side setting:
acks     ; 0-No Retries(may loss data,better through put) 	1-(one replicate done)	all-highest realible(replicate done)
retries		; 0 (how many times before retry)
max.in.flight.requests.per.connection		;number of unack requests, may disorder if great than 1(as failed msg will be resent)
buffer.memory
compression.type
batch.size
linger.ms
client.id
max.request.size


Consumer side setting:


*/
