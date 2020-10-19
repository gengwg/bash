# split the large directory into 10 smaller subdirectories
# containing around 1/10 of original files each.

mkdir {1..10}
cd photos/
x=("../1" "../2" "../3" "../4" "../5" "../6" "../7" "../8" "../9" "../10")
c=0
for f in *
do
    mv "$f" "${x[c]}"
    c=$(( (c+1)%10 ))
done

