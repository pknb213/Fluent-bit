#!/bin/bash
current_dir=$(pwd)
mkdir $current_dir/offsets
offset_path=$current_dir/offsets

#wget http://www.cmake.org/files/v3.26/cmake-3.26.4.tar.gz
tar -zxvf cmake-3.26.4.tar.gz
rm -rf cmake-3.26.4.tar.gz
#git clone https://github.com/fluent/fluent-bit
tar -zxvf fluent-bit.tar.gz
rm -rf fluent-bit.tar.gz
cd ./cmake-3.26.4
yum install -y openssl-devel
./bootstrap
make
make install

\cp -f ./bin/cmake ./bin/cpack ./bin/ctest /bin
mkdir -p /usr/share/cmake-3.26
\cp -rf ./* /usr/share/cmake-3.26/
cmake -version

cd ../fluent-bit
export PATH="/usr/lib/cmake:$PATH"
cmake -LH
yum install -y flew bison libyaml-devel
cmake -DFLB_OUT_KAFKA=On
make

cd ../
tar -zxvf config.tar.gz
rm -rf config.tar.gz
sed -i'' -e 's/ROOT_PATH/$current_dir/g' ./config/in_log_out_forward.conf 
sed -i'' -e "s/OFFSET_PATH/${offset_path//\//\\/}/g" ./config/in_log_out_forward.conf
