#   STATS :
# 
#   Executes both analytical pipelines:
#     1. Factorial Analysis of Mixed Data and Hierarchical Clustering (2 times)
#     2. Statistical DATA Analysis
#
#   Author: Iñaki Intxaurbe Alberdi 
#   Department of Graphic Design and Engineering Projects
#   (Universidad del País Vasco/Euskal Herriko Unibertsitatea)
#   PACEA UMR 5199
#   (Université du Bordeaux)
#   Date: 2023-08-27
#   Copyright (C) 2024  Iñaki Intxaurbe

#install packages ---------------------------------------------------------------------------------------------------------------------------------------------

install.packages(c("FactoMineR", "factoextra", "tidyverse","xlsx","reprex"))
library(xlsx)
library(FactoMineR)
library(factoextra)
library(ggplot2)
library(tidyverse)
library(reprex)
library(scales)
library(ggrepel)

###1st ANALYSIS: Factorial Analysis of Mixed Data and Hierarchical Clustering:
#Read Data

a<-read.xlsx("C:/Users/Inaki/Desktop/Github/2 STATISTICS/Table_DATA.xlsx",
  sheetIndex="FAMD_and_HCPC") 

#Organize Data

a2<-a[,-1]
row.names(a2)<-a[,1]
summary(a)

#Execute Factorial Analysis of Mixed Data (I)

res.famd <- FAMD(a2)

#Compare Dimensions (FAMD I)

get_eigenvalue(res.famd)
fviz_screeplot(res.famd)
dimdesc(res.famd, axes=1, proba=0.001)$Dim.1$quanti
dimdesc(res.famd, axes=1, proba=1e-5)$Dim.1$category
dimdesc(res.famd, axes=2, proba=0.001)$Dim.2$quanti
dimdesc(res.famd, axes=2, proba=1e-5)$Dim.2$category
fviz_contrib(res.famd, choice = "var", axes = 1, top = 20, palette = "jco")
fviz_contrib(res.famd, choice = "var", axes = 2, top = 20, palette = "jco")

#Execute Hierarchical Clustering (HCPC I)

c <- HCPC(res.famd, nb.clus=-1, graph=FALSE)

#Output Plot (FAMD HCPC I)

fviz_cluster(c,repel = TRUE,show.clust.cent = TRUE,palette = "jco",ggtheme = theme_minimal(),main = "Factor map")
fviz_dend(c,cex = 0.1, k_colors = c("#CD534CFF", "#868686FF", "#EFC000FF", "#0073C2FF"), labels_track_height = 0.5)

#Describe clusters (FAMD HCPC I)

c$desc.var$category
c$desc.var$quanti
c$data.clust

#Reorganize to erase the cluster 4 (non figurative motifs)

b<-filter(a, Format != "NF_F")

#Organize Data

b2<-b[,-1]
row.names(b2)<-b[,1]
summary(b)

#Execute Factorial Analysis of Mixed Data (II)

res.famd_II <- FAMD(b2)

#Compare Dimensions (FAMD II)

get_eigenvalue(res.famd_II)
fviz_screeplot(res.famd_II)
dimdesc(res.famd_II, axes=1, proba=0.001)$Dim.1$quanti
dimdesc(res.famd_II, axes=1, proba=1e-5)$Dim.1$category
dimdesc(res.famd_II, axes=2, proba=0.001)$Dim.2$quanti
dimdesc(res.famd_II, axes=2, proba=1e-5)$Dim.2$category
fviz_contrib(res.famd_II, choice = "var", axes = 1, top = 20, palette = "jco")
fviz_contrib(res.famd_II, choice = "var", axes = 2, top = 20, palette = "jco")

#Execute Hierarchical Clustering (HCPC II)

c_II <- HCPC(res.famd_II, nb.clus=-1, graph=FALSE)

#Output Plot (FAMD HCPC II)

fviz_cluster(c_II,repel = TRUE,show.clust.cent = TRUE,palette = c("#0073C2FF","#868686FF","#EFC000FF"),ggtheme = theme_minimal(),main = "Factor map")
fviz_dend(c_II,cex = 0.1, k_colors = c("#0073C2FF","#868686FF","#EFC000FF"), labels_track_height = 0.5)

#Describe clusters (FAMD HCPC II)

c_II$desc.var$category
c_II$desc.var$quanti
c_II$data.clust

###2nd ANALYSIS: Statistical DATA Analysis:
#Read Data

a<-read.xlsx("C:/Users/Inaki/Desktop/Github/2 STATISTICS/Table_DATA.xlsx",
  sheetIndex="DATA_ANALYSIS")

#Organize Data

a2<-a[,-1]
row.names(a2)<-a[,1]
summary(a)

#Analyse percent of GU's in each cluster in the 1st analysis

a_GUS <- a[,c(1,21)]
a_GUS$ClustersI<-as.factor(a_GUS$ClustersI)
df <- a_GUS %>%
  count(ClustersI) %>%
  mutate(perc = (n/sum(n)*100))

df2 <- df %>% 
  mutate(csum = rev(cumsum(rev(perc))), 
         pos = perc/2 + lead(csum, 1),
         pos = if_else(is.na(pos), perc/2, pos))

mycols <- c("#0073C2FF", "#EFC000FF", "#868686FF", "#CD534CFF")

ggplot(df, aes(x = "" , y = perc, fill = fct_inorder(ClustersI))) +
  geom_col(width = 1, color = "white") +
  coord_polar(theta = "y") +
  scale_fill_manual(values = mycols) +
  geom_label_repel(data = df2,
                   aes(y = pos, label = perc),
                   size = 4.5, nudge_x = 1, show.legend = FALSE) +
  guides(fill = guide_legend(title = "Clusters")) +
  theme_void()

#Analyse percent of GU's in each cluster in the 1st analysis (by each cave)

a_GUS <- a[,c(2,21)]
a_GUS$ClustersI<-as.factor(a_GUS$ClustersI)
df <- a_GUS %>%
  group_by(Cave) %>%
  count(ClustersI) %>%
  mutate(perc = (n/sum(n)*100))

mycols <- c("#0073C2FF", "#EFC000FF", "#868686FF", "#CD534CFF")

ggplot(df, aes(Cave,perc,fill= ClustersI))+
  geom_bar(stat = "identity")+
  scale_fill_manual("Clusters", values = mycols)+
  labs(X= "Caves", y= "% of GU's")

#Analyse percent of GU's in each cluster in the 2nd analysis

a_GUS <- a[,c(1,22)]
a_GUS$ClustersII<-as.factor(a_GUS$ClustersII)
df <- a_GUS %>%
  filter(ClustersII != "NULL") %>%
  count(ClustersII) %>%
  mutate(perc = (n/sum(n)*100))

df2 <- df %>% 
  mutate(csum = rev(cumsum(rev(perc))), 
         pos = perc/2 + lead(csum, 1),
         pos = if_else(is.na(pos), perc/2, pos))

mycols <- c("#0073C2FF","#868686FF","#EFC000FF")

ggplot(df, aes(x = "" , y = perc, fill = fct_inorder(ClustersII))) +
  geom_col(width = 1, color = "white") +
  coord_polar(theta = "y") +
  scale_fill_manual(values = mycols) +
  geom_label_repel(data = df2,
                   aes(y = pos, label = perc),
                   size = 4.5, nudge_x = 1, show.legend = FALSE) +
  guides(fill = guide_legend(title = "Clusters")) +
  theme_void()

#Analyse percent of GU's in each cluster in the 2nd analysis (by each cave)

a_GUS <- a[,c(2,22)]
a_GUS$ClustersII<-as.factor(a_GUS$ClustersII)
df <- a_GUS %>%
  filter(ClustersII != "NULL") %>%
  group_by(Cave) %>%
  count(ClustersII) %>%
  mutate(perc = (n/sum(n)*100))

mycols <- c("#0073C2FF","#868686FF","#EFC000FF")

ggplot(df, aes(Cave,perc,fill= ClustersII))+
  geom_bar(stat = "identity")+
  scale_fill_manual("Clusters", values = mycols)+
  labs(X= "Caves", y= "% of GU's")

#Access Difficulty Values statistics in each Cave

a_access <- a[,c(2,14)]
a_Etxeberri <- filter(a_access, Cave == "Etxeberri")
a_Etxeberri <- mutate(a_Etxeberri, Etxeberri=DifVal)
a_Etxeberri <- tibble::rowid_to_column(a_Etxeberri, "ID")
a_Etxeberri <- a_Etxeberri[,c(1,4)]
a_Alkerdi <- filter(a_access, Cave == "Alkerdi 1")
a_Alkerdi <- mutate(a_Alkerdi, Alkerdi_1=DifVal)
a_Alkerdi <- tibble::rowid_to_column(a_Alkerdi, "ID")
a_Alkerdi <- a_Alkerdi[,c(1,4)]
a_Aitzbitarte_IV <- filter(a_access, Cave == "Aitzbitarte IV")
a_Aitzbitarte_IV <- mutate(a_Aitzbitarte_IV, Aitzbitarte_IV=DifVal)
a_Aitzbitarte_IV <- tibble::rowid_to_column(a_Aitzbitarte_IV, "ID")
a_Aitzbitarte_IV <- a_Aitzbitarte_IV[,c(1,4)]
a_Aitzbitarte_V <- filter(a_access, Cave == "Aitzbitarte V")
a_Aitzbitarte_V <- mutate(a_Aitzbitarte_V, Aitzbitarte_V=DifVal)
a_Aitzbitarte_V <- tibble::rowid_to_column(a_Aitzbitarte_V, "ID")
a_Aitzbitarte_V <- a_Aitzbitarte_V[,c(1,4)]
a_Altxerri <- filter(a_access, Cave == "Altxerri")
a_Altxerri <- mutate(a_Altxerri, Altxerri=DifVal)
a_Altxerri <- tibble::rowid_to_column(a_Altxerri, "ID")
a_Altxerri <- a_Altxerri[,c(1,4)]
a_Ekain <- filter(a_access, Cave == "Ekain")
a_Ekain <- mutate(a_Ekain, Ekain=DifVal)
a_Ekain <- tibble::rowid_to_column(a_Ekain, "ID")
a_Ekain <- a_Ekain[,c(1,4)]
a_Atxurra <- filter(a_access, Cave == "Atxurra")
a_Atxurra <- mutate(a_Atxurra, Atxurra=DifVal)
a_Atxurra <- tibble::rowid_to_column(a_Atxurra, "ID")
a_Atxurra <- a_Atxurra[,c(1,4)]
a_Lumentxa <- filter(a_access, Cave == "Lumentxa")
a_Lumentxa <- mutate(a_Lumentxa, Lumentxa=DifVal)
a_Lumentxa <- tibble::rowid_to_column(a_Lumentxa, "ID")
a_Lumentxa <- a_Lumentxa[,c(1,4)]
a_Santimamiñe <- filter(a_access, Cave == "Santimamiñe")
a_Santimamiñe <- mutate(a_Santimamiñe, Santimamiñe=DifVal)
a_Santimamiñe <- tibble::rowid_to_column(a_Santimamiñe, "ID")
a_Santimamiñe <- a_Santimamiñe[,c(1,4)]
DiffValues<-merge(a_Etxeberri,merge(a_Alkerdi,merge(a_Aitzbitarte_IV,
    merge(a_Aitzbitarte_V,merge(a_Altxerri,merge(a_Ekain,merge(a_Atxurra,
    merge(a_Lumentxa,a_Santimamiñe,all=TRUE),all=TRUE),all=TRUE),all=TRUE),
    all=TRUE),all=TRUE),all=TRUE),all=TRUE)
DiffValues<-DiffValues[,c(2,4,10,8,5,3,7,6,9)]
boxplot(DiffValues, col="bisque1",ylab="Access difficulty values")

#Analyse Access Difficulty Values statistics, according to each Cluster
#Clusters 1 to 4 from 1st FAMD and HCPC (ClustersI)

a_access2 <- a[,c(14,21)]
a_1 <- filter(a_access2, ClustersI == "1")
a_1 <- mutate(a_1, Cluster_1=DifVal)
a_1 <- tibble::rowid_to_column(a_1, "ID")
a_1 <- a_1[,c(1,4)]
a_2 <- filter(a_access2, ClustersI == "2")
a_2 <- mutate(a_2, Cluster_2=DifVal)
a_2 <- tibble::rowid_to_column(a_2, "ID")
a_2 <- a_2[,c(1,4)]
a_3 <- filter(a_access2, ClustersI == "3")
a_3 <- mutate(a_3, Cluster_3=DifVal)
a_3 <- tibble::rowid_to_column(a_3, "ID")
a_3 <- a_3[,c(1,4)]
a_4 <- filter(a_access2, ClustersI == "4")
a_4 <- mutate(a_4, Cluster_4=DifVal)
a_4 <- tibble::rowid_to_column(a_4, "ID")
a_4 <- a_4[,c(1,4)]
DiffValues<-merge(a_1,merge(a_2,merge(a_3,a_4,all=TRUE),all=TRUE),all=TRUE)
DiffValues<-DiffValues[,c(2:5)]
boxplot(DiffValues, col=c("#0073C2FF", "#EFC000FF", "#868686FF", "#CD534CFF"),ylab="Access difficulty values")

#Analyse Access Difficulty Values statistics, according to each Cluster
#Clusters 1 to 3 from 2nd FAMD and HCPC (ClustersII)

a_access2 <- a[,c(14,22)]
a_1 <- filter(a_access2, ClustersII == "1")
a_1 <- mutate(a_1, Cluster_1=DifVal)
a_1 <- tibble::rowid_to_column(a_1, "ID")
a_1 <- a_1[,c(1,4)]
a_2 <- filter(a_access2, ClustersII == "2")
a_2 <- mutate(a_2, Cluster_2=DifVal)
a_2 <- tibble::rowid_to_column(a_2, "ID")
a_2 <- a_2[,c(1,4)]
a_3 <- filter(a_access2, ClustersII == "3")
a_3 <- mutate(a_3, Cluster_3=DifVal)
a_3 <- tibble::rowid_to_column(a_3, "ID")
a_3 <- a_3[,c(1,4)]
DiffValues<-merge(a_1,merge(a_2,a_3,all=TRUE),all=TRUE)
DiffValues<-DiffValues[,c(2:4)]
boxplot(DiffValues, col=c("#0073C2FF","#868686FF","#EFC000FF"),ylab="Access difficulty values")

#LCP Values statistics in each Cave

a_lcp <- a[,c(2,15)]
a_Etxeberri <- filter(a_lcp, Cave == "Etxeberri")
a_Etxeberri <- mutate(a_Etxeberri, Etxeberri=LCP)
a_Etxeberri <- tibble::rowid_to_column(a_Etxeberri, "ID")
a_Etxeberri <- a_Etxeberri[,c(1,4)]
a_Alkerdi <- filter(a_lcp, Cave == "Alkerdi 1")
a_Alkerdi <- mutate(a_Alkerdi, Alkerdi_1=LCP)
a_Alkerdi <- tibble::rowid_to_column(a_Alkerdi, "ID")
a_Alkerdi <- a_Alkerdi[,c(1,4)]
a_Aitzbitarte_IV <- filter(a_lcp, Cave == "Aitzbitarte IV")
a_Aitzbitarte_IV <- mutate(a_Aitzbitarte_IV, Aitzbitarte_IV=LCP)
a_Aitzbitarte_IV <- tibble::rowid_to_column(a_Aitzbitarte_IV, "ID")
a_Aitzbitarte_IV <- a_Aitzbitarte_IV[,c(1,4)]
a_Aitzbitarte_V <- filter(a_lcp, Cave == "Aitzbitarte V")
a_Aitzbitarte_V <- mutate(a_Aitzbitarte_V, Aitzbitarte_V=LCP)
a_Aitzbitarte_V <- tibble::rowid_to_column(a_Aitzbitarte_V, "ID")
a_Aitzbitarte_V <- a_Aitzbitarte_V[,c(1,4)]
a_Altxerri <- filter(a_lcp, Cave == "Altxerri")
a_Altxerri <- mutate(a_Altxerri, Altxerri=LCP)
a_Altxerri <- tibble::rowid_to_column(a_Altxerri, "ID")
a_Altxerri <- a_Altxerri[,c(1,4)]
a_Ekain <- filter(a_lcp, Cave == "Ekain")
a_Ekain <- mutate(a_Ekain, Ekain=LCP)
a_Ekain <- tibble::rowid_to_column(a_Ekain, "ID")
a_Ekain <- a_Ekain[,c(1,4)]
a_Atxurra <- filter(a_lcp, Cave == "Atxurra")
a_Atxurra <- mutate(a_Atxurra, Atxurra=LCP)
a_Atxurra <- tibble::rowid_to_column(a_Atxurra, "ID")
a_Atxurra <- a_Atxurra[,c(1,4)]
a_Lumentxa <- filter(a_lcp, Cave == "Lumentxa")
a_Lumentxa <- mutate(a_Lumentxa, Lumentxa=LCP)
a_Lumentxa <- tibble::rowid_to_column(a_Lumentxa, "ID")
a_Lumentxa <- a_Lumentxa[,c(1,4)]
a_Santimamiñe <- filter(a_lcp, Cave == "Santimamiñe")
a_Santimamiñe <- mutate(a_Santimamiñe, Santimamiñe=LCP)
a_Santimamiñe <- tibble::rowid_to_column(a_Santimamiñe, "ID")
a_Santimamiñe <- a_Santimamiñe[,c(1,4)]
LeastCostPath<-merge(a_Etxeberri,merge(a_Alkerdi,merge(a_Aitzbitarte_IV,
    merge(a_Aitzbitarte_V,merge(a_Altxerri,merge(a_Ekain,merge(a_Atxurra,
    merge(a_Lumentxa,a_Santimamiñe,all=TRUE),all=TRUE),all=TRUE),all=TRUE),
    all=TRUE),all=TRUE),all=TRUE),all=TRUE)
LeastCostPath<-LeastCostPath[,c(8,2,4,6,7,5,10,3,9)]
boxplot(LeastCostPath, col="bisque1",ylab="Least cost path length (m)")

#Analyse LCP Values statistics, according to each Cluster
#Clusters 1 to 4 from 1st FAMD and HCPC (ClustersI)

a_lcp2 <- a[,c(15,21)]
a_1 <- filter(a_lcp2, ClustersI == "1")
a_1 <- mutate(a_1, Cluster_1=LCP)
a_1 <- tibble::rowid_to_column(a_1, "ID")
a_1 <- a_1[,c(1,4)]
a_2 <- filter(a_lcp2, ClustersI == "2")
a_2 <- mutate(a_2, Cluster_2=LCP)
a_2 <- tibble::rowid_to_column(a_2, "ID")
a_2 <- a_2[,c(1,4)]
a_3 <- filter(a_lcp2, ClustersI == "3")
a_3 <- mutate(a_3, Cluster_3=LCP)
a_3 <- tibble::rowid_to_column(a_3, "ID")
a_3 <- a_3[,c(1,4)]
a_4 <- filter(a_lcp2, ClustersI == "4")
a_4 <- mutate(a_4, Cluster_4=LCP)
a_4 <- tibble::rowid_to_column(a_4, "ID")
a_4 <- a_4[,c(1,4)]
DiffValues<-merge(a_1,merge(a_2,merge(a_3,a_4,all=TRUE),all=TRUE),all=TRUE)
DiffValues<-DiffValues[,c(2:5)]
boxplot(DiffValues, col=c("#0073C2FF", "#EFC000FF", "#868686FF", "#CD534CFF"),ylab="Least cost path length (m)")

#Analyse LCP Values statistics, according to each Cluster
#Clusters 1 to 3 from 2nd FAMD and HCPC (ClustersII)

a_lcp2 <- a[,c(15,22)]
a_1 <- filter(a_lcp2, ClustersII == "1")
a_1 <- mutate(a_1, Cluster_1=LCP)
a_1 <- tibble::rowid_to_column(a_1, "ID")
a_1 <- a_1[,c(1,4)]
a_2 <- filter(a_lcp2, ClustersII == "2")
a_2 <- mutate(a_2, Cluster_2=LCP)
a_2 <- tibble::rowid_to_column(a_2, "ID")
a_2 <- a_2[,c(1,4)]
a_3 <- filter(a_lcp2, ClustersII == "3")
a_3 <- mutate(a_3, Cluster_3=LCP)
a_3 <- tibble::rowid_to_column(a_3, "ID")
a_3 <- a_3[,c(1,4)]
DiffValues<-merge(a_1,merge(a_2,a_3,all=TRUE),all=TRUE)
DiffValues<-DiffValues[,c(2:4)]
boxplot(DiffValues, col=c("#0073C2FF","#868686FF","#EFC000FF"),ylab="Least cost path length (m)")

#ETA Values statistics in each Cave

a_eta <- a[,c(2,16)]
a_Etxeberri <- filter(a_eta, Cave == "Etxeberri")
a_Etxeberri <- mutate(a_Etxeberri, Etxeberri=ETA)
a_Etxeberri <- tibble::rowid_to_column(a_Etxeberri, "ID")
a_Etxeberri <- a_Etxeberri[,c(1,4)]
a_Alkerdi <- filter(a_eta, Cave == "Alkerdi 1")
a_Alkerdi <- mutate(a_Alkerdi, Alkerdi_1=ETA)
a_Alkerdi <- tibble::rowid_to_column(a_Alkerdi, "ID")
a_Alkerdi <- a_Alkerdi[,c(1,4)]
a_Aitzbitarte_IV <- filter(a_eta, Cave == "Aitzbitarte IV")
a_Aitzbitarte_IV <- mutate(a_Aitzbitarte_IV, Aitzbitarte_IV=ETA)
a_Aitzbitarte_IV <- tibble::rowid_to_column(a_Aitzbitarte_IV, "ID")
a_Aitzbitarte_IV <- a_Aitzbitarte_IV[,c(1,4)]
a_Aitzbitarte_V <- filter(a_eta, Cave == "Aitzbitarte V")
a_Aitzbitarte_V <- mutate(a_Aitzbitarte_V, Aitzbitarte_V=ETA)
a_Aitzbitarte_V <- tibble::rowid_to_column(a_Aitzbitarte_V, "ID")
a_Aitzbitarte_V <- a_Aitzbitarte_V[,c(1,4)]
a_Altxerri <- filter(a_eta, Cave == "Altxerri")
a_Altxerri <- mutate(a_Altxerri, Altxerri=ETA)
a_Altxerri <- tibble::rowid_to_column(a_Altxerri, "ID")
a_Altxerri <- a_Altxerri[,c(1,4)]
a_Ekain <- filter(a_eta, Cave == "Ekain")
a_Ekain <- mutate(a_Ekain, Ekain=ETA)
a_Ekain <- tibble::rowid_to_column(a_Ekain, "ID")
a_Ekain <- a_Ekain[,c(1,4)]
a_Atxurra <- filter(a_eta, Cave == "Atxurra")
a_Atxurra <- mutate(a_Atxurra, Atxurra=ETA)
a_Atxurra <- tibble::rowid_to_column(a_Atxurra, "ID")
a_Atxurra <- a_Atxurra[,c(1,4)]
a_Lumentxa <- filter(a_eta, Cave == "Lumentxa")
a_Lumentxa <- mutate(a_Lumentxa, Lumentxa=ETA)
a_Lumentxa <- tibble::rowid_to_column(a_Lumentxa, "ID")
a_Lumentxa <- a_Lumentxa[,c(1,4)]
a_Santimamiñe <- filter(a_eta, Cave == "Santimamiñe")
a_Santimamiñe <- mutate(a_Santimamiñe, Santimamiñe=ETA)
a_Santimamiñe <- tibble::rowid_to_column(a_Santimamiñe, "ID")
a_Santimamiñe <- a_Santimamiñe[,c(1,4)]
EstimatedTimeArrival<-merge(a_Etxeberri,merge(a_Alkerdi,merge(a_Aitzbitarte_IV,
    merge(a_Aitzbitarte_V,merge(a_Altxerri,merge(a_Ekain,merge(a_Atxurra,
    merge(a_Lumentxa,a_Santimamiñe,all=TRUE),all=TRUE),all=TRUE),all=TRUE),
    all=TRUE),all=TRUE),all=TRUE),all=TRUE)
EstimatedTimeArrival<-EstimatedTimeArrival[,c(8,2,4,10,5,7,3,6,9)]
boxplot(EstimatedTimeArrival, col="bisque1",ylab="Estimated minutes to arrive")

#Analyse ETA Values statistics, according to each Cluster
#Clusters 1 to 4 from 1st FAMD and HCPC (ClustersI)

a_eta2 <- a[,c(16,21)]
a_1 <- filter(a_eta2, ClustersI == "1")
a_1 <- mutate(a_1, Cluster_1=ETA)
a_1 <- tibble::rowid_to_column(a_1, "ID")
a_1 <- a_1[,c(1,4)]
a_2 <- filter(a_eta2, ClustersI == "2")
a_2 <- mutate(a_2, Cluster_2=ETA)
a_2 <- tibble::rowid_to_column(a_2, "ID")
a_2 <- a_2[,c(1,4)]
a_3 <- filter(a_eta2, ClustersI == "3")
a_3 <- mutate(a_3, Cluster_3=ETA)
a_3 <- tibble::rowid_to_column(a_3, "ID")
a_3 <- a_3[,c(1,4)]
a_4 <- filter(a_eta2, ClustersI == "4")
a_4 <- mutate(a_4, Cluster_4=ETA)
a_4 <- tibble::rowid_to_column(a_4, "ID")
a_4 <- a_4[,c(1,4)]
DiffValues<-merge(a_1,merge(a_2,merge(a_3,a_4,all=TRUE),all=TRUE),all=TRUE)
DiffValues<-DiffValues[,c(2:5)]
boxplot(DiffValues, col=c("#0073C2FF", "#EFC000FF", "#868686FF", "#CD534CFF"),ylab="Estimated minutes to arrive")

#Analyse ETA Values statistics, according to each Cluster
#Clusters 1 to 3 from 2nd FAMD and HCPC (ClustersII)

a_eta2 <- a[,c(16,22)]
a_1 <- filter(a_eta2, ClustersII == "1")
a_1 <- mutate(a_1, Cluster_1=ETA)
a_1 <- tibble::rowid_to_column(a_1, "ID")
a_1 <- a_1[,c(1,4)]
a_2 <- filter(a_eta2, ClustersII == "2")
a_2 <- mutate(a_2, Cluster_2=ETA)
a_2 <- tibble::rowid_to_column(a_2, "ID")
a_2 <- a_2[,c(1,4)]
a_3 <- filter(a_eta2, ClustersII == "3")
a_3 <- mutate(a_3, Cluster_3=ETA)
a_3 <- tibble::rowid_to_column(a_3, "ID")
a_3 <- a_3[,c(1,4)]
DiffValues<-merge(a_1,merge(a_2,a_3,all=TRUE),all=TRUE)
DiffValues<-DiffValues[,c(2:4)]
boxplot(DiffValues, col=c("#0073C2FF","#868686FF","#EFC000FF"),ylab="Estimated minutes to arrive")

#Estimated viewers statistics in each Cave

a_viewers <- a[,c(2,20)]
a_Etxeberri <- filter(a_viewers, Cave == "Etxeberri")
a_Etxeberri <- mutate(a_Etxeberri, Etxeberri=View)
a_Etxeberri <- tibble::rowid_to_column(a_Etxeberri, "ID")
a_Etxeberri <- a_Etxeberri[,c(1,4)]
a_Alkerdi <- filter(a_viewers, Cave == "Alkerdi 1")
a_Alkerdi <- mutate(a_Alkerdi, Alkerdi_1=View)
a_Alkerdi <- tibble::rowid_to_column(a_Alkerdi, "ID")
a_Alkerdi <- a_Alkerdi[,c(1,4)]
a_Aitzbitarte_IV <- filter(a_viewers, Cave == "Aitzbitarte IV")
a_Aitzbitarte_IV <- mutate(a_Aitzbitarte_IV, Aitzbitarte_IV=View)
a_Aitzbitarte_IV <- tibble::rowid_to_column(a_Aitzbitarte_IV, "ID")
a_Aitzbitarte_IV <- a_Aitzbitarte_IV[,c(1,4)]
a_Aitzbitarte_V <- filter(a_viewers, Cave == "Aitzbitarte V")
a_Aitzbitarte_V <- mutate(a_Aitzbitarte_V, Aitzbitarte_V=View)
a_Aitzbitarte_V <- tibble::rowid_to_column(a_Aitzbitarte_V, "ID")
a_Aitzbitarte_V <- a_Aitzbitarte_V[,c(1,4)]
a_Altxerri <- filter(a_viewers, Cave == "Altxerri")
a_Altxerri <- mutate(a_Altxerri, Altxerri=View)
a_Altxerri <- tibble::rowid_to_column(a_Altxerri, "ID")
a_Altxerri <- a_Altxerri[,c(1,4)]
a_Ekain <- filter(a_viewers, Cave == "Ekain")
a_Ekain <- mutate(a_Ekain, Ekain=View)
a_Ekain <- tibble::rowid_to_column(a_Ekain, "ID")
a_Ekain <- a_Ekain[,c(1,4)]
a_Atxurra <- filter(a_viewers, Cave == "Atxurra")
a_Atxurra <- mutate(a_Atxurra, Atxurra=View)
a_Atxurra <- tibble::rowid_to_column(a_Atxurra, "ID")
a_Atxurra <- a_Atxurra[,c(1,4)]
a_Lumentxa <- filter(a_viewers, Cave == "Lumentxa")
a_Lumentxa <- mutate(a_Lumentxa, Lumentxa=View)
a_Lumentxa <- tibble::rowid_to_column(a_Lumentxa, "ID")
a_Lumentxa <- a_Lumentxa[,c(1,4)]
a_Santimamiñe <- filter(a_viewers, Cave == "Santimamiñe")
a_Santimamiñe <- mutate(a_Santimamiñe, Santimamiñe=View)
a_Santimamiñe <- tibble::rowid_to_column(a_Santimamiñe, "ID")
a_Santimamiñe <- a_Santimamiñe[,c(1,4)]
Viewers<-merge(a_Etxeberri,merge(a_Alkerdi,merge(a_Aitzbitarte_IV,
    merge(a_Aitzbitarte_V,merge(a_Altxerri,merge(a_Ekain,merge(a_Atxurra,
    merge(a_Lumentxa,a_Santimamiñe,all=TRUE),all=TRUE),all=TRUE),all=TRUE),
    all=TRUE),all=TRUE),all=TRUE),all=TRUE)
Viewers<-Viewers[,c(7,9,8,10,6,2,5,3,4)]
boxplot(Viewers, col="bisque1",ylab="Estimated maximum nº of viewers")

#Analyse viewers statistics, according to each Cluster
#Clusters 1 to 4 from 1st FAMD and HCPC (ClustersI)

a_view2 <- a[,c(20,21)]
a_1 <- filter(a_view2, ClustersI == "1")
a_1 <- mutate(a_1, Cluster_1=View)
a_1 <- tibble::rowid_to_column(a_1, "ID")
a_1 <- a_1[,c(1,4)]
a_2 <- filter(a_view2, ClustersI == "2")
a_2 <- mutate(a_2, Cluster_2=View)
a_2 <- tibble::rowid_to_column(a_2, "ID")
a_2 <- a_2[,c(1,4)]
a_3 <- filter(a_view2, ClustersI == "3")
a_3 <- mutate(a_3, Cluster_3=View)
a_3 <- tibble::rowid_to_column(a_3, "ID")
a_3 <- a_3[,c(1,4)]
a_4 <- filter(a_view2, ClustersI == "4")
a_4 <- mutate(a_4, Cluster_4=View)
a_4 <- tibble::rowid_to_column(a_4, "ID")
a_4 <- a_4[,c(1,4)]
DiffValues<-merge(a_1,merge(a_2,merge(a_3,a_4,all=TRUE),all=TRUE),all=TRUE)
DiffValues<-DiffValues[,c(2:5)]
boxplot(DiffValues, col=c("#0073C2FF", "#EFC000FF", "#868686FF", "#CD534CFF"),ylab="Estimated maximum nº of viewers")

#Analyse viewers statistics, according to each Cluster
#Clusters 1 to 3 from 2nd FAMD and HCPC (ClustersII)

a_view2 <- a[,c(20,22)]
a_1 <- filter(a_view2, ClustersII == "1")
a_1 <- mutate(a_1, Cluster_1=View)
a_1 <- tibble::rowid_to_column(a_1, "ID")
a_1 <- a_1[,c(1,4)]
a_2 <- filter(a_view2, ClustersII == "2")
a_2 <- mutate(a_2, Cluster_2=View)
a_2 <- tibble::rowid_to_column(a_2, "ID")
a_2 <- a_2[,c(1,4)]
a_3 <- filter(a_view2, ClustersII == "3")
a_3 <- mutate(a_3, Cluster_3=View)
a_3 <- tibble::rowid_to_column(a_3, "ID")
a_3 <- a_3[,c(1,4)]
DiffValues<-merge(a_1,merge(a_2,a_3,all=TRUE),all=TRUE)
DiffValues<-DiffValues[,c(2:4)]
boxplot(DiffValues, col=c("#0073C2FF","#868686FF","#EFC000FF"),ylab="Estimated maximum nº of viewers")

#Analyse estimated posture of the artist, according to each Cave

a_Caves <- a[,c(2,19)]
a_Caves_a <- a_Caves %>%
  filter(Posture != "NULL") %>%
  group_by(Cave) %>%
  count(Posture) %>%
  mutate(perc = (n/sum(n)*100))

ggplot(a_Caves_a, aes(Cave,perc,fill= Posture))+
  geom_bar(stat = "identity")+
  scale_fill_manual("Posture", values = c("1 Kneeling" = "sienna1", 
    "2 Leaning" = "bisque1","3 Lean/Up" = "lightblue","4 Upright" = "lawngreen",
    "5 Elevated" = "springgreen4"))+
  labs(X= "ClustersI", y= "Posture")

#Analyse estimated posture of the artist, according to each Cluster
#Clusters 1 to 4 from 1st FAMD and HCPC (ClustersI)

a_ClustersI <- a[,c(19,21)]
a_ClustersI_a <- a_ClustersI %>%
  filter(Posture != "NULL") %>%
  group_by(ClustersI) %>%
  count(Posture) %>%
  mutate(perc = (n/sum(n)*100))

ggplot(a_ClustersI_a, aes(ClustersI,perc,fill= Posture))+
  geom_bar(stat = "identity")+
  scale_fill_manual("Posture", values = c("1 Kneeling" = "sienna1", 
    "2 Leaning" = "bisque1","3 Lean/Up" = "lightblue","4 Upright" = "lawngreen",
    "5 Elevated" = "springgreen4"))+
  labs(X= "ClustersI", y= "Posture")

#Clusters 1 to 3 from 2nd FAMD and HCPC (ClustersII)

a_ClustersII <- a[,c(19,22)]
a_ClustersII_a <- a_ClustersII %>%
  filter(Posture != "NULL") %>%
  group_by(ClustersII) %>%
  count(Posture) %>%
  mutate(perc = (n/sum(n)*100))

ggplot(a_ClustersII_a, aes(ClustersII,perc,fill= Posture))+
  geom_bar(stat = "identity")+
  scale_fill_manual("Posture", values = c("1 Kneeling" = "sienna1", 
   "2 Leaning" = "bisque1","3 Lean/Up" = "lightblue","4 Upright" = "lawngreen",
   "5 Elevated" = "springgreen4"))+
  labs(X= "ClustersII", y= "Posture")

