FROM node:alpine

WORKDIR /usr/src/app
COPY ../.. /usr/src/app
COPY ./entrypoint.sh /usr/src/app
RUN apk add git  && \
git config --global user.email "whisper@codewhispers.org"  && \
git config --global user.name "whisper"  && \
git config --global push.default simple

EXPOSE 3000
ENTRYPOINT [ "./entrypoint.sh" ]
