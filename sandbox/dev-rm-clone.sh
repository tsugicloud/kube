#! /bin/bash

echo Deleting deployments...
kubectl delete deployment dev1
kubectl delete deployment dev2
kubectl delete deployment dev3
kubectl delete deployment dev4
kubectl delete deployment dev5

echo Deleting services...
kubectl delete service dev1
kubectl delete service dev2
kubectl delete service dev3
kubectl delete service dev4
kubectl delete service dev5
