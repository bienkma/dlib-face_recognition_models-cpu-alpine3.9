FROM frolvlad/alpine-glibc:alpine-3.9

ENV CONDA_DIR="/opt/conda"
ENV PATH="$CONDA_DIR/bin:$PATH"

# Install conda
RUN CONDA_VERSION="4.5.4" && \
    apk add --no-cache --virtual=.build-dependencies wget ca-certificates bash && \
    \
    mkdir -p "$CONDA_DIR" && \
    wget "http://repo.continuum.io/miniconda/Miniconda2-${CONDA_VERSION}-Linux-x86_64.sh" -O miniconda.sh && \
    bash miniconda.sh -f -b -p "$CONDA_DIR" && \
    echo "export PATH=$CONDA_DIR/bin:\$PATH" > /etc/profile.d/conda.sh && \
    rm miniconda.sh && \
    \
    conda update --all --yes && \
    conda config --set auto_update_conda False && \
    rm -r "$CONDA_DIR/pkgs/" && \
    \
    apk del --purge .build-dependencies && \
    \
    mkdir -p "$CONDA_DIR/locks" && \
    chmod 777 "$CONDA_DIR/locks"

ENV TZ=Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apk add --no-cache -U --virtual=build-dependencies ca-certificates tzdata git cmake gcc make g++ python python-dev jpeg-dev openjpeg-dev openssl-dev zlib-dev freetype jpeg libjpeg openjpeg zlib libxml2-dev libxslt-dev build-base

RUN rm -rf /var/cache/apk/*
RUN conda install -y numpy scikit-learn matplotlib scipy pillow pandas

RUN conda install -y -c menpo dlib
RUN conda install -y -c akode face_recognition_models
RUN conda install -y opencv
RUN rm -rf /conda/pkgs
WORKDIR $CONDA_DIR
