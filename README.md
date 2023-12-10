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

## Installation

```
PM2_SSH_VERSION="0.1" && curl -L "https://github.com/goodylabs/pm2-ssh/archive/refs/tags/v${PM2_SSH_VERSION}.tar.gz" -o /tmp/pm2-ssh.tar.gz && mkdir -p ~/bin && tar -zxvf /tmp/pm2-ssh.tar.gz && mv pm2-ssh-${PM2_SSH_VERSION}/bin/pm2-ssh-to-*.sh ~/bin/ && rm pm2-ssh.tar.gz && rm -rf pm2-ssh-${PM2_SSH_VERSION}
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