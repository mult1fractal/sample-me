#!/usr/bin/env Rscript

library(ggplot2)

#setwd ("/input")
df <- read.csv(file = 'decision_plot.csv')

p <- ggplot(data=df, aes(x=bin, y=cnt, fill=state)) + 
    geom_bar(stat='identity', position='fill') + 
    theme_minimal() + 
    scale_fill_brewer(palette='Set2') +
    xlab('read length') +
    ylab('fraction')
svg("decision_plot.svg", width = 20, height = 20)
print(p)
dev.off()