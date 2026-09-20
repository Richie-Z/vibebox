FROM debian:12

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
       sudo curl ca-certificates git build-essential \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -m -s /bin/bash u85-deb \
  && usermod -aG sudo u85-deb \
  && echo "u85-deb ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/u85-deb \
  && chmod 0440 /etc/sudoers.d/u85-deb

USER u85-deb
WORKDIR /home/u85-deb

# mise
RUN curl -fsSL https://mise.run | sh

ENV PATH="/home/u85-deb/.local/bin:/home/u85-deb/.local/share/mise/shims:/home/u85-deb/.opencode/bin:${PATH}"

# uv + python via mise 
RUN mise use -g uv@latest python@3.13 \
  && echo 'eval "$(mise activate bash)"' >> ~/.bashrc

# opencode
RUN curl -fsSL https://opencode.ai/install | bash

CMD ["/bin/bash"]
