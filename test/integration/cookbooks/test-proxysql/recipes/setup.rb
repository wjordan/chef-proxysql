if %w(rhel centos).include?(node['platform'])
  include_recipe 'yum-mysql-community::mysql56'
end
