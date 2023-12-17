#load in necessary libraries
library(tidyverse)
library(janitor)
library(bibliometrix)
biblioshiny()

#read in "pseudoscience" bibtex files from web of science

pseudo_1 <- "data/pseudoscience_1.bib"
pseudo_2 <- "data/pseudoscience_2.bib"

#convert bibtex files to data frames
df_pseudo_1 <- convert2df(file = pseudo_1,
                      dbsource = "wos",
                      format = "bibtex")
df_pseudo_2 <- convert2df(file = pseudo_2,
                          dbsource = "wos",
                          format = "bibtex")

#combine all pseudoscience data
M <- bind_rows(
  df_pseudo_1,
  df_pseudo_2
 )

#create files for combined data and place in "data" folder
write_rds(M, "data/pseudo_comb.rds")
library(bib2df)
df2bib(M, "data/pseudo_comb.bib")
write_csv(M, "data/pseudo_comb.csv")

# run a stock analysis and generate a summary of results
pseudo_results <- biblioAnalysis(M, sep = ";")
options(width=100)
S <- summary(object = pseudo_results, k = 10, pause = FALSE)

#create graphs of the summay data
plot(x = pseudo_results, k = 10, pause = FALSE)

# get citations and see top 5 authors and articles
PR <- citations(M, field = "article", sep = ";")
cbind(PR$Cited[1:5])
PR <- citations(M, field = "author", sep = ";")
cbind(PR$Cited[1:5])

#get citations for top 10 local authors and articles - articles and authors most cited in my corpus
PR <- localCitations(M, sep = ";")
PR$Authors[1:10, ]
PR$Papers[1:10,]

#Perform and plot co-citation network analysis - adjust "n=" and title values as needed 
###DOES NOT WORK IN R, move to biblioshiny() app###
NetMatrix <- biblioNetwork(M, analysis = "co-citation", network = "references", sep = ";")
net=networkPlot(NetMatrix, 
                n = 35, 
                Title = "'Pseudoscience' Co-Citation Network (n=35)", 
                type = "fruchterman",
                size=T, 
                remove.multiple=FALSE, 
                labelsize=0.7,
                edgesize = 4)
net=networkPlot(NetMatrix, 
                n = 100, 
                Title = "'Pseudoscience' Co-Citation Network (n=100)", 
                type = "fruchterman",
                size=T, 
                remove.multiple=FALSE, 
                labelsize=0.7,
                edgesize = 4)




