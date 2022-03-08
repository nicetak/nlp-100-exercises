FROM rocker/tidyverse

RUN apt update && apt install -y openssh-client

# R Packages
RUN R -e "install.packages(c('languageserver', 'renv'))"

WORKDIR ~/work
COPY renv.lock renv.lock
RUN R -e "renv::restore()"