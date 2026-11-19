NOMBRE = "AitorGuerrero"
IP_PUBLICA = "192.168.18.200"

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.boot_timeout = 600

  # Configuración global para evitar que Ubuntu 22.04 se congele al arrancar en VirtualBox
  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.customize ["modifyvm", :id, "--uart1", "0x3F8", "4"]
    vb.customize ["modifyvm", :id, "--uartmode1", "disconnected"]
  end

  config.vm.define "bbdd" do |m|
    m.vm.hostname = "bbdd"
    m.vm.network "private_network", ip: "192.168.30.10", virtualbox__intnet: "red_bbdd"
    m.vm.provider "virtualbox" do |vb|
      vb.name = "#{NOMBRE}BBDD"
      vb.memory = 2048
    end
    m.vm.provision "shell", path: "provision/bbdd.sh"
  end

  (1..2).each do |i|
    config.vm.define "web#{i}" do |m|
      m.vm.hostname = "web#{i}"
      m.vm.network "private_network", ip: "192.168.20.1#{i}", virtualbox__intnet: "red_web"
      m.vm.network "private_network", ip: "192.168.30.1#{i}", virtualbox__intnet: "red_bbdd"
      m.vm.provider "virtualbox" do |vb|
        vb.name = "#{NOMBRE}Web#{i}"
        vb.memory = 2048
      end
      m.vm.provision "shell", path: "provision/web.sh", args: [i.to_s, NOMBRE]
    end
  end

  config.vm.define "balanceador" do |m|
    m.vm.hostname = "balanceador"
    m.vm.network "public_network", ip: IP_PUBLICA
    m.vm.network "private_network", ip: "192.168.20.10", virtualbox__intnet: "red_web"
    m.vm.provider "virtualbox" do |vb|
      vb.name = "#{NOMBRE}Balanceador"
      vb.memory = 2048
    end
    m.vm.provision "shell", path: "provision/balanceador.sh"
  end
end