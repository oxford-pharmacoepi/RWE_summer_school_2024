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
cdmName(cdm)

# How many people are in person table? ----
cdm$person %>% 
  tally()

# Get a count of the frequency of each concept id in  the condition occurrence table ----
cdm$condition_occurrence %>% 
  group_by(condition_concept_id) %>% 
  tally() 

# What is the concept name of the most frequent concept id? ----
cdm$concept %>% 
  filter(concept_id ==  321042) %>% 
  pull("concept_name")

# Find concepts that could represent myocardial infarction ----
myocardial_infarc_codes <- getCandidateCodes(cdm, 
                                             "myocardial infarction")

# Find concepts that could represent cardiac arrest ----
cardiac_arrest_codes <- getCandidateCodes(cdm, 
                                          "cardiac arrest")

# Create a codelist with two items, one for cardiac arrest and one for myocardial infarction ----
codelists <- list(
  "myocardial_infarction" = myocardial_infarc_codes$concept_id,
  "cardiac_arrest" = cardiac_arrest_codes$concept_id)

# Summarise the frequency of the codes in the codelist  ----
codelists_counts <- summariseCodeUse(codelists, cdm)
tableCodeUse(codelists_counts)

# Create a cohort table  ----
# two cohorts: myocardial infarction and cardiac arrest
cdm$heart <- conceptCohort(cdm, 
              conceptSet = codelists, 
              name = "heart")

# Keep only people aged 40 and 65 -----
cdm$heart <- cdm$heart %>% 
  requireAge(ageRange = list(c(40, 65)))

# Restrict to first event in history -----
cdm$heart <- cdm$heart %>% 
  requireIsFirstEntry()

# Create a plot of attrition for each cohort ----
cdm$heart %>% 
  summariseCohortAttrition() %>% 
  plotCohortAttrition(1)

cdm$heart %>% 
  summariseCohortAttrition() %>% 
  plotCohortAttrition(2)

# Create a plot showing cohort overlap -----
cdm$heart %>% 
  summariseCohortOverlap() %>% 
  plotCohortOverlap()

# Create a table of patient characteristics -----
cdm$heart %>% 
  summariseCharacteristics() %>% 
  tableCharacteristics()

# Create a table of patient characteristics stratified by sex -----
cdm$heart %>% 
  addSex() %>% 
  summariseCharacteristics(
    strata = "sex",
  ) %>% 
  tableCharacteristics(groupColumn = "sex")
