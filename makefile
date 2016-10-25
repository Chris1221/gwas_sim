# This is the GWAS simulator. 
# It takes the form of a simple makefile with multiple targets for the various stages
# of GWAS simulation.
#
# To run the entire program and simulate start to finish, simply call
# 	make
# However, each individual portion may also be called seperately by specifying the target name. E.g.
# 	make QC


### The following are technicalities of the makefile format
#
# 	We declare the various stages of the simulation to be phony targets
# 	which implies that their execution does not rely on specific files being made
# 	as this complicates the simulation.
#
#	Targets do not follow unix variable convention, but rather are lower case 
#	with underscores replacing spaces.
.PHONY: all git pre_process genome_sim clean

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
pre_process:
	. ./.simrc
	
### Simulate Genomes
#	This is the first step in the simulation pipeline and uses 
#		hapgen2 
#	to simulate genomes.
#
#	Note that we include the binary file configured for unix and mac in 
#		./bin
#	However, should you wish to use a different file, 
genome_sim: pre_process
	
	wget -P ref/ ${ref} || exit 1	



### Cleaning up
# 	This is the general clean which is executed at 
#		make clean
#	and removes files for another run.
#
#	Note that this is NOT data cleaning, but rather following makefile
#	conventions.
clean:
	echo CLEAN
