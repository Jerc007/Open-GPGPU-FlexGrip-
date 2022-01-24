## USER MANUAL FOR THE FPU 1.0

Scie Edouard

Grenoble Institute of Technology

2019

# == Content ==               	
                             	
1.0 Description of blocks      
      - fpu_add_32.vhd            
      - fpu_sub_32.vhd           	
      - fpu_mul_32.vhd           	
      - fpu_fma_32.vhd           	
      - fpu_round_32.vhd        
      - fpu_exceptions_32.vhd	    
      - fpu_conv_32.vhd   			  
      - fpu_set_32.vhd    			  
      - fpu_rcp_32.vhd    			  
      - fpu_top_32_new.vhd     	  
      - fpupackage.vhd
2.0 Instruction opcodes        
3.0 Simulation guide           
                              


# == Description of blocks ==


** fpu_add_32.vhd **
This block computes the addition between two POSITIVE floats. P-O-S-I-T-I-V-E! dont even try to add negative there is sub block for that
The process is quite simple :
First the numbers must go through an unpacking operation.
The sign, exponent and mantissa are separated and the implicit 1. is aggregated in front of the mantissa if the number is normalized.
After that the bigger number is determined by comparing the two exponents.
This number will give its exponent and sign to the result and the smaller mantissa is shifted right by the exponent difference.
Now that the mantissas are aligned, it is possible to add both and store the result in a 27 bits word: the result is extended by one bit to the left in case of a carry and two bit to the right for rounding purpose.
At this point if the leftmost bit up a carry has appeared, the result exponent must be refreshed and increased by one and the mantissa shifted right.
This is due to normalization which requires that the number to be represented with the biggest exponent possible.
The same kind of adjustement are also done if the result becomes normalized from denormal operands.
The result is NOT repacked but sent to the round stage in 3 parts .

 ** fpu_sub_32.vhd **
This block computes the subtraction between two floats WITHOUT ANY GIVEN SIGN CONSIDERATION.
Now you should understand why the add block works with positives only: when FADD instruction is scheduled, one of these two blocks is activated depending on the sign of operands in the registers and the options given (+/-).
This has been done because sm_10 dont have a proper FSUB instruction but only FADD + options.
Anyway, the process is extremely similar to the addition:
The sign, exponent and mantissa are separated and the implicit 1. is aggregated in front of the mantissa if the number is normalized.
After that the bigger number is determined by comparing the two exponents and placed first so the operation is always BIG - SMALL.
If needed the sign of the output is changed to match the big one's.
This number will give its exponent and sign to the result and the smaller mantissa is shifted right by the exponent difference.
Now that the mantissas are aligned, it is possible to subtract both and store the result in a 27 bits word: the result is extended by one bit to the left (to match the precedent format) and two bit to the right for rounding purpose.
At this point cancellation may happen and there could be leading zeros in the mantissa, the result exponent must be refreshed and decreased by one and the mantissa shifted left for each zero.
This is due to normalization which requires that the number to be represented as 1.mantissa.
We take care of not shifting so much than the exponent becomes negative. Instead if we reach zero for the exponent, the resutlt is denormal and the mantissa is left with leading zeros.
The same kind of adjustement are also done if the result becomes normalized from denorm operands.
The result is NOT repacked but sent to the round stage.


** fpu_mul_32.vhd **
This block computes the multiplication between two floats.
The process is quite straightforward as multiplicaton is easy for floats:
Classic unpacking... but then exponents are added and mantissas are multiplied and stored in a 48 bits long word.
We count the number of leading zeros in this word and decrease the exponent by the same amount and shift left the mantissa.
A few tests are done to make sure the result is normalized (bc we added both exponent we have to subtract one bias and make sure that the result is still positive).
As usual we keep 27 bits for the final mantissa, all the bits from the 48 bits word that doesnt fit are or-ed to make the Sticky bit (leftmost).
The result is NOT repacked but sent to the round stage.


** fpu_fma_32.vhd **
- visit https://doc.lagout.org/science/0_Computer%20Science/3_Theory/Handbook%20of%20Floating%20Point%20Arithmetic.pdf  p254 for more explanation
Some of the values were changed from the book to make the block work properly

In brief we start by computing the exponent diff C -(A+B) + bias + correction for denormal. In parallel we compute the multiplication of A and B mantissas then place it in a 77 bits long word and shift it right by a fix amount of 27. C's mantissa is placed is also placed in a 77 long word but shifted by an amount depending on the exponent difference (alignement). This is due because the result of the next operation on mantissas is potentially shifted left by 27 so we need to make sure that me do not lost any bits.

Considering the fact that FMA can take operations AB+C , AB-C, -AB+C and -AB-C we compute AB+C, AB-C and -AB+C (the last one -AB-C just required to change the sign of AB+C in the end)
The we choose one of the result depending on the sign of operands and the exponent diff. Tough cases are when AB and C are close to each other because cancellations or carry can appear. This is handled by looking if the first one of the biggest mantissa is still at the same place after computation.  If not the mantissa is shifted left once more and the exponent decreased.
As for multiplication we make sure that there is no zeros in front of the mantissa by shifting left and all remaining bits are or-ed into a sticky bit.
The result is NOT repacked but sent to the round stage.


** fpu_conv_32.vhd **
This block computes conversion between integers and floats, or floats to floats (NEG/ABS instruction).
For convenience it has been designed to work on 1 cycle and has 2 distinct inputs and outputs for ints and floats. This block is not connected to the fpu_round_32.vhd block as it has a different internal format.
/!\ At the time of this was written, conversion from half(16), quarter(8) integer is not always working. CARE FOR .BEXT option /!\  
-For conversion integer to float:
we check for special input 0, if not null we can convert normally.
I found out that one way of converting is shifting out all leading zeros of the integer,
keeping 23 bits + possible or-ed remaining bits for rounding and using them as mantissa,
setting the exponent at 158 - numbers of zeros shifted out.
I believe the value 158 has to be changed for longer/ shorter integers
In case of signed, only a 2's complement is required before doing the conversion.
-For conversion floats to integer:
we check for special inputs as 0, and infinity or negatives when converting to unsigned.
Then we do the reverse operation. The number of leading zeros is 158 - exponent.
The mantissa is put inside a 77 bits long word (to keep remaining bits for rounding) and shifted right by the precedent amount.
In some cases the float is too big to fit inside an integer: exponent > 158, so the integer is set to x'FFFFFFFF .
First 32 bits of the 77-bit longword are the integer, those remaining are used for rounding.
-For conversion float to float NEG:
The sign of the input is not-ed and given to the output.
-For conversion float to float ABS:
The sign of the output is set at '0'.
-For TRSFR (transfer):
output = input, this is ABS instruction without the abs option enabled... (basically a NOP)

** fpu_set_32.vhd **
This block is used for comparison between floats. The related instruction FSET stores the boolean result of the comparison in a predicate register for further usage.
/!\ the output used for predication was copied from the ISET block of the scalar processor : in pipeline_execute.vhd , at the generation of predicate flags,
pred_flags_o(i)(1) is set to '1' when comparison is true else '0'
pred_flags_o(i)(0) is set to '0' when comparison is true else '1'
this is done by copying the first bit (and NOT-first bit) of output of the FPU which gaves x'FFFFFFFF or x'00000000.
/!\
Anyway, the process of comparing floats is not too different from comparing integers. The only specificity is that comparing exponents has priority over the comparison of mantissas.  Both comparisons being simple unsigned/ bit-to-bit tests.

** fpu_rcp_32.vhd **
This block is computing the reciprocal of a floating-point. It is using non-restoring division algorithm based on the implementation done by  http://www.arithmetic-circuits.org/guide2fpga/vhdl_Models/chapter12/fp_div.vhd
Subnormal support has been added has well as modifications to the internal format to match the already present rounding stage. Also the signals for the dividend were deleted as only the reciprocal of a number is computed.
-For normalized numbers, exponent result is set to 2*BIAS – exp (because exponent of 1,0 is BIAS)
The non-restoring divide algorithm provides the mantissa by computing (mantissa of 1,0) / (mantissa of the input).  At each step one bit of the mantissa is computed by :
if MSB(Remainder) = 0
{
	q[i] = +1
	Remainder = Remainder*2 – Divisor
}
else
{
	q[i] = -1
	Remainder = Remainder*2 + Divisor
}

"-1" value are encoded as '0' temporarly so the final step is to translate the quotient written with radix {-1,1} in radix {0,1}.  To do so, it is only required to do :
q = q- not(q)
-For denormal inputs, the exponent is set to 2*BIAS – 1 + #leading zeros of the mantissa. In parallel the mantissa is shifted left by the number of leading zeros. This is done to "normalize" the number before computing the division. Of course a lot of the time the exponent is going to exceed 254 and so the output is directly infinity. If not the mantissa computation can be done similarly and the result sent to rounding.


** fpu_round_32.vhd **
This block computes the rounding of a precedent operation on floats.
It takes the speacial internal format for exponent and mantissa but gives a regular 32 bits float in the end. Inputs are : exponent extended by one bit to the left and mantissa extended by one bit to the left and 2 bits to the right (Round and Sticky bits).
If round to zero is asked, nothing but truncation of the Round and Sticky bits has to be done.
If round to nearest is asked, a few tests are done to determined the closest float.
The rule is :
  Round | Sticky | value
    0  	  |   0  	   |  down
    0  	  |   1    	   |  down
    1 	  |   0    	   |  tie
    1  	  |   1  	   |  up

In case of a tie we check the value of the mantissa LSB and adjust (+1) to make it '0' if needed.
sign, exponent and mantissa are aggregated to form the final result.
CARE : sometimes IEEE seems to not be following this rule so theres is an "error" in the report given by simulation
This block's output can be the output of the FPU if the exception block doesnt raise any flags.


** fpu_exceptions_32.vhd **
This block looks for exceptions aka invalid outputs in parallel of the rounding.
Flags are raised and optional output can be given if an exception is found.
Major ones are: NaNs inputs, operation bewteen infinities, overflow and underflow (exp FF or 00 after computation).


** fpu_top_32_new.vhd **
This block is the top level of the FPU. It manages internal arithmetic blocks and workflow with a finite state machine.
The FSM has 5 stages: IDLE, GRAB, SET, WORK and DONE.
IDLE is doing nothing... it wakes up when the FPU receives an enable signal from the execution pipeline.
During GRAB (1 cycle) the FPU gathers all operands and parameters given by the execution pipeline and stored them.
During SET (2 cycles) the FPU uses given parameters to activate the arithmetic blocks needed and set a counter that represents the number of cycles needed for computation.
To determine wether addition or subtraction should be done, when FADD instruction is received, the values inside the operands and the negative options are used to compute the true values of these operands. If one of the true operands is negative then the sub block is enable instead of the add.
During WORK (multiple cycles) , the FPU waits for the end of the computation in the arithmetic blocks. The counter is incremented each cycles until it reaches the limit set before.
Also rounding and exception blocks' inputs are enabled depending on which block is actually computing. For conversion/comparison no rounding nor exception is done.
During DONE the FPU gathers outputs from rounding and exceptions/ conversion and choses one of them as final output depending on the presence of flags.
It then maintain this output for 2 cycle or until the write stage is ready (stall_in signal).
The FPU then goes back to IDLE and waits until enabled again .























== Instruction opcodes ==

Available instructions are :
			opcode(subopcode)
FADD/32/32I  	1011(000)
FMUL/32/32I		1100(000)
FMAD/32I		1110(000)
F2I			1010(100)
I2F			1010(010)
F2F			1010(111)
FSET(unsure)		1011(011)
RCP(unsure)		1001(000)

The description of bitfield and multiple examples found while playing with CUDA are given in the file opcodes.ods
Instructions FSET and RCP are quiete hard to generate with options so it is not sure that everything has been decoded.

** TO ADD A NEW INSTRUCTIONS **
-Design and add the new blocks in the FPU folder
-Modify gpgpu_compile.tcl with the new paths during compilation
-Add new instructions in gpgpu_package.vhd under alu_opcode_type and alu_opcode_array
-Modify pipeline_decode.vhd to get all sources/options
-Modify pipeline_execute.vhd , stage IDLE, signal fpu_instr, to match instructions name in gpgpu_package with internal name (can be same name but type is different)
 If instructions output uses predicate, modify gPredicateFlags


== Simulation Guide ==

There are two ways to test the FPU. As a standalone, for checking the results precisely and in large amount, or within the GPU, to test the decoding and correct execution of multiple instructions.
Depending on the need different files are used.


$$$ Required files for standalone usage$$$
softfloat.h and softfloat.a (can be obtained by compiling soffloat-3e)
FloatGen.c
FPU_32/VHD folder for the design files
FPU_32/TB folder for the testbenchs files

#compile command of the design in modelsim#
do fpu_compile.tcl.txt
#compile command of the inputs #
gcc  FloatGen.c -L. soffloat.a -o FloatGen.exe

./FloatGen produces :
3 files Floats_inputs_1/2/3.txt which contains random/positive/bounded floats used as inputs, the amount and type can be changed by modifying the file
+ 5 files Sums/Subs/Muls/Mads/RCPs.txt which contains the results of the operation between the files mentionned before
 + 2 files Int_inputs_1/2.txt which contains random unsigned and signed integers
 + 4 files F2U/U2F/S2F/F2S.txt which contains results of the conversion operations (of inputs_1).

When used for simulation, ModelSim needs to run for numbers of entries generated * time of one oeration (can be found in the comment of the testbench).
It will produce VHDL_"operation".txt file which are the results of the operation and Report_"operation".txt which gives a brief report of when and what happen when the software generated results do not match those of the aformentionned file.



$$$ Required files for GPGPU usage $$$
softfloat.h and softfloat.a (can be obtained by compiling soffloat-3e)
mif_gen.c
FlexGrip version including the FPU

#compile command of the design in modelsim#
do gpgpu_compile.tcl
#compile command of the inputs #
gcc  mif_gen.c -L. soffloat.a -o mif_gen.exe

./mif_gen produces :
1 file global_mem.mif which is used to initialize the memory of the GPU
+ 1 file global_mem_gold.mif which contains the same inputs but also the right outputs in the end.

These files have to be put in FlexGrip/GenericDesign/lib
You should produce as many floats for each operands as the number of threads in your GPU and set constant  APPLICATION to what you are doing.
At the moment it is set for a function with 3 inputs and 1 output. If application chosen is not fma the 3rd input will be all zero instead of random numbers to make it clearer.
When finished simulating the GPU produce a file gpu_rdata.log which can be compared with the gold file with the following command:

#compare command #

diff -y --suppress-common-lines gpgpu_rdata.log global_mem_gold.mif


$$$ Aplication specific : Matrix Multiplication $$$
softfloat.h and softfloat.a (can be obtained by compiling soffloat-3e)
MatrixMul.c
FlexGrip version including the FPU with one of the TB provided in GenericDesign/TB/TP and pick_bench set accordingly

./mif_gen produces :
1 file global_mem.mif which is used to initialize the memory of the GPU
+ 1 file global_mem_gold.mif which contains the same inputs but also the right outputs in the end.
+1 file Matrice.txt which prints the 3 matrices in "human readable format"
