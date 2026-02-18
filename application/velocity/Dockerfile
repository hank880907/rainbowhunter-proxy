FROM docker.io/amazoncorretto:21
WORKDIR /data
COPY data/ /data/
COPY velocity-3.5.0-SNAPSHOT-574.jar /app/velocity.jar
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh
EXPOSE 25565
ENTRYPOINT ["/app/start.sh"]