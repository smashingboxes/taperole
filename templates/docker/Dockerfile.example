FROM node:4.2
RUN mkdir /nodeapp
WORKDIR /nodeapp
ADD package.json /nodeapp/package.json
RUN npm install
ADD . /nodeapp
