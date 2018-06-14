# Cloudfoundry R Shiny + Python Buildpack
Forked from https://github.com/beibeiyang/cf-buildpack-r. Cloud Foundry R 3.3.1 Shiny buildpack which allows for installation of OS libs (sometimes required for R packages) and Python packages.

## Install
App directory should contain the following:
- a subdirectory "dashboard" containing Shiny code
- init.r file
- run.r file
- manifest.yml file
- Aptfile
- Pipfile.r

## init.r
Include which packages to install, e.g.:
```
my_packages = c("shiny", "DT", "dplyr", "stringr", "zoo", "scales", "reticulate", "keras", "abind")
install_if_missing = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p, Ncpus = 8, dependencies = TRUE)
  }
}
invisible(sapply(my_packages, install_if_missing))
```

## run.r
Opens Shiny app, e.g.:

```
#set Python version
Sys.setenv(PATH = paste0("/app/vendor/python3/bin:",Sys.getenv("LD_LIBRARY_PATH")))
Sys.setenv(LD_LIBRARY_PATH = paste0("/app/vendor/python3/lib:",Sys.getenv("LD_LIBRARY_PATH")))
require(reticulate)
use_python("/app/vendor/python3/bin/python3", required = TRUE)
py_config()

#run
require(shiny)
options(device='cairo')
port <- Sys.getenv('PORT')
print(port)
shiny::runApp('dashboard',host = '0.0.0.0', port = as.numeric(port))
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
Push app to cloudfoundry. 
In terminal, cd into the root folder of your app directory
In terminal, login to Cloudfoundry:

```
cf login
```

In terminal, push app, .e.g.:

```
cf push <shiny_app_name>
```

https://pivotalsoftware.github.io/gp-r/#shiny_cf
