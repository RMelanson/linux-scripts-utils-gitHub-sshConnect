ssh-keygen -t rsa -N "" -f ~/.ssh/gitHub
echo "host github.com"                 >> ~/.ssh/config
echo " HostName github.com"            >> ~/.ssh/config
echo " IdentityFile ~/.ssh/gitHub"     >> ~/.ssh/config
echo " User git"                       >> ~/.ssh/config
echo " passwordAuthentication no"      >> ~/.ssh/config
chmod 600 ~/.ssh/config

if grep -Fxq ~/.bashrc "ssh-agent"
then
    echo ssh-agent found
else
    echo ssh-agent not found, Adding ssh-agent
    echo EXECUTING "echo 'eval \$("ssh-agent")' >> ~/.bashrc"
    echo 'eval $("ssh-agent")' >> ~/.bashrc
fi

echo "<Copy the following ssh public key to github settings for ssh keys>"
cat ~/.ssh/gitHub.pub
