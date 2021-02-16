countrySummary <- read_csv("./shared_data/countrySummary.csv")

cnt_pca <- principal(countrySummary[3:26], 
                     nfactors = 11, #Number of factors to include in the solution
                     rotate = 'varimax', #Method to decide the rotation of the components. Leads to different interpretations of the components (i.e. whether they can be correlated) but does not change the explained variance.
                     missing = TRUE) #Predict component values if some data is missing

principal_dat <- cbind(countrySummary[,2], cnt_pca$scores)

db <- fpc::dbscan(principal_dat[2:12], eps = 3.6, MinPts = 3)

km_cluster <- kmeansCBI(principal_dat[,2:12],
                        krange = 1:(nrow(principal_dat)-1), #Automatically tests every value of K up from one to one less than the number of countries
                        criterion = "ch",
                        runs = 400) #The number of random centroid positions to try

km_cluster_demo <- kmeansCBI(principal_dat[,2:12],
                             krange = 2:20,
                             criterion = "ch",
                             runs = 400) #The number of random centroid positions to try

mapSummary <- mutate(countrySummary,
                         cluster = as.factor(km_cluster_demo$partition))

countryMap <- select(mapSummary, Country, cluster)
countryMap$Country <- recode(countryMap$Country,
                             "United States" = "USA",
                             "United Kingdom" = "UK",
                             "Viet Nam" = "Vietnam",
                             "Brunei Darussalam" = "Brunei",
                             "Korea" = "South Korea",
                             "Slovak Republic" = "Slovakia",
                             "North Macedonia" = "Macedonia",
                             "Hong Kong (China)" = "Hong Kong",
                             "Macao (China)" = "Macao"
)
map.world <- map_data("world") %>%
  left_join(countryMap, by = c("region" = "Country"))
country.points <- data.frame(
  Country = c("Brunei", "Hong Kong", "Luxembourg", "Macao", "Singapore", "Qatar", "United Arab Emirates"),
  lat = c(4.5353, 22.3193, 49.6116, 22.1987, 1.3521, 25.3548, 23.4241),
  long = c(114.7277, 114.1694, 6.1319, 113.5439, 103.8198, 51.1839, 53.8478),
  stringsAsFactors = FALSE
) %>%
  left_join(countryMap, by = "Country")

dat <- read_csv("./shared_data/Sample_Students.csv") %>% 
  inner_join(select(countrySummary, CNT), by = "CNT")

GLMM_read <- lmer(Score ~ Spending * Learning +
                    (1 + Spending * Learning | CNT) +
                    (1 | ID) +
                    (1 | Item),
                  data = filter(dat, str_detect(Item, "READ")))
GLMM_read_summary <- summary(GLMM_read)

GLMM_math <- lmer(Score ~ Spending * Learning +
                    (1 + Spending * Learning | CNT) +
                    (1 | ID) +
                    (1 | Item),
                  data = filter(dat, str_detect(Item, "MATH")))
GLMM_math_summary <- summary(GLMM_math)

GLMM_scie <- lmer(Score ~ Spending * Learning +
                    (1 + Spending * Learning | CNT) +
                    (1 | ID) +
                    (1 | Item),
                  data = filter(dat, str_detect(Item, "SCIE")))
GLMM_scie_summary <- summary(GLMM_scie)

lme4Summaries <- tibble(
  Subject = c("Reading", "Maths", "Science"),
  Spending = c(GLMM_read_summary$coefficients[2,1], GLMM_math_summary$coefficients[2,1], GLMM_scie_summary$coefficients[2,1]),
  "Learning Time" = c(GLMM_read_summary$coefficients[3,1], GLMM_math_summary$coefficients[3,1], GLMM_scie_summary$coefficients[3,1]),
  "Spending x Learning" = c(GLMM_read_summary$coefficients[4,1], GLMM_math_summary$coefficients[4,1], GLMM_scie_summary$coefficients[4,1]),
  "Marginal R2" = c(r.squaredGLMM(GLMM_read)[1], r.squaredGLMM(GLMM_math)[1],r.squaredGLMM(GLMM_scie)[1]),
  "Total R2" = c(r.squaredGLMM(GLMM_read)[2], r.squaredGLMM(GLMM_math)[2],r.squaredGLMM(GLMM_scie)[2])) %>%
  mutate(across(where(is.numeric), round, 2))

learnSpend <- dat %>% separate(Item, into = c("Item", "Type"), sep = -4) %>% group_by(Country, Type) %>%
  summarise(Mean = mean(Score)) %>% right_join(unique(select(dat, Country, Spending, Learning)))

countrySummary2015 <- read_csv("./shared_data/CountrySummary2015.csv")

cnt_pca2015 <- principal(countrySummary2015[3:24], nfactors = 11)
principal_dat2015 <- cbind(countrySummary2015[,2], cnt_pca2015$scores) %>% na.omit

km_cluster2015 <- kmeansCBI(principal_dat2015[2:12],
                            krange = 1:(nrow(principal_dat2015)-1),
                            criterion = "ch",
                            runs = 400)
expanded_dat <- read_csv("./shared_data/studentSchoolData.csv")

mixed_model <- lmer(Score ~ Spending * LearningTime + PhysicalInfrastructure + InternetComputers + PropTeachersQual + ClassSize +
                      ParentEducation + Wealth + TeacherInterest + WellBeing + Resilience + Bullied +
                      (1 + Spending | CNT) +
                      (1 + PhysicalInfrastructure + InternetComputers + PropTeachersQual + ClassSize | SchID) +
                      (1 + ParentEducation + LearningTime + Wealth + TeacherInterest + WellBeing + Resilience + Bullied | ID) +
                      (1 | Item),
                    data = expanded_dat)

save.image("./6_Analysis/FinalExample.RData")
