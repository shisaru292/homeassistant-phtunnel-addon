# PHTunnel Add-on for Home Assistant

A Home Assistant Add-on that packages PHTunnel (Peanuthull dynamic DNS client) as a containerized service.

一个将花生壳客户端(PHTunnel)封装为容器化服务的 Home Assistant 插件。

## Background

PHTunnel (Peanuthull) client is used for NAT traversal, allowing access to target services from any device running the client within the subnet. If your NAS or router supports direct Peanuthull (Oray HSK) configuration, this add-on is not necessary. However, when you want a Raspberry Pi running HAOS to serve as an HSK client, the official solution presents limitations: they only provide deb files for Raspberry Pi architecture and Docker packages that don't support Raspberry Pi architecture, making neither directly compatible with HAOS. This project repackages the official deb file into a Home Assistant Add-on format to meet this specific need.

## 背景说明

花生壳客户端用于NAT穿透，只要子网内的任意设备运行客户端后都能访问到目标服务。如果你的NAS和路由器支持直接配置花生壳(Oray HSK)则不需要使用该插件。当希望安装了HAOS的树莓派作为HSK客户端时，官方只提供了面向树莓派架构的deb文件，以及不支持树莓派架构的docker封装，因此都无法直接用于HAOS。本项目将官方提供的deb文件重新封装为Home Assistant Addon形式来满足这一需求。