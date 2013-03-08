if platform_family?('debian')
  IP_ADDRESS = node["virtual"]["ip_address"]
  execute "printf 'auto lo:0\niface lo:0 inet static\naddress #{IP_ADDRESS}\nnetmask 255.255.255.255' >> /etc/network/interfaces" do
    not_if "grep lo:0 /etc/network/interfaces"
  end
else
  template "/etc/sysconfig/network-scripts/ifcfg-lo_0" do
  	source "centos_interfaces.erb"
  	owner "root"	
  	group "root"
    mode "0644"
    action :create
  end
end

# ARP Response Intarface Address Only Settings.
# use chef-sysctl
include_recipe 'sysctl'

sysctl "net.ipv4.conf.all.arp_ignore" do  value 1  end
sysctl "net.ipv4.conf.all.arp_announce" do  value 2  end

service "networking" do
	service_name "networking"
  action :restart
end
