FROM node:alpine

WORKDIR /usr/src/app
COPY . /usr/src/app
RUN apk add git  && \
git config --global user.email "whisper@codewhispers.org"  && \
git config --global user.name "whisper"  && \
git config --global push.default simple  && \
chmod 755 ./entrypoint.sh

EXPOSE 3000
ENTRYPOINT [ "./entrypoint.sh" ]
