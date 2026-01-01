# Running samba in Docker
Samba server running on a Docker container

# Build

```bash
docker build -t samba-server .
```

# Run

```bash

IMAGE=samba-server
CONTAINER_NAME=samba

docker rm -f ${CONTAINER_NAME} 

docker run -d \
	--name ${CONTAINER_NAME} \
	-p 445:445 \
	-p 139:139 \
	-v $(pwd)/smb.conf:/etc/samba/smb.conf:ro \
	-v $(pwd)/groups.txt:/groups.txt:ro \
	-v $(pwd)/users.txt:/users.txt:ro \
	-v $(pwd)/pass.txt:/pass.txt:ro \
	-v /mnt/hdd1:/data \
	${IMAGE}
```