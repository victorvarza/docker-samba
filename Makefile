IMAGE=ghcr.io/hlesey/samba-server:1.0
CONTAINER_NAME=samba

run: stop
	docker run -d \
		--name ${CONTAINER_NAME} \
		--rm \
		-p 445:445 \
		-p 139:139 \
		-v $(CURDIR)/src/smb.conf:/etc/samba/smb.conf:ro \
		-v $(CURDIR)/users/groups.txt:/groups.txt:ro \
		-v $(CURDIR)/users/users.txt:/users.txt:ro \
		-v $(CURDIR)/users/pass.txt:/pass.txt:ro \
		-v /share:/data \
		${IMAGE}

build:
	docker build -t ${IMAGE} src/

push:
	docker push ${IMAGE}

buildx-setup:
	docker buildx create --name samba-builder --use --bootstrap || docker buildx use samba-builder

buildx:
	docker buildx build --platform linux/amd64,linux/arm64 -t ${IMAGE} src/ --load

buildx-push:
	docker buildx build --platform linux/amd64,linux/arm64 -t ${IMAGE} src/ --push

stop:
	docker stop ${CONTAINER_NAME}

logs:
	docker logs -f ${CONTAINER_NAME}

clean:
	docker rm -f ${CONTAINER_NAME} 2>/dev/null || true

.PHONY: run build buildx-setup buildx buildx-push push stop logs clean
