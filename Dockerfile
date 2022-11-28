FROM jekyll/builder:4 as builder
# First build the static site with jekyll
WORKDIR /jekyll/

COPY --chown=jekyll:jekyll ./Gemfile .
COPY --chown=jekyll:jekyll ./Gemfile.lock .
RUN bundle install

COPY --chown=jekyll:jekyll . .
RUN jekyll build -t
ENTRYPOINT [ "jekyll", "build" ]

# Then place the built static site on webserver
FROM httpd:alpine

WORKDIR /usr/local/apache2/htdocs/

COPY --from=builder /jekyll/_site .

EXPOSE 80