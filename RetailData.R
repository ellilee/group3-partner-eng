# Libraries

# Load data
retail <- read.csv('pca_retail_building_section_1&4&5_data_items.csv')
head(retail)

# Drop irrelevant last column
retail <- subset(retail, select = -c(type))

# ###################################################################################################################
# SELECTING ROWS THAT PERTAIN TO THE 3 RETAIL RELATIONSHIPS: sf->WOOD FRAME, sf->CONCRETE MASONRY, zc->GLU LAMINATED
# 
# NOTES: 
# - the idea here is finding rows that are known to contain one of the target variables, so later can see how 
#   associated the zipcode/sqft is with the presence of wood/concrete/glu. feasible? 
# - since there is no numerical data and rows are selected based on RegEx, this eliminates the need to do
#   traditional cleaning such as text preprocessing / imputing missing values. correct? 
# ###################################################################################################################

# Select rows that pertain to wood framing (based on the_data)
#   using regEx to find any columns that contain the strings "wood" and "fram"(e/ing) which implies the 
#   presence of a wood frame (can tweak these parameters)
wood_frame_rows <- retail[grepl("wood", retail$the_data, ignore.case = TRUE) & grepl("fram", retail$the_data, ignore.case = TRUE), ]
head(wood_frame_rows)

# Same for concrete masonry
# Select rows containing both "concrete" and "mason" in the_data column
concrete_masonry_rows <- retail[grepl("concrete", retail$the_data, ignore.case = TRUE) & grepl("mason", retail$the_data, ignore.case = TRUE), ]
head(concrete_masonry_rows)

# Same for glu-laminated, where it can be present in either the_data or document_text
glu_rows <- retail[grepl("glu", retail$the_data, ignore.case = TRUE) | grepl("glu", retail$document_text, ignore.case = TRUE), ]

# View the selected rows
print(glu_rows)

# #######################
# EXECUTIVE SUMMARY ROWS
# #######################

# Identifying executive summary info
#               - seems like "project_zip" (under document_spot) denotes zipcode
#               - and "gross_building" denotes square footage

# Select zipcode rows
zip_code_rows <- retail[grepl("project_zip", retail$document_spot, ignore.case = TRUE), ]

# Convert zip codes to factors to avoid R considering zipcodes as numerical 
zip_code_rows$the_data <- as.factor(zip_code_rows$the_data)
zip_code_rows$document_text <- as.factor(zip_code_rows$document_text)

# Select square footage rows
sqft_rows <- retail[grepl("gross_building", retail$document_spot, ignore.case = TRUE), ]



#########################
# BLANKS IN OUTSIDE_NAME
#########################
# Find rows with blank values in the "outside_name" column
blank_values <- retail$outside_name == ""
rows_with_blank_values <- retail[blank_values, c("project_id", "outside_name")]
print(rows_with_blank_values)
print(dim(rows_with_blank_values))

#########################
# BLANKS IN DOC_SPOT
#########################
# Find rows with blank values in the "document_spot" column
blank_values_document_spot <- retail$document_spot == ""
rows_with_blank_document_spot <- retail[blank_values_document_spot, c("project_id", "document_spot")]
print(rows_with_blank_document_spot)
print(dim(rows_with_blank_document_spot))

# No blanks in document_spot, so can infer blanks in outside_name (?)



