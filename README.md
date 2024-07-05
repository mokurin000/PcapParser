# PcapParser

Extract urls from pcap

Targetting baoyuzb

Note: You may use VLC to save a mp4 from stream

## Install

```bash
pipx install PcapParser
```

## Run

### To use tk file picker

```bash
pcap-parser
```

### To use in CLI

```bash
pcap-parser ./xxxx.pcap
```

### Other Utils

#### Check new live automatically

```bash
while true
do
    ./record.sh
    sleep 10
done
```

It will override `urls.txt` in current workdir
