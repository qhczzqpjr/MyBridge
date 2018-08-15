::/st1::kinit -k -t /opt/Cloudera/keytabs/zookeeper.``hostname``.keytab zookeeper/``hostname -f``
::/st3::/opt/cloudera/parcels/CDH-5.9.1-1.cdh5.9.1.p2282.2481/lib/zookeeper/bin/zkCli.sh -server dsccmaster02i1d.eur.nsroot.net:2181



/*Check current status of the kafka queue*/