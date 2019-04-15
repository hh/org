# References


export TIME_START=$(date)
apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get install -y docker-ce docker-ce-cli containerd.io
apt-get install -y git gcc
curl -L https://dl.google.com/go/go1.12.4.linux-amd64.tar.gz | sudo tar -C /usr/local -xzf -

export GOROOT=/usr/local/go/
export GOPATH=~/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
go version
