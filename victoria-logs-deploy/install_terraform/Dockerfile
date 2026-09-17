FROM python:3.14-slim-trixie AS builder

RUN apt update && apt install wget unzip -y && \
    wget https://mirror.yandex.ru/mirrors/releases.hashicorp.com/terraform/1.16.2/terraform_1.16.2_linux_amd64.zip -O terraform.zip && \
    unzip terraform.zip && chmod +x terraform && mv terraform /tmp/

FROM python:3.14-slim-trixie 

COPY --from=builder /tmp/terraform /usr/local/bin/
COPY .terraformrc /root/

RUN apt update && apt install openssh-client  -y && \
    pip install ansible ansible-core --break-system-packages --no-cache-dir && \
    ansible-galaxy collection install kubernetes.core --force -p /usr/share/ansible/collections && \
    apt-get purge -y --auto-remove && \
    rm -rf /var/lib/apt/lists/*  /root/.cache terraform.zip