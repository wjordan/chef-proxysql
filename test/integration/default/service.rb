# ProxySQL

service_name = 'proxysql-first'
service_provider = attribute("service", default: "systemd", description: "service provider")
service_method, service_file = case service_provider
when 'systemd'
  [method(:systemd_service), '/etc/systemd/system/proxysql-first.service']
when 'upstart'
  [method(:upstart_service), '/etc/init/proxysql-first.conf']
else
  [method(:service), '/etc/init.d/proxysql-first']
end

describe service_method.call(service_name) do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe file(service_file) do
  it { should exist }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  if service_provider == 'systemd'
    its('content') { should match 'TimeoutSec = 5' }
    its('content') { should match 'Restart=on-failure' }
    its('content') { should match 'User=proxysql' }
    # its('content') { should match 'Group = proxysql' }
    its('content') { should match 'LimitCORE = 1073741824' }
    its('content') { should match 'LimitNOFILE = 102400' }
  end
end
