FROM resin/rpi-raspbian:stretch

RUN [ "cross-build-start" ]

MAINTAINER Paul Seymour <paul@palmtech.com.au>

ENV NGINX_VERSION 1.10.*

RUN apt-get update \
	&& apt-get install -y ca-certificates nginx=${NGINX_VERSION} \
	&& rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log
	
# fix: *** stack smashing detected ***: nginx: worker process terminated / [alert] 9#9: worker process *process-id* exited on signal 6
RUN sed -i  \
-e "s/worker_processes auto;/worker_processes 1;/g" \
-e "s|# server_names_hash_bucket_size 64;|server_names_hash_bucket_size 64;|" \
/etc/nginx/nginx.conf



RUN [ "cross-build-end" ]
	
EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]