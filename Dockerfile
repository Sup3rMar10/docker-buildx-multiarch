# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM python:3.12-slim AS build
# BUILDPLATFORM is the machine doing the build; TARGETARCH is what the image is for.
ARG TARGETARCH
RUN echo "building for ${TARGETARCH} on ${BUILDPLATFORM}" > /info.txt

FROM python:3.12-slim
COPY --from=build /info.txt /info.txt
RUN useradd --uid 10001 --no-create-home appuser
USER appuser
CMD ["cat", "/info.txt"]
