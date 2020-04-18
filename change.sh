for x in $*
do
sed -e "s/[OLD_COLOR]/[NEW_COLOR]/g" $x > temp$x
mv temp$x $x
done
