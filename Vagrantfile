Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.provision "shell", path: "bootstrap.sh"
  if File.file?("setup_git.sh")
    config.vm.provision "shell", path: "setup_git.sh", privileged: false
  end
  config.vm.provision "shell", inline: "apt-get install -y linux-modules-extra-$(uname -r)", run: "always"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--usb", "on"]
    vb.customize ["modifyvm", :id, "--usbehci", "on"]
    vb.customize ["usbfilter", "add", "0",
                    "--target", :id,
                    "--name", "ESP8266",
                    "--vendorid", "10C4",
                    "--productid", "EA60"]
  end
end