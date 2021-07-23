# SWaveRIC: Swell & Wind Wave Radar Inversion Code (2 beams from 2 HF radars or from 1 single HF radar)
(see Al-Attabi, Voulgaris and Conley (2020), doi:10.1175/JTECH-D-20-0186.1)  

This is the code described in Al-Attabi et al. (2021) for the inversion of the 2nd-order of a Doppler spectrum from HF radar systems.  This is a radar wave inversion technique that treats swell and wind waves separately. Its application requires two Doppler spectra corresponding to two different radar beams (two beams from two different HF radars  or from a single radar). 

Although the wind wave inversion part is identical to that described in Alattabi et al., (2019) and is coded in WaveRIC, the swell inversion part is different. It is based on the Lipa and Barrick (1980) method (referred to as LMP in the paper) and requires 2 Doppler spectra. Prior to the inversion, the 2nd order Doppler spectrum is separated into the swell and wind wave regions. For each region the inversion takes place separately and then the two (swell and wind wave) inverted spectra are combined to a single wave energy spectrum. The code includes the basic functions and a demo routine that uses the data of event A to H (see Al-Attabi et al, 2021) and recreates Figures 14 and 15 in the paper.  These figures might be slightly different (improved) because of a small change in the method used combining the swell and wind inverted spectra when no swell is detected. See comments inside the code for more details.

- Code Citation:  
Zaid Al-Attabi, Douglas Cahl & George Voulgaris, (2021, July 23). Swell Wave Radar Inversion Code (SWaveRIC) V1.0 (Version V1.0). Zenodo. http://doi.org/cc.cccc/zenodo.xxxxxxx

- Method Citation:  
Al-Attabi, Z.R., G. Voulgaris, and D.C. Conley, 2021. Evaluation and Validation of HF Radar Swell and Wind Wave Inversion Method. J. Atmos. Oceanic Technol., https://doi.org/10.1175/JTECH-D-20-0186.1 

Copyright 2021(c) Zaid Alattabi, Douglas Cahl, George Voulgaris

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

List of Files  

Main Functions:  

  ConfigRWIC.m  
  masterRadarWIC.m  
  RadarWIC.m

Library Functions (../lib):

  Bragg_peak.m  
  ConditionDopRWIC.m  
  findSwellRWIC.m  
  Gauss_fit.m  
  hfr_noise.m  
  plot_swell.m  
  plot_wind.m  
  PXYint.m  
  PXYsideband.m  
  specSwellRWIC.m  
  specWindRWIC.m  
  spectral_noise.m  
  waveparams.m  
  weightf_barrick.m  
  wn2ndRWIC.m  
  wspecRWIC.m
