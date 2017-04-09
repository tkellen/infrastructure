From Development Machine
```
cat ~/.ssh/id_rsa.pub | ssh tkellen@SERVER "mkdir -m 700 ~/.ssh;cat >> ~/.ssh/authorized_keys;chmod 600 ~/.ssh/authorized_keys"
scp -r copy/.* tkellen@server:~/
```

On Destination Server
```
chsh -s /bin/zsh
```
