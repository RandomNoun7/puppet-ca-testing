def windows_hosts
  hosts.select { |host| host.platform =~ /windows/i }
end

def get_puppet_version
  (on default, puppet('--version')).output.chomp
end
