source ./env.sh
echo $REDIS_CONNECT_CONFIG
java -classpath "../lib/*" -Dredis.connect.configLocation=$REDIS_CONNECT_CONFIG -Dlogback.configurationFile=$LOGBACK_CONFIG com.redislabs.connect.cli.CLI
