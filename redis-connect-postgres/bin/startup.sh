source ./env.sh

nohup java -XX:+HeapDumpOnOutOfMemoryError -Xms256m -Xmx1g -classpath "../lib/*:../lib/ext/*" -Dredis.connect.secret=$REDIS_CONNECT_SECRET -Dspring.main.banner-mode=off -Dlogging.config=$LOGBACK_CONFIG -Dlogback.configurationFile=$LOGBACK_CONFIG -Dredis.connect.configLocation=$REDIS_CONNECT_CONFIG -DREST_API_ENABLED=false com.redislabs.connect.ConnectLauncher 1> rlcdc.out 2>&1 </dev/null &
