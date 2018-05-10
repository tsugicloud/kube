#! /bin/bash

if [ -z "$1" ] ; then
    echo "Numeric parameter required"
    exit
fi;

if [[ "$1" -ge 1 && "$1" -le 9 ]] ; then
   echo Creating $1
else
   echo "Please give a number from 1-9"
   exit
fi

echo Making deployment dev${1} 
cat <<EOF | tee /tmp/deploy | kubectl apply -f -
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: dev${1}
  labels:
    app: dev${1}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: dev${1}
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: dev${1}
    spec:
      containers:
      - name: dev
        image: us.gcr.io/sandbox-199519/tsugi_dev:latest
        env:
        - name: TSUGI_APPHOME
          value: "https://dev${1}.tsugicloud.org"
        - name: TSUGI_WWWROOT
          value: "https://dev${1}.tsugicloud.org/tsugi"
        - name: TSUGI_SERVICENAME
          value: "DEV-${1}"
        ports:
        - containerPort: 80

EOF

echo Making service dev${1} 
cat <<EOF | tee /tmp/service | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: dev${1}
  annotations:
    cloud.google.com/load-balancer-type: "Internal"
  labels:
    app: dev${1}
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
  selector:
    app: dev${1}
EOF

