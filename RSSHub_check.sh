#!/bin/bash

url1="http://127.0.0.1:1200/xidian/job/campus?check"
url2="http://127.0.0.1:1200/xidian/job/jobs?check"

while true; do
  response=$(curl -s -o /dev/null -w "%{http_code}" $url1)
  if [ "$response" -eq 200 ]; then
    echo "Website A-xidian/job/campus is up"
    sleep 60
    response=$(curl -s -o /dev/null -w "%{http_code}" $url2)
    if [ "$response" -eq 200 ]; then
      echo "Website B-xidian/job/jobs is up"
      sleep 60
    else
      echo "Website B-xidian/job/jobs is down. Monitoring..."
      count=0
      while true; do
        response=$(curl -s -o /dev/null -w "%{http_code}" $url2)
        if [ "$response" -eq 200 ]; then
          echo "Website B-xidian/job/jobs is up. Resuming normal monitoring."
          break
        else
          ((count++))
          if [ "$count" -eq 10 ]; then
            echo "Website B-xidian/job/jobs has been down for 10 consecutive checks. Restarting RSSHub."
            tmux send-keys -t RSSHub:0 C-c
            sleep 1
            tmux send-keys -t RSSHub:0 "npm start" C-m
            sleep 60
            count=0
          else
            echo "Website B-xidian/job/jobs is still down. Monitoring again in 1 minute."
            sleep 60
          fi
        fi
      done
    fi
  else
    echo "Website A-xidian/job/campus is down. Monitoring..."
    count=0
    while true; do
      response=$(curl -s -o /dev/null -w "%{http_code}" $url1)
      if [ "$response" -eq 200 ]; then
        echo "Website A-xidian/job/campus is up. Resuming normal monitoring."
        break
      else
        ((count++))
        if [ "$count" -eq 10 ]; then
          echo "Website A-xidian/job/campus has been down for 10 consecutive checks. Restarting RSSHub."
          tmux send-keys -t RSSHub:0 C-c
          sleep 1
          tmux send-keys -t RSSHub:0 "npm start" C-m
          sleep 60
          count=0
        else
          echo "Website A-xidian/job/campus is still down. Monitoring again in 1 minute."
          sleep 60
        fi
      fi
    done
  fi
done
