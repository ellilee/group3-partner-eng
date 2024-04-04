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
# PROCESSING ZIPCODE ROWS
# #######################

zip_code_rows <- retail[grepl("project_zip", retail$document_spot, ignore.case = TRUE), ]

# Convert zip codes to factors to avoid R considering zipcodes as numerical 
zip_code_rows$the_data <- as.factor(zip_code_rows$the_data)
zip_code_rows$document_text <- as.factor(zip_code_rows$document_text)

# NEXT STEPS: - identifying executive summary info
#               - seems like project_zip (under document_spot) denotes "zipcode"
#               - but where is square footage?
#                 - after finding, can actually find odds ratios and correlations
#


head(retail)
