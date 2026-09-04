FROM docker.io/amazoncorretto:25
WORKDIR /data
COPY data/ /data/
COPY velocity-4.1.2-SNAPSHOT-27.jar /app/velocity.jar
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh
EXPOSE 25565
ENTRYPOINT ["/app/start.sh"]