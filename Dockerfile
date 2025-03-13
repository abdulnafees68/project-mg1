# Use the official Node.js image as a base
FROM node:18 AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Angular app for production
RUN npm run build --prod

# Serve the built app using nginx
FROM nginx:alpine

# Copy the built Angular app from the previous stage
COPY --from=build /app/dist/angular-minikube /usr/share/nginx/html
COPY nginx-custom.conf /etc/nginx/conf.d/default.conf

# Expose the default port
EXPOSE 80

# Start nginx to serve the app
CMD ["nginx", "-g", "daemon off;"]
