FROM nginx
RUN rm /etc/nginx/conf.d/default.conf
ADD /provisioning/nginx.conf /etc/nginx/conf.d
ADD trailer /var/www/trailer
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
