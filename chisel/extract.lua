local cutils = require "cutils"

function extractFeatures(pod, timestamp_l, sys_l, sys_cat_l, file_path_l, file_dir_l, file_name_l, file_op_l, proc_cmd_l, proc_cwd_l, proc_name_l, proc_args_l, proc_exe_l)
        
    local features = {
        -- Metadata
        ["pod_id"] = pod,
        ["begin_time"] = timestamp_l[1],
        ["end_time"] = timestamp_l[#timestamp_l],

        -- Syscall related features
        ["list_distinct_syscalls"] = cutils.get_distinct_items(sys_l),
        ["list_distinct_syscall_category"] = cutils.get_distinct_items(sys_cat_l),

        -- FD related features
        ["list_distinct_directories"] = cutils.get_distinct_items(file_dir_l),
        ["list_distinct_filenames"] = cutils.get_distinct_items(file_name_l),
        ["list_distinct_file_operations"] = cutils.get_distinct_items(file_op_l),

        -- Proc related features
        ["list_distinct_procs"] = cutils.get_distinct_items(proc_name_l),
        ["list_distinct_commands"] = cutils.get_distinct_items(proc_cmd_l),
        ["list_distinct_cwds"] = cutils.get_distinct_items(proc_cwd_l),
        ["list_distinct_args"] = cutils.get_distinct_items(proc_args_l),
        ["list_distinct_exe"] = cutils.get_distinct_items(proc_exe_l)
    }

    return features
end

return {extractFeatures = extractFeatures}