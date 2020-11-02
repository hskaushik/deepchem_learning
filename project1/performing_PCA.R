install.packages("FactoMineR")
install.packages("factoextra")
install.packages("tidyverse")
install.packages("ggplot2")
install.packages("reshape2")

library("FactoMineR")
library("factoextra")
library("tidyverse")
library("ggplot2")
library("reshape2")

Descriptors<- read.csv(file = '/Users/KHatti001/OneDrive/project1_data/from_PP/mergedData_clearance.csv')
Descriptors<- read.csv(file = '/Users/KHatti001/OneDrive/project1_data/from_PP/mergedData_TauSeeding.csv')

Descriptors<- read.csv(file = '/Users/KHatti001/OneDrive/project1_data/from_PP/forPCA.csv')
column_to_rownames(Descriptors, 'class')

Descriptors_training<- read.csv(file = '/Users/KHatti001/OneDrive/project1_data/from_PP/training_data.csv')

DUP03Data<-read.csv(file='/Users/KHatti001/OneDrive/project2/data/all_data.csv')

# Selecting Clearance Descriptors
selectedDescriptors<-Descriptors %>% select(
                                            LOGP_nOct_VS,
                                            SKIN_VS,
                                            ACACDO_VS,
                                            PHSAR_VS,
                                            class
                                            )

names(selectedDescriptors)[names(selectedDescriptors) == "LOGP_nOct_VS"] <- "logP"
names(selectedDescriptors)[names(selectedDescriptors) == "SKIN_VS"] <- "Skin_irr"
names(selectedDescriptors)[names(selectedDescriptors) == "ACACDO_VS"] <- "H-donor"
names(selectedDescriptors)[names(selectedDescriptors) == "PHSAR_VS"] <- "PSA"


# Selecting Tau seeding Descriptors
selectedDescriptors<-Descriptors %>% select(
                                            DRDRDR_VS,
                                            logS_SD,
                                            CW1_VS,
                                            D2_VS,
                                            CD2_VS,
                                            R_VS,
                                            D6_VS,
                                            CACO2_VS,
                                            
                                            class
                                          )



# plotting density plot of selected descriptors
hp<-ggplot(melt(selectedDescriptors), aes(x=value, color=class, fill=class)) + 
  geom_density(alpha=0.3) 
  

# plotting density plot of DUP03
melted_data <-melt(DUP03Data[c(2:5)])
hp<-ggplot(melted_data, aes(x=value, color=variable, fill=variable)) + 
  geom_density(alpha=0.3) 

# Histogram of total_bill, divided by sex and smoker
hp + facet_wrap(variable ~ ., scales='free')


# Performing PCA
Descriptors.pca <- PCA(selectedDescriptors[,-5],  
                       scale.unit =TRUE,
                       graph = FALSE)

# Distribution of dimensions
fviz_screeplot(Descriptors.pca, addlabels = TRUE, ylim = c(0, 50))

# Plotting PCA circle
var <- get_pca_var(Descriptors.pca)
fviz_pca_var(Descriptors.pca, col.var = "black")

# with colour coded contribution
fviz_pca_var(Descriptors.pca, col.var="contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE # Avoid text overlapping
)

# Contributions of variables to PC1 and PC2
fviz_contrib(Descriptors.pca, choice = "var", axes = 1:2, top = 10)

# individuals plot
# Graph of individuals
# 1. Use repel = TRUE to avoid overplotting
# 2. Control automatically the color of individuals using the cos2
# cos2 = the quality of the individuals on the factor map
# Use points only
# 3. Use gradient color
fviz_pca_ind(Descriptors.pca, col.ind = "cos2",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE # Avoid text overlapping (slow if many points)
)

fviz_pca_biplot(
                #title="PCA-Biplot:\n Chemical property relationship w.r.t compound stability",
                Descriptors.pca,
                geom="point",
                labelsize = 4,
                habillage =  as.factor(Descriptors$class),
                palette = c("#009e73", "#d55e00"),
                pointsize = 1,
                col.var = "black",

                addEllipses = TRUE # Concentration ellipses
)





# group by plot
# Use habillage to specify groups for coloring
Descriptors.pca <- PCA(Descriptors[c(1:5)], graph = FALSE)


fviz_pca_ind(Descriptors.pca,
             label = "none", # hide individual labels
             habillage = as.factor(Descriptors$class), # color by groups
             palette = c("#00AFBB", "#E7B800"),
             addEllipses = TRUE # Concentration ellipses
)




# Example using iris data
# Compute PCA on the iris data set
# The variable Species (index = 5) is removed
# before PCA analysis
iris.pca <- PCA(iris[,-5], graph = FALSE)
View(iris)
# Visualize
# Use habillage to specify groups for coloring
fviz_pca_ind(iris.pca,
             label = "none", # hide individual labels
             habillage = iris$Species, # color by groups
             palette = c("#00AFBB", "#E7B800", "#FC4E07"),
             addEllipses = TRUE # Concentration ellipses
)

