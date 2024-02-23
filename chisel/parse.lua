local extract = require "extract"
local cutils = require "cutils"

local PodEventHandler = {}

function PodEventHandler.parse(events, list_pods)
    local podEventsArray = {}
    local podData = {}

    -- Initialize tables for each distinct pod/replica
    for _, pod in ipairs(cutils.get_distinct_items(list_pods)) do
        podData[pod] = {
            timestamp_l = {},
            sys_l = {},
            sys_cat_l = {},
            file_path_l = {},
            file_dir_l = {},
            file_name_l = {},
            file_op_l = {},
            proc_name_l = {},
            proc_cmd_l = {},
            proc_cwd_l = {},
            proc_exe_l = {},
            proc_args_l = {}
        }
    end

    -- Categorize events into the corresponding pod's table
    for _, event in ipairs(events) do
        local pod = event[1]
        local pData = podData[pod]
        if pData then
            table.insert(pData.timestamp_l, event[2])
            table.insert(pData.sys_l, event[3])
            table.insert(pData.sys_cat_l, event[4])

            if event[5] ~= nil then
                table.insert(pData.file_path_l, event[5])
                table.insert(pData.file_dir_l, event[6])
                table.insert(pData.file_name_l, event[7])
                table.insert(pData.file_op_l, event[8])
            end

            table.insert(pData.proc_name_l, event[9])
            table.insert(pData.proc_cmd_l, event[10])
            table.insert(pData.proc_cwd_l, event[11])
            table.insert(pData.proc_exe_l, event[12])
            table.insert(pData.proc_args_l, event[13])
        end
    end

    -- Process and add to the final array
    for pod, data in pairs(podData) do
        local podEvents = extract.extractFeatures(pod, data.timestamp_l, data.sys_l, data.sys_cat_l, data.file_path_l, data.file_dir_l, data.file_name_l, data.file_op_l, data.proc_cmd_l, data.proc_cwd_l, data.proc_name_l, data.proc_args_l, data.proc_exe_l)
        table.insert(podEventsArray, podEvents)
    end

    return podEventsArray
end

return PodEventHandler
