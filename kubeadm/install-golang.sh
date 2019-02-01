sudo curl -O https://dl.google.com/go/go1.11.5.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.11.5.linux-amd64.tar.gz
mkdir ~/go
echo "export GOPATH=~/go" >> ~/.bashrc
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc
source ~/.bashrc
