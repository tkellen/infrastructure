import express from 'express';
import morgan from 'morgan';
import bodyParser from 'body-parser';

const server = express();

server.use(bodyParser.urlencoded({ extended: true }));
server.use(bodyParser.json());
server.use(morgan('combined'));

export default server;
