# Consider a library as the location where packages are stored.
# Execute the following command to list all the libraries available in your
# computer:
.libPaths()

# One of the libraries should be a folder inside the project if you are using
# renv

# Then execute the following command to see which packages are available in
# each library:
lapply(.libPaths(), list.files)



if (require("languageserver")) {
  require("languageserver")
} else {
  install.packages("languageserver", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

# STEP 1. Install and Load the Required Packages ----
## mlbench ----
if (require("mlbench")) {
  require("mlbench")
} else {
  install.packages("mlbench", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## readr ----
if (require("readr")) {
  require("readr")
} else {
  install.packages("readr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## caret ----
if (require("caret")) {
  require("caret")
} else {
  install.packages("caret", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## e1071 ----
if (require("e1071")) {
  require("e1071")
} else {
  install.packages("e1071", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## factoextra ----
if (require("factoextra")) {
  require("factoextra")
} else {
  install.packages("factoextra", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## FactoMineR ----
if (require("FactoMineR")) {
  require("FactoMineR")
} else {
  install.packages("FactoMineR", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## STEP 2. Load the Dataset ----
library(readr)
StudentPerformanceDataset <- read_csv("/home/ki3ani/BBT4206-R-Lab4of15-DataTransforms-lumin/data/perfomance-dataset.csv")

## STEP 3. Apply a Scale Data Transform ----
# Load the caret package if not already loaded
if (!requireNamespace("caret", quietly = TRUE)) {
  install.packages("caret")
}
library(caret)

# BEFORE
summary(StudentPerformanceDataset)

# Create histograms for specific columns
hist(StudentPerformanceDataset$study_time, main = "Histogram for study_time")
hist(StudentPerformanceDataset$repeats_since_Y1, main = "Histogram for repeats_since_Y1")
hist(StudentPerformanceDataset$night_out, main = "Histogram for night_out")
hist(StudentPerformanceDataset$family_relationships, main = "Histogram for family_relationships")

# Apply the scale transform
model_of_the_transform <- preProcess(StudentPerformanceDataset[c("study_time", "repeats_since_Y1", "night_out", "family_relationships")], method = c("scale"))
print(model_of_the_transform)
student_performance_scale_transform <- predict(model_of_the_transform, StudentPerformanceDataset[c("study_time", "repeats_since_Y1", "night_out", "family_relationships")])

# AFTER
summary(student_performance_scale_transform)

# Create histograms for specific columns after scaling
hist(student_performance_scale_transform$study_time, main = "Histogram for Scaled study_time")
hist(student_performance_scale_transform$repeats_since_Y1, main = "Histogram for Scaled repeats_since_Y1")
hist(student_performance_scale_transform$night_out, main = "Histogram for Scaled night_out")
hist(student_performance_scale_transform$family_relationships, main = "Histogram for Scaled family_relationships")

# Center Data Transform ----

## STEP 4. Apply a Centre Data Transform ----
# Load the caret package if not already loaded
if (!requireNamespace("caret", quietly = TRUE)) {
  install.packages("caret")
}
library(caret)

# BEFORE
summary(student_performance_scale_transform)

# Apply the center transform
model_of_the_transform_center <- preProcess(student_performance_scale_transform, method = c("center"))
student_performance_center_transform <- predict(model_of_the_transform_center, student_performance_scale_transform)

# AFTER
summary(student_performance_center_transform)

# STEP 5. Apply a Standardize Data Transform
### The Standardize Basic Transform on the Student Performance Dataset ----
##Perform Mean/Median imputation to address mssing values
# Check for missing values in the specified columns
missing_columns <- c("study_time", "repeats_since_Y1", "night_out", "family_relationships")
missing_data <- student_performance_center_transform[, missing_columns]
missing_indices <- which(is.na(missing_data), arr.ind = TRUE)

# Impute missing values with mean
for (i in 1:nrow(missing_indices)) {
  row <- missing_indices[i, 1]
  col <- missing_indices[i, 2]
  col_name <- colnames(missing_data)[col]
  
  # Calculate mean of non-missing values in the column
  col_mean <- mean(student_performance_center_transform[[col_name]], na.rm = TRUE)
  
  # Replace missing value with mean
  student_performance_center_transform[row, col_name] <- col_mean
}

# Verify if missing values are imputed
sapply(student_performance_center_transform[, missing_columns], function(x) sum(is.na(x)))

# BEFORE
summary(student_performance_center_transform)
sapply(student_performance_center_transform[, c("study_time", "repeats_since_Y1", "night_out", "family_relationships")], sd)

# Apply the standardize transform (including centering)
model_of_the_transform_standardize <- preProcess(student_performance_center_transform, method = c("scale", "center"))
student_performance_standardize_transform <- predict(model_of_the_transform_standardize, student_performance_center_transform)

# AFTER
summary(student_performance_standardize_transform)
sapply(student_performance_standardize_transform[, c("study_time", "repeats_since_Y1", "night_out", "family_relationships")], sd)

## STEP 6. Apply a Normalize Data Transform ----
# Normalizing a dataset implies ensuring the numerical data are
# between [0, 1] (inclusive).

### Benefits of the Normalize Data Transform ----
# ... [Include the benefits as described in your code]

### The Normalize Transform on the Student Performance Dataset ----
# BEFORE
summary(student_performance_standardize_transform)

# Apply the normalize transform
model_of_the_transform_normalize <- preProcess(student_performance_standardize_transform, method = c("range"))
student_performance_normalize_transform <- predict(model_of_the_transform_normalize, student_performance_standardize_transform)

# AFTER
summary(student_performance_normalize_transform)

# You can also create histograms for specific columns if needed
hist(student_performance_normalize_transform$study_time, main = "Histogram for Normalized Study Time")
hist(student_performance_normalize_transform$repeats_since_Y1, main = "Histogram for Normalized Repeats Since Y1")
hist(student_performance_normalize_transform$night_out, main = "Histogram for Normalized Night Out")
hist(student_performance_normalize_transform$family_relationships, main = "Histogram for Normalized Family Relationships")



## STEP 7. Apply a Box-Cox Power Transform ----
### Box-Cox Power Transform ---
# Load your dataset (replace 'student_performance_dataset.csv' with your actual dataset file name)
student_performance_dataset <- read.csv("/home/ki3ani/BBT4206-R-Lab4of15-DataTransforms-lumin/data/perfomance-dataset.csv")

# Select only the numeric columns for transformation
numeric_columns <- c("YOB", "regret_choosing_bi", "drop_bi_now", "motivator", "read_content_before_lecture", 
                     "anticipate_test_questions", "answer_rhetorical_questions", "find_terms_I_do_not_know", 
                     "copy_new_terms_in_reading_notebook", "take_quizzes_and_use_results", "reorganise_course_outline", 
                     "write_down_important_points", "space_out_revision", "studying_in_study_group", "schedule_appointments", 
                     "goal_oriented", "spaced_repetition", "testing_and_active_recall", "interleaving", "categorizing", 
                     "retrospective_timetable", "cornell_notes", "sq3r", "commute", "study_time", "repeats_since_Y1", 
                     "paid_tuition", "free_tuition", "extra_curricular", "sports_extra_curricular", "exercise_per_week", 
                     "meditate", "pray", "internet", "laptop", "family_relationships", "friendships", "romantic_relationships", 
                     "spiritual_wellnes", "financial_wellness", "health", "day_out", "night_out", "alcohol_or_narcotics", 
                     "mentor", "mentor_meetings")

# BEFORE
summary(student_performance_dataset)

# Calculate the skewness before the Box-Cox transform
sapply(student_performance_dataset[numeric_columns], skewness, type = 2)

# Plot a histogram to view the skewness before the Box-Cox transform
par(mfrow = c(1, 4))  # Changed to display 4 plots per row
for (i in 1:length(numeric_columns)) {
  hist(student_performance_dataset[[numeric_columns[i]]], main = numeric_columns[i])
}

# Apply Box-Cox transformation
model_of_the_transform <- preProcess(student_performance_dataset[numeric_columns], method = c("BoxCox"))

# Transform the dataset
student_performance_dataset_box_cox_transform <- predict(model_of_the_transform, student_performance_dataset[numeric_columns])

# AFTER
summary(student_performance_dataset_box_cox_transform)

# Calculate the skewness after the Box-Cox transform
sapply(student_performance_dataset_box_cox_transform, skewness, type = 2)

# Plot a histogram to view the skewness after the Box-Cox transform
par(mfrow = c(1, 4))  # Changed to display 4 plots per row
for (i in 1:length(numeric_columns)) {
  hist(student_performance_dataset_box_cox_transform[[i]], main = numeric_columns[i])
}

# Yeo-Johnson Power Transform ----
## STEP 8. Apply a Yeo-Johnson Power Transform ----

# BEFORE
summary(student_performance_dataset)

# Calculate the skewness before the Yeo-Johnson transform
sapply(student_performance_dataset[, c(5, 10, 15, 20, 25)], skewness, type = 2)
sapply(student_performance_dataset[, c(5, 10, 15, 20, 25)], sd)

model_of_the_transform <- preProcess(student_performance_dataset,
                                     method = c("YeoJohnson"),
                                     cols = c(5, 10, 15, 20, 25))  # Randomly selected columns
print(model_of_the_transform)
student_performance_yeo_johnson_transform <- predict(model_of_the_transform, student_performance_dataset)

# AFTER
summary(student_performance_yeo_johnson_transform)

# Calculate the skewness after the Yeo-Johnson transform
sapply(student_performance_yeo_johnson_transform[, c(5, 10, 15, 20, 25)], skewness, type = 2)
sapply(student_performance_yeo_johnson_transform[, c(5, 10, 15, 20, 25)], sd)



## STEP 9.a. PCA Linear Algebra Transform for Dimensionality Reduction ----
# Check for missing values
missing_values <- colSums(is.na(student_performance_pca))

# Print columns with missing values
print(missing_values)

# Handle missing values (if necessary)
# For example, you can impute missing values with the mean
student_performance_pca <- na.omit(student_performance_pca)

# Perform PCA
pca_result <- prcomp(student_performance_pca, center = TRUE, scale. = TRUE)

# View summary of PCA results
summary(pca_result)

# Access the transformed data (principal components)
pca_transformed_data <- pca_result$x

# STEP 9.b. PCA Linear Algebra Transform for Feature Extraction ----

# Check for missing values (if necessary)
# For example, you can impute missing values with the mean
# student_performance_pca <- na.omit(student_performance_pca)

# Perform PCA
pca_result <- prcomp(student_performance_pca, center = TRUE, scale. = TRUE)

# View summary of PCA results
summary(pca_result)

# Access the transformed data (principal components)
pca_transformed_data <- pca_result$x

# Scree Plot
factoextra::fviz_eig(pca_result, addlabels = TRUE)

# Loading Values
loadings <- pca_result$rotation[, 1:2]

# Interpretation using Cos2
cos2 <- loadings^2

# Biplot and Cos2 Combined Plot
factoextra::fviz_pca_var(X = pca_result, col.var = "cos2",
                         gradient.cols = c("red", "orange", "green"),
                         repel = TRUE)




## STEP 10. ICA Linear Algebra Transform for Dimensionality Reduction ----
# Assuming you have installed the necessary package
if (!requireNamespace("fastICA", quietly = TRUE)) {
  install.packages("fastICA")
}
library(fastICA)

# Assuming pca_transformed_data is your dataframe after PCA
# Select the columns you want to apply ICA on
ica_data <- pca_transformed_data[, c("PC1", "PC2", "PC3", "PC4")]

# Perform ICA using the "R" method
ica_result <- fastICA(ica_data, n.comp = 2, method = "R")

# Access the transformed data (independent components)
ica_transformed_data <- ica_result$S

# Create a dataframe for the transformed data
ica_df <- data.frame(IC1 = ica_transformed_data[, 1], IC2 = ica_transformed_data[, 2])

# View summary of ICA results
summary(ica_result)

# Scatter plot of independent components
ggplot(ica_df, aes(x = IC1, y = IC2)) +
  geom_point() +
  labs(title = "ICA Scatter Plot", x = "Independent Component 1", y = "Independent Component 2")
