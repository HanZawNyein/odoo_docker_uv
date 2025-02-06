FROM odoo:18.0

USER root

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates python3-pip python3-venv

# Download and install `uv`
ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh

# Ensure the installed binary is on the system PATH
ENV PATH="/root/.local/bin/:$PATH"

# Install dependencies system-wide
ENV UV_SYSTEM_PYTHON=1

# Set working directory
WORKDIR /opt/odoo

COPY ./pyproject.toml /opt/odoo/pyproject.toml
RUN uv pip install -r pyproject.toml --break-system-packages

# Change to Odoo user
USER odoo

# Run Odoo
CMD ["odoo"]