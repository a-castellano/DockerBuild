# Docker build


[![pipeline status](https://git.windmaker.net/a-castellano/DockerBuild/badges/master/pipeline.svg)](https://git.windmaker.net/a-castellano/DockerBuild/commits/master)[![coverage report](https://git.windmaker.net/a-castellano/DockerBuild/badges/master/coverage.svg)](https://git.windmaker.net/a-castellano/DockerBuild/commits/master)

An originary [Daedalus Project](https://github.com/daedalusproject) utility which allows users to create Docker images during CI/CD jobs.

This tool is curently used for creating all Docker images from [Limani](https://git.windmaker.net/a-castellano/limani) project. Images were only allowed to be uploaded to [Docker Hub](https://hub.docker.com/) but other registry URL's can be used.

## Usage

This tool uses environment variables in order to obtain registry name, credential, image names, etc.

The following environment variables must be set in order to make this tool work:

* **DOCKERREGISTRYUSER** - specifies registry user.
* **DOCKERREGISTRYPASSWORD** - specifies registry user password.
* **IMAGENAME** - specifies the name of the image that this toll is creating. 


The following optional environment variables cab be set:

* 
*
*


## Base images


