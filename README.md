# SWaveRIC: Swell & Wind Wave Radar Inversion Code (2 beams from 2 HF radars or from 1 single HF radar)
(see Al-Attabi, Voulgaris and Conley (2020), doi:10.1175/JTECH-D-20-0186.1)  

This is the code described in Al-Attabi et al. (2021) for the inversion of the 2nd-order of a Doppler spectrum from HF radar systems.  It is a HF radar wave inversion technique that treats swell and wind waves separately. Its application requires two Doppler spectra corresponding to two different radar beams; these could be two beams from two different HF radars, or two beams / spectra from a single radar but of different angle (this assumes spatially homogenious wave conditions). 

The wind wave inversion part used in here is very similar to that described in Alattabi et al. (2019) and is coded in WaveRIC. However, the swell inversion part is different (see paper for details); it is based on the Lipa and Barrick (1980) method (referred to as LMP in the paper) and requires 2 Doppler spectra. 

Prior to inversion, the 2nd order Doppler spectrum is separated into the swell and wind wave regions. For each region the inversion takes place separately and then the two (swell and wind wave) inverted spectra are combined to a single wave energy spectrum. The code includes the basic functions and a demo routine that uses the data of events A to H presentd in Al-Attabi et al. (2021) and recreates Figures 14 and 15 in the paper.  These figures might be slightly different (improved) because of a small change in the method used combining the swell and wind inverted spectra when no swell is detected. See comments inside the code for more details.

- Code Citation:  
Zaid Al-Attabi, Douglas Cahl & George Voulgaris, (2021, July 23). Swell Wave Radar Inversion Code (SWaveRIC) V1.0 (Version V1.0). Zenodo. https://doi.org/10.5281/zenodo.5159955

- Method Citation:  
Al-Attabi, Z.R., G. Voulgaris, and D.C. Conley, 2021. Evaluation and Validation of HF Radar Swell and Wind Wave Inversion Method. J. Atmos. Oceanic Technol., https://doi.org/10.1175/JTECH-D-20-0186.1 

Copyright 2021(c) Zaid Al-Attabi, Douglas Cahl, George Voulgaris

RadarSWIC is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.

The files are located in three directories:  

-SWaveRIC  
  It contains the main functions used to run the inversion (ConfigRWIC.m, masterRadarWIC.m, RadarWIC.m);  
  file RWIC_Contents.html contains inflormation about the functions included in the package;  
  master_testing.m is an example using the functions to recreate the wave directions and spectra shown in Al-Attabi et al (2021) for events A to H (see Figures 14 and 15);

- SWaveRIC/lib  
  It contains a number of functions called by the main function

- SWaveRIC/html and WaveRIC/lib/html  
  It contains explanations for each function in html files. These are called from RWIC_Contents.html  

- SWaveRIC/data  
  It contains the data files used by master_testing.m for running examples from the Alattabi et al (2019) paper; Events A to H. It recreates Figure 11 in the paper.

# List of Files  

- Main Functions: 
 
 ConfigRSWIC.m,  
 DemoRadarSWIC.m,  
 masterRadarSWIC.m,  
 RadarSWIC.m.

- Library Functions (../lib):

Bragg_peak          - Bragg_peak.m,   
ConditionDopRSWIC   - ConditionDopRSWIC.m,    
create_2d_spectrum  - create_2d_spectrum.m,   
createfigure4x4     - Auto-generated by MATLAB on 11-Jul-2021 18:21:16,   
createfigure8x2     - Auto-generated by MATLAB on 11-Jul-2021 18:10:32,   
DirFun              - DirFun.m,   
dopLipa_sub         - dopLipa_sub.m,    
dopLipaS            - dopLipaS.m,   
findSNR             - findSNR.m,    
gamma_mm_depth      - gamma_mm_depth,   
Gauss_fit           - Gauss_fit.m,  
hfr_noise           - hfr_noise.m,    
Inverted_2D_DirSpec - Inverted_2D_DirSpec.m,      
PXYint              - PXYint.m,   
PXYsideband         - PXYsideband.m,    
specSwellRSWIC      - specSwellRSWIC.m,   
spectral_noise      - spectral_noise.m,   
specWindRSWIC       - specWindRSWIC.m,    
spreadparam         - spreadparam.m,    
swell_peak          - swell_peak.m,   
swell_singular      - swell_singular.m,    
waveparams          - waveparams.m,   
waveparams3         - waveparams3.m,    
weightf_barrick     - weightf_barrick.m,    
wn2ndRSWIC          - wn2ndRSWIC.m,   
wrap180             - wrap180.m,    
wspecRSWIC_hybrid   - wspecRSWIC_hybrid.m,    

- Data Files (../data):

dop_penper_X.mat   - MAT file with Doppler spectra from stations PEN and PER for event X (=A,B,...,H),  
insitu_X.mat       - MAT file with in-situ wave bouy data for event X (= A,B,...,H),  
X_inv.mat          - MAT file with inverted HF wave data for event X (= A,B,...,H).
