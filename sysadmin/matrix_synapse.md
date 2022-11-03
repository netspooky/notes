These are tips and tricks for [Matrix Synapse](https://github.com/matrix-org/synapse/). Assuming that all of this is being done on your server directly.

## Add a new user
```
register_new_matrix_user -c /etc/matrix-synapse/homeserver.yaml http://localhost:8008
```
## Change a user's password. 

You have to create a password hash using `hash_password` and your homeserver file so that it does the type of hashing you want.
```
hash_password -c /etc/matrix-synapse/homeserver.yaml
```
Then switch to the postgres user and update the user with the new hash you just made.
```
sudo su
su postgres
psql
\c synapse
UPDATE users SET password_hash='NEWHASH' WHERE name='@user:your.host';
\q
```
## Clear media cache
Use the [admin API](https://matrix-org.github.io/synapse/latest/admin_api/media_admin_api.html) for this. You can call this API from localhost on your machine.

You will also need an admin user and the auth token for this user. You can grab this from the client supposedly, but I just use the synapse_tokenstore.py script in this folder to log in and create a new session just for this.

First, grab a timestamp that you want to clear from. Syanpse expects a unix timestamp with millisecond precision.
```
date --date='1 year ago' +%s%3N
```
Let's say that this timestamp is `1635382166398`, you will put this at the end of your request after the `before_ts=` part of the URL
```
curl --header "Authorization: Bearer YOURTOKEN" -X POST http://localhost:8008/_synapse/admin/v1/purge_media_cache?before_ts=1635382166398
```
Run that and you should be good. If there is an error it will indicate to you in the json from the server.

## Fixing libolm error in python

I have some bots and services which use libolm via the [matrix-nio](https://github.com/poljar/matrix-nio) library. Sometimes during an update this shared object is overwritten, so fix it like so:

```
sudo ln -sf /usr/local/lib/libolm.so /usr/lib/x86_64-linux-gnu/libolm.so.2
```
