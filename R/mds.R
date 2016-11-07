library(data.table)

m <- as.matrix(fread("output/dataset.mibs"))
mds <- cmdscale(as.dist(1-m))
k <- c( rep("green",4500) , rep("blue",500) )

png('diagnostics/mds.png')
plot(mds,pch=20,col=k)
dev.off()
