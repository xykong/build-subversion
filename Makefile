build:
	docker build -t subversion .

Ubuntu:
	docker build -t subversion:ubuntu .

CentOS:
	docker build -t subversion:centos -f CentOS.Dockerfile .
