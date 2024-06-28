# Install necessary R packages
if (!requireNamespace("cito", quietly = TRUE)) {
  install.packages("cito")
}

if (!requireNamespace("reticulate", quietly = TRUE)) {
  install.packages("reticulate")
}

# Load the packages
library(cito)
library(reticulate)



# Load the dataset (assuming your data is in a CSV file)
data <- readRDS("../data/AllPredictors.rds")
data <- readRDS("data/AllPredictors.rds")

# Inspect the first few rows of the data
head(data)

# Split the data into predictors and response variable
predictors <- data[, -which(names(data) == "Jaccard")]
response <- data$Jaccard


# Normalize the predictor variables
normalize <- function(x) {
  if (is.numeric(x)) {
    return ((x - min(x)) / (max(x) - min(x)))
  } else {
    return (x)
  }
}

predictors <- as.data.frame(lapply(predictors, normalize))






library(reticulate)

# create a new environment 
virtualenv_create("r-reticulate")

# install SciPy
virtualenv_install("r-reticulate", "keras")

# import SciPy (it will be automatically discovered in "r-reticulate")
keras <- reticulate::import("keras")

## Building the NN
# Import necessary Python libraries
keras <- reticulate::import("keras")
np <- reticulate::import("numpy")

# Define the model
model <- keras$Sequential()

# Add layers to the model
model$add(keras$layers$Dense(units = 64, activation = 'relu', input_shape = c(ncol(predictors))))
model$add(keras$layers$Dense(units = 32, activation = 'relu'))
model$add(keras$layers$Dense(units = 1, activation = 'sigmoid'))

# Compile the model
model$compile(optimizer = 'adam', loss = 'mean_squared_error', metrics = c('mean_absolute_error'))
