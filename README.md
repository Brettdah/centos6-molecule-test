# CentOS 6

## Important Notice

> /!\ CENTOS 6 reached it's END OF LIFE don't use that in prod it's for service continuity until migration
> This image is based on my Centos-patched (with glibC and glibc-common patched to avoid segfault on recent kernel or WSL)

## How to use

This image is build on Docker Hub automatically any time the upstream OS container is rebuilt, and any time a commit is made or merged to the master branch. But if you need to build the image on your own locally, do the following:

1. Install [Docker](https://docs.docker.com/engine/installation/)
2. Clone this [repository](https://github.com/Brettdah/centos6-molecule-test.git) :

    ```bash
    git clone https://github.com/Brettdah/centos6-molecule-test.git
    ```

3. Cd into the directory the default is : centos6-molecule-test
4. Run docker build

    ```bash
    build -t <name the image> .
    ```

## What am I using it for

As the project name may give you a hint I'm using this image to test my roles during their dev.
Or their maintainance if I'm taking someone else role so first thing first !

### How am I using it

I'm planing to write a wiki page to explain more in details but if you already have molecule set up and ready to use here is what you will need to change :

In the role you are testing setup a few things
> Edit <role_dir>/molecule/default/molecule.yml
> Add In the provisoner section

```yaml
  log: true
```

Now should be like that ::

```yaml
provisioner:
  name: ansible
  log: true
```

Now to the next part the image there is 2 ways to do it

#### In a dynamical way

In the platforme section
Change the image by the one you want to use
In the exemple I will use a variable to be able to change with another one of mine
And I will default on this one

```yaml
  image: "${brettdah/${MOLECULE_DISTRO:-centos6}-molecule-test:latest}"
```

If you want to use other images than mine you can add this line

```yaml
  image: "${MOLECULE_IMAGE:-brettdah/centos6-molecule-test:latest}"
```

You will need to enter the full path of the image you want to use

you should add those too, to be able to use systemd inside the container.

```yaml
  volumes:
    - /sys/fs/cgroup:/sys/fs/cgroup:ro
  privileged: True
```

In WSL to be able to use systemd inside the container I'm using a simple workaround :

```bash
  sudo mkdir /sys/fs/cgroup/systemd
  sudo mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd
```

Now if you did not want to use this container and choose some other one of mine :
This command will let you use this image instead of the one in default

```bash
MOLECULE_DISTRO=centos6 molecule test
```

if you chose to enter the full name of the image to switch with other images than mine :

```bash
MOLECULE_DISTRO=brettdah/centos6-molecule-test molecule test
```

#### In a statical way

By putting blocs of images after the "platforms" keyword molecule will execute them in one command test

```yaml
platforms:
  - name: instance-centos6
    image: "brettdah/centos6-for-molecule-test:latest"
    command: ${MOLECULE_DOCKER_COMMAND:-""}
    privileged: True
    pre_build_image: True
  - name: instance-centos7
    image: "brettdah/centos7-for-molecule-test:latest"
    command: ${MOLECULE_DOCKER_COMMAND:-""}
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    privileged: True
    pre_build_image: True
  - name: instance-debian9
    image: "brettdah/debian9-for-molecule-test:latest"
    command: ${MOLECULE_DOCKER_COMMAND:-""}
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    privileged: True
    pre_build_image: True
  - name: instance-debian10
    image: "brettdah/debian10-for-molecule-test:latest"
    command: ${MOLECULE_DOCKER_COMMAND:-""}
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    privileged: True
    pre_build_image: True
```

So to execute just type

```bash
molecule test
```
