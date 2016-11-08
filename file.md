# Setting Up Lets Encrypt
* ssh into your server as root.
* run: `git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt`
* stop nginx by running: `monit stop all`
* cd into `/opt/letsencrypt`
* run: `./letsencrypt-auto certonly --standalone` (note: that's dash-dash-standalone)
* You should see a blue screen/form.  Fill in the requested information.  (note: you can enter the naked domain and use www, i.e. example.com and www.example.com; follow the instructions for multiple domains)
* If everything was successful, you will see a success message.  If not, a likely culprit is that nginx is still running, or you typed the wrong domain name (or haven't set the domain name up yet)
* Update your nginx config to point to he new SSL certs.  The config file can be found at `/etc/nginx/sites-enabled/your-app-name`.  

**Example**

```
ssl on;
  ssl_certificate /etc/letsencrypt/live/api.raq-staging.sbox.es/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/api.raq-staging.sbox.es/privkey.pem;
```

* Restart monit:  `monit restart all`.

*Note*:  
Let's Encrypt certificates are good for three months.  We'll need to set up a cron job on the sever to automatically renew them for us.

* Run: `crontab -e`, which will open a cron tab.
* Choose your favorite unix editor, and then insert:

```
30 2 * * 1 monit stop all
31 2 * * 1 /opt/letsencrypt/letsencrypt-auto renew >> /var/log/le-renew.log
32 2 * * 1 monit start all
```

* Save and exit.
* You need to use the `nginx-letsencrypt` Ansible role. Change the line `- nginx` in your omnibox.yml file to `- nginx-letsencrypt`
* Set the `domain` variable in your tape_vars.yml file (should be same as domain you set at the blue screen earlier).
* Run `tape ansible everything`

That's it!  Refresh your browser and make sure you have the green lock.  If not, you probably haven't set up nginx correctly.

More information:
Digital ocean / Let's Encrypt [video tutorial](https://www.youtube.com/watch?v=m9aa7xqX67c)
Digital ocean [article](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-14-04) regarding setting up Let's Encrypt
