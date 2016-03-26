#!/usr/local/opt/gnu-sed/libexec/gnubin/sed -rf 

s@\%NVA-@\%PDF-@g 

s@>>strnva$@>>stream@g 
s@^endstrnva$@endstream@g 
s@^endova$@endobj@g 
s@\ 0\ ova$@\ 0\ obj@g 

s@^snvanvaav$@startxref@g 
s@^xnva$@xref@g 
s@^tavnvna$@trailer@g 

s@/Avna@/Auto@g 
s@/BavvNNNVVVAAAVNN@/BitsPerComponent@g 
s@/Bhkfkmnokmll@/BaseEncoding@g 
s@/Bnvanvat@/BaseFont@g 
s@/BVVVAAANNNVVN@/BitsPerSample@g 
s@/Ckmlaplmxv@/ColorSpace@g 
s@/Cvvaannv@/Contents@g 
s@/Danvdknnnav@/Differences@g 
s@/Dvvaaa@/Decode@g 
s@/Evannvav@/Encoding@g 
s@/Evvvvv@/Encode@g 
s@/Fadnn@/Flags@g 
s@/Favvaa@/Filter@g 
s@/Fbjhklmhh@/FirstChar@g 
s@/Fchkkmlwlkplas@/FontDescriptor@g 
s@/Hellll@/Height@g 
s@/IAAVVV@/Intent@g 
s@/Inpu@/Info@g 
s@/Lavaaa@/Length@g 
s@/Lshskmnl@/LastChar@g 
s@/Nnna@/Name@g 
s@/Raavvvnnn@/Resources@g 
s@/Skkk@/Size@g 
s@/Snavvav@/Subtype@g 
s@/Tjklnvaqn@/ToUnicode@g 
s@/Watch@/Width@g 
s@/Watchs@/Widths@g 
s@/Xaaavvv@/XObject@g
