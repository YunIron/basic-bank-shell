data(){
    if [ -e data.sh ]
    then
        source data.sh
    else
        touch data.sh
        chmod 777 data.sh
        echo "KAYIT"
        read -p "Kullanici adiniz: " newname
        read -p "Sifreniz: " newpw
        read -p "Bakiyeniz: " newbakiye
        echo -e "kullanici='$newname'\nparalo='$newpw'\nbakiye=$newbakiye" > data.sh
        source data.sh
    fi
}


main(){
    while true
    do
        source data.sh
        clear
        printwelcome $kullanici
        echo -e "1 -| Bakiye\n2 -| Para yatir\n3 -| Para cek\n4 -| Oturum kapat\n5 -| Cikis yap\n" 
        read secenek
        if [ $secenek -eq "1" ]
        then
            clear
            bakiye
            sleep 5 &
            wait
        elif [ $secenek -eq "2" ]
        then
            clear
            parayatir
            sleep 5 &
            wait
        elif [ $secenek -eq "3" ]
        then
            clear
            paracek
            sleep 5 &
            wait
        elif [ $secenek -eq "4" ]
        then
            clear
            echo "Oturum kapatiliyor..."
            sleep 3 &
            wait
            giris
        elif [ $secenek -eq "5" ]
        then
            clear
            echo "Cikis yapiliyor..."
            sleep 3 &
            wait
            exit
        else
            clear
            echo "Hatali tuslama yaptiniz."
            sleep 3 &
            wait
        fi
    done
}

bakiye(){
    echo "Bakiyeniz: $bakiye"
}

parayatir(){
    echo -e "Tutar: \c"
    read tutar
    yenibakiye=$(( bakiye+tutar ))

    sed -i 's/'$bakiye'/'$yenibakiye'/g' data.sh
    echo "Isleminiz basariyla tamamlandi. Yeni tutariniz: $yenibakiye"
}

paracek(){
    echo -e "Tutar: \c"
    read tutar
    if [[ $bakiye -gt $tutar ]]
    then
        yenibakiye=$(( bakiye-tutar ))
        sed -i "s/$bakiye/$yenibakiye/g" data.sh
        echo "Isleminiz basariyla tamamlandi. Yeni tutariniz: $yenibakiye"
    else
        echo "Bakiyeniz yeterli degil."
    fi
}



printwelcome(){
    COLUMNS=$(tput cols) 
    title="Hosgeldin ${@}" 
    printf "%*s\n" $(((${#title}+$COLUMNS)/2)) "$title"
}

giris(){
    clear
    echo "GIRIS YAP"
    read -p "Kullanici isminiz: " isim
    read -sp "Sifreniz: " pw
    if [ $isim == $kullanici ] && [ "$pw" == "$paralo" ]
    then
        main
    else
        clear
        echo "Kullanici adiniz veya sifreniz yanlis."
        sleep 3 &
        wait
        giris
    fi
}

data
clear
giris



