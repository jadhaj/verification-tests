FROM quay.io/centos/centos:8

LABEL vendor="Red Hat inc."
LABEL maintainer="OCP QE Team"

USER root

RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-*

RUN set -x && \
    yum -y update && \
    INSTALL_PKGS="bsdtar git openssh-clients httpd-tools rsync" && \
    yum install -y $INSTALL_PKGS && \
    yum install -y --setopt=tsflags=nodocs https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm && \
    CHROMEDRIVER_URL="https://chromedriver.storage.googleapis.com" && \
    CHROMEDRIVER_VERSION=$(curl -sSL "$CHROMEDRIVER_URL/LATEST_RELEASE") && \
    curl -sSL "$CHROMEDRIVER_URL/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip" | bsdtar --no-same-owner --no-same-permissions -xvf - -C /usr/local/bin && \
    GECKODRIVER_SPEC="https://api.github.com/repos/mozilla/geckodriver/releases/latest" && \
    GECKODRIVER_RE='^.*"browser_download_url": ?"(http[^"]*linux64.tar.gz)".*$' && \
    curl -sSL $GITHUB_API_CURL_OPTS "$GECKODRIVER_SPEC" | sed -En "s#$GECKODRIVER_RE#\1#p" | xargs -d '\n' curl -sSL | bsdtar -xvf - -C /usr/local/bin && \
    chmod +x /usr/local/bin/chromedriver /usr/local/bin/geckodriver && \
    curl -sSL https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -o /tmp/epel-release-latest-8.noarch.rpm && \
    yum install -y /tmp/epel-release-latest-8.noarch.rpm

ADD . /verification-tests/
RUN chmod 777 /verification-tests/
RUN mv /tierN/ /verification-tests/features/tierN/
RUN set -x && \
    yum module reset ruby && \
    yum module -y enable ruby:2.7 && \
    yum module -y install ruby:2.7
RUN /verification-tests/tools/install_os_deps.sh
RUN /verification-tests/tools/hack_bundle.rb

RUN yum clean all -y && rm -rf /var/cache/yum /tmp/* /verification-tests/Gemfile.lock
