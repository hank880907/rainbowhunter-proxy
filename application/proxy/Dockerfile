FROM rainbowhunter-proxy:velocity
ENTRYPOINT ["java", "-Xms256M", "-Xmx400M", "-XX:+UseG1GC", "-XX:G1HeapRegionSize=4M", "-XX:+ParallelRefProcEnabled", "-jar", "velocity-3.5.0-SNAPSHOT-574.jar"]