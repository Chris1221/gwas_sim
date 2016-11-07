library(qqman)
library(data.table)

ceu <- fread("output/ceu.qassoc", h = T)
yri <- fread("output/yri.qassoc", h = T)
dataset <- fread("output/dataset.qassoc", h = T)

snps <- read.table("lib/snplist.txt", h = F)
snps <- snps$V1

if(!dir.exists("diagnostics")) dir.create("diagnostics")

png('diagnostics/ceu.man.png')
manhattan(ceu, highlight = snps)
dev.off()

png('diagnostics/yri.man.png')
manhattan(yri, highlight = snps)
dev.off()

png('diagnostics/dataset.man.png')
manhattan(dataset, highlight = snps)
dev.off()

png('diagnostics/ceu.qq.png')
qq(ceu$P)
dev.off()

png('diagnostics/yri.qq.png')
qq(yri$P)
dev.off()

png('diagnostics/dataset.qq.png')
qq(dataset$P)
dev.off()

