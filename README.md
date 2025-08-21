# Umbrella-Sampling-using-Amber
Umbrella Sampling Setup using **Distance** or **Dihedral Angle** restraints using Amber 2022 and a Python code for PMF analysis is provided (can be also done using WHAM).
You will need to minimize, equilibrate and relax the system at defined parameters before initiating Umbrella sampling (short classical MD production run with no restraints).
Then you will need to calculate the initial coordinates between the ligand and the anchor residue (can be an atom in each or COM distance between them).
Based on the initial coordinates and your simulation purposes, edit the starting parameters in the perl files. Here, we are running ligand unbinding using distance restraints (an example file of dihedral angle restraint is also provided).
