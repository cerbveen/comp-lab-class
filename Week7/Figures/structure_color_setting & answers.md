color settings in Tif-1
Crystal structure - gray
Greene_Alphafold2 - green
Colab_Alphafold2 - orange
RoseTTAfold - red

Question 1
Using mdtraj, in a jupyter notebook, align your alphafold predictions to the crystal structure and make a bar plot showing the RMSD of each predicted structure to the crystal structure based on alpha-carbons and based on the full backbone and side-chains. Does alphafold get everything right or just the backbone structure? 

Answer
1. Both for Greene_Alphafold2 and Colab_Alphafold2, the RMSDs go like: alpha-carbons (RMSD~0.06) < backbone (RMSD~0.16)< side-chains (RMSD~0.21). The structure of alpha-carbons are the most accurate.
2. For RoseTTAfold, the RMSDs are: alpha-carbons ~ backbone (RMSD~0.8) < side-chains (RMSD~0.18). Both the structure of alpha-carbons and backbones are accurate.

Question 2
From your alphafold greene output, make a picture of your protein colored by PLDDT score (stored in B-factor column), and put it in your figures folder. Which residues should we be confident in?

Answer
1. all the blue parts are of high plDDT scores and are good predictions.
2. From Extensions-Analysis-Sequence Viewer, the residues that we are confident in are 1-46, 50-69, 72-100, 104-127

Question 3
(Bonus) In your jupyter notebook, load the pkl files and get the average PLDDT score for each predicted structure. Make a scatter plot of PLDDT vs RMSD of prediction. Are they correlated in your case?

Answer
1. For Greene_Alphafold2, although the structure (model_2) with highest plDDT score does have lowest RMSDs based on alpha-carbons, backbone, and side chains, other plDDT scores are not well correlated with RMSD
2. For Colab_Alphafold2, the plDDT scores are not correlated with RMSD, and the best structure doen't have lowest RMSDs. 