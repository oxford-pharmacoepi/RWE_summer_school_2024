# Pakcages
library(CDMConnector)
library(CodelistGenerator)
library(CohortConstructor)
library(CohortCharacteristics)
library(dplyr)

# Connexion
con <- DBI::dbConnect(duckdb::duckdb(),
                      dbdir = eunomia_dir())

# CDM object
cdm <- cdm_from_con(con, cdm_schema = "main",
                    write_schema = c(prefix = "my_study_", schema = "main"))

# Concept based ----
## concept list
drug_codes <- getDrugIngredientCodes(cdm,
                                     name = c("diclofenac", "acetaminophen"))
## cohort
cdm$medications <- conceptCohort(cdm = cdm,
                                 conceptSet = drug_codes,
                                 name = "medications")

# Cohort manipulation ----
## strata
cdm$medication_strata <- cdm$medications |>
  PatientProfiles::addDemographics(ageGroup = list(c(0, 50), c(51, 150))) |>
  stratifyCohorts(
    strata = list("sex", "age_group", c("sex", "age_group")),
    cohortId = 1,
    removeStrata = TRUE,
    name = "medication_strata"
  )

## match
cdm$diclofenac_match <- cdm$medications %>%
  matchCohorts(
    cohortId = 1,
    matchSex = TRUE,
    matchYearOfBirth = TRUE,
    ratio = 5,
    name = "diclofenac_match"
  )

## year
cdm$medication_year <- cdm$medications |>
  PatientProfiles::addDemographics(ageGroup = list(c(0, 50), c(51, 150))) |>
  yearCohorts(
    years = 2000:2003,
    cohortId = NULL,
    name = "medication_year"
  )




