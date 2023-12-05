library(tidyverse)
library(janitor)
library(bibliometrix)

pseudo_1 <- "data/pseudoscience_1.bib"
pseudo_2 <- "data/pseudoscience_2.bib"

df_pseudo_1 <- convert2df(file = pseudo_1,
                      dbsource = "wos",
                      format = "bibtex")
df_pseudo_2 <- convert2df(file = pseudo_2,
                          dbsource = "wos",
                          format = "bibtex")
M <- bind_rows(
  df_pseudo_1,
  df_pseudo_2
 )


#writing data
write_rds(M, "data/pseudo_comb.rds")
library(bib2df)
df2bib(M, "data/pseudo_comb.bib")
write_csv(M, "data/pseudo_comb.csv")

# run a stock analysis (generates a list of dataframes)
pseudo_results <- biblioAnalysis(M, sep = ";")

# create a summary of the results
options(width=100)
S <- summary(object = pseudo_results, k = 10, pause = FALSE)

plot(x = pseudo_results, k = 10, pause = FALSE)


# Get citations and find top 50 cited articles
PR <- citations(M, field = "article", sep = ";")
cbind(PR$Cited[1:5])
PR <- citations(M, field = "author", sep = ";")
cbind(PR$Cited[1:5])

#local
PR <- localCitations(M, sep = ";")
PR$Authors[1:10, ]
PR$Papers[1:10,]


#Co-citation
NetMatrix <- biblioNetwork(M, analysis = "co-citation", network = "references", sep = ";")

## Plot the network
net=networkPlot(NetMatrix, 
                n = 40, 
                Title = "'Pseudoscience' Co-Citation Network (n=40)", 
                type = "fruchterman",
                size=T, 
                remove.multiple=FALSE, 
                labelsize=0.7,
                edgesize = 4)



