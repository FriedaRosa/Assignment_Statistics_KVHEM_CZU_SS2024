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
