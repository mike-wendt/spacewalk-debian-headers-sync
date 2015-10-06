#!/bin/bash
MIRROR="mirror.umd.edu"
RELEASE="trusty"
USER="user"
PASS="pass"

cd /opt/spacewalk-debian-sync

# MAIN
./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE" --url "http://$MIRROR/ubuntu/dists/$RELEASE/main/binary-amd64/"
./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-backports" --url "http://$MIRROR/ubuntu/dists/$RELEASE-backports/main/binary-amd64/"
./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-updates" --url "http://$MIRROR/ubuntu/dists/$RELEASE-updates/main/binary-amd64/"
./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-security" --url "http://$MIRROR/ubuntu/dists/$RELEASE-security/main/binary-amd64/"
./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-i386" --url "http://$MIRROR/ubuntu/dists/$RELEASE/main/binary-i386/"
./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-backports-i386" --url "http://$MIRROR/ubuntu/dists/$RELEASE-backports/main/binary-i386/"
./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-updates-i386" --url "http://$MIRROR/ubuntu/dists/$RELEASE-updates/main/binary-i386/"
./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-security-i386" --url "http://$MIRROR/ubuntu/dists/$RELEASE-security/main/binary-i386/"

# MULTIVERSE
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE" --url "http://$MIRROR/ubuntu/dists/$RELEASE/multiverse/binary-amd64/"
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-backports" --url "http://$MIRROR/ubuntu/dists/$RELEASE-backports/multiverse/binary-amd64/"
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-updates" --url "http://$MIRROR/ubuntu/dists/$RELEASE-updates/multiverse/binary-amd64/"
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-security" --url "http://$MIRROR/ubuntu/dists/$RELEASE-security/multiverse/binary-amd64/"
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-i386" --url "http://$MIRROR/ubuntu/dists/$RELEASE/multiverse/binary-i386/"
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-backports-i386" --url "http://$MIRROR/ubuntu/dists/$RELEASE-backports/multiverse/binary-i386/"
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-updates-i386" --url "http://$MIRROR/ubuntu/dists/$RELEASE-updates/multiverse/binary-i386/"
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-security-i386" --url "http://$MIRROR/ubuntu/dists/$RELEASE-security/multiverse/binary-i386/"

# RESTRICTED
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE" --url "http://$MIRROR/ubuntu/dists/$RELEASE/restricted/binary-amd64/"
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-backports" --url "http://$MIRROR/ubuntu/dists/$RELEASE-backports/restricted/binary-amd64/"
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-updates" --url "http://$MIRROR/ubuntu/dists/$RELEASE-updates/restricted/binary-amd64/"
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-security" --url "http://$MIRROR/ubuntu/dists/$RELEASE-security/restricted/binary-amd64/"
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-i386" --url "http://$MIRROR/ubuntu/dists/$RELEASE/restricted/binary-i386/"
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-backports-i386" --url "http://$MIRROR/ubuntu/dists/$RELEASE-backports/restricted/binary-i386/"
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-updates-i386" --url "http://$MIRROR/ubuntu/dists/$RELEASE-updates/restricted/binary-i386/"
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-security-i386" --url "http://$MIRROR/ubuntu/dists/$RELEASE-security/restricted/binary-i386/"

# UNIVERSE
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE" --url "http://$MIRROR/ubuntu/dists/$RELEASE/universe/binary-amd64/"
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-backports" --url "http://$MIRROR/ubuntu/dists/$RELEASE-backports/universe/binary-amd64/"
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-updates" --url "http://$MIRROR/ubuntu/dists/$RELEASE-updates/universe/binary-amd64/"
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-security" --url "http://$MIRROR/ubuntu/dists/$RELEASE-security/universe/binary-amd64/"
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-i386" --url "http://$MIRROR/ubuntu/dists/$RELEASE/universe/binary-i386/"
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-backports-i386" --url "http://$MIRROR/ubuntu/dists/$RELEASE-backports/universe/binary-i386/"
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-updates-i386" --url "http://$MIRROR/ubuntu/dists/$RELEASE-updates/universe/binary-i386/"
#./spacewalk-debian-sync.pl --user "$USER" --password "$PASS" --channel "$RELEASE-security-i386" --url "http://$MIRROR/ubuntu/dists/$RELEASE-security/universe/binary-i386/"