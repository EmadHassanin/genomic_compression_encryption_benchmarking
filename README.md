This is a README describes this repository, which contains any code related to 
testing and benchmarking BAM file compression, using various technologies. 

# Structure
Below is the directory structure and the content of the folder:

```
Access
|____wrappers
|____envs
|____docker
|____cloud_services
|____CHANGELOG.md
|____README.md
|____workflow
|____rules
| |____BAM
| |____CRAM
|____.gitlab-ci.yaml
|____conf
|____reports
|____src
```
**Figure 1**: Directory structure of the repository.

# Content

**Table 1**: Content of the different folders (Fig. 1).

| Folder | Content |
| ------ | ------ |
| wrappers | wrapper scripts to launch docker containers |
| docker | Dockerfiles building Docker images | 
| envs | `.yaml` files conda environments | 
| cloud_services | launcher scripts for cloud services |
| workflow | Snakemake workflow files |
| rules | Snakemake rules, furter separated into different functionalities |
| conf | Snakemake `.json` conf files |
| reports | Snakemake benchmark reports | 
| src | ad-hoc/custom scripts |

In the future, this repository can be used to create dedicated forks for 
processes that may become more complex, e.g. "Concordance" can be spun out as a 
separate repo, in the future.

# Dependencies

Below are the dependencies required:
1. Linux/Unix- like environment
2. git installation
3. python3
4. conda (python package)
5. docker (optional, if using conda directly)

## Clone git repository

One would need to clone the entire Access gitlab directory in order to execute 
this workflow.

Via https:
```
git clone https://gitlab.com/Narayanasamy_1985/Access.git
```
**or**
Via ssh:
```
git clone git@gitlab.com:megeno_development/Access.git <dir_name>
```
Replace `<dir_name>` with your own directory name.

If you already have a git directory named "Access", then use:
```

```

Go into the relevant directory:
```
cd <your local directory>/Access
```
NOTE: Always work on the `dev` branch or other feature branches when developing.
Change to dev branch (master has to be cleaned up)
```
git checkout dev
```

## Own environment
Install all the necessary tools.
1. Python 3
2. conda, anaconda
3. other tools (TBD)

Once you have `conda`, you can simply use the `.yaml` files in the `docker` 
folder and run:
```
conda update -n base -c defaults conda
conda env create --file envs/requirements.yaml --prefix <your favourite install path>
```
You should have all the necessary files required. Now, load the environment and start running:
```
source activate py36
```



**NOTE**: For now, we decided to use only `python 3`. 

## Docker
If you do not want to install these tools in a `conda` virtual environment, then
you can run a docker container to test it. You can either build the `docker`
container yourself or pull an existing one from the Dockerhub`

### Building your own.
If you wish to build your own container to test some specific programs. First go
to the `docker` folder and build the container. Run the command(s) below:
```
cd docker

docker build -f <location of the docker file>/Dockerfile . -t megeno/compression:latest
```
Name the <version> as you like. This should be formalized in the future.

Now, you are free to run your docker image. Named `latest` here.
```
$ docker run --privileged -v /home/emad/.config/rclone/rclone.conf:/root/.rclone.conf -v /home/emad/projects/compression/:/code/ -v /work/compression_tests:/home/Archive/Compression -v /work/data/:/home/Archive/Data/ -v /work/analysis/ -v /work/references/:/references/ --rm -it megeno/compression
```

### Pull from DockerHub
To be updated

## Snakemake
Once you have your environment setup, you can now run the pipeline.
```
snakemake -pks workflow/master.workflow --configfile config/oci_config Compression/checkpoints/all.done
```

**NOTE**: Please ignore the parts below for now. I will spin it out to a different
document.

# Transfer tests
This workflow is used to test and benchmark the upload transfer times.

## Use the handy-dandy wrapper script
Example:
```
wrappers/run.sh
```

## Docker and a handy-dandy wrapper script
Example:
```
$ docker run --privileged -v /home/emad/.config/rclone/rclone.conf:/root/.rclone.conf -v /home/emad/projects/compression/:/code/ -v /work/compression_tests:/home/Archive/Compression -v /work/data/:/home/Archive/Data/ -v /work/analysis/ -v /work/references/:/references/ --rm -it megeno/compression <wrapper.sh>
```

## Virtual environment python

Steps are being documented https://docs.google.com/document/d/1u6UHIJ3CSVKpkaeRxlcFkrlgP79B7aL9vMpeV8XfoIk/edit#
```
conda activate compression
```

## Dry run for everything
```
snakemake -npks workflow/master.workflow --configfile config/oci_config Compression/checkpoints/all.done
```

## Dry run for only cram
```
snakemake -npks workflow/master.workflow --configfile config/oci_config Compression/checkpoints/cram.done
```

## End virtual environment
```
conda deactivate
```

