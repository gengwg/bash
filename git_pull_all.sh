# Pull all git repos in a directory
# To be run in the parent dir of the git repos
#
GIT_DIR=$PWD

for f in $(ls -d */)
do
  echo "--> $f"
  cd ${GIT_DIR}/$f
  git pull
  echo
done
