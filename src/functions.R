# Functions for Machine Learning Assignment #

# Install Packages function ============
install_and_load <- function(package_list) {
  for (pkg in package_list) {
    if (!require(pkg, character.only = TRUE)) {
      if (!is.element(pkg, installed.packages()[, "Package"])) {
        install.packages(pkg, dependencies = TRUE)
      }
      suppressPackageStartupMessages(library(pkg, character.only = TRUE))
    }
  }
}


# Pre-process the raw predictor data
process_data <- function(file_path, tp_value, response, vars) {
  dat <- readRDS(file_path) %>%
    # filter for highest resolution and specified time period
    filter(cell_grouping == 1 & exclude == 0 & tp == tp_value) %>%
    # select necessary columns
    select(all_of(c(response, vars))) %>%
    # Fixing NAs
    mutate(
      D_AOO_a = case_when(
        is.na(D_AOO_a) & rel_occ_Ncells > 0.97 ~ 2,
        TRUE ~ D_AOO_a
      ),
      mean_prob_cooccur = case_when(
        is.na(mean_prob_cooccur) & rel_occ_Ncells < 0.05 ~ 0,
        TRUE ~ mean_prob_cooccur
      )
    ) %>%
    # Delete those species occupying 100% of area (Moran's I = NA)
    filter(!is.na(moran)) %>%
    # Transform all characters to factors for modeling
    mutate_if(is.character, as.factor)

  # Convert specific columns to factors if needed
  dat$Habitat.Density <- as.factor(dat$Habitat.Density)
  dat$Migration <- as.factor(dat$Migration)

  return(dat)
}



# NA summarise
summarize_NA <- function(dat) {
result <- dat %>%
  summarise(across(everything(), ~ sum(is.na(.)))) %>%
  tidyr::pivot_longer(cols = everything(), names_to = "Variable", values_to = "NA_Count")

# Print the table using kable
kable(result)
}


