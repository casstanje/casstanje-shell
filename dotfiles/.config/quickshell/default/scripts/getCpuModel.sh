#!/bin/bash
lscpu | grep "Model name:" | sed -r 's/Model name:\s{1,}//g'