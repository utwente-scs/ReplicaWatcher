local fields = require "fields"
local cutils = require "cutils"
local parse = require "parse"
local json = require ('dkjson')

local description = "This chisel helps you obtain events executed by pods/replicas belonging to a Deployment (i.e., Replicaset)"
local short_description = "Obtain pods' events"
local list_of_pods = {}
local events = {}

args = {
    {
        name = "deployment",
        description = "Deployment Name",
        argtype = "string"
    },
    {
        name = "outputfile",
        description = "Output file name",
        argtype = "string"
    }
}

-- Argument notification callback
function on_set_arg(name, val)
    if name == "deployment" then
        deployment = val
    elseif name == "outputfile" then
        output_file = val
    end
    return true
end

-- Initialization callback
function on_init()
    f_pod_name = chisel.request_field(fields.pod_name)
    f_timestamp = chisel.request_field(fields.timestamp)
    f_syscall_name = chisel.request_field(fields.syscall_name)
    f_syscall_category = chisel.request_field(fields.syscall_category)
    f_file_path = chisel.request_field(fields.file_path)
    f_file_name = chisel.request_field(fields.file_name)
    f_file_directory = chisel.request_field(fields.file_directory)
    f_file_operation = chisel.request_field(fields.file_operation)
    f_proc_name = chisel.request_field(fields.proc_name)
    f_proc_cmdline = chisel.request_field(fields.proc_cmdline)
    f_proc_cwd = chisel.request_field(fields.proc_cwd)
    f_proc_exe = chisel.request_field(fields.proc_exe)
    f_proc_args = chisel.request_field(fields.proc_args)

    -- Set filter 
    deployment_filter = "k8s.deployment.name=" .. deployment
    chisel.set_filter(deployment_filter)

    return true
end

-- Event parsing callback
function on_event()
    table.insert(list_of_pods, evt.field(f_pod_name))
    table.insert(events, {
        evt.field(f_pod_name),
        evt.field(f_timestamp),
        evt.field(f_syscall_name),
        evt.field(f_syscall_category),
        evt.field(f_file_path),
        evt.field(f_file_directory),
        evt.field(f_file_name),
        evt.field(f_file_operation),
        evt.field(f_proc_name),
        evt.field(f_proc_cmdline),
        evt.field(f_proc_cwd),
        evt.field(f_proc_exe),
        evt.field(f_proc_args)
    })
    return true
end

-- Capture end callback
function on_capture_end()
    local result = parse.parse(events, list_of_pods)
    local success, replicasEvents = pcall(json.encode, result, { indent = true })
    if not success then
        print("Error encoding JSON: " .. replicasEvents)
        return false
    end

    --print(replicasEvents)

    -- Writing to the output file
    local success, err = cutils.write_to_file(output_file, replicasEvents)
    if not success then
        print(err)
        return false
    else 
        print("File '" .. output_file .. "' has been successfully generated.")
    end
    return true    
end
