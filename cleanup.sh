#!/bin/bash

terraform destroy --auto-approve

az login --use-device-code

az ad sp delete --id "http://$service_principal_name"