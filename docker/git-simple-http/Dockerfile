FROM nginx:1.13.5-alpine

RUN set -x && \
  apk --update upgrade                                  &&  \
  apk add git fcgiwrap spawn-fcgi bash wget             &&  \
  adduser git -h /var/lib/git -D                        &&  \
  adduser nginx git                                     &&  \
  git config --system http.receivepack true             &&  \
  git config --system http.uploadpack true              &&  \
  git config --system user.email "gitserver@git.com"    &&  \
  git config --system user.name "Git Server"            &&  \
  git init --bare /var/lib/git/repo.git                 &&  \
  chown -R git:git /var/lib/git                         &&  \
  chmod -R 775 /var/lib/git                             &&  \
  ln -sf /dev/stdout /var/log/nginx/access.log          &&  \
  ln -sf /dev/stderr /var/log/nginx/error.log

COPY ./nginx-config /etc/nginx
COPY ./entrypoint.sh /usr/local/bin/entrypoint
COPY ./git-hooks /var/lib/git/repo.git/hooks

RUN chmod +x /var/lib/git/repo.git/hooks/*

ENTRYPOINT [ "entrypoint" ]
