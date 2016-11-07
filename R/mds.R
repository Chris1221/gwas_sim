m <- as.matrix(read.table("output/dataset.mdist"))
mds <- cmdscale(as.dist(1-m))
k <- c( rep("green",4500) , rep("blue",50) )

png('diagnostics/mds.png')
plot(mds,pch=20,col=k)
dev.off()
