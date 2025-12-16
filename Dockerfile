FROM wordpress:latest

COPY mpm-patch.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/mpm-patch.sh

ENTRYPOINT ["/usr/local/bin/mpm-patch.sh"]
CMD ["apache2-foreground"]
