# Use the official Node.js image as a base image
FROM node:18

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and yarn.lock (if available)
COPY package*.json yarn*.lock ./

# Install dependencies
RUN yarn

# Copy the rest of the application code
COPY . .

# Expose the port the app runs on
EXPOSE 5000

# Start the application
CMD ["node", "index.js"]
