# Start with the ubuntu image
FROM ubuntu
# Update apt cache
RUN apt-get -y update
# Install ansible dependencies
RUN apt-get install -y python-yaml python-jinja2 git
# Clone ansible repo (could also add the ansible PPA and do an apt-get install instead)
RUN git clone http://github.com/ansible/ansible.git /tmp/ansible

# Set variables for ansible
WORKDIR /tmp/ansible
ENV PATH /tmp/ansible/bin:/sbin:/usr/sbin:/usr/bin
ENV ANSIBLE_LIBRARY /tmp/ansible/library
ENV PYTHONPATH /tmp/ansible/lib:$PYTHON_PATH

# add playbooks to the image. This might be a git repo instead
ADD . ~/taperole

# Run ansible using the site.yml playbook 
WORKDIR ~/taperole/vanilla-rails-app
RUN bundle install --path vendor
RUN echo 'n' | bundle exec tape installer install
RUN echo '[omnibox]' > hosts
RUN echo '0.0.0.0 be_app_env=production be_app_branch=master' >> hosts
RUN bundle exec tape ansible everything
