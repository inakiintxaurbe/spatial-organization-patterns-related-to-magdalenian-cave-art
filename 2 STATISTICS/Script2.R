#   STATS (2) :
#
#   Executes both analytical pipelines:
#     1. Factorial Analysis of Mixed Data and Hierarchical Clustering
#     2. Each cave centroid in the Factorial Map (1st FAMD)
#
#   Author: Iñaki Intxaurbe Alberdi 
#   Department of Graphic Design and Engineering Projects
#   (Universidad del País Vasco/Euskal Herriko Unibertsitatea)
#   PACEA UMR 5199
#   (Université du Bordeaux)
#   Update Date: 2025-12-21
#   Copyright (C) 2025  Iñaki Intxaurbe

# Install packages (if necessary) ----------------------------------------------------------------------------------------------------------------------------------------------
pkgs <- c(
  "xlsx", "FactoMineR", "factoextra", "ggplot2", "tidyverse",
  "reprex", "scales", "ggrepel"
)

to_install <- pkgs[!pkgs %in% rownames(installed.packages())]
if (length(to_install) > 0) install.packages(to_install)

library(xlsx)
library(FactoMineR)
library(factoextra)
library(ggplot2)
library(tidyverse)
library(reprex)
library(scales)
library(ggrepel)


file_path <- file.path(getwd(), "Table_DATA.xlsx")
a <- read.xlsx(file_path, sheetIndex = "FAMD_and_HCPC")

a2 <- a[, -1]
row.names(a2) <- a[, 1]

# FAMD ------------------------------------------------------------------------------------------------------------------------------------------------------------

res.famd <- FAMD(a2)

# HCPC ------------------------------------------------------------------------------------------------------------------------------------------------------------

c <- HCPC(res.famd, nb.clus = -1, graph = FALSE)

# Coordinates -----------------------------------------------------------------------------------------------------------------------------------------------------

coord <- as.data.frame(res.famd$ind$coord[, 1:2])
colnames(coord) <- c("Dim1", "Dim2")

cl <- c$data.clust
coord$cluster <- factor(cl[rownames(coord), "clust"])
coord$GU <- rownames(coord)

# Detect caves and colculate centroids -----------------------------------------------------------------------------------------------------------------------------

detect_cave <- function(x) {
  x <- as.character(x)
  case_when(
    str_detect(x, "^AitzIV") ~ "Aitzbitarte IV",
    str_detect(x, "^AitzV")  ~ "Aitzbitarte V",
    str_detect(x, "^Alk")    ~ "Alkerdi 1",  # Alkerdi lenago Altxerrigaz ez liateko (Al)!
    str_detect(x, "^Atr")    ~ "Atxurra",
    str_detect(x, "^Ek")     ~ "Ekain",
    str_detect(x, "^Al")     ~ "Altxerri",
    str_detect(x, "^Lum")    ~ "Lumentxa",
    str_detect(x, "^Etx")    ~ "Etxeberri",
    str_detect(x, "^S")      ~ "Santimamiñe",
    TRUE                     ~ "Unknown"
  )
}
coord$Cueva <- factor(detect_cave(coord$GU))

cent_cueva <- coord %>%
  dplyr::group_by(Cueva) %>%
  dplyr::summarise(
    Dim1 = mean(Dim1),
    Dim2 = mean(Dim2),
    .groups = "drop"
  )

# Select GUs (2 modes) -------------------------------------------------------------------------------------------------------------------------------------------

# V (A) MANUAL MODE: Whrite the GU of interest -------------------------------------------------------------------------------------------------------------------

gu_aukeratu <- c()  # Change here !!!. e.g.: gu_aukeratu <- c("Al.C.IV.49", "Etx.I.II.02", "Atr.J.II.16")

# Ʌ (A) MANUAL MODE: Whrite the GU of interest -------------------------------------------------------------------------------------------------------------------

coord$label_GU <- ifelse(coord$GU %in% gu_aukeratu, coord$GU, NA)

# V (B) AUTOMATIC MODE: select extreme GU-s (n = 3 per dim) ------------------------------------------------------------------------------------------------------

if (length(gu_aukeratu) == 0) {
  n_ext <- 3
  ext_GU <- unique(c(
    coord %>% arrange(Dim1) %>% slice_head(n = n_ext) %>% pull(GU),
    coord %>% arrange(desc(Dim1)) %>% slice_head(n = n_ext) %>% pull(GU),
    coord %>% arrange(Dim2) %>% slice_head(n = n_ext) %>% pull(GU),
    coord %>% arrange(desc(Dim2)) %>% slice_head(n = n_ext) %>% pull(GU)
  ))
  coord$label_GU <- ifelse(coord$GU %in% ext_GU, coord$GU, NA)
}

# Coordinates of variables (and PLOT) ----------------------------------------------------------------------------------------------------------------------------

var_coord <- as.data.frame(res.famd$var$coord[, 1:2])
var_coord$Aldagaia <- rownames(var_coord)

var_sel <- var_coord %>%
  dplyr::filter(Aldagaia %in% c("DifVal"))

pal <- c("#0073C2FF", "#EFC000FF", "#868686FF", "#CD534CFF")

p <- ggplot(coord, aes(Dim1, Dim2, color = cluster)) +
  geom_point(size = 1.2, alpha = 0.6) +
    
  stat_ellipse(aes(fill = cluster), geom = "polygon",
               level = 0.9545, alpha = 0.12, color = NA) +
  stat_ellipse(level = 0.9545, linewidth = 0.6) +
  
  ggrepel::geom_text_repel(
    aes(label = label_GU),
    size = 3,
    na.rm = TRUE,
    show.legend = FALSE
  ) +
  
  geom_point(
    data = cent_cueva,
    aes(Dim1, Dim2),
    inherit.aes = FALSE,
    shape = 21,
    size = 4,
    fill = "white",
    color = "black",
    stroke = 1.1
  ) +
  ggrepel::geom_text_repel(
    data = cent_cueva,
    aes(Dim1, Dim2, label = Cueva),
    inherit.aes = FALSE,
    size = 4,
    fontface = "bold",
    color = "black"
  ) +
  
  geom_segment(
    data = var_sel,
    aes(x = 0, y = 0, xend = Dim.1, yend = Dim.2),
    inherit.aes = FALSE,
    arrow = arrow(length = unit(0.25, "cm")),
    linewidth = 1,
    color = "black"
  ) +
  ggrepel::geom_text_repel(
    data = var_sel,
    aes(x = Dim.1, y = Dim.2, label = Aldagaia),
    inherit.aes = FALSE,
    size = 4,
    fontface = "italic",
    color = "black"
  ) +
  
  scale_color_manual(values = pal) +
  scale_fill_manual(values = pal) +
  theme_minimal() +
  labs(
    title = "Factor map",
    x = "Dim1",
    y = "Dim2"
  )

print(p)

# HON BAI AMAITXUTA!!!



