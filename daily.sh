#


tic=$(date +%s)
date=$(date)
stamp=$(date +"%Y_%m_%d")
gitid=$(git rev-parse --short HEAD)
repo='https://github.com/Advancement-of-Civilization-Effort/NOCC'

#ipfs key gen -t rsa -s 3072 schumann
# QmYHfWp8NjSJ9gBEiDotXFvhbospMv8FLSwmAKGe5RnT9q
# QmQE42Qy1VD9AE6eYc2skE5xujsgJ3edbG2AiC1Y3eFDHv
key=$(ipfs key list -l | grep -w schumann | cut -d' ' -f1)

nocc='https://nocc.heartmath.org/spectrogram/gci003'
spgrm=$(curl https://nocc.heartmath.org/spectrogram/gci003/ | grep \.jpg | tail -7 | sed -e 's,.*="\([^"]*\.jpg\)".*,![IMG]('$nocc'/\1),')
cat > sch-reso.md <<EOF
<!DOCTYPE html><meta charset="utf8"/>

## Status of our planet (Schumann Resonances)

\$Date: $date \$<br>
\$GITid: $gitid \$ (previous)<br>

SPGRM:<br>
$spgrm<br>
![SPGRM ${stamp}](https://nocc.heartmath.org/spectrogram/gci003/SPGRM_${stamp}_ch2.jpg)<br>

![SRF](http://sosrff.tsu.ru/new/srf.jpg)<br>
![SRA](http://sosrff.tsu.ru/new/sra.jpg)<br>
![UMF](http://sosrff.tsu.ru/new/umf.jpg)<br>
![WSP](http://sosrff.tsu.ru/new/wsp.jpg)<br>

![meteo](http://sosrff.tsu.ru/new/meteo_en.jpg)<br>
![PRS](http://sosrff.tsu.ru/new/prs.jpg)<br>

![HMO](http://sosrff.tsu.ru/new/hmo.jpg)<br>
![ION](http://sosrff.tsu.ru/new/ion.jpg)<br>
![IPF](http://sosrff.tsu.ru/new/ipf.jpg)<br>
![IPFBS](http://sosrff.tsu.ru/new/ipfbs.jpg)<br>
![IPH](http://sosrff.tsu.ru/new/iph.jpg)<br>

--&nbsp;<br>
this file: [schumann-reson.html](schumann-reson.html) (previous: [$gitid]($repo/blob/$gitid/schumann-reson.html))
(is also on IPNS: [$key](https://gateway.ipfs.io/ipns/$key))

EOF
pandoc -t html -f markdown -o sch-reso.htm sch-reso.md
#wget -P today -l 1 -r -np -N -nH -nd -E -H -k -K -p -e robots=off -F -i sch-reso.htm
exclude="--exclude-domains https://github.com"
wget -P today -np -N -nH -nd -E -H -k -K -p -e robots=off -F -i sch-reso.htm

sed -e 's,https?:.*/\([^/]*\.jpg\),today/\1,' sch-reso.md > schumann-reson.md
pandoc -t html -f markdown -o schumann-reson.html schumann-reson.md
echo $tic: $gitid >> gittrail.yml
sed -i -e "s/^prev: .*/prev: $gitid/" README.md
qm=$(ipfs add -Q -w -r schumann-reson.* today daily.sh gittrail.yml README.md)
ipfs name publish --allow-offline --key=schumann /ipfs/$qm 1>/dev/null &
echo $tic: $qm >> schumann-reson.yml
echo url: https://ipfs.2read.net/ipfs/$qm
ipfs files rm -r /my/etc/nocc 2>/dev/null
ipfs files cp /ipfs/$qm /my/etc/nocc
echo url: https://gateway.ipfs.io/ipns/$key
git commit -a -m "schumann resonance for $date"
git push
