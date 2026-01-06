FROM debian:bookworm

# Enable i386 architecture for 32-bit libraries
RUN dpkg --add-architecture i386 && \
  apt-get update;

# Install build tools + 32-bit support + X11/OpenGL
RUN apt-get install -y \
    gcc \
    gcc-multilib \
    libc6-dev-i386 \
    make \
    pkg-config \
    libx11-dev:i386 \
    libxrandr-dev:i386 \
    libxinerama-dev:i386 \
    libxcursor-dev:i386 \
    libxi-dev:i386 \
    libgl1-mesa-dev:i386 \
    libglu1-mesa-dev:i386 \
    libasound2-dev:i386 \
    libwayland-dev:i386 \
    libxkbcommon-dev:i386 \
    libpthread-stubs0-dev:i386 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*;

# Work directory inside container
WORKDIR /workspace

# Copy project into container
COPY . .

# Command
CMD ["bash"]
