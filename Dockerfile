FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu16.04
ARG PYTHON_VERSION=3.7
RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         cmake \
         git \
         curl \
         ca-certificates \
         libjpeg-dev \
         libpng-dev && \
     rm -rf /var/lib/apt/lists/*


RUN curl -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh  && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh && \
     /opt/conda/bin/conda install -y python=$PYTHON_VERSION numpy pyyaml scipy ipython mkl mkl-include ninja cython typing && \
     /opt/conda/bin/conda install -y pytorch torchvision cudatoolkit=10.0 -c pytorch && \
     #install non-pytorch stuff below
     /opt/conda/bin/conda install -y -c conda-forge python=$PYTHON_VERSION dask pytables seaborn numba numexpr python-blosc bcolz && \
     /opt/conda/bin/conda clean -ya
ENV PATH /opt/conda/bin:$PATH
# This must be done before pip so that requirements.txt is available
#WORKDIR /opt/pytorch
#COPY . .

#RUN git submodule update --init --recursive
#RUN TORCH_CUDA_ARCH_LIST="3.5 5.2 6.0 6.1 7.0+PTX" TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
#    CMAKE_PREFIX_PATH="$(dirname $(which conda))/../" \
#    pip install -v .

# Add stuff we need to install with pip below
RUN pip install pybloomfiltermmap3 dynpy cana

# Install Torchnet, a high-level framework for PyTorch
RUN pip install torchnet==0.0.4

# Install Requests, a Python library for making HTTP requests
RUN conda install -y requests \
 && conda clean -ya

# Install Graphviz
RUN conda install -y graphviz \
 && conda clean -ya

RUN apt-get autoremove -y

WORKDIR /workspace
RUN chmod -R a+w .
