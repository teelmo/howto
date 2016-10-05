# SSH-keygen

Do this on source machine:

source ---> target

## 1.  Create public and private keys using ssh-key-gen on localhost 
teelmo@localhost$ `ssh-keygen`
~~~~
Generating public/private rsa key pair.
Enter file in which to save the key (/home/teelmo/.ssh/id_rsa):[Enter key]
Enter passphrase (empty for no passphrase): [Press enter key]
Enter same passphrase again: [Pess enter key]
Your identification has been saved in /home/teelmo/.ssh/id_rsa.
Your public key has been saved in /home/teelmo/.ssh/id_rsa.pub.
~~~~

## 2. Copy the public key to remote-host using ssh-copy-id
teelmo@localhost$ `ssh-copy-id -i ~/.ssh/id_rsa.pub remoteuser@remote`
~~~~
remoteuser@remote's password:
Now try logging into the machine, with "ssh 'remoteuser@remote'", and check in:

.ssh/authorized_keys

to make sure we haven't added extra keys that you weren't expecting.
~~~~

OS X users can install _ssh-copy-id_ with: `curl -L https://raw.githubusercontent.com/beautifulcode/ssh-copy-id-for-OSX/master/install.sh | sh`. See https://github.com/beautifulcode/ssh-copy-id-for-OSX

## 3. Login to remote-host without entering the password
teelmo@localhost$ `ssh remoteuser@remotehost`
