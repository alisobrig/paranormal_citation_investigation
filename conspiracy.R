#load packages
library(tidyverse)
library(janitor)
library(bibliometrix)
library(dplyr)
biblioshiny()

#loading in conspiracy bibtex files
con1 <- "data/conspiracy_1.bib"
con2 <- "data/conspiracy_2.bib"
con3 <- "data/conspiracy_3.bib"
con4 <- "data/conspiracy_4.bib"
con5 <- "data/conspiracy_5.bib"
con6 <- "data/conspiracy_6.bib"
con7 <- "data/conspiracy_7.bib"
con8 <- "data/conspiracy_8.bib"
con9 <- "data/conspiracy_9.bib"
con10 <- "data/conspiracy_10.bib"
con11 <- "data/conspiracy_11.bib"
con12 <- "data/conspiracy_12.bib"
con13 <- "data/conspiracy_13.bib"
con14 <- "data/conspiracy_14.bib"


#create data frames from bibtex files
df_con1 <- convert2df(file = con1,
                      dbsource = "wos",
                      format = "bibtex")
df_con2 <- convert2df(file = con2,
                      dbsource = "wos",
                      format = "bibtex")
df_con3 <- convert2df(file = con3,
                      dbsource = "wos",
                      format = "bibtex")
df_con4 <- convert2df(file = con4,
                      dbsource = "wos",
                      format = "bibtex")
df_con5 <- convert2df(file = con5,
                      dbsource = "wos",
                      format = "bibtex")
df_con6 <- convert2df(file = con6,
                      dbsource = "wos",
                      format = "bibtex")
df_con7 <- convert2df(file = con7,
                      dbsource = "wos",
                      format = "bibtex")
df_con8 <- convert2df(file = con8,
                      dbsource = "wos",
                      format = "bibtex")
df_con9 <- convert2df(file = con9,
                      dbsource = "wos",
                      format = "bibtex")
df_con10 <- convert2df(file = con10,
                      dbsource = "wos",
                      format = "bibtex")
df_con11 <- convert2df(file = con11,
                      dbsource = "wos",
                      format = "bibtex")
df_con12 <- convert2df(file = con12,
                      dbsource = "wos",
                      format = "bibtex")
df_con13 <- convert2df(file = con13,
                      dbsource = "wos",
                      format = "bibtex")
df_con14 <- convert2df(file = con14,
                      dbsource = "wos",
                      format = "bibtex")

#combine conspiracy data 
M <- bind_rows(
  df_con1,
  df_con2,
  df_con3,
  df_con4,
  df_con5,
  df_con6,
  df_con7,
  df_con8,
  df_con9,
  df_con10,
  df_con11,
  df_con12,
  df_con13,
  df_con14,
)

#write new data files for combined data
write_rds(M, "data/cons_comb.rds")
library(bib2df)
df2bib(M, "data/cons_comb.bib")
write_csv(M, "data/cons_comb.csv")

# run a stock analysis and generate summary 
results <- biblioAnalysis(M, sep = ";")
options(width=100)
S <- summary(object = results, k = 10, pause = FALSE)
plot(x = results, k = 10, pause = FALSE)

# Get top cited authors and documents
CR <- citations(M, field = "article", sep = ";")
cbind(CR$Cited[1:5])
CR <- citations(M, field = "author", sep = ";")
cbind(CR$Cited[1:5])

#Get top local cited authors and documents
CR <- localCitations(M, sep = ";")
CR$Authors[1:5, ]
CR$Papers[1:5,]

#Perform and plot co-citation network analysis - adjust "n=" and title values as needed 
###DOES NOT WORK IN R, move to biblioshiny() app###
NetMatrix <- biblioNetwork(M, analysis = "co-citation", network = "references", sep = ";")
net=networkPlot(NetMatrix,
                n = 35, 
                Title = "Co-Citation Network", 
                type = "fruchterman", 
                size=T,
                label.cex=TRUE,
                label.color=TRUE,
                halo=FALSE,
                remove.multiple=FALSE, 
                labelsize=.7,
                edgesize = 3,
                cluster = "none",
                community.repulsion = .3,
                edges.min = 1)


