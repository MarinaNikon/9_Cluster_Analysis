#Principal Component Analysis Assignment
#Marina Nikon

#BACKGROUND:
#Birds belonging to different ecological groups have different appearances:
#flying birds have strong wings and wading birds have long legs. Their 
#living habits are somewhat reflected in their bones' shapes.

#As data scientists we may think of examining the underlying relationship 
#between sizes of bones and ecological groups, and recognising birds' 
#ecological groups by their bones' shapes.

#Each bird is represented by 10 measurements (features):
#Length and Diameter of Humerus
#Length and Diameter of Ulna
#Length and Diameter of Femur
#Length and Diameter of Tibiotarsus
#Length and Diameter of Tarsometatarsus

#All measurements are continuous float numbers (mm). The skeletons of this dataset are collections of Natural History Museum of Los Angeles County. They belong to 21 orders, 153 genera, 245 species.

#Each bird has a label for its ecological group:
#SW: Swimming Birds
#W: Wading Birds
#T: Terrestrial Birds
#R: Raptors
#P: Scansorial Birds 
#SO: Singing Birds


#Install the packages if required and call for the corresponding library
library(ggplot2) # for plots
library(GGally) # for plots
library(dplyr) # for data cleaning and data management


#QUESTIONS:
#Import ‘Bird’ data in R.
# Load the data
birds<-read.csv(file.choose(), header = TRUE)
head(birds) # View first 6 rows
dim(birds) # Check the dimension of the dataset
summary(birds) #Summarizing data and checking for missing values
str(birds) # Check the structure of the dataset
anyNA(birds) # Check for missing values
#birds <- na.omit(birds)

#Observations:
#There are no missing values and all skeletal measurements are numeric


#2 Summarise bird type using Principal Component Analysis. How many principal components
#are required to explain maximum variation in the data? Interpret the component.

# Drop the 'id' and 'type' columns as they are not needed for PCA
pca_birds<-subset(birds,select = -c(id,type))
cor(pca_birds)
#Observations:
#There is a positive, strong (and moderate with Tarsometatarsus's length)
#correlation between all the measurements)


# Create a pair plot
ggpairs(pca_birds)
#Observations:
#Most of the scatter plots show an upward trend, which means that 
#there is a strong, positive correlation between them.


#PCA for Dimensionality Reduction
# Standardize the data by scaling it
pca_birds<-data.frame(scale(pca_birds))

# Run PCA on data
pc<-princomp(formula=~.,data=pca_birds, cor=T)

# Check summary of PCA output
summary(pc)
#Observations:
#The 1st principal component is holding 85% variance. The 1st and 2nd  principal
#components together will give 92%. The first two principal components are good 
#enough to have the maximum variability of the data. This implies that a limited 
#number of principal components effectively represent the majority of the data’s
#variability. Data redaction is achieved. 


#component loadings
pc$loadings


#3 Store the principal component scores as a new variable.
#PCA-derived Scores
# Assign the values of the first principal component (Comp.1) as a new 'performance' column in the original data
birds$performance<-pc$score[,1]
head(birds)
#Observations:
#Higher the value, better is the performance of the bird's type


#Scree Plot depicting principal components against their respective variances
plot(pc, type="lines")
#Observations:
#Two principal component are sufficient (from ten independent variables)
#in explaining the maximum variation


#4 Find average values of the new variable for each bird type and interpret the results.
#Summarizing performance by type
# Group the data by type and calculate the average performance for each type
summary_pc_type<-birds %>%
  group_by(type) %>%
  summarize(performance = round(mean(performance),3))%>%
  as.data.frame()
print(summary_pc_type)
#Observations:
#  type performance
#1    P      -1.615
#2    R       2.418
#3   SO      -2.399
#4   SW       1.842
#5    T       0.139
#6    W       0.405


# Create a bar graph using the specified color palette
ggplot(summary_pc_type, aes(x = type, y = performance, fill = type)) +
  geom_bar(stat = "identity") +
  labs(title = "Average Performance by Type", x = "Type", y = "Average Performance") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  scale_fill_brewer(palette = "Set3")
#Observations:
#Raptors have highest performance score 2.418

