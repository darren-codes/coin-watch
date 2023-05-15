# Project Title

**Coin Watch**

## Description

This project allows you to create alerts for specific coins *(Bitcoin for now)* and get notified when the price of the coin matches the alert price.  
Watching of price happens using the [binance websocket](wss://stream.binance.com:9443/ws/btcusdt@trade).  
Alerts are created using endpoints. The postman collection can be found in this project that consists of all the endpoints.  
Also a png file is present that details the High Level Design of the solution *(CoinWatchHLD.png)*.

## Components

### &emsp;Server
The server consists of a sinatra application that is connected to a postgres instance. The db consists of two tables *user* and *alert* to store the user and alert information respectively.
#### &emsp; *Endpoints*
- POST /user/create  
  *create a user with unique id*  
  required fields: ["id", "name", "email", "password"]
- DELETE /user/delete  
  *delete a user*  
  required fields: ["id", "password"]
- GET /user/token  
  *get jet token for user*  
  required fields: ["id", "password"]  
- POST /alert/create  
  *create alert based on price and currency*  
  required fields: ["user_id", "coin", "price", "currency", "password"]
- DELETE /alert/delete  
  *delete an alert*   
  required fields: ["id", "user_id", "password"]
- GET /alert/all  
  *get all alerts for a user*  
  can be paginated by passing **offset**, **limit**, and **filter** params  
  filter: ["created", "triggered", "deleted"]  
  required fields: ["user_id", "password"]

All endpoints return a response status code and a string body. Refer postman collection.

#### &emsp;&emsp; *Db Schema*
- user  
  id => string primary_key  
  name => string  
  email => string  
  password => string  
  status => string
- alert  
  id => number primary_key  
  user_id => string  
  coin => string  
  price => string  
  currency => string  
  status => string

### &emsp;AlertCreater
Creates an alert whenever a record in the alert table matches the current bitcoin price. The alert is a message in the queue (kafka). The queue is consumed by the AlertSender.  
The service opens a websocket to binance for trade prices. This service is also connected to the postgres instance.

### &emsp;AlertSender
This service listens for alerts created in the queue (kafka) and sends an email to the user who created the alert. Currently the service only prints to console.  

## Getting Started

### Dependencies

* Docker
  * [Windows Installing](https://docs.docker.com/desktop/install/windows-install/) 
  * [Mac Installation](https://docs.docker.com/desktop/install/mac-install/) 
* Postman (Optional)
  * [Windows Installing](https://learning.postman.com/docs/getting-started/installation-and-updates/#installing-postman-on-windows)
  * [Mac Installation](https://learning.postman.com/docs/getting-started/installation-and-updates/#installing-postman-on-mac)


### Executing program

* Run
```
docker-compose up 
```

## Improvements
- JWT authentication is not yet implemented
- Redis cache for endpoints in not yet implemented
- Current prices are in USDT and need to be converted to local currency during comparision when sending alerts
