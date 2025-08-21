#!/bin/bash
#SBATCH --time=100:00:00
#SBATCH --mem=10G
#SBATCH --job-name=LIGAND_UNBIND
#SBATCH --ntasks-per-node=10
#SBATCH --gres=gpu:1

module purge
module load Amber

#This intro code is to stip the .0 from the files so that the submission script finds them
for d in $(seq 6.0 0.5 30.0); do
  # Format distance for filename: 6.0 → 6, 6.5 → 6.5
  int_part=$(echo "$d" | cut -d'.' -f1)
  dec_part=$(echo "$d" | cut -d'.' -f2)

  if [ "$dec_part" = "0" ]; then
    d_clean="$int_part"
  else
    d_clean="$int_part.$dec_part"
  fi

  echo ">>> Running for distance $d_clean Å"

  $AMBERHOME/bin/pmemd.cuda -O -i mdin_min.$d_clean  -p complex.prmtop -c post_cmd_prod.rst -r min_$d_clean.rst  -o min_$d_clean.out
  $AMBERHOME/bin/pmemd.cuda -O -i mdin_equi.$d_clean -p complex.prmtop -c min_$d_clean.rst  -r equi_$d_clean.rst -o equi_$d_clean.out
  $AMBERHOME/bin/pmemd.cuda -O -i mdin_prod.$d_clean -p complex.prmtop -c equi_$d_clean.rst -r prod_$d_clean.rst -o prod_$d_clean.out
done

