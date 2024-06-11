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

# Restrictions ----
cdm$medications <- cdm$medications %>%
  requireIsFirstEntry(
    cohortId = NULL,
    indexDate = "cohort_start_date",
    name = tableName(cohort)
  ) %>%
  requireDemographics(
    ageRange = list(c(18, 85)),
    sex = "Female",
    minPriorObservation = 30,
    minFutureObservation = 0,
    requirementInteractions = TRUE,
    name = tableName(cohort)
  )


cdm$medications_no_gi_bleed <- cdm$medications %>%
  requireConceptIntersectFlag(conceptSet = list("gi_bleed" = 192671),
                              indexDate = "cohort_start_date",
                              window = c(-Inf, 0),
                              negate = TRUE,
                              name = "medications_no_gi_bleed")
