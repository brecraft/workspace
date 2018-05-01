#This code is used to create bins for a REST API queue
#Code Developed by Brenna Craft

# Select Libraries
library(dplyr)

# Read file into R
batches_fer_queue <- read.csv("batches_to_be_grouped.csv")

# Set how many batches you want in queue
num_batches_in_queue <- 1


## Standardize column names, bin batches and concat
batches_fer_queue %<>%
  mutate(queuerow = ntile(BatchID, num_batches_in_queue))  %>%  
  group_by(queuerow) %>%                                        
  summarise(batches = paste(BatchID, collapse = ', '))          

#Set Values for actual queue Creation
SiteId <- 42
AppId <- 42
EntityId <- "null"
PropertyNames <- "null"
MaxEntitiesPerRequest <- 0
FileNamePattern <- "'Masked_Table_Name.csv'"
SnapshotTableName <- "'Masked_Table_Name'"
ProcessAfterDate <- "'2018-03-05 18:16:48'"
DateAdded <- "'2018-04-01 18:16:48'"
Status <- 101
StatusDate <- "'2018-04-01 18:16:48'"

batchid_filter <- paste0("'AqBatchID in (", batches_fer_queue$batches, ")'")

final_where_clause <-
  paste(sep = ",", SiteId, AppId, EntityId, PropertyNames, batchid_filter,
    MaxEntitiesPerRequest, FileNamePattern, SnapshotTableName, ProcessAfterDate,
    DateAdded, Status, StatusDate) %>%
  paste("(", ., "),")

# Writes to file
write.csv(final_where_clause, file = "final_list_alternate.csv")
