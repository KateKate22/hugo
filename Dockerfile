FROM docker.itglobal.ru/base/alpine:3.15.0 as build

RUN apk add --no-cache wget zip

RUN wget --quiet "https://github.com/gohugoio/hugo/releases/download/v0.92.1/hugo_0.92.1_Linux-64bit.tar.gz" && \
    tar xzf hugo_0.92.1_Linux-64bit.tar.gz && \
    rm -r hugo_0.92.1_Linux-64bit.tar.gz && \
    mv hugo /usr/bin

WORKDIR /app

COPY . .

RUN hugo && \ 
    zip /app/static/site.zip -r /app/public

EXPOSE 3000

CMD [ "hugo", "server", "--buildDrafts", "--watch=false", "--bind", "0.0.0.0", "-p", "3000"]