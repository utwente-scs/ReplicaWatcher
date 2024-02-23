local fields = {
    pod_name = "k8s.pod.name",
    timestamp = "evt.time",
    syscall_name = "evt.type",
    syscall_category = "evt.category",
    file_path = "fd.name",
    file_name = "fd.filename",
    file_directory = "fd.directory",
    file_operation = "fd.type",
    proc_name = "proc.name",
    proc_cmdline = "proc.cmdline",
    proc_cwd = "proc.cwd",
    proc_exe = 'proc.exe',
    proc_args = 'proc.args'
}

return fields
