FROM ubuntu:18.04

#Install compilers, mpi, etc for petsc
RUN apt-get update && apt-get install -y \
    git \
    python\
    build-essential\
    gfortran \
    valgrind \
    libopenmpi-dev \
    libblas-dev \
    liblapack-dev \
&& rm -rf /var/lib/apt/lists/*

#install petsc
RUN cd /home && git clone -b maint https://bitbucket.org/petsc/petsc 
WORKDIR /home/petsc
RUN ./configure PETSC_ARCH=linux-c-complex --download-scalapack --download-mumps --with-scalar-type=complex \
&&  make PETSC_DIR=/home/petsc PETSC_ARCH=linux-c-complex all

#install slepc
WORKDIR /home/ 
RUN apt-get update && apt-get install -y wget \
&&  wget http://slepc.upv.es/download/distrib/slepc-3.10.1.tar.gz \
&& tar zxvf slepc-3.10.1.tar.gz \
&& rm -r slepc-3.10.1.tar.gz 
WORKDIR /home/slepc-3.10.1
ENV PETSC_DIR=/home/petsc
ENV SLEPC_DIR=/home/slepc-3.10.1
ENV PETSC_ARCH=linux-c-complex
RUN ./configure \ 
&& make all
CMD ["/bin/bash"]
