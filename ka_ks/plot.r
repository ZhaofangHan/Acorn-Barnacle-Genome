args <- commandArgs(T)

library(ggplot2)

df <- read.table(file=args[1], header=T)

pdf(file=args[2], width=8, height=4)

ggplot(df, aes(x=Ks, fill=Species, colour=Species)) +
       #geom_histogram(aes(y=..density..), stat="bin", binwidth=0.05, colour="black", fill="white") +
       #geom_density(colour="#FF6666", alpha=.6, fill="#FF6666") +
       geom_density(alpha=.2) +
       scale_color_brewer(palette="Accent") +
       scale_fill_brewer(palette="Accent") +
       theme_classic() +
       facet_grid(Species ~ .) + 
       theme(legend.position="top")

dev.off()
