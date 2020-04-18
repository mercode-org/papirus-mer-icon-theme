for x in $*
do
sed -e "s/#000000/#842609/g" $x > temp$x
mv temp$x $x
done