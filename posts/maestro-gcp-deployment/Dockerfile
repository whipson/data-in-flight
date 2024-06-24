FROM rocker/r-ver
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libsodium-dev \
    zlib1g-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*
RUN R -e 'install.packages("remotes")'
RUN R -e 'remotes::install_version("renv", version = "1.0.7")'
WORKDIR /usr/src/app
COPY . .
RUN R -e 'renv::restore()'
ENTRYPOINT ["Rscript", "orchestrator.R"]
