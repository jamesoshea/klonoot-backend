# Brouter-server + Docker
This is a Docker image for [brouter-server](https://github.com/abrensch/brouter)

## How to install

1. ```cp .example.env .env```
2.  There is 1.6.3 version of brouter-server by default. If you want to try another version, change VERSION= param in the .env file.
3. ```./download-segments.sh``` downloads all segments to ./data/segments (~7G)
4. ```./download-profiles.sh``` downloads default profiles to ./data/profiles
5. ```docker-compose up -d```

Check that the server works: 

```bash
curl -I "http://localhost:17777/brouter?lonlats=8.799297,49.565883|8.811764,49.563606&nogos=&profile=trekking&alternativeidx=0&format=gpx"
```