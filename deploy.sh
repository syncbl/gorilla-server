git add .
if [ $# -eq 0 ]
  then git commit -v -m "Deploy"
  else git commit -v -m "$1"
fi
git push origin master
