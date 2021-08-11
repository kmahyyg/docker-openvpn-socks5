# docker-openvpn-socks5

Isolate OpenVPN using Docker and convert to Socks5 Proxy.

## Description

- Run an OpenVPN client inside a docker with `tun` device.
- Open a socks5 server using `gost`, a high-performance, actively-maintained all-in-one proxy written in Golang.

## Usage

- Put your VPN file (single-file only) in `/config/vpn`.
  If the VPN requires you to input a password, simply change `auth-user-pass` to `auth-user-pass secret`. And put a file named `secret` in the same folder.

The `secret` file should follow the syntax like:

```
username
password
```

If you need to chain the openvpn proxy, try add `socks-proxy HOST PORT [OPTIONAL AUTH FILE]`, or `http-proxy HOST PORT [AUTH CRED] [AUTH METHOD]` before line `remote HOST PORT`. 

Reference from [OpenVPN manual](https://openvpn.net/community-resources/reference-manual-for-openvpn-2-4/):

```
--http-proxy server port [authfile|'auto'|'auto-nct'] [auth-method]
Connect to remote host through an HTTP proxy at address server and port port. If HTTP Proxy-Authenticate is required, authfile is a file containing a username and password on 2 lines, or "stdin" to prompt from console. Its content can also be specified in the config file with the --http-proxy-user-pass option. (See section on inline files)auth-method should be one of "none", "basic", or "ntlm".
HTTP Digest authentication is supported as well, but only via the auto or auto-nct flags (below).

The auto flag causes OpenVPN to automatically determine the auth-method and query stdin or the management interface for username/password credentials, if required. This flag exists on OpenVPN 2.1 or higher.

The auto-nct flag (no clear-text auth) instructs OpenVPN to automatically determine the authentication method, but to reject weak authentication protocols such as HTTP Basic Authentication.

--http-proxy-option type [parm]
Set extended HTTP proxy options. Repeat to set multiple options.VERSION version -- Set HTTP version number to version (default=1.0).
AGENT user-agent -- Set HTTP "User-Agent" string to user-agent.

CUSTOM-HEADER name content -- Adds the custom Header with name as name and content as the content of the custom HTTP header.

--socks-proxy server [port] [authfile]
Connect to remote host through a Socks5 proxy at address server and port port (default=1080). authfile (optional) is a file containing a username and password on 2 lines, or "stdin" to prompt from console.
```

- Socks5 Server will open on port 1080, HTTP Proxy Server will open on port 3128, Both service offered by GOST!
- If you want add authentication to proxy server or change the port, simply use those two environment variable:

```
OVERRIDE_HTTP_ARGS="user:pass@host:port"
OVERRIDE_SOCKS_ARGS="user:pass@host:port"
```

- Make sure your vpn file is renamed to `vpn.ovpn`
- Correctly mount your openvpn creds via `-v /myvpn:/config/vpn` , and don't forget `-dit --device=/dev/net/tun --cap-add=NET_ADMIN`, also `-p 10000:3128 -p 11000:8080`.

## Credit

- [Gost Project](https://github.com/ginuerzh/gost) (Licensed under MIT)
- [Docker-OpenVPN](https://github.com/curve25519xsalsa20poly1305/docker-openvpn) (Licensed under WTFPL)

## License

GNU AGPL v3.

