default: all
all: build-all

build-all: build-comment build-post build-ui build-blackbox_exporter build-mongodb_exporter build-prometheus
push-all: push-comment push-post build-ui push-ui push-blackbox_exporter push-mongodb_exporter push-prometheus

build-comment:
	cd src/comment;bash docker_build.sh
push-comment:
	docker push $(USER_NAME)/comment

build-post:
	cd src/post-py;bash docker_build.sh
push-post:
	docker push $(USER_NAME)/post

build-ui:
	cd src/ui;bash docker_build.sh
push-ui:
	docker push $(USER_NAME)/ui

build-blackbox_exporter:
	cd monitoring/blackbox_exporter;docker build -t $(USER_NAME)/blackbox_exporter .
push-blackbox_exporter:
	docker push $(USER_NAME)/blackbox_exporter

build-mongodb_exporter:
	cd monitoring/mongodb_exporter;docker build -t $(USER_NAME)/mongodb_exporter .
push-mongodb_exporter:
	docker push $(USER_NAME)/mongodb_exporter

build-prometheus:
	cd monitoring/prometheus;docker build -t $(USER_NAME)/prometheus .
push-prometheus:
	docker push $(USER_NAME)/prometheus

build-alertmanager:
	cd monitoring/alertmanager;docker build -t $(USER_NAME)/alertmanager .
push-alertmanager:
	docker push $(USER_NAME)/alertmanager