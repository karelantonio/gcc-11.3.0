#!/bin/sh

# Some things before start
NAME="gcc-11.3.0"
INITIALDIR=$PWD
mkdir -p /opt/$NAME
cd $(mktemp -d)

# 1. Install the required dependencies
echo "Installing the dependencies..."
apk add --no-cache patch make build-base gcompat binutils musl-dev wget mpc1-dev gmp-dev mpfr-dev gcc g++ > log.txt

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
../configure --enable-languages=c,c++ --prefix=/opt/$NAME --disable-multilib || exit 1

# 6. Apply some patches
echo "Applying some patches"
patch ../libiberty/simple-object-mach-o.c < $INITIALDIR/simple-object-mach-o.c.patch || exit 1
sed -i '1i #include<pthread.h>' ../gcc/jit/jit-playback.c || exit 1
sed -i '1i #include<pthread.h>' ../gcc/jit/jit-record.c || exit 1
sed -i '1i #include<pthread.h>' ../gcc/jit/libgccjit.c || exit 1
sed -i '1i #include<pthread.h>' ../gcc/cp/mapper-client.c || exit 1
sed -i '1i #include<pthread.h>' ../gcc/cp/mapper-resolver.c || exit 1
sed -i '1i #include<pthread.h>' ../gcc/cp/module.c || exit 1

# 7. Build
echo "Building..."
make all-gcc || exit 1
make all-target-libgcc || exit 1
make install-gcc || exit 1
make install-target-libgcc || exit 1

# 8. Copy the result to the releases?
echo "Compressing..."
tar czf $NAME-x86_64-linux-musl.tar.gz /opt/$NAME || exit 1
mv $NAME-x86_64-linux-musl.tar.gz /

# 9999 Done
echo "Done!"
cd $INITIALDIR
