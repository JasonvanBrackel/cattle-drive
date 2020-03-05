#!/bin/bash
az group delete -g cattle-drive-k8s --no-wait -y
az group delete -g cattle-drive-rancher --no-wait -y