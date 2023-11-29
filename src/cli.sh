#!/bin/bash

# Qub CLI
# By @jamonholmgren & @knewter

VERSION="0.0.1"

# What OS are we running on?

OS=$(uname -s)

# Colors

BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
GRAY='\033[0;37m'
DKGRAY='\033[1;30m'
END='\033[0m' # End Color

# Print header

echo ""
echo -e "${BLUE}Qub -- QBasic Website Generator${END}"
echo ""

# Print version and exit

if [[ $1 == "-v" || $1 == "--version" ]]; then
    echo "${VERSION}"
    exit 0
fi

# Help command if provided -h or --help

if [[ $1 == "-h" || $1 == "--help" ]]; then
    echo "Usage: qub [command] [options]"
    echo ""
    echo "Commands:"
    echo "  create          Create a new Qub QB64 web project (coming soon)"
    echo "  setup-server    Set up remote server for deployment (coming soon)"
    echo ""
    echo "Options:"
    echo "  -h, --help      Show help"
    echo "  -v, --version   Show version number"
    echo ""
    echo "Examples:"
    echo "  qub create"
    echo ""
    exit 0
fi

# Create command

if [[ $1 == "create" ]]; then
    echo "Creating new Qub QB64 website project..."
    echo ""
    echo -e "${YELLOW}What domain will this be hosted on?${END} ${DKGRAY}(e.g. jamon.dev)${END}"
    read DOMAIN

    # Check for any whitespace in the domain name
    if [[ $DOMAIN =~ [[:space:]] ]]; then
        echo ""
        echo -e "${RED}Domain name cannot contain whitespace.${END}"
        echo ""
        exit 1
    fi

    # Check if the folder exists (DOMAIN)
    if [[ -d $DOMAIN ]]; then
        echo ""
        echo -e "${RED}Folder already exists.${END}"
        echo ""
        exit 1
    fi

    # Make the folder
    mkdir $DOMAIN
    mkdir $DOMAIN/bin
    mkdir -p $DOMAIN/web/pages
    mkdir -p $DOMAIN/web/static

    GITHUB_TEMPLATE="https://raw.githubusercontent.com/jamonholmgren/qub/main/template"

    # Copy files from Github
    curl -s $GITHUB_TEMPLATE/README.md > $DOMAIN/README.md
    echo "${GREEN}✓${END} README.md"
    curl -s $GITHUB_TEMPLATE/app.bas > $DOMAIN/app.bas
    echo "${GREEN}✓${END} app.bas"
    curl -s $GITHUB_TEMPLATE/bin/install_qb64 > $DOMAIN/bin/install_qb64
    echo "${GREEN}✓${END} bin/install_qb64"
    curl -s $GITHUB_TEMPLATE/bin/build > $DOMAIN/bin/build
    echo "${GREEN}✓${END} bin/build"
    curl -s $GITHUB_TEMPLATE/web/pages/home.html > $DOMAIN/web/pages/home.html
    echo "${GREEN}✓${END} web/pages/home.html"
    curl -s $GITHUB_TEMPLATE/web/pages/contact.html > $DOMAIN/web/pages/contact.html
    echo "${GREEN}✓${END} web/pages/contact.html"
    curl -s $GITHUB_TEMPLATE/web/static/scripts.js > $DOMAIN/web/static/scripts.js
    echo "${GREEN}✓${END} web/static/scripts.js"
    curl -s $GITHUB_TEMPLATE/web/static/styles.css > $DOMAIN/web/static/styles.css
    echo "${GREEN}✓${END} web/static/styles.css"
    curl -s $GITHUB_TEMPLATE/web/footer.html > $DOMAIN/web/footer.html
    echo "${GREEN}✓${END} web/footer.html"
    curl -s $GITHUB_TEMPLATE/web/header.html > $DOMAIN/web/header.html
    echo "${GREEN}✓${END} web/header.html"
    curl -s $GITHUB_TEMPLATE/web/head.html > $DOMAIN/web/head.html
    echo "${GREEN}✓${END} web/head.html"
    
    # Make the binary files executable
    chmod +x $DOMAIN/bin/*

    # Replace the domain name in the README

    if [[ $OS == "Darwin" ]]; then
      sed -i '' "s/\$DOMAIN/$DOMAIN/g" $DOMAIN/README.md
    elif [[ $OS == "Linux" ]]; then
      sed -i "s/\$DOMAIN/$DOMAIN/g" $DOMAIN/README.md
    fi

    # Ask if the user wants to install QB64

    echo ""
    echo -e "${YELLOW}Do you want to install QB64?${END} ${DKGRAY}(y/n)${END}"
    read INSTALL_QB64

    if [[ $INSTALL_QB64 == "y" ]]; then
        echo ""
        echo -e "${YELLOW}Installing QB64...${END}"
        echo ""
        pushd $DOMAIN
        ./bin/install_qb64
        popd
    fi

    exit 0
fi
