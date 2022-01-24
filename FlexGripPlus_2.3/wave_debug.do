onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/smp_configuration_en
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/warp_generator_en
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/smp_done
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/smp_cntlr_state_machine
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/clk_in
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/host_reset
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/smp_run_en
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/warp_generator_done
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/warp_scheduler_done
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/threads_per_block_in
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/num_blocks_in
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/shmem_base_addr_in
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/shmem_size_in
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/parameter_size_in
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/gprs_size_in
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/block_x_in
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/block_y_in
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/block_z_in
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/grid_x_in
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/grid_y_in
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/block_idx_in
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/gpgpu_config_reg_cs_out
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/gpgpu_config_reg_rw_out
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/gpgpu_config_reg_adr_out
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/gpgpu_config_reg_rd_data_in
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/shmem_addr_out
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/shmem_wr_en_out
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/shmem_wr_data_out
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/gprs_base_addr_out
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/gprs_reg_num_out
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/gprs_lane_id_out
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/gprs_wr_en_out
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/gprs_wr_data_out
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/warps_per_block_out
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/header_data_i
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/write_data_cnt
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/header_index
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/block_id_calc_en
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/idx_i
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/shmem_param_idx_i
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/block_id_x_o
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/block_id_y_o
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/block_id_calc_valid
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/warps_per_block_en
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/warps_per_block_o
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/warps_per_block_i
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/warps_per_block_dv
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/thread_id_calc_en
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/shmem_addr_i
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/x_indx_i
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/y_indx_i
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/z_indx_i
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/thread_id_o
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/thread_lane_id_o
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/warp_id_o
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/warp_lane_id_o
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/thread_id_i
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/thread_lane_id_i
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/gprs_base_addr_i
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/warp_lane_id_i
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/thread_id_calc_dv
add wave -noupdate -group SMPController /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSMPController/flag
add wave -noupdate /tb_top_level/uGPGPU/uBlockScheduler/block_scheduler_state_machine
add wave -noupdate /tb_top_level/uGPGPU/uBlockScheduler/smp_reset_out
add wave -noupdate /tb_top_level/uGPGPU/uBlockScheduler/smp_en_out
add wave -noupdate /tb_top_level/uGPGPU/uBlockScheduler/rdy
add wave -noupdate /tb_top_level/uGPGPU/uBlockScheduler/kernel_done
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/clk_in
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/host_reset
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/en
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/kernel_blocks_per_core_in
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/kernel_num_gprs_in
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/kernel_shmem_size_in
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/kernel_parameter_size_in
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/kernel_dyn_shmem_size_in
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/kernel_block_x_in
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/kernel_block_y_in
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/kernel_block_z_in
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/kernel_grid_x_in
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/kernel_grid_y_in
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/smp_done_in
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/threads_per_block_out
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/num_blocks_out
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/shmem_base_addr_out
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/shmem_size_out
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/parameter_size_out
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/gprs_size_out
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/block_x_out
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/block_y_out
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/block_z_out
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/grid_x_out
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/grid_y_out
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/block_idx_out
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/shmem_params_out
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/cmem_params_out
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/grid_dimension
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/num_blocks
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/blocks_per_gpgpu
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/blocks_scheduled_cnt
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/threads_per_block_i
add wave -noupdate -group BlockScheduler /tb_top_level/uGPGPU/uBlockScheduler/blocks_remaining
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/en
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/warp_generator_state_machine
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/clk_in
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/host_reset
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/num_blocks_in
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/warps_per_block_in
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/shmem_base_addr_in
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/shmem_size_in
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/gprs_size_in
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/warp_pool_addr_out
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/warp_pool_wr_en_out
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/warp_pool_wr_data_out
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/warp_state_addr_out
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/warp_state_wr_en_out
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/warp_state_wr_data_out
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/fence_regs_cta_id_out
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/fence_regs_cta_id_ld
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/fence_regs_fence_en_out
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/fence_regs_fence_en_ld
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/num_warps_out
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/warp_gen_done
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/stats_reset
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/stats_out
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/block_num_cnt
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/warps_per_block_cnt
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/warp_id_calc_en_i
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/block_num_i
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/shmem_addr_i
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/warp_num_i
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/warp_id_calc_dv_o
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/gprs_base_addr_o
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/warp_id_o
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/warp_id_addr
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/stat_idle_cnt
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/stat_idle_total_cnt
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/stat_proc_cnt
add wave -noupdate -group WarpGenerator /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpGenerator/stat_proc_total_cnt
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/reset
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/pipeline_stall_in
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/pipeline_warpunit_done
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/warp_scheduler_state_machine
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/clk_in
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/host_reset
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/reset
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/en
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/warp_id_in
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/warp_lane_id_in
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/cta_id_in
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/initial_mask_in
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/current_mask_in
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/shmem_base_addr_in
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/gprs_base_addr_in
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/next_pc_in
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/warp_state_in
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/warps_per_block_in
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/warp_pool_addr_out
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/warp_pool_wr_en_out
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/warp_pool_wr_data_out
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/warp_state_addr_out
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/warp_state_wr_en_out
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/warp_state_wr_data_out
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/fence_regs_fence_en_out
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/fence_regs_fence_en_ld
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/fence_regs_cta_id_in
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/fence_regs_fence_en_in
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/warps_done_mask_out
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/stats_reset
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/stats_out
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/pipeline_stall_out
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/warp_checker_state_machine
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/cta_id_mask
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/cta_id_mask_rev
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/fence_id_mask
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/warp_id_addr
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/warp_cntr
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/warps_done_mask
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/stat_idle_cnt
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/stat_idle_total_cnt
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/stat_proc_cnt
add wave -noupdate -group WarpChecker /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpChecker/stat_proc_total_cnt
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_scheduler_reset
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_generator_en
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/pipeline_write_done
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/pipeline_stall_in
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_generator_done
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/pipeline_stall_out
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_scheduler_done
add wave -noupdate -color Red /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/pipeline_warpunit_done
add wave -noupdate -color Red /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/fetch_en
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/smp_run_en
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/clk_in
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/host_reset
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/reset
add wave -noupdate -expand -group WarpSch -color Yellow /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/pipeline_stall_in
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/num_blocks_in
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/num_warps_in
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/gprs_size_in
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/warps_done_mask_in
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/warp_pool_addr_out
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/warp_pool_wr_en_out
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/warp_pool_wr_data_out
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/warp_pool_rd_data_in
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/warp_state_addr_out
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/warp_state_wr_en_out
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/warp_state_wr_data_out
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/warp_state_rd_data_in
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/program_cntr_out
add wave -noupdate -expand -group WarpSch -color Red /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/warp_id_out
add wave -noupdate -expand -group WarpSch -color Red /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/warp_lane_id_out
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/cta_id_out
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/initial_mask_out
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/current_mask_out
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/shmem_base_addr_out
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/gprs_size_out
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/gprs_base_addr_out
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/done
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/pipeline_warpunit_done
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/fetch_en
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/stats_reset
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/stats_out
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/stats_smp_out
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/warp_scheduler_state_machine
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/warp_scheduler_next_state
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/warps_done_mask
add wave -noupdate -expand -group WarpSch -color Red /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/warp_id_cnt
add wave -noupdate -expand -group WarpSch -color Red /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/warp_lane_cnt
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/program_cntr
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/stat_warp_cnt_en
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/stat_single_warp_idle_cnt
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/stat_total_warp_idle_cnt
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/stat_single_warp_proc_cnt
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/stat_total_warp_proc_cnt
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/count_computation_1
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/count_computation_2
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/count_overhead
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/stat_total_cnt
add wave -noupdate -expand -group WarpSch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/uWarpScheduler/stat_idle_cnt
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/clk_in
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/host_reset
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/threads_per_block_in
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/num_blocks_in
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warps_per_block_in
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/shared_mem_base_addr_in
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/shared_mem_size_in
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/gprs_size_in
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/block_x_in
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/block_y_in
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/block_z_in
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/grid_x_in
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/grid_y_in
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/block_idx_in
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_id_in
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_lane_id_in
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/cta_id_in
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/initial_mask_in
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/current_mask_in
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/shmem_base_addr_in
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/gprs_base_addr_in
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/next_pc_in
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_state_in
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/program_cntr_out
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_id_out
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_lane_id_out
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/cta_id_out
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/initial_mask_out
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/current_mask_out
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/shmem_base_addr_out
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/gprs_size_out
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/gprs_base_addr_out
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/num_warps_out
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/stats_reset
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/stats_warp_generator_out
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/stats_warp_scheduler_out
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/stats_warp_checker_out
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/stats_smp_out
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_gen_pool_addr
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_gen_pool_wr_en
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_gen_pool_wr_data
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_gen_state_addr
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_gen_state_wr_en
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_gen_state_wr_data
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/num_warps_d
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_sched_pool_addr
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_sched_pool_wr_en
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_sched_pool_wr_data
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_sched_pool_rd_data
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_sched_state_addr
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_sched_state_wr_en
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_sched_state_wr_data
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_sched_state_rd_data
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_pool_wr_en_a
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_pool_addr_a
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_pool_wr_data_a
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_pool_rd_data_a
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_pool_wr_en_b
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_pool_addr_b
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_pool_wr_data_b
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_pool_rd_data_b
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_state_wr_en_a
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_state_addr_a
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_state_wr_data_a
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_state_rd_data_a
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_state_wr_en_b
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_state_addr_b
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_state_wr_data_b
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_state_rd_data_b
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_gen_fence_regs_rd_cta_id
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_checker_fence_regs_rd_cta_id
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_gen_fence_regs_cta_id_ld
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_gen_fence_regs_wr_cta_id
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_gen_fence_regs_rd_fence_en
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_checker_fence_regs_rd_fence_en
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_gen_fence_regs_fence_en_ld
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_checker_fence_regs_fence_en_ld
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_gen_fence_regs_wr_fence_en
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warp_checker_fence_regs_wr_fence_en
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/fence_regs_rd_cta_id
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/fence_regs_cta_id_ld
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/fence_regs_wr_cta_id
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/fence_regs_rd_fence_en
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/fence_regs_fence_en_ld
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/fence_regs_wr_fence_en
add wave -noupdate -group WarpUnit /tb_top_level/uGPGPU/uStreamingMultiProcessor/uWarpUnit/warps_done_mask_int
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/pipeline_stall_in
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/pass_en
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/fetch_en
add wave -noupdate -color Red /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/pipeline_stall_out
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/pipeline_fetch_done
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/fetch_state_machine
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/reset
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/clk_in
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/program_cntr_in
add wave -noupdate -expand -group Fetch -color Red /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/warp_id_in
add wave -noupdate -expand -group Fetch -color Red /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/warp_lane_id_in
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/cta_id_in
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/initial_mask_in
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/current_mask_in
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/shmem_base_addr_in
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/gprs_size_in
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/gprs_base_addr_in
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/mem_wr_data_a_out
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/mem_addr_a_out
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/mem_wr_en_a_out
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/mem_rd_data_a_in
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/mem_wr_data_b_out
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/mem_addr_b_out
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/mem_wr_en_b_out
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/mem_rd_data_b_in
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/program_cntr_out
add wave -noupdate -expand -group Fetch -color Red /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/warp_id_out
add wave -noupdate -expand -group Fetch -color Red /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/warp_lane_id_out
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/cta_id_out
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/initial_mask_out
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/current_mask_out
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/shmem_base_addr_out
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/gprs_size_out
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/gprs_base_addr_out
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/next_pc_out
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/instruction_out
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/stats_reset
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/stats_out
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/long_instruction_en
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/instruction_i
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/next_pc_i
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/stat_idle_cnt
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/stat_idle_total_cnt
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/stat_proc_cnt
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/stat_proc_total_cnt
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/stat_stall_cnt
add wave -noupdate -expand -group Fetch /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineFetch/stat_stall_total_cnt
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/pipeline_stall_in
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/pipeline_fetch_done
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/pipeline_stall_out
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/pipeline_dec_done
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/dec_state_machine
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/reset
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/clk_in
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/program_cntr_in
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/warp_id_in
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/warp_lane_id_in
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/cta_id_in
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/initial_mask_in
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/current_mask_in
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/shmem_base_addr_in
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/gprs_size_in
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/gprs_base_addr_in
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/next_pc_in
add wave -noupdate -group Decode -color Red /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/instruction_in
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/program_cntr_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/warp_id_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/warp_lane_id_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/cta_id_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/initial_mask_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/current_mask_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/shmem_base_addr_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/gprs_size_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/gprs_base_addr_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/next_pc_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/alu_opcode_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/mov_opcode_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/flow_opcode_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/instr_marker_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/instr_src1_shared_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/instr_src2_const_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/instr_src3_const_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/pred_reg_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/pred_cond_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/set_pred_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/set_pred_reg_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/output_reg_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/write_pred_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/is_signed_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/w32_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/f64_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/saturate_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/abs_saturate_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/cvt_round_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/cvt_type_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/cvt_neg_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/condition_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/addr_hi_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/addr_lo_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/addr_reg_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/addr_incr_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/mov_size_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/alt_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/mem_type_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/sm_type_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/imm_hi_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/addr_imm_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src1_shared_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src1_mem_type_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src2_mem_type_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src3_mem_type_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/dest_mem_type_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src1_mem_opcode_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src2_mem_opcode_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src3_mem_opcode_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/dest_mem_opcode_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src1_neg_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src2_neg_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src3_neg_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/target_addr_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src1_data_type_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src2_data_type_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src3_data_type_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/dest_data_type_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src1_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src2_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src3_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/dest_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/stats_reset
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/stats_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/instr_opcode_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/alu_opcode_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/mov_opcode_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/flow_opcode_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/instr_marker_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/instr_src1_shared_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/instr_src2_const_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/instr_src3_const_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/pred_reg_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/pred_cond_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/set_pred_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/set_pred_reg_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/output_reg_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/write_pred_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/is_signed_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/w32_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/f64_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/saturate_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/abs_saturate_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/cvt_round_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/cvt_type_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/cvt_neg_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/condition_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/addr_hi_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/addr_lo_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/addr_reg_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/addr_incr_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/mov_size_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/mem_type_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/sm_type_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/imm_hi_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/addr_imm_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src1_mem_type_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src2_mem_type_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src3_mem_type_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/dest_mem_type_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src1_mem_opcode_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src2_mem_opcode_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src3_mem_opcode_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/dest_mem_opcode_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src1_neg_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src2_neg_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src3_neg_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/target_addr_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src1_data_type_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src2_data_type_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src3_data_type_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/dest_data_type_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src1_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src2_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src3_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/dest_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/instr_opcode_b
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/instr_subop_b
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/instr_marker_b
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/instr_is_flow_b
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/instr_is_long_b
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/logic_type_b
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/is_carry_b
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/is_full_marker_b
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/addr_hi_i_3
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/src2_use_gather_b
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/reg_to_data_type
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/mov_size_to_data_type
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/data_type_mov_size_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/sm_type_to_data_type
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/cvt_type_to_data_type
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/subop_to_data_type
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/mov_mem_type_i
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/stat_idle_cnt
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/stat_idle_total_cnt
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/stat_proc_cnt
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/stat_proc_total_cnt
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/stat_stall_cnt
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/stat_stall_total_cnt
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/instr_opcode_out
add wave -noupdate -group Decode /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineDecode/instr_subop_out
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pipeline_dec_done
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pipeline_stall_in
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pipeline_stall_out
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pipeline_read_done
add wave -noupdate -color Yellow /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/read_state_machine
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/reset
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/clk_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/warp_id_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/warp_lane_id_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cta_id_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/initial_mask_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/current_mask_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/shmem_base_addr_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gprs_size_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gprs_base_addr_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/next_pc_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/instr_opcode_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/instr_subop_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/alu_opcode_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/flow_opcode_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/mov_opcode_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/instr_marker_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pred_reg_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pred_cond_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/set_pred_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/set_pred_reg_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/write_pred_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/is_signed_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/w32_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/f64_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/saturate_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/abs_saturate_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cvt_round_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cvt_type_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cvt_neg_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/condition_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/addr_hi_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/addr_lo_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/addr_incr_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/mov_size_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/mem_type_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/sm_type_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/imm_hi_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/addr_imm_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_mem_type_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_mem_type_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_mem_type_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/dest_mem_type_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_mem_opcode_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_mem_opcode_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_mem_opcode_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/dest_mem_opcode_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_neg_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_neg_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_neg_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/target_addr_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_data_type_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_data_type_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_data_type_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/dest_data_type_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/dest_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gprs_base_addr_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gprs_reg_num_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gprs_lane_id_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gprs_wr_en_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gprs_wr_data_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gprs_rd_data_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pred_regs_warp_id_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pred_regs_warp_lane_id_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pred_regs_reg_num_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pred_regs_wr_en_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pred_regs_wr_data_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pred_regs_rd_data_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/addr_regs_warp_id_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/addr_regs_warp_lane_id_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/addr_regs_reg_num_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/addr_regs_wr_en_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/addr_regs_wr_data_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/addr_regs_rd_data_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/warp_div_req_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/warp_div_ack_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/warp_div_grant_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/warp_div_stack_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/warp_div_rd_data_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/warp_div_push_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/warp_div_stack_empty
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/shmem_addr_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/shmem_wr_en_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/shmem_wr_data_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/shmem_rd_data_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cmem_addr_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cmem_wr_en_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cmem_wr_data_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cmem_rd_data_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gmem_addr_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gmem_wr_en_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gmem_wr_data_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gmem_rd_data_in
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/warp_id_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/warp_lane_id_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cta_id_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/initial_mask_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/current_mask_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/shmem_base_addr_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gprs_size_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gprs_addr_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/instruction_mask_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/next_pc_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/instr_opcode_type_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/instr_subop_type_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/alu_opcode_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/flow_opcode_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/mov_opcode_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/instr_marker_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/set_pred_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/set_pred_reg_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/write_pred_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/is_full_normal_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/is_signed_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/w32_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/f64_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/saturate_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/abs_saturate_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cvt_round_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cvt_type_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cvt_neg_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/condition_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/addr_hi_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/addr_lo_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/addr_incr_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/mov_size_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/mem_type_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/sm_type_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/addr_imm_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/dest_mem_type_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/dest_mem_opcode_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_neg_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_neg_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_neg_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/target_addr_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/dest_data_type_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/dest_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pred_flags_out
add wave -noupdate -group Read -expand -subitemconfig {/tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/temp_vector_register_out(7) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/temp_vector_register_out(7)(5) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/temp_vector_register_out(7)(4) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/temp_vector_register_out(7)(3) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/temp_vector_register_out(7)(2) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/temp_vector_register_out(7)(1) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/temp_vector_register_out(7)(0) -expand} /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/temp_vector_register_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/stats_reset
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/stats_out
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/current_mask_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/mask_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/addr_reg_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/addr_hi_i_3
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pred_regs_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pred_regs_reg_num
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pred_regs_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pred_regs_wr_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pred_regs_rd_wr_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pred_regs_cntr
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pred_regs_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pred_lut_data_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/instruction_mask_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/warp_id_addr
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/next_pc
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pred_flags_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_gprs_req
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_gprs_ack
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_gprs_ack_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_gprs_grant
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_addr_regs_req
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_addr_regs_ack
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_addr_regs_ack_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_addr_regs_grant
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_pred_regs_req
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_pred_regs_ack
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_pred_regs_ack_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_pred_regs_grant
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_shmem_req
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_shmem_ack
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_shmem_ack_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_shmem_grant
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_cmem_req
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_cmem_ack
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_cmem_ack_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_cmem_grant
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_gmem_req
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_gmem_ack
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_gmem_ack_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/arb_gmem_grant
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gprs_en_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gprs_reg_num_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gprs_data_type_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gprs_mask_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gprs_data_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gprs_rdy_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pred_regs_en_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pred_regs_reg_num_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pred_mask
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pred_regs_data_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/pred_regs_rdy_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/addr_regs_en_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/addr_regs_num_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/addr_regs_data_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/addr_regs_rdy_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/shmem_gprs_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cmem_gprs_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gmem_gprs_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/shmem_gprs_reg_num
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cmem_gprs_reg_num
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gmem_gprs_reg_num
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/shmem_gprs_data_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cmem_gprs_data_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gmem_gprs_data_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/shmem_gprs_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cmem_gprs_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gmem_gprs_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/shmem_gprs_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cmem_gprs_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gmem_gprs_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/shmem_addr_regs_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cmem_addr_regs_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gmem_addr_regs_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/shmem_addr_regs_reg
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cmem_addr_regs_reg
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gmem_addr_regs_reg
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/shmem_addr_regs_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cmem_addr_regs_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gmem_addr_regs_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/shmem_addr_regs_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cmem_addr_regs_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gmem_addr_regs_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/shmem_en_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cmem_en_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gmem_en_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/shmem_rd_wr_type_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/shmem_addr_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/shmem_mask_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/shmem_sm_type_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cmem_rd_wr_type_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cmem_addr_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cmem_mask_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cmem_sm_type_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gmem_wr_data_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gmem_rd_wr_type_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gmem_addr_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gmem_mask_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/shmem_rd_data_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/shmem_rdy_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cmem_rd_data_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/cmem_rdy_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gmem_rd_data_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gmem_rdy_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/gmem_data_type_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_read_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_gprs_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_gprs_reg_num
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_gprs_data_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_gprs_mask
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_gprs_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_gprs_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_addr_regs_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_addr_regs_reg_num
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_addr_regs_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_addr_regs_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_pred_regs_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_pred_regs_reg_num
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_pred_regs_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_pred_regs_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_shmem_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_shmem_addr
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_shmem_sm_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_shmem_rd_wr_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_shmem_mask
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_shmem_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_shmem_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_cmem_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_cmem_addr
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_cmem_sm_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_cmem_rd_wr_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_cmem_mask
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_cmem_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_cmem_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_gmem_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_gmem_addr
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_gmem_rd_wr_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_gmem_data_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_gmem_mask
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_gmem_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_gmem_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_effaddr_gprs_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_effaddr_gprs_reg_num
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_effaddr_gprs_data_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_effaddr_gprs_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_effaddr_gprs_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_effaddr_addr_regs_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_effaddr_addr_regs_reg
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_effaddr_addr_regs_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_effaddr_addr_regs_rdy
add wave -noupdate -group Read -expand -subitemconfig {/tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_data_o(7) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_data_o(6) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_data_o(5) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_data_o(4) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_data_o(3) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_data_o(2) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_data_o(1) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_data_o(0) -expand} /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_data_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_rdy_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_read_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_gprs_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_gprs_reg_num
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_gprs_data_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_gprs_mask
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_gprs_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_gprs_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_addr_regs_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_addr_regs_reg_num
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_addr_regs_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_addr_regs_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_pred_regs_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_pred_regs_reg_num
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_pred_regs_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_pred_regs_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_shmem_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_shmem_addr
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_shmem_sm_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_shmem_rd_wr_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_shmem_mask
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_shmem_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_shmem_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_cmem_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_cmem_addr
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_cmem_sm_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_cmem_rd_wr_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_cmem_mask
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_cmem_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_cmem_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_gmem_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_gmem_addr
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_gmem_rd_wr_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_gmem_data_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_gmem_mask
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_gmem_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_gmem_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_effaddr_gprs_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_effaddr_gprs_reg_num
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_effaddr_gprs_data_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_effaddr_gprs_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_effaddr_gprs_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_effaddr_addr_regs_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_effaddr_addr_regs_reg
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_effaddr_addr_regs_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_effaddr_addr_regs_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_data_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_rdy_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_read_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_gprs_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_gprs_reg_num
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_gprs_data_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_gprs_mask
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_gprs_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_gprs_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_addr_regs_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_addr_regs_reg_num
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_addr_regs_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_addr_regs_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_pred_regs_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_pred_regs_reg_num
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_pred_regs_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_pred_regs_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_shmem_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_shmem_addr
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_shmem_sm_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_shmem_rd_wr_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_shmem_mask
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_shmem_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_shmem_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_cmem_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_cmem_addr
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_cmem_sm_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_cmem_rd_wr_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_cmem_mask
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_cmem_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_cmem_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_gmem_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_gmem_addr
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_gmem_rd_wr_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_gmem_data_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_gmem_mask
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_gmem_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_gmem_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_effaddr_gprs_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_effaddr_gprs_reg_num
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_effaddr_gprs_data_type
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_effaddr_gprs_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_effaddr_gprs_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_effaddr_addr_regs_en
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_effaddr_addr_regs_reg
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_effaddr_addr_regs_rd_data
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_effaddr_addr_regs_rdy
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_data_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_rdy_o
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src1_rdy_reg
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src2_rdy_reg
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/src3_rdy_reg
add wave -noupdate -group Read -expand -subitemconfig {/tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/temp_vector_register_i(7) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/temp_vector_register_i(7)(4) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/temp_vector_register_i(7)(2) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/temp_vector_register_i(7)(0) -expand} /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/temp_vector_register_i
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/stat_idle_cnt
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/stat_idle_total_cnt
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/stat_proc_cnt
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/stat_proc_total_cnt
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/stat_stall_cnt
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/stat_stall_total_cnt
add wave -noupdate -group Read /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/warp_lane_id_i
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/reset
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/clk_in
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/en
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/data_in
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/base_addr_in
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/addr_in
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/mask_in
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/rd_wr_type_in
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/sm_type_in
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/addr_lo_in
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/addr_hi_in
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/addr_imm_in
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/gprs_req_out
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/gprs_ack_out
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/gprs_grant_in
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/gprs_en_out
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/gprs_reg_num_out
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/gprs_data_type_out
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/gprs_rd_data_in
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/gprs_rdy_in
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/addr_regs_req_out
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/addr_regs_ack_out
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/addr_regs_grant_in
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/addr_regs_en_out
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/addr_regs_reg_out
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/addr_regs_rd_data_in
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/addr_regs_rdy_in
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/shmem_addr_out
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/shmem_wr_en_out
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/shmem_wr_data_out
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/shmem_rd_data_in
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/data_out
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/rdy_out
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/shared_memory_cntrl_state_machine
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/addr_reg_i
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/shmem_addr_i
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/shmem_calc_addr_i
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/shmem_wr_en_i
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/shmem_en
add wave -noupdate -group Read-ShmemCtrl -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/offset
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/effective_addr_en
add wave -noupdate -group Read-ShmemCtrl -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/offset_o
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/effective_addr_rdy_o
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/shmem_rd_data
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/shift_i
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/shmem_size
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/shmem_rd_data_o
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/shmem_wr_data_i
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/shmem_rd_wr_done_o
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/shared_mem_rd_wr_cntr
add wave -noupdate -group Read-ShmemCtrl /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uSharedMemoryController/next_read_write_state
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/pipeline_read_done
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/pipeline_stall_in
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/pipeline_execute_done
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/pipeline_stall_out
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/pipeline_execute_state_machine
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/reset
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/clk_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/warp_id_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/warp_lane_id_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/cta_id_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/initial_mask_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/current_mask_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/shmem_base_addr_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gprs_size_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gprs_base_addr_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/instr_mask_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/next_pc_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/instr_opcode_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/instr_subop_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/alu_opcode_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/flow_opcode_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/mov_opcode_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/instr_marker_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/set_pred_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/set_pred_reg_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/write_pred_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/is_signed_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/w32_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/f64_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/saturate_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/abs_saturate_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/cvt_round_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/cvt_type_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/cvt_neg_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/set_cond_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/addr_hi_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/addr_lo_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/addr_incr_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/mov_size_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/mem_type_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/sm_type_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/addr_imm_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/dest_mem_type_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/dest_mem_opcode_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/src1_neg_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/src2_neg_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/src3_neg_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/target_addr_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/dest_data_type_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/src1_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/dest_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/pred_flags_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/temp_vector_register_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/warp_div_req_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/warp_div_ack_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/warp_div_grant_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/warp_div_stack_en_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/warp_div_wr_data_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/warp_div_rd_data_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/warp_div_push_en_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/warp_div_stack_full_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/warp_div_stack_empty_in
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/warp_id_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/warp_lane_id_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/cta_id_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/initial_mask_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/current_mask_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/shmem_base_addr_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gprs_size_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gprs_base_addr_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/instr_mask_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/next_pc_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/warp_state_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/instr_opcode_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/set_pred_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/set_pred_reg_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/write_pred_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/addr_hi_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/addr_lo_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/addr_incr_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/mov_size_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/sm_type_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/addr_imm_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/src1_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/dest_mem_type_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/dest_mem_opcode_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/dest_data_type_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/dest_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/pred_flags_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/temp_vector_register_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/stats_reset
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/stats_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/stats_instructions_out
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/alu_opcode_i
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/branch_exec_en
add wave -noupdate -group Execute -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/sp_carry_o
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/sp_overflow_o
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/sp_sign_o
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/sp_zero_o
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/sp_result_o
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/branch_exec_done
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/initial_mask_o
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/current_mask_o
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/instr_mask_o
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/next_pc_o
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/warp_state_o
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/src1_i
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/src2_i
add wave -noupdate -group Execute -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/src3_i
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/cvt_type_i
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/w32_i
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/is_signed_i
add wave -noupdate -group Execute -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/pred_flags_i
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/mem_type_to_cvt_type_o
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/data_type_i
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/stat_idle_cnt
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/stat_idle_total_cnt
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/stat_proc_cnt
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/stat_proc_total_cnt
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/stat_stall_cnt
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/stat_stall_total_cnt
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/stat_instructions_cnt
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/stat_alu_cnt
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/stat_mov_cnt
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/stat_flow_cnt
add wave -noupdate -group Execute /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/stat_nop_cnt
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/pipeline_execute_done
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/pipeline_stall_in
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/pipeline_stall_out
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/pipeline_write_done
add wave -noupdate /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/write_state_machine
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/reset
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/clk_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/warp_id_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/warp_lane_id_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/cta_id_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/initial_mask_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/current_mask_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_base_addr_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gprs_base_addr_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/next_pc_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/warp_state_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/instr_opcode_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/temp_vector_register_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/dest_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/instruction_mask_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/instruction_flags_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/dest_data_type_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/dest_mem_type_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/dest_mem_opcode_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/addr_hi_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/addr_lo_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/addr_imm_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/addr_inc_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/mov_size_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/write_pred_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/set_pred_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/set_pred_reg_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/sm_type_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gprs_base_addr_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gprs_reg_num_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gprs_lane_id_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gprs_wr_en_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gprs_wr_data_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gprs_rd_data_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/pred_regs_warp_id_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/pred_regs_warp_lane_id_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/pred_regs_reg_num_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/pred_regs_wr_en_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/pred_regs_wr_data_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/pred_regs_rd_data_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/addr_regs_warp_id_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/addr_regs_warp_lane_id_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/addr_regs_reg_num_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/addr_regs_wr_en_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/addr_regs_wr_data_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/addr_regs_rd_data_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_addr_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_wr_en_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_wr_data_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_rd_data_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_addr_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_wr_en_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_wr_data_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_rd_data_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/warp_id_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/warp_lane_id_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/cta_id_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/initial_mask_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/current_mask_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_base_addr_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gprs_addr_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/next_pc_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/warp_state_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/stats_reset
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/stats_out
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/addr_imm_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/inc_addr_en_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/inc_addr_reg_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/inc_addr_data_type_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/inc_addr_mask_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/inc_addr_imm_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/inc_addr_rdy_o
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/compute_pred_data_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/compute_pred_flags_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/compute_pred_data_type_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/compute_pred_flags_o
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gprs_en_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gprs_reg_num_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gprs_wr_data_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gprs_data_type_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gprs_mask_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gprs_rd_wr_en_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gprs_rd_data_o
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gprs_rdy_o
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/write_gprs_en
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/write_gprs_reg_num
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/write_gprs_wr_data
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/write_gprs_data_type
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/write_gprs_mask
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/write_gprs_rd_wr_en
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/write_gprs_rd_data
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/write_gprs_rdy
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_gprs_en
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_gprs_reg_num
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_gprs_wr_data
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_gprs_data_type
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_gprs_rd_data
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_gprs_rdy
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_gprs_en
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_gprs_reg_num
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_gprs_wr_data
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_gprs_data_type
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_gprs_rd_data
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_gprs_rdy
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/addr_regs_en_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/addr_regs_reg_num_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/addr_regs_wr_data_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/addr_regs_mask_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/addr_regs_rd_wr_en_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/addr_regs_rd_data_o
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/addr_regs_rdy_o
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/write_addr_regs_en
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/write_addr_regs_reg_num
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/write_addr_regs_wr_data
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/write_addr_regs_mask
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/write_addr_regs_rd_wr_en
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/write_addr_regs_rd_data
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/write_addr_regs_rdy
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/inc_addr_regs_en
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/inc_addr_regs_reg_num
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/inc_addr_regs_wr_data
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/inc_addr_regs_mask
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/inc_addr_regs_rd_wr_en
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/inc_addr_regs_rd_data
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/inc_addr_regs_rdy
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_addr_regs_en
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_addr_regs_reg_num
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_addr_regs_wr_data
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_addr_regs_rd_wr_en
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_addr_regs_rd_data
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_addr_regs_rdy
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_addr_regs_en
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_addr_regs_reg_num
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_addr_regs_wr_data
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_addr_regs_rd_wr_en
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_addr_regs_rd_data
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_addr_regs_rdy
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/pred_regs_en_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/pred_regs_num_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/pred_regs_wr_data_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/pred_regs_mask_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/pred_regs_rd_wr_en_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/pred_regs_rd_data_o
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/pred_regs_rdy_o
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_en_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_wr_data_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_addr_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_rd_wr_type_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_sm_type_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_mask_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_rd_data_o
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/shmem_rdy_o
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_en_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_wr_data_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_addr_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_rd_wr_type_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_data_type_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_mask_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_rd_data_o
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/gmem_rdy_o
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/mask_i
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/mv_size_to_sm_type_o
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/mv_size_to_data_type_o
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/sm_type_to_data_type_o
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/write_select
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/data_type_in
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/stat_idle_cnt
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/stat_idle_total_cnt
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/stat_proc_cnt
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/stat_proc_total_cnt
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/stat_stall_cnt
add wave -noupdate -group Write /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineWrite/stat_stall_total_cnt
add wave -noupdate -group SharedMemory /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSharedMemory/ce
add wave -noupdate -group SharedMemory /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSharedMemory/clk_a
add wave -noupdate -group SharedMemory /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSharedMemory/rst_a
add wave -noupdate -group SharedMemory /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSharedMemory/addr_a
add wave -noupdate -group SharedMemory /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSharedMemory/din_a
add wave -noupdate -group SharedMemory /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSharedMemory/we_a
add wave -noupdate -group SharedMemory /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSharedMemory/clk_b
add wave -noupdate -group SharedMemory /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSharedMemory/rst_b
add wave -noupdate -group SharedMemory /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSharedMemory/addr_b
add wave -noupdate -group SharedMemory /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSharedMemory/din_b
add wave -noupdate -group SharedMemory /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSharedMemory/we_b
add wave -noupdate -group SharedMemory /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSharedMemory/dout_a
add wave -noupdate -group SharedMemory /tb_top_level/uGPGPU/uStreamingMultiProcessor/uSharedMemory/dout_b
add wave -noupdate -group GlobalMemory /tb_top_level/uGPGPU/uGlobalMemory/ce
add wave -noupdate -group GlobalMemory /tb_top_level/uGPGPU/uGlobalMemory/clk_a
add wave -noupdate -group GlobalMemory /tb_top_level/uGPGPU/uGlobalMemory/rst_a
add wave -noupdate -group GlobalMemory /tb_top_level/uGPGPU/uGlobalMemory/addr_a
add wave -noupdate -group GlobalMemory /tb_top_level/uGPGPU/uGlobalMemory/din_a
add wave -noupdate -group GlobalMemory /tb_top_level/uGPGPU/uGlobalMemory/we_a
add wave -noupdate -group GlobalMemory /tb_top_level/uGPGPU/uGlobalMemory/clk_b
add wave -noupdate -group GlobalMemory /tb_top_level/uGPGPU/uGlobalMemory/rst_b
add wave -noupdate -group GlobalMemory /tb_top_level/uGPGPU/uGlobalMemory/addr_b
add wave -noupdate -group GlobalMemory /tb_top_level/uGPGPU/uGlobalMemory/din_b
add wave -noupdate -group GlobalMemory /tb_top_level/uGPGPU/uGlobalMemory/we_b
add wave -noupdate -group GlobalMemory /tb_top_level/uGPGPU/uGlobalMemory/dout_a
add wave -noupdate -group GlobalMemory /tb_top_level/uGPGPU/uGlobalMemory/dout_b
add wave -noupdate -group TB_Toplevel /tb_top_level/test_bench_state_machine
add wave -noupdate -group TB_Toplevel /tb_top_level/clk_100MHz
add wave -noupdate -group TB_Toplevel /tb_top_level/sys_reset
add wave -noupdate -group TB_Toplevel /tb_top_level/host_reset
add wave -noupdate -group TB_Toplevel /tb_top_level/host_reset_reg
add wave -noupdate -group TB_Toplevel /tb_top_level/kernel_block_x
add wave -noupdate -group TB_Toplevel /tb_top_level/kernel_block_y
add wave -noupdate -group TB_Toplevel /tb_top_level/kernel_block_z
add wave -noupdate -group TB_Toplevel /tb_top_level/kernel_grid_x
add wave -noupdate -group TB_Toplevel /tb_top_level/kernel_grid_y
add wave -noupdate -group TB_Toplevel /tb_top_level/kernel_gprs
add wave -noupdate -group TB_Toplevel /tb_top_level/kernel_shmem_size
add wave -noupdate -group TB_Toplevel /tb_top_level/threads_per_block
add wave -noupdate -group TB_Toplevel /tb_top_level/warps_per_block
add wave -noupdate -group TB_Toplevel /tb_top_level/blocks_per_core
add wave -noupdate -group TB_Toplevel /tb_top_level/block_scheduler_en
add wave -noupdate -group TB_Toplevel /tb_top_level/write_instructions_en
add wave -noupdate -group TB_Toplevel /tb_top_level/write_instructions_done
add wave -noupdate -group TB_Toplevel /tb_top_level/write_instructions_done_reg
add wave -noupdate -group TB_Toplevel /tb_top_level/read_data_en
add wave -noupdate -group TB_Toplevel /tb_top_level/mem_start_addr_i
add wave -noupdate -group TB_Toplevel /tb_top_level/mem_read_size_i
add wave -noupdate -group TB_Toplevel /tb_top_level/read_data_o
add wave -noupdate -group TB_Toplevel /tb_top_level/read_data_rdy_o
add wave -noupdate -group TB_Toplevel /tb_top_level/read_data_done
add wave -noupdate -group TB_Toplevel /tb_top_level/read_data_done_reg
add wave -noupdate -group TB_Toplevel /tb_top_level/smp_done_signal
add wave -noupdate -group TB_Toplevel /tb_top_level/gpgpu_config_cntrl_en
add wave -noupdate -group TB_Toplevel /tb_top_level/gpgpu_config_top_cs
add wave -noupdate -group TB_Toplevel /tb_top_level/gpgpu_config_top_rw
add wave -noupdate -group TB_Toplevel /tb_top_level/gpgpu_config_top_adr
add wave -noupdate -group TB_Toplevel /tb_top_level/gpgpu_config_top_rd_data
add wave -noupdate -group TB_Toplevel /tb_top_level/gpgpu_config_top_wr_data
add wave -noupdate -group TB_Toplevel /tb_top_level/gpgpu_stats_top_cs
add wave -noupdate -group TB_Toplevel /tb_top_level/gpgpu_stats_top_rw
add wave -noupdate -group TB_Toplevel /tb_top_level/gpgpu_stats_top_adr
add wave -noupdate -group TB_Toplevel /tb_top_level/gpgpu_stats_top_rd_data
add wave -noupdate -group TB_Toplevel /tb_top_level/gpgpu_stats_top_wr_data
add wave -noupdate -group TB_Toplevel /tb_top_level/gmem_cntrl_en
add wave -noupdate -group TB_Toplevel /tb_top_level/gmem_wr_data_a
add wave -noupdate -group TB_Toplevel /tb_top_level/gmem_addr_a
add wave -noupdate -group TB_Toplevel /tb_top_level/gmem_wr_en_a
add wave -noupdate -group TB_Toplevel /tb_top_level/gmem_rd_data_a
add wave -noupdate -group TB_Toplevel /tb_top_level/gmem_wr_data_b
add wave -noupdate -group TB_Toplevel /tb_top_level/gmem_addr_b
add wave -noupdate -group TB_Toplevel /tb_top_level/gmem_wr_en_b
add wave -noupdate -group TB_Toplevel /tb_top_level/gmem_rd_data_b
add wave -noupdate -group TB_Toplevel /tb_top_level/cmem_cntrl_en
add wave -noupdate -group TB_Toplevel /tb_top_level/cmem_wr_data_a
add wave -noupdate -group TB_Toplevel /tb_top_level/cmem_addr_a
add wave -noupdate -group TB_Toplevel /tb_top_level/cmem_wr_en_a
add wave -noupdate -group TB_Toplevel /tb_top_level/cmem_rd_data_a
add wave -noupdate -group TB_Toplevel /tb_top_level/cmem_wr_data_b
add wave -noupdate -group TB_Toplevel /tb_top_level/cmem_addr_b
add wave -noupdate -group TB_Toplevel /tb_top_level/cmem_wr_en_b
add wave -noupdate -group TB_Toplevel /tb_top_level/cmem_rd_data_b
add wave -noupdate -group TB_Toplevel /tb_top_level/sysmem_cntrl_en
add wave -noupdate -group TB_Toplevel /tb_top_level/sysmem_wr_data_a
add wave -noupdate -group TB_Toplevel /tb_top_level/sysmem_addr_a
add wave -noupdate -group TB_Toplevel /tb_top_level/sysmem_wr_en_a
add wave -noupdate -group TB_Toplevel /tb_top_level/sysmem_rd_data_a
add wave -noupdate -group TB_Toplevel /tb_top_level/sysmem_wr_data_b
add wave -noupdate -group TB_Toplevel /tb_top_level/sysmem_addr_b
add wave -noupdate -group TB_Toplevel /tb_top_level/sysmem_wr_en_b
add wave -noupdate -group TB_Toplevel /tb_top_level/sysmem_rd_data_b
add wave -noupdate -group TB_Toplevel /tb_top_level/cmem_reg_cs
add wave -noupdate -group TB_Toplevel /tb_top_level/cmem_reg_rw
add wave -noupdate -group TB_Toplevel /tb_top_level/cmem_reg_adr
add wave -noupdate -group TB_Toplevel /tb_top_level/cmem_reg_wr_data
add wave -noupdate -group TB_Toplevel /tb_top_level/cmem_reg_rd_data
add wave -noupdate -group TB_Toplevel /tb_top_level/kernel_reg_cs
add wave -noupdate -group TB_Toplevel /tb_top_level/kernel_reg_rw
add wave -noupdate -group TB_Toplevel /tb_top_level/kernel_reg_adr
add wave -noupdate -group TB_Toplevel /tb_top_level/kernel_reg_wr_data
add wave -noupdate -group TB_Toplevel /tb_top_level/kernel_reg_rd_data
add wave -noupdate -group TB_Toplevel /tb_top_level/cmem_param_size
add wave -noupdate -group TB_Toplevel /tb_top_level/kernel_param_size
add wave -noupdate -group TB_Toplevel /tb_top_level/kernel_params_cnt
add wave -noupdate -group TB_Toplevel /tb_top_level/cmem_params_cnt
add wave -noupdate -group TB_Toplevel /tb_top_level/kernel_done
add wave -noupdate -group TB_Toplevel /tb_top_level/kernel_done_reg
add wave -noupdate -group TB_Toplevel /tb_top_level/gpgpu_statistics
add wave -noupdate -group TB_Toplevel /tb_top_level/gpgpu_stats_cnt
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/alu_opcode_in
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/instr_subop_in
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/src1_in
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/src2_in
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/src3_in
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/src1_neg_in
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/src2_neg_in
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/src3_neg_in
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/carry_in
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/saturate_in
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/w32_in
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/is_signed_in
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/abs_saturate_in
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/cvt_neg_in
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/cvt_type_in
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/set_cond_in
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/carry_out
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/overflow_out
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/sign_out
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/zero_out
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/result_out
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/srca_i
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/srcb_i
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/srca_iaddsub_i
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/srcb_iaddsub_i
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/src_a_neg_i
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/src_b_neg_i
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/src_c_neg_i
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/sub_en_i
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/carry_i
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/w32_i
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/is_signed_i
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/saturate_i
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/sum_o
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/carry_o
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/overflow_o
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/product_o
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/sll_o
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/srl_o
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/neg_o
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/and_o
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/or_o
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/xor_o
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/max_o
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/min_o
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/convert_o
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/compute_pred_o
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/sign_o
add wave -noupdate -group Scalar0 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineExecute/gScalarProcessor(0)/uScalarProcessor/zero_o
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/reset
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/clk_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/en
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/instr_opcode_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/alu_opcode_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/instr_marker_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/addr_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/mask_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/addr_reg_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/addr_imm_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/pred_reg_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/mov_size_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/sm_type_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/mem_type_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/imm_hi_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/src_mem_type_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/src_data_type_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/src_mem_opcode_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/dest_mem_type_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/gprs_req_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/gprs_ack_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/gprs_grant_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/addr_regs_req_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/addr_regs_ack_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/addr_regs_grant_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/pred_regs_req_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/pred_regs_ack_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/pred_regs_grant_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/shmem_req_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/shmem_ack_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/shmem_grant_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/cmem_req_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/cmem_ack_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/cmem_grant_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/gmem_req_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/gmem_ack_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/gmem_grant_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/effaddr_gprs_req_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/effaddr_gprs_ack_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/effaddr_gprs_grant_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/effaddr_addr_regs_req_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/effaddr_addr_regs_ack_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/effaddr_addr_regs_grant_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/gprs_en_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/gprs_reg_num_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/gprs_data_type_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/gprs_mask_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/gprs_rd_data_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/gprs_rdy_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/addr_regs_en_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/addr_regs_reg_num_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/addr_regs_rd_data_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/addr_regs_rdy_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/pred_regs_en_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/pred_regs_reg_num_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/pred_regs_rd_data_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/pred_regs_rdy_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/shmem_en_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/shmem_addr_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/shmem_rd_wr_type_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/shmem_sm_type_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/shmem_mask_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/shmem_rd_data_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/shmem_rdy_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/cmem_en_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/cmem_addr_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/cmem_rd_wr_type_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/cmem_sm_type_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/cmem_mask_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/cmem_rd_data_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/cmem_rdy_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/gmem_en_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/gmem_addr_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/gmem_rd_wr_type_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/gmem_data_type_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/gmem_mask_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/gmem_rd_data_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/gmem_rdy_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/effaddr_gprs_en_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/effaddr_gprs_reg_num_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/effaddr_gprs_data_type_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/effaddr_gprs_rd_data_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/effaddr_gprs_rdy_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/effaddr_addr_regs_en_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/effaddr_addr_regs_reg_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/effaddr_addr_regs_rd_data_in
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/effaddr_addr_regs_rdy_in
add wave -noupdate -expand -group ReadOps1 -expand -subitemconfig {/tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/data_out(7) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/data_out(6) -expand} /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/data_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/rdy_out
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/read_source_ops_state_machine
add wave -noupdate -expand -group ReadOps1 -expand -subitemconfig {/tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/data_o(7) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/data_o(6) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/data_o(5) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/data_o(4) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/data_o(3) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/data_o(2) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/data_o(1) -expand /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/data_o(0) -expand} /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/data_o
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/addr_int
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/imm_hi_shift
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/imm_addr_int
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/addr_reg_num_i
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/sm_type_int
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/data_type_int
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/data_type_to_sm_type_o
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/sm_type_to_sm_type_o
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/mem_type_to_sm_type_o
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/mv_size_to_data_type_o
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/effaddr_en_i
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/effaddr_rdy_o
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/effaddr_addr_o
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/calc_data_type_i
add wave -noupdate -expand -group ReadOps1 /tb_top_level/uGPGPU/uStreamingMultiProcessor/uPipelineRead/uReadSource1/calc_addr_o
add wave -noupdate -group SysMem /tb_top_level/uGPGPU/uSystemMemoryController/clk_in_a
add wave -noupdate -group SysMem /tb_top_level/uGPGPU/uSystemMemoryController/mem_data_in_a
add wave -noupdate -group SysMem /tb_top_level/uGPGPU/uSystemMemoryController/mem_addr_in_a
add wave -noupdate -group SysMem /tb_top_level/uGPGPU/uSystemMemoryController/mem_wr_en_a
add wave -noupdate -group SysMem /tb_top_level/uGPGPU/uSystemMemoryController/mem_data_out_a
add wave -noupdate -group SysMem /tb_top_level/uGPGPU/uSystemMemoryController/clk_in_b
add wave -noupdate -group SysMem /tb_top_level/uGPGPU/uSystemMemoryController/mem_data_in_b
add wave -noupdate -group SysMem /tb_top_level/uGPGPU/uSystemMemoryController/mem_addr_in_b
add wave -noupdate -group SysMem /tb_top_level/uGPGPU/uSystemMemoryController/mem_wr_en_b
add wave -noupdate -group SysMem /tb_top_level/uGPGPU/uSystemMemoryController/mem_data_out_b
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7350 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 237
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {6940 ns} {8254 ns}
