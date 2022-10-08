#!/bin/bash
# JOB HEADERS HERE

#SBATCH --job-name=run-gromace
#SBATCH --nodes=1
#SBATCH --tasks-per-node=48
#SBATCH --mem=8GB
#SBATCH --time=24:00:00
module purge
module load gromacs/openmpi/intel/2020.4
#mpirun -np 1 gmx_mpi grompp -f nvt.mdp -c energy_minim.gro -r energy_minim.gro -p topol.top -o nvt.tpr
#mpirun gmx_mpi mdrun -deffnm nvt
#mpirun -np 1 gmx_mpi grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr
#mpirun gmx_mpi mdrun -deffnm npt
mpirun -np 1 gmx_mpi grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_1.tpr
mpirun gmx_mpi mdrun -deffnm md_0_1
#mpirun -np 1 gmx_mpi grompp -f md_50.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_50_48tasks.tpr
#mpirun gmx_mpi mdrun -deffnm md_0_50_48tasks
