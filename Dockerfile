# Start with the ubuntu image
FROM ubuntu

CMD ["bash"]

# Update apt cache
RUN apt-get -y update

# Install ansible dependencies
RUN apt-get install -y python-dev git aptitude sudo wget make zlib1g-dev libssl-dev build-essential libreadline-dev libyaml-dev libxml2-dev libcurl4-openssl-dev python-software-properties libffi-dev

# Install Ruby
WORKDIR /tmp
RUN wget http://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.0.tar.gz
RUN tar -xvzf ruby-2.3.0.tar.gz
WORKDIR /tmp/ruby-2.3.0
RUN ./configure --prefix=/usr/local
RUN make
RUN make install

# Add an authorized_keys file to the container since tape expects this
RUN mkdir -p /root/.ssh
RUN touch /root/.ssh/authorized_keys
RUN chown root:root /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

# Clone ansible repo (could also add the ansible PPA and do an apt-get install instead)
RUN apt-get install wget
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
RUN pip install ansible

# Set variables for ansible
WORKDIR /tmp/ansible
ENV PATH /tmp/ansible/bin:/usr/sbin:/sbin:/usr/bin:/bin:$PATH
ENV ANSIBLE_LIBRARY /tmp/ansible/library
ENV PYTHONPATH /tmp/ansible/lib:$PYTHON_PATH

# add playbooks to the image. This might be a git repo instead
ADD . /taperole

# Install Tape
WORKDIR /taperole
RUN gem build taperole.gemspec
RUN gem install slack-notifier
RUN gem install --local taperole

# Configure tape
WORKDIR /taperole/vanilla-rails-app
RUN echo 'n' | tape installer install
ADD test/tape_vars.yml taperole/tape_vars.yml

# FIXME
# Disable ufw bc docker gets mad about iptables
RUN sed -i '/ufw/d' taperole/omnibox.yml

# Run Tape
RUN echo '[omnibox]' > taperole/hosts
RUN echo 'localhost ansible_connection=local be_app_env=production be_app_branch=master' >> taperole/hosts
RUN tape ansible everything
