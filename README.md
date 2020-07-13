# varnish-dynamic

This Dockerfile builds the [libvmod-dynamic](https://github.com/nigoroll/libvmod-dynamic/) extension and adds it to the official Varnish docker image. The Varnish version is currently pinned to 6.4.

A GitHub action builds this image and uploads it to Docker hub as `richiefi/varnish-dynamic:6.4`.
