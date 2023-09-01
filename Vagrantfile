NUM_AGENTS = 4
NUM_CONTROLLER = 1
NETWORK_IP = "192.168.50."
CONTROLLER_IP = 200

Vagrant.configure("2") do |config|
  
  config.vm.box = "debian/bookworm64"
  config.vm.box_check_update = false
  
  config.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "2048"
      vb.cpus = "2"
  end

  config.trigger.after :provision do |trigger|
    trigger.name = "Run Playbooks"
    trigger.only_on = 'controller', 's1.infra', 's2.infra', 's3.infra', 's4.infra'
    trigger.run_remote =  {path: "provisionning/triggers.sh"}
  end

    # Create Cluster nodes 
    (0..NUM_AGENTS).each do |i|
        config.vm.define "s#{i}.infra" do |machine|
            
            machine.vm.hostname = "s#{i}.infra"
            
            if i == 0
                machine.vm.network "private_network",  ip: NETWORK_IP + "50", virtualbox__intnet: "intnet"
                machine.vm.network "forwarded_port", guest: 80, host: 80
                machine.vm.provision "shell", path: "provisionning/script_sshkey.sh" 
                machine.vm.provision "shell", path: "provisionning/Script_S0.sh",env: {"DNSMASQ_INSTALLATION_MODE_SHELL"=> "false"}
            else
                machine.vm.network "private_network", ip: NETWORK_IP + "#{CONTROLLER_IP +  i}", virtualbox__intnet: "intnet", auto_config: false
                # machine.vm.provision "shell", path: "provisionning/Script_Agents.sh"
            end
            machine.vm.provision "shell", path: "provisionning/Script_addkeys.sh"
      end
    end



  # VM  ansible controller 
  config.vm.define "controller", primary: true do |node|
    node.vm.hostname= "controller"
    node.vm.network "private_network", ip: NETWORK_IP + "#{CONTROLLER_IP}" ,virtualbox__intnet: "intnet"
    node.vm.provision "shell", path: "provisionning/Script_Controller.sh"  
    node.vm.provision "shell", path: "provisionning/Script_playbooks.sh"      
  end



end
