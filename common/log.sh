buildlog=`pwd`/build.log

log() {
    echo -e $@ | tee -a $buildlog
}