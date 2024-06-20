# load packages ------
library(DBI)
library(here) 
library(duckdb) 
library(dplyr)
library(omopgenerics)
library(CDMConnector)
library(OmopSketch)
library(PatientProfiles)
library(CohortConstructor)
library(CohortCharacteristics)
library(CodelistGenerator)
library(IncidencePrevalence)

# connect to the heart database ----
Sys.setenv("EUNOMIA_DATA_FOLDER" = here("eunomia"))
# CDMConnector::downloadEunomiaData("synthea-heart-10k")
con <- DBI::dbConnect(duckdb::duckdb(dbdir = eunomia_dir(
  dataset_name = "synthea-heart-10k")))

# create a cdm reference ----
cdm <- cdm_from_con(con = con, 
                    cdm_schema = "main", 
                    write_schema = "main")

# what is the name of the cdm? ----

# How many people are in person table? ----

# Get a count of the frequency of each concept id in  the condition occurrence table ----

# What is the concept name of the most frequent concept id? ----

# Find concepts that could represent myocardial infarction ----

# Find concepts that could represent cardiac arrest ----

# Create a codelist with two items, one for cardiac arrest and one for myocardial infarction ----

# Summarise the frequency of the codes in the codelist  ----

# Create a cohort table  ----
# two cohorts: myocardial infarction and cardiac arrest

# Keep only people aged 40 and 65 -----

# Restrict to first event in history -----

# Create a plot of attrition for each cohort ----

# Create a plot showing cohort overlap -----

# Create a table of patient characteristics -----

# Create a table of patient characteristics stratified by sex -----
