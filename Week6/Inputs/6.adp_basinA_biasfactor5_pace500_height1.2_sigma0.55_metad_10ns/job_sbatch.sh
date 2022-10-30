#!/bin/bash
#SBATCH --job-name=lab6_Lugano
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --mem=80GB
#SBATCH --time=1:00:00
source /scratch/work/courses/CHEM-GA-2671-2022fa/software/gromacs-2019.6-plumedSept2020/bin/GMXRC.bash.modules
mpirun -np 1 gmx_mpi mdrun -s topolA.tpr -nsteps 5000000 -plumed plumed.dat
plumed sum_hills --hills 6.adp_basinA_biasfactor5_pace500_height1.2_sigma0.55_metad_10ns.hills.txt --outfile 6.adp_basinA_biasfactor5_pace500_height1.2_sigma0.55_metad_10ns.fes.dat
plumed sum_hills --hills 6.adp_basinA_biasfactor5_pace500_height1.2_sigma0.55_metad_10ns.hills.txt --stride 100 --mintozero --outfile stride_hills/6.adp_basinA_biasfactor5_pace500_height1.2_sigma0.55_metad_10ns.fes.dat
