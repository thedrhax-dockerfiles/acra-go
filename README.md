# acra-go [![](https://images.microbadger.com/badges/image/thedrhax/acra-go.svg)](https://hub.docker.com/r/thedrhax/acra-go)

Backend for Application Crash Reports for Android - [ACRA](https://github.com/ACRA/acra).

## Fork details

* Static assets now use relative URLs to allow running acra-go behind an NGINX reverse proxy with custom sub-path.

```
# Start acra-go on port 80 with custom sub-path /acra/
docker run -d --name acra-go -v acra-go:/data thedrhax/acra-go
docker run -d --name proxy --link acra-go:acra -e PROXY=true \
           -e PROXY_HOST=acra/ -e LOCATION=/acra/ \
           thedrhax/nginx-stateless:v0.2.1
```

* Added tabs **Custom Data** and **Build Config** for each report.

* Fixed type of `APP_VERSION_NAME` (part of issue [gen2brain/acra-go#5](https://github.com/gen2brain/acra-go/issues/5)).

## Installation

```
go install -v github.com/gen2brain/acra-go/acra-go
```

This will install server in `$GOPATH/bin/acra-go`.

### Docker

The other way to run acra-go is to deploy a Docker container. The command listed below will start acra-go on port 80 with frontend protected by Basic Auth (*admin:admin*).

```
docker run -d --name acra-go -v acra:/data -p 80:80 \
    -e HTPASSWD_FRONTEND='admin:$apr1$qSR1P5cj$SKkO5nF96Qa99pDhPl3ZV0' \
    thedrhax/acra-go
```

There are two available environment variables:

* `-e HTPASSWD_BACKEND` — .htpasswd string for /send (user reports);
* `-e HTPASSWD_FRONTEND` — .htpasswd string for /view (admin panel);

Reports are saved in `/data`. You can attach a named volume to this directory to achieve data persistence.

```
-v acra-go:/data
```

## Building

The `build.sh` script should configure your system on Linux and build the leveldb version of acra-go in `bin/acra-go`.

### Setup

#### Server

Server by default listens on port 55000, you can bind it to other port like this:

```
acra-go --bind-addr :80
```

#### Client

ACRA should send reports to `http://example.com:55000/send`. Example annotation of your Android `Application` class:

```java
@ReportsCrashes(formUri = "http://example.com:55000/send",
                formUriBasicAuthLogin = "yourusername", // optional
                formUriBasicAuthPassword = "y0uRpa$$w0rd", // optional
                reportType = org.acra.sender.HttpSender.Type.JSON, // recommended
                mode = ReportingInteractionMode.TOAST,
                resToastText = R.string.crash_toast_text)
public class MyApplication extends Application {
...
}
```

### Usage

```
Usage of acra-go:
  --bind-addr string
        Bind address (default ":55000")
  --database-dir string
        Path to database directory (default ".")
  --htpasswd-backend string
        Path to htpasswd file, if empty backend auth is disabled
  --htpasswd-frontend string
        Path to htpasswd file, if empty frontend auth is disabled
  --read-timeout int
        Read timeout (seconds) (default 5)
  --write-timeout int
        Write timeout (seconds) (default 15)
```

### Pages

* `/`: dashboard of the crashes
* `/send`: accepts POST and PUT requests from you app and stores report in db
* `/view`: view all reports, returns json
* `/view?id=9823648d-20f6-4663-b8b5-f66f9fc97f81`: view a single report, identified by report id

### Screenshot

![screenshot](https://goo.gl/E38Gyw)
