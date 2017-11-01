VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define :ubuntu_two_five do |ubuntu|
    ubuntu.vm.box = 'hashicorp/precise32'
    ubuntu.vm.provision 'shell', path: 'vagrant_ubuntu_provisioning_two_five.sh'
  end
end
