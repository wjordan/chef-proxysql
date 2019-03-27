default['percona']['repository']['name'] = 'percona-original-release.repo'
default['percona']['repository']['version'] = 'latest'

case node['platform']
when 'rhel', 'centos'
  default['proxysql']['package_release'] = "1.1.el#{node['platform_version'].to_i}"

  default['percona']['repository']['url'] = 'http://www.percona.com/'\
    'downloads/percona-release/redhat/'\
    "#{node['percona']['repository']['version']}/"
when 'debian', 'ubuntu'
  lsb_release = Mixlib::ShellOut.new('lsb_release -sc')
  lsb_release.run_command
  lsb_release.error!
  lsb_release = lsb_release.stdout.chomp

  default['proxysql']['package_release'] = "1.1.#{lsb_release}"

  default['percona']['repository']['url'] =
    'http://repo.percona.com/apt/percona-release_'\
    "#{node['percona']['repository']['version']}."\
    "#{lsb_release}_all.deb"
end
