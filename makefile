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
.PHONY: all git genome_sim clean

# For the moment we only want to build the git commit as we test out the individual dependencies
all: git genome_sim

git: 
	git add -A
	git commit -am "Auto update GWAS_SIM, see ChangeLog for more details."

genome_sim:
	echo TEST

clean:
	echo CLEAN
