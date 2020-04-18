for x in $*
do
sed -e "s/#ff6600/#ff4d0d/g" $x > temp$x
mv temp$x $x
done
