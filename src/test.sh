xxd -p -c4 prog_20k.bin | while read w; do
    echo ${w:0:2} | tr '[:lower:]' '[:upper:]' >> mem_init0.ini
    echo ${w:2:2} | tr '[:lower:]' '[:upper:]' >> mem_init1.ini
    echo ${w:4:2} | tr '[:lower:]' '[:upper:]' >> mem_init2.ini
    echo ${w:6:2} | tr '[:lower:]' '[:upper:]' >> mem_init3.ini
done

