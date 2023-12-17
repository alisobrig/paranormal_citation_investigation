#load in necessary libraries
library(tidyverse)
library(janitor)
library(bibliometrix)

#read in "parnormal investigation" bibtex data
para <- "data/paranormal_investigation.bib"

#create data from from bibtex file
df_para <- convert2df(file = para,
                      dbsource = "wos",
                      format = "bibtex")
#save in "data" file
write_rds(df_para, "data/para_comb.rds")
library(bib2df)
df2bib(df_para, "data/para_comb.bib")
write_csv(df_para, "data/para_comb.csv")

# run a stock analysis and generate of summary of results
results <- biblioAnalysis(df_para, sep = ";")
options(width=100)
S <- summary(object = results, k = 10, pause = FALSE)

# Top 5 cited documents and authors
CR <- citations(df_para, field = "article", sep = ";")
cbind(CR$Cited[1:5])
CR <- citations(df_para, field = "author", sep = ";")
cbind(CR$Cited[1:5])

#get citations for top 10 local authors and articles - articles and authors most cited in my corpus
CR <- localCitations(df_para, sep = ";")
CR$Authors[1:5, ]
CR$Papers[1:5,]


#Perform and plot co-citation network analysis - adjust "n=" and title values as needed 
NetMatrix <- biblioNetwork(df_para,
                           analysis = "co-citation",
                           network = "references", 
                           sep = ";")
net=networkPlot(NetMatrix, 
                n = 35, 
                Title = "'Paranormal Investigation' Co-Citation Network (n=35)", 
                type = "fruchterman",
                size=T, 
                remove.multiple=FALSE, 
                labelsize=0.7,
                edgesize = 4)
net=networkPlot(NetMatrix, 
                n = 111, 
                Title = "'Paranormal Investigation' Co-Citation Network (n=111)", 
                type = "fruchterman",
                size=T, 
                remove.multiple=FALSE, 
                labelsize=0.7,
                edgesize = 4)

#keyword cocitaiton
NetMatrix <- biblioNetwork(df_para,
                           analysis = "co-occurrences",
                           network = "keywords", sep = ";")

net=networkPlot(NetMatrix,
                normalize="association",
                weighted=T,
                n = 50, 
                Title = "'Paranormal Investigation' Keyword Co-occurrences", 
                type = "fruchterman", size=T,edgesize = 5,labelsize=0.7)

## Create a historical citation network
options(width=130)
histResults <- histNetwork(df_para,
                           min.citations = 1, 
                           sep = ";")

net <- histPlot(histResults, 
                n=111, 
                size = 10, 
                labelsize=5)
