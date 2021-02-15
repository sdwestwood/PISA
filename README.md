# ESSENTIAL PACKAGES
The interactive grading packages require installation from github. Before attempting the tutorials, you will need to install `learnr` and `gradethis`.
To install these, you can run the following lines of code in the R console:
`devtools::install_github("rstudio/learnr")`
`devtools::install_github("rstudio-education/gradethis")`

The following is a list of additional CRAN packages that are currently used in each tutorial section:

## PCA
library(tidyverse) #data manipulation <br/>
library(ggplot2) #visualization features
library(plotly) #interactive plots
library(psych) #PCA functions
library(chemometrics) #mahalanobis distance test

## Clustering 
library(tidyverse) #data manipulation
library(plotly) #visualization features
library(ggplot2) #visualization features
library(shiny) #interactive plots
library(ggalt) #additional plot features
library(kmodR) #k-means simultaneous outlier detection 
library(cluster) #clustering algorithms
library(factoextra) #clustering visualization
library(dendextend) #dendrograms visualization
library(fpc) #computing density based clustering
library(dbscan) #computing density based clustering

## GLM
library(tidyverse) #data manipulation

## CV
library(tidyverse) #data manipulation

## Analysis
library(tidyverse) #data manipulation 
library(dbscan) #computing density based clustering
library(fpc) #computing density based clustering
library(ggrepel) #geom labels
library(kableExtra) #table layout
library(knitr) #Markdown
library(lme4) #Mixed effects models
library(maps) #Maps
library(MuMIn) #Mixed effects variance
library(psych) #PCA functions
library(shiny) #*everything*

