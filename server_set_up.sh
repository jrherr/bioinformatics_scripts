# server set up

sudo apt-get update
sudo apt-get -y install screen git curl gcc make g++ python-dev unzip default-jre pkg-config libncurses5-dev r-base-core r-cran-gplots python-matplotlib sysstat
sudo apt-get -y install python-pip ncftp
sudo pip install screed

#run this under 'sudo bash' this is requiered for trimming and assembling
sudo bash
cd /usr/local/share
git clone https://github.com/ged-lab/khmer.git
cd khmer
git checkout v1.1
make install

cd /root
curl -O http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.30.zip
unzip Trimmomatic-0.30.zip
cd Trimmomatic-0.30/
cp trimmomatic-0.30.jar /usr/local/bin
cp -r adapters /usr/local/share/adapters

cd /root
curl -O http://hannonlab.cshl.edu/fastx_toolkit/libgtextutils-0.6.1.tar.bz2
tar xjf libgtextutils-0.6.1.tar.bz2
cd libgtextutils-0.6.1/
./configure && make && make install

cd /root
curl -O http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit-0.0.13.2.tar.bz2
tar xjf fastx_toolkit-0.0.13.2.tar.bz2
cd fastx_toolkit-0.0.13.2/
./configure && make && make install

cd /root
curl -O http://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.10.tgz
tar xzf velvet_1.2.10.tgz
cd velvet_1.2.10
make MAXKMERLENGTH=51
cp velvet? /usr/local/bin

cd /root
curl -O https://hku-idba.googlecode.com/files/idba-1.1.1.tar.gz
tar xzf idba-1.1.1.tar.gz
cd idba-1.1.1
./configure && make
cp bin/idba_ud /usr/local/bin

apt-get -y install cmake

wget http://spades.bioinf.spbau.ru/release3.1.0/SPAdes-3.1.0.tar.gz
tar -xzf SPAdes-3.1.0.tar.gz
cd SPAdes-3.1.0
PREFIX=/usr/local ./spades_compile.sh

cd /root
curl -O http://ftp.gnu.org/gnu/parallel/parallel-latest.tar.bz2
tar xjf parallel-latest.tar.bz2
cd parallel-*
./configure && make && make install
cd /mnt/work/