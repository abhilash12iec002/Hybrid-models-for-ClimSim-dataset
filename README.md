# Hybrid-models-for-ClimSim-dataset
This includes two hybrid regression algorithms that couple the nature-inspired algorithms Teaching-Learning-Based Optimization (TLBO) and Invasive Weed Optimization (IWO) with fuzzy theory. These algorithms can be applied to any regression task across various application domains, beyond just earth and environmental sciences.

Due to the large size of the data, it is not uploaded along with the code. Kindly download the data from https://www.kaggle.com/competitions/leap-atmospheric-physics-ai-climsim/data

To change the algorithm from IWO to TLBO, please modify line 26 of BioFuzzRegression.m to:

BioFis = TLBO(fis, data, MaxItr, Population);


Citation Request: If you are using this code, please cite the corresponding primary paper. Detailed descriptions of each algorithm can be found in these papers.

1. Nature-inspired optimal tuning of input membership functions of fuzzy inference system for groundwater level prediction. Environmental Modelling & Software (2024): 105995.
2. F-TLBO-ID: Fuzzy fed teaching learning based optimisation algorithm to predict the number of k-barriers for intrusion detection. Applied Soft Computing 151 (2024): 111163.

For any query, please contact to abhilash.singh@ieee.org

Good Luck!!
