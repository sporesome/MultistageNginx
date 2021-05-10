FROM debian:9 as build

RUN apt update && apt install -y wget gcc make libpcre3-dev zlib1g-dev

RUN wget http://nginx.org/download/nginx-1.19.3.tar.gz && tar xvfz nginx-1.19.3.tar.gz  && cd nginx-1.19.3 && ./configure &&  make && make install

FROM debian:9

WORKDIR /usr/local/nginx/sbin
COPY --from=build /usr/local/nginx/sbin/nginx .
RUN mkdir ../logs ../conf ../html && touch ../logs/error.log && chmod +x nginx
COPY --from=build /usr/local/nginx/html/index.html ../html
COPY --from=build /usr/local/nginx/conf/nginx.conf ../conf
COPY --from=build /usr/local/nginx/conf/mime.types ../conf
RUN echo "<img src="https://i.imgur.com/Dows6kT.png">" > ../html/index.html
CMD ["./nginx", "-g", "daemon off;"]
