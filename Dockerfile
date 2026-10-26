# Cloudflare Tunnel for Sonoff iHost (Rockchip RV1109 / RV1126, 32-bit ARMv7)
# Base: Multi-architecture minimal build from Erisa (actively maintained)
FROM erisamoe/cloudflared:latest

LABEL org.opencontainers.image.title="cloudflared-ihost"
LABEL org.opencontainers.image.description="Cloudflare Tunnel client pre-configured for Sonoff iHost (eWeLink CUBE)"
LABEL org.opencontainers.image.authors="nikovsk1"

# Pre-baked arguments so Sonoff iHost's Web UI can leave the Command field completely empty
CMD ["tunnel", "run"]
