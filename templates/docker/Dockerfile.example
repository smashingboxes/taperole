FROM node:4.2
RUN mkdir /nodeapp
WORKDIR /nodeapp
COPY package.json /nodeapp/package.json
RUN npm install
COPY . /nodeapp
