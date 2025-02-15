#!/bin/sh

# Some things before start
NAME="gcc-11.3.0"
INITIALDIR=$PWD
mkdir -p /opt/$NAME
cd $(mktemp -d)

# 1. Install the required dependencies
echo "Installing the dependencies..."
apk add --no-cache make build-base gcompat binutils musl-dev wget mpc1-dev gmp-dev mpfr-dev > log.txt

# 2. Download the file
echo "Downloading the file"
wget https://ftp.gnu.org/gnu/gcc/$NAME/$NAME.tar.gz >> log.txt

# 3. Decompress
echo "Decompressing..."
tar xzf $NAME.tar.gz >> log.txt
rm $NAME.tar.gz >> log.txt
mkdir $NAME/build_dir
cd $NAME/build_dir

# 4. Install requirements
echo "Installing requirements"
../contrib/download_prerequisites >> log.txt

# 5. Configure
echo "Configuring..."
../configure --enable-languages=c,c++ --prefix=/opt/$NAME --disable-multilib # Useful to see the output

# 6. Apply some patches

# 7. Build

# 8. Copy the result to the releases?

# 9999 Done
echo "Done!"
cd $INITIALDIR
