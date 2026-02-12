

#####################################################################
#report table generation for multiple samples
#using MNPflex-report.pdf files from MNPflex tool
#####################################################################


# Set working directory
setwd("")


# Install packages if needed
if (!require(pdftools)) install.packages("pdftools")
if (!require(dplyr)) install.packages("dplyr")
if (!require(stringr)) install.packages("stringr")

# Load libraries
library(pdftools)
library(dplyr)
library(stringr)

# Set your folder path containing the PDF files
pdf_folder <- "/Documents/mnpflex/"  # change according to your directory

# List all PDF files
pdf_files <- list.files(pdf_folder, pattern = "\\.pdf$", full.names = TRUE)

# Initialize empty list to store results
results <- list()

# Loop over all PDFs
for (pdf_file in pdf_files) {
  # Extract text from PDF
  text <- pdf_text(pdf_file)
  full_text <- paste(text, collapse = "\n")  # Combine all pages
  
  # Extract Sample_ID from file name (remove path and .pdf extension)
  sample_id <- tools::file_path_sans_ext(basename(pdf_file))
  
  # Extract Methylation superfamily, family, class, subclass and their scores
  superfamily_info <- str_match(full_text, "Methylation superfamily\\s+(.+?)\\s+(\\d\\.\\d+)")[,2:3]
  family_info      <- str_match(full_text, "Methylation family\\s+(.+?)\\s+(\\d\\.\\d+)")[,2:3]
  class_info       <- str_match(full_text, "Methylation class\\s+(.+?)\\s+(\\d\\.\\d+)")[,2:3]
  subclass_info    <- str_match(full_text, "Methylation subclass\\s+(.+?)\\s+(\\d\\.\\d+)")[,2:3]
  
  # Extract MGMT info
  mgmt_sites <- str_match(full_text, "Number of sites used\\s*=\\s*(\\d+)")[,2]
  mgmt_avg_methyl <- str_match(full_text, "Average methylation\\s*=\\s*([0-9\\.]+)%?")[,2]
  mgmt_status <- str_match(full_text, "Predicted MGMT promoter status=\\s*(\\w+)")[,2]
  
  # Create a dataframe row
  sample_row <- tibble(
    Sample_ID = sample_id,
    Methylation_Superfamily = superfamily_info[1],
    Superfamily_Score = as.numeric(superfamily_info[2]),
    Methylation_Family = family_info[1],
    Family_Score = as.numeric(family_info[2]),
    Methylation_Class = class_info[1],
    Class_Score = as.numeric(class_info[2]),
    Methylation_Subclass = subclass_info[1],
    Subclass_Score = as.numeric(subclass_info[2]),
    MGMT_Sites_Used = as.numeric(mgmt_sites),
    MGMT_Avg_Methylation = as.numeric(mgmt_avg_methyl),
    MGMT_Status = mgmt_status
  )
  
  # Add to results
  results[[length(results) + 1]] <- sample_row
}

# Combine all samples into one table
final_table <- bind_rows(results)

# Print the final table
print(final_table)

# Save to CSV
write.csv(final_table, "Methylation_Classification_Summary.csv", row.names = FALSE)

