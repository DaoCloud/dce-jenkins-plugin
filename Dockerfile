FROM jenkins

USER root
ENV NGINX_VERSION 1.11.9-1~jessie

RUN echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
                        ca-certificates \
                        nginx=${NGINX_VERSION} \
                        nginx-module-xslt \
                        nginx-module-geoip \
                        nginx-module-image-filter \
                        nginx-module-perl \
                        nginx-module-njs \
                        gettext-base \
    && rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443
ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/entrypoint.sh", "/usr/local/bin/jenkins.sh"]

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY jenkins.conf /etc/nginx/conf.d/jenkins.conf
COPY plugin.json /usr/share/nginx/html/plugin.json

LABEL io.daocloud.dce.plugin.name="Jenkins" \
      io.daocloud.dce.plugin.description="Jenkins 的前身是 Hudson 是一个可扩展的持续集成引擎" \
      io.daocloud.dce.plugin.categories="continuous-integration" \
      io.daocloud.dce.plugin.icon-src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0naHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmcnIHZpZXdCb3g9JzAgMCAyMDAgMjAwJz4gPGc+IDxwYXRoIGQ9J00xNjEuOTYyLDk2LjhjMCwzNS0yNy43NDEsNjMuMzc3LTYxLjk2MSw2My4zNzdTMzguMDQsMTMxLjgsMzguMDQsOTYuOCw2NS43ODEsMzMuNDIsMTAwLDMzLjQyLDE2MS45NjIsNjEuOCwxNjEuOTYyLDk2LjgnIGZpbGw9JyNkMzM4MzMnLz4gPHBhdGggZD0nTTQwLjU2NSwxMTIuNDk0UzM2LjA4LDQ2LjQsOTYuOTc5LDQ0LjUxNEw5Mi43MywzNy40MzNjLTM0LjkzMywwLTU4Ljg1LDMzLjk4OC01NC4wNTQsNjguNDUyQTM0Ljk4MiwzNC45ODIsMCwwLDAsNDAuNTY1LDExMi40OTRaJyBmaWxsPScjZWYzZDNhJy8+IDxwYXRoIGQ9J001Ny41NjMsNTMuNTYzYTYxLjk4Nyw2MS45ODcsMCwwLDAtMTcuNiw0My40NzFoMGE2MS45ODEsNjEuOTgxLDAsMCwwLDE3LjYsNDMuNDY4aDBBNTkuMTQ3LDU5LjE0NywwLDAsMCwxMDAsMTU4LjQ4NmgwQTU5LjE0Niw1OS4xNDYsMCwwLDAsMTQyLjQzNywxNDAuNWgwYTYxLjk4NSw2MS45ODUsMCwwLDAsMTcuNi00My40NjhoMGE2MS45OTEsNjEuOTkxLDAsMCwwLTE3LjYtNDMuNDcxaDBBNTkuMTYsNTkuMTYsMCwwLDAsMTAwLDM1LjU4aDBBNTkuMTYxLDU5LjE2MSwwLDAsMCw1Ny41NjMsNTMuNTYzaDBabS0yLjc1Miw4OS42MjlhNjUuODQsNjUuODQsMCwwLDEtMTguNy00Ni4xNThoMGE2NS44NDEsNjUuODQxLDAsMCwxLDE4LjctNDYuMTZoMEE2Myw2MywwLDAsMSwxMDAsMzEuNzMyaDBhNjMsNjMsMCwwLDEsNDUuMTg5LDE5LjE0MmgwYTY1LjgzNCw2NS44MzQsMCwwLDEsMTguNyw0Ni4xNmgwYTY1LjgzLDY1LjgzLDAsMCwxLTE4LjcsNDYuMTU4aDBBNjMuMDEyLDYzLjAxMiwwLDAsMSwxMDAsMTYyLjMzNWgwYTYzLjAxNiw2My4wMTYsMCwwLDEtNDUuMTg5LTE5LjE0M2gwJyBmaWxsPScjMjMxZjIwJy8+IDxwYXRoIGQ9J00xMjYuMDgzLDk3LjE0OWwtOS40NDIsMS40MTYtMTIuNzQ2LDEuNDE2LTguMjYyLjIzNi04LjAyNS0uMjM2TDgxLjQ3LDk4LjA5M2wtNS40MjktNS45TDcxLjc5Miw4MC4xNTRsLTAuOTQ0LTIuNi01LjY2NS0xLjg4OC0zLjMtNS40MjktMi4zNi03Ljc4OSwyLjYtNi44NDUsNi4xMzctMi4xMjQsNC45NTcsMi4zNjEsMi4zNjEsNS4xOTMsMi44MzMtLjQ3MiwwLjk0NC0xLjE4TDc4LjQsNTMuOTUzbC0wLjIzNy02Ljg0NSwxLjQxNi05LjQ0MS0wLjA1NS01LjM5Myw0LjMtNi44ODEsNy41NTMtNS40MjlMMTA0LjYsMTQuM2wxNC42MzQsMi4xMjQsMTIuNzQ2LDkuMjA2LDUuOSw5LjQ0MSwzLjc3Niw2Ljg0NSwwLjk0NCwxNy0yLjgzMywxNC42MzVMMTM0LjU4LDg2LjUyN2wtNC45NTcsNi44NDVaJyBmaWxsPScjZjBkNmI3Jy8+IDxwYXRoIGQ9J00xMTguMDU3LDEzNy45ODRMODQuMywxMzkuNHY1LjY2NWwyLjgzMywxOS44MjgtMS40MTYsMS42NTMtMjMuNi04LjAyNi0xLjY1My0yLjgzM0w1OC4xLDEyOS4wMTVsLTUuNDI4LTE2LjA1MS0xLjE4MS0zLjc3Nkw3MC4zNzYsOTYuMjA1bDUuOS0yLjM2MSw1LjE5Myw2LjM3Myw0LjQ4NSw0LjAxMyw1LjE5MywxLjY1MiwyLjM2LDAuNzA4LDIuODMzLDEyLjI3NCwyLjEyNCwyLjYsNS40MjktMS44ODgtMy43NzcsNy4zMTgsMjAuNTM2LDkuNjc3LTIuNiwxLjQxNicgZmlsbD0nIzMzNTA2MScvPiA8cGF0aCBkPSdNNjIuMTE1LDU1LjYwNWw2LjEzNy0yLjEyNCw0Ljk1NywyLjM2MSwyLjM2MSw1LjE5MywyLjgzMy0uNDcyTDc5LjExLDU3LjczLDc3LjY5NCw1Mi4zLDc5LjExLDM5LjMxOSw3Ny45MywzMi4yMzdsNC4yNDktNC45NTcsOS4yMDYtNy4zMTctMi42LTMuNTQxTDc1LjgwNSwyMi44bC01LjQyOSw0LjI0OS0zLjA2OCw2LjYwOS00LjcyMSw2LjM3M0w2MS4xNyw0Ny41OGwwLjk0NSw4LjAyNScgZmlsbD0nIzZkNmI2ZCcvPiA8cGF0aCBkPSdNNzEuNzkyLDMzLjQxOHMzLjU0MS04LjczMywxNy43LTEyLjk4MiwwLjcwOC0zLjA2OS43MDgtMy4wNjlsLTE1LjM0Miw1LjktNS45LDUuOS0yLjYsNC43MjEsNS40MjgtLjQ3MicgZmlsbD0nI2RjZDlkOCcvPiA8cGF0aCBkPSdNNjQuNzExLDUzLjk1M1M1OS43NTQsMzcuNDMsNzguNjM4LDM1LjA3TDc3LjkzLDMyLjIzNyw2NC45NDgsMzUuMzA2LDYxLjE3LDQ3LjU4bDAuOTQ1LDguMDI1LDIuNi0xLjY1MicgZmlsbD0nI2RjZDlkOCcvPiA8cGF0aCBkPSdNNzIuMjY1LDc1LjkwNWwzLjA5MS0yLjk5NWExLjk5LDEuOTksMCwwLDEsMS42MzEsMS44MTRjMC4yMzYsMS42NTMuOTQ0LDE2LjUyMywxMS4wOTQsMjQuNTQ5LDAuOTI2LDAuNzMyLTcuNTUzLTEuMTgxLTcuNTUzLTEuMTgxbC03LjU1NC0xMS44JyBmaWxsPScjZjdlNGNkJy8+IDxwYXRoIGQ9J00xMTUuNyw3MS40MjFzMC41NS03LjE1NSwyLjQ3Ny02LjZhMi42NTIsMi42NTIsMCwwLDEsMS45MjcsMi40NzdzLTQuNjc5LDMuMDI3LTQuNCw0LjEyOCcgZmlsbD0nI2Y3ZTRjZCcvPiA8cGF0aCBkPSdNMTM1LjI4OCw0NS4yMnMtMy44OS44MjEtNC4yNDksNC4yNDksNC4yNDksMC43MDgsNC45NTcuNDcyJyBmaWxsPScjZjdlNGNkJy8+IDxwYXRoIGQ9J00xMDYuNzI3LDQ1LjQ1N3MtNS4xOTMuNzA4LTUuMTkzLDQuMDEyLDUuOSwzLjA2OSw3LjU1NCwxLjY1MycgZmlsbD0nI2Y3ZTRjZCcvPiA8cGF0aCBkPSdNNzQuNjI1LDYwLjhzLTguOTctNS40MjktOS45MTQtLjIzNi0zLjA2OSw4Ljk3LDEuNDE2LDE0LjRhMTEuNjYyLDExLjY2MiwwLDAsMS01LjktOC4yNjFjLTEuMDg2LTYuMDA2LjI3MS0xMS4xMTMsNC40ODUtMTIuNzQ3LDMuMjIyLTEuMjUsNy41NDkuMTI3LDguMjYxLDEuMDMyUzc0LjYyNSw2MC44LDc0LjYyNSw2MC44JyBmaWxsPScjZjdlNGNkJy8+IDxwYXRoIGQ9J003OC44NzQsNDUuOTI4czQuMDEzLTIwLjc3MSwyNC4zMTMtMjQuNzg0YzE2LjcxMy0zLjMsMjUuNDkyLjcwOCwyOC44LDQuNDg1LDAsMC0xNC44NzEtMTcuNy0yOS4wMzMtMTIuMjc0Uzc4LjQsMjguNyw3OC42MzgsMzUuMDdjMC40LDEwLjg1NC4yMzYsMTAuODU4LDAuMjM2LDEwLjg1OCcgZmlsbD0nI2Y3ZTRjZCcvPiA8cGF0aCBkPSdNMTMzLjYzNiwyNy45ODlzLTYuODQ1LS4yMzYtNy4wODEsNS45YTQuNjkyLDQuNjkyLDAsMCwwLC40NzIsMS44ODhzNS40My02LjEzNyw4LjczNC0yLjgzM1onIGZpbGw9JyNmN2U0Y2QnLz4gPHBhdGggZD0nTTEwMy42NjIsMzYuNDE3cy0xLjE3OC05LjQyLTkuMjEtMy45NDRjLTUuMTkzLDMuNTQxLTQuNzIsOC41LTMuNzc3LDkuNDQxczAuNjg3LDIuODQ2LDEuNDA2LDEuNTQxLDAuNDgyLTUuNTU0LDMuMDc5LTYuNzM0LDYuODUzLTIuNSw4LjUtLjMwNScgZmlsbD0nI2Y3ZTRjZCcvPiA8cGF0aCBkPSdNODEuNDcsMTAwLjIxN2wtMjIuMTg4LDkuOTE0czkuMjA2LDM2LjU4Nyw0LjQ4NCw0Ny45MTdsLTMuMy0xLjE4LTAuMjM2LTEzLjkyN0w1NC4wOSwxMTYuNWwtMi42LTcuMzE4TDc0LjYyNSw5My42MDlsNi44NDUsNi42MDgnIGZpbGw9JyM0OTcyOGInLz4gPHBhdGggZD0nTTgzLjc1MiwxMjAuNDU0bDMuMTQ4LDMuODQxdjE0LjE2M0g4My4xMjJzLTAuNDcyLTkuOTE0LS40NzItMTEuMDk0LDAuNDcyLTUuNDI5LjQ3Mi01LjQyOScgZmlsbD0nIzQ5NzI4YicvPiA8cGF0aCBkPSdNODMuODMxLDE0MC41ODFsLTEwLjYyMi40NzIsMy4wNjksMi4xMjQsNy41NTMsMS4xOCcgZmlsbD0nIzQ5NzI4YicvPiA8cGF0aCBkPSdNMTIwLjE4MiwxMzguMjJsOC43MzMtLjIzNiwyLjEyNCwyMS43MTYtOC45NywxLjE4LTEuODg4LTIyLjY2JyBmaWxsPScjMzM1MDYxJy8+IDxwYXRoIGQ9J00xMjIuNTQyLDEzOC4yMmwxMy4yMTktLjcwOHM1LjQyOC0xMy42OSw1LjQyOC0xNC40LDQuNzIxLTE5LjgyNyw0LjcyMS0xOS44MjdMMTM1LjI4OCw5Mi4xOTMsMTMzLjE2NCw5MC4zLDEyNy41LDk1Ljk2OXYyMS45NTJsLTQuOTU3LDIwLjMnIGZpbGw9JyMzMzUwNjEnLz4gPHBhdGggZD0nTTEyOC40NDMsMTM2LjU2OGwtOC4yNjEsMS42NTIsMS4xOCw2LjYxYzMuMDY4LDEuNDE2LDguMjYyLTIuMzYxLDguMjYyLTIuMzYxWicgZmlsbD0nIzQ5NzI4YicvPiA8cGF0aCBkPSdNMTI4LjY3OSw5NS4yNjFMMTQ1LjIsMTA3LjUzNWwwLjQ3Mi01LjY2NUwxMzMuMTY0LDkwLjNsLTQuNDg1LDQuOTU3JyBmaWxsPScjNDk3MjhiJy8+IDxwYXRoIGQ9J005Mi4wMjIsMTg0LjcyM2wtNC44ODctMTkuODNMODQuNywxNTAuMjYxLDg0LjMsMTM5LjRsMjIuMTE4LTEuMTc3LDEzLjc2MSwwLTEuMjUxLDI0Ljc4NywyLjEyNCwxOS4xMTktMC4yMzYsMy41NDEtMTcuOTM5LDEuNDE2LTEwLjg1OC0yLjM2JyBmaWxsPScjZmZmJy8+IDxwYXRoIGQ9J00xMTcuMTEzLDEzNy45ODRzLTEuMTgsMjQuNTQ5LDIuMzYxLDQyLjAxNWE0NS4wOTMsNDUuMDkzLDAsMCwxLTE3LjQ2OCw1LjY2NWwxOS44MjgtLjcwOCwyLjM2LTEuNDE2LTIuODMzLTM4LjcxLTAuNzA4LTguMjYyWicgZmlsbD0nI2RjZDlkOCcvPiA8cGF0aCBkPSdNMTMxLjQ0MiwxNTcuODE0bDkuMjA2LTIuNiwxNy40NjctLjk0NCwyLjYtOC4wMjUtNC43MjEtMTMuOTI3LTUuNDI4LS43MDgtNy41NTQsMi4zNi03LjI0NywzLjUzOC0zLjg0Ny0uNzA2LTMsMS4xNzhaJyBmaWxsPScjZmZmJy8+IDxwYXRoIGQ9J00xMzEuMjc1LDE1My4wOTFzNi4xMzctMi44MzIsNy4wODEtMi42bC0yLjYtMTIuOTgzLDMuMDY4LTEuMThzMi4xMjQsMTIuMjc0LDIuMTI0LDEzLjY5YzAsMCwxMy4yMTguNzA4LDE0LjQsMC43MDgsMCwwLDIuODMzLTUuNDI5LDIuMTI0LTExLjA5NGwyLjYsNy41NTMsMC4yMzYsNC4yNDktMy43NzYsNS42NjUtNC4yNDkuOTQ0LTcuMDgxLS4yMzYtMi4zNi0zLjA2OC04LjI2MiwxLjE4LTIuNi45NDVaJyBmaWxsPScjZGNkOWQ4Jy8+IDxwYXRoIGQ9J00xMjIsMTM2LjMzNWwtNS4xOTMtMTMuMjE5LTUuNDI5LTcuNzg5czEuMTgtMy4zLDIuODMzLTMuM2g1LjQyOWw1LjE5MywxLjg4OS0wLjQ3Miw4LjczM0wxMjIsMTM2LjMzNScgZmlsbD0nI2ZmZicvPiA8cGF0aCBkPSdNMTIzLjAxNCwxMzEuODQ3cy02LjYxLTEyLjc0Ni02LjYxLTE0LjYzNGMwLDAsMS4xOC0yLjgzMywyLjgzMy0yLjEyNHM1LjE5MywyLjYsNS4xOTMsMi42VjExMy4ybC04LjAyNi0xLjY1My01LjQyOC43MDgsOS4yMDYsMjEuNzE2LDEuODg4LDAuMjM3JyBmaWxsPScjZGNkOWQ4Jy8+IDxwYXRoIGQ9J005NC4xNDcsMTAwLjY5M2wtNi41MzktLjcxMUw4MS40Nyw5OC4wOTN2Mi4xMjRsMywzLjMwNyw5LjQ0Miw0LjI0OScgZmlsbD0nI2ZmZicvPiA8cGF0aCBkPSdNODMuNiwxMDEuNHM3LjMxOCwzLjA2OSw5LjY3OCwyLjM2MWwwLjIzNSwyLjgzTDg2LjksMTA1LjE3N2wtNC4wMTMtMi44MzNMODMuNiwxMDEuNCcgZmlsbD0nI2RjZDlkOCcvPiA8cGF0aCBkPSdNMTMxLjQxNiwxMTIuODI2YTQ0Ljg1LDQ0Ljg1LDAsMCwxLTEwLjc5Mi0xLjQ4N2MwLjIxNS0xLjMtLjE4OC0yLjU3My4xMzYtMy41MDksMC44ODMtLjYzNiwyLjM2My0wLjYyNiwzLjctMC43NzVhNi40MzQsNi40MzQsMCwwLDAtNC4xMDgtLjQ2NCw2LjU3Myw2LjU3MywwLDAsMC0uNjgxLTIuMTY1YzIuMjUyLS44LDcuNTY4LTYuMDczLDEwLjU1OC00LjMyOCwxLjQyNSwwLjgzLDIuMDMsNS41NywyLjE0MSw3Ljg3NSwwLjA5MiwxLjkxMi0uMTczLDMuODQxLTAuOTUyLDQuODUzJyBmaWxsPScjZDMzODMzJy8+IDxwYXRoIGQ9J00xMTIuMjYzLDEwNi4yNzhjLTAuMDExLjMtLjAyMywwLjYwOC0wLjAzNSwwLjkxNC0xLjI1MS44MjEtMy4yNjksMC44MTItNC42NDIsMS41YTEyLjA2MSwxMi4wNjEsMCwwLDEsNC45OTQsMS4yNjNxLTAuMDQ2LDEuMTQ1LS4wODksMi4yODljLTIuMjkyLDEuNTY5LTQuMzg2LDMuOTA2LTcuMDg1LDUuMzc4LTEuMjc2LjctNS43NTQsMi40ODctNy4xMTIsMi4xNy0wLjc2OC0uMTc4LTAuODM3LTEuMTMyLTEuMTQ0LTIuMDMtMC42NTQtMS45MjQtMi4xNi00Ljk4Ny0yLjI5Mi03Ljg4My0wLjE2Ny0zLjY1OC0uNTM3LTkuNzg5LDMuNDA2LTkuMDM2YTM1LjIxOCwzNS4yMTgsMCwwLDEsOS4zNDIsMy40MTdjMS41LDAuODIzLDIuMzc1LDEuODQsNC42NTgsMi4wMTUnIGZpbGw9JyNkMzM4MzMnLz4gPHBhdGggZD0nTTEyMi4yMzUsMTEyLjI1OHMtMS42NTMtMi4zNjEtLjQ3Mi0zLjA2OSwyLjM2MSwwLDMuMDY5LTEuMTgsMC0xLjg4OS4yMzYtMy4zLDEuNDE3LTEuNjUzLDIuNi0xLjg4OSw0LjQ4NS0uNzA4LDQuOTU3LjQ3MkwxMzEuMiw5OS4wNGwtMi44MzMtLjk0NC04Ljk3LDUuMTkzLTAuNDcyLDIuNnY1LjE5MycgZmlsbD0nI2VmM2QzYScvPiA8cGF0aCBkPSdNOTcuNDUxLDEyMC4wNDhxLTAuNDI1LTUuNTI2LS45MTgtMTEuMDQzYy0wLjUtNS41LDEuMzItNC41MzYsNi4wODMtNC41MzYsMC43MjgsMCw0LjQ4Ljg2Nyw0Ljc0OCwxLjQxNiwxLjI4NywyLjYyOS0yLjE1MywyLjA0NSwxLjQ4Myw0LjAyOCwzLjA2OSwxLjY3Myw4LjQ5LTEuMDE2LDcuMjUxLTQuNzM2LTAuNjk0LS44MjctMy42MTYtMC4yNTgtNC42NjMtMC44bC01LjUzMi0yLjg2OGMtMi4zNDYtMS4yMTctNy43NjktMi45OTItMTAuMjctMS4yOTEtNi4zMzgsNC4zMS40LDE1LjA4LDIuNjYxLDE5LjU3NycgZmlsbD0nI2VmM2QzYScvPiA8cGF0aCBkPSdNMTAzLjY2MiwzNi40MTdjLTYuNDMzLTEuNS05LjYzLDIuNjkyLTExLjU4LDcuMDM5LTEuNzQxLS40MjItMS4wNDgtMi43OS0wLjYwOS00LDEuMTUyLTMuMTY3LDUuNzkyLTcuMzgyLDkuNTg0LTYuODExLDEuNjMyLDAuMjQ2LDMuODQsMS43MzgsMi42LDMuNzY5JyBmaWxsPScjMjMxZjIwJy8+IDxwYXRoIGQ9J00xMzUuMDA4LDQzLjc0NGwwLjMwNSwwLjAxMmMxLjQ1NCwzLjAyLDIuNzEyLDYuMjE5LDQuNTQ2LDguODg2LTEuMjI5LDIuODYyLTkuMyw1LjM5NC05LjE3OS4yNTYsMS43NDYtLjc2Myw0Ljc2MS0wLjE1Niw2LjMwOS0xLjEzMS0wLjktMi40NTYtMi4xODctNC41NDgtMS45ODEtOC4wMjInIGZpbGw9JyMyMzFmMjAnLz4gPHBhdGggZD0nTTEwNi45NTYsNDMuODIyYzEuMzc5LDIuNTI5LDEuODI4LDUuMTg2LDMuNzg5LDcuMSwwLjg4MywwLjg2LDIuNiwxLjkwOSwxLjc0OSw0LjNBNS40NTYsNS40NTYsMCwwLDEsMTEwLDU3LjI5MWMtMy4wNjUuOS0xMC4yMDgsMC4xODctNy43OS0zLjYzNSwyLjUzNSwwLjExOCw1Ljk0MywxLjY0Niw3LjgzOC0uMTk0LTEuNDU1LTIuMzI2LTQuMDQ5LTYuOTI4LTMuMDk1LTkuNjQnIGZpbGw9JyMyMzFmMjAnLz4gPHBhdGggZD0nTTEzMy44NTgsNjkuNTIzYy00LjYxNiwyLjk2NS05Ljc2Miw2LjE4OS0xNy4zMjUsNS40NDFhNS4xMjksNS4xMjksMCwwLDEtLjY2Mi02LjZjMC44MTcsMS40LjMsMy45ODksMi41ODEsNC4zNzgsNC4yOTEsMC43MzQsOS4yODYtMi42MjUsMTIuMzcyLTMuOCwxLjkxNC0zLjIyNy0uMTY1LTQuNDE0LTEuODg5LTYuNDkxLTMuNTMtNC4yNTUtOC4yNjUtOS41MjktOC4wOTMtMTUuOSwxLjQyNy0xLjAzNSwxLjU1LDEuNTc5LDEuNzU1LDIuMDU1LDEuODQzLDQuMzE0LDYuNDgyLDkuODMxLDkuODY4LDEzLjUyMywwLjgzMSwwLjkwOSwyLjIsMS43ODIsMi4zNTIsMi4zODMsMC40MzksMS43NDgtMS4xNDIsMy44NDMtLjk1OSw1LjAwNicgZmlsbD0nIzIzMWYyMCcvPiA8cGF0aCBkPSdNNzMuMDA5LDY2LjRjLTEuNDQ3LS44MjYtMS43OTEtNC40NjMtMy40OS00LjU2Ni0yLjQyNy0uMTQ3LTEuOTg1LDQuNzE4LTEuOTc1LDcuNTYzLTEuNjcxLTEuNTE3LTEuOTY1LTYuMTg3LS43MzctOC41ODUtMS40LS42ODctMi4wMjMuNzU4LTIuOCwxLjI2NywxLTcuMjQ0LDEwLjYtMy4zNiw5LDQuMzIxJyBmaWxsPScjMjMxZjIwJy8+IDxwYXRoIGQ9J00xMzYuOCw3Mi41NGMtMi4xNDgsNC4wODktNS4xODgsOC41OTMtMTEuNDkyLDguNzI0YTE1LjU2NywxNS41NjcsMCwwLDEsLjAwNy00LjEyNmM0LjgyLS40NjMsNy44LTIuOTE2LDExLjQ4NS00LjYnIGZpbGw9JyMyMzFmMjAnLz4gPHBhdGggZD0nTTEwNi41OTIsNzUuMTkxYzQuMDIxLDIuMTE0LDExLjQxMSwyLjM0MiwxNi44NzYsMi4xODJhMTkuMTM3LDE5LjEzNywwLDAsMSwuMyw0LjEzN2MtNy4wMjUuMzUxLTE1LjMzMi0xLjM4OC0xNy4xNzQtNi4zMTknIGZpbGw9JyMyMzFmMjAnLz4gPHBhdGggZD0nTTEwNS44MjgsNzkuMTM0YzIuNzgxLDYuOTgxLDEyLjMzNyw2LjE3OCwyMC40LDUuOTg1YTQuMzExLDQuMzExLDAsMCwxLTIuMDgsMi4zNjRjLTIuNTgzLDEuMDUxLTkuNzA2LDEuODQ4LTEzLjI5MS0uMDU2LTIuMjc0LTEuMjA5LTMuNzM1LTMuOTQtNC45OC01LjU0MS0wLjYtLjc3My0zLjYtMi43NDgtMC4wNDYtMi43NTInIGZpbGw9JyMyMzFmMjAnLz4gPHBhdGggZD0nTTEzMy41MjIsMTE3LjY0NGMtMy4yNjMsNS41ODktNi4zODUsMTEuMzI5LTEwLjI1NiwxNi4yNTgsMS42MjMtNC43NzIsMi4zMTgtMTIuNzU5LDIuNTYzLTE4Ljg0OCwzLjQtMS41ODksNi4zLjM1OCw3LjY5NCwyLjU5JyBmaWxsPScjODFiMGM0Jy8+IDxwYXRoIGQ9J00xNTEuMDgxLDEzNy43M2MtMy42NTMuNzMxLTYuMjIsNC4yODItOS43ODQsNC4wNTQsMS45NTktMi43NjEsNS4zOTEtMy45MjUsOS43ODQtNC4wNTQnIGZpbGw9JyMyMzFmMjAnLz4gPHBhdGggZD0nTTE1Mi42OTIsMTQzLjQ0N2E1My41MzEsNTMuNTMxLDAsMCwxLTkuNS41NDhjMS40My0yLjE4NCw2LjkzOC0xLjQzLDkuNS0uNTQ4JyBmaWxsPScjMjMxZjIwJy8+IDxwYXRoIGQ9J00xNTMuNzI0LDE0OC4zNzZjLTMuMzQ3LjA3My03LjUwNiwwLjAwNi0xMC42ODctLjI2MSwxLjg4MS0yLjAyMSw4LjUxNy0uNzUsMTAuNjg3LjI2MScgZmlsbD0nIzIzMWYyMCcvPiA8cGF0aCBkPSdNMTI3LjIyNSwxNjEuODY1YzAuNDgsNC4yLDIuMTQ2LDguNDYxLDEuOTM3LDEzLjA2NGExMy42ODIsMTMuNjgyLDAsMCwxLTUuMzkyLDEuMTY2Yy0wLjE3NS0zLjkxMi0uNy05Ljg5Mi0wLjU0Mi0xMy42MjEsMS4yMTksMC4wODEsMy4wMTctLjg3MSw0LTAuNjEnIGZpbGw9JyNkY2Q5ZDgnLz4gPHBhdGggZD0nTTEyMS44Myw5OS45MjRjLTEuNjgsMS4xLTMuMTEyLDIuNDY2LTQuNzI1LDMuNjM4LTMuNTc5LjE3Ny01LjUzMi0uMjQ4LTguMTYxLTIuM2ExLjI1MiwxLjI1MiwwLDAsMCwuMzE3LTAuMjk0YzMuODMxLDEuNzA3LDguNy0uNywxMi41NjktMS4wNDEnIGZpbGw9JyNmMGQ2YjcnLz4gPHBhdGggZD0nTTEwMS43MTksMTI2LjAzOGMxLjA1My00LjU2MSw1LjE3Ny02LjkyMyw4LjkyMi05LjQzNSwzLjg2Niw0LjkwNiw2LjIxNywxMS4yMTUsOC44MDYsMTcuM2E5MC4yMzYsOTAuMjM2LDAsMCwxLTE3LjcyOC03Ljg2OScgZmlsbD0nIzgxYjBjNCcvPiA8cGF0aCBkPSdNMTIzLjIyOSwxNjIuNDc1Yy0wLjE1NiwzLjcyOS4zNjcsOS43MDksMC41NDIsMTMuNjIxYTEzLjY4MiwxMy42ODIsMCwwLDAsNS4zOTItMS4xNjZjMC4yMDktNC42LTEuNDU3LTguODYxLTEuOTM3LTEzLjA2NEMxMjYuMjQ2LDE2MS42LDEyNC40NDgsMTYyLjU1NiwxMjMuMjI5LDE2Mi40NzVabS0zOC42LTIxLjIwOGMxLjYzNSwxNS4wMjksNCwyNy42NjIsOC4zNDUsNDAuOTcsOS42MzksMi45MjcsMjEuMjU4LDMuMTgyLDI5Ljc3Ny41NDEtMS41NjQtNy41MTEtLjg4MS0xNi42NTYtMS44LTI0LjY3MS0wLjY4OS02LjAyNS0uMzM4LTEyLjA4Ni0xLjI4Mi0xOC4yMzNDMTA5LjM0OCwxMzcuNzI3LDk0Ljc1NywxMzkuMzczLDg0LjYyNiwxNDEuMjY4Wm0zNy40ODYtMS4zYy0wLjA4Nyw2LjQ1NC4yODksMTIuODIxLDAuNzgyLDE5LjI4NCwyLjQ3OC0uMzcyLDQuMTYtMC42Miw2LjQ2My0xLjEyNS0wLjc0OC02LjIyMi0uNjU2LTEzLjIyMi0yLjE3OS0xOC43MjZBMTUuMzU2LDE1LjM1NiwwLDAsMCwxMjIuMTEyLDEzOS45NjlabTEyLjU3My0xLjA0YTE1LjQ0NCwxNS40NDQsMCwwLDAtMy42Ny4wMTFjMC41MjgsNS4yNjEsMS44MSwxMS4wNjcsMi4yNjEsMTYuNTksMS43NjgsMC4wNTUsMi43MTMtLjc3OSw0LjE2Ny0xLjA1OSwwLjA3OC00Ljg0OC0uNDIzLTExLjUyNy0yLjc1OS0xNS41NDJoMFptMTkuMDM3LDE3LjM5NGMzLjY4Ni0uOSw2LTUuNDA5LDQuOTcyLTEwLjA0NS0wLjY5Mi0zLjExNi0xLjkyNC04Ljk4My0zLjI0My0xMC45NzYtMC45NzQtMS40NzQtMy42MTYtMy40LTUuNzI2LTIuMDU0LTMuNDMyLDIuMi05LjQ3NywyLjgzNS0xMS45NzksNS41LDEuMjU1LDQuMTc4LDEuNjQ0LDkuOTE3LDIuMTYyLDE1LjIxLDQuMjg3LDAuMjY3LDkuNTYyLTEuMTgsMTMuMTI3LjM1Ni0yLjQ4OS44MDYtNS43MTksMC44MTMtNy44NjksMS45ODgsMS43NTgsMC44NDksNS44NzIuNjc3LDguNTU2LDAuMDI2aDBabS0zNC4yNzUtMjIuNDE1Yy0yLjU4OS02LjA4OC00Ljk0LTEyLjQtOC44MDYtMTcuMy0zLjc0NSwyLjUxMi03Ljg2OSw0Ljg3NC04LjkyMiw5LjQzNUE5MC4yMzYsOTAuMjM2LDAsMCwwLDExOS40NDcsMTMzLjkwN1ptNi4zODItMTguODU0Yy0wLjI0NSw2LjA4OS0uOTQsMTQuMDc2LTIuNTYzLDE4Ljg0OCwzLjg3MS00LjkyOSw2Ljk5My0xMC42NjksMTAuMjU2LTE2LjI1OEMxMzIuMTMxLDExNS40MTEsMTI5LjIyNCwxMTMuNDY0LDEyNS44MjgsMTE1LjA1M1ptLTcuMjM0LTIuNTdjLTEuNDY3LS4xNTgtMi43MTEsMS42ODYtNC42MTguODg5LTAuNDM3LjQ4My0uODM0LDEuMDA2LTEuMjgsMS40NzgsNC4yMTIsNS4wNzYsNi4xMjYsMTIuMjc3LDkuMzc5LDE4LjI0MywxLjc0Ni01LjczLDEuNTQ0LTEyLjAwOCwxLjkyOS0xOC4yNjJDMTIxLjYwNiwxMTQuOTgzLDEyMC4yNzUsMTEyLjY2MSwxMTguNTk0LDExMi40ODNabS00LjY1Mi02LjEzOWMtMC4xNTYsMS43MzguMjQ4LDIuMzA3LDAuNiw0LjNDMTIwLjI1NSwxMTIuNDMsMTE5LjI1NywxMDIuOCwxMTMuOTQyLDEwNi4zNDNabS02LjMzNy0yLjA4YTM1LjIxOCwzNS4yMTgsMCwwLDAtOS4zNDItMy40MTdjLTMuOTQyLS43NTQtMy41NzMsNS4zNzgtMy40MDYsOS4wMzYsMC4xMzEsMi45LDEuNjM4LDUuOTU5LDIuMjkyLDcuODgzLDAuMzA3LDAuOS4zNzYsMS44NTIsMS4xNDQsMi4wMywxLjM1OCwwLjMxNiw1LjgzNi0xLjQ3NCw3LjExMi0yLjE3LDIuNy0xLjQ3Miw0Ljc5My0zLjgwOCw3LjA4NS01LjM3OHEwLjA0NS0xLjE0NS4wODktMi4yODlhMTIuMDYxLDEyLjA2MSwwLDAsMC00Ljk5NC0xLjI2M2MxLjM3Mi0uNjksMy4zOTEtMC42ODEsNC42NDItMS41LDAuMDEyLS4zMDYuMDI1LTAuNjExLDAuMDM1LTAuOTE0QzEwOS45OCwxMDYuMSwxMDkuMTEsMTA1LjA4NiwxMDcuNjA1LDEwNC4yNjNaTTg0LjA4Niw5OS45OTFjLTIuMDQ0LDIuMDc1LDUuNzMyLDQuOSw4LjIwOCw1LjA1NS0wLjAxNC0xLjMxMy43NDgtMi41NTEsMC41OTUtMy40OTJDODkuOTQ4LDEwMS4wMzcsODYuMDg0LDEwMS4zNzgsODQuMDg2LDk5Ljk5MVptMjUuMTc1LDAuOTc0YTEuMjUyLDEuMjUyLDAsMCwxLS4zMTcuMjk0YzIuNjI5LDIuMDU1LDQuNTgyLDIuNDgsOC4xNjEsMi4zLDEuNjE0LTEuMTcxLDMuMDQ1LTIuNTQxLDQuNzI1LTMuNjM4QzExNy45NjIsMTAwLjI3LDExMy4wOTIsMTAyLjY3MiwxMDkuMjYxLDEwMC45NjVabTIzLjEwOCw3LjAwN2MtMC4xMS0yLjMtLjcxNi03LjA0NS0yLjE0MS03Ljg3NS0yLjk5LTEuNzQ2LTguMzA2LDMuNTI0LTEwLjU1OCw0LjMyOGE2LjU3Myw2LjU3MywwLDAsMSwuNjgxLDIuMTY1LDYuNDM0LDYuNDM0LDAsMCwxLDQuMTA4LjQ2NGMtMS4zMzUuMTQ5LTIuODE1LDAuMTM5LTMuNywwLjc3NS0wLjMyNC45MzUsMC4wNzksMi4yMS0uMTM2LDMuNTA5YTQ0Ljg1LDQ0Ljg1LDAsMCwwLDEwLjc5MiwxLjQ4N0MxMzIuMTk1LDExMS44MTMsMTMyLjQ2MSwxMDkuODg0LDEzMi4zNjgsMTA3Ljk3MlpNODAuNjQ1LDEwMmMtMC42NDItLjQ1Ny00Ljk4My02LjEwNi01LjU3OC01Ljg3Mi03Ljg1NiwzLjEtMTUuMiw4LjQ1NS0yMS43NjUsMTMuNTIyLDYuMjU4LDEzLjQyOSw4Ljc4NSwyOS44ODIsOS4yMzEsNDUuNzM5QzY5LjcsMTU4Ljc0LDc2LDE2My41NzQsODUuNzI4LDE2NC4wNzhjLTEuMTI2LTcuOTY1LTIuMTUzLTE1LjA3MS0yLjc5Mi0yMi41Ny0yLjQ0NC0xLjAzLTUuOTUxLjA0Ny04LjIzOS0uMzItMC4wMTktMi43NTcsMy40OTQtMS4yMDcsMy43ODYtMy4wNjEsMC4yMjEtMS40LTEuOTMzLTEuNTA4LTEuMjMyLTMuNzE2LDEuNzg4LDAuNjUsMi43MjcsMi4wODYsNC42MzUsMi42MjUsMS43NDMtMy44MTMtLjAyNC0xMC41NTguMjI3LTEzLjc0NSwwLjA0OC0uNi4zLTMuMzE1LDEuNjM5LTIuODM4LDEuMTg2LDAuNDIyLS4wNjgsNy4yMjQuMDYyLDEwLjI0LDAuMTE4LDIuNzc5LS4zMzYsNS40NjcuNzksNy4yMTJhMjY4LjYyOSwyNjguNjI5LDAsMCwxLDI5LjEyNS0yLjM4Niw3MC40NzEsNzAuNDcxLDAsMCwxLTcuODEtMy41MTJjLTEuNTgtLjg5MS02LjU2LTIuNzQ0LTcuMDE2LTQuMjQ1LTAuNzI3LTIuMzkxLDEuOTA5LTMuNjY1LDIuMzU5LTUuNzE1LTQuNzQ1LDIuNTg4LTUuNjcxLTIuNDgxLTYuNzk0LTYuMDcyYTQ3LjE5NCw0Ny4xOTQsMCwwLDEtMS44NDYtNy41NThDODguNTM0LDEwNi40Nyw4NC4xNjQsMTA0LjUsODAuNjQ1LDEwMmgwWm00Ny41NzEtNS4xODhjNi41NDUtMy4xNzQsNy43MjUsMTEuODYyLDUuMTU5LDE2LjcwNSwwLjQsMS40NDUsMS43NiwyLDIuMzE3LDMuMy0zLjY1Myw2LjU0My03LjcwOSwxMi42NTEtMTEuNDM2LDE5LjExNywyLjc3Mi0xLjcyNiw2LjczMi0uMzA5LDkuOTk0LTEuNiwxLjE5Mi0uNDcyLDIuMDU2LTMuMiwyLjk1OS01LjM4NWExMTcuMTIzLDExNy4xMjMsMCwwLDAsNi4yNTEtMTkuMzE3YzAuMjYyLTEuMzA2Ljk3Ni00LjE1MywwLjgxNi01LjMxNi0wLjI4NS0yLjA4Mi0zLjExLTMuNjI2LTQuNTQ3LTQuOTEzLTIuNjQ3LTIuMzc4LTQuMzE0LTQuNDctNy4wNzUtNi42OTQtMS4xMiwxLjY1My0zLjUyMiwyLjc2My00LjQzOCw0LjEwN2gwWk02NS42NzcsMzguNzY1QzYyLjU1OCw0Mi4yLDYzLjIxMSw0OC42MjcsNjMuNTg4LDUzLjJjNS42MzctMy41NDYsMTMuMTIuMjgsMTMuMDQ5LDYuMzEyLDIuNjkxLS4wNzIsMS4wMDUtMy4zNjEuNTE5LTUuNDgxLTEuNTkxLTYuOTIzLDIuNjgtMTQuNDQ0LjE5NC0yMC43NzRhMTcuMTA3LDE3LjEwNywwLDAsMC0xMS42NzMsNS41MDdoMFpNODcuOTkyLDE4Ljg0OWMtNy4wNjEsMi0xNi4xMDksNy4xMzItMTkuMDExLDEzLjQ3NCwyLjI0Ny0uMzI2LDMuODA2LTEuNDU5LDYuMDIyLTEuNiwwLjgzOC0uMDU1LDEuOTM1LjM1MSwyLjksMC4xMTIsMS45MTgtLjQ3NiwzLjUzNy00Ljc3Nyw0Ljk4NS02LjM3NywxLjQxMS0xLjU2MywzLjEwNi0yLjIzMSw0LjI2Ny0zLjY1NSwwLjc0Ni0uMzYsMS44NDgtMC4zMzUsMS44OS0xLjQ1NEExLjEsMS4xLDAsMCwwLDg3Ljk5MiwxOC44NDlabTM2Ljc1NCwxLjg4MmMtNy4zMjgtNC4xMzUtMTkuNzMzLTcuMjQ1LTI3LjUyOC0zLjM1OS02LjI5LDMuMTM2LTE0Ljc5Myw4LjMyNS0xNy42OTIsMTQuOSwyLjcwOCw2LjM0Ni0uOCwxMi4xNi0xLjAyNiwxOC42Qzc4LjM4MSw1NC4zLDgwLjExNCw1Ny4zLDgwLjI0Nyw2MS4wMjhjLTAuOTI3LDEuNTI5LTMuNzU4LDEuNzE3LTUuNzE4LDEuNjEyLTAuNjYtMy4zLTEuODE1LTcuMDEyLTUuMjE0LTcuMzg0LTQuODEtLjUyNi04LjMyNywzLjQ1NS04LjU0Niw3LjYxNS0wLjI1OSw0Ljg5MiwzLjc1OCwxMyw5LjQ1LDEyLjQzOCwyLjItLjIxNywyLjczOS0yLjQyMiw1LjEzNS0yLjQsMS4zLDIuNTkxLTIsMy40LTIuMzQzLDUuMjU4QTE0Ljg4NiwxNC44ODYsMCwwLDAsNzMuNSw4MS40LDQ0LjAzOCw0NC4wMzgsMCwwLDAsNzkuMSw5NC40NDljMi44OCw0LjEyNiw4LjUzNyw0Ljc0NywxNC42MjMsNS4xNTIsMS4wODctMi4zNDIsNS4wOTItMi4xNDksNy43LTEuNTM3LTMuMTI3LTEuMjM5LTYuMDM0LTQuMjQxLTguNDQ0LTYuOS0yLjc2OC0zLjA0OS01LjU3MS02LjMyLTUuNzEzLTEwLjMwNSw1LjIzLDcuMjU1LDkuNTUxLDEzLjU5MiwxOS4wNiwxNi43ODMsNy4yLDIuNDEzLDE1LjYtMS4xMDYsMjEuMTI5LTQuOTg5LDIuMjk0LTEuNjE0LDMuNjY0LTQuMTc0LDUuMjk1LTYuNTE4LDYuMS04Ljc3Nyw4Ljk0OS0yMS4zMDUsOC4zMjMtMzMuNDQ4LTAuMjU4LTUuMDA4LS4yNDYtMTAtMS45MjctMTMuMzY4LTEuNzU2LTMuNTIzLTcuNy02LjY3NS0xMS4xNzMtMy40ODgtMC42NDQtMy40MjYsMi44OTEtNS41NDUsNy4wNDQtNC4zMTItMi45NjEtMy44MjItNi4wNjktOC40MTQtMTAuMjc4LTEwLjc4OWgwWk0xMzguNCwxMzMuNzI1YzUuNzI3LTIuODQ3LDE2LjQyNi03LjY2MywyMC4wMTcuMDFhNjUuMDYxLDY1LjA2MSwwLDAsMSwzLjU2NSwxMC41MjljMC45NjksNC4xMTktMS4wNTEsMTIuNzc3LTUuMjg1LDE0LjE1OWEyNS4xMjcsMjUuMTI3LDAsMCwxLTEyLjYwNy4yNDEsNi44NjgsNi44NjgsMCwwLDEtMS41MzQtMi4wMTIsMTcuNCwxNy40LDAsMCwwLTguNzY5LDEuNDk1YzAuMjQxLDIuMzc5LTEuMzY4LDIuNzYtMi44NzYsMy4yNS0xLjExOCw0LjQzNCwyLjIzNywxMC4yMjMsMS40MzQsMTQuMjY2LTAuNTczLDIuODgtNC4xMTYsMy4zMjUtNi43MjEsMy44NjRhMjIuMTI2LDIyLjEyNiwwLDAsMCwuMjkyLDQuMjkxYy0wLjYsMi4xOTQtMy4yNjcsMy40NDQtNS44LDMuNzQ5LTguMzI3LDEtMjAuOTcsMS40NTEtMjguOTc5LTEuNDI5LTIuMjM1LTUuNDgyLTQtMTIuMTUtNS44NTctMTguNDEtNy44MTEuODM0LTE0LjEyOS0zLjM3MS0yMC4wODUtNi4xMjUtMi4wNjItLjk1Ni00LjkxNS0xLjQ4My01LjY4NS0zLjEyNC0wLjc0Ny0xLjU4OS0uNDQxLTQuNjM1LTAuNjI3LTcuNTEyLTAuNDcyLTcuMzQ4LS44NzUtMTQuNDM2LTIuODE2LTIxLjk2LTAuODcxLTMuMzc2LTIuMzktNi4zNTUtMy40NDktOS42MDktMC45NzktMy4wMTUtMi42OS02Ljc0MS0zLjEzNi05Ljc0OC0wLjY2Mi00LjQ1NiwzLjUzNS00LjcsNi4yMTgtNi42MzUsNC4xNDgtMi45ODYsNy40LTQuNjM4LDExLjktNy4zMzMsMS4zMy0uOCw1LjM0My0yLjgxOCw1LjgtMy43NDksMC45MDctMS44NDUtMS41NTctNC40NDYtMi4yMTYtNS44OTJhMTcuNzIxLDE3LjcyMSwwLDAsMS0xLjczNS02LjQ4NSwxMi41MTEsMTIuNTExLDAsMCwxLTguMzUtNS4zNjdjLTIuODU0LTQuMTg1LTQuODM0LTExLjkyOC0yLjM2NC0xNy44MTdhMTEuNTM1LDExLjUzNSwwLDAsMCwxLjMtMi4wODhjMC4yODEtMS40LS41MjktMy4yNjgtMC41NzktNC43Ni0wLjI1OS03LjY1NSwxLjMtMTQuMjUsNi40NDgtMTYuNTU5LDIuMDkyLTguMzM0LDkuNTgtMTEuMSwxNi42MzQtMTUuMjQ3YTUyLjMwNyw1Mi4zMDcsMCwwLDEsOC41NDYtMy42NDJjMTAuNzY5LTMuOTYzLDI3LjI5My0zLjIxNywzNi4yMywzLjU0MywzLjc5LDIuODY2LDkuODQ4LDguOTE5LDEyLjAxNSwxMy4zLDUuNzIzLDExLjU2OSw1LjMxNywzMC45LDEuMzE0LDQ0Ljk3NWE0NS4yNzEsNDUuMjcxLDAsMCwxLTIuNDA4LDYuOTM2Yy0wLjc2LDEuNTg1LTMuMTIxLDQuNzU2LTIuODM1LDYuMTU1LDAuMywxLjQ0Nyw1LjM4NSw1LjMxMSw2LjQ3Niw2LjM2MywxLjk2NSwxLjksNS43LDQuNDEyLDYsNi44LDAuMzI1LDIuNTQ2LTEuMTIyLDYuMDI4LTEuODU1LDguNDg1LTIuNDUsOC4yLTQuODQxLDE1Ljc3Ni03LjYxOSwyMy4wODQnIGZpbGw9JyMyMzFmMjAnLz4gPHBhdGggZD0nTTEwMC4xOTQsNzYuOTc3YzAuMzExLS40MTQsMi4wMTktMS4wNDIsNC40MDkuMTA5LDAsMC0yLjgzMy40NzItMi42LDUuMTk1bC0xLjE4LS4yMzdzLTEuMjItNC4yODItLjYzMi01LjA2NycgZmlsbD0nI2Y3ZTRjZCcvPiA8cGF0aCBkPSdNMTIwLjg5LDExNy41NjdhMS4zLDEuMywwLDEsMS0xLjMtMS4zLDEuMywxLjMsMCwwLDEsMS4zLDEuMycgZmlsbD0nIzFkMTkxOScvPiA8cGF0aCBkPSdNMTIyLjE4OCwxMjMuNTg2YTEuMywxLjMsMCwxLDEtMS4zLTEuMywxLjMsMS4zLDAsMCwxLDEuMywxLjMnIGZpbGw9JyMxZDE5MTknLz4gPC9nPiA8L3N2Zz4=" \
      io.daocloud.dce.plugin.vendor="Community" \
      io.daocloud.dce.plugin.required-dce-version=">=2.2.0" \
      io.daocloud.dce.plugin.nano-cpus-limit="500000000" \
      io.daocloud.dce.plugin.memory-bytes-limit="52428800"
