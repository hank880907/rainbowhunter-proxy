FROM rainbowhunter-proxy:base
# Add extra plugins and configurations here
# This layer extends the base image with additional plugins
COPY plugins/ /app/plugins/
ENTRYPOINT ["java", "-Xms1G", "-Xmx1G", "-XX:+UseG1GC", "-XX:G1HeapRegionSize=4M", "-XX:+UnlockExperimentalVMOptions", "-XX:+ParallelRefProcEnabled", "-jar", "velocity-3.5.0-SNAPSHOT-574.jar"]