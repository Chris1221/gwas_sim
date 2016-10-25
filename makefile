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
	
	if [ -e ref/`basename $$ref` ]; \
	then \
		echo Youve already downloaded the data; \
	else \
		wget -P ref/ $$ref; \
	fi;

	# If the directory is not already expanded then expand it.
	if [ ! -d ref/HM3 ]; \
		then \
			 tar -C ref -xvzf ref/`basename $$ref` HM3/YRI.chr1.hap HM3/CEU.chr1.hap HM3/hapmap3.r2.b36.chr1.legend HM3/genetic_map_chr1_combined_b36.txt; \
	fi;
	
	# Split it into the correct populations that we want 
	# and delete the rest which are unwanted
	#
	# For us currently this is CEU and YRI
	#
	# We will also only take the first chromosome

	# Now use HAPGEN2 to simulate 20,000 unrelated controls for CEU
	# 	Note that I'm hardcoding the HM3 which is not ideal
	
	$$hapgen2 -m ref/HM3/genetic_map_chr1_combined_b36.txt \
		-l ref/HM3/hapmap3.r2.b36.chr1.legend; \
		-h ref/HM3/YRI.chr1.hap; \
		-n 100 100;


### Cleaning up
# 	This is the general clean which is executed at 
#		make clean
#	and removes files for another run.
#
#	Note that this is NOT data cleaning, but rather following makefile
#	conventions.
clean:
	echo CLEAN
