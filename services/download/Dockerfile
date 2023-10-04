FROM bash:alpine3.15

RUN apk add parallel aria2
COPY --chown=1000:1000 . /docker
RUN mkdir -p /data/checkpoints \
    /data/VAE \
    /data/VAE-approx \
    /data/GFPGAN \
    /data/Codeformer \
    /data/RealESRGAN \
    /data/LDSR \
    /data/karlo
RUN chown -R 1000:1000 /data
VOLUME /data/checkpoints \
    /data/VAE \
    /data/VAE-approx \
    /data/GFPGAN \
    /data/Codeformer \
    /data/RealESRGAN \
    /data/LDSR \
    /data/karlo
RUN chmod +x /docker/download.sh
USER 1000:1000
ENTRYPOINT ["/docker/download.sh"]
