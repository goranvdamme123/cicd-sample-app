#!/bin/bash
set -euo pipefail

mkdir -p tempdir
mkdir -p tempdir/templates
mkdir -p tempdir/static

cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

cat > tempdir/Dockerfile << _EOF_
FROM python
RUN pip install flask
COPY  ./static /home/myapp/static/
COPY  ./templates /home/myapp/templates/
COPY  sample_app.py /home/myapp/
EXPOSE 5050
CMD python /home/myapp/sample_app.py
_EOF_

if [[ "$(docker ps -a | grep samplerunning)" ]]; then
  echo "de docker container bestaat al, skip de install en gebruik de oude."
else
  cd tempdir || exit
  docker build -t sampleapp .
  docker run -t -d -p 5050:5050 --name samplerunning sampleapp
fi

docker ps -a
