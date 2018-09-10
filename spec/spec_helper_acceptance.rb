require 'beaker-pe'
require 'beaker-puppet'
require 'beaker-rspec/helpers/serverspec'
require 'beaker-rspec/spec_helper'
require 'beaker/puppet_install_helper'
require 'beaker/testmode_switcher/dsl'
require 'beaker/module_install_helper'

# automatically load any shared examples or contexts
Dir["./spec/acceptance/helpers/**/*.rb"].sort.each { |f| require f }

run_puppet_install_helper
configure_type_defaults_on(hosts)
install_ca_certs unless ENV['PUPPET_INSTALL_TYPE'] =~ /pe/i

RSpec.configure do |c|
  # Provision the Environment
  c.before :suite do
    # Create a domain controller
    create_domain_controller
  end
end

def beaker_opts
  @env ||= {
    acceptable_exit_codes: (0...256),
    debug: true,
    trace: true,
  }
end
