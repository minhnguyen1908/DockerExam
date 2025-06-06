# Use this empty Dockerfile to build your assignment

# This dir contains Python app, you need to get it running in a container
# No modifications to the app should be necessary, only edit this Dockerfile

# Instructions from the app developer
# - you should use the 'ubuntu' official image
# - then it should install the Python pip package to the ubuntu linux distribution: 	
		# 'apt-get update -y'
		# 'apt-get install -y python-pip python-dev build-essential'
	# optimize it !
# - then it should create directory /usr/src/app/ for app files with 'mkdir -p /usr/src/app/'
# - then it needs to copy requirements.txt and app.py to /usr/src/app/
# - then it needs to run 'pip install --no-cache-dir -r /usr/src/app/requirements.txt' to install dependencies from that file
# - this app listens on port 5000, but the container should launch on port 80
  #  so it will respond to http://localhost:80 on your computer
# - then it needs to start container with command 'python /usr/src/app/app.py'
# - build this dockerfile with another optimize images and find a smallest

# Stage 1: Builder - for installing dependencies and building
FROM ubuntu:latest AS builder

# 1. Update apt and install essential tools.
#    Enable universe repo, install default python3 (likely 3.12),
#    its dev headers, build tools, and libexpat.
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository universe && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends \
    python3-pip python3-dev \
    build-essential \
    libexpat1 libexpat1-dev && \
    rm -rf /var/lib/apt/lists/*

# Set working directory for your application source
WORKDIR /app

# Copy requirements.txt first to leverage Docker cache
COPY requirements.txt ./

# Install dependencies using pip3.
# Ensure requirements.txt has Flask 0.12.3 and its pinned dependencies:
# Flask==0.12.3
# Werkzeug==0.16.1
# Jinja2==3.0.3
# MarkupSafe==2.0.1
# itsdangerous==1.1.0
# click==7.1.2
RUN pip3 install --no-cache-dir -r requirements.txt --break-system-packages

# Copy the main application file
COPY app.py ./

# --- Stage 2: Runtime - for the final, optimized image ---
FROM ubuntu:latest

# Create the application directory in the final image
RUN mkdir -p /usr/src/app/

# Determine the exact Python 3 executable and its library in the builder.
# We'll assume python3 is python3.12.
# You can confirm this exact path in the builder:
# docker build -t temp_builder --target builder .
# docker run --rm temp_builder ls -l /usr/bin/python3
# docker run --rm temp_builder ls -l /usr/bin/python3.12
# docker run --rm temp_builder ldd /usr/bin/python3.12 # To see its dependencies

# Copy the specific python3.12 executable (not just the symlink /usr/bin/python3)
# It's usually `/usr/bin/python3.12` and `/usr/lib/python3.12/lib-dynload/` for compiled modules
# and the main shared library `/usr/lib/aarch664-linux-gnu/libpython3.12.so.1.0`.
COPY --from=builder /usr/bin/python3.12 /usr/bin/python3.12

# CRITICAL: Create a symlink from /usr/bin/python3 to /usr/bin/python3.12
# This ensures that `CMD ["python3", ...]` can find it.
RUN ln -sf /usr/bin/python3.12 /usr/bin/python3

# Copy pip3 executable
COPY --from=builder /usr/bin/pip3 /usr/bin/pip3

# CRITICAL: Copy the entire Python 3 standard library directory.
# This contains 'encodings' and all other core modules.
# Path based on default Ubuntu Python 3.12.
COPY --from=builder /usr/lib/python3.12/ /usr/lib/python3.12/

# CRITICAL: Copy the site-packages directory where pip installed your Flask dependencies.
COPY --from=builder /usr/local/lib/python3.12/dist-packages/ /usr/local/lib/python3.12/dist-packages/

# CRITICAL: Copy Python's primary shared library (libpython) and other common shared libraries.
# This is usually what `python3: executable file not found` eventually means if the symlink is wrong.
# You need to ensure these directories exist.
RUN mkdir -p /lib/aarch64-linux-gnu/ /usr/lib/aarch64-linux-gnu/
COPY --from=builder /usr/lib/aarch64-linux-gnu/libpython3.12.so* /usr/lib/aarch64-linux-gnu/
COPY --from=builder /lib/aarch64-linux-gnu/libexpat.so* /lib/aarch64-linux-gnu/
# If other shared library errors persist, you might need to find them using `ldd /usr/bin/python3.12`
# on the builder image and copy them individually, OR more pragmatically,
# install the corresponding apt packages in the runtime stage (e.g., libssl3, libffi8, zlib1g, etc.)

# Copy the application files from the builder stage
COPY --from=builder /app/app.py /usr/src/app/app.py
COPY --from=builder /app/requirements.txt /usr/src/app/requirements.txt

# Set the working directory for the runtime container
WORKDIR /usr/src/app

# App listens on port 5000
EXPOSE 5000

# Command to start the application
CMD ["python3", "app.py"]
