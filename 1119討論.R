bird_1 <- read.table("C:/Users/Waiting/Downloads/dwca-trait_454-v1.68/measurementorfacts.txt", header = TRUE, sep = "\t", fill = TRUE, quote = "")

bird_2 <- read.table("C:/Users/Waiting/Downloads/dwca-trait_454-v1.68/extendedmeasurementorfact.txt", header = TRUE, sep = "\t", fill = TRUE, quote = "")

bird_3 <- read.table("C:/Users/Waiting/Downloads/dwca-trait_454-v1.68/taxon.txt", header = TRUE, sep = "\t", fill = TRUE, quote = "")

unique(bird_1$measurementType)
