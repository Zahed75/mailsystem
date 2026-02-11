# Custom Snappymail Dockerfile with additional configurations
FROM djmaze/snappymail:latest

# Set timezone
ENV TZ=Asia/Dhaka

# Install additional utilities if needed
RUN apk add --no-cache \
    tzdata \
    curl \
    bash

# Create necessary directories
RUN mkdir -p /var/lib/snappymail

# Set proper permissions
RUN chown -R www-data:www-data /var/lib/snappymail

# Expose port
EXPOSE 8888

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8888/ || exit 1

# Start Snappymail
CMD ["php", "-S", "0.0.0.0:8888", "-t", "/app"]
