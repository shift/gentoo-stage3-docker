
LATEST_VERSION=

if [ -z "$LATEST_VERSION" ]; then
  LATEST_VERSION=$LATEST_VERSION`curl 'http://distfiles.gentoo.org/releases/amd64/autobuilds/latest-stage3-amd64.txt' | tail -n 1`
  TAG=autobuild-`echo $LATEST_VERSION | sed -n 's|\(.*\)\/.*|\1|p'`
fi

#wget -c "http://distfiles.gentoo.org/releases/amd64/autobuilds/${LATEST_VERSION}"
mkdir rootfs
git tag $TAG
sed -ri "s/LATEST_VERSION=$LATEST_VERSION/LATEST_VERSION=$LATEST_VERSION/" build.sh
git add build.sh
git push origin --tags
(cd rootfs && sudo tar xvjpf ../*.tar.bz2)
sudo tar -C rootfs -c . | sudo docker import - shift/gentoo-stage3-amd64
sudo docker push shift/gentoo-stage3-amd64
