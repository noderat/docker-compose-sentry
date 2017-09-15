FROM sentry:latest

ADD https://cdn.rawgit.com/vishnubob/wait-for-it/db049716/wait-for-it.sh /bin/wait-for-it
RUN chmod +x /bin/wait-for-it

COPY custom-entrypoint.sh /custom-entrypoint.sh
RUN chmod +x /custom-entrypoint.sh

EXPOSE 9000
ENTRYPOINT ["/custom-entrypoint.sh"]
CMD ["run", "web"]