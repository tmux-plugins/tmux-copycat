VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define :ubuntu do |ubuntu|
    ubuntu.vm.box = 'hashicorp/precise32'
    ubuntu.vm.provision 'shell', path: 'vagrant_ubuntu_provisioning.sh'
  end

  config.vm.define :centos do |centos|
    centos.vm.box = 'chef/centos-6.5'
    centos.vm.provision 'shell', path: 'vagrant_centos_provisioning.sh'
  end

end
