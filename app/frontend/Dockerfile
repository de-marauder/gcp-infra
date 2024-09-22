# Use the official Node.js image as a base image
FROM node:18 AS build

# Set the working directory
WORKDIR /app

# Copy package.json and yarn.lock (if available)
COPY package*.json yarn*.lock ./

# Install dependencies
RUN yarn

# Copy the rest of the application code
COPY . .
# Build the React application with environment variable
ARG VITE_APP_HOSTNAME
ARG VITE_APP_API_HOSTNAME
ENV VITE_APP_HOSTNAME=localhost
ENV VITE_APP_API_HOSTNAME=localhost

EXPOSE 3000

# Build and serve the React application
CMD ["sh", "-c", "yarn build && npx -y serve -s dist -p 3000"]
