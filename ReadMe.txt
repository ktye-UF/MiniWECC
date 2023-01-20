- This folder will be updated.
- All the demo code and documents can be found in a private Github repository as well. 
Note that the repository is for MiniWECC demo only and will not be used in this project. 
And everything in github and outlook share folders will be uqdated simultaneously.
================Introduction==============
This folder contains 3 demos:
1. 'demo_paper.m': 
	demo for the pipeline of Gaussian process surrogate modeling
2. 'demo1_copula_inference.m': 
	demo for comparing copula inference results based on 720 samples and 360 samples
3. 'demo2_mc_result.m':
	demo for comparing Monte-Carlo results based on 720 samples and 360 samples
Others to be updated:
4. demo for comparing probabilistic results on all 720 samples or clustered data

===============Requirements==============
- UQLab: https: //www.uqlab.com/install
1. Unzip the downloaded zip archive in a folder, say my_UQLab_folder
2. Open MATLAB and select my_UQLab_folder/core as your working directory and type: 
	uqlab_install 

- MATPOWER: https://matpower.org/about/get-started/
1. Start MATLAB or Octave and change your working directory to the MATPOWER directory you just extracted (the one containing install_matpower.m).
2. Run the installer and follow the directions to add the required directories to your MATLAB or Octave path, by typing:  
	install_matpower

===============Folder Tree==============
Demo_MiniWECC:.
│  demo1_copula_inference.m                           	# demo 1: comparing copula inference results based on 720 samples and 360 samples
│  demo2_mc_result.m                                          	# demo 2: comparing Monte-Carlo results based on 720 samples and 360 samples
│  demo_paper.m                                               	# demo: demo for the pipeline of Gaussian process surrogate modeling
│  ReadMe.txt
│  
├─data:                                                       	# original load data, load ratio data, and generator data
│      gen_data_for_30days_starting_at_20180729_15.csv
│      load_data_for_30days_starting_at_20180729_15.csv
│      Load_ratio1-m.csv
│      
├─plot					# figures	
│	......
│          
├─power_system                                                	# .m file for matpower, containing MiniWECC system information
│      WECC240_HS_2018_Basecase.m
│      WECC240_HS_2018_Basecase_modified.m
│      
├─save                                                        	# pre-processed data and pre-trained model
│      data_all.mat
│      demo_paper.mat
│      demo_v1.mat
│      demo_v2.mat
│      Input_infer.mat
│      Input_infer_360.mat
│      
│                  
└─utility                                                     	# tools and functions
        construct_krig.m
        get_input_infer.m
        kldiv.m
        solver_wecc.m
        uq_fit.m
        v2struct.m