FROM debian:12

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
       sudo curl ca-certificates git build-essential \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -m -s /bin/bash richie \
  && usermod -aG sudo richie \
  && echo "richie ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/richie \
  && chmod 0440 /etc/sudoers.d/richie

USER richie
WORKDIR /home/richie

# mise
RUN curl -fsSL https://mise.run | sh

ENV PATH="/home/richie/.local/bin:/home/richie/.local/share/mise/shims:/home/richie/.opencode/bin:${PATH}"

# uv + python via mise
RUN mise use -g uv@latest python@3.13 \
  && echo 'eval "$(mise activate bash)"' >> ~/.bashrc

# opencode
RUN curl -fsSL https://opencode.ai/install | bash

CMD ["/bin/bash"]
