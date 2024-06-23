#### base ####
FROM nginx:latest as base

# Remove the default Nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy the custom HTML file to the Nginx HTML directory
COPY ./index.html /usr/share/nginx/html/index.html

#### prod-server ####
FROM base as prod-server
# No additional changes needed for prod-server

# Expose the port Nginx is running on
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
