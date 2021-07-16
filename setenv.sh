#!/usr/bin/env bash

#export $(grep -v '^#' .env | xargs)
export $(grep -v '^#' env.sample | xargs)

