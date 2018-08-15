#SingleInstance Force
;Build function to trace and execute any historical commands or data
::@r0::
::@r1::%s/\s*\(.*\);/LOG.info("\1 -> {}",\1);/g
::@r2::%s/\s*\(.*\);/System.out.println("\1 -> " {+} \1);/g
::@r3::cd $(dirname $(readlink -f $(which hbase)))
::@r4::
::@r5::
::@r6::
::@r7::netstat -atp
::@r8::import scala.collection.JavaConversions._
::@r9::jar -tf htrace-core-3.1.0-incubating.jar | grep Trace


::!s::System.out.println()

::/mvni::mvn install:install-file -Dfile=C:\Users\qz55554\Downloads\jmxtools-1.2.1.jar -DgroupId=com.sun.jdmk -DartifactId=jmxtools -Dversion=1.2.1 -Dpackaging=jar
; Ctrl+Shirft+T find which jar own the class

::/spkui::localhost:4040

/* check jar files info
jar tf
*/


/*
private static final Logger LOG = LoggerFactory.getLogger(App.class);
@r1 - %s/\s*\(.*\);/LOG.info("\1 -> {}",\1);/g
now.getDate() -> LOG.info("now.getDate() -> {}",now.getDate());

@r7 - check port open


mvn install:install-file -Dfile=sqljdbc4.jar -Dpackaging=jar -DgroupId=com.microsoft.sqlserver -DartifactId=sqljdbc4 -Dversion=4.0
*/


/**
List of Server Address
List of Service and port
List of common used folder

**/
 