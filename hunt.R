library(tidyverse)
library(janitor)
library(bibliometrix)
biblioshiny()


hunt_1 <- "data/ghost_hunt.bib"

df_hunt <- convert2df(file = hunt_1,
                       dbsource = "wos",
                       format = "bibtex")
M <- df_hunt

#writing data
write_rds(df_hunt, "data/hunt_comb.rds")
library(bib2df)
df2bib(df_hunt, "data/hunt_comb.bib")
write_csv(df_hunt, "data/hunt_comb.csv")

# run a stock analysis (generates a list of dataframes)
results <- biblioAnalysis(df_hunt, sep = ";")

# create a summary of the results
options(width=100)
S <- summary(object = results, k = 10, pause = FALSE)

# Get citations and find top 50 cited articles
CR <- citations(df_hunt, field = "article", sep = ";")
cbind(CR$Cited[1:5])
CR <- citations(df_hunt, field = "author", sep = ";")
cbind(CR$Cited[1:5])

#local citations in dataset
CR <- localCitations(df_hunt, sep = ";")
CR$Authors[1:5, ]
CR$Papers[1:5,]

#co-citation network
NetMatrix <- biblioNetwork(M, analysis = "co-citation", network = "references", sep = ";")

#n=82 to see all
net=networkPlot(NetMatrix, 
                n = 82, 
                Title = "'Ghost Hunting' Co-Citation Network (n=82)", 
                type = "fruchterman",
                size=T, 
                remove.multiple=FALSE, 
                labelsize=0.7,
                edgesize = 4)

#n=10 to try and understand
net=networkPlot(NetMatrix, 
                n = 10, 
                Title = "'Ghost Hunting' Co-Citation Network (n=10)", 
                type = "fruchterman",
                size=T, 
                remove.multiple=FALSE, 
                labelsize=0.7,
                edgesize = 4)


# Create a historical citation network
options(width=130)
histResults <- histNetwork(M,
                           min.citations = 1, sep = ";")

net <- histPlot(histResults, 
                n=30, size = 10, labelsize=5)

#keyword
NetMatrix <- biblioNetwork(df_hunt,
                           analysis = "co-occurrences",
                           network = "keywords", sep = ";")

net=networkPlot(NetMatrix,
                normalize="association",
                weighted=T,
                n = 50, 
                Title = "'Paranormal Investigation' Keyword Co-occurrences", 
                type = "fruchterman", size=T,edgesize = 5,labelsize=0.7)

