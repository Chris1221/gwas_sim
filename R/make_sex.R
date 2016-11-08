sex <- data.frame(FID = c(paste0("ID_ceu_", 1:4500),
			  paste0("ID_yri_", 1:500)),
		  IID = c(paste0("ID_ceu_", 1:4500),
			  paste0("ID_yri_", 1:500)),
		  SEX = 1+rbinom(5000, 1, 0.5)) 

write.table(sex, file = "tmp/sex.txt", row.names = F, col.names = T, quote = F)

			  
