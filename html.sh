#!/bin/bash

# Create directories for HTML files
mkdir -p html_8081 html_8082 html_8083 html_8084 html_8085

# Create HTML files for each port
echo "<!DOCTYPE html>
<html>
<head>
  <title>Port 8081 - HTML Page</title>
</head>
<body>
  <h1>This is Port 8081</h1>
  <p>This HTML file is served on port 8081.</p>
</body>
</html>" > html_8081/index.html

echo "<!DOCTYPE html>
<html>
<head>
  <title>Port 8082 - HTML Page</title>
</head>
<body>
  <h1>This is Port 8082</h1>
  <p>This HTML file is served on port 8082.</p>
</body>
</html>" > html_8082/index.html

echo "<!DOCTYPE html>
<html>
<head>
  <title>Port 8083 - HTML Page</title>
</head>
<body>
  <h1>This is Port 8083</h1>
  <p>This HTML file is served on port 8083.</p>
</body>
</html>" > html_8083/index.html

echo "<!DOCTYPE html>
<html>
<head>
  <title>Port 8084 - HTML Page</title>
</head>
<body>
  <h1>This is Port 8084</h1>
  <p>This HTML file is served on port 8084.</p>
</body>
</html>" > html_8084/index.html

echo "<!DOCTYPE html>
<html>
<head>
  <title>Port 8085 - HTML Page</title>
</head>
<body>
  <h1>This is Port 8085</h1>
  <p>This HTML file is served on port 8085.</p>
</body>
</html>" > html_8085/index.html

# Create Dockerfile
echo "FROM nginx:stable-alpine

COPY html_8081 /usr/share/nginx/html_8081
COPY html_8082 /usr/share/nginx/html_8082
COPY html_8083 /usr/share/nginx/html_8083
COPY html_8084 /usr/share/nginx/html_8084
COPY html_8085 /usr/share/nginx/html_8085

EXPOSE 8081
EXPOSE 8082
EXPOSE 8083
EXPOSE 8084
EXPOSE 8085

CMD [\"nginx\", \"-g\", \"daemon off;\"]" > Dockerfile

# Build Docker image
docker build -t my-nginx-container .

# Run Docker containers for each port
for port in {8081..8085}; do
    docker run -d -p $port:$port my-nginx-container
done

