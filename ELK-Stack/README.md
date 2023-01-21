Commands :

Start the ELK stack - 
docker compose up

Start the filebeat container - 
docker run -i -t --name filebeat --network=SOANet  -v /home/sushilpawar/mydocker/DockerVolume/FileBeatsVolume/filebeat.docker.yml:/usr/share/filebeat/filebeat.yml:ro -v /home/sushilpawar/mydocker/DockerVolume:/usr/share/logs:ro   docker.elastic.co/beats/filebeat:8.6.0 
