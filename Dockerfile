# Use the official Node.js 20 image as the base
FROM node:bookworm

# Install Docker CLI
RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json (if they exist)
COPY package*.json ./

# Install Node.js dependencies
RUN npm install https://github.com/MichaelBuhler/ao-localnet.git#610f64922d4a9361547de0d548184e24c114d268
RUN npx ao-localnet configure     # generate wallets and download AOS module
RUN npx ao-localnet start         # run Docker containers (build them if necessary)
RUN npx ao-localnet seed          # seed AOS and Scheduler info into the localnet

# Copy the rest of the application code
COPY . .