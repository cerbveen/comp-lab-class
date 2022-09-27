#!/bin/bash
# JOB HEADERS HERE

#SBATCH --job-name=run-gromace
#SBATCH --nodes=1
#SBATCH --tasks-per-node=4
#SBATCH --mem=8GB
#SBATCH --time=04:00:00
##SBATCH --gres=gpu:1 ## To ask for a gpu, remove #, don't need right now

##unload module
module purge
##load gromacs
module load gromacs/openmpi/intel/2020.4

##generate topology
wget https://files.rcsb.org/download/1AKI.pdb
grep -v HOH 1aki.pdb > 1AKI_clean.pdb
mpirun -np 1 gmx_mpi pdb2gmx -f 1AKI_clean.pdb -o 1AKI_processed.gro -water spc
##15

##define box and solvate
mpirun -np 1 gmx_mpi editconf -f 1AKI_processed.gro -o 1AKI_newbox.gro -c -d 1.0 -bt cubic
mpirun -np 1 gmx_mpi solvate -cp 1AKI_newbox.gro -cs spc216.gro -o 1AKI_solv.gro -p topol.top

##add ions
wget http://www.mdtutorials.com/gmx/lysozyme/Files/ions.mdp
mpirun -np 1 gmx_mpi grompp -f ions.mdp -c 1AKI_solv.gro -p topol.top -o ions.tpr
mpirun -np 1 gmx_mpi genion -s ions.tpr -o 1AKI_solv_ions.gro -p topol.top -pname NA -nname CL -neutral

##energy minimization
wget http://www.mdtutorials.com/gmx/lysozyme/Files/minim.mdp
mpirun -np 1 gmx_mpi grompp -f minim.mdp -c 1AKI_solv_ions.gro -p topol.top -o em.tpr
mpirun -np 1 gmx_mpi mdrun -v -deffnm em
mpirun -np 1 gmx_mpi energy -f em.edr -o potential.xvg
##10 0

##equilibration
wget http://www.mdtutorials.com/gmx/lysozyme/Files/nvt.mdp
mpirun -np 1 gmx_mpi grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr
mpirun -np 1 gmx_mpi mdrun -deffnm nvt
mpirun -np 1 gmx_mpi energy -f nvt.edr -o temperature.xvg
##16 0

wget http://www.mdtutorials.com/gmx/lysozyme/Files/npt.mdp
mpirun -np 1 gmx_mpi grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr
mpirun -np 1 gmx_mpi mdrun -deffnm npt
mpirun -np 1 gmx_mpi energy -f npt.edr -o pressure.xvg
##18 0
mpirun -np 1 gmx_mpi energy -f npt.edr -o density.xvg
##24 0

##production MD
wget http://www.mdtutorials.com/gmx/lysozyme/Files/md.mdp
mpirun -np 1 gmx_mpi grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_1.tpr
mpirun -np 1 gmx_mpi mdrun -deffnm md_0_1
mpirun -np 1 gmx_mpi mdrun -deffnm md_0_1 -nb gpu

##analysis
mpirun -np 1 gmx_mpi trjconv -s md_0_1.tpr -f md_0_1.xtc -o md_0_1_noPBC.xtc -pbc mol -center
##1"protein", 0"system"
mpirun -np 1 gmx_mpi rms -s md_0_1.tpr -f md_0_1_noPBC.xtc -o rmsd.xvg -tu ns
##4"backbone"
mpirun -np 1 gmx_mpi rms -s em.tpr -f md_0_1_noPBC.xtc -o rmsd_xtal.xvg -tu ns
mpirun -np 1 gmx_mpi gyrate -s md_0_1.tpr -f md_0_1_noPBC.xtc -o gyrate.xvg
##1"protein"



mpirun gmx_mpi grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr
mpirun gmx_mpi  mdrun -deffnm npt
mpirun gmx_mpi  grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_1.tpr
mpirun gmx_mpi  mdrun -deffnm md_0_1
#mpirun gmx_mpi  mdrun -deffnm md_0_1 -nb gpu"

#note, srun commnad replaces mpirun for multi node jobs


