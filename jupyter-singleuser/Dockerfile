# Dockerfile for running a single user jupyter server
FROM unidata/ubuntu-dev

MAINTAINER Ryan May <rmay@ucar.edu>

# fetch juptyerhub-singleuser entrypoint
ADD https://raw.githubusercontent.com/jupyter/jupyterhub/master/jupyterhub/singleuser.py /usr/local/bin/jupyterhub-singleuser
RUN chmod 755 /usr/local/bin/jupyterhub-singleuser
ADD singleuser.sh setup_kernel.sh /srv/singleuser/

# jupyter is our user -- set uid/gid to match base data image
RUN groupadd -g 1001 jupyter && useradd -u 1001 -g jupyter -m -s /bin/bash -d /home/jupyter jupyter
USER jupyter
ENV HOME=/home/jupyter SHELL=/bin/bash USER=jupyter PATH=/home/jupyter/conda/bin:$PATH
WORKDIR $HOME

# Install conda
RUN curl https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh > conda.sh && \
  /bin/bash conda.sh -bfp $HOME/conda && rm conda.sh

# Update conda and add channels
RUN conda update --yes --quiet conda && conda config --add channels https://conda.binstar.org/scitools --add channels https://conda.binstar.org/Unidata

# Create Python 3 environment
RUN conda create -n py3 --yes --quiet python=3 ipython-notebook numpy netcdf4 ipywidgets\
 matplotlib cartopy OWSLib siphon MetPy xray networkx && \
 bash /srv/singleuser/setup_kernel.sh py3

# Create Python 2 environment
RUN conda create -n py2 --yes --quiet python=2 ipython-notebook numpy netcdf4 ipywidgets\
  matplotlib cartopy OWSLib siphon MetPy xray networkx && \
  bash /srv/singleuser/setup_kernel.sh py2

VOLUME /notebooks
WORKDIR /notebooks
EXPOSE 8888

ENTRYPOINT ["/bin/bash", "/srv/singleuser/singleuser.sh"]
