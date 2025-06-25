# Demonstration of Flogo using GraphQL

## Demonstrates simplicity of Flogo to implement various resolvers handling the following:

* Retrieve all devices
* Retrieve a device using ID
* Query for devices by manufacturer
* Query for devices by network capability
* Query for devices by well-known fields


## Building the demo

A makefile (yeah i'm old but make works) is provided to build the Flogo Application and create the associated Docker Image.

Run make with the build target...
```bash
make build
```

## Starting the demo

1) Start MongoDB using Docker Compose.
2) Start Flogo Application using Docker Compose

```bash
docker compose -f ./db/docker-compose.yaml up
docker compose up -d
```

## Stopping the demo

Use Docker Compose to stop

```bash
docker compose down
docker compose -f ./db/docker-compose.yaml down
```


## About the GraphQL Endpoint

Our GraphQL endpoint is exposed on: http://localhost:4000/graphql




```graphql
type Device {
  # Basic device information
  id: ID!
  manufacturer: String
  model: String
  year: Int
  picture: String
  
  # Device type and screen
  deviceType: String
  touchScreen: Boolean
  
  # Operating system
  os: String
  osName: String
  osVersion: String
  
  # WAP and browser information
  wapStackVersion: String
  wapBrowserVersion: String
  uaProf: String
  browserType: String
  
  # Network connectivity
  frequency: String
  edge: Boolean
  umts: Boolean
  hsdpa: Boolean
  hsupa: Boolean
  hspa: Boolean
  dcHspa: Boolean
  lte: Boolean
  lteA: Boolean
  volte: Boolean
  wifiCalling: Boolean
  
  # Features
  supportedRingtones: [String]
  supportedVideoFormat: [String]
  hasCamera: Boolean
  hasVideoCall: Boolean
  hasVoiceVoip: Boolean
  hasBluetooth: Boolean
  hasWirelessLan: Boolean
  hasGps: Boolean
  hasJavaMidp: Boolean
  hasSms: Boolean
}

type Query {
  # Get a device by ID
  device(id: ID!): Device
  
  # Get all devices
  devices: [Device]
  
  # Search devices by various criteria
  searchDevices(
    manufacturer: String
    model: String
    year: Int
    deviceType: String
    hasCamera: Boolean
    hasTouchScreen: Boolean
    osName: String
  ): [Device]
  
  # Get devices by manufacturer
  devicesByManufacturer(manufacturer: String!): [Device]
  
  # Get devices by network capability
  devicesByNetworkCapability(
    lte: Boolean
    volte: Boolean
    wifiCalling: Boolean
  ): [Device]
}
```


## Using Apollo GraphQL Playground to test

Open a browser with the following URL https://studio.apollographql.com/sandbox/explorer/?

