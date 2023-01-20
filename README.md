# MiniWECC
**`Under Development`**

Demo for MiniWECC voltage risk assessment.

## Introduction
This repo currently contains 3 demos:

- **`'demo_paper.m'`**: demo for the pipeline of Gaussian process surrogate modeling. More advanced methods (parallel partial Gaussian process) will be used for more complex problems.


- **`'demo1_copula_inference.m'`**: demo for comparing copula inference results based on 720 samples and 360 samples


- **`'demo2_mc_result.m'`**: demo for comparing Monte-Carlo results based on 720 samples and 360 samples


## Requirements

### **`UQLab`**
How to download and install (https://www.uqlab.com/install):
1. Unzip the downloaded zip archive in a folder, say my_UQLab_folder
2. Open MATLAB and select my_UQLab_folder/core as your working directory and type:
```
uqlab_install 
```
### **`MATPOWER`**
How to download and install (https://matpower.org/about/get-started/):
1. Start MATLAB or Octave and change your working directory to the MATPOWER directory you just extracted (the one containing install_matpower.m).
2. Run the installer and follow the directions to add the required directories to your MATLAB or Octave path, by typing: 
```
install_matpower
```

## Folder Tree
```bash
Demo_MiniWECC:.
│  demo1_copula_inference.m                                   # demo 1: comparing copula inference results based on 720 samples and 360 samples
│  demo2_mc_result.m                                          # demo 2: comparing Monte-Carlo results based on 720 samples and 360 samples
│  demo_paper.m                                               # demo: demo for the pipeline of Gaussian process surrogate modeling
│  
├─data:                                                       # original load data, load ratio data, and generator data
│      gen_data_for_30days_starting_at_20180729_15.csv
│      load_data_for_30days_starting_at_20180729_15.csv
│      Load_ratio1-m.csv
│      
├─plot
│	......
│          
├─power_system                                                # .m file for matpower, containing system information
│      WECC240_HS_2018_Basecase.m
│      WECC240_HS_2018_Basecase_modified.m
│      
├─save                                                        # pre-processed data and pre-trained model
│      data_all.mat
│      demo_paper.mat
│      demo_v1.mat
│      demo_v2.mat
│      Input_infer.mat
│      Input_infer_360.mat
│      
│                  
└─utility                                                     # tools and functions
        construct_krig.m
        get_input_infer.m
        kldiv.m
        solver_wecc.m
        uq_fit.m
        v2struct.m
```
        
