#!/usr/bin/env Rscript
# in a r-docker
# docker run --rm -it -v $PWD:/input nanozoo/r_ggpubr:0.2.5--4b52011

##not needed
#install.packages("ggplot2")
#install.packages("magrittr")
#install.packages("cowplot")
#install.packages("ggpubr")
#install.packages("viridis")

# to install
#install.packages("reshape2")
#install.packages("viridis")
#install.packages("ggplot2")
#install.packages("colorspace")

#libs
library(ggpubr)
library(viridis)
library(reshape2)
library(ggplot2)
library(viridis)


# inputs
#setwd ("/input")
dt <- read.csv(file = 'genus_plot.csv', sep = ",")
dt2 <- read.csv(file = 'phylum_plot.csv', sep = ",")
dt3 <- read.csv(file = 'species_plot.csv', sep = ",")
dt4 <- read.csv(file = 'class_plot.csv', sep = ",")


#balloon_melted <- melt(dt, id=c("Organism","Abundance"))

# Sizes just for png
#sizew <- ceiling(( ncol(dt) * 200 ) + 4 )
#sizeh <- ceiling(( nrow(dt) * 5 ) + 2 )

options(ggplot2.continuous.colour="viridis")

######################################
####Genus
######################################

##grouped: Case

plot <- ggplot(dt, aes(x = Sample_name, y = Organism)) +
facet_grid( ~ experiment, scales = "free", space = "free") +
theme_light() +
theme(panel.border = element_blank()) + 
labs(y = element_blank(), x="sample") +
geom_point( aes(size=Abundance, colour=Abundance) ) +
scale_size_area(max_size=10) +
labs(size="Abundance\n[%]", colour="Abundance\n[%]") + 
theme(axis.text.x = element_text(angle = 45, hjust = 1))

svg("overview_genus.svg", width = 20, height = 20)
print(plot)

dev.off()

##############################################################

######################################
####Phylum
######################################

##grouped: Case

plot <- ggplot(dt2, aes(x = Sample_name, y = Organism)) +
facet_grid( ~ experiment, scales = "free", space = "free") +
theme_light() +
theme(panel.border = element_blank()) + 
labs(y = element_blank(), x="sample") +
geom_point( aes(size=Abundance, colour=Abundance) ) +
scale_size_area(max_size=10) +
labs(size="Abundance\n[%]", colour="Abundance\n[%]") + 
theme(axis.text.x = element_text(angle = 45, hjust = 1))

svg("overview_phylum.svg", width = 20, height = 20)
print(plot)

dev.off()

##############################################################

######################################
####Species
######################################

##grouped: Case

plot <- ggplot(dt3, aes(x = Sample_name, y = Organism)) +
facet_grid( ~ experiment, scales = "free", space = "free") +
theme_light() +
theme(panel.border = element_blank()) + 
labs(y = element_blank(), x="sample") +
geom_point( aes(size=Abundance, colour=Abundance) ) +
scale_size_area(max_size=10) +
labs(size="Abundance\n[%]", colour="Abundance\n[%]") + 
theme(axis.text.x = element_text(angle = 45, hjust = 1))

svg("overview_species.svg", width = 20, height = 20)
print(plot)

dev.off()

##############################################################

######################################
####Class
######################################

##grouped: Case

plot <- ggplot(dt4, aes(x = Sample_name, y = Organism)) +
facet_grid( ~ experiment, scales = "free", space = "free") +
theme_light() +
theme(panel.border = element_blank()) + 
labs(y = element_blank(), x="sample") +
geom_point( aes(size=Abundance, colour=Abundance) ) +
scale_size_area(max_size=10) +
labs(size="Abundance\n[%]", colour="Abundance\n[%]") + 
theme(axis.text.x = element_text(angle = 45, hjust = 1))

svg("overview_class.svg", width = 20, height = 20)
print(plot)

dev.off()

##############################################################


##############################################################
############### READS heatmap
##############################################################

plot <- ggplot(dt, aes(x = Sample_name, y = Organism)) +
geom_tile(aes(fill = reads)) +
geom_text(aes(label = reads, color="white")) +
theme_light() +
facet_grid( ~ experiment, scales = "free", space = "free") +
theme(panel.border = element_blank()) + 
labs(y = element_blank(), x="sample") +
theme(axis.text.x = element_text(angle = 45, hjust = 1))+
theme(panel.border = element_blank()) +
geom_density(alpha = 0.6) + 
scale_fill_viridis()
svg("overview_reads_genus.svg", width = 20, height = 20)
print(plot)

dev.off()


plot <- ggplot(dt2, aes(x = Sample_name, y = Organism)) +
geom_tile(aes(fill = reads)) +
geom_text(aes(label = reads, color="white")) +
theme_light() +
facet_grid( ~ experiment, scales = "free", space = "free") +
theme(panel.border = element_blank()) + 
labs(y = element_blank(), x="sample") +
theme(axis.text.x = element_text(angle = 45, hjust = 1))+
theme(panel.border = element_blank()) +
geom_density(alpha = 0.6) + 
scale_fill_viridis()
svg("overview_reads_phylum.svg", width = 20, height = 20)
print(plot)

dev.off()


plot <- ggplot(dt3, aes(x = Sample_name, y = Organism)) +
geom_tile(aes(fill = reads)) +
geom_text(aes(label = reads, color="white")) +
theme_light() +
facet_grid( ~ experiment, scales = "free", space = "free") +
theme(panel.border = element_blank()) + 
labs(y = element_blank(), x="sample") +
theme(axis.text.x = element_text(angle = 45, hjust = 1))+
theme(panel.border = element_blank()) +
geom_density(alpha = 0.6) + 
scale_fill_viridis()
svg("overview_reads_species.svg", width = 20, height = 20)
print(plot)

dev.off()


plot <- ggplot(dt4, aes(x = Sample_name, y = Organism)) +
geom_tile(aes(fill = reads)) +
geom_text(aes(label = reads, color="white")) +
theme_light() +
facet_grid( ~ experiment, scales = "free", space = "free") +
theme(panel.border = element_blank()) + 
labs(y = element_blank(), x="sample") +
theme(axis.text.x = element_text(angle = 45, hjust = 1))+
theme(panel.border = element_blank()) +
geom_density(alpha = 0.6) + 
scale_fill_viridis()
svg("overview_reads_class.svg", width = 20, height = 20)
print(plot)

dev.off()