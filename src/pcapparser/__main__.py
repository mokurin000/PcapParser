import re
from tkinter.filedialog import askopenfilename

import dpkt

pcap_file = askopenfilename(defaultextension="pcap", filetypes=[("Pcap", ".pcap")])

urls = {}

with open(pcap_file, "rb") as f:
    pcap = dpkt.pcap.Reader(f)
    rtmp_url_re = b"rtmp://.*/live"
    token_re = rb"\d+\?token=[\w\d]+&t=\d+"

    base = None
    for t, buf in pcap:
        if b"rtmp://" in buf:
            r = re.search(rtmp_url_re, buf)
            base = f"{r.group().decode("ascii")}"
        if b"FCSubscribe" in buf:
            r = re.search(token_re, buf)
            if r is not None and base is not None:
                auth = r.group().decode("ascii")
                url = f"{base}/{auth}"
                room, _ = auth.split("?")
                urls[room] = url
                base = None

result = "\n".join(urls.values())
with open("urls.txt", "w", encoding="utf-8") as f:
    f.write(result)
