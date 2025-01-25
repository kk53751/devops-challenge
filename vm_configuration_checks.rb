

control 'nginx-installation' do
    impact 1.0
    title 'Check if nginx is installed and running'
    desc 'Verify that nginx is installed and the service is running'
    
    describe package('nginx') do
      it { should be_installed }
    end
    
    describe service('nginx') do
      it { should be_running }
      it { should be_enabled }
    end
  end
  
  control 'nginx-default-page' do
    impact 1.0
    title 'Validate that the default nginx page contains the required message'
    desc 'Ensure that the default nginx page displays the expected message'
    
    describe command('curl -s http://localhost') do
      its('stdout') { should include 'Welcome to nginx!' } # Adjust this message as needed
    end
  end
  
  control 'ssh-root-login' do
    impact 1.0
    title 'Ensure SSH root login is disabled'
    desc 'Verify that root login via SSH is not allowed'
    
    describe sshd_config do
      its('PermitRootLogin') { should eq 'no' }
    end
  end
  
  control 'ssh-port' do
    impact 1.0
    title 'Verify the SSH port is set to 22'
    desc 'Ensure that the SSH service is listening on port 22'
    
    describe port(22) do
      it { should be_listening }
    end
  end
  
  control 'devops-user' do
    impact 1.0
    title 'Ensure the devops user exists and is in the sudo group'
    desc 'Verify that the devops user has been created and is part of the sudo group'
    
    describe user('devops') do
      it { should exist }
      it { should belong_to_group 'sudo' }
    end
  end
  