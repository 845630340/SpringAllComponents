FROM registry-in.beta.sohucs.com/domeos/gitbook:3.2.2
COPY gitbook /srv/gitbook
WORKDIR /srv/gitbook
RUN gitbook build
