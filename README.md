# PM2 SSH
Easily connect to remote environment using PM2 settings

#### Connect to the 1st server from PM2 staging settings

```
pm2-ssh-to-staging.sh
```

#### Connect to the 2nd server from PM2 production settings

```
pm2-ssh-to-production.sh 2
```



## Development

```
git clone git@github.com:goodylabs/pm2-ssh.git
cd pm2-ssh

mkdir -p ~/bin
ln -s bin/pm2-ssh-to-env.sh ~/bin/
ln -s bin/pm2-ssh-to-staging.sh ~/bin/
ln -s bin/pm2-ssh-to-production.sh ~/bin/
```