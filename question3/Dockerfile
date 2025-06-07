FROM ubuntu:latest AS builder

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository universe && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends \
    python3-pip python3-dev \
    build-essential \
    libexpat1 libexpat1-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt ./

RUN pip3 install --no-cache-dir -r requirements.txt --break-system-packages

COPY app.py ./

FROM ubuntu:latest

RUN mkdir -p /usr/src/app/

COPY --from=builder /usr/bin/python3.12 /usr/bin/python3.12

RUN ln -sf /usr/bin/python3.12 /usr/bin/python3

COPY --from=builder /usr/bin/pip3 /usr/bin/pip3

COPY --from=builder /usr/lib/python3.12/ /usr/lib/python3.12/

COPY --from=builder /usr/local/lib/python3.12/dist-packages/ /usr/local/lib/python3.12/dist-packages/

RUN mkdir -p /lib/aarch64-linux-gnu/ /usr/lib/aarch64-linux-gnu/
COPY --from=builder /usr/lib/aarch64-linux-gnu/libpython3.12.so* /usr/lib/aarch64-linux-gnu/
COPY --from=builder /lib/aarch64-linux-gnu/libexpat.so* /lib/aarch64-linux-gnu/
COPY --from=builder /app/app.py /usr/src/app/app.py
COPY --from=builder /app/requirements.txt /usr/src/app/requirements.txt

EXPOSE 5000

CMD ["python3", "/usr/src/app/app.py"]
