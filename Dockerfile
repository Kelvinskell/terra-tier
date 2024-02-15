# Use an official Python runtime as a parent image
FROM python:3.10

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt update -y && apt upgrade -y && apt install -y \
    python3-flask \
    python3-pip \
    python3-venv \
    sox \
    ffmpeg \
    libcairo2 \
    libcairo2-dev \
    python3-dev \
    default-libmysqlclient-dev \
    build-essential \
 && rm -rf /var/lib/apt/lists/*

# Copy the current directory contents into the container at /app
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Environment variables
ENV FLASK_APP=run.py
ENV FLASK_ENV=production

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Command to run the Flask application
CMD ["flask", "run", "-h", "0.0.0.0"]
