
https://cloud.google.com/kubernetes-engine/docs/quickstart

gcloud config list

gcloud projects list

gcloud config set project nd-edu

gcloud container clusters create nd-edu

gcloud container clusters list

kubectl get services

    NAME         TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
    kubernetes   ClusterIP   10.11.240.1   <none>        443/TCP   6m


https://github.com/kubernetes/kubernetes/issues/44377

https://github.com/mappedinn/kubernetes-nfs-volume-on-gke

gcloud compute disks create --size=10GB --type=pd-ssd gce-nfs-disk

$ gcloud compute disks create --size=10GB --type=pd-ssd gce-nfs-disk

    Created [https://www.googleapis.com/compute/v1/projects/nd-edu/zones/us-central1-a/disks/gce-nfs-disk].
    NAME          ZONE           SIZE_GB  TYPE    STATUS
    gce-nfs-disk  us-central1-a  10       pd-ssd  READY
    
    New disks are unformatted. You must format and mount a disk before it
    can be used. You can find instructions on how to do this at:
    
    https://cloud.google.com/compute/docs/disks/add-persistent-disk#formatting

Note - the format happens automatically for some reason in GCE :)

$ gcloud compute disks list

    NAME                                   ZONE           SIZE_GB  TYPE         STATUS
    gce-nfs-disk                           us-central1-a  10       pd-ssd       READY
    gke-nd-edu-default-pool-12578ca5-l8qt  us-central1-a  100      pd-standard  READY
    gke-nd-edu-default-pool-12578ca5-wstl  us-central1-a  100      pd-standard  READY

kubectl create -f 01-dep-nfs.yml 
kubectl describe deployment nfs-server
kubectl get pods

kubectl create -f 02-srv-nfs.yml 
kubectl create -f 03-pv-and-pvc-nfs.yml
kubectl create -f 04-dep-busybox.yml

kubectl exec -it nfs-busybox-7478d74df7-mlzxb -- busybox sh

kubectl exec -it nfs-server-7b6894fc6f-vjbmw -- /bin/bash

kubectl run my-shell --rm -i --tty --image ubuntu -- bash


    docker tag tsugi_dev:latest us.gcr.io/nd-edu/tsugi_dev:latest
    gcloud docker -- push us.gcr.io/nd-edu/tsugi_dev:latest

Enable the Google Cloud SQL API

https://cloud.google.com/sql/docs/mysql/connect-kubernetes-engine

gcloud sql tiers list
gcloud sql instances create tsugi-sql3 -gce-zone=us-central1-a

    Creating Cloud SQL instance...done.                                                                                                           
    Created [https://www.googleapis.com/sql/v1beta4/projects/nd-edu/instances/tsugi-sql3].
    NAME        DATABASE_VERSION  LOCATION       TIER              ADDRESS        STATUS
    tsugi-sql3  MYSQL_5_6         us-central1-a  db-n1-standard-2  35.193.11.230  RUNNABLE

Note the automatically assigned IP address.  If you are not using the Cloud SQL Proxy,
you will use this address as the host address that your applications or tools use
to connect to the instance.

Note - tsugi-sql cannot be re-created for several months :)

gcloud sql instances create tsugi-sql --gce-zone=us-central1-a

gcloud sql users set-password root % --instance tsugi-sql3 --password secret

Connect using Cloud Shell from the instance details in the console

Enable backups and binary logging

Enable high availability and failover

