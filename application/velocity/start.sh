#!/bin/sh
# Startup script for Velocity proxy.
# Override individual options via environment variables:
#
#   JVM_XMS        Initial heap size          (default: 1G)
#   JVM_XMX        Maximum heap size          (default: 1G)
#   JVM_OPTS       Fully replace ALL JVM flags (overrides JVM_XMS/JVM_XMX and GC flags)
#   EXTRA_JVM_OPTS Append extra JVM flags to the defaults
#   JAR_PATH       Path to the velocity jar   (default: /app/velocity.jar)

JAR_PATH="${JAR_PATH:-/app/velocity.jar}"

if [ -n "$JVM_OPTS" ]; then
    # User supplied a full replacement for all JVM flags
    echo "Using custom JVM options: $JVM_OPTS"
    echo "Starting java application with command:"
    echo "java $JVM_OPTS -jar $JAR_PATH"
    exec java $JVM_OPTS -jar "$JAR_PATH"
else
    JVM_XMS="${JVM_XMS:-1G}"
    JVM_XMX="${JVM_XMX:-1G}"
    DEFAULT_FLAGS="-Xms${JVM_XMS} -Xmx${JVM_XMX} \
        -XX:+UseG1GC \
        -XX:G1HeapRegionSize=4M \
        -XX:+UnlockExperimentalVMOptions \
        -XX:+ParallelRefProcEnabled"

    echo "Starting java application with command:"
    echo "java $DEFAULT_FLAGS $EXTRA_JVM_OPTS -jar $JAR_PATH"
    exec java $DEFAULT_FLAGS $EXTRA_JVM_OPTS -jar "$JAR_PATH"
fi
