# RealWorldEvidenceSummerSchool2024


## Issues

if you have any issue setting your environment please contact: 
- Edward Burn: edward.burn@ndorms.ox.ac.uk
- Marti Catala: marti.catalasabate@ndorms.ox.ac.uk

## Setup your laptop

Follow this instructions to setup your environment:
### Install R
-	https://cran.r-project.org/bin/windows/base/ (at least version 4.2)
### Install RStudio
-	https://posit.co/download/rstudio-desktop/
### Install Rtools
-	https://cran.r-project.org/bin/windows/Rtools/
### Install Java 
- https://www.ohdsi.org/web/wiki/doku.php?id=documentation:r_setup

After this steps open RStudio. Download the Setup folder locally in your laptop. Open the project: `Setup.Rproj`

You can open the project double clicking to the file, to check that you have opened correctly the project you must see the following:
![setup](https://user-images.githubusercontent.com/18575244/235122166-a860c2c8-1441-4c7e-b6d2-de47db32e5b1.png)

The following packages should be easily installed from the command line just typing: `install.packages("PackageName")`

- DBI
- CDMConnector
- duckdb
- IncidencePrevalence
- PatientProfiles
- here
- usethis
- SqlRender
- remotes

Install other packages from github. To install them type: `remotes::install_github("PackageName")`

- OHDSI/CirceR

### Download Eunomia
For the practicals we will work with a mock simple database. To download it run the following command:
```r
CDMConnector::downloadEunomiaData(
  pathToData = here::here(), 
  overwrite = TRUE
)
```
Set the environment so you can read the database, open the `.Renviron` file:
```r
usethis::edit_r_environ()
```
Write there the path to Eunomia. Note that you cna put the zip file wherever is more convenient for you. Change `"......"` for the full path to the eunomia zip file:
```
# EUNOMIA_DATA_FOLDER = "......"
```

## Check the setup

If you have done all the previous steps you should be able to run the script `CodeToRun.R`.

