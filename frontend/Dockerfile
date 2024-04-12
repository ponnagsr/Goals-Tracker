#Setting the base image as node(latest will be pulled if the version is not mentioned)
FROM node:14-alpine

#Setting the working directory
WORKDIR /app

#Copying the package.json before my source code files
COPY package.json .

#Installing the necessary dependencies
RUN npm install

#Copying the remaining files from the current working directory
COPY . .

#Exposing the port 80 as my application listens on port 80
EXPOSE 80

#Command to start my container
CMD [ "npm", "start" ]