source ./env.sh
echo $REDIS_CONNECT_CONFIG
java -classpath "../lib/*" -DjobQueueType=LIST -Dredis.connect.configLocation=$REDIS_CONNECT_CONFIG com.redislabs.connect.redis.RedisConnectSetupProvider update-metrics-config
