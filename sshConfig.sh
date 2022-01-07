ssh-keygen -t rsa -N "" -f ~/.ssh/gitHub
echo "host github.com"                 >> ~/.ssh/config
echo " HostName github.com"            >> ~/.ssh/config
echo " IdentityFile ~/.ssh/gitHub"     >> ~/.ssh/config
echo " User git"                       >> ~/.ssh/config
echo " passwordAuthentication no"      >> ~/.ssh/config
echo "<Copy the following ssh public key to github settings for ssh keys>"
cat ~/.ssh/gitHub.key.pub
echo
