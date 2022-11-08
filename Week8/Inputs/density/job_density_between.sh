#!/bin/bash
#SBATCH --job-name=LASSI
#SBATCH --nodes=1
#SBATCH --tasks-per-node=8
#SBATCH --mem=80GB
#SBATCH --time=24:00:00
source /scratch/work/courses/CHEM-GA-2671-2022fa/software/lammps-gcc-30Oct2022/setup_lammps.bash
mpirun lmp -var density 0.95 -in ../2dWCA.in -log log_density_0.95.file