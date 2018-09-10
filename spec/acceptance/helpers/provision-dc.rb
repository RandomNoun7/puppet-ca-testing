def domain_controller
  hosts.select {|host| host['role'] == 'domaincontroller'}.first
end

def dc_manifest(domain_name, user, password)
  manifest = <<-HEREDOC
    $features = ['AD-Domain-Services','RSAT-AD-PowerShell','RSAT-AD-Tools']

    $domain_name = '#{domain_name}'

    $domain_credential = {
      'user'     => '#{user}',
      'password' => '#{password}'
    }

    $features.each |String $feature| {
      dsc_xwindowsfeature { $feature:
        ensure                   => 'present',
        dsc_name                 => $feature,
        dsc_includeallsubfeature => true,
      }
    }

    dsc_xaddomain { 'domain':
      ensure                            => 'present',
      dsc_domainname                    => $domain_name,
      dsc_domainadministratorcredential => $domain_credential,
      dsc_safemodeadministratorpassword => $domain_credential,
    }

    reboot { 'dsc_reboot':
      message => 'DSC has requested a reboot',
      when    => 'pending',
    }
  HEREDOC
end

def create_domain_controller(domain_name = 'fabricum.com', user = 'domain_admin', password = 'Password1!')
  require 'pry'; binding.pry;
  apply_manifest_on(domain_controller.name, dc_manifest(domain_name, user, password))
  retry_on(domain_conroller.name, powershell("$env:USERDOMAIN -eq #{domain_name}", {EncodedCommand => true}))
end