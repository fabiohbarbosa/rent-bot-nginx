#!/bin/bash
CURRENT_VERSION=$(head -n 1 VERSION)

if [ -z "$CURRENT_VERSION" ]; then
    printf "1.0.0" > VERSION

    git status

    NEXT_VERSION=$(head -n 1 VERSION)
    echo "The release version will be ${NEXT_VERSION}"
    exit 0
fi

git status

ARRAY=($(echo $CURRENT_VERSION | tr '.' "\n"))
MINOR_VERSION=${ARRAY[2]}
NEXT_MINOR=$((${MINOR_VERSION} + 1))
NEXT_VERSION=$(printf "${ARRAY[0]}.${ARRAY[1]}.${NEXT_MINOR}")

printf ${NEXT_VERSION} > VERSION

echo "The release version will be ${NEXT_VERSION}"