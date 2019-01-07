all:
	@echo "Valid targets: create, start, stop"

create:
	@[ -f _config.yml ] || ( echo "Are you sure that your working directory is a Jekyll repo?" && exit 1 )
	@sudo docker run --name TallerPages \
       			-v `pwd`:/srv/jekyll -p 127.0.0.1:4000:4000 \
                  	jekyll/jekyll:3.6 \
                  	jekyll serve --watch

start: stop
	@sudo docker start TallerPages || true
	@sleep 5 && sudo docker ps | grep TallerPages

stop:
	@sudo docker stop TallerPages || true

