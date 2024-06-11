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

# Demographic based ----
cdm$age_cohort <- demographicsCohort(cdm = cdm,
                                     ageRange = c(18, 65),
                                     sex = NULL,
                                     minPriorObservation = NULL,
                                     minFutureObservation = NULL,
                                     name = "age_cohort")

# Concept based ----
## concept list
drug_codes <- getDrugIngredientCodes(cdm,
                                     name = c("diclofenac", "acetaminophen"))
## cohort
cdm$medications <- conceptCohort(cdm = cdm,
                                 conceptSet = drug_codes,
                                 name = "medications")

## from measurements
codelist <- list("oral_temperature_measurement" = 3006322)

cdm$temperature <- measurementCohort(
  cdm = cdm,
  conceptSet = codelist,
  name = "temperature",
  valueAsNumber = list("586323" = c(39, 45)) # high fever in celsius
)
