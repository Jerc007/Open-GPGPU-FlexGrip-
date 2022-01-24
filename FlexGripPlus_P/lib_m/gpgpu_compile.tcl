#!/usr/bin/tclsh
set GPGPU_GENERIC_ROOT "../RTL"
quit -sim

exec vlib work
exec vmap gpgpu work

set gpgpu_vhdls [list \
	"# TB - configuration" \
	"$GPGPU_GENERIC_ROOT/TB/configuration/pick_bench.vhd" \
	"# Top-level, reference components" \
	"## Package" \
	"$GPGPU_GENERIC_ROOT/gpgpu_package.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/shift_register.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/effective_address.vhd" \
	"## DP REGISTER FILE" \
	"$GPGPU_GENERIC_ROOT/SMP/dp_regfile.vhd" \
	"## Address, Predicate, Vector(GP) registers" \
	"$GPGPU_GENERIC_ROOT/SMP/address_register_controller.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/address_register_file.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/predicate_register_controller.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/predicate_register_file.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/vector_register_controller.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/vector_register_file.vhd" \
	"## Memory controller" \
	"$GPGPU_GENERIC_ROOT/SMP/memory_controller.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/constant_memory_controller.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/global_memory_controller.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/shared_memory_controller.vhd" \
	"## SMP Controller" \
	"$GPGPU_GENERIC_ROOT/SMP/SMPController/block_id_calc.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/SMPController/thread_id_calc.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/SMPController/warps_per_block_calc.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/SMPController/streaming_multiprocessor_cntlr.vhd" \
	"## Warp Unit" \
	"$GPGPU_GENERIC_ROOT/SMP/WarpUnit/fence_registers.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/WarpUnit/warps_done_mask_LUT.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/WarpUnit/warp_id_calc.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/WarpUnit/warp_generator.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/WarpUnit/warp_scheduler.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/WarpUnit/warp_checker.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/WarpUnit/warp_unit.vhd" \
	"## Pipeline, reference components" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/bshift.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/stack.vhd" \
	"## Pipeline - Fetch" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Fetch/pipeline_fetch.vhd" \
	"## Pipeline - Read" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Read/arbiter.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Read/predicate_lut.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Read/convert_data_types.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Read/calculate_address.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Read/read_source_ops.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Read/pipeline_read.vhd" \
	"## Pipeline - Decode" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Decode/pipeline_decode.vhd" \
	"## Pipeline - Execution - ScalarProcessor" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/ScalarProcessor/shift_logic.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/ScalarProcessor/min_max.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/ScalarProcessor/boolean_functions.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/ScalarProcessor/compute_set_pred_i.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/ScalarProcessor/convert_int_int.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/ScalarProcessor/integer_add_subtract.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/ScalarProcessor/integer_mult_24.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/ScalarProcessor/scalar_processor.vhd" \
	"## Pipeline - Execution - FloatingPointUnit" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/FPU/fpu_add_32.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/FPU/fpu_conv_32.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/FPU/fpu_exceptions_32.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/FPU/fpu_fma_32.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/FPU/fpu_mul_32.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/FPU/fpu_round_32.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/FPU/fpu_sub_32.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/FPU/fpu_set_32.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/FPU/a_s.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/FPU/divisor.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/FPU/fpu_rcp_32.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/FPU/fpu_top_32_new.vhd" \
	"## Pipeline - Execution - SpecialFunctionUnit" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Components/CLZ.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Components/SFU_Exceptions.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/fused_accm_tree/Booth_PP.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/fused_accm_tree/CSA_4_2.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/fused_accm_tree/fused_accum_tree.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C0_cos.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C0_exp.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C0_ln2.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C0_ln2e0.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C0_reci.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C0_reci_sqrt_1_2.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C0_reci_sqrt_2_4.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C0_sin.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C0_sqrt_1_2.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C0_sqrt_2_4.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C1_cos.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C1_exp.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C1_ln2.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C1_ln2e0.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C1_reci.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C1_reci_sqrt_1_2.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C1_reci_sqrt_2_4.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C1_sin.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C1_sqrt_1_2.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C1_sqrt_2_4.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C2_cos.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C2_exp.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C2_ln2.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C2_ln2e0.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C2_reci.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C2_reci_sqrt_1_2.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C2_reci_sqrt_2_4.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C2_sin.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C2_sqrt_1_2.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Single_LUTS/LUT_C2_sqrt_2_4.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/squaring.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/ROM.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/Quadratic_Interpolator/Quadratic_Interpolator.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/sfu.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/SFU/sfu_proc.vhd" \
	"## Pipeline - Execution - RangeReduceOrder" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/RRO/Components/fp_leading_zeros_and_shift.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/RRO/Components/right_shifter.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/RRO/Components/add_sub.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/RRO/Components/multFP.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/RRO/RRO_trig.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/RRO/rro.vhd"\
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/RRO/rro_proc.vhd"\
	"## Pipeline - Execution - Branch" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/branch_exec_unit.vhd" \
	"## Pipeline - Execution" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Execution/pipeline_execute.vhd" \
	"## Pipeline - Write" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Write/compute_pred_flags.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Write/increment_address.vhd" \
	"$GPGPU_GENERIC_ROOT/SMP/Pipeline/Write/pipeline_write.vhd" \
	"## SMP" \
	"$GPGPU_GENERIC_ROOT/SMP/streaming_multiprocessor.vhd" \
	"## Block Scheduler" \
	"$GPGPU_GENERIC_ROOT/block_scheduler.vhd" \
	"## DP RAM (BEHAVIORAL)" \
	"$GPGPU_GENERIC_ROOT/dp_ram.vhd" \
	"## GPGPU Configuration" \
	"$GPGPU_GENERIC_ROOT/gpgpu_configuration.vhd" \
	"## System Memory Controller" \
	"$GPGPU_GENERIC_ROOT/system_memory_cntlr.vhd" \
	"## GPGPU Top Level" \
	"$GPGPU_GENERIC_ROOT/gpgpu_ml605_top_level.vhd" \
	"# TestBench, top-level components" \
	"$GPGPU_GENERIC_ROOT/TB/txt_util.vhd" \
	"$GPGPU_GENERIC_ROOT/TB/read_data.vhd" \
	"$GPGPU_GENERIC_ROOT/TB/write_instructions.vhd" \
    "# TB - TP" \
	"$GPGPU_GENERIC_ROOT/TB/TP/TP_configuration.vhd" \
    "$GPGPU_GENERIC_ROOT/TB/TP/TP_instructions.vhd" \
	"# TB - Benchmark Configuration" \
	"$GPGPU_GENERIC_ROOT/TB/tb_configuration.vhd" \
	"# TB - Top-level" \
	"$GPGPU_GENERIC_ROOT/TB/tb_top_level.vhd" \
]

foreach src $gpgpu_vhdls {
	if [expr {[string first # $src] eq 0}] {puts $src} else {
		#exec >@stdout 2>@stderr
		vcom -64 -2008 -work work $src
	#	vcom +cover=cbesxf -coveropt 1 -64 -2008 -work work $src
	}
}

vsim -64 -voptargs=+acc work.tb_top_level
#vsim -voptargs=+acc work.tb_top_level


do wave_custom_JDGB.do

run -all

quit
