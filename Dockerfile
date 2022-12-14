FROM jekyll/builder:4 as builder
# First build the static site with jekyll
WORKDIR /src/jekyll/
# Create gemfile layers first
COPY ./Gemfile .
COPY ./Gemfile.lock .
RUN bundle install
# Makes caching a little better
COPY . .
# Pre-make directory for jekyll
RUN mkdir _site && chown jekyll ./_site && ls -aln && jekyll build -t

# Then place the built static site on webserver
FROM httpd:alpine

WORKDIR /usr/local/apache2/htdocs/

COPY --from=builder /src/jekyll/_site .

EXPOSE 80