## FlexGripPlus

Politecnico di Torino, Turin, Italy

Department of Control and Computer Engineering (DAUIN)

Electronic CAD & Reliability Group (CAD Group)

2019

Author: Josie Esteban Rodriguez Condia

Name of the project: FlexGripPlus

Type: Microarchitectural Open-source General Purpose Graphics Processing Unit (GPGPU)

Language: Full VHDL

Target simulator or technology: The model can be ported into any version of ModelSim and Xcelium

# Description:

The **FlexGripPlus** model is an open-source General Purpose Graphics Processing Unit (GPGPU) fully described in vhdl and implementing the microarchitecture of the [**G80**](https://ieeexplore.ieee.org/document/4523358) architecture by **NVIDIA**. The model was originally developed by the University of Massachusetts and released in 2010 targeting the implementation on Xilinx platforms. 

The current version is built on top and it is an extended version providing additional hardware support and correcting several bugs from the original FlexGrip model. **FlexGripPlus** now supports up to 52 instructions in more than 64 formats. The improved version is fully compatible with the CUDA programming environment under *SM_1.0* compatibility. 

For additional details regarding the internal description, please see the following documentation:


- J. E. R. Condia, B. Du, M. Sonza Reorda and L. Sterpone, *"FlexGripPlus: An improved GPGPU model to support reliability analysis,"* Microelectronics Reliability 109, 113660, 2020


# Quick simulation steps:

Please check the *"FlexGripPlus_P"* folder, it contains the whole description of the GPU model. 
Follow the next steps if you want to perform an initial simulation of the model:
Steps to perform a simulation of the GPGPU model.

1) Enter in /lib_m and use the command line to launch the next command: 

```vsim -do gpu_compile.tcl```

this will starts the operation of the GUI of modelsim and import all required files for simulating the microarchitectural model.

2) Continue the execution until reach the **DONE** state in the *TB_State_machine* signal. When reached it means that memory results of the operation were correctly stored during simulation.

3) Analyze results or change target application for the simulation. (See steps for changing the application)

# Quick App change steps:

In order to change the application, three elements must be considered in the GPU: The instruction memory, the data memory and the configuration memory.

In the GPU model, the instruction memory is named as *TP_instructions.vhd*
The data memory is named as *global_mem.mif*
The configuration memory is named as *pickbench.vhd*

You need to replace the files in order to change the target application. In this version, the replacement of the application is performed by changing one, or all files which behaves as memory in the model.

The *"TP_instructions.vhd"* file includes the assembly isntructions (.SASS) which are supported by the FlexGrip-Plus model. It should be noted that conventional NVCC cuda compilers can be employed under the SM_1.0.

The *"global_mem.mif"* contains the data elements required by the aplication. If required, this memory must be generated considering the target application.

The *"pickbench.vhd"* file contains the configuration parameters required by the model. These are maintained as constants by the lack of a host to control them before a program kernel operation. Check the dedicated manual to select the values of each line in this file.

Once you change or move new files, you can repeat the launching process and check the simulation of the model.

Other documents of support:


## Additional documentation:


- B. Du, J. E. R. Condia and M. Sonza Reorda, *"An extended model to support detailed GPGPU reliability analysis,"* 14th International Conference on Design & Technology of Integrated Systems In Nanoscale Era (DTIS), Mykonos, Greece, 2019, pp. 1-6.

- B. Du, J. E. Rodriguez Condia, M. Sonza Reorda and L. Sterpone, *"On the evaluation of SEU effects in GPGPUs,"* IEEE Latin American Test Symposium (LATS), Santiago, Chile, 2019, pp. 1-6.

- K. Andryc, M. Merchant and R. Tessier, *"FlexGrip: A soft GPGPU for FPGAs,"* 2013 International Conference on Field-Programmable Technology (FPT), Kyoto, 2013, pp. 230-237.

- Andryc, K., Thomas, T., & Tessier, R. (2016). *Soft GPGPUs for embedded FPGAs: An architectural evaluation*, arXiv preprint arXiv:1606.06454.


## Acknowledgments:

The **FlexGripPlus** model was developed in the CAD group of Politecnico di Torino, Turin, Italy and supported with funding by the European Comission through the **Horizon 2020 RESCUE-ETN project** under grant 722325. 
For more information: http://rescue-etn.eu/

![](https://pbs.twimg.com/profile_images/913684021040893952/GrLIBP1R_400x400.jpg)


