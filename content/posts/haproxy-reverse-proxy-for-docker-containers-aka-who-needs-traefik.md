---
title: ' Haproxy Reverse Proxy for Docker Containers (aka Who Needs Traefik?)'
date: 2023-05-17T21:59:00.003-04:00
draft: false
url: /2023/05/haproxy-reverse-proxy-for-docker.html
---

I'm going to describe how to generate an haproxy config based on running docker containers, and run haproxy as a reverse proxy for those containers. We'll include a service directory, which can show us what we're running. All with less than 100 lines of python!

This [Here is the code](https://github.com/mjkelly/experiments/blob/master/docker/docker-tmpl/) -- generate-cfg.py is the key part. The rest of the post will talk about the motivation and decisions behind the code.

\*\*\*  

### Motivation

The reason I want a reverse proxy for docker containers is so that I can:

1.  Access containers via a unique hostname based on container name, instead of accessing them all via the same hostname and obscure port numbers. grafana.example.com instead of example.com:3000!
2.  Add https to containers that don't have it set up already.
3.  Configure TLS (for https) in one place (the reverse proxy) instead of container-by-container.  
    

This setup supports exposing 1 port per container. The container can be exposed over http or https. Haproxy exposes each container on a hostname based on the container name (and a domain you choose), so a container called 'grafana' will be exposed as grafana.example.com. If you give haproxy a link to a TLS private key for \*.example.com, it'll use https as well.

  

**NOTE:** [Traefik](https://traefik.io/) exists and is great for this purpose. Snarky title aside, if you're in a production environment you should probably use that. This is an exercise in how to do this in a minimal, flexible way, with a focus on learning what's actually necessary to set up a usable reverse proxy.

### DNS

In order to make use of this setup, you need a DNS setup that will support it. You should have a domain with a wildcard entry (e.g., something like \*.example.com) for all subdomains. This means that foo.example.com and bar.example.com will resolve to the same host. This is like a classic virtual host web server setup, but we don't know all the hostnames ahead of time.

  

You can configure most DNS servers to direct \*.example.com to a single address.

*   Here are [instructions for Ubiquiti EdgeOS routers with dnsmasq](https://community.ui.com/questions/wild-card-dns/d245e3a7-8240-4f79-b7a6-1c8e1187a473).
*   Here are [instructions for pfsense](https://docs.netgate.com/pfsense/en/latest/services/dns/wildcards.html).
*   Here are [instructions for Route53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/DomainNameFormat.html).  
    

  

To test this setup without changing your DNS server, you can edit the  /etc/hosts file on your laptop/desktop (from which you'll be accessing the exposed docker services) to add a line like this:

  

192.168.1.10 foo.example.com. bar.example.com. baz.example.com.

  

This will direct foo.example.com, bar.example.com, and baz.example.com to 192.168.1.10 on your computer only. Replace with your domains and your docker host's IP address.

### How to Run

This is all designed to be run from the docker host. Unlike a continuously-running setup like Traefik, we do not require a connection to the docker daemon (such as exposing the docker socket to the traefik container).

  

There are 2 parts of this:

1.  Generate output files from jinja2 templates. We'll generate an haproxy config file and a simple HTML service list.
2.  Run docker containers using those templates in some way. We'll run haproxy (using the haproxy config) and an nginx webserver (serving the static HTML service list).

**Part 0: Run a service you want to expose:**

  

Before we even get started, we need to run a web service in a docker container that we want to expose via the reverse-proxy! Here's an example we can use:

  

docker run --rm -it -p 8080:80 \\  
  -l http-port=8080 \\  
  --name example-nginx nginx

  

This will stay running in the foreground. Once it's running you should be able to access localhost:8080 and see the "Welcome to Nginx!" page.

  

**Part 1: Generating configs:**

Once you've run \`make\` to set up your virtualenv, you can run generate-cfg.py to generate an haproxy config and HTML file using the provided templates:

  

```
./venv/bin/python3 ./generate-cfg.py \
  --var domain=example.com \
  --template templates/haproxy.tmpl \
  > $HOME/haproxy.cfg
```

and

```
./venv/bin/python3 ./generate-cfg.py \
  --hostname foo.example.com \
  --template docker-html.tmpl \
  > $HOME/directory.html
```

Check ~/haproxy.cfg and ~/directory.html after running these scripts to see the configs they generated! You should see the container you ran before, example-nginx, listed in ~/directory.html and as a backend in ~/haproxy.cfg.

  

How do we tell which containers to expose? We're checking for a http-port or tls-port label on the running containers. This is how we know which port to expos and whether it's http or https.

  

The logic for extracting the ports is actually not in the python code at all! We just pass a blob of docker metadata to the template, and let it do whatever we want. In this case, we take note of the values of http-port and tls-port on each container, then iterate over each port of each container, exposing the ones that match.

  

  

**Part 2: Running the reverse-proxy and directory server**

  

```
sudo docker run \
  --name haproxy \
  --restart unless-stopped \
  --mount type=bind,src=$HOME/haproxy.cfg,dst=/etc/haproxy.cfg \
  --mount type=bind,src=$HOME/ssl/docker.example.name/fullchain-privkey.pem,dst=/ssl/fullchain-privkey.pem \
  -p 8090:8090 \
  -p 80:80 \
  -p 443:443 \
  -d \
  haproxy \
  haproxy -f /etc/haproxy.cfg
```

We bind to port 80, so we can serve HTTP, 443 so we can serve HTTPS, and 8090 for the admin interface. You can see references to all of this in the haproxy config.

### Putting it all together

It's useful to have a script that starts or updates a running container with a current config. This is what you can re-run anytime you start a new container you want to access by subdomain. There are two such scripts in the README: [https://github.com/mjkelly/experiments/tree/master/docker/docker-tmpl#examples](https://github.com/mjkelly/experiments/tree/master/docker/docker-tmpl#examples)

Note that we can use the script **both** to generate the haproxy config and some of the content we serve (like an HTML file listing all the services we're running).  

Notice how we set http-port in the script that exposes directory.html with nginx. This is so the directory will be picked up by the reverse proxy, so you can go to dir.example.com and see your running containers!

### Limitations & Future Work

Because we're limited to running periodically, we don't pick up new containers as they come up. You could imagine a more advanced setup where we poll the set of containers every 30 seconds or so, and update the configs in running containers if it has changed, then reload haproxy with docker kill -s HUP.