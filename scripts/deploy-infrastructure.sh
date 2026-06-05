#!/bin/bash

# Exit immediately if any command exits with a non-zero status
set -e

# Define standard terminal color output configurations
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=======================================================${NC}"
echo -e "${YELLOW}      STARTTECH AUTOMATED INFRASTRUCTURE DEPLOYMENT    ${NC}"
echo -e "${YELLOW}=======================================================${NC}"

# Navigate to the root terraform directory relative to this script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$SCRIPT_DIR/../terraform"

if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}[ERROR] Target Terraform directory could not be located at: $TARGET_DIR${NC}"
    exit 1
fi

cd "$TARGET_DIR"

echo -e "\n${YELLOW}[1/4] Initializing backend providers and downloading dependencies...${NC}"
terraform init

echo -e "\n${YELLOW}[2/4] Executing static structural compilation verification checks...${NC}"
if terraform validate; then
    echo -e "${GREEN}[SUCCESS] Terraform compilation structure is valid.${NC}"
else
    echo -e "${RED}[ERROR] Configuration syntax check failed. Halting deployment.${NC}"
    exit 1
fi

echo -e "\n${YELLOW}[3/4] Generating descriptive dry-run execution blueprint (Plan)...${NC}"
terraform plan -out=tfplan

echo -e "\n${YELLOW}[4/4] Executing active physical resource construction routines...${NC}"
read -p "Do you want to apply this infrastructure execution blueprint to AWS? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Applying configuration updates to the cloud...${NC}"
    terraform apply -auto-approve tfplan
    echo -e "${GREEN}=======================================================${NC}"
    echo -e "${GREEN} [SUCCESS] StartTech Core Infrastructure Is Operational! ${NC}"
    echo -e "${GREEN}=======================================================${NC}"
else
    echo -e "${YELLOW}[WARNING] Active execution aborted by user. Resources unchanged.${NC}"
fi
