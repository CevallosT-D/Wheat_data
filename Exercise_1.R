#####################################
#            Exercise 1            #
####################################

# Create a small data-to-decision pipeline using R scripting



### 1 "wheat" dataset from BGLR ###
### --------------------------- ###

 ## 1.a - Installing package

  # Loading data

   # install.packages("BGLR")
   library(BGLR)
   data(wheat) # This load 3 data tables (wheat.A, wheat.X, wheat.Y) and a list (wheat.sets)

  # Creating new column and row names for the three wheat data tables that are meaningful and informative to an analyst.
   
   # wheat.A -> Wheat_Pedigree
   
     # Since dataframes are more friendly, lets work with them
     str(wheat.A) # pedigree relationship matrix of 599 genotype x genotype (number coded)
    
     # Creating a 3 column dataframe with all the additive relationships
    
      # method 1 - using external package reshape2 (efficient)
      library(reshape2)
      wheat_Pedigree <- melt(wheat.A, varnames = c("genotype_a", "genotype_b"), value.name = "additive_value")
    
      # method 2 - using hardcode imputation (more computationally intensive)
      wheat_id <- colnames(wheat.A) # list of IDs
    
      wheat_Pedigree<-data.frame() # starting dataframe
    
      # Loop through all possible row-column combinations
      for (i in 1:599) {  # Loop through indices 1 to 599
        for (j in 1:599) {
          wheat_Pedigree <- rbind(wheat_Pedigree, data.frame(
            genotype_a = wheat_id[i],  # Use variable names instead of indices
            genotype_b = wheat_id[j],
            additive_value = wheat.A[i, j]
          ))
        }
      }
    
    
   # wheat.X -> wheat_markers 
    
     str(wheat.X) # matrix of 599 genotypes x 1279 DArT markers
    
     # the documentation states the same amount and order of genotypes so we add this information for trace-ability
     wheat_markers <- data.frame(cbind(genotype=colnames(wheat.A),wheat.X))
     wheat_markers[,2:1280] <- lapply(wheat_markers[,2:1280],as.numeric)
     str(wheat_markers)
     # Since this data is in a correct understandable format that can be worked it, we keep it as is.
     
    
   # wheat.Y <- wheat_yield
     
     str(wheat.Y) # we can indeed see the same genotypes and the average yield for 4 locations
     
     # changing it to dataframe and adding IDs as a column and an average of the 2 year average yield
     colnames(wheat.Y)<-c("Location1","Location2","Location3","Location4")
     wheat_yield <- data.frame(cbind(genotype=row.names(wheat.Y),wheat.Y,avg_env_yield=rowMeans(wheat.Y)))
     row.names(wheat_yield)<-NULL
     wheat_yield[,2:6]<-lapply(wheat_yield[,2:6], as.numeric)
  
     
  # Creating API functions to access the wheat dataset in  versatile manner
