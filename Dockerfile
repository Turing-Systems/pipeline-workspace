FROM nvidia/cuda:10.2-cudnn8-devel

ENV APP_HOME /
WORKDIR $APP_HOME

RUN apt-get update
RUN apt-get install --yes git curl build-essential wget

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

RUN conda update conda

# FIX: diffvg requires 3.7 instead of the system's default 3.9
RUN conda install python=3.7

RUN conda install -y cudatoolkit=10.2 -c nvidia
RUN conda install -y pytorch torchvision torchaudio -c pytorch -c nvidia
RUN conda install -y pytorch-lightning -c conda-forge

# COPY requirements.txt ./
# RUN pip install --no-cache-dir -r ./requirements.txt

RUN git clone https://github.com/openai/CLIP
RUN git clone https://github.com/CompVis/taming-transformers.git
RUN git clone https://github.com/BachiLi/diffvg

# Compile diffvg
# ENV DPYTHON3_LIBRARY /root/miniconda3/lib/

# /root/miniconda3/lib/python3.9/

WORKDIR diffvg

RUN git submodule update --init --recursive

RUN conda install -y pytorch torchvision -c pytorch
RUN conda install -y numpy
RUN conda install -y scikit-image
RUN conda install -y -c anaconda cmake
RUN conda install -y -c conda-forge ffmpeg
RUN conda install -y -c conda-forge poetry


RUN pip install svgwrite
RUN pip install svgpathtools
RUN pip install cssutils
RUN pip install numba
RUN pip install torch-tools
RUN pip install visdom

RUN poetry install

RUN poetry run python setup.py install

#RUN python setup.py install

# RUN git submodule update --init --recursive
# RUN conda install -y numpy
# RUN conda install -y scikit-image
# RUN conda install -y -c anaconda cmake
# RUN conda install -y -c conda-forge ffmpeg
# RUN export DIFFVG_CUDA=1; python setup.py install

WORKDIR ..


# Clone clipit last, since it's the second most-likely to change
RUN git clone https://github.com/dribnet/clipit

RUN conda install -y -c conda-forge jupyterlab

# Copy local code to container image
# COPY *.py ./
# CMD ["python3", "pixeldraw.py"]
