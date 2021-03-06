# Base image https://hub.docker.com/u/rocker/
FROM rocker/shiny:latest

# system libraries of general use
## install debian packages
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libxml2-dev \
    libcairo2-dev \ 
    libsqlite3-dev \
    libpq-dev \
    libssh2-1-dev \
    unixodbc-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libmariadb-dev

## update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

# copy necessary files
## app folder
COPY /app ./srv/shiny-server/endless
## renv.lock file
COPY /renv.lock ./srv/shiny-server/endless

WORKDIR ./srv/shiny-server/endless

# install renv & restore packages
RUN Rscript -e 'install.packages("renv")'
RUN Rscript -e 'install.packages("R6", dependencies=TRUE, repos="http://cran.rstudio.com/")'
RUN Rscript -e 'install.packages("shinyanimate", dependencies=TRUE, repos="http://cran.rstudio.com/")'
RUN Rscript -e 'install.packages("vov", dependencies=TRUE, repos="http://cran.rstudio.com/")'
RUN Rscript -e 'renv::consent(provided = TRUE)'
RUN Rscript -e 'renv::restore()'


USER shiny

EXPOSE 3838

CMD ["/usr/bin/shiny-server"]