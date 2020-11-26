#!/bin/bash
systemctl stop container-portus
systemctl stop container-portus-background
systemctl stop container-registry
systemctl stop container-mysql

systemctl start container-registry
systemctl start container-mysql
systemctl start container-portus
systemctl start container-portus-background
