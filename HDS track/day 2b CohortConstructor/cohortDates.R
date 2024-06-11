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

# Cohort dates ----
cdm$medications_end <- cdm$medications %>%
  exitAtObservationEnd(cohortId = NULL, name = "medications_end")

cdm$medications_first <- cdm$medications |>
  PatientProfiles::addDemographics(futureObservationType = "date") %>%
  mutate(cohort_end_date_100 = as.Date(!!dateadd("cohort_start_date", 100))) |>
  exitAtFirstDate(
    dateColumns = c("future_observation", "cohort_end_date_100"),
    cohortId = NULL,
    returnReason = TRUE,
    name = "medications_first"
  )
