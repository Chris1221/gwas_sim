# Read in gen files, assign a phenotype to each of them, select the top X, 
# and write back out.

# Loop through gens 1 to 10

library(data.table)
library(dplyr)
library(magrittr)

#' @title Make a phenotype vector from a gen file and a vector of effects for chosen SNPs
#' @param gen gen fiels passed from fread
#' @param snps path to list of causal SNPs
#' @param nc DEPRECATED
#' @param effects vector of effects (population specific)
#' @return A vector of phenotypes
phen <- function(gen, snps, nc, effects){

	snps <- fread(snps, h = F)

	# Okay now i need to subset the gen to get the snps
	# so subset the index (column 2) 

	subset_gen <- as.data.frame(gen[which(gen$V2 %in% snps$V1),])

	# Assign phenotype based on weighted sum of alleles

	phenotype_matrix <- matrix(ncol = ((ncol(subset_gen) - 5) / 3), nrow = nrow(snps))

	for(i in seq(6, ncol(subset_gen), by = 3)){

		for(j in 1:nrow(snps)){

			phenotype_matrix[j, i/3 - 1] <- 0*subset_gen[j, i] + effects[j]*subset_gen[j, i+1] + 2*effects[j]*subset_gen[j,i+2]


		}
		message(i)
	}

	phenotypes = colSums(phenotype_matrix)

	phenotypes = phenotypes + rnorm(length(phenotypes))
	
	return(phenotypes)
}

#' @title Make a .sample file from a phenotype and a genotype
#' @param phen Phenotype vector, maybe passed from \code{phen}
#' @param file Path to output file.
#' @return Nothing. Writes a file to path. Use magrittr::%T>% to passthrough and still write.
make_sample <- function(phen, file) {

	sample <- data.frame(matrix(ncol = 4, nrow = length(phen)))
	colnames(sample) <- c("ID_1", "ID_2", "missing", "pheno")

	sample$pheno <- phen
	sample$ID_1 <- paste0("ID_", 1:nrow(sample))
	sample$ID_2 <- paste0("ID_", 1:nrow(sample))
	sample$missing <- 0

	header <- data.frame(matrix(ncol = 4, nrow = 1))
	colnames(header) <- c("ID_1", "ID_2", "missing", "pheno")
	header$pheno = "P"
	header$ID_1 = 0
	header$ID_2 = 0
	header$missing = 0
	
	output <- rbind(header, sample)

	write.table(output, file, col.names = T, row.names = F, quote = F, sep = " ")
}


ceu_effects <- c(4,5,5,6,2,1,9,8,2,15)/10
yri_effects <- c(3,5,2,5,20,3,7,8,2,13)/5

fread("output/ceu.controls.gen") %>% 
	phen(snps = "snplist.txt", effects = ceu_effects) %>% 
	make_sample(file = "output/ceu.sample")

fread("output/yri.controls.gen") %>% 
	phen(snps = "snplist.txt", effects = yri_effects) %>% 
	make_sample(file = "output/yri.sample")
