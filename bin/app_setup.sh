# setup ssh key
ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
sudo mkdir -p ~root/.ssh/
sudo touch ~root/.ssh/authorized_keys
cat ~/.ssh/id_rsa.pub | sudo tee -a ~root/.ssh/authorized_keys
ssh-keyscan -H 0.0.0.0 >> ~/.ssh/known_hosts
ssh-keyscan -H 127.0.0.1 >> ~/.ssh/known_hosts
ssh-keyscan -H localhost >> ~/.ssh/known_hosts

ls -la /var/lib/apt/lists

# Project
git clone https://github.com/dkniffin/vanilla-rails-app.git ~/vanilla-rails-app
cd ~/vanilla-rails-app/

# Set up tape
echo 'y' | tape installer install
# TODO: add a silent flag for ^
echo '[omnibox]' > hosts
echo '0.0.0.0 be_app_env=production be_app_branch=master' >> hosts
sed -i 's/app_name:.*/app_name: vanilla/g' tape_vars.yml
sed -i 's/be_app_repo:.*/be_app_repo: https:\/\/github.com\/dkniffin\/vanilla-rails-app.git/g' tape_vars.yml
cp ~/.ssh/id_rsa.pub dev_keys/key.pub
