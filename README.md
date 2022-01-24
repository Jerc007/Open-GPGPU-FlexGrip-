## FlexGripPlus

Name of the project: FlexGripPlus

Type: Microarchitectural Open-source General Purpose Graphics Processing Unit (GPGPU)

Author: Josie Esteban Rodriguez Condia

Language: Full VHDL

Target simulator or technology: The model can be ported into any version of ModelSim and Xcelium

Politecnico di Torino, Turin, Italy

Department of Control and Computer Engineering (DAUIN)

Electronic CAD & Reliability Group (CAD Group)

2019

## Description:

The **FlexGripPlus** model is an open-source General Purpose Graphics Processing Unit (GPGPU) fully described in vhdl and implementing the microarchitecture of the [**G80**](https://ieeexplore.ieee.org/document/4523358) architecture by **NVIDIA**. The model was originally developed by the University of Massachusetts and released in 2010 targeting the implementation on Xilinx platforms. 

The current version is built on top and it is an extended version providing additional hardware support and correcting several bugs from the original FlexGrip model. **FlexGripPlus** now supports up to 52 instructions in more than 64 formats. The improved version is fully compatible with the CUDA programming environment under *SM_1.0* compatibility. 

For additional details regarding the internal description, please see the following documentation:


- J. E. R. Condia, B. Du, M. Sonza Reorda and L. Sterpone, *"FlexGripPlus: An improved GPGPU model to support reliability analysis,"* Microelectronics Reliability 109, 113660, 2020


## Quick simulation steps:

Please check the *"FlexGripPlus_4.4"* folder, it contains the whole description of the latest release version of the GPU model.
Follow the next steps if you want to perform an initial simulation of the model:
Steps to perform a simulation of the GPGPU model.

1) Enter in /lib_m and use the command line to launch the next command: 

```vsim -do gpu_compile.tcl```

this will starts the operation of the GUI of modelsim and import all required files for simulating the microarchitectural model.

2) Continue the execution until reach the **DONE** state in the *TB_State_machine* signal. When reached it means that memory results of the operation were correctly stored during simulation.

3) Analyze results ( file *gpgpu_rdata.log*, generated in the same /lib_m folder) or change target application for the simulation. (See steps for changing the application)

## Quick App change steps:

In order to change the application, three elements must be considered in the GPU:
- The instruction memory;
- the data memory;
- the configuration memory.

The instruction memory is named as *TP_instructions.vhd* (located at: RTL/TB/TP)
The *"TP_instructions.vhd"* file includes the assembly isntructions (.SASS) which are supported by the FlexGrip-Plus model. It should be noted that conventional NVCC cuda compilers can be employed under the SM_1.0.

The data memory is named as *global_mem.mif* (located at: RTL/TB/TP)
The *"global_mem.mif"* contains the data elements required by the aplication. If required, this memory must be generated considering the target application.

The configuration memory is named as *pickbench.vhd* (located at: RTL/TB/configuration)
The *"pickbench.vhd"* file contains the configuration parameters required by the model. These are maintained as constants by the lack of a host to control them before a program kernel operation. Check the dedicated manual to select the values of each line in this file.

You need to replace the three files in order to change the target application. Use the files in the Applications folder to set a new application.

Once you change or move new files, you can repeat the launching process and check the simulation of the model.


## Additional documentation:

- J. E. R. Condia, *"New Techniques for On-line Testing and Fault Mitigation in GPUs"*, Politecnico di Torino.

- J. E. R. Condia, F. F. d. Santos, M. Sonza Reorda, P. Rech, *“Combining architectural simulation and software fault injection for a fast and accurate CNNs reliability evaluation on GPUs”*, 39th IEEE VLSI Test Symposium, 2021.

- J. Guerrero-Balaguera, J. E. R. Condia, M. Sonza Reorda, *"On the Functional Test of Special Function Units in GPUs”*, 24th International Symposium on Design and Diagnostics of Electronic Circuits & Systems, 2021.

- J. E. R. Condia, P. Narducci, M. Sonza Reorda, L. Sterpone, *“DYRE: a DYnamic REconfigurable solution to increase GPGPU’s reliability”*, THE JOURNAL OF SUPERCOMPUTING, ISSN 11625–11642, 77, 2021.

- J. E. R. Condia, J. Guerrero-Balaguera, C. Moreno-Manrique, M. Sonza Reorda, *“Design and Verification of an open-source SFU model for GPGPUs”*, Baltic Electronics Conference, 2020.

- J. E. R. Condia, M. Sonza Reorda, *“On the testing of special memories in GPGPUs”*, 26th International Symposium on On-Line Testing and Robust System Design, 2020.

- B. Du, J. E. R. Condia and M. Sonza Reorda, *"An extended model to support detailed GPGPU reliability analysis,"* 14th International Conference on Design & Technology of Integrated Systems In Nanoscale Era (DTIS), 2019.

- B. Du, J. E. Rodriguez Condia, M. Sonza Reorda and L. Sterpone, *"On the evaluation of SEU effects in GPGPUs,"* IEEE Latin American Test Symposium (LATS), 2019.

- K. Andryc, M. Merchant and R. Tessier, *"FlexGrip: A soft GPGPU for FPGAs,"* 2013 International Conference on Field-Programmable Technology (FPT), 2013.

- Andryc, K., Thomas, T., & Tessier, R. (2016). *Soft GPGPUs for embedded FPGAs: An architectural evaluation*, arXiv preprint arXiv:1606.06454.

- Andryc, K., *AN ARCHITECTURE EVALUATION AND IMPLEMENTATION OF A SOFT GPGPU FOR FPGAs*, University of Massachusetts Amherst.



## Acknowledgments:

The **FlexGripPlus** model was developed in the CAD group of Politecnico di Torino, Turin, Italy and supported with funding by the European Comission through the **Horizon 2020 RESCUE-ETN project** under grant 722325. 
For more information: http://rescue-etn.eu/

The Floating Point Unit (FPU) extension and op-codes were developed in cooperation between Politecnico di Torino and the Grenoble Institute of Technology.

The Special Functions Unit (SFU) extension and op-codes were developed in cooperation between Politecnico di Torino and Universidad Pedagogica y Tecnologica de Colombia (UPTC).

[![logo-poli-blu.png](https://i.postimg.cc/tRMFsnD8/logo-poli-blu.png)](https://postimg.cc/kDW2Z40y)

![](https://pbs.twimg.com/profile_images/913684021040893952/GrLIBP1R_400x400.jpg)


