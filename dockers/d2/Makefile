help:
	@cat Makefile

IMAGE=cyyang/detectron2
DOCKER_FILE=Dockerfile
GPU?=1
#DOCKER=GPU=$(GPU) nvidia-docker
DOCKER=docker
#APP=/home/tsaiid/git/femh-dicom
DATA=$${HOME}/work
NAME=d2

build:
	docker build -t $(IMAGE) -f $(DOCKER_FILE) .

all:
	$(DOCKER) run --gpus all --ipc=host -it -d --name $(NAME) \
	  -u $$(id -u):$$(id -g) -e HOME=$${HOME} -e USER=$${USER} -v $${HOME}:$${HOME} $(IMAGE)

bash: 
	$(DOCKER) exec -it $(NAME) bash
