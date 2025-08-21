import numpy as np
import glob
import matplotlib.pyplot as plt
from scipy.ndimage import gaussian_filter1d

#Parameters to be editted accordingly
bin_min = 6.0
bin_max = 30.0
num_bins = 50   # fewer bins -> more points per bin
kT = 0.791      # kcal/mol at 300 K
sigma_smooth = 2  # smoothing strength

#Create bins
bins = np.linspace(bin_min, bin_max, num_bins+1)
bin_centers = 0.5*(bins[:-1] + bins[1:])

#Load distance files generated at each window
files = sorted(glob.glob("distance_*.dat"))
files_in_range = []
for f in files:
    try:
        center = float(f.split("_")[1].replace(".dat", ""))
        if bin_min <= center <= bin_max:
            files_in_range.append(f)
    except:
        continue

#Check
#print(f"Using {len(files_in_range)} files from {bin_min} to {bin_max} Å.")

#Build weighted histogram across windows
all_counts = np.zeros(num_bins, dtype=float)

for f in files_in_range:
    data = np.loadtxt(f)
    
    # Optional: apply a simple umbrella weight, assuming harmonic potential
    # w = exp(-0.5*k*(x-x0)^2 / kT)  #approximate weighting
    # k (force constant) and x0 (window center), can be included
    # Here, we just add raw counts
    hist, _ = np.histogram(data, bins=bins)
    all_counts += hist

# Avoid zeros for log
all_counts = np.where(all_counts == 0, 1e-10, all_counts)

#Calculate PMF
prob = all_counts / all_counts.sum()
pmf = -kT * np.log(prob)
pmf -= pmf.min()  # shift minimum to zero

#Smoothing PMF
pmf_smooth = gaussian_filter1d(pmf, sigma=sigma_smooth)

#Plot
plt.figure(figsize=(8,5))
plt.plot(bin_centers, pmf_smooth, lw=2, color='royalblue', label='Smoothed PMF')
plt.xlabel("Distance (Å)", fontsize=14, fontweight='bold')
plt.ylabel("PMF (kcal/mol)", fontsize=14, fontweight='bold')
plt.title("Umbrella Sampling PMF (Smoothed)", fontsize=16)
plt.grid(True)
#plt.ylim(0, 25)
#plt.xticks(np.arange(0, 31, 2)) 
plt.savefig("PMF-plot.png", dpi=300)
#plt.legend()
#plt.show()

