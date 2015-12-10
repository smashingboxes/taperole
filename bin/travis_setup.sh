# setup ssh key
ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
cat ~/.ssh/id_rsa.pub | sudo tee -a ~root/.ssh/authorized_keys

# Project
git clone git@github.com:dkniffin/vanilla-rails-app.git ~/vanilla-rails-app
cd ~/vanilla-rails-app/

# Set up tape
gem install --local $TRAVIS_BUILD_DIR/taperole.gem
echo 'y' | tape installer install
# TODO: add a silent flag for ^
echo '[omnibox]' > hosts
echo '0.0.0.0 be_app_env=production be_app_branch=master' >> hosts
sed -i 's/app_name:.*/app_name: vanilla/g' tape_vars.yml
sed -i 's/be_app_repo:.*/be_app_repo: git@github.com:dkniffin\/vanilla-rails-app.git/g' tape_vars.yml
cp ~/.ssh/id_rsa.pub dev_keys/key.pub
