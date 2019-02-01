NOW=$(date +%Y%m%d-%H%M%S)
sudo cp -rf /etc/kubernetes ~/kubernetes-${NOW}
sudo tar zcf ~/kubernetes-${NOW}.tar.gz kubernetes-${NOW}
sudo rm -rf ~/kubernetes-${NOW}
