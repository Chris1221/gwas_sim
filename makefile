# This is the GWAS simulator. 
# It takes the form of a simple makefile with multiple targets for the various stages
# of GWAS simulation.
#
# To run the entire program and simulate start to finish, simply call
# 	make
# However, each individual portion may also be called seperately by specifying the target name. E.g.
# 	make QC


### Include the variables declared in .simrc
# 	This replaces the deprecated pre_process make target
#	and allows for easier manipulation of the variables.

include .simrc
export $(shell sed 's/=.*//' .simrc)

### The following are technicalities of the makefile format
#
# 	We declare the various stages of the simulation to be phony targets
# 	which implies that their execution does not rely on specific files being made
# 	as this complicates the simulation.
#
#	Targets do not follow unix variable convention, but rather are lower case 
#	with underscores replacing spaces.
.PHONY: all git genome_sim clean

### Set the shell to enable BASH specific syntax
SHELL := /bin/bash


# For the moment we only want to build the git commit as we test out the individual dependencies
all: git genome_sim 


### GIT Updating for sanity
# 	This rule ensures that changes are synced up to VC at each step. 
# 	Note that this may only be useful if you have executed
# 		git clone 
#	and have your own local repository to hold these files.
#	This also relies on having
#		git
#	installed and configured and a 
#		./.git
#	directory present and configured.
git: 
	git add -A
	git commit -am "Auto update GWAS_SIM, see ChangeLog for more details."		

# !!------------------------------------------!!	
#		!! DEPRECATED !! 
#

### Pre Processing and/or neccessary evils.
# 	This step should always be executed even when you are not building the whole
# 	pipeline. I.e. all targets rely on this one.
# 	
# 	This should be obvious and should always happen, but just in case it doesn't
# 	you should know that this is neccessary.
#
#	I'm not exactly sure why
#		. ./.simrc
#	correctly exports the shell variables and 
#		sh .simrc
#		bash .simrc
#		./.simrc
#	all do not.
#
#	Eventually I may integrate in autoconf and simply call
#		./configure
#	but that is a project for another day.

#pre_process:
#	. ./.simrc

#	
#		!! DEPRECATED !! 
# !!------------------------------------------!!	

### Make from cluster
# 
# 	This is just a helper function to 
# 	build this from the cluster.
sub:
	qsub -N make_from_cluster sh/make_from_cluster.qsub


### Simulate Genomes
#	This is the first step in the simulation pipeline and uses 
#		hapgen2 
#	to simulate genomes.
#
#	Note that we include the binary file configured for unix and mac in 
#		./bin
#	However, should you wish to use a different file, 
genome_sim: 
	
	### First try to download the reference data if it is not there
	#	Download the file
	#	unzip it
	#	split
	# 
	# 	Note that the reference data is not included in the git
	#	directory for portability. 
	
	if [ -e ref/HM3.tgz ]; \
	then \
		echo Youve already downloaded the data; \
	else \
		wget -P ref/ $$ref; \
	fi;

	# If the directory is not already expanded then expand it.
	if [ ! -d ref/HM3 ]; \
		then \
			 tar -C ref -xvzf ref/`basename $$ref` \
			 HM3/YRI.chr{1..5}.hap \
			 HM3/CEU.chr{1..5}.hap \
			 HM3/hapmap3.r2.b36.chr{1..5}.legend \
			 HM3/genetic_map_chr{1..5}_combined_b36.txt; \
	fi;
	
	# Split it into the correct populations that we want 
	# and delete the rest which are unwanted
	#
	# For us currently this is CEU and YRI
	#
	# We will also only take the first chromosome

	# Now use HAPGEN2 to simulate 20,000 unrelated controls for CEU
	# 	Note that I'm hardcoding the HM3 which is not ideal
	#	
	#	Also note that the diesease locus
	#		-dl 
	#	is bogus and this is a workaround to known bug in
	#	hapgen2.
	#
	#	Note also that we must individually simulate the 
	#	chromosomes because we have to input
	#	one bogus loci per chromosome and I had to do this
	#	manually to find one that actually exists.

	# chr1
	$$hapgen2 -m ref/HM3/genetic_map_chr1_combined_b36.txt \
		-l ref/HM3/hapmap3.r2.b36.chr1.legend \
		-h ref/HM3/CEU.chr1.hap \
		-n 4500 0 \
		-dl 744045 1 1.5 2.25 \
		-o output/ceu_chr1; 


	$$hapgen2 -m ref/HM3/genetic_map_chr1_combined_b36.txt \
		-l ref/HM3/hapmap3.r2.b36.chr1.legend \
		-h ref/HM3/YRI.chr1.hap \
		-n 500 0 \
		-dl 744045 1 1.5 2.25 \
		-o output/yri_chr1; 

	# chr2
	$$hapgen2 -m ref/HM3/genetic_map_chr2_combined_b36.txt \
		-l ref/HM3/hapmap3.r2.b36.chr2.legend \
		-h ref/HM3/CEU.chr2.hap \
		-n 4500 0 \
		-dl 18228 1 1.5 2.25 \
		-o output/ceu_chr2; 


	$$hapgen2 -m ref/HM3/genetic_map_chr2_combined_b36.txt \
		-l ref/HM3/hapmap3.r2.b36.chr2.legend \
		-h ref/HM3/YRI.chr2.hap \
		-n 500 0 \
		-dl 18228 1 1.5 2.25 \
		-o output/yri_chr2; 

	# chr3
	$$hapgen2 -m ref/HM3/genetic_map_chr3_combined_b36.txt \
		-l ref/HM3/hapmap3.r2.b36.chr3.legend \
		-h ref/HM3/CEU.chr3.hap \
		-n 4500 0 \
		-dl 44244 1 1.5 2.25 \
		-o output/ceu_chr3; 


	$$hapgen2 -m ref/HM3/genetic_map_chr3_combined_b36.txt \
		-l ref/HM3/hapmap3.r2.b36.chr3.legend \
		-h ref/HM3/YRI.chr3.hap \
		-n 500 0 \
		-dl 44244 1 1.5 2.25 \
		-o output/yri_chr3; 

	# chr4
	$$hapgen2 -m ref/HM3/genetic_map_chr4_combined_b36.txt \
		-l ref/HM3/hapmap3.r2.b36.chr4.legend \
		-h ref/HM3/CEU.chr4.hap \
		-n 4500 0 \
		-dl 63508 1 1.5 2.25 \
		-o output/ceu_chr4; 


	$$hapgen2 -m ref/HM3/genetic_map_chr4_combined_b36.txt \
		-l ref/HM3/hapmap3.r2.b36.chr4.legend \
		-h ref/HM3/YRI.chr4.hap \
		-n 500 0 \
		-dl 63508 1 1.5 2.25 \
		-o output/yri_chr4; 

	# chr5
	$$hapgen2 -m ref/HM3/genetic_map_chr5_combined_b36.txt \
		-l ref/HM3/hapmap3.r2.b36.chr5.legend \
		-h ref/HM3/CEU.chr5.hap \
		-n 4500 0 \
		-dl 101534 1 1.5 2.25 \
		-o output/ceu_chr5; 


	$$hapgen2 -m ref/HM3/genetic_map_chr5_combined_b36.txt \
		-l ref/HM3/hapmap3.r2.b36.chr5.legend \
		-h ref/HM3/YRI.chr5.hap \
		-n 500 0 \
		-dl 101534 1 1.5 2.25 \
		-o output/yri_chr5; 

### Convert .gen files to .ped 
#	
#	But don't delete them quite yet. 
#	Remove the haps becuase they're useless here.
#
#	Sorry for the weird indenting here, makefiles are stupid.
gen_to_ped: genome_sim

	for chr in 1 2 3 4 5; do \
		$$plink --oxford-single-chr $$chr --gen output/ceu_chr$$chr.controls.gen --sample output/ceu_chr$$chr.controls.sample --make-bed --out output/ceu_chr$$chr; \
	done

	for chr in 1 2 3 4 5; do \
		$$plink --oxford-single-chr $$chr --gen output/yri_chr$$chr.controls.gen --sample output/yri_chr$$chr.controls.sample --make-bed --out output/yri_chr$$chr; \
	done

### Merge all the ped files together
#
#
merge_ped: 

	rm output/*.cases.*
	rm output/*.haps
	rm output/*.sample	
	rm output/*.log
	rm output/*.nosex
	rm output/*.summary

	$$plink --merge-list lib/merge_list_ceu.txt --allow-no-sex --recode --out output/ceu 
	$$plink --merge-list lib/merge_list_yri.txt --allow-no-sex --recode --out output/yri 

### Create new phenotypes
#
#
sim_phen:
	Rscript R/phen.R


combine: format_gen
	
	$$plink --file output/ceu \
		--allow-no-sex \
		--assoc \
		--out output/ceu

	$$plink --file output/yri \
		--allow-no-sex \
		--assoc \
		--out output/yri

	Rscript R/assoc.R


### Clean up the generated gen files
#	This step cleans up unneccesary files and formats the output for
#	easy integration into the next portion.
clean_up_gen: genome_sim
	rm -f output/*.cases.*

	

### Cleaning up
# 	This is the general clean which is executed at 
#		make clean
#	and removes files for another run.
#
#	Note that this is NOT data cleaning, but rather following makefile
#	conventions.
clean:
	echo CLEAN
