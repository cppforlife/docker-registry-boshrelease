# Docker-registry-boshrelease

Bosh release for provisioning private docker registry image offline. 
It was created based on the following [blogpost](https://blog.starkandwayne.com/2015/04/28/embed-docker-into-bosh-releases/) and generated with the bosh-gen tool. 

## Prerequisites

  - [Running Docker boshrelease](https://github.com/cf-platform-eng/docker-boshrelease#usage)

## Usage

- Provision docker-registry-boshrelease

  ```
    git clone http://github.com/compozed/docker-registry-boshrelease.git && cd docker-registry-boshrelease
    bosh create release --force
    bosh upload release 
  ```

- Collocate docker-registry-boshrelease with docker deployment

  Edit releases in docker deployment manifest to provision docker-registry. See example: 
  
  ```
  releases:
  - name: docker
    version: 15
  - name: docker-registry
    version: latest
  ```

  Collocate distribution_registry_image template in docker job (daemon). See example:

  ```
  jobs:
  ...
  - name: docker
    templates:
    - name: distribution_registry_image
      release: docker-registry
    - name: docker
      release: docker
    - name: containers
      release: docker
  ```

- Running docker registry container 

  Edit properties in docker deployment manifest to run a private registry container. See example: 

  ```
  properties:
    containers:
    - name: registry
      image: "distribution/registry"
      bind_ports:
        - "5000:5000"
      bind_volumes:
        - "/var/lib/registry"
    docker:
      insecure_registries:
      - '<DOCKER_VM_IP>:5000'
  ```


## Push images to private docker registry

__Prerequisites:__

Running docker deamon that can:

- Pull images from hub.docker.com.
- Push to the running private registry (Daemon running with option: `--insecure-registry <DOCKER_VM_IP>:5000`)

__Steps:__

- Pull Docker image 

```
docker pull <IMAGE_NAME>
```

- Tag the docker image to point to the registry

```
docker tag <IMAGE_NAME> <DOCKER_VM_IP>:5000/<IMAGE_NAME>
```

- Push the image to the registry

```
docker push <DOCKER_VM_IP>:5000/<IMAGE_NAME>
```


