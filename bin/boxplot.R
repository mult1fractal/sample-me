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
dt <- read.csv(file = 'readcounts.csv', sep = ",")

# Box plot by group with error bars
plot <- ggplot(dt, aes(x = experiment, y = reads, fill= experiment)) + 
  stat_boxplot(geom = "errorbar", # Error bars
               width = 0.25) +    # Bars width
  geom_point(aes(fill = experiment), size = 5, shape = 21, position = position_jitterdodge()) +
  geom_boxplot() 
 
svg("boxplot_readvariation.svg", width = 10, height = 15)
print(plot)

dev.off()



######### IMPROVMENTS
# trimm in the collection script the letters so you can do the y axis with G or M
# not e+10 and stuff

# in a r-docker
# via docker run --rm -it -v $PWD:/input r-base
#install.packages("cowplot")
# install.packages("ggplot2")
# install.packages("viridis")
# install.packages("gridExtra")

# library(ggplot2)
# library(viridis)
# library(gridExtra) #arrangeGrob()

# #docker
# setwd ("/input")
# # my data
# data <- read.table("qc-report.csv", header = TRUE, sep = ";")
# ## quality check that numbers are numbers:
# str(data)

# #plots
# ## theme for all
# uniformtheme <- theme_classic() +
# 		 theme(legend.position="top", legend.direction="vertical", legend.title = element_blank()) +
#   		 theme(axis.title.x=element_blank(),
#         		axis.text.x=element_blank(),
#         		axis.ticks.x=element_blank())
# this_base = "qc-report"
# ## aktuall plots

# p1 <- 	ggplot(data, aes(type, median.read.length, fill=type)) +
# 	geom_boxplot() +
#   	geom_dotplot(binaxis = "y", stackdir = "center") +
#   	ylim(0, 10000) +
# 	ylab("Median read length [bases]") +
#   	uniformtheme 

# p2 <- 	ggplot(data, aes(type, read.length.N50, fill=type)) +
# 	geom_boxplot() +
#   	geom_dotplot(binaxis = "y", stackdir = "center") +
#   	ylim(0, 10000) +
# 	ylab("N50 [bases]") +
#   	uniformtheme

# p3 <- 	ggplot(data, aes(1, median.read.quality, fill=kit)) +
#   	geom_dotplot(binaxis = "y", stackdir = "center") +
# 	ylab("Median read quality [Q score]") +
# 	scale_fill_manual(values=c("#CC6699", "#E69F00")) +
#   	uniformtheme

# p4 <- 	ggplot(data, aes(1, number.of.reads)) +
# 	geom_boxplot() +
#   	geom_dotplot(binaxis = "y", stackdir = "center", fill='darkgrey') +
# 	ylim(0, 12.5) +
# 	ylab("Number of reads [Mio]") +
#   	uniformtheme

# p5 <- 	ggplot(data, aes(1, total.bases)) +
# 	geom_boxplot() +
#   	geom_dotplot(binaxis = "y", stackdir = "center", fill='darkgrey') +
# 	ylim(0, 30) +
# 	ylab("Total sequenced bases [Gb]") +
#   	uniformtheme

# # merge plots
# multi <- arrangeGrob(p3, p4, p5, p1, p2, ncol = 3)
# ggsave(paste0(this_base, ".png"), multi, width = 6, height = 6) 

# print("Done")




