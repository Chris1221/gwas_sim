# Automated GWAS Simulation Pipeline
Simulate a mixed-population GWAS for use in training exercises. 

### Quick start

To simulate the default population (i.e. 4500 CEU, 500 YRI from the Hapmap 3 reference panel), simply clone the directory and invoke `make`, i.e.

```
git clone https://github.com/Chris1221/gwas_sim.git
make
```

This may take a while, and alternatively if you are set up on computer cluster, you may invoke

```
make sub
```

To submit the whole make job as a cluster job.

*Note: The config file lives at `.simrc` and any easy modifications will probably be made in there.*

The combined dataset has the following Manhattan plot and is perfectly seperated through MDS. See `make` targets `assoc` and `mds` to produce the following. 
Manhattan Plot									   |: QQ Plot
:---------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------:
![](https://github.com/Chris1221/gwas_sim/blob/master/diagnostics/dataset.man.png) | ![](https://github.com/Chris1221/gwas_sim/blob/master/diagnostics/mds.png)

### Description of `make` targets.

The program contains several `make` targets with distinct recipies. The file is commented with a more complete description of the options, but a brief explaination is provided below.

Convenience targets: 

- `all`: The default target, starts the simulation assuming no auxilary files are present and runs all the way to the end.
- `git`: If you have [forked the repository](https://github.com/chris1221/gwas_sim#fork-destination-box), this adds and commits new files for you.
- `sub`: Simply submits a cluster job changing to the correct directory and invoking `make`.

Simulation targets:

- `genome_sim`: Downloads the reference panel, extracts the specific files, and uses `hapgen2` to simulate the new genomes into `output/`. Attempts to download files if not present. 
- `gen_to_ped`: Converts the simulated Oxford style genotypes to plink format.
- `format_gen`: Removes excess files generated along the way and formats the output to prepare for the next step. 
- `combine`: Combines all chromosomes together into one (or two) files.
- `package`: Packages all output into a convenience `.tgz` file for sharing. 

Extra targets:

- `assoc`: Runs a typical GWAS on the output and generates diagnostic plots in order to validate the simulation.
- `clean`: Cleans up everything in preparation for a clean run. This will delete reference panels so be careful.

### FAQ

**Q: What exactly are the default settings?**

> A: The pipeline is set up by default to simulate 4500 CEU individuals and 500 YRI individuals on 6 chromosomes (1 - 5) of the human genome build 36 from the HapMap 3 reference populations. 10 causal Loci are simulated, with two being highly divergent between the populations. This should manifest itself when prinicpal components are derived and the populations are split.

**Q: How do I change things to do my own simulation?**

> A: Fork the repository, clone it, and change the relevant code.

**Q: How can I suggest an improvement?**

> A: Please open an issue or a pull request.

