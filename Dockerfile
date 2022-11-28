FROM jekyll/builder:4 as builder
# First build the static site with jekyll
WORKDIR /jekyll/
# Create gemfile layers first
COPY ./Gemfile .
COPY ./Gemfile.lock .
RUN bundle install
# Make caching a little better
COPY . .
RUN jekyll build -t

# Then place the built static site on webserver
FROM httpd:alpine

WORKDIR /usr/local/apache2/htdocs/

COPY --from=builder /jekyll/_site .

EXPOSE 80