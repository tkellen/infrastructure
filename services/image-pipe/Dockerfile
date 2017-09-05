FROM mhart/alpine-node:8.2
MAINTAINER Tyler Kellen <tyler@sleekcode.net>
RUN apk add --no-cache imagemagick
RUN mkdir /opt
WORKDIR /opt
COPY package.json .
COPY package-lock.json .
RUN npm install
COPY src src
RUN npm test
EXPOSE 8000
CMD ["npm", "start"]
