for f in `find . -name '*.png'`;
do
	echo $f
  	sips -s format png $f --out $f
	
done