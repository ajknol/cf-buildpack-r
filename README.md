# Cloudfoundry R Shiny + Python Buildpack
Forked from https://github.com/beibeiyang/cf-buildpack-r. Cloud Foundry R 3.3.1 Shiny buildpack which allows for installation of OS libs (sometimes required for R packages) and Python packages. I was not able to pip install in the Python 2.x / 3.x already available in the buildpack (permissions), so therefore build Python from source again in the /app/vendor dir.

## Install
App directory should contain the following:
- a subdirectory "dashboard" containing Shiny code
- init.r file
- run.r file
- manifest.yml file
- Aptfile

## init.r
Which packages to install, e.g.:
```
#R packages
my_packages = c("shiny", "shinyjs", "DT", "dplyr", "stringr", "zoo", "scales", "keras", "abind", "PivotalR", "RPostgreSQL", "DBI")
install_if_missing = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p, Ncpus = 8, dependencies = TRUE)
  }
}
invisible(sapply(my_packages, install_if_missing))
rm(my_packages, install_if_missing)

#Python packages
my_packages <- c("h5py", "keras", "tensorflow")
print(Sys.getenv("LD_LIBRARY_PATH"))
Sys.setenv(LD_LIBRARY_PATH = paste0("/app/vendor/python3/lib:",Sys.getenv("LD_LIBRARY_PATH")))
print(Sys.getenv("LD_LIBRARY_PATH"))
for(pkg in my_packages) system(paste("/app/vendor/python3/bin/pip3 install",pkg))
rm(my_packages, pkg)

#device
options(device='cairo')
```

## run.r
Opens Shiny app as declared in manifest.yml, e.g.:

```
#set Python version
Sys.setenv(PATH = paste0("/app/vendor/python3/bin:",Sys.getenv("PATH")))
Sys.setenv(LD_LIBRARY_PATH = paste0("/app/vendor/python3/lib:",Sys.getenv("LD_LIBRARY_PATH")))
require(reticulate)
use_python("/app/vendor/python3/bin/python3", required = TRUE)
py_config()

#run
require(shiny)
port <- Sys.getenv('PORT')
shiny::runApp('dashboard', host = '0.0.0.0', port = as.numeric(port))
```

## manifest.yml
manifest for cf push, e.g.:

```
applications:
 - name: app_name
   buildpack: https://github.com/ajknol/cf-buildpack-r.git
   command: R --no-save --gui-none < /app/run.r
   instances: 1
   memory: 2G
   disk_quota: 5G
   env:
      CRAN_MIRROR: https://cran.rstudio.com
      CF_STAGING_TIMEOUT: 20
      CF_STARTUP_TIMEOUT: 5
```

## Aptfile
Place Aptfile in root dir with required OS libs on each line, e.g.:

```
r-cran-slam
libyaml-dev
```

## Cloudfoundry push
Push app to cloudfoundry using CLI. 

In terminal, cd into the root folder of your app directory.

In terminal, login to Cloudfoundry:

```
cf login
```

In terminal, push app:

```
cf push <shiny_app_name>
```

https://pivotalsoftware.github.io/gp-r/#shiny_cf
